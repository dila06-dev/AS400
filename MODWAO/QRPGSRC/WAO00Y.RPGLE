     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H*
     H*  Bei der Umwandlung Bibliothek DOMGEN der Libl hinzufügen
     H*
     H**************************************************************************
     H/TITLE  Ermitteln Unterwegs-, Sperr und WE-Bestand
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 20.04.2004 Weaco Projekt 2774
     H*  -----------------------------------------------------------------------
     H*  Änderung: RE 05.11.2010 Weaco neue WE Lager 400 und 410
     H*  Änderung: RE 14.12.2010 WAECO Projekt 7011
     H*            Ermitteln VK-Preis
     H*  Änderung: RE 04.05.2011 DOMETIC PROJEKT 7402
     H*            unterschiedliche Sperrgründe für Vertrieb (VPKZ = "V") und
     H*            Produktion/Einkauf (VPKZ = "P")
     H*  Änderung: PH 30.05.2011 Projekt 7460 für Kunde WAECO (DOMETIC). Ermittlung des "sofort
     H*            lieferbaren" Bestands intergriert
     H*  Änderung: MG 06.12.2012 Projekt 9024 Mandantenübergreifenden Abwicklung
     H*            Aufruf der Anfangsroutine bei Firmenwechsel (DAFIRM/WKFIRM)
     H*  Änderung: SZ 27.04.2016 Projekt 11427, differenzierten Bestand aus LFS
     H*            über externen Aufruf ermitteln und zusätzlich übergeben
     H*            Feld D1NSLI
     H*  Änderung: GS 12.05.2021 Projekt 16586 ermitteln Dispo-Sätze "043" für Ware
     H*            unterwegs pro Lagerbereich. Rückgabe RTLBB2BESU
     H*  Änderung: GS 04.08.2021 Projekt 16626 Bei den Disposätzen "043"('BU') muss mit
     H*            der offenen Menge (WKOFMG) und nicht mit WKMENG gerechnet werden.
     H*            Des weiteren muss bei der "SOLI"-Routine die Wiederbeschaffungszeit
     H*            des Lieferanten berücksichtigt werden.
     H*  Änderung: GS 07.04.2022 Projekt 220051 Bei "Ware unterwegs" (TRUNTW) wird fix mit
     H*            dem Lagerbereich "901" gearbeitet. (Lager 500,510 und 590)
     H*  Änderung: ZG 19.04.2023 Projekt 230186-01 Änderung der Sofort lieferbaren Menge
     H*            Berücksichtigung des Parameters TRAF17/RSZR/RSZR
     H*            bei der Ermittlung der  sofort lieferbaren Menge aus der Bestellung
     H*            (Begriff 040,041, RS-Datum>=Tagesdatum+Tage aus dem Parameter)
     H*  Änderung: PH 23.05.2025 Projekt Dometic Germany - B2B (Case #03777387). Aufruf
     H*            mit separatem Pgm-Status 'ERSOLI' nur dür die Ermittlung des sofort
     H*            lieferbaren Bestandes (Routine TRSOLI).
     F**************************************************************************
     F*
     F*  Ermittlung des Sperr-, Unterwegs- und WE-Bestandes über MCDIST
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D PREI          E DS                  INZ
     D KYPREI        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D DIST          E DS                  INZ
     D KYDIST        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D DSBSTHEL      E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D TESTST          S                   DIM(20)  INZ LIKE(TETEST)            STATIS FÜR LIST-FUNK
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
     C     WKFIRM        CASNE     DAFIRM        ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      PCPGST = 'ERSOLI'
     C                   EXSR      TRSOLI
     C                   OTHER
     C                   EXSR      TRUNTW
     C                   EXSR      TRWEMG
     C                   EXSR      TRSPER
     C                   EXSR      TRSOLI
     C                   EXSR      EHELL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      D1UNTW        DUC013
     C                   TESTN                   DUC013               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUN134                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   MOVEA     DUC013        KOM(16)
     C*-------------------------------------------------------------------------
     C                   MOVE      D1WEMG        DUC013
     C                   TESTN                   DUC013               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUN134                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   MOVEA     DUC013        KOM(29)
     C*-------------------------------------------------------------------------
     C                   MOVE      D1SPER        DUC013
     C                   TESTN                   DUC013               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUN134                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   MOVEA     DUC013        KOM(42)
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PREI
     C                   MOVEL     DAFIRM        KYPRFI
     C                   MOVEL(P)  'PVK'         KYPRBG
     C                   MOVEL(P)  WKTENR        KYPRTE
     C                   MOVEL(P)  EXFIRMWACD    KYPRWC
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        KYPRDA
     C*
     C                   MOVEA     '00-     '    CHI
     C                   EXSR      CHPREI
     C*
     C     CHI(5)        IFEQ      'N'
     C     PRFIRM        ORNE      KYPRFI                                       URSPRUNGSGRENZE
     C     PRBEGR        ORNE      KYPRBG                                       UNTERSCHRITTEN
     C     PRPSLI        ORNE      KYPRPS
     C     PRABTL        ORNE      KYPRAB
     C     PRLAND        ORNE      KYPRLD
     C     PRBLGA        ORNE      KYPRBL
     C     PRPRGR        ORNE      KYPRPG
     C     PRMAGR        ORNE      KYPRMG
     C     PRVKGB        ORNE      KYPRVG
     C     PRPOLZ        ORNE      KYPRPZ
     C     PRSTCD        ORNE      KYPRSC
     C     PRKDLI        ORNE      KYPRKL
     C     PRKDLG        ORNE      KYPRKG
     C     PRTENR        ORNE      KYPRTE
     C     PRGEBI        ORNE      KYPRGB
     C     PRPJNR        ORNE      KYPRPJ
     C     PRWACD        ORNE      KYPRWC
     C                   CLEAR                   PREI
     C                   ENDIF
     C*
     C     PRGBDA        IFNE      *ZERO                                        PRÜFEN DES
     C     PRGBDA        ANDLT     KYPRDA                                       BIS-DATUM
     C                   CLEAR                   PREI
     C                   ENDIF
     C*
     C                   Z-ADD     PREZPR        DUN113
     C                   MOVEA     DUC011        KOM(55)
     C*-------------------------------------------------------------------------
     C                   Z-ADD     D1SOLI        DUN134
     C                   MOVEA     DUC013        KOM(66)
     C                   Z-ADD     D1NSLI        DUN134
     C                   MOVEA     DUC013        KOM(79)
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  KOM           EXTRNDKEYB
     C                   MOVEA(P)  KOM           RTTRNDDATE
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        WKFIRM
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   SETON                                        LR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  KOM(01)       WKTENR
     C                   MOVEA(P)  KOM(16)       WKVPKZ            1
     C                   MOVEA(P)  KOM(17)       WKLGBE            3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C*MG                MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYPRFI                         PREI
     C                   MOVEL(P)  DAFIRM        KYITFI                         DSIT
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYZTFI                         ZTDI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        WKUDAT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKUDAT        EXDATEDATV
     C                   Z-ADD     WKTRPARSZR    EXDATEWERT
     C                   MOVEL(P)  '001'         EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    W2RSDA
     C                   ELSE
     C                   Z-ADD     WKUDAT        W2RSDA
     C                   ENDIF

     C                   EVAL      D1UNTW = *ZERO
     C                   EVAL      D1WEMG = *ZERO
     C                   EVAL      D1SPER = *ZERO
     C                   EVAL      D1SOLI = *ZERO
     C                   EVAL      D2SOLI = *ZERO
     C                   EVAL      D1NSLI = *ZERO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRUNTW     ERMITTELN UNTERWEGSBESTAND                          ***
     C**************************************************************************
     C     TRUNTW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         D1UNTW           13 4
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C***??              MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     *BLANK        KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C**GS               MOVEA     WKLGBE        KOM(99)
     C                   MOVEA     '901'         KOM(99)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        D1UNTW
     C**GS               Z-ADD     RTLBB2BESU    D1UNTW
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRWEMG     ERMITTELN WARENEINGANGSBESTAND                      ***
     C**************************************************************************
     C     TRWEMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         D1WEMG           13 4
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C****?              MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '100'         KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        D1WEMG
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C****??             MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '110'         KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   ADD       DUN134        D1WEMG
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C****??             MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '400'         KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   ADD       DUN134        D1WEMG
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBB2
     C                   CLEAR                   RTLBB2
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C****??             MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '410'         KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   ADD       DUN134        D1WEMG
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRSPER     ERMITTELN SPERRBESTAND                              ***
     C**************************************************************************
     C     TRSPER        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         D1SPER           13 4
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C**??               MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     *BLANK        KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(144)      DUC013
     C                   Z-ADD     DUN134        D1SPER
     C*-------------------------------------------------------------------------
     C     WKVPKZ        IFEQ      'V'
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *OFF          KOM(1)
     C                   MOVE      *ON           KOM(2)
     C                   MOVE      *ON           KOM(3)
     C**??               MOVE      *OFF          KOM(3)
     C                   MOVE      *ON           KOM(4)
     C                   MOVE      *OFF          KOM(5)
     C                   MOVEA     *BLANK        KOM(6)
     C                   MOVE      *ON           KOM(7)
     C                   MOVE      *OFF          KOM(9)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '180'         KOM(25)
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(144)      DUC013
     C                   SUB       DUN134        D1SPER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRSOLI     ERMITTELN SOFORT LIEFERBAREN BESTAND                ***
     C**************************************************************************
     C     TRSOLI        BEGSR
     C*
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVE      WKTDAT        WKBETE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTENR                         ERMITTELN
     C                   MOVEL     *BLANK        KYTEEZ                         DER IDENT-
     C                   MOVEA     '01C     '    CHI                            ART
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C*    Ermitteln der Transportzeit aus dem Lieferantenstamm (Stammlieferant TEIL)
     C     TESTLF        IFNE      KYLFNR
     C                   MOVEL     TESTLF        KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         ERMITTELN
     C                   MOVEL(P)  'FIRM'        KYTATA                         BRIEFKASTEN-
     C                   MOVEL(P)  'DIBR'        KYTATC                         ART
     C                   MOVEL(P)  TETART        KYTAPA                         PRODUKTION 'PRO'
     C                   MOVEA     '01C     '    CHI                            ODER BESTELLUNG
     C                   EXSR      CHTRPA                                       'BES'
     C                   MOVEL(P)  TAPCDE        WKTRPADIBR
     C*-------------------------------------------------------------------------
     C     WKTRPADIBR    IFEQ      '030'                                        EIGENFERTIGUNG
     C                   MOVEL(P)  TEVOA1        WKVLAT                         V-ART (T,M,W) AV
     C                   Z-ADD     TEVOZ1        WKVLZT                         VORLAUFZEIT   AV
     C                   ENDIF
     C     WKTRPADIBR    IFEQ      '040'                                        KAUFTEIL
     C                   MOVEL(P)  TELVA1        WKVLAT                         VORLAUFART    EK
     C                   Z-ADD     TELVZ1        WKVLZT                         VORLAUFZEIT   EK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKVLAT        IFEQ      *BLANK                                       KEINE VL-DATEN
     C     WKVLZT        OREQ      *ZERO                                        IM IDENTSTAMM
     C                   MOVE      WKTDAT        WKBETE                         RES.DATUM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'T'           KYZTZD                         ZEITFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZU
     C                   EXSR      CHZTDI                                       TAGEN
     C                   Z-ADD     ZTZTFK        WKZTFK
     C     WKZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             WKZTFK
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKVLAT        KYZTZD                         ZEIFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZUR
     C                   EXSR      CHZTDI                                       IDENTSTAMM
     C                   Z-ADD     ZTZTFK        W1ZTFK                         VORLAUFZEIT
     C     W1ZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             W1ZTFK
     C                   ENDIF
     C*--------------------------------------------------------
     C     W1ZTFK        DIV       WKZTFK        DUN030                         ERMITTELN DES
     C     DUN030        MULT      WKVLZT        DUN030                         TAGES-VERHÄLTNIS
     C                   ADD       LFVSTA        DUN030
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKBETE        EXDATEDATV
     C                   Z-ADD     DUN030        EXDATEWERT
     C                   MOVEL(P)  '001'         EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    WKBETE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKBETE        IFLE      *ZERO                                        PRÜFUNG
     C     WKBETE        ORLT      WKUDAT                                       DATUM
     C                   Z-ADD     WKUDAT        WKBETE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         D1SOLI
     C                   Z-ADD     *ZERO         D1NSLI
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(01)
     C                   MOVE      *ON           KOM(02)
     C                   MOVE      *ON           KOM(03)
     C                   MOVE      *OFF          KOM(04)
     C                   MOVE      *OFF          KOM(05)
     C                   MOVEA     *BLANK        KOM(06)
     C                   MOVE      *ON           KOM(07)
     C                   MOVE      *OFF          KOM(09)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '001'         KOM(25)
     C                   Z-ADD     WKBETE        DUN080
     C                   MOVEA     DUC008        KOM(202)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL(P)  WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(001)      DUC013                         Lagerbestand gesamt
     C                   Z-ADD     DUN134        D1SOLI
     C                   MOVEA     KOM(092)      DUC013                         Res.Bestand
     C                   SUB       DUN134        D1SOLI
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(01)
     C                   MOVE      *ON           KOM(02)
     C                   MOVE      *ON           KOM(03)
     C                   MOVE      *OFF          KOM(04)
     C                   MOVE      *OFF          KOM(05)
     C                   MOVEA     *BLANK        KOM(06)
     C                   MOVE      *ON           KOM(07)
     C                   MOVE      *OFF          KOM(09)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '060'         KOM(25)
     C                   Z-ADD     WKBETE        DUN080
     C                   MOVEA     DUC008        KOM(202)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL(P)  WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(001)      DUC013                         Lagerbestand gesamt
     C                   ADD       DUN134        D1SOLI
     C                   MOVEA     KOM(092)      DUC013                         Res.Bestand
     C                   SUB       DUN134        D1SOLI
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(01)
     C                   MOVE      *ON           KOM(02)
     C                   MOVE      *ON           KOM(03)
     C                   MOVE      *OFF          KOM(04)
     C                   MOVE      *OFF          KOM(05)
     C                   MOVEA     *BLANK        KOM(06)
     C                   MOVE      *ON           KOM(07)
     C                   MOVE      *OFF          KOM(09)
     C                   MOVEA     WKTENR        KOM(10)
     C                   MOVEA     '070'         KOM(25)
     C                   Z-ADD     WKBETE        DUN080
     C                   MOVEA     DUC008        KOM(202)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL(P)  WKVPKZ        EXLBB2VPKZ
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBB2
     C                   PARM                    RTLBB2
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(001)      DUC013                         Lagerbestand gesamt
     C                   ADD       DUN134        D1SOLI
     C                   MOVEA     KOM(092)      DUC013                         Res.Bestand
     C                   SUB       DUN134        D1SOLI
     C*-------------------------------------------------------------------------
     C                   Z-ADD     D1SOLI        D2SOLI
     C                   Z-ADD     *ZERO         WKRSDA
     C*-------------------------------------------------------------------------
     C                   MOVE      WKTENR        KYITTE
     C                   MOVE      *LOVAL        KYITRD                         SCHLÜSSEL
     C                   MOVE      *LOVAL        KYITRZ
     C                   MOVE      *LOVAL        KYITBG
     C                   MOVE      *LOVAL        KYITJH
     C                   MOVE      *LOVAL        KYITNR
     C                   MOVE      *LOVAL        KYITPO
     C                   MOVE      *LOVAL        KYITUP
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHDIST
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     ITFIRM        IFGT      KYITFI
     C     ITTENR        ORGT      KYITTE                                       VERGLEICHEN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKRSDA        WHENEQ    *ZERO
     C                   MOVE      ITRSDA        WKRSDA
     C     ITRSDA        WHENGT    WKRSDA
     C*
     C     D2SOLI        IFLT      D1SOLI
     C                   Z-ADD     D2SOLI        D1SOLI
     C                   ENDIF
     C     D2SOLI        IFLE      *ZERO
     C     ITRSDA        ANDNE     *ZERO
     C     WKRSDA        ANDNE     *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C     ITRSDA        IFGT      WKBETE
     C     TETEST        LOOKUP    TESTST(1)                              98
     C     *IN(98)       IFEQ      *OFF
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     ITLANR        IFEQ      '001'
     C     ITLANR        OREQ      '060'
     C     ITLANR        OREQ      '070'
     C     ITBEGR        OREQ      '043'
     C     ITBEGR        OREQ      '040'
     C*
     C                   MOVEL     'ERMMGE'      #CPGST                         ERMITTELN
     C                   EXSR      TRDIMG                                       DIST-MENGE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHDIST
     C                   ITER
     C                   ENDIF
     C*
     C     ITBEGR        IFEQ      '040'
     C     ITBEGR        OREQ      '041'
     C     WKDIMGBSKZ    IFEQ      *BLANK
     C     ITRSDA        ORLT      W2RSDA
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHDIST
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C     ITBEGR        IFNE      '014'
     C*
     C     WKRBKZ        IFEQ      'RN'                                         RESERVIERUNG
     C     WKRBKZ        OREQ      'RS'                                         RESERVIERUNG
     C     WKRBKZ        OREQ      'BN'                                         RESERVIERUNG
     C     WKRBKZ        OREQ      'BS'                                         RESERVIERUNG
     C     WKRBKZ        OREQ      'BU'                                         RESERVIERUNG
     C*
     C                   SELECT
     C     WKRBKZ        WHENEQ    'BU'
     C                   ADD       WKOFMG        D2SOLI
     C     WKWTKZ        WHENEQ    '+'
     C     WKDIMGBSKZ    ANDEQ     DAJNKZ
     C                   ADD       WKOFMG        D2SOLI
     C     WKWTKZ        WHENEQ    '-'
     C                   SUB       WKOFMG        D2SOLI
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      ITRSDA        WKRSDA
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI                            READ
     C                   EXSR      CHDIST
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     D2SOLI        IFLT      D1SOLI
     C                   Z-ADD     D2SOLI        D1SOLI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRDIMG     ERMITTELM DISPO-MENGE                               ***
     C**************************************************************************
     C     TRDIMG        BEGSR
     C*
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRBKZ          + 1            KZ RES/BES
     C     *LIKE         DEFINE    WKC001        WKWTKZ
     C                   MOVE      *BLANK        WKDIMGBSKZ        1
     C                   MOVE      *ZERO         WKOFMG           11 2          OFFENE MENGE
     C                   MOVE      *ZERO         WKMENG           11 2          OFFENE MENGE
     C                   MOVE      *BLANK        WKRBKZ
     C                   MOVE      *BLANK        WKWTKZ
     C*-------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     'P'           KOM(1)                         KZ SICHT V/P      J/
     C                   MOVEL     *OFF          KOM(22)
     C                   MOVEL     *BLANK        #CRTCD
     C                   MOVEA     KOM(1)        #CKOMM
     C*
     C                   CALL      'TRDIMG'                             99
     C                   PARM                    EXTR02
     C                   PARM                    DIST
     C*-------------------------------------------------------------------
     C     #CRTCD        IFNE      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ELSE
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(1)        DUC011                         DISPO-MENGE
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   MOVE      DUN112        WKMENG
     C                   MOVEA     KOM(12)       WKRBKZ                         KENNZ. RES/BES    J/
     C                   MOVEA     KOM(14)       WKWTKZ                         KZ WERTIGKEIT     J/
     C                   MOVEA     KOM(84)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN112        WKOFMG                         OFFENE MENGE
     C*
     C                   MOVEA     KOM(120)      WKDIMGBSKZ                     BESTELL-BESTÄTIGT
     C                   END                                                    INHALT
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'VERTRIEB'    KYTATA                         PLANUNGS-ART
     C                   MOVEL(P)  'PLAT'        KYTATC                         FÜR WERKSKALENDER
     C                   MOVEL(P)  'PMWK'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAPLAT
     C     WKTRPAPLAT    IFEQ      *BLANK
     C                   MOVEL(P)  '001'         WKTRPAPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'ZTDI'        KYTATC                         STAMMZEIT-
     C                   MOVEL(P)  'ZTDI'        KYTAPA                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        KYZTSZ                         STAMMZEITBASIS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'WAO00Y'      KYTATC
     C                   MOVEL(P)  'TETEST'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEA     TAPCDE        TESTST
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRAF17'      KYTATA                         VORLAUF-
     C                   MOVEL     'RSZR  '      KYTATC                         KORREKTUR
     C                   MOVEL     'RSZR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        DUC003
     C*
     C                   TESTN                   DUC003               98        PRÜFUNG AUF
     C     *IN(98)       IFEQ      *ON                                          NUMERISCHEN
     C                   Z-ADD     DUN030        WKTRPARSZR                     INHALT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BESTAND HELLMANN                                        ***
     C**************************************************************************
     C     EHELL         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      BSFIRM = WKFIRM
     C                   EVAL      BSTENR = WKTENR
     C                   EVAL      BSMENG = *ZERO
     C                   CALL      'BSTHELC01'                          98
     C                   PARM                    DSBSTHEL
     C*
     C                   EVAL      D1NSLI = BSMENG
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKTENR          +14            Ident-Nr.
     C     *LIKE         DEFINE    WKC001        WKTRPADIBR      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAPLAT      + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DUN080        WKUDAT
     C     *LIKE         DEFINE    DUN080        WKBETE
     C     *LIKE         DEFINE    DUN134        D1SOLI
     C     *LIKE         DEFINE    DUN134        D2SOLI
     C     *LIKE         DEFINE    DUN134        D1NSLI
     C     *LIKE         DEFINE    TEVOA1        WKVLAT
     C     *LIKE         DEFINE    TEVOZ1        WKVLZT
     C     *LIKE         DEFINE    ZTZTFK        WKZTFK
     C     *LIKE         DEFINE    ZTZTFK        W1ZTFK
     C     *LIKE         DEFINE    ITRSDA        WKRSDA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C     *LIKE         DEFINE    DUN030        WKTRPARSZR
     C     *LIKE         DEFINE    ITRSDA        W2RSDA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHPREI
     C/COPY QCPYSRC,CHDIST
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHZTDI
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
