     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2012')
     H**************************************************************************
     H/TITLE  Aufruf TRAFPO für Update Fixtermin
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 01.12.2012 WAECO Projekt 7958
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 02.05.2013 Aktivierung Aufruf TRAFPO
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm dient zum Update aller AFPO-Sätze zu einem Auftrag mit
     F*  dem Kennzeichen "Fixtermin" (APLFDR).
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
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXAFPO        E DS                  INZ
     D RTAFPO        E DS                  INZ
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
     C                   PARM                    WKLFTE
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
     C                   IF        WKAFPOLFTE <> *ZERO
     C                   EXSR      VAFKO
     C*--------------------------------------------------------
     C                   IF        WKFENR      = '0000'
     C                   EXSR      VAFPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAKFI      = DAFIRM                         AFKO
     C                   EVAL      KYAPFI      = DAFIRM                         AFPO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
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
     C                   EVAL      DUC008      = WKLFTE
     C                   TESTN                   DUC008               97
     C*
     C                   IF        *IN97       = *OFF
     C                   EVAL      DUN080      = *ZERO
     C                   ENDIF
     C*
     C                   EVAL      WKAFPOLFTE  = DUN080
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETEREINSTELLUNGEN                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
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
     C     *LIKE         DEFINE    WKC001        WKLFTE          + 7            LIEFERTERMIN
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKAFJJ        WKAFKOAFJJ                     AUFTRAGJAHR
     C     *LIKE         DEFINE    AKAFNR        WKAFKOAFNR                     AUFTRAGNUMMER
     C     *LIKE         DEFINE    AKWKNR        WKAFKOWKNR                     WERK
     C     *LIKE         DEFINE    AKAFAT        WKAFKOAFAT                     AUFTRAGSART
     C     *LIKE         DEFINE    AKKDNR        WKAFKOKDNR                     KUNDE
     C     *LIKE         DEFINE    AKVSNR        WKAFKOVSNR                     VERSANDADRESSNR.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    APLFTE        WKAFPOLFTE                     LIEFERTERMIN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AFKO                                                       ***
     C**************************************************************************
     C     VAFKO         BEGSR
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
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN AFPO                                                  ***
     C**************************************************************************
     C     VAFPO         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAPJH      = WKAFKOAFJJ
     C                   EVAL      KYAPAF      = WKAFKOAFNR
     C                   EVAL      KYAPPO      = *ZERO
     C                   MOVEA     '00L     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR     <> *ZERO
     C                   MOVEA     '00R     '    CHI
     C                   EXSR      CHAFPO
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO         OR
     C                             APFIRM     <> KYAPFI        OR
     C                             APAFJJ     <> KYAPJH        OR
     C                             APAFNR     <> KYAPAF
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      TRAFPO
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF TRAFPO                                                     ***
     C**************************************************************************
     C     TRAFPO        BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFPO
     C                   EVAL      EXAFPOPGST  = 'UPAFPO'
     C**                 EVAL      EXAFPOFIRM  = AKFIRM
     C                   EVAL      EXAFPOAFJJ  = AKAFJJ
     C                   EVAL      EXAFPOAFNR  = AKAFNR
     C                   EVAL      EXAFPOAFPO  = APAFPO
     C                   EVAL      EXAFPOAFAT  = AKAFAT
     C                   EVAL      EXAFPOWKNR  = AKWKNR
     C                   EVAL      EXAFPOKDNR  = AKKDNR
     C                   EVAL      EXAFPOVSNR  = AKVSNR
     C                   EVAL      EXAFPOLFTE  = WKAFPOLFTE
     C                   EVAL      EXAFPOLFDR  = '1'
     C                   EVAL      EXAFPOZZKZ  = *OFF
     C                   CALL      'TRAFPO'
     C                   PARM                    EXAFPO
     C                   PARM                    RTAFPO
     C*-------------------------------------------------------------------------
     C                   IF        RTAFPOFENR <> '0000'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,TRDAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
