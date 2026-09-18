     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Lager-Zugang Wareneingang MDE buchen
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: VU 20.06.2012 Projekt 8469 DOMETIC
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 13.09.2012 keine Prüfung auf Position, wenn Art = '400'
     H*  Änderung: RE/PH 28./30.11.2012 DOMETIC Projekt 8914. Anpassung Aufruf ULGPO. Erweiterung
     H*            EXLGPO um EXLGPOBARC für die Übergabe des Barcodes aus DSLGWEBARC
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Verbuchung von Lager-Zugang Wareneingang
     F*  mit MDE-Geräten
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FT2LGPOFM  CF   E             WORKSTN USROPN
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
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ
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
     D LGWE          E DS                  INZ
     D KYLGWE        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
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
     D EXTR02        E DS
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
     D EXLGFB        E DS                  INZ
     D RTLGFB        E DS                  INZ
     D*
     D EXLGPO        E DS                  INZ
     D RTLGPO        E DS                  INZ
     D*
     D EXLGWE        E DS                  INZ
     D RTLGWE        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXWAOO        E DS                  INZ
     D RTWAOO        E DS                  INZ
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
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
     C                   CLOSE     T2LGPOFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
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
     C                   OPEN      T2LGPOFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01                         LAGER-ZUGANG
     C     WKIFMT        CASEQ     '02'          BILD02                         BUCHUNG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     T2LGPOFM                             98
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
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLBLBFIRM                     LBLB
     C                   MOVEL(P)  DAFIRM        KYLGKOFIRM                     LGKO
     C                   MOVEL(P)  DAFIRM        KYLGPAFIRM                     LGPA
     C                   MOVEL(P)  DAFIRM        KYLGPOFIRM                     LGPO
     C                   MOVEL(P)  DAFIRM        KYLGWEFIRM                     LGWE
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T2LGPOFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'T2LGPOFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER                                 ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVE      #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFNE      *ON
     C                   MOVE      *ZERO         DUC004
     C                   ENDIF
     C                   Z-ADD     DUN040        DSLGPOLGJJ
     C                   MOVEA(P)  KOM(05)       DSLGPOLGNR
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
     C                   MOVE      *OFF          C#LCK3
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C                   MOVE      C#LCK2        WKIN32
     C                   MOVE      C#LCK3        WKIN33
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
     C                   MOVEL(P)  'T2LGPO'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99(32)       W1KOPF
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
     C                   MOVEL     'T2LGPO01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     T2LGPO01
     C                   WRITE     T2LGPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT02
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      T2LGPO01                             9899
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
     C     C#FT02        OREQ      *ON
     C     FUKT02        ANDEQ     *ON
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
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C* keine Verwaltung
     C     PCPGST        WHENEQ    '5     '
     C* keine Verwaltung
     C                   OTHER
     C                   MOVE      '02'          WKIFMT
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
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'T2LGPO01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSLGPOLGJJ'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSLGPOLGJJ'  EXFLPOFLDN
     C                   ENDSL
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
     C                   MOVEL     'T2LGPO02'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     T2LGPO02
     C                   WRITE     T2LGPOB2
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT02
     C*                  MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*-------------------------------------------------------------------------
     C*    WKBUMG        IFGT      *ZERO
     C*    DSISTMENGE    ANDGT     *ZERO
     C*                  EVAL      W$PA03 = %TRIM(%EDITW(WKBUMG :
     C*                             '     0,    '))
     C*                  MOVE      '0690'        WKFENR
     C*                  ENDIF
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      T2LGPO02                             9899
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
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
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
     C     C#FT05        WHENEQ    *ON
     C     FUKT05        ANDEQ     *ON
     C                   EXSR      B02DS
     C                   ITER
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
     C     C#FT02        OREQ      *ON
     C     FUKT02        ANDEQ     *ON
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
     C*
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      LGKOLGAT    = '400'
     C                   EXSR      ULGPO
     C                   OTHER
     C                   EXSR      BULGWE
     C                   ENDSL
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   LEAVE
     C                   ENDIF
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
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        DSLGPOTENR
     C                   Z-ADD     *ZERO         DSISTMENGE
     C                   MOVEL(P)  *BLANK        DSLGWEBARC
     C                   MOVEL(P)  *BLANK        DSLGFBFBNR
     C                   MOVEL(P)  *BLANK        DSWAOOPERG
     C                   MOVEL(P)  *BLANK        DSWAOOFEAR
     C                   MOVEL(P)  *BLANK        DSWAOOFEUS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRBC2902'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSLGPOTENR'  EXFLPOFLDN
     C                   ENDSL
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
     C     FLDNAM        ANDEQ     'DSLGPOLGJJ'
     C                   MOVE      '0052'        WKFENR
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
     C     FLDNAM        WHENEQ    'DSLGPOLGJJ'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRLGPOLGJJ
     C     FLDNAM        WHENEQ    'DSLGPOLGNR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRLGPOLGNR
     C     FLDNAM        WHENEQ    'DSLGPOTENR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRLGPOTENR
     C     FLDNAM        WHENEQ    'DSISTMENGE'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRISTMENGE
     C     FLDNAM        WHENEQ    'DSLGWEBARC'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRLGWEBARC
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      '      '
     C*
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGJJ                                                   ***
     C**************************************************************************
     C     PRLGPOLGJJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLGPOLGJJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSLGPOLGJJ    IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE LGNR                                                   ***
     C**************************************************************************
     C     PRLGPOLGNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLGPOLGNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSLGPOLGJJ    KYLGKOLGJJ
     C                   MOVEL(P)  DSLGPOLGNR    KYLGKOLGNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGKO
     C*
     C                   MOVEL(P)  LGKOLGAT      KYLGPALGAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     LGPAWEKZ      ANDEQ     DANEKZ
     C                   MOVEL     LGPALANR      DSLBLBLANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRLGPOTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLGPOTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSLGPOTENR <> *BLANK
     C                   MOVEL(P)  DSLGPOTENR    KYTEEA                         ERST ÜBER EAN SUCHEN
     C                   MOVEA     '91C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   IF        WKFENR      = *ZERO
     C                   EVAL      DSLGPOTENR  = TETENR
     C                   ELSE
     C                   EVAL      WKFENR      = *ZERO
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSLGPOTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  TETENR        DSLGPOTENR
     C                   Z-ADD     *ZERO         WKOFFENMNG
     C                   Z-ADD     *ZERO         WKANZA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      LGKOLGAT    = '400'
     C**                 EXSR      ULGPO
     C                   OTHER
     C                   EXSR      PROFFENMNG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE OFFENE MENGE                                           ***
     C**************************************************************************
     C     PROFFENMNG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSLGPOLGJJ    KYLGPOLGJJ
     C                   MOVEL(P)  DSLGPOLGNR    KYLGPOLGNR
     C                   MOVEL(P)  DSLGPOTENR    KYLGPOTENR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLGPO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LGPOFIRM      IFNE      KYLGPOFIRM
     C     LGPOLGJJ      ORGT      KYLGPOLGJJ
     C     LGPOLGNR      ORGT      KYLGPOLGNR
     C     LGPOTENR      ORGT      KYLGPOTENR
     C     WKANZA        IFEQ      *ZERO
     C                   MOVEL(P)  '0688'        WKFENR
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   ADD       1             WKANZA
     C*----------------------------------------------------------
     C     LGPOSTAT      IFGE      '20'
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLGPO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C     LGPOSOMG      IFGT      LGPOISMG
     C     LGPOSOMG      SUB       LGPOISMG      WKMENG
     C                   ADD       WKMENG        WKOFFENMNG
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLGPO
     C                   MOVE      *ZERO         WKFENR
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE MENG                                                   ***
     C**************************************************************************
     C     PRISTMENGE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSISTMENGE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     DSISTMENGE    WHENEQ    *ZERO
     C                   MOVEL(P)  '0031'        WKFENR
     C     DSISTMENGE    WHENGT    WKOFFENMNG
     C     LGKOLGAT      ANDNE     '400'
     C                   EVAL      W$PA03 = %TRIM(%EDITW(WKOFFENMNG :
     C                              '     0,    '))
     C                   MOVEL     '0689'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE BARC                                                   ***
     C**************************************************************************
     C     PRLGWEBARC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSLGWEBARC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     LGPABARC      IFEQ      DAJNKZ
     C*
     C     DSLGWEBARC    IFEQ      *BLANK
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-BULGWE     VERBUCHUNG MATERIALENTNAHME PRODUKTION              ***
     C**************************************************************************
     C     BULGWE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSLGPOLGJJ    KYLGPOLGJJ
     C                   MOVEL(P)  DSLGPOLGNR    KYLGPOLGNR
     C                   MOVEL(P)  DSLGPOTENR    KYLGPOTENR
     C*
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLGPO
     C                   MOVE      *ZERO         WKFENR
     C                   Z-ADD     *ZERO         WKBUMG
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LGPOFIRM      IFNE      KYLGPOFIRM
     C     LGPOLGJJ      ORGT      KYLGPOLGJJ
     C     LGPOLGNR      ORGT      KYLGPOLGNR
     C     LGPOTENR      ORGT      KYLGPOTENR
     C     DSISTMENGE    ORLE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C     LGPOLOCK      IFEQ      'L'
     C     LGPOSTAT      ORGE      '20'
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLGPO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C     LGPOSOMG      IFGT      LGPOISMG
     C*
     C     LGPOSOMG      SUB       LGPOISMG      WKMENG
     C     WKMENG        IFGT      DSISTMENGE
     C                   Z-ADD     DSISTMENGE    WKMENG
     C                   ENDIF
     C*
     C                   MOVEL(P)  'BUCHEN'      PCPGST
     C                   EXSR      TRLGWE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   SUB       WKMENG        DSISTMENGE
     C                   ADD       WKMENG        WKBUMG
     C                   EXSR      TRLGFB
     C     MODWAO        IFEQ      *ON
     C                   EXSR      TRWAOO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLGPO
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LGWE                                                 ***
     C**************************************************************************
     C     TRLGWE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLGWE
     C                   MOVEL(P)  PCPGST        EXLGWEPGST
     C                   Z-ADD     LGPOLGJJ      EXLGWELGJJ
     C                   MOVEL(P)  LGPOLGNR      EXLGWELGNR
     C                   Z-ADD     LGPOLGPO      EXLGWELGPO
     C                   MOVEL(P)  DSLGWEBARC    EXLGWEBARC
     C                   Z-ADD     WKMENG        EXLGWEISMG
     C                   MOVEL(P)  DANEKZ        EXLGWETLKZ
     C*
     C                   CALL      'TRLGWE'                             99
     C                   PARM                    EXLGWE
     C                   PARM                    RTLGWE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLGWEPROG    WKPROG
     C                   MOVEL(P)  RTLGWEDANA    WKDANA
     C                   MOVEL(P)  RTLGWEFFLD    WKFFLD
     C                   MOVEL(P)  RTLGWEFENR    WKFENR
     C                   MOVEL(P)  RTLGWEPA03    W$PA03
     C                   MOVEL(P)  RTLGWEPA04    W$PA04
     C                   MOVEL(P)  RTLGWEPA05    W$PA05
     C                   MOVEL(P)  RTLGWEPA06    W$PA06
     C                   MOVEL(P)  RTLGWEPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LGFB                                                 ***
     C**************************************************************************
     C     TRLGFB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSLGFBFBNR    IFEQ      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLGFB
     C                   MOVE      *OFF          EXLGFBIFKZ
     C                   Z-ADD     LGPOLGJJ      EXLGFBLGJJ
     C                   MOVEL(P)  LGPOLGNR      EXLGFBLGNR
     C                   Z-ADD     LGPOLGPO      EXLGFBLGPO
     C                   MOVEL(P)  DSLGFBFBNR    EXLGFBFBNR
     C*
     C                   CALL      'TRLGFB'                             99
     C                   PARM                    EXLGFB
     C                   PARM                    RTLGFB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLGFBPROG    WKPROG
     C                   MOVEL(P)  RTLGFBDANA    WKDANA
     C                   MOVEL(P)  RTLGFBFFLD    WKFFLD
     C                   MOVEL(P)  RTLGFBFENR    WKFENR
     C                   MOVEL(P)  RTLGFBPA03    W$PA03
     C                   MOVEL(P)  RTLGFBPA04    W$PA04
     C                   MOVEL(P)  RTLGFBPA05    W$PA05
     C                   MOVEL(P)  RTLGFBPA06    W$PA06
     C                   MOVEL(P)  RTLGFBPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOO                                                 ***
     C**************************************************************************
     C     TRWAOO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     DSWAOOPERG    IFEQ      *BLANK
     C     DSWAOOFEAR    ANDEQ     *BLANK
     C     DSWAOOFEUS    ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOO
     C                   MOVE      *OFF          EXWAOOIFKZ
     C                   Z-ADD     LGPOLGJJ      EXWAOOLGJJ
     C                   MOVEL(P)  LGPOLGNR      EXWAOOLGNR
     C                   Z-ADD     LGPOLGPO      EXWAOOLGPO
     C                   MOVEL(P)  DSLGFBFBNR    EXWAOOFBNR
     C                   MOVEL(P)  DSWAOOPERG    EXWAOOPERG
     C                   MOVEL(P)  DSWAOOFEAR    EXWAOOFEAR
     C                   MOVEL(P)  DSWAOOFEUS    EXWAOOFEUS
     C                   CLEAR                   EXWAOOTSTP
     C*
     C                   CALL      'TRWAOO'                             99
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
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
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
     C                   MOVEA     'DANA'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKTRPA
     C                   MOVE      DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'T2LGPO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         OB KACO AKTIV
     C                   MOVEL     'MODWAO'      KYTATC                         IST
     C                   MOVEL     'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C*
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODWAO
     C*
     C                   IF        MODWAO     <> *ON
     C                   EVAL      MODWAO      = *OFF
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
     C                   MOVEL(P)  'T2LGPO'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'T2LGPOB1'    EXTRDNPGNA
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
     C***  UPDATE LGPO                                                       ***
     C**************************************************************************
     C     ULGPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      LGPOLGPO    = *ZERO
     C                   EXSR      TRLGPO
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      LGPOLGJJ    = RTLGPOLGJJ
     C                   EVAL      LGPOLGNR    = RTLGPOLGNR
     C                   EVAL      LGPOLGPO    = RTLGPOLGPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE LGPO                                                       ***
     C**************************************************************************
     C     TRLGPO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLGPO
     C                   MOVEL(P)  PCPGST        EXLGPOPGST
     C                   Z-ADD     DSLGPOLGJJ    EXLGPOLGJJ
     C                   MOVEL(P)  DSLGPOLGNR    EXLGPOLGNR
     C                   MOVEL(P)  DSLGPOTENR    EXLGPOTENR
     C                   Z-ADD     DSISTMENGE    EXLGPOSOMG
     C                   MOVEL(P)  TEMEIN        EXLGPOMEIN
     C                   MOVEL(P)  DSLGWEBARC    EXLGPOBARC
     C                   MOVEL(P)  *ON           EXLGPOIFKZ
     C*
     C                   CALL      'TRLGPO'                             99
     C                   PARM                    EXLGPO
     C                   PARM                    RTLGPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLGPOPROG    WKPROG
     C                   MOVEL(P)  RTLGPODANA    WKDANA
     C                   MOVEL(P)  RTLGPOFFLD    WKFFLD
     C                   MOVEL(P)  RTLGPOFENR    WKFENR
     C                   MOVEL(P)  RTLGPOPA03    W$PA03
     C                   MOVEL(P)  RTLGPOPA04    W$PA04
     C                   MOVEL(P)  RTLGPOPA05    W$PA05
     C                   MOVEL(P)  RTLGPOPA06    W$PA06
     C                   MOVEL(P)  RTLGPOPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *BLANK
     C                   MOVE      *ZERO         WKFENR
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
     C     *LIKE         DEFINE    WKC001        WKOPEN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTLKZ
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C     *LIKE         DEFINE    WKC001        WKIN32
     C     *LIKE         DEFINE    WKC001        WKIN33
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        FL              + 3
     C     *LIKE         DEFINE    WKN010        WKPROK
     C     *LIKE         DEFINE    WKN010        WKSATZ          + 4
     C     *LIKE         DEFINE    WKN010        WKANZA
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    LGPOSOMG      WKMENG
     C     *LIKE         DEFINE    DUN104        WKOFFENMNG
     C     *LIKE         DEFINE    DUN104        WKBUMG
     C     *LIKE         DEFINE    RTLGWEPROG    WKPROG
     C     *LIKE         DEFINE    RTLGWEDANA    WKDANA
     C     *LIKE         DEFINE    RTLGWEFFLD    WKFFLD
     C     *LIKE         DEFINE    LBLBLANR      DSLBLBLANR
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
     C                   MOVEL(P)  'T2LGPO'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTLGPOW2
     C                   OTHER
     C                   WRITE     T2LGPOCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTLGPOW2
     C                   OTHER
     C                   WRITE     T2LGPOCT
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
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPA
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,CHLGWE
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTEIL
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
