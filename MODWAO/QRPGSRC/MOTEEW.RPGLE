     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2012')
     H**************************************************************************
     H/TITLE Prüfungen/Ermittlungen auf Basis der Ident-Stamm-Erweiterungsdatei TEEW
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 26.11.2012 DOMETIC Projekt 9022
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 05.02.2026 DOMETIC Case 05947565. Rückgabe TEEWPCGR "Product Group"
     H*            an das aufrufende Programm
     F**************************************************************************
     F*
     F*  Über dieses Programm werden kundenspezifische Prüfungen und Ermittlungen
     F*  auf Basis der Ident-Stamm-Erweiterungsdatei TEEW durchgführt
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
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
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
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERTEEW'
     C                   EXSR      ERTEEW
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   RETURN
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
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM                     TEEW
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       DSTEEWTENR
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
     C***  ERMITELLN TEEW                                                    ***
     C**************************************************************************
     C     ERTEEW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C                   EVAL      %SUBST(RTTRNDDATE:01:02) = TEEWVKG1
     C                   EVAL      %SUBST(RTTRNDDATE:03:04) = TEEWVKG2
     C                   EVAL      %SUBST(RTTRNDDATE:05:06) = TEEWVKG3
     C                   EVAL      %SUBST(RTTRNDDATE:07:08) = TEEWVKG4
     C                   EVAL      %SUBST(RTTRNDDATE:09:10) = TEEWVKG5
     C                   EVAL      %SUBST(RTTRNDDATE:11:14) = TEEWPRGR
     C                   EVAL      %SUBST(RTTRNDDATE:15:04) = TEEWPCGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKPROG
     C     *LIKE         DEFINE    DSJZEI        WKBIBL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEEWTENR      DSTEEWTENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTRPA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
