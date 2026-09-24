     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Ermitteln Kostenstelle
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 26.12.2010
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 05.07.2012 Auch bei Begriff "WEIN" (ohne PRGR, ohne AFAT)
     H*            die Kostenstelle umschlüsseln.
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm ermittelt die Kostenstelle aus dem Kundenstamm und
     F*  schlüsselt diese ggf. noch über WAO9 um.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KDDB          E DS                  INZ
     D KYKDDB        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D WAO9          E DS                  INZ
     D KYWAO9        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
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
     C                   EXSR      UEBDTA
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C     WKTRPAFIRM    IfEq      'WERK'
     C                   Exsr      EKDDB
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      ERKOST
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKPROG
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKBIBL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDDBFIRM                     KDDB
     C                   MOVEL(P)  DAFIRM        KYWAO9FIRM                     WAO9
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       WKDBKD
     C                   MOVEA     KOM(11)       WKKONT
     C                   MOVEA     KOM(21)       WKPRGR
     C                   MOVEA     KOM(25)       WKAFAT
     C                   MOVEA     KOM(28)       WKWKNR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   EVAL      RTTRNDFENR  = *ZERO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'FIRM'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN Kundennummer aus Debitor                                ***
     C**************************************************************************
     C     EKDDB         BEGSR
     C                   MOVEL(P)  WKDBKD        KYKDDBDBNR
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHKDDB
     C     WKFENR        DoWEq     '0000'
     C     KDDBFIRM      AndEq     KYKDDBFIRM
     C     KDDBDBNR      AndEq     KYKDDBDBNR
     C     KDDBWKNR      IfEq      WKWKNR
     C                   EVAL      SVWKDBKD = WKDBKD
     C                   EVAL      WKDBKD = KDDBKDNR
     C                   LEAVE
     C                   ENDIF
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHKDDB
     C                   EndDo
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER KOSTENSTELLE                                        ***
     C**************************************************************************
     C     ERKOST        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYKDEWKDNR  = WKDBKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDFENR  = WKFENR
     C*
     C                   IF        RTTRNDFENR <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = KDEWKSST
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = WKPRGR
     C                   EVAL      KYWAO9KONT  = WKKONT
     C                   EVAL      KYWAO9KSST  = KDEWKSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9AFAT  = WKAFAT
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKONT
     C                   EVAL      KYWAO9KSST  = KDEWKSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKONT
     C                   EVAL      KYWAO9KSST  = KDEWKSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = WAO9ERKS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKTRPAFIRM      + 3
     C     *LIKE         DEFINE    WKC001        WKWKNR          + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKDBKD          + 9            DEBITOR
     C     *LIKE         DEFINE    WKC001        SVWKDBKD        + 9            DEBITOR
     C     *LIKE         DEFINE    WKC001        WKKONT          + 9            SACHKONTO
     C     *LIKE         DEFINE    WKC001        WKAFAT          + 2            AUFTRAGSART
     C     *LIKE         DEFINE    WKC001        WKPRGR          + 3            PRODUKTGRUPPE
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAPROG        WKPROG
     C     *LIKE         DEFINE    DABIBL        WKBIBL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKDDB
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHWAO9
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
