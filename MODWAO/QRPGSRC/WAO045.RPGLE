     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Auswahlformat Update Ertrag in TVAE
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: VU 08.06.2012 Projekt 8385
     H*  -----------------------------------------------------------------------
/*  ÄH*  Änderung: SZ 03.07.2012 Vorbelegung Kz. Währungsumrechnung
     H*
     F**************************************************************************
     F*
     F*  Über dieses Programm wird eine Vorauswahl zum Update Ertrag in TVAE
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO045FM  CF   E             WORKSTN USROPN
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
     D***  DATEIEN                                                           ***
     D**************************************************************************
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
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
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
     D                 DS                  INZ
     D  WKDATE                        8  0
     D   WKJHJJ                       4  0 OVERLAY(WKDATE:1)
     D   WKMONA                       2  0 OVERLAY(WKDATE:5)
     D   WKTAG                        2  0 OVERLAY(WKDATE:7)
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
     C                   OPEN      WAO045FM                             98
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
     C                   CLOSE     WAO045FM                             98
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
     C                   MOVEL(P)  'WAO045'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO045FM'    EXFLPOFMTN
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
     C                   WRITE     WAO045W1
     C                   WRITE     WAO04501
     C                   WRITE     W1O045B1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO04501                             9899
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
     C                   EXSR      UPDKOM
     C*
     C                   CALL      'WAO045SB'
     C                   PARM                    EXTR02
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   CLEAR                   EXDATE
     C                   MOVE      WKTDAT        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSREDAAB
     C*-------------------------------------------------------------------------
     C                   IF        DSERTG      = *BLANK
     C                   EVAL      DSERTG      = DANEKZ
     C                   ENDIF
     C                   IF        DSNTSK      = *BLANK
     C                   EVAL      DSNTSK      = DANEKZ
     C                   ENDIF
     C                   IF        DSWAEHUM    = *BLANK
     C                   EVAL      DSWAEHUM    = DAJNKZ
     C                   ENDIF
     C*
     C                   EXSR      PRERTG
     C                   EXSR      PRNTSK
     C                   EXSR      PRWAEHUM
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C     DSREDAAB      IFEQ      *ZERO
     C                   MOVEL(P)  'DSREDAAB  '  EXFLPOFLDN
     C                   ELSE
     C                   MOVEL(P)  'DSREDABI  '  EXFLPOFLDN
     C                   ENDIF
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
     C                   EXSR      PRREDAAB
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRREDABI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRWAEHUM
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
     C                   MOVEL(P)  'DSREDAAB  '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSREDAAB  '
     C                   EXSR      MCREDAAB
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSREDABI  '
     C                   EXSR      MCREDABI
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSERTG    '
     C                   EXSR      MCTRPCERTG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSNTSK    '
     C                   EXSR      MCTRPCNTSK
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAEHUM  '
     C                   EXSR      MCWAEHUM
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KALENDER                                                 ***
     C**************************************************************************
     C     MCREDAAB      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDAAB      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSREDAAB      IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSREDAAB
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN RE-DATUM AB                                                ***
     C**************************************************************************
     C     PRREDAAB      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSREDAAB  '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDAAB      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSREDAAB
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDAAB      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKREDAAB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KALENDER                                                 ***
     C**************************************************************************
     C     MCREDABI      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDABI      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSREDABI      IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSREDABI
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN RE-DATUM BIS                                               ***
     C**************************************************************************
     C     PRREDABI      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSREDABI  '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDABI      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSREDABI
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSREDABI      EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKREDABI
     C*
     C     WKREDAAB      IFGT      WKREDABI
     C                   MOVE      '9504'        WKFENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE JN_KZ ERTG                                             ***
     C**************************************************************************
     C     MCTRPCERTG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSERTG  '    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSERTG        EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSERTG
     C                   MOVEL(P)  EXTRPCTEXT    TXERTG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE Ertrag-KZ                                              ***
     C**************************************************************************
     C     PRERTG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSERTG  '    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSERTG        EXTRPCCODE                     JNKZ
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXERTG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE Netto              KZ                                  ***
     C**************************************************************************
     C     MCTRPCNTSK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSNTSK  '    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSNTSK        EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSNTSK
     C                   MOVEL(P)  EXTRPCTEXT    TXNTSK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE Netto               KZ                                 ***
     C**************************************************************************
     C     PRNTSK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSNTSK  '    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSNTSK        EXTRPCCODE                     JNKZ
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXNTSK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE WÄHRUNGSUMRECHNUNG KZ                                  ***
     C**************************************************************************
     C     MCWAEHUM      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSWAEHUM'    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  DSWAEHUM      EXTRPCCODE
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  '5'           EXTRPCPGST
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSWAEHUM
     C                   MOVEL(P)  EXTRPCTEXT    TXWAEHUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE WAEHRUNGSUMRECHNUNG KZ                                 ***
     C**************************************************************************
     C     PRWAEHUM      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSWAEHUM'    EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAEHUM      EXTRPCCODE                     JNKZ
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXWAEHUM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE KOM-BEREICH                                                ***
     C**************************************************************************
     C     UPDKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     WKREDAAB      DUN080
     C                   MOVEA     DUC008        KOM(01)
     C                   Z-ADD     WKREDABI      DUN080
     C                   MOVEA     DUC008        KOM(09)
     C                   MOVEA     DSWAEHUM      KOM(17)
     C                   MOVEA     DSERTG        KOM(18)
     C                   MOVEA     DSNTSK        KOM(19)
     C                   MOVEA     KOM           #CKOMM
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
     C     *LIKE         DEFINE    DSREDAAB      WKREDAAB
     C     *LIKE         DEFINE    DSREDABI      WKREDABI
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
     C                   MOVEL(P)  'WAO045'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTO045W1
     C                   OTHER
     C                   WRITE     WAO045CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTO045W1
     C                   OTHER
     C                   WRITE     WAO045CT
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
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
