     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Beispiel Aufruf TRAFKO für Update Druckkennzeichen
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 31.10.2011 WAECO Projekt 7761
     H*  -----------------------------------------------------------------------
     H*  Änderung:
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient als Beispiel für den Aufruf von TRAFKO zum
     F*  Update des Druckkennzeichens.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXAFKO        E DS                  INZ
     D RTAFKO        E DS                  INZ
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
     C                   PARM                    WKFIRM
     C                   PARM                    WKAFJJ
     C                   PARM                    WKAFNR
     C*
     C                   EXSR      UEBDTA
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      TRAFKO
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
     C                   EVAL      KYAKFI      = DAFIRM                         AFKO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      DUC004      = WKAFJJ
     C                   TESTN                   DUC004               97
     C*
     C                   IF        *IN97       = *OFF
     C                   EVAL      DUN040      = *YEAR
     C                   ENDIF
     C*
     C                   EVAL      WKAFKOAFJJ  = DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      WKAFKOAFNR  = WKAFNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETEREINSTELLUNGEN                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFIRM          + 1            FIRMA
     C     *LIKE         DEFINE    WKC001        WKAFJJ          + 3            AUFTRAGJAHR
     C     *LIKE         DEFINE    WKC001        WKAFNR          + 5            AUFTRAGNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKAFJJ        WKAFKOAFJJ                     AUFTRAGJAHR
     C     *LIKE         DEFINE    AKAFNR        WKAFKOAFNR                     AUFTRAGNUMMER
     C     *LIKE         DEFINE    AKWKNR        WKAFKOWKNR                     WERK
     C     *LIKE         DEFINE    AKAFAT        WKAFKOAFAT                     AUFTRAGSART
     C     *LIKE         DEFINE    AKKDNR        WKAFKOKDNR                     KUNDE
     C     *LIKE         DEFINE    AKVSNR        WKAFKOVSNR                     VERSANDADRESSNR.
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF TRAFKO                                                     ***
     C**************************************************************************
     C     TRAFKO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAKJH      = WKAFKOAFJJ
     C                   EVAL      KYAKAF      = WKAFKOAFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFKO
     C                   EVAL      EXAFKOPGST  = 'UPAFKO'
     C                   EVAL      EXAFKOAFJJ  = AKAFJJ
     C                   EVAL      EXAFKOAFNR  = AKAFNR
     C                   EVAL      EXAFKOAFAT  = AKAFAT
     C                   EVAL      EXAFKOWKNR  = AKWKNR
     C                   EVAL      EXAFKOKDNR  = AKKDNR
     C                   EVAL      EXAFKOVSNR  = AKVSNR
     C                   EVAL      EXAFKOVELS  = 'Y'
     C                   EVAL      EXAFKOIFKZ  = *OFF
     C*
     C                   CALL      'TRAFKO'
     C                   PARM                    EXAFKO
     C                   PARM                    RTAFKO
     C*-------------------------------------------------------------------------
     C                   IF        RTAFKOFENR <> '0000'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,TRDAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
