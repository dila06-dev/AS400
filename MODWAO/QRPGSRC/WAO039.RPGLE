     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Beispiel Aufruf TRKDAZ für Update Zuordnung Auftrag-Ansprechpartn.
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
     F*  Dieses Programm dient als Beispiel für den Aufruf von TRKDAZ zum
     F*  Update bzw. Neuanlage der Zuordnung des Kundenansprechpartners zum
     F*  Kundenauftrag.
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
     C                   PARM                    WKVSNR
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
     C                   EXSR      TRKDAZ
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
     C                   EVAL      WKAFKOVSNR  = WKVSNR
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
     C     *LIKE         DEFINE    WKC001        WKVSNR          + 2            ANSPRECHPARTNERNR.
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
     C***  AUFRUF TRKDAZ                                                     ***
     C**************************************************************************
     C     TRKDAZ        BEGSR
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
     C                   CLEAR                   EXTR02
     C                   EVAL      #CPGST      = 'NEUANL'
     C                   MOVEA     *BLANK        KOM
     C                   MOVEA     'AFKO      '  KOM(01)                        DANA
     C                   Z-ADD     AKAFJJ        DUN040                         AUFTRAGJAHR
     C                   MOVEA     DUC004        KOM(11)
     C                   MOVEA     AKAFNR        KOM(15)                        AUFTRAGNUMMER
     C                   Z-ADD     *ZERO         DUN040
     C                   MOVEA     DUC004        KOM(21)                        AUFTRAGPOSITION
     C                   MOVEA     'EK        '  KOM(25)                        ANSPRECHPARTNERART
     C                   MOVEA     AKKDNR        KOM(35)                        KUNDENNUMMER
     C                   MOVEA     WKAFKOVSNR    KOM(45)                        ANSPRECHPARTNERNR.
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'TRKDAZ'
     C                   PARM                    EXTR02
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
