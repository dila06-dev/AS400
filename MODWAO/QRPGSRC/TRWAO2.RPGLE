     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Übernahme Rechnungen
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 15.10.2003 WAECO Projekt 2502
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 12.05.2005 WAECO Projekt 2984
     H*  Änderung: ZG 22.10.2007 WAECO Projekt 4483
     H*            Status 87 - Pos. in der LBAP bereits vorhanden
     H*  Änderung: ZG 11.08.2010 WAECO Besuch - Update BUDA mit TDAT für BGFS
     H**************************************************************************
     F*
     F*  Dieses Programm liest die SST-Datei WAO1 und übergibt die Sätze     der
     F*  an die Dateien LBAK und LBAP.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D LBAK          E DS                  INZ
     D KYLBAK        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
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
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C*
     C                   IF        %PARMS      < 1
     C                   CLEAR                   EXTR02
     C                   ENDIF
     C**************************************************************************
     C                   EXSR      UEBWAO2
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      VWAO1
     C*-------------------------------------------------------------------------
     C*
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
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '01'          DAFIRM
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYLBAKFIRM
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM
     C                   MOVEL(P)  DAFIRM        KYWAO1FIRM
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXWAO2                                                 ***
     C**************************************************************************
     C     UEBWAO2       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VWAO1                                                             ***
     C**************************************************************************
     C     VWAO1         BEGSR
     C*
     C                   SELECT
     C     #CSUCH        WHENEQ    '05'
     C                   MOVEL     '05'          KYWAO1UEST
     C     #CSUCH        WHENEQ    '15'
     C                   MOVEL     '15'          KYWAO1UEST
     C                   OTHER
     C                   MOVEL     '10'          KYWAO1UEST
     C                   ENDSL
     C                   MOVEL(P)  KYWAO1UEST    KYABFRAGE         2
     C*-------------------------------------------------------------------------
     C                   MOVEL     *LOVAL        KYWAO1LIJJ
     C                   MOVEL     *LOVAL        KYWAO1LINR
     C                   MOVEL     *LOVAL        KYWAO1RALP
     C                   MOVEA     '02+U    '    CHI
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*----------------------------------------------------------
     C     WAO1UEST      IFGT      KYABFRAGE
     C                   MOVEA     '02F     '    CHI
     C                   EXSR      CHWAO1
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      PWAO1
     C*----------------------------------------------------------
     C     WKFENR        IFEQ      *ZEROS
     C*
     C                   MOVE      *OFF          KZPOSVOR          1
     C*
     C                   EXSR      ULBAK
     C*
     C                   MOVEL(P)  '20'          WAO1UEST
     C     KZPOSVOR      IFEQ      *ON
     C                   MOVEL(P)  '87'          WAO1UEST
     C                   ENDIF
     C*
     C     WAO1TSTP      IFEQ      *LOVAL
     C                   CALL      'EXTSTP'
     C                   PARM                    WAO1TSTP
     C                   ENDIF
     C*
     C                   ENDIF
     C*----------------------------------------------------------
     C     WAO1JNAM      IFEQ      *BLANKS
     C                   MOVEL(P)  DAJNAM        WAO1JNAM
     C                   ENDIF
     C     WAO1PROG      IFEQ      *BLANKS
     C                   MOVEL(P)  WKCHPN        WAO1PROG
     C                   ENDIF
     C     WAO1BIBL      IFEQ      *BLANKS
     C                   MOVEL(P)  WKCHPL        WAO1BIBL
     C                   ENDIF
     C     WAO1USER      IFEQ      *BLANKS
     C                   MOVEL(P)  DAUSER        WAO1USER
     C                   ENDIF
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C     WAO1JZEI      IFEQ      *ZEROS
     C                   MOVEL     DUN120        WAO1JZEI
     C                   ENDIF
     C     WAO1JDAT      IFEQ      *ZEROS
     C                   MOVE      WKTDAT        WAO1JDAT
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     '02U     '    CHI
     C                   EXSR      CHWAO1
     C*
     C                   MOVEA     '02RU    '    CHI
     C                   EXSR      CHWAO1
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WAO1                                                       ***
     C**************************************************************************
     C     PWAO1         BEGSR
     C*
     C                   MOVEL(P)  WAO1TENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZEROS
     C                   MOVEL(P)  '30'          WAO1UEST
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBAK                                                 ***
     C**************************************************************************
     C     ULBAK         BEGSR
     C*
     C                   MOVEL(P)  'BGFS'        KYLBAKDANA
     C                   Z-ADD     WAO1LIJJ      KYLBAKJAHR
     C                   MOVEL(P)  WAO1LINR      KYLBAKNMKR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAK
     C                   MOVEA     '01U     '    CHI
     C     WKFENR        IFNE      *ZEROS
     C                   MOVEL(P)  '00'          LBAKSTAT
     C*
     C     KYABFRAGE     IFEQ      '05'
     C                   MOVEL(P)  '05'          LBAKSTAT
     C                   ENDIF
     C*
     C                   EVALR     DUC006 = %TRIMR(LBAKNMKR)
     C     ' ':'0'       XLATE     DUC006        DUC006
     C                   Z-ADD     DUN060        LBAKNMKN
     C*
     C                   MOVEL(P)  DAJNAM        LBAKJNAM
     C                   MOVEL(P)  WKCHPN        LBAKPROG
     C                   MOVEL(P)  WKCHPL        LBAKBIBL
     C                   MOVEL(P)  DAUSER        LBAKUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAKJZEI
     C                   MOVE      WKTDAT        LBAKJDAT
     C*
     C                   MOVEA     '01W     '    CHI
     C                   ELSE
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO1VSBD      LBAKVSBD
     C*
     C                   MOVE      WKTDAT        LBAKBUDA
     C*
     C                   MOVEL(P)  WAO1FREI      DUC005
     C                   MOVEL     DUC005        LBAKKDNR
     C*-------------------------------------------------------------------------
     C                   EXSR      CHLBAK
     C*-------------------------------------------------------------------------
     C                   EXSR      ULBAP
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBAP                                                 ***
     C**************************************************************************
     C     ULBAP         BEGSR
     C*
     C                   MOVEL(P)  'BGFS'        KYLBAPDANA
     C                   Z-ADD     WAO1LIJJ      KYLBAPJAHR
     C                   MOVEL(P)  WAO1LINR      KYLBAPNMKR
     C                   Z-ADD     WAO1RALP      KYLBAPPOSI
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBAP
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVE      *ON           KZPOSVOR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO1TENR      LBAPTENR
     C                   MOVEL(P)  '00'          LBAPSTAT
     C     KYABFRAGE     IFEQ      '05'
     C                   MOVEL(P)  '05'          LBAPSTAT
     C                   ENDIF
     C*
     C                   Z-ADD     WAO1LIJJ      LBAPAFJJ
     C                   MOVEL(P)  WAO1LINR      LBAPAFNR
     C                   Z-ADD     WAO1RALP      LBAPAFPO
     C                   Z-ADD     WAO1AFMG      LBAPBWMG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        LBAPJNAM
     C                   MOVEL(P)  WKCHPN        LBAPPROG
     C                   MOVEL(P)  WKCHPL        LBAPBIBL
     C                   MOVEL(P)  DAUSER        LBAPUSER
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAPJZEI
     C                   MOVE      WKTDAT        LBAPJDAT
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHLBAP
     C*
     C*-------------------------------------------------------------------------
     C     LBAKSTAT      IFEQ      '90'
     C     LBAKSTAT      ORLT      '90'                                         NEU
     C                   MOVEL(P)  'BGFS'        KYLBAKDANA
     C                   Z-ADD     WAO1LIJJ      KYLBAKJAHR
     C                   MOVEL(P)  WAO1LINR      KYLBAKNMKR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBAK
     C                   MOVEL(P)  '10'          LBAKSTAT
     C                   MOVEL(P)  '00'          LBAKSTAT
     C     KYABFRAGE     IFEQ      '05'
     C                   MOVEL(P)  '05'          LBAKSTAT
     C                   ENDIF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBAK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODXXX
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHLBAK
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
