     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2010')
     H**************************************************************************
     H/TITLE Verwalten Datei KDEW
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Str. 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RH 04.11.2010 Kunde WAECO Projekt 6883
     H*  -----------------------------------------------------------------------
     H*  Geändert: RH 19.11.2010 SYTK/SYTP $$KDEWBVKG für Prüfung BOVIS-KdGr
     H*  Änderung: MG 15.08.2011 Projekt 7668, Planungssystem
     H*            Neue Felder Planungskz, Kundenplanung
     H*  Änderung: ZG 12.06.2013 Projekt 8399 - Übernahme ZOTN,URLD,ZPUR in den
     H*            Kundenstamm.
     H*  Änderung: MG 12.07.2012 Projekt 8559 Plankunden sind abhängig von der
     H*            Commercial-Division. Die Verknüpfung zwischen der Commercial-
     H*            Division und dem Plankunde erfolgt über die Tabelle KDEWKDPL
     H*            über das Feld "num. Wert".
     H*  Änderung: ZG 20.08.2012 Projekt 8762 - Einzel-Picklistensteuerung
     H*  Änderung: MG 10.09.2012 Projekt 8886, Planungssystem
     H*            Erweiterung der Prüfung des Planungsk.
     H*  Änderung: MG 23.11.2012 PROJEKT 9021 - "Konzernschlüßel" (KDEWKZKY)
     H*  Änderung: PH 09.07.2014 Projekt 10655. Neue Felder KDEWRPMG "RPM-Gruppe",
     H*            KDEWFL01...04 "KD-Steuerung 01...04"; alle 10A
     H*  Änderung: PH 13.08.2015 Projekt 11567. Neues Feld KDEWFGZT "F-Gas berechtigt"
     H*  Änderung: PH 28.08.2015 Projekt 11427. Neues Feld KDEWSPTE "Kom-Schein verdichten"
     A*  Änderung: PH 01.12.2022 Projekt 220562-01. Neue Felder KDEWFL05...09
     A*            "KD-Steuerung 05...09", alle 20A. Felder im Format TRKDEW01 neu
     A*            angeordnet, damit die neuen Felder platziert werden können.
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei KDEW.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRKDEWFM  CF   E             WORKSTN USROPN
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
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D WKKDEW        E DS                  EXTNAME(KDEW) PREFIX(WK)
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
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
     D  EXKDEWKEYB                  256
     D   EXKDEWKDNR                  10    OVERLAY(EXKDEWKEYB:1)
     D*
     D  EXKDEWNKEY                  273
     D   EXKDEWNKDN                  10    OVERLAY(EXKDEWNKEY:1)
     D*
     D  EXKDEWDATE                 1024
     D   EXKDEWGSKZ                   1    OVERLAY(EXKDEWDATE:1)
     D   EXKDEWBLKZ                   1    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWBVKG                   1    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWKSST                  10    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWKDKR                   4    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWZOTN                   1    OVERLAY(EXKDEWDATE:*NEXT)            frei
     D   EXKDEWZPUR                   1    OVERLAY(EXKDEWDATE:*NEXT)            frei
     D   EXKDEWURLD                   1    OVERLAY(EXKDEWDATE:*NEXT)            frei
     D   EXKDEWDAGB                   1    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWPLKZ                   1    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWKDPL                   4    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWEZPL                   1    OVERLAY(EXKDEWDATE:*NEXT)
     D   EXKDEWKZKY                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWKZKY)
     D   EXKDEWDUST                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWDUST)
     D   EXKDEWRPMG                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWRPMG)
     D   EXKDEWFL01                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL01)
     D   EXKDEWFL02                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL02)
     D   EXKDEWFL03                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL03)
     D   EXKDEWFL04                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL04)
     D   EXKDEWFGZT                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFGZT)
     D   EXKDEWSPTE                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWSPTE)
     D   EXKDEWFL05                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL05)
     D   EXKDEWFL06                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL06)
     D   EXKDEWFL07                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL07)
     D   EXKDEWFL08                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL08)
     D   EXKDEWFL09                        OVERLAY(EXKDEWDATE:*NEXT)
     D                                     LIKE(KDEWFL09)
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
     C                   EXSR      UEBKDEW
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
     C                   CLOSE     TRKDEWFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'KKUND '
     C     PCPGST        OREQ      '3     '
     C                   EXSR      KKDEW
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UKDEW
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PKDEW '
     C                   EXSR      PKDEW
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PKDEW
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LKDEW
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERMFLD'                                     EXTERNE PRÜFUNG
     C                   EXSR      ERMFLD
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPDATE'
     C                   EXSR      IFKDEW                                       UPDATE
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
     C                   OPEN      TRKDEWFM                             98
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
     C                   CLOSE     TRKDEWFM                             98
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
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KUND
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTKFI                         TRTK
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL     DAFIRM        KYSYTPFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTKSP                         TRTK
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKDEWFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRKDEWFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBKDEW       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'EXTRND'      EXDATAFILE
     C                   MOVEL(P)  EXTREND       EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    EXTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C                   MOVEL(P)  EXTRNDKEYB    EXKDEWKEYB
     C*
     C                   MOVEL(P)  EXKDEWKDNR    KYKDEWKDNR
     C                   MOVEL(P)  EXKDEWKDNR    DSKDEWKDNR
     C*
     C                   MOVEL(P)  EXTRNDNKEY    EXKDEWNKEY
     C                   MOVEL(P)  EXKDEWNKDN    DSKDEWNKDN
     C*
     C                   MOVEL(P)  EXTRNDDATE    EXKDEWDATE
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
     C                   MOVEL(P)  'KDEW'        EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
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
     C                   MOVEL     'TRKDEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRKDEW01
     C                   WRITE     TRKDEWB1
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
     C                   READ      TRKDEW01                             9899
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
     C                   EXSR      UKDEW
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKDEW
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHKDEW
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
     C                   MOVEL(P)  DSKDEWKDNR    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     PCPGST        IFEQ      *BLANK
     C     PCPGST        OREQ      '2     '
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL(P)  *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL(P)  '2     '      PCPGST
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   KDEW
     C                   EXSR      ETRMU
     C                   EXSR      EKDEW
     C                   MOVEL(P)  KYKDEWKDNR    KDEWKDNR
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVEL(P)  KDEWUSER      WKUSER
     C                   Z-ADD     KDEWJDAT      WKJDAT
     C                   Z-ADD     KDEWJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHKDEW
     C                   EXSR      EKDEW
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEWKDNR      DSKDEWKDNR
     C                   MOVEL(P)  KDEWGSKZ      DSKDEWGSKZ
     C                   MOVEL(P)  KDEWKDKR      DSKDEWKDKR
     C                   MOVEL(P)  KDEWBLKZ      DSKDEWBLKZ
     C                   MOVEL(P)  KDEWBVKG      DSKDEWBVKG
     C                   MOVEL(P)  KDEWKSST      DSKDEWKSST
     C                   MOVEL(P)  KDEWDAGB      DSKDEWDAGB
     C                   MOVEL(P)  KDEWPLKZ      DSKDEWPLKZ
     C                   MOVEL(P)  KDEWKDPL      DSKDEWKDPL
     C                   MOVEL(P)  KDEWEZPL      DSKDEWEZPL
     C                   MOVEL(P)  KDEWKZKY      DSKDEWKZKY
     C                   MOVEL(P)  KDEWDUST      DSKDEWDUST
     C                   MOVEL(P)  KDEWRPMG      DSKDEWRPMG
     C                   MOVEL(P)  KDEWFL01      DSKDEWFL01
     C                   MOVEL(P)  KDEWFL02      DSKDEWFL02
     C                   MOVEL(P)  KDEWFL03      DSKDEWFL03
     C                   MOVEL(P)  KDEWFL04      DSKDEWFL04
     C                   MOVEL(P)  KDEWFGZT      DSKDEWFGZT
     C                   MOVEL(P)  KDEWSPTE      DSKDEWSPTE
     C                   MOVEL(P)  KDEWFL05      DSKDEWFL05
     C                   MOVEL(P)  KDEWFL06      DSKDEWFL06
     C                   MOVEL(P)  KDEWFL07      DSKDEWFL07
     C                   MOVEL(P)  KDEWFL08      DSKDEWFL08
     C                   MOVEL(P)  KDEWFL09      DSKDEWFL09
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSKUNDKNAM
     C                   MOVE      *BLANK        TXKDEWKDKR                     INITIALISIEREN
     C                   MOVE      *BLANK        TXKDEWGSKZ                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWBLKZ                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWBVKG                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWKSST                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWDAGB                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWPLKZ
     C                   MOVE      *BLANK        TXKDEWKDPL
     C                   MOVE      *BLANK        TXKDEWEZPL
     C                   MOVE      *BLANK        TXKDEWKZKY
     C                   MOVE      *BLANK        TXKDEWDUST                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWRPMG
     C                   MOVE      *BLANK        TXKDEWFGZT
     C                   MOVE      *BLANK        TXKDEWSPTE
     C*-------------------------------------------------------------------------
     C     DSKDEWKDNR    CASNE     *BLANK        PRKDEWKDNR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKDEWGSKZ    CASNE     *BLANK        PRKDEWGSKZ
     C                   ENDCS
     C     DSKDEWKDKR    CASNE     *BLANK        PRKDEWKDKR
     C                   ENDCS
     C     DSKDEWBLKZ    CASNE     *BLANK        PRKDEWBLKZ
     C                   ENDCS
     C     DSKDEWBVKG    CASNE     *BLANK        PRKDEWBVKG
     C                   ENDCS
     C     DSKDEWKSST    CASNE     *BLANK        PRKDEWKSST
     C                   ENDCS
     C     DSKDEWDAGB    CASNE     *BLANK        PRKDEWDAGB
     C                   ENDCS
     C     DSKDEWDUST    CASNE     *BLANK        PRKDEWDUST
     C                   ENDCS
     C     DSKDEWPLKZ    CASNE     *BLANK        PRKDEWPLKZ
     C                   ENDCS
     C     DSKDEWKDPL    CASNE     *BLANK        PRKDEWKDPL
     C                   ENDCS
     C     DSKDEWEZPL    CASNE     *BLANK        PRKDEWEZPL
     C                   ENDCS
     C     DSKDEWKZKY    CASNE     *BLANK        PRKDEWKZKY
     C                   ENDCS
     C     DSKDEWRPMG    CASNE     *BLANK        PRKDEWRPMG
     C                   ENDCS
     C     DSKDEWFGZT    CASNE     *BLANK        PRKDEWFGZT
     C                   ENDCS
     C     DSKDEWSPTE    CASNE     *BLANK        PRKDEWSPTE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKDEW01'    EXTRPBBFMT
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
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
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
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
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
     C     C#LCK0        WHENEQ    *ON
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSKDEWKDNR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSKDEWKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWGSKZ'
     C                   EXSR      MCKDEWGSKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKDKR'
     C                   EXSR      MCKDEWKDKR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWBLKZ'
     C                   EXSR      MCKDEWBLKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWBVKG'
     C                   EXSR      MCKDEWBVKG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C                   EXSR      MCKDEWKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWDAGB'
     C                   EXSR      MCKDEWDAGB
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWDUST'
     C                   EXSR      MCKDEWDUST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWPLKZ'
     C                   EXSR      MCKDEWPLKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKDPL'
     C                   EXSR      MCKDEWKDPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWEZPL'
     C                   EXSR      MCKDEWEZPL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWKZKY'
     C                   EXSR      MCKDEWKZKY
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWRPMG'
     C                   EXSR      MCKDEWRPMG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWFGZT'
     C                   EXSR      MCKDEWFGZT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWSPTE'
     C                   EXSR      MCKDEWSPTE
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
     C                   EVAL      EXFLPOFLDN = FLDNAM
     C                   EXSR      EFLPO
     C*----------------------------------------------------------
     C                   SELECT
     C                   WHEN      EXFLPOKZIO = *OFF
     C     FLDNAM        WHENEQ    'DSKDEWKDNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRKDEWKDNR
     C     FLDNAM        WHENEQ    'DSKDEWGSKZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWGSKZ
     C     FLDNAM        WHENEQ    'DSKDEWBLKZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWBLKZ
     C     FLDNAM        WHENEQ    'DSKDEWBVKG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWBVKG
     C     FLDNAM        WHENEQ    'DSKDEWKSST'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWKSST
     C     FLDNAM        WHENEQ    'DSKDEWKDKR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWKDKR
     C     FLDNAM        WHENEQ    'DSKDEWDAGB'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWDAGB
     C     FLDNAM        WHENEQ    'DSKDEWDUST'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWDUST
     C     FLDNAM        WHENEQ    'DSKDEWPLKZ'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWPLKZ
     C     FLDNAM        WHENEQ    'DSKDEWKDPL'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWKDPL
     C     FLDNAM        WHENEQ    'DSKDEWEZPL'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWEZPL
     C     FLDNAM        WHENEQ    'DSKDEWKZKY'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWKZKY
     C     FLDNAM        WHENEQ    'DSKDEWRPMG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWRPMG
     C     FLDNAM        WHENEQ    'DSKDEWFGZT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWFGZT
     C     FLDNAM        WHENEQ    'DSKDEWSPTE'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRKDEWSPTE
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
     C                   MOVEL(P)  DSKDEWNKDN    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSKDEWNKDN'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      '      '
     C                   MOVEL(P)  DSKDEWKDNR    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSKDEWKDNR'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSKDEWKDNR'  EXFLPOFLDN
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
     C                   MOVEL(P)  'KDEW'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEW          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI KDEW                                     ***
     C**************************************************************************
     C     KKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSKDEWKDNR    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  KDEWGSKZ      DSKDEWGSKZ
     C                   MOVEL(P)  KDEWBLKZ      DSKDEWBLKZ
     C                   MOVEL(P)  KDEWBVKG      DSKDEWBVKG
     C                   MOVEL(P)  KDEWKSST      DSKDEWKSST
     C                   MOVEL(P)  KDEWKDKR      DSKDEWKDKR
     C                   MOVEL(P)  KDEWDAGB      DSKDEWDAGB
     C                   MOVEL(P)  KDEWDUST      DSKDEWDUST
     C                   MOVEL(P)  KDEWPLKZ      DSKDEWPLKZ
     C                   MOVEL(P)  KDEWKDPL      DSKDEWKDPL
     C                   MOVEL(P)  KDEWEZPL      DSKDEWEZPL
     C                   MOVEL(P)  KDEWKZKY      DSKDEWKZKY
     C                   MOVEL(P)  KDEWRPMG      DSKDEWRPMG
     C                   MOVEL(P)  KDEWFL01      DSKDEWFL01
     C                   MOVEL(P)  KDEWFL02      DSKDEWFL02
     C                   MOVEL(P)  KDEWFL03      DSKDEWFL03
     C                   MOVEL(P)  KDEWFL04      DSKDEWFL04
     C                   MOVEL(P)  KDEWFGZT      DSKDEWFGZT
     C                   MOVEL(P)  KDEWSPTE      DSKDEWSPTE
     C                   MOVEL(P)  KDEWFL05      DSKDEWFL05
     C                   MOVEL(P)  KDEWFL06      DSKDEWFL06
     C                   MOVEL(P)  KDEWFL07      DSKDEWFL07
     C                   MOVEL(P)  KDEWFL08      DSKDEWFL08
     C                   MOVEL(P)  KDEWFL09      DSKDEWFL09
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB KDEW-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYKDEWKDNR    OFKDEWKDNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDNR      ANDLE     OFKDEWKDNR
     C*--------------------------------------------------------
     C     KDEWLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'KDEWLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHKDEW
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
     C***  LÖSCHEN SÄTZE DATEI KDEW                                          ***
     C**************************************************************************
     C     LKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYKDEWKDNR    OFKDEWKDNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKDEW
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     KDEWFIRM      ANDEQ     KYKDEWFIRM
     C     KDEWKDNR      ANDLE     OFKDEWKDNR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDEWKDNR      KYKDEWKDNR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHKDEW
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
     C***  PRÜFEN DATEI-FELDER                                               ***
     C**************************************************************************
     C     PRAUFR        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXKDEWGSKZ    DSKDEWGSKZ
     C                   MOVEL(P)  EXKDEWBLKZ    DSKDEWBLKZ
     C                   MOVEL(P)  EXKDEWBVKG    DSKDEWBVKG
     C                   MOVEL(P)  EXKDEWKSST    DSKDEWKSST
     C                   MOVEL(P)  EXKDEWKDKR    DSKDEWKDKR
     C                   MOVEL(P)  EXKDEWDAGB    DSKDEWDAGB
     C                   MOVEL(P)  EXKDEWPLKZ    DSKDEWPLKZ
     C                   MOVEL(P)  EXKDEWKDPL    DSKDEWKDPL
     C                   MOVEL(P)  EXKDEWEZPL    DSKDEWEZPL
     C                   MOVEL(P)  EXKDEWKZKY    DSKDEWKZKY
     C                   MOVEL(P)  EXKDEWDUST    DSKDEWDUST
     C                   MOVEL(P)  EXKDEWRPMG    DSKDEWRPMG
     C                   MOVEL(P)  EXKDEWFGZT    DSKDEWFGZT
     C                   MOVEL(P)  EXKDEWSPTE    DSKDEWSPTE
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   OTHER
     C                   MOVEL     'TRKDEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
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
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFKDEW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*
     C     EXKDEWGSKZ    IFNE      *BLANK
     C                   MOVEL     EXKDEWGSKZ    DSKDEWGSKZ
     C                   ENDIF
     C     EXKDEWBLKZ    IFNE      *BLANK
     C                   MOVEL     EXKDEWBLKZ    DSKDEWBLKZ
     C                   ENDIF
     C     EXKDEWBVKG    IFNE      *BLANK
     C                   MOVEL     EXKDEWBVKG    DSKDEWBVKG
     C                   ENDIF
     C     EXKDEWKSST    IFNE      *BLANK
     C                   MOVEL     EXKDEWKSST    DSKDEWKSST
     C                   ENDIF
     C     EXKDEWKDKR    IFNE      *BLANK
     C                   MOVEL     EXKDEWKDKR    DSKDEWKDKR
     C                   ENDIF
     C     EXKDEWDAGB    IFNE      *BLANK
     C                   MOVEL     EXKDEWDAGB    DSKDEWDAGB
     C                   ENDIF
     C     EXKDEWPLKZ    IFNE      *BLANK
     C                   MOVEL     EXKDEWPLKZ    DSKDEWPLKZ
     C                   ENDIF
     C     EXKDEWKDPL    IFNE      *BLANK
     C                   MOVEL     EXKDEWKDPL    DSKDEWKDPL
     C                   ENDIF
     C     EXKDEWEZPL    IFNE      *BLANK
     C                   MOVEL     EXKDEWEZPL    DSKDEWEZPL
     C                   ENDIF
     C     EXKDEWKZKY    IFNE      *BLANK
     C                   MOVEL     EXKDEWKZKY    DSKDEWKZKY
     C                   ENDIF
     C     EXKDEWDUST    IFNE      *BLANK
     C                   MOVEL     EXKDEWDUST    DSKDEWDUST
     C                   ENDIF
     C     EXKDEWRPMG    IFNE      *BLANK
     C                   MOVEL(P)  EXKDEWRPMG    DSKDEWRPMG
     C                   ENDIF
     C     EXKDEWFGZT    IFNE      *BLANK
     C                   MOVEL(P)  EXKDEWFGZT    DSKDEWFGZT
     C                   ENDIF
     C     EXKDEWSPTE    IFNE      *BLANK
     C                   MOVEL(P)  EXKDEWSPTE    DSKDEWSPTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRKDEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UKDEW
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
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
     C     K#KDEWLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHKDEW                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KDEW                                                 ***
     C**************************************************************************
     C     UKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSKDEWKDNR    KYKDEWKDNR
     C*
     C     PCPGST        IFEQ      '3     '
     C     PCPGST        OREQ      'KKUND '
     C                   MOVE(P)   DSKDEWNKDN    KYKDEWKDNR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKDEW
     C*-------------------------------------------------------------------------
     C* SPEICHERN DATENSATZ
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = %LEN(KDEW)
     C                   EVAL      WKKDEW      = KDEW
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSKDEWGSKZ    KDEWGSKZ
     C                   MOVEL(P)  DSKDEWBLKZ    KDEWBLKZ
     C                   MOVEL(P)  DSKDEWBVKG    KDEWBVKG
     C                   MOVEL(P)  DSKDEWKSST    KDEWKSST
     C                   MOVEL(P)  DSKDEWKDKR    KDEWKDKR
     C                   MOVEL(P)  DSKDEWDAGB    KDEWDAGB
     C                   MOVEL(P)  DSKDEWPLKZ    KDEWPLKZ
     C                   MOVEL(P)  DSKDEWKDPL    KDEWKDPL
     C                   MOVEL(P)  DSKDEWEZPL    KDEWEZPL
     C                   MOVEL(P)  DSKDEWKZKY    KDEWKZKY
     C                   MOVEL(P)  DSKDEWDUST    KDEWDUST
     C                   MOVEL(P)  DSKDEWRPMG    KDEWRPMG
     C                   MOVEL(P)  DSKDEWFL01    KDEWFL01
     C                   MOVEL(P)  DSKDEWFL02    KDEWFL02
     C                   MOVEL(P)  DSKDEWFL03    KDEWFL03
     C                   MOVEL(P)  DSKDEWFL04    KDEWFL04
     C                   MOVEL(P)  DSKDEWFGZT    KDEWFGZT
     C                   MOVEL(P)  DSKDEWSPTE    KDEWSPTE
     C                   MOVEL(P)  DSKDEWFL05    KDEWFL05
     C                   MOVEL(P)  DSKDEWFL06    KDEWFL06
     C                   MOVEL(P)  DSKDEWFL07    KDEWFL07
     C                   MOVEL(P)  DSKDEWFL08    KDEWFL08
     C                   MOVEL(P)  DSKDEWFL09    KDEWFL09
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KDEWJNAM
     C                   MOVEL(P)  WKCHPN        KDEWPROG
     C                   MOVEL(P)  WKCHPL        KDEWBIBL
     C                   MOVEL(P)  DAUSER        KDEWUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KDEWJZEI
     C                   MOVE      WKTDAT        KDEWJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C                   WHEN      %SUBST(WKKDEW: 56: I1-55) =
     C                             %SUBST(KDEW: 56: I1-55)
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRKDEWKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKDEWKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL     KDKNAM        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE GSKZ                                                   ***
     C**************************************************************************
     C     MCKDEWGSKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWGSKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWGSKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWGSKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWGSKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWGSKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GSKZ                                                   ***
     C**************************************************************************
     C     PRKDEWGSKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWGSKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWGSKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDKR                                                   ***
     C**************************************************************************
     C     MCKDEWKDKR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWKDKR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWKDKR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDKR'        KOM(02)
     C                   MOVEA     DSKDEWKDKR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWKDKR
     C                   MOVEL(P)  TPTTXT        TXKDEWKDKR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDKR                                                   ***
     C**************************************************************************
     C     PRKDEWKDKR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKDKR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSKDEWKDKR    IFNE      *BLANK
     C     DSKDEWGSKZ    OREQ      *ON
     C                   MOVEL(P)  'KDKR'        KYTPTA
     C                   MOVEL(P)  DSKDEWKDKR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKDKR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE BLKZ                                                   ***
     C**************************************************************************
     C     MCKDEWBLKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWBLKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWBLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWBLKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWBLKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWBLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BLKZ                                                   ***
     C**************************************************************************
     C     PRKDEWBLKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWBLKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWBLKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWBLKZ
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE BVKG                                                   ***
     C**************************************************************************
     C     MCKDEWBVKG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWBVKG    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWBVKG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '$$KDEWBVKG'  KOM(01)
     C                   MOVEA     DSKDEWBVKG    KOM(11)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCSYTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  SYTPTCDE      DSKDEWBVKG
     C                   MOVEL(P)  SYTPTTXT      TXKDEWBVKG
     C                   ENDIF
     C*--------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BVKG                                                   ***
     C**************************************************************************
     C     PRKDEWBVKG    BEGSR
     C*
     C     DSKDEWBVKG    IFNE      *BLANK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWBVKG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '$$KDEWBVKG'  KYSYTPTART
     C                   MOVEL(P)  DSKDEWBVKG    KYSYTPTCDE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     SYTPTTXT      TXKDEWBVKG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KSST                                                   ***
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
     C***  PR-ROUTINE KSST                                                   ***
     C**************************************************************************
     C     PRKDEWKSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKSST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSKDEWKSST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKSST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DAGB                                                   ***
     C**************************************************************************
     C     MCKDEWDAGB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWDAGB    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWDAGB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWDAGB    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWDAGB
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWDAGB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DAGB                                                   ***
     C**************************************************************************
     C     PRKDEWDAGB    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWDAGB'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWDAGB    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWDAGB
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE DUST                                                   ***
     C**************************************************************************
     C     MCKDEWDUST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWDUST    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWDUST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWDUST    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWDUST
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWDUST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE DUST                                                   ***
     C**************************************************************************
     C     PRKDEWDUST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWDUST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWDUST    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWDUST
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PLANUNGSKZ                                               ***
     C**************************************************************************
     C     MCKDEWPLKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWPLKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWPLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWPLKZ'    KOM(02)
     C                   MOVEA     DSKDEWPLKZ    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWPLKZ
     C                   MOVEL(P)  TPTTXT        TXKDEWPLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PLANUNGSKZ                                                 ***
     C**************************************************************************
     C     PRKDEWPLKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWPLKZ'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKDEWPLKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDEWPLKZ'    KYTKTA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C*-------------------------------------------------------------------------
     C     DSKDEWPLKZ    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  'KDEWPLKZ'    KYTPTA
     C                   MOVEL(P)  DSKDEWPLKZ    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWPLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSKDEWPLKZ    WHENEQ    '1'
     C     KDKSTC        ANDEQ     *BLANK
     C                   MOVE      '0051'        WKFENR
     C     DSKDEWPLKZ    WHENEQ    '2'
     C     KDKDGR        ANDEQ     *BLANK
     C                   MOVE      '0051'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KUNDENPLANUNG                                            ***
     C**************************************************************************
     C     MCKDEWKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWKDPL    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KDEWKDPL'    KOM(02)
     C                   MOVEA     DSKDEWKDPL    KOM(12)
     C                   EVAL      DUN115      = %DEC(%TRIM(DSKDEWKSST):11:5)
     C                   MOVEA     DUC011        KOM(55)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWKDPL
     C                   MOVEL(P)  TPTTXT        TXKDEWKDPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KUNDENPLANUNG                                              ***
     C**************************************************************************
     C     PRKDEWKDPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKDPL'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKDEWKDPL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDEWKDPL'    KYTKTA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C*-------------------------------------------------------------------------
     C     DSKDEWKDPL    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  'KDEWKDPL'    KYTPTA
     C                   MOVEL(P)  DSKDEWKDPL    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKDPL
     C*--------------------------------------------------------
     C* Prüfen Kosten-Stelle
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   EVAL      DUN115      = %DEC(%TRIM(DSKDEWKSST):11:5)
     C*
     C                   IF        DUN115     <> TPTNUM
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE EZPL                                                   ***
     C**************************************************************************
     C     MCKDEWEZPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWEZPL    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWEZPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWEZPL    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWEZPL
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWEZPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE JNKZ                                                   ***
     C**************************************************************************
     C     PRKDEWEZPL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKDEWEZPL'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWEZPL    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWEZPL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KONZERNSCHLÜSSEL                                         ***
     C**************************************************************************
     C     MCKDEWKZKY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKZKY'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSKDEWKZKY    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXKDEWKZKY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAOKZKY'   KOM(02)
     C                   MOVEA     DSKDEWKZKY    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWKZKY
     C                   MOVEL(P)  TPTTXT        TXKDEWKZKY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONZERNSCHLÜSSEL                                           ***
     C**************************************************************************
     C     PRKDEWKZKY    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKZKY'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKDEWKZKY
     C*-------------------------------------------------------------------------
     C     DSKDEWKZKY    IFEQ      *BLANK
     C                   MOVEL(P)  '$$WAOKZKY'   KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSKDEWKZKY    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$WAOKZKY'   KYTPTA
     C                   MOVEL(P)  DSKDEWKZKY    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKZKY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN RPM-Gruppe                                               ***
     C**************************************************************************
     C     MCKDEWRPMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWRPMG'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSKDEWRPMG    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXKDEWRPMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAORPMG'   KOM(02)
     C                   MOVEA     DSKDEWRPMG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSKDEWRPMG
     C                   MOVEL(P)  TPTTXT        TXKDEWRPMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN RPM-Gruppe                                                 ***
     C**************************************************************************
     C     PRKDEWRPMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWRPMG'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKDEWRPMG
     C*-------------------------------------------------------------------------
     C     DSKDEWRPMG    IFEQ      *BLANK
     C                   MOVEL(P)  '$$WAORPMG'   KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSKDEWRPMG    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$WAORPMG'   KYTPTA
     C                   MOVEL(P)  DSKDEWRPMG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWRPMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE FGZT                                                   ***
     C**************************************************************************
     C     MCKDEWFGZT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWFGZT    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWFGZT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWFGZT    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWFGZT
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWFGZT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE FGZT                                                   ***
     C**************************************************************************
     C     PRKDEWFGZT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKDEWFGZT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWFGZT    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWFGZT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE SPTE                                                   ***
     C**************************************************************************
     C     MCKDEWSPTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWSPTE    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWSPTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWSPTE    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWSPTE
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWSPTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SPTE                                                   ***
     C**************************************************************************
     C     PRKDEWSPTE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKDEWSPTE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWSPTE    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWSPTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDEW'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      KDEW
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'KDEW'        EXDATAFILE
     C                   MOVEL(P)  KDEW          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    KDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KDEWGSKZ      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWGSKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWBLKZ      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWBLKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWDAGB      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWDAGB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWEZPL      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWEZPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWDUST      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWDUST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWFGZT      IFEQ      *BLANK
     C                   MOVEL     *OFF          KDEWFGZT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDEWSPTE      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        KDEWSPTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERM. PFI1-SATZ                                                    ***
     C**************************************************************************
     C     ERMFLD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  EXKDEWKDNR    RTTRNDKEYB
     C                   MOVEL(P)  KDEW          RTTRNDDATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
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
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TRKDEW'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKDEW'      KYTATA
     C                   MOVEL(P)  'KDPL'        KYTATC
     C                   MOVEL(P)  'PLKZ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        WKTRPAPLKZ
     C                   ELSE
     C                   MOVEL(P)  '3'           WKTRPAPLKZ
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
     C                   MOVEL(P)  'TRKDEW'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
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
     C     *LIKE         DEFINE    WKC001        EXFLPOKZIO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAPLKZ
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
     C     *LIKE         DEFINE    KYKDEWKDNR    OFKDEWKDNR
     C     *LIKE         DEFINE    KDEWKDNR      DSKDEWNKDN
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
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
     C                   MOVEL(P)  'TRKDEW'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTKDEWW1
     C                   OTHER
     C                   WRITE     TRKDEWCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTKDEWW1
     C                   OTHER
     C                   WRITE     TRKDEWCT
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
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTK
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCSYTP
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
