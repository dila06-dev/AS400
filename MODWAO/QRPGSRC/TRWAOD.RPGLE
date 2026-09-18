     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2009')
     H**************************************************************************
     H/TITLE Verwalten Datei WAOD
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: HR 03.02.2011 Projekt 7120 für Kunde Dometec
     H*  -----------------------------------------------------------------------
     H*  Änderung: HR 19.03.2013 Projekt 9397 Ermitteln Rechenschema ERWAOC
     H*  Änderung: HR 23.12.2013 Projekt 10083 Weitere ICS-Felder
     H*  Änderung: HR 14.05.2014 Projekt 10378 Weitere ICS-Felder
     H*  Änderung: HR 16.04.2019 Projekt 13927 Weitere Felder EMEA
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei WAOD für die firmaenspezifische
     F*  Produktgruppen<-Margenmatrix
     F**************************************************************************
     F*     Programm-Übergabeparameter:
     F*     ===========================
     F*
     F*  1. Bei der "normalen" Verwaltung:
     F*     ------------------------------
     F*     Produktgruppe(KOM(01)  (EXTRNDKEYB ==> KOM)
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRWAODFM  CF   E             WORKSTN USROPN
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
     D*
     D WAOC          E DS                  INZ
     D KYWAOC        E DS                  INZ
     D*
     D WAOD          E DS                  INZ
     D KYWAOD        E DS                  INZ
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
     D EXTREND       E DS
     D RTTREND       E DS
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
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBTREND
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
     C                   CLOSE     TRWAODFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PWAOD '
     C                   EXSR      PWAOD
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PWAOD
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LWAOD
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERWAOD'
     C                   EXSR      ERWAOD
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERWAOC'
     C                   EXSR      ERWAOC
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
     C                   OPEN      TRWAODFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRWAODFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
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
     C                   MOVEL(P)  DAFIRM        KYWAOCFIRM                     WAOC
     C                   MOVEL(P)  DAFIRM        KYWAODFIRM                     WAOD
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAODFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRWAODFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXTREND'     EXDATAFILE
     C                   MOVEL(P)  EXTREND       EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  KOM(01)       KYWAODRSBE
     C*
     C                   MOVEA(P)  KOM(01)       DSWAODRSBE
     C*
     C                   MOVEA(P)  EXTRNDNKEY    KOM
     C                   MOVEA(P)  KOM(01)       DSWAODNRSB
     C*
     C     PCPGST        IFEQ      'ERWAOD'
     C     PCPGST        OREQ      'ERWAOC'
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  KOM(04)       WKTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
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
     C                   MOVEL(P)  'TRWAOD'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C**                 MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
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
     C                   MOVEL     'TRWAOD01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAODW3
     C                   WRITE     TRWAOD01
     C                   WRITE     W3WAODB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C**                 MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRWAOD01                             9899
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
     C                   EXSR      UWAOD
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
     C                   MOVE      *BLANK        KYWAODRSBE
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOD
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOD
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
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   WAOD
     C                   EXSR      ETRMU
     C                   EXSR      EWAOD
     C                   MOVEL(P)  KYWAODRSBE    WAODRSBE
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOD
     C                   MOVEL(P)  WAODUSER      WKUSER
     C                   Z-ADD     WAODJDAT      WKJDAT
     C                   Z-ADD     WAODJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHWAOD
     C                   EXSR      EWAOD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAODRSBE      DSWAODRSBE
     C                   Z-ADD     WAODRICS      DSWAODRICS
     C                   Z-ADD     WAODRICN      DSWAODRICN
     C                   Z-ADD     WAODREXS      DSWAODREXS
     C                   Z-ADD     WAODREXN      DSWAODREXN
     C                   Z-ADD     WAODROEM      DSWAODROEM
     C                   Z-ADD     WAODGHNT      DSWAODGHNT
     C                   Z-ADD     WAODGHRB      DSWAODGHRB
     C                   Z-ADD     WAODICSE      DSWAODICSE
     C                   Z-ADD     WAODICSA      DSWAODICSA
     C                   Z-ADD     WAODICSU      DSWAODICSU
     C                   Z-ADD     WAODICSN      DSWAODICSN
     C                   Z-ADD     WAODVPAB      DSWAODVPAB
     C                   Z-ADD     WAODTEML      DSWAODTEML
     C                   Z-ADD     WAODTEMH      DSWAODTEMH
     C                   Z-ADD     WAODTRUS      DSWAODTRUS
     C                   Z-ADD     WAODTAUS      DSWAODTAUS
     C                   Z-ADD     WAODTFCM      DSWAODTFCM
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXWAODRSBE                     INITIALISIEREN
     C*-------------------------------------------------------------------------
     C     DSWAODRSBE    CASNE     *BLANK        PRWAODRSBE                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAOD01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSWAODRICS'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   SELECT
     C     DSWAODRSBE    WHENEQ    *BLANK
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
     C                   OTHER
     C                   MOVEL(P)  'DSWAODRICS'  EXFLPOFLDN
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
     C                   MOVEL     'TRWAODK1'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRWAODW2
     C                   WRITE     TRWAODK1
     C                   WRITE     W2WAODB1
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
     C                   READ      TRWAODK1                             9899
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
     C                   EXSR      KWAOD
     C                   EXSR      UWAOD
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEA(P)  KYWAODRSBE    KOM(01)
     C                   MOVEA(P)  KOM           RTTRNDKEYB
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
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
     C                   MOVEL(P)  KYWAODRSBE    DSWAODRSBE
     C*
     C                   MOVEL(P)  *BLANK        DSWAODNRSB
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODNRSB'  EXFLPOFLDN
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
     C     FLDNAM        ANDEQ     'DSWAODRSBE'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSWAODRICS'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAODRSBE'
     C                   EXSR      MCWAODRSBE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSWAODNRSB'
     C                   EXSR      MCWAODNRSB
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
     C     FLDNAM        WHENEQ    'DSWAODRSBE'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRWAODRSBE
     C     FLDNAM        WHENEQ    'DSWAODRICS'
     C                   EXSR      PRWAODRICS
     C     FLDNAM        WHENEQ    'DSWAODRICN'
     C                   EXSR      PRWAODRICN
     C     FLDNAM        WHENEQ    'DSWAODREXS'
     C                   EXSR      PRWAODREXS
     C     FLDNAM        WHENEQ    'DSWAODREXN'
     C                   EXSR      PRWAODREXN
     C     FLDNAM        WHENEQ    'DSWAODROEM'
     C                   EXSR      PRWAODROEM
     C     FLDNAM        WHENEQ    'DSWAODGHNT'
     C                   EXSR      PRWAODGHNT
     C     FLDNAM        WHENEQ    'DSWAODGHRB'
     C                   EXSR      PRWAODGHRB
     C     FLDNAM        WHENEQ    'DSWAODICSE'
     C                   EXSR      PRWAODICSE
     C     FLDNAM        WHENEQ    'DSWAODICSA'
     C                   EXSR      PRWAODICSA
     C     FLDNAM        WHENEQ    'DSWAODICSU'
     C                   EXSR      PRWAODICSU
     C     FLDNAM        WHENEQ    'DSWAODICSN'
     C                   EXSR      PRWAODICSN
     C     FLDNAM        WHENEQ    'DSWAODVPAB'
     C                   EXSR      PRWAODVPAB
     C     FLDNAM        WHENEQ    'DSWAODTEML'
     C                   EXSR      PRWAODTEML
     C     FLDNAM        WHENEQ    'DSWAODTEMH'
     C                   EXSR      PRWAODTEMH
     C     FLDNAM        WHENEQ    'DSWAODTRUS'
     C                   EXSR      PRWAODTRUS
     C     FLDNAM        WHENEQ    'DSWAODTAUS'
     C                   EXSR      PRWAODTAUS
     C     FLDNAM        WHENEQ    'DSWAODTFCM'
     C                   EXSR      PRWAODTFCM
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
     C                   MOVEL(P)  DSWAODNRSB    KYWAODRSBE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOD
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAODNRSB'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      *BLANK
     C                   MOVEL(P)  DSWAODRSBE    KYWAODRSBE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOD
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
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
     C                   MOVEL(P)  'WAOD'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOD          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI WAOD                                     ***
     C**************************************************************************
     C     KWAOD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAODRSBE    KYWAODRSBE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOD
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     WAODRICS      DSWAODRICS
     C                   Z-ADD     WAODRICN      DSWAODRICN
     C                   Z-ADD     WAODREXS      DSWAODREXS
     C                   Z-ADD     WAODREXN      DSWAODREXN
     C                   Z-ADD     WAODROEM      DSWAODROEM
     C                   Z-ADD     WAODGHNT      DSWAODGHNT
     C                   Z-ADD     WAODGHRB      DSWAODGHRB
     C                   Z-ADD     WAODICSE      DSWAODICSE
     C                   Z-ADD     WAODICSA      DSWAODICSA
     C                   Z-ADD     WAODICSU      DSWAODICSU
     C                   Z-ADD     WAODICSN      DSWAODICSN
     C                   Z-ADD     WAODVPAB      DSWAODVPAB
     C                   Z-ADD     WAODTEML      DSWAODTEML
     C                   Z-ADD     WAODTEMH      DSWAODTEMH
     C                   Z-ADD     WAODTRUS      DSWAODTRUS
     C                   Z-ADD     WAODTAUS      DSWAODTAUS
     C                   Z-ADD     WAODTFCM      DSWAODTFCM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB WAOD-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PWAOD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAODRSBE    OFWAODRSBE
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAODFIRM      ANDEQ     KYWAODFIRM
     C     WAODRSBE      ANDLE     OFWAODRSBE
     C*--------------------------------------------------------
     C     WAODLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'WAODLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOD
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI WAOD                                          ***
     C**************************************************************************
     C     LWAOD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAODRSBE    OFWAODRSBE
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     WAODFIRM      ANDEQ     KYWAODFIRM
     C     WAODRSBE      ANDLE     OFWAODRSBE
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAODRSBE      KYWAODRSBE
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOD
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHWAOD
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOD
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
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
     C***  UPDATE DATEI WAOD                                                 ***
     C**************************************************************************
     C     UWAOD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSWAODRSBE    KYWAODRSBE
     C*
     C     PCPGST        IFEQ      '3     '
     C                   MOVE(P)   DSWAODNRSB    KYWAODRSBE
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAOD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSWAODRICS    WAODRICS
     C                   Z-ADD     DSWAODRICN    WAODRICN
     C                   Z-ADD     DSWAODREXS    WAODREXS
     C                   Z-ADD     DSWAODREXN    WAODREXN
     C                   Z-ADD     DSWAODROEM    WAODROEM
     C                   Z-ADD     DSWAODGHNT    WAODGHNT
     C                   Z-ADD     DSWAODGHRB    WAODGHRB
     C                   Z-ADD     DSWAODICSE    WAODICSE
     C                   Z-ADD     DSWAODICSA    WAODICSA
     C                   Z-ADD     DSWAODICSU    WAODICSU
     C                   Z-ADD     DSWAODICSN    WAODICSN
     C                   Z-ADD     DSWAODVPAB    WAODVPAB
     C                   Z-ADD     DSWAODTEML    WAODTEML
     C                   Z-ADD     DSWAODTEMH    WAODTEMH
     C                   Z-ADD     DSWAODTRUS    WAODTRUS
     C                   Z-ADD     DSWAODTAUS    WAODTAUS
     C                   Z-ADD     DSWAODTFCM    WAODTFCM
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        WAODJNAM
     C                   MOVEL(P)  DAPROG        WAODPROG
     C                   MOVEL(P)  WKCHPL        WAODBIBL
     C                   MOVEL(P)  DAUSER        WAODUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAODJZEI
     C                   MOVE      WKTDAT        WAODJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHWAOD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAOD
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOD
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE RSBE                                                   ***
     C**************************************************************************
     C     MCWAODRSBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSWAODRSBE    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXWAODRSBE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'MODWAORSBE'  KOM(02)
     C                   MOVEA     DSWAODRSBE    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAODRSBE
     C                   MOVEL(P)  TPTTXT        TXWAODRSBE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE RSBE                                                   ***
     C**************************************************************************
     C     PRWAODRSBE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODRSBE'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXWAODRSBE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAORSBE'  KYTPTA
     C                   MOVEL(P)  DSWAODRSBE    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXWAODRSBE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE RICS                                                   ***
     C**************************************************************************
     C     PRWAODRICS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODRICS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODRICS    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE RICN                                                   ***
     C**************************************************************************
     C     PRWAODRICN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODRICN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODRICN    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE REXS                                                   ***
     C**************************************************************************
     C     PRWAODREXS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODREXS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODREXS    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE REXN                                                   ***
     C**************************************************************************
     C     PRWAODREXN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODREXN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODREXN    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ROEM                                                   ***
     C**************************************************************************
     C     PRWAODROEM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODROEM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODROEM    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GHNT                                                   ***
     C**************************************************************************
     C     PRWAODGHNT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODGHNT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODGHNT    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GHRB                                                   ***
     C**************************************************************************
     C     PRWAODGHRB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODGHRB'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODGHRB    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ISCE                                                   ***
     C**************************************************************************
     C     PRWAODICSE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODICSE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODICSE    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ISCA                                                   ***
     C**************************************************************************
     C     PRWAODICSA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODICSA'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODICSA    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ISCU                                                   ***
     C**************************************************************************
     C     PRWAODICSU    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODICSU'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODICSU    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE ISCN                                                   ***
     C**************************************************************************
     C     PRWAODICSN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODICSN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODICSN    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE VPAB                                                   ***
     C**************************************************************************
     C     PRWAODVPAB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODVPAB'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODVPAB    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TEML                                                   ***
     C**************************************************************************
     C     PRWAODTEML    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODTEML'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODTEML    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TEMH                                                   ***
     C**************************************************************************
     C     PRWAODTEMH    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODTEMH'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODTEMH    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TRUS                                                   ***
     C**************************************************************************
     C     PRWAODTRUS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODTRUS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODTRUS    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TAUS                                                   ***
     C**************************************************************************
     C     PRWAODTAUS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODTAUS'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODTAUS    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TFCM                                                   ***
     C**************************************************************************
     C     PRWAODTFCM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODTFCM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSWAODTFCM    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE NRSB                                                   ***
     C**************************************************************************
     C     MCWAODNRSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'MODWAORSBE'  KOM(02)
     C                   MOVEA     DSWAODNRSB    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSWAODNRSB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE NRBS                                                   ***
     C**************************************************************************
     C     PRWAODNRSB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSWAODNRSB'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAORSBE'  KYTPTA
     C                   MOVEL(P)  DSWAODNRSB    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAOD'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      WAOD
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'WAOD'        EXDATAFILE
     C                   MOVEL(P)  WAOD          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    WAOD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EWAOD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS WAOD                                          ***
     C**************************************************************************
     C     ERWAOD        BEGSR
     C*
     C                   Z-ADD     *ZERO         WKRICS
     C                   Z-ADD     *ZERO         WKRICN
     C                   Z-ADD     *ZERO         WKREXS
     C                   Z-ADD     *ZERO         WKREXN
     C                   Z-ADD     *ZERO         WKROEM
     C                   Z-ADD     *ZERO         WKGHNT
     C                   Z-ADD     *ZERO         WKGHRB
     C                   Z-ADD     *ZERO         WKICSE
     C                   Z-ADD     *ZERO         WKICSA
     C                   Z-ADD     *ZERO         WKICSU
     C                   Z-ADD     *ZERO         WKICSN
     C                   Z-ADD     *ZERO         WKVPAB
     C                   Z-ADD     *ZERO         WKTEML
     C                   Z-ADD     *ZERO         WKTEMH
     C                   Z-ADD     *ZERO         WKTRUS
     C                   Z-ADD     *ZERO         WKTAUS
     C                   Z-ADD     *ZERO         WKTFCM
     C*
     C                   MOVEL     *BLANK        WKLFNR
     C                   MOVEL     *BLANK        WKPRGR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TEPRGR        WKPRGR
     C                   MOVEL(P)  TESTLF        WKLFNR
     C     TESTLF        IFEQ      *BLANK
     C                   MOVEL(P)  TELFNR        WKLFNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKPRGR        KYWAOCPRGR
     C                   MOVEL(P)  WKLFNR        KYWAOCLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOC
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     *BLANK        KYWAOCLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOCRSBE      KYWAODRSBE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOD
     C*
     C                   Z-ADD     WAODRICS      WKRICS
     C                   Z-ADD     WAODRICN      WKRICN
     C                   Z-ADD     WAODREXS      WKREXS
     C                   Z-ADD     WAODREXN      WKREXN
     C                   Z-ADD     WAODROEM      WKROEM
     C                   Z-ADD     WAODGHNT      WKGHNT
     C                   Z-ADD     WAODGHRB      WKGHRB
     C                   Z-ADD     WAODICSE      WKICSE
     C                   Z-ADD     WAODICSA      WKICSA
     C                   Z-ADD     WAODICSU      WKICSU
     C                   Z-ADD     WAODICSN      WKICSN
     C                   Z-ADD     WAODVPAB      WKVPAB
     C                   Z-ADD     WAODTEML      WKTEML
     C                   Z-ADD     WAODTEMH      WKTEMH
     C                   Z-ADD     WAODTRUS      WKTRUS
     C                   Z-ADD     WAODTAUS      WKTAUS
     C                   Z-ADD     WAODTFCM      WKTFCM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM                            ÜBERGABEBEREICH
     C                   Z-ADD     WKRICS        DUN052
     C                   MOVEA     DUC005        KOM(001)
     C                   Z-ADD     WKRICN        DUN052
     C                   MOVEA     DUC005        KOM(006)
     C                   Z-ADD     WKREXS        DUN052
     C                   MOVEA     DUC005        KOM(011)
     C                   Z-ADD     WKREXN        DUN052
     C                   MOVEA     DUC005        KOM(016)
     C                   Z-ADD     WKROEM        DUN052
     C                   MOVEA     DUC005        KOM(021)
     C                   Z-ADD     WKGHNT        DUN052
     C                   MOVEA     DUC005        KOM(026)
     C                   Z-ADD     WKGHRB        DUN052
     C                   MOVEA     DUC005        KOM(031)
     C                   Z-ADD     WKICSE        DUN052
     C                   MOVEA     DUC005        KOM(036)
     C                   Z-ADD     WKICSA        DUN052
     C                   MOVEA     DUC005        KOM(041)
     C                   Z-ADD     WKICSU        DUN052
     C                   MOVEA     DUC005        KOM(046)
     C                   Z-ADD     WKICSN        DUN052
     C                   MOVEA     DUC005        KOM(051)
     C                   Z-ADD     WKVPAB        DUN052
     C                   MOVEA     DUC005        KOM(056)
     C                   Z-ADD     WKTEML        DUN052
     C                   MOVEA     DUC005        KOM(061)
     C                   Z-ADD     WKTEMH        DUN052
     C                   MOVEA     DUC005        KOM(066)
     C                   Z-ADD     WKTRUS        DUN052
     C                   MOVEA     DUC005        KOM(071)
     C                   Z-ADD     WKTAUS        DUN052
     C                   MOVEA     DUC005        KOM(076)
     C                   Z-ADD     WKTFCM        DUN052
     C                   MOVEA     DUC005        KOM(081)
     C*
     C                   MOVEA     KOM           RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS WAOC                                          ***
     C**************************************************************************
     C     ERWAOC        BEGSR
     C*
     C                   MOVEL     *BLANK        WKLFNR
     C                   MOVEL     *BLANK        WKPRGR
     C                   MOVEL     *BLANK        WKRSBE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TEPRGR        WKPRGR
     C                   MOVEL(P)  TESTLF        WKLFNR
     C     TESTLF        IFEQ      *BLANK
     C                   MOVEL(P)  TELFNR        WKLFNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKPRGR        KYWAOCPRGR
     C                   MOVEL(P)  WKLFNR        KYWAOCLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOC
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     *BLANK        KYWAOCLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAOCRSBE      WKRSBE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM                            ÜBERGABEBEREICH
     C                   MOVEA     WKRSBE        KOM(001)
     C*
     C                   MOVEA     KOM           RTTRNDDATE
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
     C                   MOVEL(P)  'TRWAOD'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODXXX'      KYTATC
     C                   MOVEL(P)  'MODXXX'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODXXX
     C*
     C     MODXXX        IFNE      *ON
     C                   MOVE      *OFF          MODXXX
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'QQQQ'        KYTATC
     C                   MOVEL(P)  'QQQQ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAQQQQ
     C*
     C     WKTRPAQQQQ    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAQQQQ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODYYY'      KYTATC
     C                   MOVEL(P)  'MODYYY'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODYYY
     C                   ELSE
     C                   MOVE      *OFF          MODYYY
     C                   ENDIF
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
     C                   MOVEL(P)  'TRWAOD'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRWAODB1'    EXTRDNPGNA
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
     C     EXTRDNDANA    WHENEQ    'TRTK'
     C                   EXSR      MCAUFRTRTK
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODXXX
     C     *LIKE         DEFINE    WKC001        MODYYY
     C     *LIKE         DEFINE    WKC001        WKTRPAQQQQ
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
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
     C     *LIKE         DEFINE    KYWAODRSBE    OFWAODRSBE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAODRICS      WKRICS
     C     *LIKE         DEFINE    WAODRICN      WKRICN
     C     *LIKE         DEFINE    WAODREXS      WKREXS
     C     *LIKE         DEFINE    WAODREXN      WKREXN
     C     *LIKE         DEFINE    WAODROEM      WKROEM
     C     *LIKE         DEFINE    WAODGHNT      WKGHNT
     C     *LIKE         DEFINE    WAODGHRB      WKGHRB
     C     *LIKE         DEFINE    WAODICSE      WKICSE
     C     *LIKE         DEFINE    WAODICSA      WKICSA
     C     *LIKE         DEFINE    WAODICSU      WKICSU
     C     *LIKE         DEFINE    WAODICSN      WKICSN
     C     *LIKE         DEFINE    WAODVPAB      WKVPAB
     C     *LIKE         DEFINE    WAODTEML      WKTEML
     C     *LIKE         DEFINE    WAODTEMH      WKTEMH
     C     *LIKE         DEFINE    WAODTRUS      WKTRUS
     C     *LIKE         DEFINE    WAODTAUS      WKTAUS
     C     *LIKE         DEFINE    WAODTFCM      WKTFCM
     C*
     C     *LIKE         DEFINE    WAOCPRGR      WKPRGR
     C     *LIKE         DEFINE    WAOCLFNR      WKLFNR
     C     *LIKE         DEFINE    TETENR        WKTENR
     C     *LIKE         DEFINE    WAOCRSBE      WKRSBE
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
     C                   MOVEL(P)  'TRWAOD'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAODW2
     C                   OTHER
     C                   WRITE     CTWAODW3
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTWAODW2
     C                   OTHER
     C                   WRITE     CTWAODW3
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
     C/COPY QCPYSRC,CHWAOC
     C/COPY QCPYSRC,CHWAOD
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTK
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
