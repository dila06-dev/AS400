     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Kundenspezifische Updates aus AFSP
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 23.05.2012 Projekt 8354 Kühne + Nagel
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 04.07.2012 Projekt 8390 Update auch für SPEDG0 (Schenker)
     H*  Änderung: SZ 14.03.2013 Projekt 8997 Update auch für SPEDI0 (TNT)
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus TRAFSP aufgerufen, wenn die Positionen der
     F*  Bordero Liste hinzugefügt werden. Es wird gleichzeitig ein Update des
     F*  Status in SPEDF0 gemacht, um die Daten zu markieren, die an Kühne +
     F*  Nagel versandt werden sollen.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXSPF0        E DS                  INZ
     D RTSPF0        E DS                  INZ
     D*
     D EXSPG0        E DS                  INZ
     D RTSPG0        E DS                  INZ
     D*
     D EXSPH0        E DS                  INZ
     D RTSPH0        E DS                  INZ
     D*
     D EXSPI0        E DS                  INZ
     D RTSPI0        E DS                  INZ
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
     C                   EXSR      ANFANG
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      TRSPF0
     C                   EXSR      TRSPG0
     C                   EXSR      TRSPH0
     C                   EXSR      TRSPI0
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
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   EVAL      RTTRNDFENR  = *ZERO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF UPDATEPROGRAMM                                             ***
     C**************************************************************************
     C     TRSPF0        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(EXTRNDKEYB:16:5) <> '92222'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSPF0
     C                   EVAL      EXSPF0PGST  = 'UPSTAT'
     C                   EVAL      EXSPF0N020  = %SUBST(EXTRNDKEYB:1:15)
     C*
     C                   CALL      'TRSPF0'
     C                   PARM                    EXSPF0
     C                   PARM                    RTSPF0
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF UPDATEPROGRAMM                                             ***
     C**************************************************************************
     C     TRSPG0        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(EXTRNDKEYB:16:5) <> '92224'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSPG0
     C                   EVAL      EXSPG0PGST  = 'UPSTAT'
     C                   EVAL      EXSPG02020  = %SUBST(EXTRNDKEYB:1:15)
     C*
     C                   CALL      'TRSPG0'
     C                   PARM                    EXSPG0
     C                   PARM                    RTSPG0
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF UPDATEPROGRAMM BRT ITALIEN                                 ***
     C**************************************************************************
     C     TRSPH0        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(EXTRNDKEYB:16:5) <> '92225'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSPH0
     C                   EVAL      EXSPH0PGST  = 'UPSTAT'
     C                   EVAL      EXSPH0B020  = %SUBST(EXTRNDKEYB:1:15)
     C*
     C                   CALL      'TRSPH0'
     C                   PARM                    EXSPH0
     C                   PARM                    RTSPH0
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF UPDATEPROGRAMM TNT INNIGHT                                 ***
     C**************************************************************************
     C     TRSPI0        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(EXTRNDKEYB:16:5) <> '90169'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSPI0
     C                   EVAL      EXSPI0PGST  = 'UPSTAT'
     C                   EVAL      EXSPI0T020  = %SUBST(EXTRNDKEYB:1:15)
     C*
     C                   CALL      'TRSPI0'
     C                   PARM                    EXSPI0
     C                   PARM                    RTSPI0
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
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPYMODULE                                                        ***
     C**************************************************************************
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
