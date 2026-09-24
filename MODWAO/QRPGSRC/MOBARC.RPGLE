     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2013')
     H**************************************************************************
     H/TITLE  Barcode (Referenz) ermitteln/auslesen
     H**************************************************************************
     H*  Copyright 2013 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 31.01.2013 WAECO Projekt 9032
     H*  -----------------------------------------------------------------------
     H*  Änderung:
     H*
     F**************************************************************************
     F*
     F*  Die Verarbeitung ist Firmenabhängig!
     F*
     F*  PGST = 'WRITE '
     F*  Barcode aus den Einzelwerten zusammensetzen.
     F*
     F*  PGST = 'READ  '
     F*  Barcode in die Einzelwerte zerlegen.
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
     C                   EXSR      UEBTRND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C                   WHEN      WKPGST      = 'WRITE '
     C                   EXSR      WRBARC
     C                   WHEN      WKPGST      = 'READ  '
     C                   EXSR      RDBARC
     C                   ENDSL
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
     C                   EVAL      WKFIRM      = DAFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÜBERNAHME PARAMETERWERTE                                          ***
     C**************************************************************************
     C     UEBTRND       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKPGST      = EXTRNDPGST
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKDNR      = %SUBST(EXTRNDKEYB:1:10)
     C                   EVAL      WKKMNR      = %SUBST(EXTRNDKEYB:11:6)
     C                   EVAL      WKBARC      = %SUBST(EXTRNDKEYB:17:15)
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   EVAL      RTTRNDFENR  = '0000'
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
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5            PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        WKCOD1          + 1            BARCODE TEIL 1
     C     *LIKE         DEFINE    WKC001        WKCOD2                         BARCODE TEIL 2
     C     *LIKE         DEFINE    WKC001        WKKDNR          + 9            KUNDENNUMMER
     C     *LIKE         DEFINE    WKC001        WKKMNR          + 5            KOM.-NUMMER
     C     *LIKE         DEFINE    WKC001        WKBARC          +14            BARCODE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BARCODE ZUSAMMENSETZEN                                            ***
     C**************************************************************************
     C     WRBARC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKCOD1      = '01'
     C                   EVAL      WKCOD2      = '1'
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKFIRM      = '08'
     C                   EVAL      WKBARC      = '0' + %TRIM(WKKDNR) + WKKMNR
     C                                         + WKCOD2
     C                   WHEN      WKFIRM      = '52'
     C                   EVAL      WKBARC      = '0' + %TRIM(WKKDNR) + WKKMNR
     C                                         + WKCOD2
     C                   OTHER
     C                   EVAL      WKBARC      = '01' + %TRIM(WKKDNR) + WKKMNR
     C                                         + WKCOD2
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = WKKDNR + WKKMNR + WKBARC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BARCODEINHALT AUSLESEN                                            ***
     C**************************************************************************
     C     RDBARC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKFIRM      = '08'
     C                   EVAL      WKKDNR      = %SUBST(WKBARC:2:7)
     C                   EVAL      WKKMNR      = %SUBST(WKBARC:9:6)
     C                   EVAL      WKCOD2      = %SUBST(WKBARC:15:1)
     C                   WHEN      WKFIRM      = '52'
     C                   EVAL      WKKDNR      = %SUBST(WKBARC:2:7)
     C                   EVAL      WKKMNR      = %SUBST(WKBARC:9:6)
     C                   EVAL      WKCOD2      = %SUBST(WKBARC:15:1)
     C                   OTHER
     C                   EVAL      WKKDNR      = %SUBST(WKBARC:3:6)
     C                   EVAL      WKKMNR      = %SUBST(WKBARC:9:6)
     C                   EVAL      WKCOD2      = %SUBST(WKBARC:15:1)
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = WKKDNR + WKKMNR + WKBARC
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
