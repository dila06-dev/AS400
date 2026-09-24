     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Update Feld "Ertrag" in TVAE
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 23.02.2011
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm liest in TVAE die Sätze mit Änderungskennzeichen '900'
     F*  und macht einen Update auf das Feld "Ertrag" mit dem aktuellen Wert aus
     F*  dem Feld "Standardpreis" (* Menge) aus TEIL.
     F*  In einem weiteren Schritt wird der Umsatz in Fremdwährung mit dem ge-
     F*  änderten Kurs aus WAEH in Stammwährung umgerechnet.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TVAE          E DS                  INZ
     D KYTVAE        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXWAUM        E DS                  INZ
     D RTWAUM        E DS                  INZ
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
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VTVAE
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
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYSWFI                         TVAE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
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
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEPDEK        WKPDEK
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    SWERTR        WKERTR
     C     *LIKE         DEFINE    SWKURS        WKKURS
     C     *LIKE         DEFINE    SWUMDV        WKUMDS
     C     *LIKE         DEFINE    SWUMSV        WKUMSS
     C     *LIKE         DEFINE    SWUMEV        WKUMES
     C     *LIKE         DEFINE    SWUMWV        WKUMWS
     C     *LIKE         DEFINE    SWABDV        WKABDS
     C     *LIKE         DEFINE    SWABSV        WKABSS
     C     *LIKE         DEFINE    SWABEV        WKABES
     C     *LIKE         DEFINE    SWABWV        WKABWS
     C     *LIKE         DEFINE    SWAEDV        WKAEDS
     C     *LIKE         DEFINE    SWAESV        WKAESS
     C     *LIKE         DEFINE    SWAEEV        WKAEES
     C     *LIKE         DEFINE    SWAEWV        WKAEWS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN TVAE                                                  ***
     C**************************************************************************
     C     VTVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYSWAE      = '900'
     C                   EVAL      KYSWRD      = 20120401
     C                   EVAL      KYSWDA      = *ZERO
     C                   EVAL      KYSWTI      = *ZERO
     C                   EVAL      KYSWNU      = *ZERO
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHTVAE
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             SWFIRM      = KYSWFI        AND
     C                             SWAEKZ      = KYSWAE        AND
     C                             SWREDA      < 20120430
     C                   MOVEL(P)  SWTENR        KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   EXSR      VERTR
     C                   EXSR      VWAUM
     C                   EXSR      UTVAE
     C*--------------------------------------------------------
     C                   MOVEA     '05R     '    CHI
     C                   EXSR      CHTVAE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE TVAE                                                       ***
     C**************************************************************************
     C     UTVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYSWDA      = SWDATE
     C                   EVAL      KYSWTI      = SWTIME
     C                   EVAL      KYSWNU      = SWNUMM
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTVAE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKERTR        SWERTR
     C                   Z-ADD     WKAEWS        SWAEWS
     C                   Z-ADD     WKAEES        SWAEES
     C                   Z-ADD     WKAESS        SWAESS
     C                   Z-ADD     WKAEDS        SWAEDS
     C                   Z-ADD     WKABWS        SWABWS
     C                   Z-ADD     WKABES        SWABES
     C                   Z-ADD     WKABSS        SWABSS
     C                   Z-ADD     WKABDS        SWABDS
     C                   Z-ADD     WKUMWS        SWUMWS
     C                   Z-ADD     WKUMES        SWUMES
     C                   Z-ADD     WKUMSS        SWUMSS
     C                   Z-ADD     WKUMDS        SWUMDS
     C                   Z-ADD     WKKURS        SWKURS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHTVAE
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHTVAE
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BERECHNEN ERTRAG                                                  ***
     C**************************************************************************
     C     VERTR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*                                                                         BESTELLTE MENGE
     C     SWUMMS        ADD       SWUMNS        WKN112                         + NATURALRABATT
     C*-------------------------------------------------------------------------
     C     TEPDEK        IFNE      WKPDEK
     C                   MOVEL(P)  'PDIM'        KYTPTA                         VERKAUF-
     C                   MOVEL(P)  TEPDEK        KYTPTC                         PREISDIMENSION
     C                   MOVEA     '01C     '    CHI                            AUS TEILESTAMM
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TEPDEK        WKPDEK
     C                   ENDIF
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*
     C     TESTPR        MULT      WKN112        WKERTR                         BERECHNEN
     C     WKERTR        DIV       TPTNUM        WKERTR                         ROHERTRAG
     C*-------------------------------------------------------------------------
     C                   EXSR      VRUND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RUNDUNGSROUTINE                                                   ***
     C**************************************************************************
     C     VRUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        WKERTR      = *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        KOM
     C                   MOVEA     SWWAVK        KOM(1)
     C                   Z-ADD     WKERTR        DUN152
     C                   MOVEA     DUC015        KOM(4)
     C                   MOVEA     KOM           #CKOMM
     C                   EXSR      TRRUND
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(4)        DUC015
     C                   Z-ADD     DUN152        WKERTR
     C                   ELSE
     C                   Z-ADD     *ZERO         WKERTR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  WÄHRUNGSUMRECHNUNG                                                ***
     C**************************************************************************
     C     VWAUM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SWAEWV        WKAEWS
     C                   Z-ADD     SWAEEV        WKAEES
     C                   Z-ADD     SWAESV        WKAESS
     C                   Z-ADD     SWAEDV        WKAEDS
     C                   Z-ADD     SWABWV        WKABWS
     C                   Z-ADD     SWABEV        WKABES
     C                   Z-ADD     SWABSV        WKABSS
     C                   Z-ADD     SWABDV        WKABDS
     C                   Z-ADD     SWUMWV        WKUMWS
     C                   Z-ADD     SWUMEV        WKUMES
     C                   Z-ADD     SWUMSV        WKUMSS
     C                   Z-ADD     SWUMDV        WKUMDS
     C                   Z-ADD     SWKURS        WKKURS
     C*
     C                   IF        SWWAST      = SWWAVK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAESV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAESS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABSV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      SWABSS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMSV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMSS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     1             WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMKRS1      WKKURS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTVAE
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,TRRUND
     C/COPY QCPYSRC,TRWAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
