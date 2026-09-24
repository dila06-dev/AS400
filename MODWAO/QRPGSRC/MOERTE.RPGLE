     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen für
     H/TITLE  die Ersatz-Ident-Nr
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 08./09.12.2010 Projekt 6997 für Kunde DOMETIC (WAECO)
     H*  -----------------------------------------------------------------------
     H*  Änderung: RE 06.01.2011 Projekt 7037
     H*  Änderung: PH 18.01.2010 Projekt 7037. Differenzierung der zugelassenen Ersatzartikel
     H*            bei deren Ermittlung abhängig der an das Programm übergebenen KD-Af-Art (ob
     H*            diese in der Tabelle $$WAOERTE enthalten ist ("Garantie"-Auftrag) oder nicht
     H*            (kein "Garantie"-Auftrag). Bei "Garantie"-Aufträgen werden alle zugelassenen
     H*            Ersatzartikel in einer Übersicht (Programmaufruf WAO007) zur Auswahl angeboten.
     H*  Änderung: PH 16.08.2017 Projekt 13022. Ermitteln der 1. gültigen Erstz-Ident-Nr.,
     H*            dessen dispositibe LG-Bestand die an das Programm übergebene Gesamt-
     H*            bestellmenge (BSMG + NRMG) in der Stamm-ME nicht übersteigt.
     H*  Änderung: ZG 19.02.2021 DOMETIC Projekt 16302 - 04 B2C
     H*            keine Ersatzartikel-Steuerung für B2C-Aufträge (AFAT="B2C")
     H*
    F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*  für die Ersatz-Ident-Nr
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D ERTE            S                   DIM(999) LIKE(TEERTE) INZ
     D AUSL            S                   DIM(999) LIKE(TEERTE) INZ
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
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
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ
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
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
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
     C     PCPGST        WHENEQ    'ERERTE'                                     ERMITTELN DER 1.
     C                   EXSR      ERERTE                                       GÜLTIGEN IDENT-NR
     C*--------------------------------------------------------                 Ermitteln der 1.
     C     PCPGST        WHENEQ    'ERTEMG'                                     gültigen Ident-Nr
     C                   EXSR      ERTEMG                                       unter Berücks. TEMG
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERAUSL'                                     ERMITTELN
     C                   MOVEL     DAFIRM        WKFIRM            2
     C                   MOVEL     DSFIRM        DAFIRM
     C                   OUT       EXTRLD
     C*
     C                   EXSR      ERAUSL                                       VORGÄNGER MIT ST=79
     C*
     C                   MOVEL     WKFIRM        DAFIRM
     C                   OUT       EXTRLD
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRERTE'                                     IN-SICH-VERWENDUNG
     C                   EXSR      PRERTE                                       PRÜFEN
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   RETURN
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
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
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
     C                   MOVEA     KOM(01)       DSTENR
     C                   MOVEA     KOM(16)       DSERTE
     C                   MOVEA     KOM(31)       DSAFAT
     C                   MOVEA     KOM(34)       DSLANR
     C                   MOVEA     KOM(37)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN112        DSTEMG
     C                   MOVEA     KOM(48)       DSFIRM            2
     C     DSFIRM        IFEQ      *BLANK
     C                   MOVEL     DAFIRM        DSFIRM
     C                   ENDIF
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
     C                   MOVEL(P)  '$$WAOERTE'   KYTPTA
     C                   MOVEL(P)  DSAFAT        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C     CHI(5)        IFEQ      'J'
     C                   MOVE      *ON           WKWAOERTE                      "GARANTIE"-AUFTRAG
     C                   ELSE
     C                   MOVE      *OFF          WKWAOERTE                      "NICHTGARANTIE"-
     C                   ENDIF                                                  AUFTRAG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER ERSTEN GÜLTIGEN IDENT-NR FÜR DIE ÜBERGEBENE IDENT-NR***
     C***  GÜLTIG HEISST IN DISEM FALL TETEST < '90' ODER TEERTE = *BLANK    ***
     C**************************************************************************
     C     ERERTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO                                        ARTIKEL OK
     C     DSAFAT        ANDNE     'B2C'
     C*
     C     WKWAOERTE     IFEQ      *ON                                          "GARANTIE"-AUFTRAG
     C     TEERTE        ANDNE     *BLANK
     C     TETEST        ANDGT     '81'
     C     WKWAOERTE     OREQ      *OFF                                         "NICHTGARANTIE"-
     C     TEERTE        ANDNE     *BLANK                                       AUFTRAG
     C     TETEST        ANDGT     '80'
     C                   EXSR      EERTE
     C                   MOVEL(P)  WKERTE        RTTRNDDATE
     C                   ELSE
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER 1. GÜLTIGEN ERSATZ-ID-NR FÜR DIE ÜBERGEBENE ID-NR   ***
     C***  GÜLTIG HEISST IN DISEM FALL TETEST < '90' ODER TEERTE = *BLANK    ***
     C**************************************************************************
     C     EERTE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        ERTE
     C                   MOVEL(P)  TETENR        ERTE(01)
     C                   Z-ADD     1             I2
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKERTE
     C                   MOVEL     *BLANK        W1ERTE
     C*-------------------------------------------------------------------------
     C     WKERTE        DOWEQ     *BLANK
     C*
     C                   MOVEL(P)  TEERTE        KYTENR                         LESEN
     C                   MOVEL     *BLANK        KYTEEZ                         ERSATZIDENT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  DSTENR        WKERTE
     C     W1ERTE        IFNE      *BLANK
     C                   MOVEL(P)  W1ERTE        WKERTE
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     1             I1
     C     TETENR        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *OFF
     C     *BLANK        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *ON
     C                   MOVEL(P)  TETENR        ERTE(I1)
     C                   MOVEL     *OFF          *IN98
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKWAOERTE     WHENEQ    *OFF                                         "NICHTGARANTIE"-AF
     C     TETEST        ANDLT     '81'                                         KEIN AUSLAUFARTIKEL
     C                   MOVEL(P)  TETENR        WKERTE                         II. WAHL UND NICHT
     C                   LEAVE                                                  GESPERRT
     C*
     C     WKWAOERTE     WHENEQ    *ON                                          "GARANTIE"-AUFTRAG,
     C     TETEST        ANDLE     '81'                                         NICHT GESPERRT SOWIE
     C*                                                                         AUSLAUF II.WAHL SIND
     C                   ADD       1             I2                             ZUGELASSEN
     C     I2            IFEQ      1
     C                   MOVEL(P)  TETENR        W1ERTE
     C                   ELSE
     C*
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEA(P)  DSTENR        KOM(01)
     C                   MOVE      *ON           KOM(16)
     C                   MOVEL(P)  'DETAIL'      #CPGST
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   EXSR      WAO007                                       ALLE ZUGELASSENEN
     C     WKTRTP        IFEQ      *OFF                                         ERSATZARTIKEL
     C     WKFENR        ANDEQ     *ZERO                                        ANZEIGEN
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        WKERTE
     C**                 LEAVE
     C                   ELSE                                                   KEIN ERSATZARTIKEL
     C**                 MOVEL(P)  DSTENR        WKERTE                         AUSGEWÄHLT
     C                   MOVEL(P)  W1ERTE        WKERTE                         AUSGEWÄHLT
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     TEERTE        WHENEQ    *BLANK                                       KEIN WEITERER
     C                   MOVEL(P)  DSTENR        WKERTE                         ERSATZARTIKEL
     C     W1ERTE        IFNE      *BLANK
     C                   MOVEL(P)  W1ERTE        WKERTE
     C                   ENDIF
     C                   LEAVE
     C*
     C     TEERTE        WHENNE    *BLANK                                       ERSATZARTIKEL VOR-
     C     *IN98         ANDEQ     *ON                                          HANDEN DER ARTIKEL
     C                   MOVEL(P)  DSTENR        WKERTE                         WURDE ABER SCHON MAL
     C     W1ERTE        IFNE      *BLANK                                       AUFGELÖST - IN-SICH
     C                   MOVEL(P)  W1ERTE        WKERTE                         VERWENDUNG
     C                   ENDIF
     C                   LEAVE
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Ermitteln der 1. gültigen Ident-Nr. unter Berücksichtigung der an ***
     C***  das Programm übergbenen Gesamtbestellmenge in der Stamm-ME (DSTEMG)**
     C**************************************************************************
     C     ERTEMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KYAAAT        IFNE      DSAFAT
     C                   MOVEL(P)  DSAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZERO                                        ARTIKEL OK
     C     DSAFAT        ANDNE     'B2C'
     C                   IF        TEERTE <> *BLANK
     C                   EXSR      ETEMG
     C                   MOVEL(P)  WKERTE        RTTRNDDATE
     C                   ELSE
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Ermitteln der 1. gültigen Ident-Nr. unter Berücksichtigung der an ***
     C***  das Programm übergbenen Gesamtbestellmenge in der Stamm-ME (DSTEMG)**
     C**************************************************************************
     C     ETEMG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        ERTE
     C                   MOVEL(P)  TETENR        ERTE(01)
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKERTE
     C*-------------------------------------------------------------------------
     C     WKERTE        DOWEQ     *BLANK
     C*
     C                   MOVEL(P)  TEERTE        KYTENR                         LESEN
     C                   MOVEL     *BLANK        KYTEEZ                         ERSATZIDENT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  DSTENR        WKERTE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     1             I1
     C     TETENR        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *OFF
     C     *BLANK        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *ON
     C                   MOVEL(P)  TETENR        ERTE(I1)
     C                   MOVEL     *OFF          *IN98
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      PRTEMG
     C*
     C                   SELECT
     C     WKWAOERTE     WHENEQ    *OFF                                         "NICHTGARANTIE"-AF
     C     TETEST        ANDLT     '81'                                         KEIN AUSLAUFARTIKEL
     C     WKITER        ANDEQ     *OFF                                         II. WAHL UND NICHT
     C                   MOVEL(P)  TETENR        WKERTE                         GESPERRT
     C                   LEAVE
     C*
     C     WKWAOERTE     WHENEQ    *ON                                          "GARANTIE"-AUFTRAG,
     C     TETEST        ANDLE     '81'                                         NICHT GESPERRT SOWIE
     C     WKITER        ANDEQ     *OFF                                         AUSLAUF II.WAHL SIND
     C*                                                                         ZUGELASSEN
     C                   MOVEL(P)  TETENR        WKERTE
     C                   LEAVE
     C*
     C     TEERTE        WHENEQ    *BLANK                                       KEIN WEITERER
     C                   MOVEL(P)  DSTENR        WKERTE                         ERSATZARTIKEL
     C                   LEAVE
     C*
     C     TEERTE        WHENNE    *BLANK                                       ERSATZARTIKEL VOR-
     C     *IN98         ANDEQ     *ON                                          HANDEN DER ARTIKEL
     C                   MOVEL(P)  DSTENR        WKERTE                         WURDE ABER SCHON MAL
     C                   LEAVE
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen der an das Programm übergebenen Gesamtbestellmenge in der  ***
     C***  Stamm-ME auf den Lagerbestand
     C**************************************************************************
     C     PRTEMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKITER = *OFF
     C*
     C     AABSFU        IFEQ      DAJNKZ
     C     TEBSKZ        ANDEQ     DAJNKZ
     C     AAGNKZ        ANDNE     DAJNKZ
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C     AALGBE        IFEQ      *BLANK
     C                   MOVEA     DSLANR        KOM(25)
     C                   ELSE
     C                   MOVEA     AALGBE        KOM(99)
     C                   ENDIF
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        DSVFBS
     C                   MOVEA     KOM(040)      DUC013
     C                   Z-ADD     DUN134        WKRESN
     C                   MOVEA     KOM(053)      DUC013
     C                   Z-ADD     DUN134        WKRESB
     C*
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C                   MOVEA     '300'         KOM(25)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   ADD       DUN134        DSVFBS
     C                   MOVEA     KOM(040)      DUC013
     C                   ADD       DUN134        WKRESN
     C                   MOVEA     KOM(053)      DUC013
     C                   ADD       DUN134        WKRESB
     C*
     C                   MOVE      *ZERO         WKBESU
     C*
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVEL(P)  *ON           KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *OFF          KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *OFF          KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C                   MOVEA     '900'         KOM(99)
     C                   Z-ADD     *ZERO         DUN080
     C                   MOVEA     DUC008        KOM(202)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   Z-ADD     RTLBB2BESU    WKBESU
     C                   ADD       RTLBB2BESB    WKBESU
     C*
     C                   IF        DSTEMG > DSVFBS - WKRESB - WKRESN + WKBESU
     C                             OR DSVFBS - WKRESB - WKRESN + WKBESU <= 0
     C                   EVAL      WKITER = *ON
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DES VORGÄNGERS MIT STATUS 79                            ***
     C**************************************************************************
     C     ERAUSL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KYAAAT        IFNE      DSAFAT
     C                   MOVEL     DSFIRM        KYAAFI
     C                   MOVEL     DSAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSFIRM        KYTEFI
     C                   MOVEL(P)  DSTENR        KYTEET
     C                   MOVEL(P)  *BLANK        KYTENR
     C                   MOVEA     '06+     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     CHI(05)       IFEQ      'N'                                          KEIN VORGÄNGER
     C     TEFIRM        ORNE      KYTEFI                                       VORHANDEN
     C     TEERTE        ORNE      KYTEET
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C     TEFIRM        ANDEQ     KYTEFI
     C     TEERTE        ANDEQ     KYTEET
     C*
     C                   SELECT
     C     TETEST        WHENGE    '90'
     C                   MOVEA     '06R     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     CHI(05)       IFEQ      'N'                                          KEIN VORGÄNGER
     C     TEFIRM        ORNE      KYTEFI                                       VORHANDEN
     C     TEERTE        ORNE      KYTEET
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ITER
     C     TETEST        WHENNE    '79'
     C     TETEST        ANDLT     '90'
     C                   EXSR      EAUSL
     C                   ENDSL
     C*
     C     TETEST        IFEQ      '79'
     C*
     C     AABSFU        IFEQ      DAJNKZ
     C     TEBSKZ        ANDEQ     DAJNKZ
     C     AAGNKZ        ANDNE     DAJNKZ
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C     AALGBE        IFEQ      *BLANK
     C                   MOVEA     DSLANR        KOM(25)
     C                   ELSE
     C                   MOVEA     AALGBE        KOM(99)
     C                   ENDIF
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        DSVFBS
     C                   MOVEA     KOM(040)      DUC013
     C                   Z-ADD     DUN134        WKRESN
     C                   MOVEA     KOM(053)      DUC013
     C                   Z-ADD     DUN134        WKRESB
     C*
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C                   MOVEA     '300'         KOM(25)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   ADD       DUN134        DSVFBS
     C                   MOVEA     KOM(040)      DUC013
     C                   ADD       DUN134        WKRESN
     C                   MOVEA     KOM(053)      DUC013
     C                   ADD       DUN134        WKRESB
     C*
     C                   MOVE      *ZERO         WKBESU
     C*
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVEL(P)  *ON           KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *OFF          KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *OFF          KOM(3)                         ERM.LAGERRESERV.
     C                   MOVE      *ON           KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C                   MOVEA     TETENR        KOM(10)
     C                   MOVEA     '900'         KOM(99)
     C                   Z-ADD     *ZERO         DUN080
     C                   MOVEA     DUC008        KOM(202)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'V'           EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   Z-ADD     RTLBB2BESU    WKBESU
     C                   ADD       RTLBB2BESB    WKBESU
     C*
     C                   IF        DSTEMG > DSVFBS - WKRESB - WKRESN + WKBESU
     C                             OR DSVFBS - WKRESB - WKRESN + WKBESU <= 0
     C                   MOVEA     '06R     '    CHI
     C                   EXSR      CHTEIL
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------- ---------------------------------------------------------
     C                   MOVEL(P)  TETENR        RTTRNDDATE
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   LEAVESR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     CHI(05)       IFEQ      'N'                                          KEIN VORGÄNGER
     C     TEFIRM        ORNE      KYTEFI                                       VORHANDEN
     C     TEERTE        ORNE      KYTEET
     C                   MOVEL(P)  DSTENR        RTTRNDDATE
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER NÄCHSTEN VORLÄUFERS                          D-NR   ***
     C**************************************************************************
     C     EAUSL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        AUSL
     C                   MOVEL(P)  TEERTE        AUSL(01)
     C                   Z-ADD     1             I2
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKAUSL
     C                   MOVEL     *BLANK        W1AUSL
     C*-------------------------------------------------------------------------
     C     WKAUSL        DOWEQ     *BLANK
     C*
     C                   MOVEL(P)  TEFIRM        KYTEFI
     C                   MOVEL(P)  TETENR        KYTEET                         LESEN
     C                   MOVEL     *BLANK        KYTENR                         ERSATZIDENT
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '06+     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C     KYTEFI        ORNE      TEFIRM
     C     KYTEET        ORNE      TEERTE
     C                   MOVEL(P)  DSTENR        WKAUSL
     C     W1AUSL        IFNE      *BLANK
     C                   MOVEL(P)  W1AUSL        WKAUSL
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     1             I1
     C     TETENR        LOOKUP    AUSL(I1)                               98
     C*
     C     *IN98         IFEQ      *OFF
     C     *BLANK        LOOKUP    AUSL(I1)                               98
     C*
     C     *IN98         IFEQ      *ON
     C                   MOVEL(P)  TEERTE        AUSL(I1)
     C                   MOVEL     *OFF          *IN98
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     TETEST        WHENEQ    '79'
     C                   MOVEL(P)  TETENR        WKAUSL
     C                   LEAVE
     C*
     C     TEERTE        WHENNE    *BLANK                                       ERSATZARTIKEL VOR-
     C     *IN98         ANDEQ     *ON                                          HANDEN DER ARTIKEL
     C                   MOVEL(P)  DSTENR        WKAUSL                         WURDE ABER SCHON MAL
     C     W1AUSL        IFNE      *BLANK                                       AUFGELÖST - IN-SICH
     C                   MOVEL(P)  W1AUSL        WKAUSL                         VERWENDUNG
     C                   ENDIF
     C                   LEAVE
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEFIRM        KYTEFI
     C                   MOVEL(P)  WKAUSL        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** IN-SICH-VERWENDUNG FÜR DIE ÜBERGEBENEN ID- UND ERSATZ-ID-NR PRÜFEN ***
     C**************************************************************************
     C     PRERTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        ERTE
     C                   MOVEL(P)  DSTENR        ERTE(01)
     C                   MOVEL(P)  DSERTE        TEERTE
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*
     C                   MOVEL(P)  TEERTE        KYTENR                         LESEN
     C                   MOVEL     *BLANK        KYTEEZ                         ERSATZIDENT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      *ZERO         WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     1             I1
     C     TETENR        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *OFF
     C     *BLANK        LOOKUP    ERTE(I1)                               98
     C*
     C     *IN98         IFEQ      *ON
     C                   MOVEL(P)  TETENR        ERTE(I1)
     C                   MOVEL     *OFF          *IN98
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     TEERTE        WHENEQ    *BLANK                                       KEIN WEITERER
     C                   LEAVE                                                  ERSATZARTIKEL
     C*
     C     TEERTE        WHENNE    *BLANK                                       ERSATZARTIKEL VOR-
     C     *IN98         ANDEQ     *ON                                          HANDEN DER ARTIKEL
     C                   MOVE      '2001'        WKFENR                         WURDE ABER SCHON MAL
     C                   LEAVE                                                  AUFGELÖST - IN-SICH-
     C*                                                                         VERWENDUNG
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     WKFENR        RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE-ROUTINE DATEI TEIL                                      ***
     C**************************************************************************
     C     WAO007        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'WAO007'                             98
     C                   PARM                    EXTR02
     C                   PARM                    TEIL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     *IN98         WHENEQ    *ON
     C                   MOVE      '0063'        WKFENR
     C*--------------------------------------------------------
     C     #CRTCD        WHENEQ    '1'
     C     #CRTCD        OREQ      'N'
     C                   MOVE      *ON           WKTRTP
     C*--------------------------------------------------------
     C     #CRTCD        WHENEQ    '9'
     C                   MOVE      '0901'        WKFENR
     C*--------------------------------------------------------
     C                   ENDSL
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
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*
     C     *LIKE         DEFINE    WKC001        WKWAOERTE
     C     *LIKE         DEFINE    WKC001        WKITER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
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
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TETENR        DSTENR                         ÜBERGEBENE IDENR-NR.
     C     *LIKE         DEFINE    TEERTE        DSERTE                         ÜBERGEB.ERSATZ-ID-NR
     C     *LIKE         DEFINE    TEERTE        WKERTE                         ERSATZ-IDENT-NR
     C     *LIKE         DEFINE    TEERTE        W1ERTE                         ERSATZ-IDENT-NR
     C     *LIKE         DEFINE    TEERTE        WKAUSL                         ERSATZ-IDENT-NR
     C     *LIKE         DEFINE    TEERTE        W1AUSL                         ERSATZ-IDENT-NR
     C     *LIKE         DEFINE    DUC003        DSAFAT                         AUFTRAGS-ART
     C     *LIKE         DEFINE    DUC003        DSLANR
     C     *LIKE         DEFINE    DUN112        DSTEMG
     C     *LIKE         DEFINE    DUN134        DSVFBS
     C     *LIKE         DEFINE    DUN134        WKRESN
     C     *LIKE         DEFINE    DUN134        WKRESB
     C     *LIKE         DEFINE    DUN134        WKBESU
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
