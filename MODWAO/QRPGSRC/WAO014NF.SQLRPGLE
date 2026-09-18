     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Prüfen Identstamm Status 80
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 01.12.2010
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 17.01.2011 Projekt 7037. Prüfen/Setzen Status für Ausalaufartikel
     H*            II. Wahl
     H*  Änderung: RE 11.11.2013 Projekt 9939
     H*            Prüfen/Setzen Status für Artikel mit Status 79
     H*  Änderung: MG 13.10.2015 WAECO Service 20151009-013
     H*            Update Datei TEIL Mandant Österreich (TRTEIL)
     H*  Änderung: SZ 02.12.2018 Aufgrund von übermäßig vielen Aufrufen des
     H*            Triggers auf TEIL den Job überprüft und festgestellt, dass
     H*            auch bereits auf Status '90' gesetzte Artikel immer wieder
     H*            geändert werden.
     H*            Und wenn WKTEST auf Basis der Abfragen geändert wird, der
     H*            Update auf TEIL dann aber mit dem Inhalt von TETEST erfolgt,
     H*            wird sich an dem Status nie etwas ändern.
     H*            (UTEIL wurde durch TRTEIL ersetzt)
     H*  Änderung: MG 25.09.2020 DOMETIC Service 20200924-025 Der Ident-Status
     H*            wird aufgrund fehlende Berechtigung für den Benutzer TRDSCD nicht aktualisiert.
     H*            => Übergabe Abteilung "QS " für die Prüfung der Berechtigung.
     H*  Änderung: GS 18.05.2021 Projekt 16597 Prüfung Identstatus um weitere Lagerbereiche:
     H*            602,603,604,605
     H*************************************************************************
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
     D EXTR02        E DS                  INZ
     D*
     D EXTEIL        E DS                  INZ
     D RTTEIL        E DS                  INZ
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
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OTEIL
     C                   EXSR      VTEIL
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
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*-------------------------------------------------------------------------
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
     C***  ÖFFENEN CURSOR TEILC1                                             ***
     C**************************************************************************
     C     OTEIL         BEGSR
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TEILC1 CURSOR FOR SELECT * FROM TEIL
     C+ WHERE TEFIRM = :DAFIRM AND
     C+ TETEST IN ('79', '80', '81', '90')
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN TEILC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VTEIL                                                             ***
     C**************************************************************************
     C     VTEIL         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C/EXEC SQL
     C+ FETCH NEXT FROM TEILC1 INTO :TEIL
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVE      *OFF          WKLGBE902
     C                   MOVE      *OFF          WKLGBE903
     C                   MOVE      *OFF          WKLGBE602
     C                   MOVE      *OFF          WKLGBE603
     C                   MOVE      *OFF          WKLGBE604
     C                   MOVE      *OFF          WKLGBE605
     C*----------------------------------------------------------
     C                   EVAL      WKTEST = TETEST
     C                   EVAL      WKABC3 = TEABC3
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE902     IFEQ      *ON                                          Bestand 902
     C     WKFENR        ANDNE     *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE602     IFEQ      *ON                                          Bestand 602
     C     WKFENR        ANDNE     *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE603     IFEQ      *ON                                          Bestand 603
     C     WKFENR        ANDNE     *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE604     IFEQ      *ON                                          Bestand 604
     C     WKFENR        ANDNE     *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE605     IFEQ      *ON                                          Bestand 605
     C     WKFENR        ANDNE     *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRTEIL                                       Prüfen TEIL
     C     WKLGBE903     IFEQ      *ON                                          Bestand 903
     C     WKFENR        ANDNE     *ZERO                                        vorhanden
     C                   MOVEL(P)  '81'          WKTEST                         Auslauf
     C                   ELSE
     C                   MOVEL(P)  '90'          WKTEST                         inaktiv
     C                   ENDIF
     C*----------------------------------------------------------
     C                   IF        WKTEST = '90'
     C                   EVAL      WKABC3 = 'X'
     C                   ENDIF
     C*----------------------------------------------------------
     C                   IF        WKTEST <> TETEST OR WKABC3 <> TEABC3
     C                   EXSR      TRTEIL
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRTEIL        Prüfen TEIL                                         ***
     C**************************************************************************
     C     PRTEIL        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *OFF          KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGER-BEREICH= 'P'
     C                   MOVE      *OFF          KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C                   MOVEA     *BLANK        KOM(25)                        LAGER
     C                   MOVEA     *BLANK        KOM(28)                        GEBINDE
     C                   MOVEA     *BLANK        KOM(43)                        CHARGE
     C                   MOVEA     *BLANK        KOM(63)                        LAGER-PLATZ
     C                   SELECT
     C     WKLGBE902     WHENEQ    *OFF
     C                   MOVEA     '902'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE902
     C     WKLGBE602     WHENEQ    *OFF
     C                   MOVEA     '602'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE602
     C     WKLGBE603     WHENEQ    *OFF
     C                   MOVEA     '603'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE603
     C     WKLGBE604     WHENEQ    *OFF
     C                   MOVEA     '604'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE604
     C     WKLGBE605     WHENEQ    *OFF
     C                   MOVEA     '605'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE605
     C     WKLGBE903     WHENEQ    *OFF
     C                   MOVEA     '903'         KOM(99)                        LAGER-BEREICH
     C                   MOVE      *ON           WKLGBE903
     C                   ENDSL
     C                   MOVE      *ON           KOM(105)                       MIT SPERRLAGER
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*
     C                   MOVEA     KOM(01)       DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   MOVEA     KOM(40)       DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   MOVEA     KOM(53)       DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   MOVEA     KOM(66)       DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   MOVEA     KOM(79)       DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   MOVEA     KOM(144)      DUC013
     C     DUN134        IFNE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEIL                                                 ***
     C**************************************************************************
     C     TRTEIL        BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTEIL
     C                   MOVEL(P)  '2     '      EXTEILPGST
     C                   MOVEL(P)  *ON           EXTEILIFKZ
     C                   MOVEL(P)  TETENR        EXTEILTENR
     C                   MOVEL(P)  WKTEST        EXTEILTEST
     C                   MOVEL(P)  WKABC3        EXTEILABC3
     C                   MOVEL(P)  'QS '         EXTEILABTL
     C*
     C                   CALL      'TRTEIL'
     C                   PARM                    EXTEIL
     C                   PARM                    RTTEIL
     C*-------------------------------------------------------------------------
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
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKLGBE902
     C     *LIKE         DEFINE    WKC001        WKLGBE903
     C     *LIKE         DEFINE    WKC001        WKLGBE602
     C     *LIKE         DEFINE    WKC001        WKLGBE603
     C     *LIKE         DEFINE    WKC001        WKLGBE604
     C     *LIKE         DEFINE    WKC001        WKLGBE605
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TETEST        WKTEST
     C     *LIKE         DEFINE    TEABC3        WKABC3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
