     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Auswahlformat Druck Picklisten
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 08.07.2010 Projekt 6231
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 17.09.2010 Info-Meldung- Tel. mit Herrn Meier
     H*  Änderung: ZG 10.12.2010 Projket 6990  Umstellung Versand
     H*  Änderung: PH 14.12.2010 Projekt 6990. Selektion nach Kunden-Gruppe
     H*  Änderung: ZG 10.05.2011 Projket 7238 Beistellung
     H*  Änderung: ZG 20.08.2012 Projket 8700 Erweiterung des Formates WAO01201
     H*            um 3 zusätzliche Felder für die Eingabe der Versandbedingungen.
     H*  Änderung: ZG 30.04.2014 Projket 10278 Erweiterung des Formates WAO01202
     H*            um 4 zusätzliche Felder für die Eingabe der Komm-Nr.
     F**************************************************************************
     F*
     F*  Über dieses Programm wird eine Vorauswahl zum Druck der Liste getroffen
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO012FM  CF   E             WORKSTN USROPN
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
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
     D*
     D LBPB          E DS                  INZ
     D KYLBPB        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D KYTRPC        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D*
     D EXTRPC        E DS                  INZ
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
     C                   PARM                    EXTREND
     C*
     C                   EXSR      UEBTREND
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
     C*--------------------------------------------------------
     C                   SELECT
     C     DSLBAKDANA    WHENEQ    'BBKM'
     C                   MOVE      '02'          WKIFMT
     C     DSLBAKDANA    WHENEQ    'SKOM'
     C                   MOVE      '03'          WKIFMT
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      WAO012FM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     WAO012FM                             98
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
     C                   MOVEL(P)  DAFIRM        KYBBKMFIRM                     BBKM
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYLDFI                         LBSD
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYLBPBFIRM                     LBPB
     C                   MOVEL(P)  DAFIRM        KYLLFI                         LBPL
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYVBFI                         VSBD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'WAO012'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO012FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXTREND                                                ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSLBAKDANA
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSLBAKSTAT
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
     C                   MOVE      '0'           WKINFO            1            INFO-MELDUNG
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
     C                   WRITE     WAO012W3
     C                   WRITE     WAO01201
     C                   WRITE     W3W012B1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO01201                             9899
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
     C                   MOVE      '0'           WKINFO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKINFO        IFLT      '2'                                          INFO-MELDUNG
     C                   EXSR      B01AE                                        SCHICKEN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         DSBBKMKMJ1
     C                   MOVE      *ZERO         DSBBKMKMJ2
     C                   MOVE      *ZERO         DSBBKMKMJ3
     C                   MOVE      *ZERO         DSBBKMKMJ4
     C                   MOVE      *BLANK        DSBBKMKMN1
     C                   MOVE      *BLANK        DSBBKMKMN2
     C                   MOVE      *BLANK        DSBBKMKMN3
     C                   MOVE      *BLANK        DSBBKMKMN4
     C                   MOVE      *BLANK        DSLBAKLGBE
     C                   EXSR      UPDTREND
     C*
     C                   CALL      'WAO013SB'
     C                   PARM                    EXTREND
     C*
     C                   MOVE      '0'           WKINFO
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
     C                   MOVEL(P)  DSLBAKDANA    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'DANALBAK'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBAKDANA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBAKSTAT    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATLBAK'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBAKSTAT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXLBAKKDGR
     C                   MOVE      *BLANK        TXLBAKAFAT
     C                   MOVE      *BLANK        TXLBAKPOLD
     C                   MOVE      *BLANK        TXLBAKLANR
     C                   MOVE      *BLANK        TXLBAKVSBD
     C                   MOVE      *BLANK        TXLBAKVSB2
     C                   MOVE      *BLANK        TXLBAKVSB3
     C                   MOVE      *BLANK        TXLBAKVSB4
     C                   MOVE      *BLANK        TXLBAKVBGR
     C                   MOVE      *BLANK        TXLBAKLGBE
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
     C                   Z-ADD     RTDATEDATE    DSLBAKLFTE
     C                   Z-ADD     RTDATEDATE    DSLBAKKMTE
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  'DSLBAKKDNR'  EXFLPOFLDN
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
     C                   EXSR      PRLBAKKDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKKDGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKAFAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSBD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB2
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB3
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB4
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVBGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKPOLD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLFTE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKKMTE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLANR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLPBE
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
     C***  ÄNDERUNGEN IM FORMAT                                              ***
     C**************************************************************************
     C     B01AE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C                   MOVEL(P)  'DSLBAKVSBD'  EXFLPOFLDN                     FELD AUFTRAGSNR.
     C*-------------------------------------------------------------------------
     C     DSLBAKVSBD    IFEQ      *BLANK
     C     DSLBAKVSB2    ANDEQ     *BLANK
     C     DSLBAKVSB3    ANDEQ     *BLANK
     C     DSLBAKVSB4    ANDEQ     *BLANK
     C     DSLBAKKDNR    ANDEQ     *BLANK
     C     DSLBAKKDGR    ANDEQ     *BLANK
     C     DSLBAKAFAT    ANDEQ     *BLANK
     C     DSLBAKPOLD    ANDEQ     *BLANK
     C     DSLBAKLANR    ANDEQ     *BLANK
     C     DSLBAKLPBE    ANDEQ     *BLANK
     C     DSLBAKVBGR    ANDEQ     *BLANK
     C*
     C                   SELECT
     C     WKINFO        WHENEQ    '0'                                          1. HINWEIS
     C                   MOVEL     '0110'        WKFENR
     C                   MOVEL     '1'           WKINFO
     C     WKINFO        WHENEQ    '1'                                          2. HINWEIS
     C                   MOVEL     '0144'        WKFENR
     C                   MOVEL     '2'           WKINFO                         HINWEIS 1 NICHT
     C                   ENDSL                                                  BEACHTET
     C*
     C                   ENDIF
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
     C                   EXSR      EFLPO
     C                   WRITE     WAO012W2
     C                   WRITE     WAO01202
     C                   WRITE     W2W012B1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO01202                             9899
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
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '0'           WKINFO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKINFO        IFLT      '2'                                          INFO-MELDUNG
     C                   EXSR      B02AE                                        SCHICKEN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     DSBBKMLFNR    DSLBAKKDNR
     C                   Z-ADD     DSBBKMKMTE    DSLBAKKMTE
     C                   MOVE      *ZERO         DSLBAKLFTE
     C                   MOVE      *BLANK        DSLBAKAFAT
     C                   MOVE      DSLBAKVSBD    DSLBAKVSBD
     C                   MOVE      *BLANK        DSLBAKPOLD
     C                   MOVE      *BLANK        DSLBAKKDGR
     C                   MOVE      *BLANK        DSLBAKLANR
     C                   MOVE      *BLANK        DSLBAKLPBE
     C                   MOVE      *BLANK        DSLBAKVSB2
     C                   MOVE      *BLANK        DSLBAKVSB3
     C                   MOVE      *BLANK        DSLBAKVSB4
     C                   MOVE      *BLANK        DSLBAKVBGR
     C                   MOVE      *BLANK        DSLBAKLGBE
     C                   EXSR      UPDTREND
     C*
     C                   CALL      'WAO013SB'
     C                   PARM                    EXTREND
     C*
     C                   MOVE      '0'           WKINFO
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
     C***  FÜLLEN BILDSCHIRMFORMAT 02                                        ***
     C**************************************************************************
     C     B02DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBAKDANA    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'DANALBRS'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBAKDANA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBAKSTAT    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATBBUP'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBBKMSTAT
     C*-------------------------------------------------------------------------
     C                   MOVE      *YEAR         DSBBKMKMJ1
     C                   MOVE      *YEAR         DSBBKMKMJ2
     C                   MOVE      *YEAR         DSBBKMKMJ3
     C                   MOVE      *YEAR         DSBBKMKMJ4
     C*
     C                   MOVE      *BLANK        DSBBKMKMN1
     C                   MOVE      *BLANK        DSBBKMKMN2
     C                   MOVE      *BLANK        DSBBKMKMN3
     C                   MOVE      *BLANK        DSBBKMKMN4
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
     C                   Z-ADD     RTDATEDATE    DSBBKMKMTE
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  'DSLBAKLFNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD02                                          ***
     C**************************************************************************
     C     B02PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMLFNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSBD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMKMTE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMKMN1
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMKMN2
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMKMN3
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKMKMN4
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
     C***  ÄNDERUNGEN IM FORMAT                                              ***
     C**************************************************************************
     C     B02AE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
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
     C                   EXSR      EFLPO
     C                   WRITE     WAO012W3
     C                   WRITE     WAO01203
     C                   WRITE     W3W012B1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO01203                             9899
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
     C                   EXSR      B03PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '0'           WKINFO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKINFO        IFLT      '2'                                          INFO-MELDUNG
     C                   EXSR      B01AE                                        SCHICKEN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         DSBBKMKMJ1
     C                   MOVE      *ZERO         DSBBKMKMJ2
     C                   MOVE      *ZERO         DSBBKMKMJ3
     C                   MOVE      *ZERO         DSBBKMKMJ4
     C                   MOVE      *BLANK        DSBBKMKMN1
     C                   MOVE      *BLANK        DSBBKMKMN2
     C                   MOVE      *BLANK        DSBBKMKMN3
     C                   MOVE      *BLANK        DSBBKMKMN4
     C                   MOVE      *BLANK        DSLBAKVBGR
     C                   MOVE      *BLANK        DSLBAKLANR
     C                   MOVE      *BLANK        DSLBAKLPBE
     C                   EXSR      UPDTREND
     C*
     C                   CALL      'WAO013SB'
     C                   PARM                    EXTREND
     C*
     C                   MOVE      '0'           WKINFO
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
     C***  FÜLLEN BILDSCHIRMFORMAT 03                                        ***
     C**************************************************************************
     C     B03DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBAKDANA    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'DANALBAK'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBAKDANA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBAKSTAT    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATLBAK'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBAKSTAT
     C*-------------------------------------------------------------------------
     C     DSLBAKLGBE    IFEQ      *BLANK
     C                   MOVEL     WKTRPALGBE    DSLBAKLGBE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXLBAKKDGR
     C                   MOVE      *BLANK        TXLBAKAFAT
     C                   MOVE      *BLANK        TXLBAKPOLD
     C                   MOVE      *BLANK        TXLBAKLANR
     C                   MOVE      *BLANK        TXLBAKVSBD
     C                   MOVE      *BLANK        TXLBAKVSB2
     C                   MOVE      *BLANK        TXLBAKVSB3
     C                   MOVE      *BLANK        TXLBAKVSB4
     C                   MOVE      *BLANK        TXLBAKVBGR
     C                   MOVE      *BLANK        TXLBAKLGBE
     C*
     C     DSLBAKLGBE    CASNE     *BLANK        PRLBAKLGBE
     C                   ENDCS
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
     C                   Z-ADD     RTDATEDATE    DSLBAKLFTE
     C                   Z-ADD     RTDATEDATE    DSLBAKKMTE
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  'DSLBAKKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD03                                          ***
     C**************************************************************************
     C     B03PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKKDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKKDGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKAFAT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVBGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSBD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB2
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB3
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKVSB4
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKPOLD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLFTE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKKMTE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLANR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBAKLGBE
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
     C***  ÄNDERUNGEN IM FORMAT                                              ***
     C**************************************************************************
     C     B03AE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C                   MOVEL(P)  'DSLBAKVSBD'  EXFLPOFLDN                     FELD AUFTRAGSNR.
     C*-------------------------------------------------------------------------
     C     DSLBAKVSBD    IFEQ      *BLANK
     C     DSLBAKVSB2    ANDEQ     *BLANK
     C     DSLBAKVSB3    ANDEQ     *BLANK
     C     DSLBAKVSB4    ANDEQ     *BLANK
     C     DSLBAKKDNR    ANDEQ     *BLANK
     C     DSLBAKKDGR    ANDEQ     *BLANK
     C     DSLBAKAFAT    ANDEQ     *BLANK
     C     DSLBAKPOLD    ANDEQ     *BLANK
     C     DSLBAKLANR    ANDEQ     *BLANK
     C     DSLBAKLPBE    ANDEQ     *BLANK
     C     DSLBAKLGBE    ANDEQ     *BLANK
     C*
     C                   SELECT
     C     WKINFO        WHENEQ    '0'                                          1. HINWEIS
     C                   MOVEL     '0110'        WKFENR
     C                   MOVEL     '1'           WKINFO
     C     WKINFO        WHENEQ    '1'                                          2. HINWEIS
     C                   MOVEL     '0144'        WKFENR
     C                   MOVEL     '2'           WKINFO                         HINWEIS 1 NICHT
     C                   ENDSL                                                  BEACHTET
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     MCBBKMKMTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSBBKMKMTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSLBAKKMTE    IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSBBKMKMTE
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     PRBBKMKMTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMKMTE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSBBKMKMTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSBBKMKMTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LFNR                                                   ***
     C**************************************************************************
     C     MCBBKMLFNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBBKMLFNR'  EXFLPOFLDN
     C*----------------------------------------------------
     C                   MOVEA(P)  DSBBKMLFNR    KOM(01)
     C                   MOVE      '0005'        #CUEBE
     C                   MOVEL(P)  *BLANK        #CPGST
     C                   EXSR      MCLIEF
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL     LFLFNR        DSLBAKKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRBBKMLFNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMLFNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSBBKMLFNR <> *BLANK
     C                   MOVEL(P)  DSBBKMLFNR    KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   ENDIF
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
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSLBAKKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBAKKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKKDNR'
     C                   EXSR      MCLBAKKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKKDGR'
     C                   EXSR      MCLBAKKDGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKAFAT'
     C                   EXSR      MCLBAKAFAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKVSBD'
     C                   EXSR      MCLBAKVSBD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKVSB2'
     C                   EXSR      MCLBAKVSB2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKVSB3'
     C                   EXSR      MCLBAKVSB3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKVSB4'
     C                   EXSR      MCLBAKVSB4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKPOLD'
     C                   EXSR      MCLBAKPOLD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKLFTE'
     C                   EXSR      MCLBAKLFTE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKKMTE'
     C                   EXSR      MCLBAKKMTE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKLANR'
     C                   EXSR      MCLBAKLANR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKLPBE'
     C                   EXSR      MCLBAKLPBE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMLFNR'
     C                   EXSR      MCBBKMLFNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMKMTE'
     C                   EXSR      MCBBKMKMTE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMKMN1'
     C                   EXSR      MCBBKMKMN1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMKMN2'
     C                   EXSR      MCBBKMKMN2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMKMN3'
     C                   EXSR      MCBBKMKMN3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBBKMKMN4'
     C                   EXSR      MCBBKMKMN4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKVBGR'
     C                   EXSR      MCLBAKVBGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBAKLGBE'
     C                   EXSR      MCLBAKLGBE
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LANR                                                   ***
     C**************************************************************************
     C     MCLBAKLANR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C     DSLBAKLANR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXLBAKLANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSLBAKLANR    KOM(01)
     C                   MOVE      'LBSD01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCLBSD
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  LDLANR        DSLBAKLANR
     C                   MOVEL(P)  LDLBZ1        TXLBAKLANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LANR                                                   ***
     C**************************************************************************
     C     PRLBAKLANR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKLANR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXLBAKLANR
     C*-------------------------------------------------------------------------
     C     DSLBAKLANR    IFNE      *BLANK
     C                   MOVE      DSLBAKLANR    KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C                   MOVEL(P)  TPTTXT        TXLBAKLANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE LPBE                                                   ***
     C**************************************************************************
     C     MCLBAKLPBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKLPBE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSLBAKLANR    KOM(01)
     C                   MOVEA     DSLBAKLPBE    KOM(04)
     C                   MOVE      '0010'        #CUEBE
     C                   MOVE      'LBPB01'      #CPGST
     C                   EXSR      MCLBPB
     C*
     C     WKTRTP        IFEQ      *OFF                                         FEHLER
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     LBPBLANR      DSLBAKLANR
     C                   MOVEL     LBPBLPBE      DSLBAKLPBE
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LPBE                                                   ***
     C**************************************************************************
     C     PRLBAKLPBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBAKLPBE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKLPBE    IFNE      *BLANK
     C                   MOVEL     DSLBAKLANR    KYLLLA
     C                   MOVEL     DSLBAKLPBE    KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C     LLLPBK        IFNE      DAJNKZ
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      '1379'        WKFENR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     MCLBAKKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKKDNR'  EXFLPOFLDN
     C*----------------------------------------------------
     C                   MOVEA(P)  DSLBAKKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVEL(P)  *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSLBAKKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRLBAKKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKKDNR <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKKDNR) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL(P)  DSLBAKKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE KUNDENGRUPPE                                              ***
     C**************************************************************************
     C     MCLBAKKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C     DSLBAKKDGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSLBAKKDGR    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSLBAKKDGR
     C                   MOVEL(P)  TPTTXT        TXLBAKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRKDGR        PRÜFEN KUNDENGRUPPE                                 ***
     C**************************************************************************
     C     PRLBAKKDGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKKDGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKKDGR
     C*-------------------------------------------------------------------------
     C     DSLBAKKDGR    IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSLBAKKDGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXLBAKKDGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     MCLBAKAFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKAFAT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKAFAT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKAFAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVE      'AFPA01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCAFPA
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVEL     AAAFAT        DSLBAKAFAT
     C                   MOVEL(P)  AAABEZ        TXLBAKAFAT
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE AFAT                                                   ***
     C**************************************************************************
     C     PRLBAKAFAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKAFAT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKAFAT
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKAFAT <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKAFAT) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL     DSLBAKAFAT    KYAAAT                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHAFPA
     C                   MOVEL(P)  AAABEZ        TXLBAKAFAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VSBD                                                   ***
     C**************************************************************************
     C     MCLBAKVSBD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKVSBD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKVSBD    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKVSBD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVE      DSLBAKVSBD    KOM(01)
     C                   MOVE      'VSBD01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCVSBD
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVEL(P)  VBVSBD        DSLBAKVSBD
     C                   MOVEL(P)  VBTEXT        TXLBAKVSBD
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VSBD                                                   ***
     C**************************************************************************
     C     PRLBAKVSBD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKVSBD'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKVSBD
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKVSBD <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKVSBD) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL(P)  DSLBAKVSBD    KYVBBD                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHVSBD
     C                   MOVEL(P)  VBTEXT        TXLBAKVSBD
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VSB2                                                   ***
     C**************************************************************************
     C     MCLBAKVSB2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKVSB2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKVSB2    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKVSB2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVE      DSLBAKVSB2    KOM(01)
     C                   MOVE      'VSBD01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCVSBD
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVEL(P)  VBVSBD        DSLBAKVSB2
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB2
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VSB2                                                   ***
     C**************************************************************************
     C     PRLBAKVSB2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKVSB2'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKVSB2
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKVSB2 <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKVSB2) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL(P)  DSLBAKVSB2    KYVBBD                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHVSBD
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB2
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VSB3                                                   ***
     C**************************************************************************
     C     MCLBAKVSB3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKVSB3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKVSB3    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKVSB3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVE      DSLBAKVSB3    KOM(01)
     C                   MOVE      'VSBD01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCVSBD
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVEL(P)  VBVSBD        DSLBAKVSB3
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB3
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VSB3                                                   ***
     C**************************************************************************
     C     PRLBAKVSB3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKVSB3'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKVSB3
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKVSB3 <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKVSB3) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL(P)  DSLBAKVSB3    KYVBBD                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHVSBD
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB3
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VSB4                                                   ***
     C**************************************************************************
     C     MCLBAKVSB4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKVSB4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKVSB4    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKVSB4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVE      DSLBAKVSB4    KOM(01)
     C                   MOVE      'VSBD01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCVSBD
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   MOVEL(P)  VBVSBD        DSLBAKVSB4
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB4
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VSB4                                                   ***
     C**************************************************************************
     C     PRLBAKVSB4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKVSB4'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKVSB4
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKVSB4 <> *BLANK
     C**ZG                         AND %SCAN(WCTRD:DSLBAKVSB4) = *ZERO          "*"-Funktion
     C*
     C                   MOVEL(P)  DSLBAKVSB4    KYVBBD                         PRÜFEN DER
     C                   MOVEA     '01C     '    CHI                            AUFTRAGSART
     C                   EXSR      CHVSBD
     C                   MOVEL(P)  VBTEXT        TXLBAKVSB4
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE NACH POSTALISCHES LAND                                    ***
     C**************************************************************************
     C     MCLBAKPOLD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKPOLD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBAKPOLD    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKPOLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     DSLBAKPOLD    KOM(01)
     C                   MOVEL     'LAND02'      #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCLAND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL     LNAMKZ        DSLBAKPOLD
     C                   MOVEL(P)  LNLBEZ        TXLBAKPOLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE POLD                                                   ***
     C**************************************************************************
     C     PRLBAKPOLD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKPOLD'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKPOLD
     C*-------------------------------------------------------------------------
     C                   IF        DSLBAKPOLD <> *BLANK
     C**                           AND %SCAN(WCTRD:DSLBAKPOLD) = *ZERO          "*"-Funktion
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSLBAKPOLD    KYLNKZ
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLAND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C     LNAMKZ        IFNE      KYLNKZ
     C                   MOVE      '0162'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA(P)  LNLDNR        KOM(01)
     C                   EXSR      PRLANDLAND
     C                   MOVEA(P)  KOM(8)        TXLBAKPOLD
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE EXTREND                                                    ***
     C**************************************************************************
     C     UPDTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  DSLBAKDANA    KOM(01)
     C                   MOVEA     KOM           EXTRNDKEYB
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  DSLBAKSTAT    KOM(01)
     C                   MOVEA(P)  DSLBAKKDNR    KOM(03)
     C                   MOVEA(P)  DSLBAKAFAT    KOM(13)
     C                   MOVEA(P)  DSLBAKVSBD    KOM(16)
     C                   MOVEA(P)  DSLBAKPOLD    KOM(19)
     C*
     C     DSLBAKLFTE    IFGT      *ZERO
     C                   CLEAR                   EXDATE
     C                   MOVE      DSLBAKLFTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DUN080
     C                   ELSE
     C                   Z-ADD     *ZERO         DUN080
     C                   ENDIF
     C                   MOVEA(P)  DUC008        KOM(22)
     C*
     C                   MOVEA(P)  DSLBAKLANR    KOM(30)
     C                   MOVEA(P)  DSLBAKLPBE    KOM(33)
     C*
     C     DSLBAKKMTE    IFGT      *ZERO
     C                   CLEAR                   EXDATE
     C                   MOVE      DSLBAKKMTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DUN080
     C                   ELSE
     C                   Z-ADD     *ZERO         DUN080
     C                   ENDIF
     C                   MOVEA(P)  DUC008        KOM(41)
     C*
     C                   MOVEA(P)  DSLBAKKDGR    KOM(49)
     C*
     C                   MOVEA(P)  DSLBAKVSB2    KOM(53)
     C                   MOVEA(P)  DSLBAKVSB3    KOM(56)
     C                   MOVEA(P)  DSLBAKVSB4    KOM(59)
     C*
     C                   Z-ADD     DSBBKMKMJ1    DUN040
     C                   MOVEA(P)  DUC004        KOM(62)
     C                   MOVEA     DSBBKMKMN1    KOM(66)
     C                   Z-ADD     DSBBKMKMJ2    DUN040
     C                   MOVEA(P)  DUC004        KOM(72)
     C                   MOVEA     DSBBKMKMN2    KOM(76)
     C                   Z-ADD     DSBBKMKMJ3    DUN040
     C                   MOVEA(P)  DUC004        KOM(82)
     C                   MOVEA     DSBBKMKMN3    KOM(86)
     C                   Z-ADD     DSBBKMKMJ4    DUN040
     C                   MOVEA(P)  DUC004        KOM(92)
     C                   MOVEA     DSBBKMKMN4    KOM(96)
     C*
     C                   MOVEA(P)  DSLBAKVBGR    KOM(102)
     C                   MOVEA(P)  DSLBAKLGBE    KOM(105)
     C*
     C                   MOVEA     KOM           EXTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     MCLBAKLFTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSLBAKLFTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSLBAKLFTE    IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSLBAKLFTE
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     PRLBAKLFTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKLFTE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSLBAKLFTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSLBAKLFTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     MCLBAKKMTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSLBAKKMTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*--------------------------------------------------------
     C     DSLBAKKMTE    IFEQ      *ZERO
     C                   MOVEL(P)  'POSANF'      EXDATEPGCD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RTDATEDATE    ANDNE     *ZERO
     C                   Z-ADD     RTDATEDATE    DSLBAKKMTE
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DATE                                                   ***
     C**************************************************************************
     C     PRLBAKKMTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKKMTE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSLBAKKMTE    EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    DSLBAKKMTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KMNR                                                   ***
     C**************************************************************************
     C     MCBBKMKMN1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBBKMKMN1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBBKMKMJ1    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSBBKMKMN1    KOM(05)
     C                   MOVEA     '1'           KOM(11)
     C                   MOVEA     DSBBKMLFNR    KOM(12)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DATAIL'      #CPGST
     C                   EXSR      MCBBKM
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   Z-ADD     BBKMKMJJ      DSBBKMKMJ1
     C                   MOVEL(P)  BBKMKMNR      DSBBKMKMN1
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KMN1                                                   ***
     C**************************************************************************
     C     PRBBKMKMN1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMKMN1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBBKMKMN1    IFNE      *BLANK
     C                   Z-ADD     DSBBKMKMJ1    KYBBKMKMJJ
     C                   MOVEL     DSBBKMKMN1    KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C     BBKMSTAT      IFGT      '20'
     C                   MOVEL(P)  BBKMSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATBBUP'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   MOVEA     EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0015'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KMN2                                                   ***
     C**************************************************************************
     C     MCBBKMKMN2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBBKMKMN2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBBKMKMJ2    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSBBKMKMN2    KOM(05)
     C                   MOVEA     '1'           KOM(11)
     C                   MOVEA     DSBBKMLFNR    KOM(12)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DATAIL'      #CPGST
     C                   EXSR      MCBBKM
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   Z-ADD     BBKMKMJJ      DSBBKMKMJ2
     C                   MOVEL(P)  BBKMKMNR      DSBBKMKMN2
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KMN2                                                   ***
     C**************************************************************************
     C     PRBBKMKMN2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMKMN2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBBKMKMN2    IFNE      *BLANK
     C                   Z-ADD     DSBBKMKMJ2    KYBBKMKMJJ
     C                   MOVEL     DSBBKMKMN2    KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C     BBKMSTAT      IFGT      '22'
     C                   MOVEL(P)  BBKMSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATBBUP'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   EVAL      DUC040  = EXTRPCTEXT
     C                   MOVEA     DUC040        W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0015'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KMNR                                                   ***
     C**************************************************************************
     C     MCBBKMKMN3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBBKMKMN3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBBKMKMJ3    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSBBKMKMN3    KOM(05)
     C                   MOVEA     '1'           KOM(11)
     C                   MOVEA     DSBBKMLFNR    KOM(12)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DATAIL'      #CPGST
     C                   EXSR      MCBBKM
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   Z-ADD     BBKMKMJJ      DSBBKMKMJ3
     C                   MOVEL(P)  BBKMKMNR      DSBBKMKMN3
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KMN3                                                   ***
     C**************************************************************************
     C     PRBBKMKMN3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMKMN3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBBKMKMN3    IFNE      *BLANK
     C                   Z-ADD     DSBBKMKMJ3    KYBBKMKMJJ
     C                   MOVEL     DSBBKMKMN3    KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C     BBKMSTAT      IFGT      '22'
     C                   MOVEL(P)  BBKMSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATBBUP'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   EVAL      DUC040  = EXTRPCTEXT
     C                   MOVEA     DUC040        W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0015'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KMNR                                                   ***
     C**************************************************************************
     C     MCBBKMKMN4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBBKMKMN4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBBKMKMJ4    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA     DSBBKMKMN4    KOM(05)
     C                   MOVEA     '1'           KOM(11)
     C                   MOVEA     DSBBKMLFNR    KOM(12)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'DATAIL'      #CPGST
     C                   EXSR      MCBBKM
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   Z-ADD     BBKMKMJJ      DSBBKMKMJ4
     C                   MOVEL(P)  BBKMKMNR      DSBBKMKMN4
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KMN1                                                   ***
     C**************************************************************************
     C     PRBBKMKMN4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSBBKMKMN4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBBKMKMN4    IFNE      *BLANK
     C                   Z-ADD     DSBBKMKMJ4    KYBBKMKMJJ
     C                   MOVEL     DSBBKMKMN4    KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C     BBKMSTAT      IFGT      '22'
     C                   MOVEL(P)  BBKMSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   MOVEL(P)  'STATBBUP'    EXTRPCPGGR
     C                   EXSR      PRTRPC
     C                   EVAL      DUC040  = EXTRPCTEXT
     C                   MOVEA     DUC040        W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0015'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE VBGR                                                   ***
     C**************************************************************************
     C     MCLBAKVBGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSLBAKVBGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAORVBGR'  KOM(02)
     C                   MOVEA     DSLBAKVBGR    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSLBAKVBGR
     C                   MOVEL(P)  TPTTXT        TXLBAKVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VBGR                                                   ***
     C**************************************************************************
     C     PRLBAKVBGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSLBAKVBGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKVBGR
     C*-------------------------------------------------------------------------
     C     DSLBAKVBGR    IFNE      *BLANK
     C                   MOVEL(P)  '$$WAORVBGR'  KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSLBAKVBGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXLBAKVBGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGE LGBE                                                      ***
     C**************************************************************************
     C     MCLBAKLGBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C     DSLBAKLGBE    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXLBAKLGBE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'LGBE'        KOM(02)
     C                   MOVEA     DSLBAKLGBE    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSLBAKLGBE
     C                   MOVEL(P)  TPTTXT        TXLBAKLGBE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRLGBE        PRÜFEN LAGERBEREICH                                 ***
     C**************************************************************************
     C     PRLBAKLGBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLBAKLGBE'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXLBAKLGBE
     C*-------------------------------------------------------------------------
     C     DSLBAKLGBE    IFNE      *BLANK
     C                   MOVEL(P)  'LGBE'        KYTPTA                         PRÜFEN
     C                   MOVEL(P)  DSLBAKLGBE    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXLBAKLGBE
     C                   ENDIF
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
     C                   MOVEL(P)  'WAO012'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'LGBE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALGBE
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
     C     *LIKE         DEFINE    DSLBAKLGBE    WKTRPALGBE
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
     C                   MOVEL(P)  'WAO012'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTW012W3
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTW012W2
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTW012W3
     C                   OTHER
     C                   WRITE     WAO012CT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTW012W3
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTW012W2
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTW012W3
     C                   OTHER
     C                   WRITE     WAO012CT
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
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHVSBD
     C/COPY QCPYSRC,CHLBPB
     C/COPY QCPYSRC,CHLBPL
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCAFPA
     C/COPY QCPYSRC,MCBBKM
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCLAND
     C/COPY QCPYSRC,MCLIEF
     C/COPY QCPYSRC,MCVSBD
     C/COPY QCPYSRC,MCLBPB
     C/COPY QCPYSRC,MCLBSD
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
