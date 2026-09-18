     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2009')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 15.11.2010 WAECO Projekt 6883
     H*  Änderung: ZG 19.11.2010 WAECO Projekt 6943 Anzeige KDEW
     H*  Änderung: ZG 21.12.2010 WAECO Preis PVK
     H*  Änderung: ZG 12.06.2012 Projekt 8399 - Übernahme ZOTN,URLD,ZPUR in den
     H*            Kundenstamm.
     H*  Änderung: ZG 20.08.2012 Projekt 8762 - Einzel-Picklistensteuerung
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Programm für die kundenspezifischen Prüfungen und Ermittlungen
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXGEWI        E DS                  INZ
     D RTGEWI        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXPRKO01      E DS                  INZ
     D RTPRKO01      E DS                  INZ
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERBLKZ'
     C                   MOVEL(P)  WKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   EVAL      TXPDIM = *BLANK
     C                   EVAL      TXMEPR = *BLANK
     C                   EVAL      TXPRAR = *BLANK
     C                   EVAL      DSEZPR = *ZERO
     C*
     C     KDEWBLKZ      IFEQ      *ON
     C                   EXSR      EREZPR
     C                   ENDIF
     C*
     C                   Z-ADD     DSEZPR        DUN113
     C                   EVAL      RTTRNDDATE = KDEWBLKZ + TXPDIM + TXMEPR +
     C                                          TXPRAR + DUC011
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'EREZPL'
     C                   MOVEL(P)  WKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   EVAL      RTTRNDDATE = KDEWEZPL
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERKSST'
     C                   MOVEL     WKAFJJ        KYAKJH
     C                   MOVEL     WKAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   EVAL      RTTRNDDATE = KDEWKSST
     C     KDEWKSST      IFEQ      *BLANK
     C                   MOVEL     WKAFJJ        KYAPJH
     C                   MOVEL     WKAFNR        KYAPAF
     C                   MOVEL     WKAFPO        KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*
     C                   MOVEL(P)  APTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   EVAL      RTTRNDDATE = TEKOTR
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERKDEW'
     C                   MOVEL(P)  WKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVEL(P)  WKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL(P)  KDDRZN        KDEWZOTN
     C                   MOVEL(P)  KDDRZP        KDEWZPUR
     C                   MOVEL(P)  KDDRUL        KDEWURLD
     C*
     C                   EVAL      RTTRNDDATE = KDEW
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKPROG
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKBIBL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       WKKDNR
     C                   MOVEA     KOM(11)       WKTENR
     C                   MOVEA     KOM(26)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN112        WKBSMG
     C                   MOVEA     KOM(38)       WKMEIN
     C                   MOVEA     KOM(39)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        WKAFJJ
     C                   MOVEA     KOM(43)       WKAFNR
     C                   MOVEA     KOM(49)       DUC005
     C                   TESTN                   DUC005               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        WKAFPO
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
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BRUTTO-PREIS                                            ***
     C**************************************************************************
     C     EREZPR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXPRKO01
     C                   CLEAR                   RTPRKO01
     C                   MOVEL     'V'           EXPRKOVPKZ
     C                   MOVEL     'PVK'         EXPRKOPRAR                     KUNDEN/PRODUKTPREIS
     C                   MOVEL     KDKDNR        EXPRKOKDNR                     HAT VORRANG
     C                   MOVEL     TETENR        EXPRKOTENR
     C                   MOVEL     KDWACD        EXPRKOWACD
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     *DATE         EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    EXPRKODATE
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTUTE                         UMRECHNEN
     C                   MOVEL(P)  WKMEIN        KYTUME                         MENGE IN
     C                   Z-ADD     WKBSMG        WKV1V2                         IDENT-ME
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKTEMG
     C*--------------------------------------------------------
     C                   CLEAR                   EXGEWI
     C                   MOVEL     TETENR        EXGEWITENR
     C                   Z-ADD     WKTEMG        EXGEWIMENG
     C                   MOVEL     TEMEIN        EXGEWIMEIN
     C*
     C                   CALL      'ERGEWI'
     C                   PARM                    EXGEWI
     C                   PARM                    RTGEWI
     C*
     C                   Z-ADD     RTGEWIGWNT    EXPRKOGWNT
     C*--------------------------------------------------------
     C                   MOVEL     TETENR        KYTUTE                         UMRECHNEN
     C                   MOVEL     TEMPVK        KYTUME                         MENGE IN
     C                   Z-ADD     WKTEMG        WKV2V1                         VERKAUF-ME
     C                   EXSR      VTEUF                                        IDENTSTAMM
     C                   Z-ADD     WKV2V1        EXPRKOMENG
     C                   MOVEL     WKMEIN        EXPRKOMEIN                     BESTELL-ME
     C*--------------------------------------------------------
     C                   MOVEL     KDVSBD        EXPRKOVSBD
     C                   MOVEL     KDLIBD        EXPRKOLIBD
     C*
     C                   CALL      'ERPRKO'                             99
     C                   PARM                    EXPRKO01
     C                   PARM                    RTPRKO01
     C*-------------------------------------------------------------------------
     C     RTPRKOPREI    IFNE      *ZERO
     C                   Z-ADD     RTPRKOPREI    DSEZPR
     C*----------------------------------------------------------
     C                   MOVEL     KDSPCD        KYTPSP
     C                   MOVEL     'MEIN'        KYTPTA
     C                   MOVEL     RTPRKOMEPR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'MEIN'        KYTPTA
     C                   MOVEL     RTPRKOMEPR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C                   MOVEL     TPTTXT        TXMEPR
     C*----------------------------------------------------------
     C                   MOVEL     KDSPCD        KYTPSP
     C                   MOVEL     'PRAR'        KYTPTA
     C                   MOVEL     RTPRKOPRAR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'PRAR'        KYTPTA
     C                   MOVEL     RTPRKOPRAR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C                   MOVEL     TPTTXT        TXPRAR
     C*----------------------------------------------------------
     C                   MOVEL     KDSPCD        KYTPSP
     C                   MOVEL     'PDIM'        KYTPTA
     C                   MOVEL     RTPRKOPDIM    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'PDIM'        KYTPTA
     C                   MOVEL     RTPRKOPDIM    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C                   MOVEL     TPTTXT        TXPDIM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
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
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    KDKDNR        WKKDNR
     C     *LIKE         DEFINE    TETENR        WKTENR
     C     *LIKE         DEFINE    APAFJJ        WKAFJJ
     C     *LIKE         DEFINE    APAFNR        WKAFNR
     C     *LIKE         DEFINE    APAFPO        WKAFPO
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TPTTXT        TXPDIM
     C     *LIKE         DEFINE    TPTTXT        TXMEPR
     C     *LIKE         DEFINE    TPTTXT        TXPRAR
     C     *LIKE         DEFINE    DUN113        DSEZPR
     C     *LIKE         DEFINE    DUN112        WKBSMG
     C     *LIKE         DEFINE    DUN112        WKTEMG
     C     *LIKE         DEFINE    TEMEIN        WKMEIN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
