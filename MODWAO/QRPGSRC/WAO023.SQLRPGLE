     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Übernahme Monatsabschluss
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 03.02.2011 Projekt 7104
     H*  -----------------------------------------------------------------------
/*  ÄH*  Änderung: SZ 12.11.2013 Absprache mit Herrn Kordel, Mengen der nicht
     H*            bewerteten Lager nicht summieren.
/*  ÄH*  Änderung: SZ 12.11.2013 Nach erneuter Absprache mit Herrn Kordel ist
     H*            noch eine Prüfung auf LBPR zu integrieren.
     H*            VORBEREITET, ABER NOCH NICHT AKTIV!
/*  ÄH*  Änderung: SZ 01.12.2013 Prüfung auf LBPR aktiviert.
     H*
     H**************************************************************************
     F*
     F*  Dieses Programm dient zur Übernahme der Lagerbestandswerte aus der Datei LBSU.
     F*  Die Vorauswahl wurde mit dem Programm WAO022 getroffen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FPRJTRENDLGUF A E             DISK
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRBR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D LBPR          E DS                  INZ
     D KYLBPR        E DS                  INZ
     D*
     D LBSU          E DS                  INZ
     D KYLBSU        E DS                  INZ
     D WKLBSU        E DS                  EXTNAME(LBSU) PREFIX(WK)
     D*
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D WKTEEW        E DS                  EXTNAME(TEEW) PREFIX(WK)
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D WKTEIL        E DS                  EXTNAME(TEIL) PREFIX(WK)
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D                 DS                  INZ
     D  WKDATE                        8  0
     D   WKJHJJ                       4  0 OVERLAY(WKDATE:1)
     D   WKMONA                       2  0 OVERLAY(WKDATE:5)
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      LPRJTRENDLG
     C*-------------------------------------------------------------------------
     C                   EXSR      OLBSU
     C                   EXSR      VLBSU
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLRFI                         LBPR
     C                   MOVEL(P)  DAFIRM        KYLUFI                         LBSU
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM                     TEEW
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*
     C                   MOVEA     KOM(01)       DUC008
     C                   TESTN                   DUC008               97        PRÜFUNG
     C     *IN97         IFEQ      *OFF                                         AUF
     C                   MOVE      *ZERO         DUC008                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN080        WKDATE
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   WKLBSU
     C                   CLEAR                   WKTEEW
     C                   CLEAR                   WKTEIL
     C                   EVAL      WKILPR = *OFF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI PRODWIN51/PRJTRENDLG                          ***
     C**************************************************************************
     C     LPRJTRENDLG   BEGSR
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DELETE FROM PRODWIN51/PRJTRENDLG WHERE LAGDAT = :WKDATE
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR LBSUC1                                             ***
     C**************************************************************************
     C     OLBSU         BEGSR
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBSUC1 CURSOR FOR SELECT * FROM LBSU, TEEW
     C+ WHERE LBSU.LUFIRM = :DAFIRM
     C+ AND   LBSU.LUJHJJ = :WKJHJJ
     C+ AND   LBSU.LUMONA = :WKMONA
     C+ AND   LBSU.LUFIRM = TEEW.TEEWFIRM
     C+ AND   LBSU.LUTENR = TEEW.TEEWTENR
     C+ ORDER BY LBSU.LUFIRM, LBSU.LUJHJJ, LBSU.LUMONA, TEEW.TEEWSKUN,
     C+       LBSU.LUTENR, LBSU.LUEZNR, LBSU.LULANR
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBSUC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN LBSU                                                  ***
     C**************************************************************************
     C     VLBSU         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD = *ZERO
     C/EXEC SQL
     C+ FETCH NEXT FROM LBSUC1 INTO :LBSU, :TEEW
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      ETEIL
     C                   EXSR      PLBPR
     C*----------------------------------------------------------
     C                   SELECT
     C                   WHEN      TEEWSKUN <> WKTEEWSKUN AND
     C                             WKTEEWSKUN <> *BLANK AND
     C                             WKILPR = *OFF
     C                   EXSR      AUSGABE
     C                   MOVEL     LBSU          WKLBSU
     C                   Z-ADD     *ZERO         WKLULAWT
     C                   Z-ADD     *ZERO         WKLUENDB
     C                   WHEN      WKILPR = *OFF                                KEIN BEWERTUNGSPREIS
     C*                  NICHTS MACHEN
     C                   WHEN      TEEWSKUN <> WKTEEWSKUN AND
     C                             WKTEEWSKUN <> *BLANK
     C                   EXSR      AUSGABE
     C                   MOVEL     LBSU          WKLBSU
     C                   WHEN      TEEWSKUN <> WKTEEWSKUN
     C                   MOVEL     LBSU          WKLBSU
     C                   OTHER
     C                   MOVEL(P)  LULANR        WKLULANR
     C                   Z-ADD     LUBWPR        WKLUBWPR
     C                   ADD       LULAWT        WKLULAWT
     C                   ADD       LUENDB        WKLUENDB
     C                   ENDSL
     C*----------------------------------------------------------
     C                   MOVEL     TEEW          WKTEEW
     C                   MOVEL     TEIL          WKTEIL
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKTEEWSKUN    CASNE     *BLANK        AUSGABE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI PRODWIN51/PRJTRENDLG                                 ***
     C**************************************************************************
     C     AUSGABE       BEGSR
     C*-------------------------------------------------------------------------
     C* Prüfung auf numerischen Inhalt
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTEEWSKUN    DUC010
     C*
     C                   TESTN                   DUC010               97
     C     *IN97         IFNE      *ON
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Wert pro Einheit
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  WKLUPDIM      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     TPTNUM        WHENNE    *ZERO
     C     WKLUBWPR      DIV       TPTNUM        WKLUBWPR
     C     WKLUBWPR      MULT      WKLUENDB      WKLULAWT
     C*--------------------------------------------------------
     C     WKLUENDB      WHENNE    *ZERO
     C     WKLULAWT      DIV       WKLUENDB      WKLUBWPR
     C*--------------------------------------------------------
     C                   OTHER
     C                   Z-ADD     *ZERO         WKLUBWPR
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      EMEIN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PRJTRDF
     C                   Z-ADD     WKDATE        LAGDAT
     C                   Z-ADD     DUN100        ARTNUM
     C                   Z-ADD     WKLUENDB      MNG
     C                   MOVEL     SFMEIN        ENH
     C                   Z-ADD     WKLULAWT      LAGWRT
     C                   Z-ADD     WKLUBWPR      WRT
     C                   MOVEL     SFMEIN        PRSENH
     C*
     C                   WRITE     PRJTRDF                              98
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS IDENT-STAMM                                   ***
     C**************************************************************************
     C     ETEIL         BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        TEEWTENR = WKTEEWTENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEEWTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN MENGENEINHEIT                                           ***
     C**************************************************************************
     C     EMEIN         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  WKTEMEIN      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SFMEIN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BEWERTUNGSPREIS                                            ***
     C**************************************************************************
     C     PLBPR         BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        LULANR = WKLULANR AND
     C                             TETART = WKTETART
     C**                 LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKILPR = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYLRLA = LULANR
     C                   EVAL      KYLRTA = TETART
     C                   EVAL      KYLRBF = *BLANK
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBPR
     C*--------------------------------------------------------
     C                   IF        WKFENR = '0000' AND
     C                             LRFIRM = KYLRFI AND
     C                             LRLANR = KYLRLA AND
     C                             LRTART = KYLRTA
     C                   EVAL      WKILPR = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
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
     C     *LIKE         DEFINE    WKC001        WKILPR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        SFMEIN          +39
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLBPR
     C/COPY QCPYSRC,CHLBSU
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
