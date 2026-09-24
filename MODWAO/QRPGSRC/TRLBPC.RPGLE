     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei LBPC
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 03.11.2003 MOD-Übernahme wegen WAO1
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 20.10.2003 Weaco Projekt 2502
     H*            Umbuchen Pickliste-Nr
     H*  Änderung: ZG 29.11.2004 NEUES PARAM. MODWAO/TRLBPC/UMLSTC FÜR LSST.
     H*  Änderung: ZG 12.05.2005 Weaco Projekt 2984 PICKLISTE 2
     H*  Änderung: ZG 29.07.2005 Weaco WKLBAPBWMG
     H*  ÄNDERUNG: ZG 23.10.2007 Projekt 4483 Kunde Waeco- Text für Löschen
     H*  Änderung: ZG 22.10.2007 Fa.WAECO -Projekt 5467 - Splitung Pickliste
     H*  Änderung: ZG 13.08.2010 Anpassung Standard/trend-Java-Client Projekt 6579
     H*  Änderung: ZG 15.12.2010 WAECO Projekt 6990 - Umstellung Versand
     H*  Änderung: ZG 12.05.2011 Projekt 7238 für Kunde DOMETIC (WAECO). LS-Beistellung
     H*  Änderung: ZG 19.05.2011 DOMETIC Projekt 7184 Lagertrennung, PPL
     H*  Änderung: ZG 13.12.2011 DOMETIC Projekt 8027
     H*  Änderung: ZG 13.04.2012 DOMETIC Projekt 8052 Komm/Liefer-Sperre
     H*  Änderung: ZG 19.07.2012 DOMETIC Projekt 8587
     H*  Änderung: ZG 20.08.2012 DOMETIC Projekt 8762
     H*            Trennung des Picklistendrucks nach Kunden
     H*  Änderung: ZG 14.09.2012 DOMETIC Projekt 8696 Routine G2BGFS
     H*            Gruppenwechsel (neue Pickliste) pro Kunden-Gruppe und pro Referenz_1.
     H*  Änderung: ZG 06.03.2013 DOMETIC Service#: 20130201-006 Status 40 durch 00
     H*            ersetzt
     H*  Änderung: ZG 16.05.2014 DOMETIC - Projekt 10206
     H*            eien Sammelpickliste auf unterschiedlichem Lager
     H*  Änderung: ZG 03.07.2014 DOMETIC - Besuch Routine PRLBPCPPL - PPL-Liste Prüfen
     H*  Änderung: ZG 31.07.2014 DOMETIC - Abschluß Sammelpickliste
     H*  Änderung: ZG 16.02.2015 DOMETIC - Service#: 20150213-006 Leergut - keine Buchung AFUP
     H*  Änderung: ZG 03.03.2015 DOMETIC - Projekt 10787
     H*            Erweiterung des Programm TRLBPC um die Funktionen: Löschung,  Sperrung des
     H*            Lagerplatzes (Gesamt-Bestand des Artikels pro Platz), Reservierung im gleichen
     H*            Lager, Fortschreibung der Pickliste,Umbuchung (Ziel- Versandlager 002) der
     H*            Nachreservierung.
     H*  Änderung: ZG 13.07.2015 DOMETIC - Projekt 11466
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei LBPC.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRLBPCFM  CF   E             WORKSTN USROPN
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
     D LBPC          E DS                  INZ
     D KYLBPC        E DS                  INZ
     D*
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
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
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBVS          E DS                  INZ
     D KYLBVS        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D LBAK          E DS                  INZ
     D KYLBAK        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D WAOR          E DS                  INZ
     D KYWAOR        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXFLPO        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXLBPC        E DS
     D RTLBPC        E DS
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D EXTRPC        E DS                  INZ
     D*
     D EXLBVS        E DS                  INZ
     D RTLBVS        E DS                  INZ
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXLB09        E DS                  INZ
     D*
     D EXBBLP        E DS                  INZ
     D RTBBLP        E DS                  INZ
     D*
     D EXBBKM        E DS                  INZ
     D RTBBKM        E DS                  INZ
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
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D/COPY QCPYSRC,EXUX01
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
     C                   PARM                    EXLBPC
     C                   PARM                    RTLBPC
     C*
     C                   EXSR      UEBLBPC
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     PCPGST        ANDNE     'ENDE  '
     C     PCPGST        ANDNE     'PRUEFE'
     C                   MOVE      '5     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C     WKTRPALSTC    IFEQ      *BLANK
     C                   MOVEL(P)  '960'         WKTRPALSTC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '
     C*
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRLBPCFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '11    '
     C                   MOVE      '02'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UMBUCH'                                     Umbuchen
     C     EXLBPCDANA    ANDEQ     'BGFS      '
     C     PCPGST        OREQ      'UMBUCH'                                     Umbuchen
     C     EXLBPCDANA    ANDEQ     'BGF2      '
     C                   MOVE      '04'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UMBUCH'                                     Umbuchen
     C                   MOVE      '03'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PLBPC '
     C                   EXSR      PLBPC
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PLBAP '
     C                   EXSR      PLBPCLBAP
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BLBPC '
     C                   EXSR      BLBPC
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPAKN '
     C*
     C     DSLBPCPAKN    CASEQ     *BLANK        ERPAKN
     C                   ENDCS
     C                   EXSR      ULBPC
     C                   MOVEL(P)  DSLBPCPAKN    RTLBPCPAKN
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PLBPC
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LLBPC
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '6     '
     C                   EXSR      PLBPC
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      SLBPC
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LLBRS '
     C                   EXSR      PLBPCLBRS
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LLBPCLBRS
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GNLBPC'
     C                   EXSR      GNLBPC
     C*
     C                   MOVE      '00'          WKIFMT
     C                   Z-ADD     KYLBPCPCJJ    RTLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    RTLBPCPCNR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GNBGFS'
     C                   EXSR      GNLBPCBGFS
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'G2BGFS'
     C                   EXSR      G2LBPCBGFS
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRLBVS'
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'DRWAO1'
     C                   EXSR      DRLB09
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ABLBAK'                                      Abschluß LBAK
     C                   EXSR      ABLBAK                                        Status auf 90
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LLBAP '
     C                   EXSR      PLBPCLBAP
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LLBPCLBAP
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LIBBKM'
     C                   EXSR      PLBPCBBKM
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LIBBKM
     C                   ENDIF
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRPPL '
     C                   EXSR      PLBPCPPL
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      TRLBPCFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C     WKIFMT        CASEQ     '04'          BILD04
     C     WKIFMT        CASEQ     '05'          BILD05
     C     WKIFMT        CASEQ     '06'          BILD06
     C     WKIFMT        CASEQ     '07'          BILD07
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C     PCPGST        OREQ      'MUSTER'
     C                   CLOSE     TRLBPCFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
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
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM                     LBPC
     C                   MOVEL(P)  DAFIRM        KYLDFI                         LBSD
     C                   MOVEL(P)  DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL     DAFIRM        KYTUFI                         TEUF
     C                   MOVEL     DAFIRM        KYAMFI                         AFKM
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYWAO1FIRM                     TEIL
     C                   MOVEL     DAFIRM        KYLBAPFIRM                     TEIL
     C                   MOVEL     DAFIRM        KYLBVSFIRM                     TEIL
     C                   MOVEL(P)  DAFIRM        KYLBAKFIRM
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYBBKMFIRM                     BBKM
     C                   MOVEL(P)  DAFIRM        KYWAORFIRM                     WAOR
     C                   MOVEL(P)  DAFIRM        KYLLFI                         LBPL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'LBPC'        EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'TRLBPCS1'    EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEL(P)  EXTRDNTEXT    W3KOPF
     C                   MOVEL(P)  EXTRDNTEXT    W4KOPF
     C                   MOVEL(P)  EXTRDNTEXT    W5KOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBPCS2'    EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEL(P)  EXTRDNTEXT    W2KOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBPCS3'    EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEL(P)  EXTRDNTEXT    W4KOPF
     C                   MOVEL(P)  EXTRDNTEXT    W5KOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBPCFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRLBPCFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXLBPC                         ***
     C**************************************************************************
     C     UEBLBPC       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXLBPCPGST    PCPGST
     C*
     C                   MOVE      EXLBPCTSTP    KYLBPCTSTP
     C                   Z-ADD     EXLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  EXLBPCPCNR    KYLBPCPCNR
     C*
     C                   MOVE      EXLBPCTMST    KYLBPCTMST
     C*
     C                   Z-ADD     EXLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  EXLBPCPCNR    DSLBPCPCNR
     C*
     C                   MOVEL(P)  EXLBPCPAKN    DSLBPCPAKN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL     *ZERO         RTLBPCFENR
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
     C                   MOVE      *OFF          C#LCK2
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C                   MOVE      C#LCK2        WKIN32
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
     C                   MOVE      *ZERO         C#CLEA
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
     C                   WRITE     TRLBPCW2
     C                   WRITE     TRLBPC01
     C                   WRITE     W2LBPCB3
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRLBPC01                             9899
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
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    '2     '
     C                   EXSR      ULBRS
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '0003'        WKFENR
     C                   ITER
     C                   ENDIF
     C*
     C     DSLBPCSTAT    IFEQ      '50'
     C     DSLBPCZULG    ANDEQ     LBPCLANR
     C     DSLBPCZULO    ANDEQ     LBPCLORT
     C     LBPCRSMG      ANDGT     DSLBPCRSMG
     C                   MOVEL(P)  LBPCLANR      KYLDLA
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBSD
     C     LDHLSL        IFGT      *BLANK
     C                   MOVEL     LDHLSL        LBPCZULG
     C                   MOVEL     *BLANK        LBPCZULO
     C     LBPCRSMG      SUB       DSLBPCRSMG    LBPCRSMG
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDSL
     C*
     C                   EXSR      ULBPC
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C                   MOVE      *BLANK        KYLBPCPCJJ
     C                   MOVE      *BLANK        KYLBPCPCNR
     C                   EXSR      B01DS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHLBPC
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHLBPC
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
     C                   MOVE      WKIN32        C#LCK2
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVEL(P)  LBPCUSER      WKUSER
     C                   Z-ADD     LBPCJDAT      WKJDAT
     C                   Z-ADD     LBPCJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHLBPC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     LBPCPCJJ      DSLBPCPCJJ
     C                   MOVEL(P)  LBPCPCNR      DSLBPCPCNR
     C                   Z-ADD     LBPCAFJJ      DSLBPCAFJJ
     C                   MOVEL     LBPCAFNR      DSLBPCAFNR
     C                   Z-ADD     LBPCAFPO      DSLBPCAFPO
     C                   Z-ADD     LBPCAFUP      DSLBPCAFUP
     C                   MOVEL     LBPCJAHR      DSLBPCJAHR
     C                   MOVEL     LBPCNMKR      DSLBPCNMKR
     C                   Z-ADD(H)  LBPCPOSI      DSLBPCPOSI
     C                   MOVEL(P)  LBPCPAKN      DSLBPCPAKN
     C                   MOVEL(P)  LBPCZULG      DSLBPCZULG
     C                   MOVEL(P)  LBPCZULO      DSLBPCZULO
     C                   MOVEL(P)  LBPCTENR      DSLBPCTENR
     C                   Z-ADD     LBPCGEWI      DSLBPCGEWI
     C                   Z-ADD     LBPCRSMG      DSLBPCRSMG
     C                   MOVEL(P)  LBPCSTAT      DSLBPCSTAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LBPCSTAT'    EXTRPCPGGR
     C                   MOVEL(P)  LBPCSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXLBPCSTAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBPCZULG      KYLDLA
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBSD
     C                   MOVEL(P)  TPTTXT        TXLBPCZULG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBPC01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
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
     C                   MOVE      *ON           C#LCK2
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C     LBPCSTAT      IFGT      '50'
     C                   MOVE      *ON           C#LCK2
     C                   ENDIF
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C                   MOVE      *ON           C#LCK2
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
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
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCPCJJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCPCNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFEQ      *BLANK
     C*--------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C                   LEAVE
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCRSMG
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCGEWI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
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
     C                   WRITE     TRLBPCW1
     C                   WRITE     TRLBPC02
     C                   WRITE     W1LBPCB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRLBPC02                             9899
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
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   MOVEL(P)  KYLBPCPCJJ    RTLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    RTLBPCPCNR
     C                   MOVEL(P)  KYLBPCPAKN    RTLBPCPAKN
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
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
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C*
     C                   MOVE      *BLANK        DSLBPCPAKN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD02                                          ***
     C**************************************************************************
     C     B02PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCPAKN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    KYLBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     LBPCFIRM      ANDEQ     KYLBPCFIRM
     C     LBPCPCJJ      ANDEQ     KYLBPCPCJJ
     C     LBPCPCNR      ANDEQ     KYLBPCPCNR
     C     LBPCPAKN      ANDEQ     KYLBPCPAKN
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C                   LEAVE
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
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
     C                   WRITE     TRLBPCW1
     C                   WRITE     TRLBPC03
     C                   WRITE     W1LBPCB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRLBPC03                             9899
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
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C                   EXSR      B03PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      UMLBPC                                       Umbuchen
     C*-------------------------------------------------------------------------
     C                   EXSR      B03DS
     C*
     C                   MOVE      '9132'        WKFENR
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
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
     C                   Z-ADD     *ZERO         DSLBPCPCJJ
     C                   MOVE      *BLANK        DSLBPCPCNR
     C*
     C                   MOVE      *BLANK        DSLBPCPAKN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD03                                          ***
     C**************************************************************************
     C     B03PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCPCJJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBPCPCNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      P1LBPCPAKN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    KYLBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   LEAVE
     C*
     C     LBPCFIRM      WHENGT    KYLBPCFIRM
     C     LBPCPCJJ      ORGT      KYLBPCPCJJ
     C     LBPCPCNR      ORGT      KYLBPCPCNR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     LBPCPAKN      WHENGT    KYLBPCPAKN
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     LBPCSTAT      WHENGE    '50'
     C                   MOVEL(P)  'LBPCSTAT'    EXTRPCPGGR
     C                   MOVEL(P)  LBPCSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEA(P)  EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0014'        WKFENR
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      PRLBLB
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD04                                              ***
     C**************************************************************************
     C     BILD04        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B04DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '04'
     C*
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   MOVEL(P)  'T4'          WKIFMT
     C                   EXSR      EFLPO
     C                   MOVEL(P)  FMT(FM)       WKIFMT
     C                   WRITE     TRLBPCT4
     C                   OTHER
     C                   EXSR      EFLPO
     C                   WRITE     TRLBPC04
     C                   ENDSL
     C*
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   READ      TRLBPCT4                             9899
     C                   OTHER
     C                   READ      TRLBPC04                             9899
     C                   ENDSL
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
     C     DAPROG        IFEQ      'TRLBPCS4'
     C                   MOVEL(P)  'T4'          WKIFMT
     C                   ENDIF
     C                   EXSR      MCAUFR
     C                   MOVEL     '04'          WKIFMT
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C                   EXSR      B04PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '05'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 04                                        ***
     C**************************************************************************
     C     B04DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD04                                          ***
     C**************************************************************************
     C     B04PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '00'          KYLBPCSTAT
     C                   MOVEL(P)  DSLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    KYLBPCPCNR
     C                   MOVEL(P)  *LOVAL        KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     LBPCFIRM      ORNE      KYLBPCFIRM
     C     LBPCSTAT      ORNE      KYLBPCSTAT
     C     LBPCPCJJ      ORNE      KYLBPCPCJJ
     C     LBPCPCNR      ORNE      KYLBPCPCNR
     C                   MOVE      '9124'        WKFENR
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD05                                              ***
     C**************************************************************************
     C     BILD05        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B05DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '05'
     C*
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   MOVEL(P)  'T5'          WKIFMT
     C                   EXSR      EFLPO
     C                   MOVEL(P)  FMT(FM)       WKIFMT
     C                   WRITE     TRLBPCT5
     C                   OTHER
     C                   EXSR      EFLPO
     C                   WRITE     TRLBPC05
     C                   ENDSL
     C*
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   READ      TRLBPCT5                             9899
     C                   OTHER
     C                   READ      TRLBPC05                             9899
     C                   ENDSL
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
     C     DAPROG        IFEQ      'TRLBPCS4'
     C                   MOVEL(P)  'T5'          WKIFMT
     C                   ENDIF
     C                   EXSR      MCAUFR
     C                   MOVEL     '05'          WKIFMT
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C                   EXSR      B05PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '06'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 05                                        ***
     C**************************************************************************
     C     B05DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C                   MOVE      *BLANK        D1LBPCTMST
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ZERO         WKFENR
     C     #CRTCD        IFEQ      'W'
     C                   MOVE      '9132'        WKFENR
     C                   ENDIF
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'D1LBPCTMST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD05                                          ***
     C**************************************************************************
     C     B05PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVE      D1LBPCTMST    KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   LEAVE
     C*
     C     LBPCFIRM      WHENGT    KYLBPCFIRM
     C     LBPCTMST      ORGT      KYLBPCTMST
     C     LBPCPCJJ      ORNE      DSLBPCPCJJ
     C     LBPCPCNR      ORNE      DSLBPCPCNR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'D1LBPCTMST'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     LBPCSTAT      WHENGE    '50'
     C                   MOVEL(P)  'LBPCSTAT'    EXTRPCPGGR
     C                   MOVEL(P)  LBPCSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEA(P)  EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0014'        WKFENR
     C                   MOVEL(P)  'D1LBPCTMST'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD(H)  LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'D1LBPCTMST'  EXFLPOFLDN
     C                   MOVE      '2318'        WKFENR
     C                   LEAVE
     C     LBRSSTAT      WHENGE    '90'
     C                   MOVE      '9133'        WKFENR
     C                   MOVEL(P)  'D1LBPCTMST'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD06                                              ***
     C**************************************************************************
     C     BILD06        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B06DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '06'
     C*
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   MOVEL(P)  'T6'          WKIFMT
     C                   EXSR      EFLPO
     C                   MOVEL(P)  FMT(FM)       WKIFMT
     C                   WRITE     TRLBPCT7
     C                   OTHER
     C                   EXSR      EFLPO
     C                   WRITE     TRLBPC07
     C                   ENDSL
     C*
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT08
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   READ      TRLBPCT7                             9899
     C                   OTHER
     C                   READ      TRLBPC07                             9899
     C                   ENDSL
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
     C     DAPROG        IFEQ      'TRLBPCS4'
     C                   MOVEL(P)  'T6'          WKIFMT
     C                   ENDIF
     C                   EXSR      MCAUFR
     C                   MOVEL     '06'          WKIFMT
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#DETA        WHENEQ    *ON
     C     FUKT08        ANDEQ     *ON
     C     DSLBPCRSMG    ANDGT     *ZERO
     C*weiter
     C     C#DETA        WHENEQ    *ON
     C     FUKT08        ANDEQ     *ON
     C     DSLBPCRSMG    ANDEQ     *ZERO
     C*
     C                   EXSR      B06PR
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  LBPCZULG      DSLBPCZULG
     C                   MOVEL(P)  LBPCZULO      DSLBPCZULO
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C* Gibt es eine Reservierung
     C                   MOVE      D1LBPCTMST    LBRSTMST
     C                   EXSR      DLBRS                                        Löschen Reservierung
     C                   MOVE      D1LBPCTMST    KYLBPCTMST
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '09CU    '    CHI
     C                   EXSR      CHLBPC
     C                   MOVEA     '09D     '    CHI
     C                   EXSR      CHLBPC
     C*
     C                   EXSR      TRLBB1                                       Sperren
     C*REservieren
     C                   EXSR      GNLBRS                                       Reservieren
     C*
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B06PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHLBPC
     C     CHI(5)        IFEQ      'L'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      '0001'        WKFENR
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBPCZULG      DSLBPCLANR
     C     LBPCBSLA      IFNE      *BLANK
     C                   MOVEL(P)  LBPCZULG      DSLBPCBSLA
     C                   ELSE
     C                   MOVEL(P)  *BLANK        DSLBPCBSLA
     C                   ENDIF
     C                   MOVEL(P)  LBPCZULO      DSLBPCLORT
     C*
     C                   EXSR      ULBRS
     C*--------------------------------------------------------
     C                   SELECT
     C     DSLBPCRSMG    WHENEQ    *ZERO
     C     TEKLSP        ANDEQ     *ON
     C                   OTHER
     C     WKTRPALSTC    IFEQ      *BLANK
     C                   MOVEL(P)  '960'         WKTRPALSTC
     C                   ENDIF
     C                   Z-ADD     DSLBPCRSMG    LBPCRSMG
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  '50'          DSLBPCSTAT
     C                   ELSE
     C                   MOVEL(P)  '00'          DSLBPCSTAT
     C                   MOVEL(P)  LBPCLANR      DSLBPCLANR
     C                   MOVEL(P)  LBPCBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBPCLORT      DSLBPCLORT
     C                   EXSR      ULBRS
     C                   ENDIF
     C*
     C                   EXSR      ULBPC
     C*
     C     RTLBFENR      IFNE      *ZERO
     C     DSLBPCSTAT    ANDEQ     '00'
     C                   MOVE      '9118'        WKFENR
     C                   MOVEL(P)  RTLBFFLD      W$PA03
     C                   ITER
     C                   ENDIF
     C*
     C     DSLBPCRSMG    IFLT      WKLBRSRSMG
     C     C#DETA        ANDEQ     *ON
     C*
     C                   MOVEL(P)  LBPCZULG      DSLBPCZULG
     C                   MOVEL(P)  LBPCZULO      DSLBPCZULO
     C*Sperren Platz
     C                   EXSR      TRLBB1                                       Sperren Platz
     C*REservieren
     C                   EVAL      WKLBRSRSMG = WKLBRSRSMG-DSLBPCRSMG
     C                   EXSR      GNLBRS                                       Reservieren
     C*
     C                   ENDIF
     C*
     C                   SELECT
     C     TEKLSP        WHENEQ    *ON
     C     TEVSKZ        ANDEQ     DAJNKZ
     C*
     C     TEVSKZ        WHENEQ    DAJNKZ
     C     MODWAO        ANDEQ     *OFF                                         Deaktiviert
     C                   MOVEL(P)  'UMAFUP'      #CPGST
     C                   EXSR      TRAFUP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      'W'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C*
     C*-------------------------------------------------------------------------
     C     MODWAO        IFEQ      *ON
     C     LBPCDANA      ANDNE     'BGF2      '
     C                   MOVEL(P)  'UPWAO1'      #CPGST                         Update Status
     C                   EXSR      MOWAO1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MOWAO1    Update WAO1                                             ***
     C**************************************************************************
     C     MOWAO1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     LBPCJAHR      DUN040
     C                   MOVEA     DUC004        KOM(01)
     C                   MOVEA     LBPCNMKR      KOM(05)
     C                   Z-ADD     LBPCPOSI      DUN050
     C                   MOVEA     DUC005        KOM(11)
     C                   MOVEA     KOM           EXTRNDKEYB
     C*
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     DSLBPCRSMG    DUN112
     C                   MOVEA     DUC011        KOM(01)
     C                   MOVEA     TEMEIN        KOM(12)
     C                   MOVEA     KOM           EXTRNDDATE
     C*
     C                   MOVEL(P)  #CPGST        EXTRNDPGST
     C*
     C                   CALL      'MOWAO1   '                          99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTTRNDPROG    WKPROG
     C                   MOVEL     RTTRNDDANA    WKDANA
     C                   MOVEL     RTTRNDFFLD    WKFFLD
     C                   MOVEL     RTTRNDFENR    WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 06                                        ***
     C**************************************************************************
     C     B06DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   Z-ADD     LBRSRSMG      WKLBRSRSMG
     C*
     C                   MOVEL     LBRSLANR      DSLBPCLANR
     C                   MOVEL     LBRSLORT      DSLBPCLORT
     C                   MOVEL     LBRSTENR      DSLBPCTENR
     C*
     C                   MOVEL     DSLBPCTENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ                         LESEN
     C                   MOVEA     '01C     '    CHI                            TEILESTAMM
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCLANR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANKS       DSLANR
     C                   MOVEL(P)  *BLANKS       DSLORT
     C                   MOVEL(P)  *BLANKS       DSTENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD06                                          ***
     C**************************************************************************
     C     B06PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLBPCTENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     DSLBPCRSMG    IFEQ      *ZERO
     C     C#DETA        ANDNE     *ON
     C     TEKLSP        ANDNE     *ON
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9168'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C     DSLBPCRSMG    IFNE      *ZERO
     C     TEKLSP        ANDEQ     *ON
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9238'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      D1LBPCTMST    KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9168'        WKFENR
     C                   LEAVE
     C*
     C     LBPCFIRM      WHENGT    KYLBPCFIRM
     C     LBPCTMST      ORGT      KYLBPCTMST
     C     LBPCPCJJ      ORNE      DSLBPCPCJJ
     C     LBPCPCNR      ORNE      DSLBPCPCNR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     LBPCSTAT      WHENGE    '50'
     C                   MOVEL(P)  'LBPCSTAT'    EXTRPCPGGR
     C                   MOVEL(P)  LBPCSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEA(P)  EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0014'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     DSLBPCRSMG    WHENGT    LBPCRSMG
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9163'        WKFENR
     C                   LEAVE
     C*
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*                  MOVE      'PRLBLB'      #CPGST
     C*                  Z-ADD     DSLBPCRSMG    LBPCRSMG
     C*                  EXSR      TRLBLB
     C*
     C*    WKFENR        IFNE      *ZERO
     C*                  MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C*                  LEAVE
     C*                  ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '2318'        WKFENR
     C                   LEAVE
     C     LBRSSTAT      WHENGE    '90'
     C                   MOVE      '9133'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     DSTENR        IFNE      *BLANKS
     C                   MOVEL     DSTENR        KYTEEA
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '91C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSTENR
     C*
     C                   ELSE
     C*
     C                   MOVEL     DSTENR        KYTENR                         PRÜFEN TEILE-
     C                   MOVEL     *BLANK        KYTEEZ                         NUMMER OB
     C                   MOVEA     '01C     '    CHI                            VORHANDEN
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TETENR        DSTENR
     C                   ELSE
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSLBPCLANR    IFNE      DSLANR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSLANR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C     DSLBPCLORT    IFNE      DSLORT
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSLANR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C     DSLBPCTENR    IFNE      DSTENR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD07                                              ***
     C**************************************************************************
     C     BILD07        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B07DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '07'
     C*
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   MOVEL(P)  'T8'          WKIFMT
     C                   EXSR      EFLPO
     C                   WRITE     TRLBPCT8
     C                   OTHER
     C                   MOVEL(P)  '08'          WKIFMT
     C                   EXSR      EFLPO
     C                   WRITE     TRLBPC08
     C                   ENDSL
     C                   MOVEL(P)  '07'          WKIFMT
     C*
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DAPROG        WHENEQ    'TRLBPCS4'
     C                   READ      TRLBPCT8                             9899
     C                   OTHER
     C                   READ      TRLBPC08                             9899
     C                   ENDSL
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
     C     DAPROG        IFEQ      'TRLBPCS4'
     C                   MOVEL(P)  'T8'          WKIFMT
     C                   ELSE
     C                   MOVEL(P)  '08'          WKIFMT
     C                   ENDIF
     C                   EXSR      MCAUFR
     C                   MOVEL     '07'          WKIFMT
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
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
     C                   EXSR      B07PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHLBPC
     C     CHI(5)        IFEQ      'L'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      '0001'        WKFENR
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBPCZULG      DSLBPCLANR
     C     LBPCBSLA      IFNE      *BLANK
     C                   MOVEL(P)  LBPCZULG      DSLBPCBSLA
     C                   ELSE
     C                   MOVEL(P)  *BLANK        DSLBPCBSLA
     C                   ENDIF
     C                   MOVEL(P)  LBPCZULO      DSLBPCLORT
     C*
     C                   EXSR      ULBRS
     C*--------------------------------------------------------
     C                   SELECT
     C     DSLBPCRSMG    WHENEQ    *ZERO
     C     TEKLSP        ANDEQ     *ON
     C                   OTHER
     C     WKTRPALSTC    IFEQ      *BLANK
     C                   MOVEL(P)  '960'         WKTRPALSTC
     C                   ENDIF
     C                   Z-ADD     DSLBPCRSMG    LBPCRSMG
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  '50'          DSLBPCSTAT
     C                   ELSE
     C                   MOVEL(P)  '00'          DSLBPCSTAT
     C                   MOVEL(P)  LBPCLANR      DSLBPCLANR
     C                   MOVEL(P)  LBPCBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBPCLORT      DSLBPCLORT
     C                   EXSR      ULBRS
     C                   ENDIF
     C*
     C                   EXSR      ULBPC
     C*
     C     RTLBFENR      IFNE      *ZERO
     C     DSLBPCSTAT    ANDEQ     '00'
     C                   MOVE      '9118'        WKFENR
     C                   MOVEL(P)  RTLBFFLD      W$PA03
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      'W'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTLBPCRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 07                                        ***
     C**************************************************************************
     C     B07DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C*
     C                   MOVEL     LBRSLANR      DSLBPCLANR
     C                   MOVEL     LBRSLORT      DSLBPCLORT
     C                   MOVEL     LBRSTENR      DSLBPCTENR
     C*
     C                   MOVEL     DSLBPCTENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ                         LESEN
     C                   MOVEA     '01C     '    CHI                            TEILESTAMM
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLANR    '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANKS       DSLANR
     C                   MOVEL(P)  *BLANKS       DSLORT
     C                   MOVEL(P)  *BLANKS       DSTENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD07                                          ***
     C**************************************************************************
     C     B07PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSLBPCTENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     DSLBPCRSMG    IFEQ      *ZERO
     C     TEKLSP        ANDNE     *ON
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9168'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*
     C     DSLBPCRSMG    IFNE      *ZERO
     C     TEKLSP        ANDEQ     *ON
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9238'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      D1LBPCTMST    KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9168'        WKFENR
     C                   LEAVE
     C*
     C     LBPCFIRM      WHENGT    KYLBPCFIRM
     C     LBPCTMST      ORGT      KYLBPCTMST
     C     LBPCPCJJ      ORNE      DSLBPCPCJJ
     C     LBPCPCNR      ORNE      DSLBPCPCNR
     C                   MOVE      '0031'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     LBPCSTAT      WHENGE    '50'
     C                   MOVEL(P)  'LBPCSTAT'    EXTRPCPGGR
     C                   MOVEL(P)  LBPCSTAT      EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEA(P)  EXTRPCTEXT    W99
     C                   MOVEA     W99(1)        W$PA03
     C                   MOVEA     W99(11)       W$PA04
     C                   MOVE      '0014'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C*
     C     DSLBPCRSMG    WHENGT    LBPCRSMG
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '9163'        WKFENR
     C                   LEAVE
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   MOVE      '2318'        WKFENR
     C                   LEAVE
     C     LBRSSTAT      WHENGE    '90'
     C                   MOVE      '9133'        WKFENR
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     DSLBPCLANR    IFNE      DSLANR
     C                   MOVE      '9105'        WKFENR
     C                   MOVEL(P)  'DSLANR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C     DSLBPCLORT    IFNE      DSLORT
     C                   MOVE      '9107'        WKFENR
     C                   MOVEL(P)  'DSLANR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C     DSLBPCTENR    IFNE      DSTENR
     C                   MOVE      '9101'        WKFENR
     C                   MOVEL(P)  'DSTENR'      EXFLPOFLDN
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PROBEBUCHUNG                                                      ***
     C**************************************************************************
     C     PRLBLB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    KYLBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCPCJJ      ORGT      KYLBPCPCJJ
     C     LBPCPCNR      ORGT      KYLBPCPCNR
     C     LBPCPAKN      ORGT      KYLBPCPAKN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      'PRLBLB'      #CPGST
     C                   EXSR      TRLBLB
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD(H)  LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '2318'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Es muß jedes im Format vorhandene Feld abgefragt werden, sonst wird
     C*  der Cursor falsch positioniert. Ebenso müssen die Felder zusätzlich
     C*  mit den im Format verwendeten Bezugszahlen zum Sperren (*IN30 - *IN39)
     C*  abgefragt werden, da sonst F4 bei einem gesperrten Feld ausgeführt
     C*  werden kann und die weiteren Aktionen nicht mehr kontrollierbar sind
     H*  (Update des gesperrten Feldes).
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
     C     FLDNAM        ANDEQ     'DSLBPCPCJJ'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCPCJJ'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCPCNR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCPCNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCPAKN'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCGEWI'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCGEWI'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCJAHR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCJAHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCNMKR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCNMKR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCPOSI'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCPOSI'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCAFJJ'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCAFJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCAFNR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCAFNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCAFPO'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCAFPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCZULG'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCZULG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSLBPCZULO'
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSLBPCZULO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB LBPC-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PLBPC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYLBPCTSTP    OFLBPCTSTP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCTSTP      ORGT      OFLBPCTSTP
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'LBPCLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFGT      '50'
     C                   MOVEL(P)  '0014'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFLT      '50'
     C     PCPGST        ANDEQ     '6     '                                     Storno
     C                   MOVEL(P)  '0014'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI LBPC                                          ***
     C**************************************************************************
     C     LLBPC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYLBPCTSTP    OFLBPCTSTP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCTSTP      ORGT      OFLBPCTSTP
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBPCZULG      WKLBPCZULG        4
     C                   MOVEL(P)  LBPCZULO      WKLBPCZULO        8
     C*
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBPC
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C     PCPGST        IFEQ      '4     '
     C     MODWAO        ANDEQ     *ON
     C                   EXSR      USTAT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STORNO                                                            ***
     C**************************************************************************
     C     SLBPC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYLBPCTSTP    OFLBPCTSTP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCTSTP      ORGT      OFLBPCTSTP
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBPCABLA      DSLBPCLANR
     C                   MOVEL(P)  LBPCABBL      DSLBPCBSLA
     C                   MOVEL(P)  LBPCABLO      DSLBPCLORT
     C                   Z-ADD     LBPCRSMG      DSLBPCRSMG
     C                   EXSR      ULBRS
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBPCABLA      LBPCZULG
     C                   MOVEL(P)  LBPCABLO      LBPCZULO
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  '00'          DSLBPCSTAT
     C                   ELSE
     C                   MOVEL(P)  '50'          DSLBPCSTAT
     C                   MOVEL(P)  LBPCLANR      DSLBPCLANR
     C                   MOVEL(P)  LBPCBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBPCLORT      DSLBPCLORT
     C                   EXSR      ULBRS
     C                   ENDIF
     C*
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   EXSR      ULBPC
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBVS                                                 ***
     C**************************************************************************
     C     TRLBVSBGFS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LORT '       EXLBVSPGST
     C                   MOVEL(P)  WKLBPCZULG    EXLBVSLANR
     c                   MOVEL(P)  WKLBPCZULO    EXLBVSLORT
     C*
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLBVSPROG    WKPROG
     C                   MOVEL(P)  RTLBVSDANA    WKDANA
     C                   MOVEL(P)  RTLBVSFFLD    WKFFLD
     C                   MOVEL(P)  RTLBVSFENR    WKFENR
     C                   MOVEL(P)  RTLBVSPA03    W$PA03
     C                   MOVEL(P)  RTLBVSPA04    W$PA04
     C                   MOVEL(P)  RTLBVSPA05    W$PA05
     C                   MOVEL(P)  RTLBVSPA06    W$PA06
     C                   MOVEL(P)  RTLBVSPA07    W$PA07
     C*
     C                   MOVEL(P)  RTLBVSRTCD    #CRTCD
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STATUS IN SCHNITTSTELLENDATEI ZURÜCKSETZEN                        ***
     C**************************************************************************
     C     USTAT         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     LBPCJAHR      KYLBPCJAHR
     C                   MOVEL(P)  LBPCNMKR      KYLBPCNMKR
     C                   Z-ADD     LBPCPOSI      KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTMST
     C*
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C     WKFENR        IFEQ      *ZEROS
     C     KYLBPCFIRM    ANDEQ     LBPCFIRM
     C     KYLBPCJAHR    ANDEQ     LBPCJAHR
     C     KYLBPCNMKR    ANDEQ     LBPCNMKR
     C     KYLBPCPOSI    ANDEQ     LBPCPOSI
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYLBPCJAHR    KYWAO1LIJJ
     C                   MOVEL(P)  KYLBPCNMKR    KYWAO1LINR
     C                   Z-ADD     KYLBPCPOSI    KYWAO1RALP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO1
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVEL(P)  '88'          WAO1UEST
     C                   EVAL      WAO1FREX = EXLBPCSTKZ + EXLBPCBEME
     C*
     C                   MOVEL(P)  DAJNAM        WAO1JNAM
     C                   MOVEL(P)  WKCHPN        WAO1PROG
     C                   MOVEL(P)  WKCHPL        WAO1BIBL
     C                   MOVEL(P)  DAUSER        WAO1USER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO1JZEI
     C                   MOVE      WKTDAT        WAO1JDAT
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO1
     C*
     C                   EXSR      TRLBVSBGFS
     C*
     C                   ENDIF
     C*
     C                   MOVEL(P)  'BGFS'        KYLBAPDANA
     C                   Z-ADD     KYLBPCJAHR    KYLBAPJAHR
     C                   MOVEL(P)  KYLBPCNMKR    KYLBAPNMKR
     C                   Z-ADD     KYLBPCPOSI    KYLBAPPOSI
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAP
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBAP
     C                   ENDIF
     C*
     C                   MOVEL     *ZEROS        WKFENR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB LBPC-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PLBPCLBRS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYLBPCTMST    OFLBPCTMST
     C                   MOVE      *LOVAL        OFLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCTMST      ORGT      OFLBPCTMST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'LBPCLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFGT      '50'
     C                   MOVEL(P)  '0014'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '09R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI LBPC                                          ***
     C**************************************************************************
     C     LLBPCLBRS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      KYLBPCTMST    OFLBPCTMST
     C                   MOVE      *LOVAL        OFLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCTMST      ORGT      OFLBPCTMST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBPC
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   MOVEA     '09R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
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
     C                   Z-ADD(H)  LBPCTMST      LBRSTMST
     C                   EXSR      DLBRS
     C*-------------------------------------------------------------------------
     C     LBPCDANA      IFEQ      'BGFS      '
     C                   MOVEL(P)  'STBGFS'      #CPGST
     C                   EXSR      TRLBAP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     LBPCSTAT      IFEQ      '50'
     C     LBPCLANR      ANDEQ     LBPCZULG
     C*UMBUCHEN 902
     C                   MOVEL(P)  LBPCLANR      KYLDLA
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBSD
     C*
     C                   IF        LDHLSL<>*BLANK
     C                   MOVEL(P)  LDHLSL        LBPCZULG
     C                   MOVEL(P)  *BLANK        LBPCZULO
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUFEN POSITIONEN LBAP                                          ***
     C**************************************************************************
     C     TRLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  LBPCDANA      KOM(01)
     C                   MOVE      LBPCJAHR      DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA(P)  LBPCNMKR      KOM(15)
     C                   Z-ADD     LBPCPOSI      DUN050
     C                   MOVEA(P)  DUC005        KOM(21)
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'TRLBAP'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBPC                                                 ***
     C**************************************************************************
     C     ULBPC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'UPSTAT'
     C                   MOVEL(P)  DSLBPCSTAT    LBPCSTAT
     C     PCPGST        WHENEQ    'UMBUCH'
     C     PCPGST        OREQ      '6     '
     C                   MOVEL(P)  DSLBPCSTAT    LBPCSTAT
     C                   MOVEL(P)  DSLBPCLANR    LBPCLANR
     C                   MOVEL(P)  DSLBPCBSLA    LBPCBSLA
     C                   MOVEL(P)  DSLBPCLORT    LBPCLORT
     C     LBPCDANA      IFEQ      'BGFS      '
     C     LBPCDANA      OREQ      'BGF2      '
     C     MODWAO        OREQ      *ON
     C                   Z-ADD     DSLBPCRSMG    LBPCRSMG
     C                   ENDIF
     C*
     C     PCPGST        WHENEQ    'UPAKN '
     C                   MOVEL(P)  DSLBPCPAKN    LBPCPAKN
     C*
     C     PCPGST        WHENEQ    'GNLBPC'
     C     PCPGST        OREQ      'GNBGFS'
     C     PCPGST        OREQ      'G2BGFS'
     C                   Z-ADD     DSLBPCPCJJ    LBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    LBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    LBPCPAKN
     C                   MOVEL(P)  DSLBPCSTAT    LBPCSTAT
     C*
     C                   MOVEL(P)  DSLBPCDANA    LBPCDANA
     C                   Z-ADD     DSLBPCJAHR    LBPCJAHR
     C                   MOVEL(P)  DSLBPCNMKR    LBPCNMKR
     C                   Z-ADD     DSLBPCPOSI    LBPCPOSI
     C*
     C                   MOVEL(P)  DSLBPCAFDN    LBPCAFDN
     C                   Z-ADD     DSLBPCAFJJ    LBPCAFJJ
     C                   MOVEL(P)  DSLBPCAFNR    LBPCAFNR
     C                   Z-ADD     DSLBPCAFPO    LBPCAFPO
     C                   Z-ADD     DSLBPCAFUP    LBPCAFUP
     C*
     C                   MOVEL(P)  DSLBPCBSTY    LBPCBSTY
     C                   MOVEL(P)  DSLBPCWKNR    LBPCWKNR
     C                   MOVEL(P)  DSLBPCKDNR    LBPCKDNR
     C                   MOVEL(P)  DSLBPCLFNR    LBPCLFNR
     C                   MOVEL(P)  DSLBPCLANR    LBPCLANR
     C                   MOVEL(P)  DSLBPCBSLA    LBPCBSLA
     C                   MOVEL(P)  DSLBPCTENR    LBPCTENR
     C                   MOVEL(P)  DSLBPCFBNR    LBPCFBNR
     C*
     C                   MOVEL(P)  DSLBPCGEBI    LBPCGEBI
     C                   MOVEL(P)  DSLBPCCONT    LBPCCONT
     C                   MOVEL(P)  DSLBPCBHNR    LBPCBHNR
     C                   MOVEL(P)  DSLBPCLORT    LBPCLORT
     C                   MOVEL(P)  DSLBPCCHAR    LBPCCHAR
     C                   MOVEL(P)  DSLBPCFUMG    LBPCFUMG
     C                   MOVEL(P)  DSLBPCMEIN    LBPCMEIN
     C*
     C                   MOVEL(P)  DSLBPCBSLA    LBPCABBL
     C                   MOVEL(P)  DSLBPCLANR    LBPCABLA
     C                   MOVEL(P)  DSLBPCLORT    LBPCABLO
     C*
     C                   MOVEL(P)  DSLBPCZULG    LBPCZULG
     C                   MOVEL(P)  DSLBPCZULO    LBPCZULO
     C*
     C                   Z-ADD     DSLBPCRSMG    LBPCRSMG
     C                   Z-ADD     DSLBPCGEWI    LBPCGEWI
     C                   Z-ADD     DSLBPCTMST    LBPCTMST
     C*
     C                   OTHER
     C                   MOVEL(P)  DSLBPCPAKN    LBPCPAKN
     C                   Z-ADD     DSLBPCGEWI    LBPCGEWI
     C                   Z-ADD     DSLBPCRSMG    LBPCRSMG
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        LBPCJNAM
     C                   MOVEL(P)  WKCHPN        LBPCPROG
     C                   MOVEL(P)  WKCHPL        LBPCBIBL
     C                   MOVEL(P)  DAUSER        LBPCUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBPCJZEI
     C                   MOVE      WKTDAT        LBPCJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    LBPCTSTP
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     PCPGST        IFEQ      'GNBGFS'
     C     LBPCDANA      ANDEQ     'BGFS'
     C                   EXSR      ULBAPBGFS
     C                   ENDIF
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBPC
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Update  LBAP Waeco                                                ***
     C**************************************************************************
     C     ULBAPBGFS     BEGSR
     C*
     C                   MOVEL(P)  'BGFS'        KYLBAPDANA
     C                   Z-ADD     LBPCJAHR      KYLBAPJAHR
     C                   MOVEL(P)  LBPCNMKR      KYLBAPNMKR
     C                   Z-ADD     LBPCPOSI      KYLBAPPOSI
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAP
     C     WKFENR        IFEQ      *ZEROS
     C*
     C                   Z-ADD     LBPCPCJJ      LBAPKMJJ
     C                   MOVEL(P)  LBPCPCNR      LBAPKMNR
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBAP
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Update  LBRS                                                      ***
     C**************************************************************************
     C     ULBRS         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD(H)  LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C*
     C                   SELECT
     C     PCPGST        WHENEQ    'UMBUCH'
     C     PCPGST        OREQ      '6     '
     C                   MOVEL(P)  DSLBPCLANR    LBRSLANR
     C                   MOVEL(P)  DSLBPCBSLA    LBRSBSLA
     C                   MOVEL(P)  DSLBPCLORT    LBRSLORT
     C     LBRSDANA      IFEQ      'BGFS      '
     C     LBRSDANA      OREQ      'BGF2      '
     C     MODWAO        OREQ      *ON
     C                   Z-ADD     DSLBPCRSMG    LBRSRSMG
     C                   ENDIF
     C*
     C     PCPGST        WHENEQ    '2     '
     C                   Z-ADD     DSLBPCRSMG    LBRSRSMG
     C                   ENDSL
     C*
     C                   MOVEL(P)  DAJNAM        LBRSJNAM
     C                   MOVEL(P)  WKCHPN        LBRSPROG
     C                   MOVEL(P)  WKCHPL        LBRSBIBL
     C                   MOVEL(P)  DAUSER        LBRSUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBRSJZEI
     C                   MOVE      WKTDAT        LBRSJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBRS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PCJJ                                                   ***
     C**************************************************************************
     C     PRLBPCPCJJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPCJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBPCPCJJ    IFEQ      *ZERO
     C                   MOVEL(P)  '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PCNR                                                   ***
     C**************************************************************************
     C     PRLBPCPCNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPCNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBPCPCNR    IFNE      *BLANK
     C**                 MOVEL(P)  '0031'        WKFENR
     C**                 LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE RSMG                                                   ***
     C**************************************************************************
     C     PRLBPCRSMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCRSMG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSLBPCRSMG    WHENEQ    *ZERO
     C                   MOVE      '0031'        WKFENR
     C     DSLBPCRSMG    WHENGT    LBPCRSMG
     C                   MOVE      '0031'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      ERGEWI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PAKN                                                   ***
     C**************************************************************************
     C     PRLBPCPAKN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCPAKN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBPCPAKN    IFEQ      *BLANK
     C     LBPCSTAT      ANDGT     '10'
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PAKN                                                   ***
     C**************************************************************************
     C     P1LBPCPAKN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'D1LBPCPAKN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     D1LBPCPAKN    IFEQ      *BLANK
     C     LBPCSTAT      ANDGT     '10'
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  D1LBPCPAKN    DSLBPCPAKN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GEWI                                                   ***
     C**************************************************************************
     C     PRLBPCGEWI    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSLBPCGEWI'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLBPCGEWI    IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
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
     C                   MOVEA     'XXXX'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LIEFERSCHEIN FÜR LBAK                                             ***
     C**************************************************************************
     C     GNLBPC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      SPLBRS
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXLBPCDANA    KYLBRSDANA
     C                   MOVEL     EXLBPCJAHR    KYLBRSJAHR
     C                   MOVEL     EXLBPCNMKR    KYLBRSNMKR
     C                   MOVEL     *ZERO         KYLBRSPOSI
     C                   MOVEL     *LOVAL        KYLBRSTMST
     C                   EXSR      ERLBRS
     C*-------------------------------------------------------------------------
     C     EXLBPCNMK1    IFNE      *BLANK
     C                   MOVEL     EXLBPCDANA    KYLBRSDANA
     C                   MOVEL     EXLBPCJAH1    KYLBRSJAHR
     C                   MOVEL     EXLBPCNMK1    KYLBRSNMKR
     C                   MOVEL     *ZERO         KYLBRSPOSI
     C                   MOVEL     *LOVAL        KYLBRSTMST
     C                   EXSR      ERLBRS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         KYLBPCPCJJ                     PRODUKTIONS-NR
     C                   MOVEL     *BLANK        KYLBPCPCNR                     AUF GÜLTIGKEIT
     C                   MOVEL     *BLANK        KYLBRSLANR
     C                   Z-ADD     *ZERO         KYAMJH                         PRODUKTIONS-NR
     C                   MOVEL     *BLANK        KYAMKM                         AUF GÜLTIGKEIT
     C                   Z-ADD     *ZERO         WKPAKN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*--------------------------------------------------------
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 40: 440)
     C*--------------------------------------------------------
     C     LBRSLANR      IFNE      KYLBRSLANR
     C     MODGVF        ANDEQ     *OFF
     C*
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
     C*
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C*
     C                   MOVEL     LBRSLANR      KYLBRSLANR
     C                   ENDIF
     C*--------------------------------------------------------
     C     KYLBPCPCNR    IFEQ      *BLANK
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSDANA      IFEQ      'AFKM'
     C*
     C     LBRSJAHR      IFNE      KYAMJH
     C     LBRSNMKR      ORNE      KYAMKM
     C                   MOVEL     LBRSJAHR      KYAMJH
     C                   MOVEL     LBRSNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*
     C                   MOVEL     'ELORT '      #CPGST
     C                   EXSR      TRLBVS
     C                   MOVEL(P)  RTLBVSLANR    DSLBPCZULG
     C                   MOVEL(P)  RTLBVSLORT    DSLBPCZULO
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBRSDANA      DSLBPCDANA
     C                   Z-ADD     LBRSJAHR      DSLBPCJAHR
     C                   MOVEL(P)  LBRSNMKR      DSLBPCNMKR
     C                   Z-ADD     LBRSPOSI      DSLBPCPOSI
     C*
     C                   MOVEL(P)  LBRSAFDN      DSLBPCAFDN
     C                   Z-ADD     LBRSAFJJ      DSLBPCAFJJ
     C                   MOVEL(P)  LBRSAFNR      DSLBPCAFNR
     C                   Z-ADD     LBRSAFPO      DSLBPCAFPO
     C                   Z-ADD     LBRSAFUP      DSLBPCAFUP
     C*
     C                   MOVEL(P)  LBRSBSTY      DSLBPCBSTY
     C                   MOVEL(P)  LBRSWKNR      DSLBPCWKNR
     C                   MOVEL(P)  LBRSKDNR      DSLBPCKDNR
     C                   MOVEL(P)  LBRSLFNR      DSLBPCLFNR
     C                   MOVEL(P)  LBRSLANR      DSLBPCLANR
     C                   MOVEL(P)  LBRSBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBRSTENR      DSLBPCTENR
     C                   MOVEL(P)  LBRSFBNR      DSLBPCFBNR
     C*
     C                   MOVEL(P)  LBRSGEBI      DSLBPCGEBI
     C                   MOVEL(P)  LBRSCONT      DSLBPCCONT
     C                   MOVEL(P)  LBRSBHNR      DSLBPCBHNR
     C                   MOVEL(P)  LBRSLORT      DSLBPCLORT
     C                   MOVEL(P)  LBRSCHAR      DSLBPCCHAR
     C                   MOVEL(P)  LBRSFUMG      DSLBPCFUMG
     C                   MOVEL(P)  LBRSMEIN      DSLBPCMEIN
     C                   Z-ADD     LBRSTMST      DSLBPCTMST
     C*
     C                   MOVEL(P)  LBRSTENR      KYTUTE                         LESEN TEUF
     C                   MOVEL(P)  WKTRPAPLTT    KYTUME
     C                   Z-ADD     1             WKV1V2                         MENGE IN
     C                   EXSR      VTEUF
     C*
     C     LBRSRSMG      IFEQ      WKV1V2
     C     WKV1V2        ANDGT     1
     C*
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   ADD       1             WKPAKN
     C                   Z-ADD     WKPAKN        DUN030
     C                   MOVEL(P)  DUC003        DSLBPCPAKN
     C                   EXSR      ERGEWI
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVE      '00'          DSLBPCSTAT
     C                   EXSR      ULBPC
     C                   SUB       DSLBPCRSMG    LBRSRSMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBRSTENR      KYTUTE                         LESEN TEUF
     C                   MOVEL(P)  WKTRPAKRTN    KYTUME
     C                   Z-ADD     1             WKV1V2                         MENGE IN
     C                   EXSR      VTEUF
     C*
     C     LBRSRSMG      IFGT      *ZERO
     C*
     C                   MOVE      *BLANK        DSLBPCPAKN
     C                   Z-ADD     WKV1V2        DSLBPCRSMG
     C     LBRSRSMG      IFLT      WKV1V2
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   ELSE
     C                   ADD       1             WKPAKN
     C                   Z-ADD     WKPAKN        DUN030
     C                   MOVEL(P)  DUC003        DSLBPCPAKN
     C                   ENDIF
     C                   EXSR      ERGEWI
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVE      '00'          DSLBPCSTAT
     C                   EXSR      ULBPC
     C                   SUB       DSLBPCRSMG    LBRSRSMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBVS                                                 ***
     C**************************************************************************
     C     TRLBVS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C                   MOVEL(P)  #CPGST        EXLBVSPGST
     C                   MOVEL(P)  EXLBPCZULG    EXLBVSLANR
     C                   MOVEL(P)  *BLANK        EXLBVSLORT
     C                   MOVEL(P)  AMKDNR        EXLBVSKDNR
     C                   MOVEL(P)  AMVSNR        EXLBVSVSNR
     C*
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLBVSPROG    WKPROG
     C                   MOVEL(P)  RTLBVSDANA    WKDANA
     C                   MOVEL(P)  RTLBVSFFLD    WKFFLD
     C                   MOVEL(P)  RTLBVSFENR    WKFENR
     C                   MOVEL(P)  RTLBVSPA03    W$PA03
     C                   MOVEL(P)  RTLBVSPA04    W$PA04
     C                   MOVEL(P)  RTLBVSPA05    W$PA05
     C                   MOVEL(P)  RTLBVSPA06    W$PA06
     C                   MOVEL(P)  RTLBVSPA07    W$PA07
     C*
     C                   MOVEL(P)  RTLBVSRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTLEN NUMMERNKREIS                                             ***
     C**************************************************************************
     C     ERNMKR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM                            ERMITTELN
     C                   MOVEA     'NUMMER'      KOM(1)
     C                   MOVE      *YEAR         DUN040
     C                   MOVEA     DUC004        KOM(11)
     C                   MOVEA     'PCNR'        KOM(15)
     C                   MOVEA     KOM           #CKOMM
     C                   CALL      'TRNUMM'
     C                   PARM                    EXTR02
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(1)        KYLBPCPCNR
     C*-------------------------------------------------------------------------
     C                   MOVE      *YEAR         KYLBPCPCJJ
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
     C                   EVAL      EXUX01INAM = 'TRLBPC'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 39 + 440                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 39                              MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung LBPC für Pickliste'
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERLBRS     ERm.    SÄTZE DATEI LBRS JE AFKM                    ***
     C**************************************************************************
     C     ERLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBRSFIRM      IFNE      KYLBRSFIRM                                   VERGLEICHEN
     C     LBRSDANA      ORNE      KYLBRSDANA                                   OBERGRENZE
     C     LBRSJAHR      ORNE      KYLBRSJAHR
     C     LBRSNMKR      ORNE      KYLBRSNMKR
     C     LBRSPOSI      ORNE      KYLBRSPOSI
     C     KYLBRSPOSI    ANDNE     *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSSTAT      IFNE      *BLANK
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     LBRSJAHR      DUN040
     C                   Z-ADD     LBRSTMST      DUN260
     C                   EVAL      WKSORT     = LBRSLANR + DUC004 + LBRSNMKR+
     C                             DUC026
     C                   EVAL      EXUX01IDTA = WKSORT +LBRS
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-SPLBRS     SPLITTERN LBRS JE VERPACKUNG                        ***
     C**************************************************************************
     C     SPLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXLBPCDANA    KYLBRSDANA
     C                   MOVEL     EXLBPCJAHR    KYLBRSJAHR
     C                   MOVEL     EXLBPCNMKR    KYLBRSNMKR
     C                   MOVEL     *ZERO         KYLBRSPOSI
     C                   MOVEL     *LOVAL        KYLBRSTMST
     C                   EXSR      ERLBRS
     C*-------------------------------------------------------------------------
     C     EXLBPCNMK1    IFNE      *BLANK
     C                   MOVEL     EXLBPCDANA    KYLBRSDANA
     C                   MOVEL     EXLBPCJAH1    KYLBRSJAHR
     C                   MOVEL     EXLBPCNMK1    KYLBRSNMKR
     C                   MOVEL     *ZERO         KYLBRSPOSI
     C                   MOVEL     *LOVAL        KYLBRSTMST
     C                   EXSR      ERLBRS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*--------------------------------------------------------
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 40: 440)
     C*--------------------------------------------------------
     C                   EXSR      DLBRS
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         WKRSMG
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBRSTENR      KYTUTE                         LESEN TEUF
     C                   MOVEL(P)  WKTRPAPLTT    KYTUME
     C                   Z-ADD     1             WKV1V2                         MENGE IN
     C                   EXSR      VTEUF
     C*
     C     LBRSRSMG      DOWGT     *ZERO
     C     LBRSRSMG      ANDGE     WKV1V2
     C     WKV1V2        ANDGT     1
     C*
     C                   Z-ADD     WKV1V2        DSLBPCRSMG
     C     LBRSRSMG      IFLT      WKV1V2
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      T1LBRS
     C                   SUB       DSLBPCRSMG    LBRSRSMG
     C                   ADD       DSLBPCRSMG    WKRSMG
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBRSTENR      KYTUTE                         LESEN TEUF
     C                   MOVEL(P)  WKTRPAKRTN    KYTUME
     C                   Z-ADD     1             WKV1V2                         MENGE IN
     C                   EXSR      VTEUF
     C*
     C     LBRSRSMG      DOWGT     *ZERO
     C*
     C                   Z-ADD     WKV1V2        DSLBPCRSMG
     C     LBRSRSMG      IFLT      WKV1V2
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   ENDIF
     C*
     C                   EXSR      T1LBRS
     C                   SUB       DSLBPCRSMG    LBRSRSMG
     C                   ADD       DSLBPCRSMG    WKRSMG
     C                   ENDDO
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMBUCHEN LBPC nach PAKET-NR                                       ***
     C**************************************************************************
     C     UMLBPC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KYTENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSLBPCPCJJ    OFLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    OFLBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    OFLBPCPAKN
     C                   Z-ADD     DSLBPCPCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    KYLBPCPCNR
     C                   MOVEL(P)  DSLBPCPAKN    KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCPCJJ      ORGT      OFLBPCPCJJ
     C     LBPCPCNR      ORGT      OFLBPCPCNR
     C     LBPCPAKN      ORGT      OFLBPCPAKN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBPCZULG      DSLBPCLANR
     C     LBPCBSLA      IFNE      *BLANK
     C                   MOVEL(P)  LBPCZULG      DSLBPCBSLA
     C                   ELSE
     C                   MOVEL(P)  *BLANK        DSLBPCBSLA
     C                   ENDIF
     C                   MOVEL(P)  LBPCZULO      DSLBPCLORT
     C*--------------------------------------------------------
     C                   EXSR      ULBRS
     C*--------------------------------------------------------
     C                   MOVEL(P)  'ULBLB '      #CPGST
     C                   EXSR      TRLBLB
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  '50'          DSLBPCSTAT
     C                   ELSE
     C                   MOVEL(P)  '40'          DSLBPCSTAT
     C                   MOVEL(P)  LBPCLANR      DSLBPCLANR
     C                   MOVEL(P)  LBPCBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBPCLORT      DSLBPCLORT
     C                   EXSR      ULBRS
     C                   ENDIF
     C*
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   EXSR      ULBPC
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERGEWI     ERM.Gewicht                                         ***
     C**************************************************************************
     C     ERGEWI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSLBPCTENR    IFNE      KYTENR
     C                   MOVEL     DSLBPCTENR    KYTENR
     C                   MOVE      *BLANK        KYTEEZ                         LESEN
     C                   MOVEA     '01C     '    CHI                            TEILESTAMM
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSLBPCGEWI                     GEW.BRUTTO
     C*-------------------------------------------------------------------------
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'GDIM'        KYTPTA                         ERMITTELN GEWICHT
     C                   MOVEL     TEGWDI        KYTPTC                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   END
     C*-------------------------------------------------------------------------
     C     MODGVF        IFEQ      *ON
     C                   EXSR      TREGEW
     C*
     C                   ELSE
     C*
     C     TEGWBR        IFNE      *ZERO
     C     DSLBPCRSMG    MULT      TEGWBR        DSLBPCGEWI                     GEW.BRUTTO
     C                   ELSE
     C     DSLBPCRSMG    MULT      TEGWNT        DSLBPCGEWI                     GEW.NETTO
     C                   ENDIF
     C                   DIV(H)    TPTNUM        DSLBPCGEWI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TREGEW     ERM.Gewicht                                         ***
     C**************************************************************************
     C     TREGEW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM                            ERMITTELN
     C                   MOVEA     DSLBPCTENR    KOM(01)                        GEWICHT
     C                   MOVE      DSLBPCRSMG    DUN154
     C                   MOVEA     DUC015        KOM(16)
     C                   MOVEA     KOM(1)        #CKOMM
     C                   CALL      'TREGEW  '
     C                   PARM                    EXTR02
     C*
     C                   MOVEA     #CKOMM        KOM
     C*
     C                   MOVEA     KOM(31)       DUC011                         GEWICHT
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN112        DSLBPCGEWI
     C                   MOVEA     KOM(42)       DUC011                         VERPACKUNGSGEWICHT
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   ADD       DUN112        DSLBPCGEWI                     MENGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRLBLB     VERBUCHEN DER LAGERBEWEGUNG                         ***
     C**************************************************************************
     C     TRLBLB        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     LBPCTENR      IFNE      KYTENR
     C                   MOVEL     LBPCTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ                         LESEN
     C                   MOVEA     '01C     '    CHI                            TEILESTAMM
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL     #CPGST        EXLBPGST
     C**RE
     C**RE das KZ, ob Reservierung geprüft werden sollen, sollte immer auf N stehen
     C**RE sowohl beim Prüfen der Lagerbuchung als auch bei der Buchung selber, da sonst
     C**RE Fehler wegen Reservierungen beim Prüfen, obwohl ohne Fehler gebucht werden kann
     C**RE
     C**RE EXLBPGST      IFEQ      'ULBLB'
     C                   MOVE      WKNEIN        EXLBRSKZ
     C**RE               ENDIF
     C                   MOVEL     WKTRPALSTC    EXLBLSTC
     C                   MOVEL     LBPCFIRM      EXLBFIRM
     C*
     C                   MOVEL     LBPCWKNR      EXLBWKNR
     C                   MOVEL     LBPCLANR      EXLBLANR
     C                   MOVEL     LBPCBSLA      EXLBBSLA
     C                   MOVEL     LBPCTENR      EXLBTENR
     C                   MOVEL     LBPCFBNR      EXLBFBNR
     C                   MOVEL     LBPCGEBI      EXLBGEBI
     C                   MOVEL     LBPCCONT      EXLBCONT
     C                   MOVEL     LBPCBHNR      EXLBBHNR
     C                   MOVEL     LBPCLORT      EXLBLORT
     C                   MOVEL     LBPCCHAR      EXLBCHAR
     C                   Z-ADD     LBPCFUMG      EXLBFUMG
     C                   MOVEL     LBPCKDNR      EXLBKDNR
     C                   MOVEL     LBPCLFNR      EXLBLFNR
     C                   MOVEL     LBPCMEIN      EXLBMEIN
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        EXLBBZEI
     C                   MOVE      WKTDAT        EXLBBDAT
     C*
     C                   Z-ADD     LBPCRSMG      EXLBBWMG
     C                   MOVEL     TEMEIN        EXLBBWME
     C*
     C                   MOVEL     LBPCZULG      EXLBULNR
     C                   MOVEL     LBPCZULO      EXLBUORT
     C*
     C*                  SELECT
     C*    LBPCDANA      WHENEQ    'BGFS      '
     C*                  MOVEL     LBPCDANA      EXLBDANA
     C*                  Z-ADD     LBPCJAHR      EXLBAFJJ
     C*                  MOVEL     LBPCNMKR      EXLBAFNR
     C*                  Z-ADD     LBPCPOSI      EXLBAFPO
     C*                  Z-ADD     *ZERO         EXLBAFUP
     C*                  OTHER
     C                   MOVEL     LBPCAFDN      EXLBDANA
     C                   Z-ADD     LBPCAFJJ      EXLBAFJJ
     C                   MOVEL     LBPCAFNR      EXLBAFNR
     C                   Z-ADD     LBPCAFPO      EXLBAFPO
     C                   Z-ADD     LBPCAFUP      EXLBAFUP
     C*                  ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C                   ENDDO
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
     C                   MOVEL(P)  'TRLBPC'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DEFAULT'     KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'LGBE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALGBE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'UMLSTC'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALSTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MEIN'        KYTATC
     C                   MOVEL(P)  'KARTON'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAKRTN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MEIN'        KYTATC
     C                   MOVEL(P)  'PALETTE'     KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAPLTT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODGVF'      KYTATC
     C                   MOVEL(P)  'MODGVF'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODGVF
     C*
     C     MODGVF        IFNE      *ON
     C                   MOVE      *OFF          MODGVF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODWAO'      KYTATC
     C                   MOVEL(P)  'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODWAO            1
     C*
     C     MODWAO        IFNE      *ON
     C                   MOVE      *OFF          MODWAO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'NEIN'        KYTATC                         NEIN
     C                   MOVEL     'NEIN'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKNEIN            1
     C*-------------------------------------------------------------------------
     C*
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'ANZLAFNR'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL     TAPCDE        DUC003
     C                   TESTN                   DUC003               97
     C     *IN(97)       IFNE      '1'
     C                   Z-ADD     3             W0TRPAAFNR
     C                   ELSE
     C                   MOVEL     TAPCDE        W0TRPAAFNR
     C                   ENDIF
     C*---------------------------------------------------------------------
     C*
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'ANZLAFPO'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL     TAPCDE        DUC003
     C                   TESTN                   DUC003               97
     C     *IN(97)       IFNE      '1'
     C                   Z-ADD     4             W0TRPAAFPO
     C                   ELSE
     C                   MOVEL     TAPCDE        W0TRPAAFPO
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'TRLBPC'      KYTATC
     C                   MOVEL(P)  'SPGR  '      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASPGR
     C     WKTRPASPGR    IFEQ      *BLANK
     C                   MOVEL(P)  '80'          WKTRPASPGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  'LBPC'        EXTRDNPGNA
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C                   WRITE     TRLBPCW2
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     TRLBPC01
     C                   WRITE     W2LBPCB3
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     TRLBPC02
     C                   WRITE     W1LBPCB1
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     TRLBPC03
     C                   WRITE     W1LBPCB1
     C                   ENDSL
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT12
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
     C                   MOVE      *BLANK        #CRTCD
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOMPLETT BUCHEN                                                   ***
     C**************************************************************************
     C     BLBPC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKDANA
     C                   MOVEL     *ZERO         WKJAHR
     C                   MOVEL     *BLANK        WKNMKR
     C                   MOVEL     *ZERO         WKPOSI
     C*-------------------------------------------------------------------------
     C                   MOVEL     '50'          KYLBPCSTAT
     C                   MOVEL     *LOVAL        KYLBPCDANA
     C                   MOVEL     *LOVAL        KYLBPCJAHR
     C                   MOVEL     *LOVAL        KYLBPCNMKR
     C                   MOVEL     *LOVAL        KYLBPCPOSI
     C                   MOVEL     *LOVAL        KYLBPCTSTP
     C*
     C                   MOVEL     '50'          OFLBPCSTAT
     C                   MOVEL     *HIVAL        OFLBPCDANA
     C                   MOVEL     *HIVAL        OFLBPCJAHR
     C                   MOVEL     *HIVAL        OFLBPCNMKR
     C                   MOVEL     *HIVAL        OFLBPCPOSI
     C                   MOVEL     *HIVAL        OFLBPCTSTP
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCSTAT      ORNE      OFLBPCSTAT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCDANA      IFNE      WKDANA
     C     LBPCJAHR      ORNE      WKJAHR
     C     LBPCNMKR      ORNE      WKNMKR
     C*
     C     WKDANA        IFNE      *BLANK
     C                   EXSR      TRLBAK
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCDANA      IFNE      WKDANA
     C     LBPCJAHR      ORNE      WKJAHR
     C     LBPCNMKR      ORNE      WKNMKR
     C     LBPCPOSI      ORNE      WKPOSI
     C*
     C                   EXSR      TRLBRS
     C*
     C                   MOVEL     LBPCDANA      WKDANA
     C                   MOVEL     LBPCJAHR      WKJAHR
     C                   MOVEL     LBPCNMKR      WKNMKR
     C                   MOVEL     LBPCPOSI      WKPOSI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '04R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRLBRS     UPDATE DATEI LBRS                                   ***
     C**************************************************************************
     C     TRLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'BLBRS'       #CPGST
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL     LBPCDANA      EXRSDANA
     C                   MOVEL     LBPCJAHR      EXRSJAHR
     C                   MOVEL     LBPCNMKR      EXRSNMKR
     C                   Z-ADD(H)  LBPCPOSI      EXRSPOSI
     C*
     C                   CALL      'TRLBRS'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTRSFENR      WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRLBRS     UPDATE DATEI LBRS                                   ***
     C**************************************************************************
     C     DLBRS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *OFF          KOM(77)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'LLBRS '      #CPGST
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   Z-ADD(H)  LBRSTMST      EXRSTMST
     C*
     C                   CALL      'TRLBRS'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTRSFENR      WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERSTELLEN LAGERRESERVIERUNGEN LBRS                                ***
     C**************************************************************************
     C     T1LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   MOVEL     *BLANK        KOM
     C                   MOVEL     *OFF          KOM(66)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        EXRSFIRM
     C                   MOVEL     LBRSDANA      EXRSDANA
     C                   Z-ADD     LBRSJAHR      EXRSJAHR
     C                   MOVEL     LBRSNMKR      EXRSNMKR
     C                   Z-ADD     LBRSPOSI      EXRSPOSI
     C                   MOVEL     LBRSAFDN      EXRSAFDN
     C                   MOVEL     LBRSAFJJ      EXRSAFJJ
     C                   MOVEL     LBRSAFNR      EXRSAFNR
     C                   Z-ADD     LBRSAFPO      EXRSAFPO
     C                   Z-ADD     LBRSAFUP      EXRSAFUP
     C                   MOVEL     LBRSWKNR      EXRSWKNR
     C                   MOVEL     LBRSBSTY      EXRSBSTY
     C                   MOVEL     LBRSKDNR      EXRSKDNR
     C                   MOVEL     LBRSLFNR      EXRSLFNR
     C                   MOVEL     LBRSLANR      EXRSLANR
     C                   MOVEL     LBRSBSLA      EXRSBSLA
     C                   MOVEL     LBRSTENR      EXRSTENR
     C                   MOVEL     LBRSFBNR      EXRSFBNR
     C                   MOVEL(P)  LBRSGEBI      EXRSGEBI
     C                   MOVEL(P)  LBRSCONT      EXRSCONT
     C                   MOVEL(P)  LBRSBHNR      EXRSBHNR
     C                   MOVEL(P)  LBRSLORT      EXRSLORT
     C                   MOVEL(P)  LBRSCHAR      EXRSCHAR
     C                   Z-ADD     LBRSFUMG      EXRSFUMG
     C                   MOVEL     LBRSMEIN      EXRSMEIN
     C*
     C                   Z-ADD     DSLBPCRSMG    EXRSRSMG
     C*-------------------------------------------------------------------------
     C                   MOVEL     'RLBRS'       #CPGST
     C*
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBAK                                                 ***
     C**************************************************************************
     C     TRLBAK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  WKDANA        KOM(01)
     C                   Z-ADD     WKJAHR        DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA(P)  WKNMKR        KOM(15)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'LI     '     #CPGST
     C*
     C                   CALL      'TRLBAK'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Erm. Paketnummer                                                  ***
     C**************************************************************************
     C     ERPAKN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *HIVAL        KYLBPCPAKN
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     LBPCFIRM      ANDEQ     KYLBPCFIRM
     C     LBPCPCJJ      ANDEQ     KYLBPCPCJJ
     C     LBPCPCNR      ANDEQ     KYLBPCPCNR
     C                   MOVE      LBPCPAKN      DUC020
     C                   EVALR     DUC020 =  %TRIMR(DUC020)
     C     ' ':'0'       XLATE     DUC020        DUC020
     C                   Z-ADD     DUN200        DUN030
     C                   ADD       1             DUN030
     C                   ELSE
     C                   Z-ADD     1             DUN030
     C                   ENDIF
     C                   MOVEL(P)  DUC003        DSLBPCPAKN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Drucken Pickliste
     C**************************************************************************
     C     DRLB09        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLB09
     C                   Z-ADD     DSLBPCPCJJ    EXLB09PCJJ
     C                   MOVEL(P)  DSLBPCPCNR    EXLB09PCNR
     C     MODWAO        IFEQ      *ON
     C                   EXSR      MOLBPCWAO
     C                   EVAL      EXLB09LGBE = %SUBST(RTTRNDDATE:1:1)
     C                   MOVEL(P)  DSLBPCLANR    EXLB09LANR
     C                   ENDIF
     C     PCPGST        IFEQ      'DRWAO1'
     C                   MOVEL     PCPGST        EXLB09PGST
     C                   ENDIF
     C*
     C                   CALL      'DRLB09SB'
     C                   PARM                    EXLB09
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PICLISTE für BGFS                                                 ***
     C**************************************************************************
     C     GNLBPCBGFS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         KYLBPCPCJJ                     PRODUKTIONS-NR
     C                   MOVEL     *BLANK        KYLBPCPCNR                     AUF GÜLTIGKEIT
     C                   MOVEL     *BLANK        KYLBRSBSLA
     C                   MOVEL     *BLANK        KYLBRSLANR
     C                   MOVEL     *BLANK        WKDANA                         AUF GÜLTIGKEIT
     C                   Z-ADD     *ZERO         WKJAHR
     C                   MOVEL     *BLANK        WKNMKR
     C                   Z-ADD     *ZERO         WKANZLPOSI
     C                   Z-ADD     *ZERO         W2ANZLPOSI
     C                   Z-ADD     *ZERO         WKANZLAFNR
     C                   MOVEL     *BLANK        WKVSBD
     C                   MOVEL     *BLANK        W1VSBD
     C                   MOVEL     *BLANK        WKLBPBLPBE
     C                   MOVEL     *BLANK        W1LBPBLPBE
     C                   MOVE      *ZERO         WAORSTAZ
     C                   MOVEL     *BLANK        WKKDNR
     C                   MOVEL     *BLANK        W1KDNR
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C**********         EXSR      EXUXSAVE
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*--------------------------------------------------------
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 101: %LEN(LBRS))
     C                   EVAL      DUC006= %SUBST(EXUX01IDTA: 20: 6)
     C     999999        SUB       DUN060        W1ANZLPOSI
     C                   EVAL      W1SORT = %SUBST(EXUX01IDTA: 1: 100)
     C                   EVAL      WKKDNR = %SUBST(EXUX01IDTA: 7: 10)
     C                   EVAL      WKVSBD = %SUBST(EXUX01IDTA: 17: 3)
     C                   EVAL      WKLBPBLPBE=%SUBST(EXUX01IDTA:
     C                             1+3+3+10+3+6+4+6: 8)
     C*
     C                   EVAL      WAORSOPO= %SUBST(EXUX01IDTA: 90: 1)
     C                   IF        WAORSOPO = DAJNKZ
     C                   Z-ADD     DUN060        W1ANZLPOSI
     C                   ENDIF
     C*
     C                   MOVE      LBRSTMST      KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C     WKFENR        IFEQ      *ZERO
     C     LBPCFIRM      ANDEQ     KYLBPCFIRM
     C     LBPCTMST      ANDEQ     KYLBPCTMST
     C                   EXSR      EXUXNEXT
     C                   ITER
     C                   ENDIF
     C*
     C     LBRSDANA      IFNE      WKDANA
     C     LBRSJAHR      ORNE      WKJAHR
     C     LBRSNMKR      ORNE      WKNMKR
     C                   SELECT
     C     WKTRPAAFNR    WHENEQ    1
     C     WAORSTAZ      ANDNE     *ZERO
     C     WAORSTAZ      ANDGE     W1ANZLPOSI
     C                   OTHER
     C                   ADD       1             WKANZLAFNR
     C                   ADD       W1ANZLPOSI    W2ANZLPOSI
     C                   ENDSL
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSLANR      IFNE      KYLBRSLANR                                   Lager-Trennung
     C     LBRSBSLA      ORNE      KYLBRSBSLA
     C     WKKDNR        ORNE      W1KDNR
     C     WKVSBD        ORNE      W1VSBD
     C     WKLBPBLPBE    ORNE      W1LBPBLPBE
     C     W1ANZLPOSI    ORGE      WKTRPAAFPO
     C     WKANZLAFNR    ORGT      WKTRPAAFNR
     C     W2ANZLPOSI    ORGT      WAORSTAZ
     C     WAORSTAZ      ANDNE     *ZERO
     C     WAORSOPO      ANDEQ     DAJNKZ
     C*
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
     C*
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C*
     C                   MOVEL     LBRSLANR      KYLBRSLANR
     C                   MOVEL     LBRSBSLA      KYLBRSBSLA
     C                   MOVEL     WKKDNR        W1KDNR
     C                   MOVEL     WKVSBD        W1VSBD
     C                   MOVEL     WKLBPBLPBE    W1LBPBLPBE
     C*
     C                   MOVEL(P)  WKVSBD        KYWAORVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOR
     C     CHI(5)        IFEQ      'J'
     C                   Z-ADD     WAORAZAF      WKTRPAAFNR
     C                   Z-ADD     WAORPOAZ      WKTRPAAFPO
     C                   ELSE
     C                   Z-ADD     W0TRPAAFNR    WKTRPAAFNR
     C                   Z-ADD     W0TRPAAFPO    WKTRPAAFPO
     C                   ENDIF
     C*
     C                   Z-ADD     1             WKANZLAFNR
     C     W1ANZLPOSI    IFGE      WKTRPAAFPO
     C                   Z-ADD     WKTRPAAFNR    WKANZLAFNR
     C                   ENDIF
     C                   Z-ADD     W1ANZLPOSI    W2ANZLPOSI
     C                   ENDIF
     C*--------------------------------------------------------
     C     KYLBPCPCNR    IFEQ      *BLANK
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     LBRSDANA      WKDANA                         AUF GÜLTIGKEIT
     C                   Z-ADD     LBRSJAHR      WKJAHR
     C                   MOVEL     LBRSNMKR      WKNMKR
     C*--------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS2  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS2                  '
     C***********        EXSR      EXUXSAVE
     C                   EXSR      EXUXREAD
     C*
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 101: %LEN(LBRS))
     C                   EVAL      LBRSULAN  = %SUBST(EXUX01IDTA: 75: 3)
     C                   EVAL      LBRSUORT  = %SUBST(EXUX01IDTA: 78: 8)
     C                   EVAL      WKLPBE    = %SUBST(EXUX01IDTA:
     C                             1+3+3+10+3+4+6: 8)
     C*
     C     LBRSDANA      IFNE      WKDANA
     C     LBRSJAHR      ORNE      WKJAHR
     C     LBRSNMKR      ORNE      WKNMKR
     C     LBRSBSLA      ORNE      KYLBRSBSLA
     C     LBRSLANR      ORNE      KYLBRSLANR
     C     W1LBPBLPBE    ORNE      WKLPBE
     C                   EXSR      EXUXNEXT
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVE      LBRSTMST      KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C     WKFENR        IFEQ      *ZERO
     C     LBPCFIRM      ANDEQ     KYLBPCFIRM
     C     LBPCTMST      ANDEQ     KYLBPCTMST
     C                   EXSR      EXUXNEXT
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  LBRSDANA      DSLBPCDANA
     C                   Z-ADD     LBRSJAHR      DSLBPCJAHR
     C                   MOVEL(P)  LBRSNMKR      DSLBPCNMKR
     C                   Z-ADD     LBRSPOSI      DSLBPCPOSI
     C*
     C                   MOVEL(P)  LBRSAFDN      DSLBPCAFDN
     C                   Z-ADD     LBRSAFJJ      DSLBPCAFJJ
     C                   MOVEL(P)  LBRSAFNR      DSLBPCAFNR
     C                   Z-ADD     LBRSAFPO      DSLBPCAFPO
     C                   Z-ADD     LBRSAFUP      DSLBPCAFUP
     C*
     C                   MOVEL(P)  LBRSBSTY      DSLBPCBSTY
     C                   MOVEL(P)  LBRSWKNR      DSLBPCWKNR
     C                   MOVEL(P)  LBRSKDNR      DSLBPCKDNR
     C                   MOVEL(P)  LBRSLFNR      DSLBPCLFNR
     C                   MOVEL(P)  LBRSLANR      DSLBPCLANR
     C                   MOVEL(P)  LBRSBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBRSTENR      DSLBPCTENR
     C                   MOVEL(P)  LBRSFBNR      DSLBPCFBNR
     C*
     C                   MOVEL(P)  LBRSGEBI      DSLBPCGEBI
     C                   MOVEL(P)  LBRSCONT      DSLBPCCONT
     C                   MOVEL(P)  LBRSBHNR      DSLBPCBHNR
     C                   MOVEL(P)  LBRSLORT      DSLBPCLORT
     C                   MOVEL(P)  LBRSCHAR      DSLBPCCHAR
     C                   MOVEL(P)  LBRSFUMG      DSLBPCFUMG
     C                   MOVEL(P)  LBRSMEIN      DSLBPCMEIN
     C                   Z-ADD     LBRSTMST      DSLBPCTMST
     C*
     C                   MOVEL(P)  LBRSULAN      DSLBPCZULG
     C                   MOVEL(P)  LBRSUORT      DSLBPCZULO
     C*
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   MOVEL(P)  *BLANK        DSLBPCPAKN
     C                   EXSR      ERGEWI
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVE      '00'          DSLBPCSTAT
     C                   EXSR      ULBPC
     C*
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C                   EVAL      EXUX01IKEY = W1SORT
     C*************      EXSR      EXUXSAVE
     C                   EXSR      EXUXBYKY
     C*
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        WKVSBD          + 2
     C     *LIKE         DEFINE    WKC001        W1VSBD          + 2
     C     *LIKE         DEFINE    WKC001        WKSORT          +38
     C     *LIKE         DEFINE    WKC001        W1SORT          +99
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAPCJJ
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C     *LIKE         DEFINE    WKC001        WKIN32
     C     *LIKE         DEFINE    WKC001        MODGVF
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        WKPAKN          + 2
     C     *LIKE         DEFINE    WKN010        WKANZLAFNR      + 2
     C     *LIKE         DEFINE    WKN010        WKANZLPOSI      + 5
     C     *LIKE         DEFINE    WKN010        W2ANZLPOSI      + 5
     C     *LIKE         DEFINE    WKN010        W1ANZLPOSI      + 5
     C     *LIKE         DEFINE    WKN010        WKTRPAAFPO      + 2
     C     *LIKE         DEFINE    WKN010        WKTRPAAFNR      + 2
     C     *LIKE         DEFINE    WKN010        W0TRPAAFNR      + 2
     C     *LIKE         DEFINE    WKN010        W0TRPAAFPO      + 2
     C     *LIKE         DEFINE    WKN010        L1              + 3
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
     C     *LIKE         DEFINE    KYLBPCPCJJ    OFLBPCPCJJ
     C     *LIKE         DEFINE    KYLBPCPCNR    OFLBPCPCNR
     C     *LIKE         DEFINE    KYLBPCPAKN    OFLBPCPAKN
     C     *LIKE         DEFINE    KYLBPCSTAT    OFLBPCSTAT
     C     *LIKE         DEFINE    KYLBPCDANA    OFLBPCDANA
     C     *LIKE         DEFINE    KYLBPCJAHR    OFLBPCJAHR
     C     *LIKE         DEFINE    KYLBPCNMKR    OFLBPCNMKR
     C     *LIKE         DEFINE    KYLBPCPOSI    OFLBPCPOSI
     C     *LIKE         DEFINE    KYLBPCTSTP    OFLBPCTSTP
     C     *LIKE         DEFINE    KYLBPCTMST    OFLBPCTMST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBPCJAHR      WKJAHR
     C     *LIKE         DEFINE    LBPCNMKR      WKNMKR
     C     *LIKE         DEFINE    LBPCPOSI      WKPOSI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTLBPCPROG    WKPROG
     C     *LIKE         DEFINE    RTLBPCDANA    WKDANA
     C     *LIKE         DEFINE    RTLBPCFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBPCDANA      DSLBPCDANA
     C*
     C     *LIKE         DEFINE    LBPCAFDN      DSLBPCAFDN
     C     *LIKE         DEFINE    LBPCAFUP      DSLBPCAFUP
     C*
     C     *LIKE         DEFINE    LBPCBSTY      DSLBPCBSTY
     C     *LIKE         DEFINE    LBPCWKNR      DSLBPCWKNR
     C     *LIKE         DEFINE    LBPCKDNR      DSLBPCKDNR
     C     *LIKE         DEFINE    LBPCLFNR      DSLBPCLFNR
     C     *LIKE         DEFINE    LBPCLANR      DSLBPCLANR
     C     *LIKE         DEFINE    LBPCBSLA      DSLBPCBSLA
     C     *LIKE         DEFINE    LBPCTENR      DSLBPCTENR
     C     *LIKE         DEFINE    LBPCFBNR      DSLBPCFBNR
     C*
     C     *LIKE         DEFINE    LBPCGEBI      DSLBPCGEBI
     C     *LIKE         DEFINE    LBPCCONT      DSLBPCCONT
     C     *LIKE         DEFINE    LBPCBHNR      DSLBPCBHNR
     C     *LIKE         DEFINE    LBPCLORT      DSLBPCLORT
     C     *LIKE         DEFINE    LBPCCHAR      DSLBPCCHAR
     C     *LIKE         DEFINE    LBPCFUMG      DSLBPCFUMG
     C     *LIKE         DEFINE    LBPCMEIN      DSLBPCMEIN
     C     *LIKE         DEFINE    LBPCRSMG      DSLBPCRSMG
     C     *LIKE         DEFINE    LBPCRSMG      WKRSMG
     C     *LIKE         DEFINE    LBPCSTAT      DSLBPCSTAT
     C*
     C     *LIKE         DEFINE    LBPCLANR      WKTRPALGBE
     C     *LIKE         DEFINE    LBPCTMST      DSLBPCTMST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXLBLSTC      WKTRPALSTC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEMEIN        WKTRPAKRTN
     C     *LIKE         DEFINE    TEMEIN        WKTRPAPLTT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYLBRSTMST    K$LBRSTMST
     C     *LIKE         DEFINE    KYLBPCTSTP    K$LBPCTSTP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBRSRSMG      WKLBAPBWMG
     C     *LIKE         DEFINE    TELORT        WKLBPBLPBE
     C     *LIKE         DEFINE    TELORT        W1LBPBLPBE
     C     *LIKE         DEFINE    TELORT        WKLPBE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN112        DSGLMG                         GELIEFERTE MENGE
     C     *LIKE         DEFINE    RTRSTLKZ      DSTLKZ                         KOMPLETT-KZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXRSLORT      WKLIEFLORT
     C     *LIKE         DEFINE    LFLANR        WKLIEFLANR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBPCKDNR      WKKDNR
     C     *LIKE         DEFINE    LBPCKDNR      W1KDNR
     C     *LIKE         DEFINE    WKC001        WKKDGR          + 3
     C     *LIKE         DEFINE    WKC001        W1KDGR          + 3
     C     *LIKE         DEFINE    WKC001        WKREF1          +29
     C     *LIKE         DEFINE    WKC001        W1REF1          +29
     C     *LIKE         DEFINE    WKC001        WKTRPASPGR       +1
     C     *LIKE         DEFINE    PCPGST        W$PGST
     C     *LIKE         DEFINE    LBRSRSMG      WKLBRSRSMG
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
     C                   MOVEL(P)  'TRLBPC'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTLBPCW2
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTLBPCW1
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTLBPCW1
     C     WKIFMT        WHENEQ    '04'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT4
     C     WKIFMT        WHENEQ    '04'
     C                   WRITE     CTLBPC04
     C     WKIFMT        WHENEQ    '05'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT5
     C     WKIFMT        WHENEQ    '05'
     C                   WRITE     CTLBPC05
     C     WKIFMT        WHENEQ    '06'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT6
     C     WKIFMT        WHENEQ    '06'
     C                   WRITE     CTLBPC06
     C     WKIFMT        WHENEQ    '07'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT6
     C     WKIFMT        WHENEQ    '07'
     C                   WRITE     CTLBPC06
     C                   OTHER
     C                   WRITE     TRLBPCCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTLBPCW2
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTLBPCW1
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTLBPCW1
     C     WKIFMT        WHENEQ    '04'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT4
     C     WKIFMT        WHENEQ    '04'
     C                   WRITE     CTLBPC04
     C     WKIFMT        WHENEQ    '05'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT5
     C     WKIFMT        WHENEQ    '05'
     C                   WRITE     CTLBPC05
     C     WKIFMT        WHENEQ    '06'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT6
     C     WKIFMT        WHENEQ    '06'
     C                   WRITE     CTLBPC06
     C     WKIFMT        WHENEQ    '07'
     C     DAPROG        ANDEQ     'TRLBPCS4'
     C                   WRITE     CTLBPCT6
     C     WKIFMT        WHENEQ    '07'
     C                   WRITE     CTLBPC06
     C                   OTHER
     C                   WRITE     TRLBPCCT
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
     C***  PICLISTE für BGFS                                                 ***
     C**************************************************************************
     C     G2LBPCBGFS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         KYLBPCPCJJ                     PRODUKTIONS-NR
     C                   MOVEL     *BLANK        KYLBPCPCNR                     AUF GÜLTIGKEIT
     C                   MOVEL     *BLANK        WKDANA                         AUF GÜLTIGKEIT
     C                   Z-ADD     *ZERO         WKJAHR
     C                   MOVEL     *BLANK        WKNMKR
     C                   Z-ADD     *ZERO         DSLBPCPCJJ
     C                   MOVEL     *BLANK        DSLBPCPCNR
     C                   Z-ADD     *ZERO         DSLBPCPOSI
     C                   Z-ADD     *ZERO         DSLBPCRSMG
     C                   Z-ADD     *ZERO         WKLBAPBWMG
     C                   CLEAR                   KYLBRS
     C                   MOVEL     DAFIRM        KYLBRSFIRM
     C                   MOVEL     *BLANK        W1KDGR
     C                   MOVEL     *BLANK        W1REF1
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C                   EVAL      L1 = %LEN(LBRS)
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*--------------------------------------------------------
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 101: L1)
     C                   EVAL      W1SORT = %SUBST(EXUX01IDTA: 1: 100)
     C                   EVAL      WKKDGR = %SUBST(EXUX01IDTA: 7: 4)
     C                   EVAL      WKREF1 = %SUBST(EXUX01IDTA:11:30)
     C*
     C                   MOVE      LBRSTMST      KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C     WKFENR        IFEQ      *ZERO
     C     LBPCFIRM      ANDEQ     KYLBPCFIRM
     C     LBPCTMST      ANDEQ     KYLBPCTMST
     C                   EXSR      EXUXNEXT
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKKDGR        IFNE      W1KDGR
     C     WKREF1        ORNE      W1REF1
     C     KYLBPCPCNR    OREQ      *BLANK
     C*
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
     C*
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C                   Z-ADD     *ZERO         DSLBPCPOSI
     C                   Z-ADD     *ZERO         DSLBPCRSMG
     C*
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C                   MOVEL(P)  'ELORT '      EXLBVSPGST
     C                   MOVEL(P)  'BGF2'        EXLBVSDANA
     C                   Z-ADD     DSLBPCPCJJ    EXLBVSJAHR
     C                   MOVEL(P)  DSLBPCPCNR    EXLBVSNMKR
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C                   MOVEL(P)  RTLBVSLANR    DSLBPCZULG
     C                   MOVEL(P)  RTLBVSLORT    DSLBPCZULO
     C*
     C                   EXSR      WLBAKBGF2
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   ENDIF
     C*--------------------------------------------------------
     C     KYLBPCPCNR    IFEQ      *BLANK
     C                   EXSR      ERNMKR
     C                   Z-ADD     KYLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  KYLBPCPCNR    DSLBPCPCNR
     C                   Z-ADD     *ZERO         DSLBPCPOSI
     C                   Z-ADD     *ZERO         DSLBPCRSMG
     C*
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C                   MOVEL(P)  'ELORT '      EXLBVSPGST
     C                   MOVEL(P)  'BGF2'        EXLBVSDANA
     C                   Z-ADD     DSLBPCPCJJ    EXLBVSJAHR
     C                   MOVEL(P)  DSLBPCPCNR    EXLBVSNMKR
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C                   MOVEL(P)  RTLBVSLANR    DSLBPCZULG
     C                   MOVEL(P)  RTLBVSLORT    DSLBPCZULO
     C*
     C                   EXSR      WLBAKBGF2
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     LBRSJAHR      KYWAO1LIJJ
     C                   MOVEL(P)  LBRSNMKR      KYWAO1LINR
     C                   Z-ADD     LBRSPOSI      KYWAO1RALP
     C*--------------------------------------------------------
     C     KYLBRSSTAT    IFNE      LBRSSTAT
     C     KYLBRSTENR    ORNE      LBRSTENR                                     RETTEN
     C     KYLBRSLANR    ORNE      LBRSLANR                                     AUFSETZKEY
     C     KYLBRSBSLA    ORNE      LBRSBSLA
     C     KYLBRSBSTY    ORNE      LBRSBSTY
     C     KYLBRSWKNR    ORNE      LBRSWKNR
     C     KYLBRSKDNR    ORNE      LBRSKDNR
     C     KYLBRSLFNR    ORNE      LBRSLFNR
     C     KYLBRSFBNR    ORNE      LBRSFBNR
     C     KYLBRSGEBI    ORNE      LBRSGEBI
     C     KYLBRSCONT    ORNE      LBRSCONT
     C     KYLBRSBHNR    ORNE      LBRSBHNR
     C     KYLBRSLORT    ORNE      LBRSLORT
     C     KYLBRSCHAR    ORNE      LBRSCHAR
     C     KYLBRSFUMG    ORNE      LBRSFUMG
     C     KYLBRSMEIN    ORNE      LBRSMEIN
     C     DSLBPCPOSI    OREQ      *ZERO
     C*
     C     KYLBRSTENR    IFNE      LBRSTENR
     C                   ADD       10            DSLBPCPOSI
     C                   ENDIF
     C*
     C                   MOVE      LBRSTMST      KYLBRSTMST
     C                   MOVE      LBRSTMST      K$LBRSTMST
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   Z-ADD     LBRSRSMG      WKLBAPBWMG
     C                   EXSR      ULBRSBGF2                                    LBRS
     C*
     C                   EXSR      ULBPCBGF2                                    LBPC
     C                   MOVE      LBPCTSTP      K$LBPCTSTP
     C*
     C                   ELSE
     C*
     C                   ADD       LBRSRSMG      DSLBPCRSMG
     C                   Z-ADD     LBRSRSMG      WKLBAPBWMG
     C*
     C                   Z-ADD     LBRSTMST      KYLBRSTMST                     BGFS WIRD
     C                   MOVEA     '01CU    '    CHI                            GELÖSCHT
     C                   EXSR      CHLBRS
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBRS
     C                   Z-ADD     K$LBRSTMST    KYLBRSTMST                     BGFS WIRD
     C                   EXSR      ULBRSBGF2                                    BGF2
     C*
     C                   MOVEL(P)  *BLANK        DSLBPCPAKN
     C                   EXSR      ERGEWI
     C                   MOVE      K$LBPCTSTP    KYLBPCTSTP
     C                   MOVE      '2     '      PCPGST
     C                   EXSR      ULBPC
     C                   MOVE      'G2BGFS'      PCPGST
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UWAO1PCNR
     C*--------------------------------------------------------
     C                   EXSR      WLBAP
     C*--------------------------------------------------------
     C                   MOVEL(P)  'BGFS'        KYLBAPDANA
     C                   Z-ADD     KYWAO1LIJJ    KYLBAPJAHR
     C                   MOVEL(P)  KYWAO1LINR    KYLBAPNMKR
     C                   Z-ADD     KYWAO1RALP    KYLBAPPOSI
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAP
     C*
     C                   Z-ADD     DSLBPCPCJJ    LBAPKMJJ
     C                   MOVEL(P)  DSLBPCPCNR    LBAPKMNR
     C                   Z-ADD     DSLBPCPOSI    LBAPKMPO
     C                   MOVEL(P)  RTLBVSLANR    LBAPULAN
     C                   MOVEL(P)  RTLBVSLORT    LBAPULOR
     C*
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLBAP
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBAP
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL     LBRSSTAT      KYLBRSSTAT
     C                   MOVEL     LBRSTENR      KYLBRSTENR                     RETTEN
     C                   MOVEL     LBRSLANR      KYLBRSLANR                     AUFSETZKEY
     C                   MOVEL     LBRSBSLA      KYLBRSBSLA
     C                   MOVEL     LBRSBSTY      KYLBRSBSTY
     C                   MOVEL     LBRSWKNR      KYLBRSWKNR
     C                   MOVEL     LBRSKDNR      KYLBRSKDNR
     C                   MOVEL     LBRSLFNR      KYLBRSLFNR
     C                   MOVEL     LBRSFBNR      KYLBRSFBNR
     C                   MOVEL     LBRSGEBI      KYLBRSGEBI
     C                   MOVEL     LBRSCONT      KYLBRSCONT
     C                   MOVEL     LBRSBHNR      KYLBRSBHNR
     C                   MOVEL     LBRSLORT      KYLBRSLORT
     C                   MOVEL     LBRSCHAR      KYLBRSCHAR
     C                   MOVEL     LBRSFUMG      KYLBRSFUMG
     C                   MOVEL     LBRSMEIN      KYLBRSMEIN
     C                   MOVEL     WKKDGR        W1KDGR
     C                   MOVEL     WKREF1        W1REF1
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     DSLBPCPCNR    IFNE      *BLANK
     C                   EXSR      DRLB09
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBAK                                                 ***
     C**************************************************************************
     C     WLBAKBGF2     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BGF2'        KYLBAKDANA
     C                   Z-ADD     DSLBPCPCJJ    KYLBAKJAHR
     C                   MOVEL(P)  DSLBPCPCNR    KYLBAKNMKR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAK
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL(P)  '05'          LBAKSTAT
     C*
     C                   MOVEL(P)  RTLBVSLANR    LBAKLANR
     C                   MOVEL(P)  RTLBVSLORT    LBAKLORT
     C*
     C                   MOVEL(P)  DAJNAM        LBAKJNAM
     C                   MOVEL(P)  WKCHPN        LBAKPROG
     C                   MOVEL(P)  WKCHPL        LBAKBIBL
     C                   MOVEL(P)  DAUSER        LBAKUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAKJZEI
     C                   MOVE      WKTDAT        LBAKJDAT
     C*
     C                   Z-ADD     LBAKJDAT      LBAKBUDA
     C                   Z-ADD     LBAKJZEI      LBAKBUZT
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLBAK
     C*-------------------------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBAK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBAP                                                 ***
     C**************************************************************************
     C     WLBAP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BGF2'        KYLBAPDANA
     C                   Z-ADD     DSLBPCPCJJ    KYLBAPJAHR
     C                   MOVEL(P)  DSLBPCPCNR    KYLBAPNMKR
     C                   Z-ADD     DSLBPCPOSI    KYLBAPPOSI
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAP
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C*
     C                   MOVEL(P)  DSLBPCTENR    LBAPTENR
     C                   MOVEL(P)  '05'          LBAPSTAT
     C                   Z-ADD     WKLBAPBWMG    LBAPBWMG
     C*
     C                   MOVEL(P)  RTLBVSLANR    LBAPULAN
     C                   MOVEL(P)  RTLBVSLORT    LBAPULOR
     C*
     C                   MOVEL(P)  DAJNAM        LBAPJNAM
     C                   MOVEL(P)  WKCHPN        LBAPPROG
     C                   MOVEL(P)  WKCHPL        LBAPBIBL
     C                   MOVEL(P)  DAUSER        LBAPUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAPJZEI
     C                   MOVE      WKTDAT        LBAPJDAT
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLBAP
     C*-------------------------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C*
     C                   ADD       WKLBAPBWMG    LBAPBWMG
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBAP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAO1                                                 ***
     C**************************************************************************
     C     UWAO1PCNR     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BGF2'        WAO1DANA
     C                   Z-ADD     DSLBPCPCJJ    WAO1JAHR
     C                   MOVEL(P)  DSLBPCPCNR    WAO1NMKR
     C                   Z-ADD     DSLBPCPOSI    WAO1POSI
     C*
     C                   MOVEL(P)  DAJNAM        WAO1JNAM
     C                   MOVEL(P)  WKCHPN        WAO1PROG
     C                   MOVEL(P)  WKCHPL        WAO1BIBL
     C                   MOVEL(P)  DAUSER        WAO1USER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO1JZEI
     C                   MOVE      WKTDAT        WAO1JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHWAO1
     C*
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO1
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBRS                                                 ***
     C**************************************************************************
     C     ULBRSBGF2     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C*
     C                   MOVEL(P)  *BLANK        LBRSAFDN
     C                   Z-ADD     *ZERO         LBRSAFJJ
     C                   MOVEL(P)  *BLANK        LBRSAFNR
     C                   Z-ADD     *ZERO         LBRSAFPO
     C                   MOVEL(P)  *BLANK        LBRSKDKZ
     C*
     C                   MOVEL(P)  'BGF2'        LBRSDANA
     C                   Z-ADD     DSLBPCPCJJ    LBRSJAHR
     C                   MOVEL(P)  DSLBPCPCNR    LBRSNMKR
     C                   Z-ADD     DSLBPCPOSI    LBRSPOSI
     C*
     C                   Z-ADD     DSLBPCRSMG    LBRSRSMG
     C*
     C                   MOVEL(P)  DSLBPCZULG    LBRSULAN
     C                   MOVEL(P)  DSLBPCZULO    LBRSUORT
     C*
     C                   MOVEL(P)  DAJNAM        LBRSJNAM
     C                   MOVEL(P)  WKCHPN        LBRSPROG
     C                   MOVEL(P)  WKCHPL        LBRSBIBL
     C                   MOVEL(P)  DAUSER        LBRSUSER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBRSJZEI
     C                   MOVE      WKTDAT        LBRSJDAT
     C                   SELECT
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBPC                                                 ***
     C**************************************************************************
     C     ULBPCBGF2     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBRSDANA      DSLBPCDANA
     C                   Z-ADD     LBRSJAHR      DSLBPCJAHR
     C                   MOVEL(P)  LBRSNMKR      DSLBPCNMKR
     C                   Z-ADD     LBRSPOSI      DSLBPCPOSI
     C*
     C                   MOVEL(P)  LBRSAFDN      DSLBPCAFDN
     C                   Z-ADD     LBRSAFJJ      DSLBPCAFJJ
     C                   MOVEL(P)  LBRSAFNR      DSLBPCAFNR
     C                   Z-ADD     LBRSAFPO      DSLBPCAFPO
     C                   Z-ADD     LBRSAFUP      DSLBPCAFUP
     C*
     C                   MOVEL(P)  LBRSBSTY      DSLBPCBSTY
     C                   MOVEL(P)  LBRSWKNR      DSLBPCWKNR
     C                   MOVEL(P)  LBRSKDNR      DSLBPCKDNR
     C                   MOVEL(P)  LBRSLFNR      DSLBPCLFNR
     C                   MOVEL(P)  LBRSLANR      DSLBPCLANR
     C                   MOVEL(P)  LBRSBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBRSTENR      DSLBPCTENR
     C                   MOVEL(P)  LBRSFBNR      DSLBPCFBNR
     C*
     C                   MOVEL(P)  LBRSGEBI      DSLBPCGEBI
     C                   MOVEL(P)  LBRSCONT      DSLBPCCONT
     C                   MOVEL(P)  LBRSBHNR      DSLBPCBHNR
     C                   MOVEL(P)  LBRSLORT      DSLBPCLORT
     C                   MOVEL(P)  LBRSCHAR      DSLBPCCHAR
     C                   MOVEL(P)  LBRSFUMG      DSLBPCFUMG
     C                   MOVEL(P)  LBRSMEIN      DSLBPCMEIN
     C                   Z-ADD     LBRSTMST      DSLBPCTMST
     C*
     C*****************  MOVEL(P)  LBRSULAN      DSLBPCZULG
     C*****************  MOVEL(P)  LBRSUORT      DSLBPCZULO
     C*
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   MOVEL(P)  *BLANK        DSLBPCPAKN
     C                   EXSR      ERGEWI
     C*
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVE      '00'          DSLBPCSTAT
     C                   EXSR      ULBPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-MOLBPCWAO                                                      ***
     C**************************************************************************
     C     MOLBPCWAO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     'PRLBPB'      EXTRNDPGST
     C*
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     DSLBPCPCJJ    DUN040
     C                   MOVEA(P)  DUC004        KOM(01)
     C                   MOVEA(P)  DSLBPCPCNR    KOM(05)
     C                   MOVEA(P)  KOM           EXTRNDKEYB
     C*
     C                   CALL      'MOLBPC'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PRLBAP     Abschluß Auslagerung                                ***
     C**************************************************************************
     C     ABLBAK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXLBPCDANA    KYLBPCDANA
     C                   Z-ADD     EXLBPCJAHR    KYLBPCJAHR
     C                   MOVEL(P)  EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCDANA      ORNE      KYLBPCDANA
     C     LBPCJAHR      ORNE      KYLBPCJAHR
     C     LBPCNMKR      ORNE      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD(H)  LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C*--------------------------------------------------------
     C                   SELECT
     C     LBPCSTAT      WHENEQ    '50'
     C     LBRSSTAT      ANDEQ     '90'
     C     LBPCSTAT      OREQ      '50'
     C     LBPCDANA      ANDEQ     'BGF2      '
     C     WKFENR        ANDNE     *ZERO
     C                   MOVEL(P)  PCPGST        WKPGST
     C                   MOVEL(P)  'UPSTAT'      PCPGST
     C                   MOVEL(P)  LBRSSTAT      DSLBPCSTAT
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   EXSR      ULBPC
     C                   MOVEL(P)  WKPGST        PCPGST
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB LBPC-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PLBPCLBAP     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      EXLBPCDANA    KYLBPCDANA
     C                   MOVE      EXLBPCJAHR    KYLBPCJAHR
     C                   MOVE      EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      EXLBPCPOSI    KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCDANA      ORGT      KYLBPCDANA
     C     LBPCJAHR      ORGT      KYLBPCJAHR
     C     LBPCNMKR      ORGT      KYLBPCNMKR
     C     LBPCPOSI      ORGT      KYLBPCPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'LBPCLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFGT      '50'
     C                   MOVEL(P)  '0014'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI LBPC                                          ***
     C**************************************************************************
     C     LLBPCLBAP     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      EXLBPCDANA    KYLBPCDANA
     C                   MOVE      EXLBPCJAHR    KYLBPCJAHR
     C                   MOVE      EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      EXLBPCPOSI    KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCDANA      ORGT      KYLBPCDANA
     C     LBPCJAHR      ORGT      KYLBPCJAHR
     C     LBPCNMKR      ORGT      KYLBPCNMKR
     C     LBPCPOSI      ORGT      KYLBPCPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBPC
     C*
     C                   EXSR      LPOSI
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB LBPC-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PLBPCBBKM     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      EXLBPCDANA    KYLBPCDANA
     C                   MOVE      EXLBPCJAHR    KYLBPCJAHR
     C                   MOVE      EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCDANA      ORGT      KYLBPCDANA
     C     LBPCJAHR      ORGT      KYLBPCJAHR
     C     LBPCNMKR      ORGT      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'LBPCLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFLT      '50'
     C                   MOVEL(P)  '0014'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI LBPC                                          ***
     C**************************************************************************
     C     LIBBKM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAKBUZT
     C                   MOVE      WKTDAT        LBAKBUDA
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXLBPCJAHR    KYBBKMKMJJ                     KOM-KOPF
     C                   MOVEL(P)  EXLBPCNMKR    KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C                   MOVEL(P)  BBKMLFNR      KYLFNR                         LIEFERANT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*
     C                   MOVE      *BLANK        WKLIEFLANR
     C                   MOVE      *BLANK        WKLIEFLORT
     C     LFLANR        IFNE      *BLANK                                       ABWICKLUNG
     C                   MOVEL     LFLANR        WKLIEFLANR
     C*
     C                   MOVEL     LFLANR        KYLDLA                         LAGERNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C     LDCHAO        IFEQ      DAJNKZ                                       CHAOT.LAGER !
     C                   MOVEL     LFLANR        WKLIEFLORT                     LAGERPLATZ =
     C                   ENDIF                                                  LAGERNUMMER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      EXLBPCDANA    KYLBPCDANA
     C                   MOVE      EXLBPCJAHR    KYLBPCJAHR
     C                   MOVE      EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCDANA      ORGT      KYLBPCDANA
     C     LBPCJAHR      ORGT      KYLBPCJAHR
     C     LBPCNMKR      ORGT      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     LBPCTMST      KYLBRSTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBRS
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL(P)  'DSLBPCTMST'  EXFLPOFLDN
     C                   MOVE      '2318'        WKFENR
     C                   LEAVE
     C     LBRSSTAT      WHENGE    '90'
     C                   MOVEL(P)  'U3BBLP'      #CPGST                         Lieferposition
     C                   EXSR      TRBBLP
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C                   OTHER
     C                   MOVEL(P)  'BLBRS '      #CPGST                         ENTNAHME
     C                   EXSR      T2LBRS
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'U3BBLP'      #CPGST                         Lieferposition
     C                   EXSR      TRBBLP
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  PCPGST        WKPGST
     C                   MOVEL(P)  'UPSTAT'      PCPGST
     C                   MOVEL(P)  '90'          DSLBPCSTAT
     C                   MOVE      LBPCTSTP      KYLBPCTSTP
     C                   EXSR      ULBPC
     C                   MOVEL(P)  WKPGST        PCPGST
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR=*ZERO
     C                   MOVEL(P)  'F7BBKM'      PCPGST
     C                   EXSR      TRBBKM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** BUCHEN MIT TRLBRS                                                  ***
     C**************************************************************************
     C     T2LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C*
     C     LFLANR        IFNE      *BLANK
     C     LBRSDANA      ANDEQ     'BBKM'
     C                   MOVEA     WKLIEFLANR    KOM(05)
     C                   MOVEA     WKLIEFLORT    KOM(08)
     C                   ENDIF
     C*
     C                   Z-ADD     LBAKBUDA      DUN080
     C                   MOVEA     DUC008        KOM(40)
     C                   Z-ADD     LBAKBUZT      DUN060                         BUCHUNGSZEIT
     C                   MOVEA     DUC006        KOM(48)
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        EXRSFIRM
     C                   MOVE      LBRSTMST      EXRSTMST
     C                   MOVEL     LBRSDANA      EXRSDANA
     C                   Z-ADD     LBRSJAHR      EXRSJAHR
     C                   MOVEL     LBRSNMKR      EXRSNMKR
     C                   Z-ADD     LBRSPOSI      EXRSPOSI
     C                   MOVEL     LBRSAFDN      EXRSAFDN
     C                   MOVEL     LBRSAFJJ      EXRSAFJJ
     C                   MOVEL     LBRSAFNR      EXRSAFNR
     C                   Z-ADD     LBRSAFPO      EXRSAFPO
     C                   Z-ADD     LBRSAFUP      EXRSAFUP
     C                   MOVEL     LBRSWKNR      EXRSWKNR
     C                   MOVEL     LBRSKDNR      EXRSKDNR
     C                   MOVEL     LBRSBSLA      EXRSBSLA
     C                   MOVEL     LBRSLANR      EXRSLANR
     C                   MOVEL     LBRSLORT      EXRSLORT
     C                   MOVEL     LBRSTENR      EXRSTENR
     C                   MOVEL     LBRSCHAR      EXRSCHAR
     C                   MOVE      LBRSBHNR      EXLBBHNR
     C                   MOVEL     LBRSGEBI      EXRSGEBI
     C                   Z-ADD     LBRSFUMG      EXRSFUMG
     C                   MOVEL     LBRSMEIN      EXRSMEIN
     C                   Z-ADD     LBPCRSMG      EXRSRMMG
     C*
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(1)        DUC011
     C                   Z-ADD     DUN112        DSGLMG                         GELIEFERTE MENGE
     C                   MOVEA     KOM(12)       DSTLKZ                         KOMPLETT-KZ
     C
     C                   MOVEL     RTRSFENR      WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BBLP                                                 ***
     C**************************************************************************
     C     TRBBLP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXBBLP
     C                   CLEAR                   RTBBLP
     C                   MOVEL(P)  #CPGST        EXBBLPPGST
     C                   Z-ADD     LBPCJAHR      EXBBLPKMJJ
     C                   MOVEL(P)  LBPCNMKR      EXBBLPKMNR
     C                   Z-ADD     LBPCPOSI      EXBBLPKMPO
     C                   Z-ADD     DSGLMG        EXBBLPGLMG
     C                   MOVEL     DSTLKZ        EXBBLPTLKZ
     C*
     C                   CALL      'TRBBLP'
     C                   PARM                    EXBBLP
     C                   PARM                    RTBBLP
     C*----------------------------------------------------------
     C                   MOVEL(P)  RTBBLPPROG    WKPROG
     C                   MOVEL(P)  RTBBLPDANA    WKDANA
     C                   MOVEL(P)  RTBBLPFFLD    WKFFLD
     C                   MOVEL(P)  RTBBLPFENR    WKFENR
     C                   MOVEL(P)  RTBBLPPA03    W$PA03
     C                   MOVEL(P)  RTBBLPPA04    W$PA04
     C                   MOVEL(P)  RTBBLPPA05    W$PA05
     C                   MOVEL(P)  RTBBLPPA06    W$PA06
     C                   MOVEL(P)  RTBBLPPA07    W$PA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BBKM                                                 ***
     C**************************************************************************
     C     TRBBKM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXBBKM
     C                   CLEAR                   RTBBKM
     C                   MOVEL(P)  PCPGST        EXBBKMPGST
     C                   Z-ADD     EXLBPCJAHR    EXBBKMKMJJ
     C                   MOVEL(P)  EXLBPCNMKR    EXBBKMKMNR
     C*
     C                   CALL      'TRBBKM'
     C                   PARM                    EXBBKM
     C                   PARM                    RTBBKM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTBBKMPROG    WKPROG
     C                   MOVEL(P)  RTBBKMDANA    WKDANA
     C                   MOVEL(P)  RTBBKMFFLD    WKFFLD
     C                   MOVEL(P)  RTBBKMFENR    WKFENR
     C                   MOVEL(P)  RTBBKMPA03    W$PA03
     C                   MOVEL(P)  RTBBKMPA04    W$PA04
     C                   MOVEL(P)  RTBBKMPA05    W$PA05
     C                   MOVEL(P)  RTBBKMPA06    W$PA06
     C                   MOVEL(P)  RTBBKMPA07    W$PA07
     C*
     C                   MOVEL(P)  RTBBKMRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RÜCKMELDEN AUFTRAGSTÜCKLISTE                                      ***
     C******************************************************+*******************
     C     TRAFUP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     LBPCRSMG      DUN112
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     LBPCAFJJ      DUN040
     C                   MOVEA     DUC004        KOM(01)
     C                   MOVEA     LBPCAFNR      KOM(05)
     C                   Z-ADD     LBPCAFPO      DUN040
     C                   MOVEA     DUC004        KOM(11)
     C                   Z-ADD     *ZERO         DUN040
     C                   MOVEA     DUC004        KOM(15)
     C                   MOVEA     DUC011        KOM(40)
     C*
     C                   MOVEA     WKTRPALSTC    KOM(119)
     C*
     C                   MOVEA(P)  '   '         KOM(122)
     C                   MOVEA(P)  DSLANR        KOM(125)
     C                   MOVEA(P)  DSLORT        KOM(128)
     C*
     C                   MOVEA(P)  DSLBPCBSLA    KOM(136)
     C                   MOVEA(P)  DSLBPCLANR    KOM(136)
     C                   MOVEA(P)  DSLBPCLORT    KOM(139)
     C                   MOVEA(P)  KOM           #CKOMM
     C*
     C                   CALL      'TRAFUP'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB LBPC-SATZ AUF DER PPL                                  ***
     C**************************************************************************
     C     PLBPCPPL      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      EXLBPCDANA    KYLBPCDANA
     C                   MOVE      EXLBPCJAHR    KYLBPCJAHR
     C                   MOVE      EXLBPCNMKR    KYLBPCNMKR
     C                   MOVE      *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBPCFIRM      IFGT      KYLBPCFIRM
     C     LBPCDANA      ORGT      KYLBPCDANA
     C     LBPCJAHR      ORGT      KYLBPCJAHR
     C     LBPCNMKR      ORGT      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFLE      '50'
     C*
     C     LBPCPCJJ      IFNE      EXLBPCPCJJ
     C     LBPCPCNR      ORNE      EXLBPCPCNR
     C                   MOVEL(P)  '3205'        WKFENR
     C                   EVAL       W$PA03 = %CHAR(LBPCPCJJ)+LBPCPCNR
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  WKPROG        RTLBPCPROG
     C                   MOVEL(P)  WKDANA        RTLBPCDANA
     C                   MOVEL(P)  WKFFLD        RTLBPCFFLD
     C                   MOVEL(P)  WKFENR        RTLBPCFENR
     C                   MOVEL(P)  W$PA03        RTLBPCPA03
     C                   MOVEL(P)  W$PA04        RTLBPCPA04
     C                   MOVEL(P)  W$PA05        RTLBPCPA05
     C                   MOVEL(P)  W$PA06        RTLBPCPA06
     C                   MOVEL(P)  W$PA07        RTLBPCPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LLBRS  LÖSCHEN SÄTZE AUS DATEI LBRS                               ***
     C**************************************************************************
     C     LLBRS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   MOVEL     *BLANK        KOM
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBRSTMST      EXRSTMST                         ERSTER SATZ
     C                   MOVEL     'DLBRS '      #CPGST                         CHAOTISCH ODER
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBLB                                                 ***
     C**************************************************************************
     C     TRLBB1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   CLEAR                   RTLBLB
     C                   MOVEL     LBRSBSTY      RTLBBSTY
     C                   MOVEL     LBRSFIRM      EXLBFIRM
     C                   MOVEL     LBRSWKNR      EXLBWKNR
     C                   MOVEL     LBRSLANR      EXLBLANR
     C                   MOVEL     LBRSBSLA      EXLBBSLA
     C                   MOVEL     LBRSTENR      EXLBTENR
     C                   MOVEL     LBRSFBNR      EXLBFBNR
     C                   MOVEL     LBRSGEBI      EXLBGEBI
     C                   MOVEL     LBRSCONT      EXLBCONT
     C                   MOVEL     LBRSBHNR      EXLBBHNR
     C                   MOVEL     LBRSLORT      EXLBLORT
     C                   MOVEL     LBRSCHAR      EXLBCHAR
     C                   MOVEL     LBRSFUMG      EXLBFUMG
     C                   MOVEL     LBRSKDNR      EXLBKDNR
     C                   MOVEL     LBRSLFNR      EXLBLFNR
     C                   MOVEL     LBRSMEIN      EXLBMEIN
     C                   MOVEL     LBRSQUMM      EXLBQUMM
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DAJNKZ        KOM(01)
     C                   MOVEA     WKTRPASPGR    KOM(02)
     C                   MOVEA     *ON           KOM(04)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     'ULBBS '      #CPGST
     C*
     C                   CALL      'TRLBB1'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C     RTLBFENR      IFGT      *ZERO
     C                   MOVEL(P)  RTLBFENR      WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN PICKLISTE KOMPLETT                                     ***
     C**************************************************************************
     C     GNLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPENLBRS
     C*-------------------------------------------------------------------------
     C     LBPCTENR      IFNE      KYTENR
     C                   MOVEL(P)  LBPCTENR      KYTENR                         PRÜFEN
     C                   MOVEL     *BLANK        KYTEEZ                         IDENTNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     TEKLSP        WHENEQ    *ON                                          KOM/LIEFER- Sperre
     C                   EXSR      EXUXCLOSLBRS
     C                   LEAVESR
     C*
     C                   OTHER
     C*
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     *BLANK        KOM(01)
     C                   MOVEL     *OFF          KOM(29)
     C                   MOVEL     *OFF          KOM(38)
     C                   MOVEL     *OFF          KOM(39)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     DAFIRM        EXRSFIRM
     C                   MOVEL     LBRSDANA      EXRSDANA                         FÜLLEN
     C                   MOVEL     LBRSJAHR      EXRSJAHR
     C                   MOVEL     LBRSNMKR      EXRSNMKR
     C                   Z-ADD     LBRSPOSI      EXRSPOSI
     C                   MOVEL     LBRSAFDN      EXRSAFDN
     C                   MOVEL     LBRSAFJJ      EXRSAFJJ
     C                   MOVEL     LBRSAFNR      EXRSAFNR
     C                   Z-ADD     LBRSAFPO      EXRSAFPO
     C                   Z-ADD     LBRSAFUP      EXRSAFUP
     C                   MOVEL     DSLANR        EXRSLANR
     C                   MOVEL     DSLBPCTENR    EXRSTENR
     C                   MOVEL     LBRSGEBI      EXRSGEBI
     C                   Z-ADD     LBRSFUMG      EXRSFUMG
     C                   MOVEL     LBRSMEIN      EXRSMEIN
     C                   Z-ADD     WKLBRSRSMG    EXRSRSMG
     C     EXRSAFDN      IFEQ      'AFPO'
     C     EXRSAFDN      OREQ      'AFUP'
     C                   MOVEL     'L'           EXRSKDKZ
     C                   ENDIF
     C                   MOVEL     'RLBRS'       #CPGST
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*
     C                   Z-ADD     *ZERO         DSLBPCRSMG
     C                   MOVEL(P)  LBRSAFDN      DSLBPCAFDN
     C                   Z-ADD     LBRSAFJJ      DSLBPCAFJJ
     C                   MOVEL     LBRSAFNR      DSLBPCAFNR
     C                   Z-ADD     LBRSAFPO      DSLBPCAFPO
     C                   Z-ADD     LBRSAFUP      DSLBPCAFUP
     C                   EXSR      E5LBRS
     C*
     C                   IF        DSLBPCRSMG = *ZERO
     C                   EXSR      EXUXCLOSLBRS
     C                   MOVE      '2318'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*--------------------------------------------------------
     C* Bearbeiten LBRS aus dem ertsn Index
     C*--------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*
     C                   EVAL      LBRS = %SUBST(EXUX01IDTA: 101: %LEN(LBRS))
     C*
     C                   Z-ADD     DSLBPCPCJJ    DSLBPCPCJJ
     C                   MOVEL(P)  DSLBPCPCNR    DSLBPCPCNR
     C                   MOVEL(P)  *BLANK        DSLBPCPAKN
     C                   MOVEL(P)  '00'          DSLBPCSTAT
     C                   MOVEL(P)  LBRSDANA      DSLBPCDANA
     C                   Z-ADD     LBRSJAHR      DSLBPCJAHR
     C                   MOVEL(P)  LBRSNMKR      DSLBPCNMKR
     C                   Z-ADD     LBRSPOSI      DSLBPCPOSI
     C                   MOVEL(P)  LBRSAFDN      DSLBPCAFDN
     C                   Z-ADD     LBRSAFJJ      DSLBPCAFJJ
     C                   MOVEL(P)  LBRSAFNR      DSLBPCAFNR
     C                   Z-ADD     LBRSAFPO      DSLBPCAFPO
     C                   Z-ADD     LBRSAFUP      DSLBPCAFUP
     C                   MOVEL(P)  LBRSBSTY      DSLBPCBSTY
     C                   MOVEL(P)  LBRSWKNR      DSLBPCWKNR
     C                   MOVEL(P)  LBRSKDNR      DSLBPCKDNR
     C                   MOVEL(P)  LBRSLFNR      DSLBPCLFNR
     C                   MOVEL(P)  LBRSLANR      DSLBPCLANR
     C                   MOVEL(P)  LBRSBSLA      DSLBPCBSLA
     C                   MOVEL(P)  LBRSTENR      DSLBPCTENR
     C                   MOVEL(P)  LBRSFBNR      DSLBPCFBNR
     C                   MOVEL(P)  LBRSGEBI      DSLBPCGEBI
     C                   MOVEL(P)  LBRSCONT      DSLBPCCONT
     C                   MOVEL(P)  LBRSBHNR      DSLBPCBHNR
     C                   MOVEL(P)  LBRSLORT      DSLBPCLORT
     C                   MOVEL(P)  LBRSCHAR      DSLBPCCHAR
     C                   MOVEL(P)  LBRSFUMG      DSLBPCFUMG
     C                   MOVEL(P)  LBRSMEIN      DSLBPCMEIN
     C*                  MOVEL(P)  LBRSBSLA      DSLBPCABBL
     C*                  MOVEL(P)  LBRSLANR      DSLBPCABLA
     C*                  MOVEL(P)  LBRSLORT      DSLBPCABLO
     C                   MOVEL(P)  DSLBPCZULG    DSLBPCZULG
     C                   MOVEL(P)  DSLBPCZULO    DSLBPCZULO
     C                   Z-ADD     LBRSRSMG      DSLBPCRSMG
     C                   EXSR      ERGEWI
     C                   Z-ADD     LBRSTMST      DSLBPCTMST
     C                   MOVEL(P)  PCPGST        W$PGST
     C                   MOVEL     'GNBGFS'      PCPGST
     C                   EXSR      ULBPC
     C                   MOVEL(P)  W$PGST        PCPGST
     C*
     C                   MOVE      LBRSTMST      D1LBPCTMST
     C                   MOVE      '07'          WKIFMT
     C                   EXSR      BILD07
     C
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOSLBRS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** ERMITTLEN LBRS-SATZ  für Pickliste                                 ***
     C**************************************************************************
     C     E5LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBRSDANA      KYLBRSDANA                     ERSTER SATZ
     C                   Z-ADD     LBRSJAHR      KYLBRSJAHR
     C                   MOVEL     LBRSNMKR      KYLBRSNMKR
     C                   Z-ADD     LBRSPOSI      KYLBRSPOSI
     C                   MOVE      *LOVAL        KYLBRSTMST
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBRSFIRM      IFGT      KYLBRSFIRM
     C     LBRSDANA      ORGT      KYLBRSDANA
     C     LBRSJAHR      ORGT      KYLBRSJAHR
     C     LBRSNMKR      ORGT      KYLBRSNMKR
     C     LBRSPOSI      ORGT      KYLBRSPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSDANA      IFEQ      'AFKM'
     C     LBRSAFDN      IFNE      DSLBPCAFDN
     C     LBRSAFJJ      ORNE      DSLBPCAFJJ
     C     LBRSAFNR      ORNE      DSLBPCAFNR
     C     LBRSAFPO      ORNE      DSLBPCAFPO
     C     LBRSAFUP      ORNE      DSLBPCAFUP
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ITER
     C                   ENDIF
     C
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSSTAT      IFEQ      *BLANK
     C     LBRSTENR      ANDEQ     DSLBPCTENR
     C*
     C                   MOVE      LBRSTMST      KYLBPCTMST
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     WKFENR        IFNE      *ZERO
     C     LBPCFIRM      ORNE      KYLBPCFIRM
     C     LBPCTMST      ORNE      KYLBPCTMST
     C                   MOVEL(P)  LBRSLANR      KYLLLA
     C                   MOVEL(P)  LBRSLORT      KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C                   Z-ADD     LLZGFK        DUN030
     C*
     C                   Z-ADD     LBRSTMST      DUN260
     C                   EVAL      W1SORT = LBRSBSLA + LBRSLANR + DUC003 +
     C                             LBRSLORT + LBAPTENR + DUC026
     C*
     C                   EVAL      EXUX01IDTA = W1SORT   + LBRS
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*
     C                   ADD       LBRSRSMG      DSLBPCRSMG
     C*
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPENLBRS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1 '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG =  100+900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG =  100                            MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                         '
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE  USERINDEX                                                  ***
     C**************************************************************************
     C     EXUXCLOSLBRS  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHLBAK
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHLBPL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLBPC
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBVS
     C/COPY QCPYSRC,CHWAOR
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
