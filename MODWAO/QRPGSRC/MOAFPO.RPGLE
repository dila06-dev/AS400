     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: TB 22.11.2010 WAECO
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 28.04.2012 DOMETIC Projekt 7177. Artikel mit pfandpflichtigen Artikeln
     H*            in Verpackungsstückliste sind nur für die KD-Auftrags-Art '06' zugelassen
     H*  Änderung: MG 19.03.2013 DOMETIC Projekt 9024 Erweiterung PRGNPA
     H*            Prüfen das Kz "Generieren Bestellung" abhängig vom Lager "Emsdetten"
     H*  Änderung: MG 24.06.2013 Service 20130624-011 Pseudoartikel nicht zuzlässig
     H*  Änderung: RE 28.08.2013 Projekt 9822
     H*            Ermitteln Staffel-Preise und -Konditionen anhand der Mengen pro
     H*            Prod-Gruppe
     H*  Änderung: SC 06.01.2014 Service 20140106-004 Satzzeiger in UXREAD retten
     H*  Änderung: MG 14.01.2014 Projekt 9787 SDB pro Land, Artikel
     H*            Es dürfen nur dann Artikel mit einem Kennzeichen "SDB Pflicht" als
     H*            Auftragspositionen angelegt werden, wenn für den Artikel und das Land des
     H*            des Auftraggeber ein "Sicherheitsdatenblatt pro Land, Artikel vorliegt
     H*  Änderung: MG 24.07.2014 Service 20140721-025, Keine Generierung zulässig
     H*            wenn bereits kommissioniert
     H*  Änderung: MG 12.05.2015 WAECO Projekt 11348 Neue Abwicklung von Dometic-Sunshine
     H*            Keine Prüfung bei Bestell-Generierung in Emsdetten
     H*  Änderung: PH 14.08.2015 Projekt 11567. Zwei neue Prüfungen:
     H*            - Ob für der F-Gas-Verordnung unterliegende Artikel der Kunde
     H*              (Auftraggeber) ein entsprechendes Zertifikat vorgelegt hat
     H*            - Prüfen, ob das Land, in das der Auftrag versendet werden soll,
     H*              durch die Hinterlegung in der Datei WAOX von der Lieferung von in
     H*              TEEW als "Gefahrgut" gekennzeichneten Artikeln ausgeschlossen ist
     H*  Änderung: MG 13.10.2015 WAECO Service 20151009-013 Prüfen ident-Status Emsdetten
     H*  Änderung: PH 01.02.2016 DOMETIC Projekt 11363. Prüfen Ausnahmen von der STK3-Preisprüfung
     H*            (Standard-Preis) über die Hinterlegungen in der Datei WA12 (zuerst nur für die
     H*            an das Programm übergebene KD-Af-Art, wenn keine solche Hinterlegung vorhanden,
     H*            dann nur für die Kunden-Nr aus dem KD-Auftrags-Kopf, wenn keine solche Hinter-
     H*            legung vorhanden, dann nur für die an das Programm übergebene Produkt-Gruppe,
     H*            wenn keine solche Hinterlegung vorhanden, dann nur für die an das Programm
     H*            übergebene Ident-Nr, wenn keine solche Hinterlegung vorhanden, dann nur für die
     H*            Kombination aus der Kunden-Nr und Produkt-Gruppe, wenn keine solche Hinterlegung
     H*            vorhanden, dann anschließend nur für die Kombination aus der Kunden-Nr und
     H*            Ident-Nr)
     H*  Änderung: MG 09.08.2016 Projekt 12646, Ergänzung zum Projekt 9787
     H*            SDB-Prüfung für Kunden der Dometic-Gruppe (KDEWKSST='1015')
     H*            Steuerung über der Anwendungstabelle WAOSDBPRGR
     H*  Änderung: RE 12.08.2016 DOMETIC Projekt 11363
     H*  Änderung: RE 13.09.2016 DOMETIC Projekt 11940
     H*  Änderung: PH 27.04.2017 DOMETIC Projekt 13218. Ist im Feld TEIL.TEINPR "Inventur-Preis"
     H*            ein Wert hinterlegt, wird dieser statt des Standard-Preises TEIL.TESTPR zur
     H*            Prüfung des Vekaufspreises harangezogen.
     H*  Änderung: GS 28.03.2018 Abstimmung IK/GS Prüfung auf die Identart "P" bei IC-Aufträgen
     H*            inaktiviert. siehe **GS
     H*  Änderung: GS 21.12.2020 Abstimmung IK/GS Einführung Belgien (HUB) Zusätzliche Abfrage
     H*            auf "W06" bei Pfandartikel
     H*  Änderung: GS 20.01.2021 Abstimmung IK/GS Einführung Schweiz (HUB) Zusätzliche Abfrage
     H*            auf "C06" bei Pfandartikel
     H*  Änderung: PH 02.03.2021 Projekt 16393-01. Neue Prüfroutine PRWAOY:
     H*            Prüfen, ob das Land, in das der Auftrag versendet werden soll,
     H*            durch die Hinterlegung in der Datei WAOY von der Belieferung mit
     H*            dem Artikel ausgeschlossen ist bzw. ob der Artikel für den
     H*            Versand in dieses Land zugelassen ist
     H*  Änderung: MG 07.06.2021 Projekt 16570-01 Status 17 bei manueller Reservierung
     H*  Änderung: PH 24.08.2021 Projekt 16393-02. Erweiterung der Prüfroutine PRWAOY:um die
     H*            Prüfung, ob der übergebene Artikel über eine Hinterlegung in der WAOY einem
     H*            ANDEREN Land als das Versand-Zielland zugeordnet ist. Ist dies der Fall, ist
     H*            der übergebene Artikel für den Versand-Zielland nicht zugelassen ist.
     H*  Änderung: GS 27.11.2021 Projekt 16860 Deaktivierung der Routine PRVSKZ. (siehe PRVSKZ
     H*            "LEAVESR")
     H*  Änderung: GS 12.12.2022 DOMETIC Projekt 220567 Aufruf MODWAO/PRWA11, (Werk-Prüfung)
     H*  Änderung: PH 10.08.2023 DOMETIC Projekt 230391-02. Ermittlung und Rückgabe des "verfüg-
     H*            baren Gesamtbestandes" als "Ges-Bestand" (DSLAGB) + Be-Menge (DSBESN) +
     H*            "Unterwegs" (DSUNTW) - "Bedarf" (DSRESN), wobei diese Felder analog den
     H*            gleichnamigen Feldern im Format MCDIST1W berechnet werden.
     H*  Änderung: ZG 04.01.2024 DOMETIC Projekt 230391-04.
     H*            der verfügabere Gesamtbestand DSLAGB wird im Lagerbereich ermittelt.
     H*  Änderung: ZG 14.02.2024 DOMETIC E_MAIL IK Lagerbereich 004 aus nicht INhaus-Lager
     H*  Änderung: GS 08.11.2024 E-Mail IK, siehe ERVGBS-Routine (Aufruf aus TRAB04 bei TETEST
     H*            mit Status 80), Verwendung eines speziellen Lagerbereichs. Siehe hierzu
     H*            Parameter MODWAO/MOAFPO/TEIL80LGBE Feld WKTRPALGBE
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
     D*
     D WA13          E DS                  INZ
     D KYWA13        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AKPS          E DS                  INZ
     D KYAKPS        E DS                  INZ
     D*
     D ERTE          E DS                  INZ
     D KYERTE        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ
     D*
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOU          E DS                  INZ
     D KYWAOU        E DS                  INZ
     D*
     D WAOX          E DS                  INZ
     D KYWAOX        E DS                  INZ

     D WAOY          E DS                  INZ
     D KYWAOY        E DS                  INZ
     D*
     D WA11          E DS                  INZ
     D KYWA11        E DS                  INZ
     D*
     D WA12          E DS                  INZ
     D KYWA12        E DS                  INZ
     D*
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ

     D EXLBB2        E DS                  INZ
     D RTLBB2        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D PRG             S                   INZ LIKE(APPRGR) DIM(999)
     D PGMG            S                   INZ LIKE(DUN134) DIM(999)
     D KDGR            S                   INZ LIKE(APKDGR) DIM(999)
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

      //*************************************************************************
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKTRPAPLBD      S              1
     D WKTRPADART      S              2
     D WKTRPALGBE      S              3
     D DSLAGB          S             11S 2
     D DSBESN          S             11S 2
     D DSUNTW          S             11S 2
     D DSRESN          S             11S 2

      //*************************************************************************
      //**  Externe Call-Prozeduren                                           ***
      //*************************************************************************
      //--------------------------------------------------
      // Program name: C_TRLBB2
      // Purpose:
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #EXLBB2
      // Parameter:      #RTLBB2
      //--------------------------------------------------
     D C_TRLBB2...
     D                 PR                  EXTPGM('TRLBB2')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #EXLBB2                            LIKEDS(EXLBB2)
     D                                     OPTIONS(*NOPASS)
     D  #RTLBB2                            LIKEDS(RTLBB2)
     D                                     OPTIONS(*NOPASS)

      //--------------------------------------------------
      // Program name: C_WAO00Y
      // Purpose:
      // Returns:
      // Parameter:      #EXTREND
      // Parameter:      #RTTREND
      //--------------------------------------------------
     D C_WAO00Y...
     D                 PR                  EXTPGM('WAO00Y')
     D  #EXTREND                           LIKEDS(EXTREND)
     D  #RTTREND                           LIKEDS(RTTREND)

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
     C     PCPGST        WHENEQ    'ERERTE'
     C                   EXSR      ERERTE
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRSDBP'
     C                   EXSR      PRSDBP
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSKZ'
     C                   EXSR      PRVSKZ
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRGNPA'
     C                   EXSR      PRGNPA
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERPREI'
     C                   EXSR      UXWRTE
     C                   EXSR      UXREAD
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRSTPR'
     C                   EXSR      PRSTPR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAFPR'
     C                   EXSR      PRAFSTPR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRPRAR'
     C                   EXSR      PRPRAR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRFGZT'
     C                   EXSR      PRFGZT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRWAOX'
     C                   EXSR      PRWAOX
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRWAOY'
     C                   EXSR      PRWAOY
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRWA14'
     C                   EXSR      PRWA14
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERWA13'
     C                   EXSR      ERWA13
     C*--------------------------------------------------------
     C* Werk/Artikel-Werk Prüfung
     C     PCPGST        WHENEQ    'PRWA11'
     C                   EXSR      PRWA11
     C*--------------------------------------------------------
     C* Ermitteln verfügbarer Gesamtbestand
     C     PCPGST        WHENEQ    'ERVGBS'
     C                   EXSR      ERVGBS
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
     C                   MOVEL(P)  DAFIRM        KYERTEFIRM                     ERTE
     C                   MOVEL(P)  DAFIRM        KYADFI                         AFAD
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYWA13FIRM                     WA13
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYAKPSFIRM                     AKPS
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM                     TEEW
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAOUFIRM                     WAOU
     C                   MOVEL(P)  DAFIRM        KYWAOXFIRM                     WAOX
     C                   MOVEL(P)  DAFIRM        KYWAOYFIRM                     WAOY
     C                   MOVEL(P)  DAFIRM        KYWA12FIRM                     WA12
     C                   MOVEL(P)  DAFIRM        KYWA11FIRM                     WA11
     C                   MOVEL(P)  DAFIRM        KYSYTPFIRM                     SYTP
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
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C                   MOVEL(P)  EXTRNDDATE    KYERTEERTE
     C                   MOVEL(P)  EXTRNDDATE    KYTENR
     C                   MOVEL(P)  EXTRNDDATE    KYTEEWTENR
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRSDBP'
     C                   MOVEA     KOM(16)       EXTRNDLAND
     C                   MOVEA     KOM(19)       EXTRNDKDNR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSKZ'
     C     PCPGST        OREQ      'ERWA13'
     C                   MOVEA     KOM(16)       EXTRNDAFAT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERPREI'
     C                   MOVEA     KOM(16)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *YEAR         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        EXTRNDAFJJ
     C                   MOVEA     KOM(20)       EXTRNDAFNR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRSTPR'
     C                   MOVEA     KOM(16)       EXTRNDAFAT
     C                   MOVEA     KOM(19)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN113        EXTRNDSTPR
     C                   MOVEA     KOM(30)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN113        EXTRNDEZPR
     C                   MOVEA     KOM(41)       EXTRNDPRGR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRPRAR'
     C                   MOVEA     KOM(16)       EXTRNDAFAT
     C                   MOVEA     KOM(19)       EXTRNDPRAR
     C                   MOVEA     KOM(22)       EXTRNDKDGR
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRWA11'
     C                   MOVEA     KOM(50)       EXTRNDWKNR
     C                   MOVEA     KOM(53)       EXTRNDTEWK
     C*--------------------------------------------------------
     C                   ENDSL
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
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN Artikelnummer                                           ***
     C**************************************************************************
     C     ERERTE        BEGSR
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFEQ      *ZEROS
     C     TETEST        ANDLT     '80'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHERTE
     C     WKFENR        IFEQ      *ZEROS
     C     KYERTEERTE    ANDEQ     ERTEERTE
     C                   MOVEL(P)  ERTETENR      EXTRNDDATE
     C                   ENDIF
     C*
     C                   MOVE      *ZEROS        WKFENR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN  SICHERHEITSDATENBLÄTTER PRO LAND, ARTIKEL                 ***
     C**************************************************************************
     C     PRSDBP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C* SDB-Prüfung für Kunden der Dometic-Gruppe
     C     TEPRGR        IFNE      *BLANK
     C                   EVAL      KYTPTA      = 'WAOSDBPRGR'
     C                   EVAL      KYTPTC      = TEPRGR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL     EXTRNDKDNR    KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C* SDB-Prüfung für Kunden der Dometic-Gruppe
     C     KDEWKSST      IFNE      '1015'
     C                   MOVE      *ZERO         WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     TEEWSDBP      IFEQ      *ON
     C                   MOVEL     TEEWTENR      KYWAOUTENR
     C                   MOVEL     EXTRNDLAND    KYWAOULAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOU
     C
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     '0922'        WKFENR
     C                   MOVEL     EXTRNDLAND    W$PA03
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      WKFENR        RTTRNDFENR
     C                   MOVE      W$PA03        RTTRNDPA03
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AUFTRAGS-ART BEI PFAND-ARTIKELN                            ***
     C**************************************************************************
     C     PRVSKZ        BEGSR
     C*
     C                   LEAVESR
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C     TEVSKZ        IFEQ      DAJNKZ
     C     EXTRNDAFAT    ANDNE     '06'
     C     EXTRNDAFAT    ANDNE     'W06'
     C     EXTRNDAFAT    ANDNE     'C06'
     C     EXTRNDAFAT    ANDNE     'B06'
     C                   MOVE      '9998'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      WKFENR        RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN IDENT-NR (IC-ABWICKLUNG)                                   ***
     C**************************************************************************
     C     PRGNPA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Daten aus KD-Auftragsposition
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAPJH      = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL      KYAPAF      = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      KYAPPO      = %INT(%SUBST(EXTRNDKEYB:11:4))
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C* Lager = "Emsdetten" -> Generieren Bestellung
     C*--------------------------------------------------------
     C                   WHEN      %SUBST(EXTRNDDATE:82:3)=WKTRPALANR
     C                             AND WKTRPALANR <> *BLANK
     C                             AND %SUBST(EXTRNDDATE:85:1)<>DAJNKZ
     C                   EVAL      RTTRNDFENR  = '0031'
     C*--------------------------------------------------------
     C* Lager <> "Emsdetten" -> keine Bestell-Generierung
     C*--------------------------------------------------------
     C                   WHEN      %SUBST(EXTRNDDATE:82:3)<>WKTRPALANR
     C                             AND WKTRPALANR <> *BLANK
     C                             AND %SUBST(EXTRNDDATE:85:1)=DAJNKZ
     C                   EVAL      RTTRNDFENR  = '0031'
     C*--------------------------------------------------------
     C* Bestell-Generierung -> Prüfen, ob Artikel in Emsdetten vorhanden
     C*--------------------------------------------------------
     C                   WHEN      %SUBST(EXTRNDDATE:85:1)=DAJNKZ
     C                             AND WKTRPAFIRM <> *BLANK
     C                   MOVEL     WKTRPAFIRM    KYKPFI
     C                   MOVEL     WKTRPAKDNR    KYKPKD
     C                   MOVEL     KYTENR        KYKPID
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHKPIF
     C                   MOVE      *ZERO         WKFENR
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL     KPTENR        KYTENR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKTRPAFIRM    KYTEFI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C* Die Ident-Nr &3&4 ist bei Mandant &5 nicht vorhanden
     C     WKFENR        IFNE      *ZERO
     C     TETEST        ORGE      '90'
     C                   EVAL      RTTRNDFENR  = '0830'
     C                   EVAL      RTTRNDPA03  = %SUBST(EXTRNDDATE:01:10)
     C                   EVAL      RTTRNDPA04  = %SUBST(EXTRNDDATE:11:05)
     C                   EVAL      RTTRNDPA05  = WKTRPAFIRM
     C                   ENDIF
     C* Identart ist für diese Auftragsart nicht zugelassen
     C     TETART        IFEQ      'P'
     C**GS               EVAL      RTTRNDFENR  = '3045'
     C                   ENDIF
     C*--------------------------------------------------------
     C* Keine Generierung zulässig wenn bereits in Kommissionierung
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      RTTRNDFENR <> *ZERO
     C* Fehler: Programm verlassen
     C                   WHEN      %SUBST(EXTRNDDATE:85:1) <> DAJNKZ
     C* keine Bestellgenerierung: Programm verlassen
     C                   WHEN      %SUBST(EXTRNDDATE:85:1) = APGNPA
     C* keine Neuanlage bzw. Änderung: Programm verlassen
     C                   OTHER
     C                   EVAL      KYAPJH      = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL      KYAPAF      = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      KYAPPO      = *LOVAL
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C*
     C     CHI(5)        DOWEQ     'J'
     C     APFIRM        ANDEQ     KYAPFI
     C     APAFJJ        ANDEQ     KYAPJH
     C     APAFNR        ANDEQ     KYAPAF
     C* Auftrag bereits kommissioniert. Keine Neuanlage möglich.
     C     APAFST        IFEQ      '20'
     C     APGNPA        ANDEQ     DAJNKZ
     C                   EVAL      RTTRNDFENR  = '0560'
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   ENDDO
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXWRTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        PRG
     C                   MOVEA     *ZERO         PGMG
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDAFJJ    KYAKJH
     C                   MOVEL     EXTRNDAFNR    KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   MOVEL     AKAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAPMKZ        IFEQ      '-'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDAFJJ    KYAPJH
     C                   MOVEL     EXTRNDAFNR    KYAPAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     APFIRM        ANDEQ     KYAPFI
     C     APAFJJ        ANDEQ     KYAPJH
     C     APAFNR        ANDEQ     KYAPAF
     C*
     C                   MOVEL     APTENR        KYTUTE
     C                   MOVEL     APMEIN        KYTUME
     C                   Z-ADD     APBSMG        WKV1V2
     C                   Z-ADD     AKAFDA        WKTUEGDATE
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV1V2        DUN134
     C*
     C                   Z-ADD     1             I2
     C     APPRGR        LOOKUP    PRG(I2)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     1             I2
     C     *BLANK        LOOKUP    PRG(I2)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL     APPRGR        PRG(I2)
     C                   ADD       DUN134        PGMG(I2)
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDAFJJ    KYAPJH
     C                   MOVEL     EXTRNDAFNR    KYAPAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     APFIRM        ANDEQ     KYAPFI
     C     APAFJJ        ANDEQ     KYAPJH
     C     APAFNR        ANDEQ     KYAPAF
     C* SC
     C                   EVAL      KYAPJH =  APAFJJ
     C                   EVAL      KYAPAF =  APAFNR
     C                   EVAL      KYAPPO =  APAFPO
     C* SC
     C                   Z-ADD     1             I2
     C     APPRGR        LOOKUP    PRG(I2)                                99
     C*
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     APAFJJ        DUN040
     C                   MOVEA(P)  DUC004        KOM(1)
     C                   MOVEA     APAFNR        KOM(5)
     C                   Z-ADD     APAFPO        DUN040
     C                   MOVEA     DUC004        KOM(86)
     C                   MOVE      *ZERO         DUN030
     C                   MOVEA     DUC003        KOM(11)
     C                   MOVEA     *BLANK        KOM(121)
     C                   MOVEA     *BLANK        KOM(124)
     C*
     C                   Z-ADD     PGMG(I2)      DUN112
     C                   MOVEA     DUC011        KOM(150)
     C*
     C                   Z-ADD     *ZERO         DUN112
     C                   MOVEA     DUC011        KOM(185)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     'UPPREI'      #CPGST
     C                   CALL      'TRAB04'
     C                   PARM                    EXTR02
     C                   ENDIF
     C* SC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C* SC
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     PRAFSTPR      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAPJH = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL      KYAPAF = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      KYAPPO = *LOVAL
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     APFIRM        ANDEQ     KYAPFI
     C     APAFJJ        ANDEQ     KYAPJH
     C     APAFNR        ANDEQ     KYAPAF
     C*
     C                   EVAL      EXTRNDAFAT = APAFAT
     C                   EVAL      EXTRNDPRGR = APPRGR
     C*
     C                   EVAL      KYTENR     = APTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   Z-ADD     TESTPR        EXTRNDSTPR
     C                   IF        TEINPR <> *ZERO
     C                   EVAL      EXTRNDSTPR = TEINPR
     C                   ENDIF
     C*
     C     APNESU        DIV(H)    APBSMG        EXTRNDEZPR
     C*
     C                   EXSR      PRSTPR
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   MOVEL     *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN STANDARD-PREIS                                             ***
     C**************************************************************************
     C     PRSTPR        BEGSR
     C*
     C                   MOVE      *ZERO         RTTRNDFENR
     C                   MOVEL     *BLANK        RTTRNDAFST
     C*-------------------------------------------------------------------------
     C     WKTRPASTPR    IFEQ      *OFF
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAKJH = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL      KYAKAF = %SUBST(EXTRNDKEYB:5:6)
     C*
     C                   IF        KYAKJH = AKAFJJ
     C                             AND KYAKAF = AKAFNR
     C                             AND WKAKPS = *ON
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         RTTRNDFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAKJH = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL      KYAKAF = %SUBST(EXTRNDKEYB:5:6)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAKPSAFJJ = AKAFJJ
     C                   EVAL      KYAKPSAFNR = AKAFNR
     C                   EVAL      KYAKPSAFST = '95'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAKPS
     C*
     C                   IF        WKFENR = *ZERO
     C                   EVAL      WKAKPS = *ON
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         RTTRNDFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12AFAT = EXTRNDAFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12KDNR = AKKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12PRGR = EXTRNDPRGR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12TENR = KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12KDNR = AKKDNR
     C                   EVAL      KYWA12PRGR = EXTRNDPRGR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   CLEAR                   KYWA12
     C                   EVAL      KYWA12FIRM = DAFIRM
     C                   EVAL      KYWA12KDNR = AKKDNR
     C                   EVAL      KYWA12TENR = KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA12
     C                   IF        CHI(5) = 'J'
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   IF        PCPGST = 'PRSTPR'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   IF        TEINPR <> *ZERO
     C                   EVAL      EXTRNDSTPR = TEINPR
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKFENR = *ZERO
     C*-------------------------------------------------------------------------
     C     EXTRNDSTPR    IFGT      EXTRNDEZPR
     C                   IF        EXTRNDSTPR = TEINPR
     C                             AND TEINPR <> *ZERO
                                   // VK-Preis unterschreitet Inventur-Preis
     C                   EVAL      WKFENR = '1885'
     C                   ELSE
                                   // VK-Preis unterschreitet Standard-Preis
     C                   MOVEL     '0978'        WKFENR
     C                   ENDIF
     C                   MOVEL     '95'          RTTRNDAFST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      WKFENR        RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREIS-ART                                                  ***
     C**************************************************************************
     C     PRPRAR        BEGSR
     C*
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C     WKTRPAPRAR    IFEQ      *OFF
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDAFAT    IFNE      '08'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I2
     C     EXTRNDKDGR    LOOKUP    KDGR(I2)                               99
     C*
     C     *IN(99)       IFEQ      *OFF
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDPRAR    IFEQ      'PKG'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '3094'        WKFENR
     C                   MOVE      WKFENR        RTTRNDFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen, ob für der F-Gas-Verordnung unterliegende Artikel der     ***
     C***  Kunde ein entsprechendes Zertifikat vorgelegt hat                 ***
     C**************************************************************************
     C     PRFGZT        BEGSR
     C*
     C                   EVAL      RTTRNDFENR = *ZERO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C                   EVAL      WKFENR = *ZERO
     C                   IF        TEEWFGVE <> '1'                              Kein der F-Gas-
     C                   LEAVESR                                                Verordnung unter-
     C                   ENDIF                                                  legender Artikel
     C*
     C                   EVAL       KYAKJH = %INT(%SUBST(EXTRNDKEYB:1:4))
     C                   EVAL       KYAKAF = %SUBST(EXTRNDKEYB:5:6)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C                   EVAL      WKFENR = *ZERO
     C*
     C                   EVAL      KYKDEWKDNR = AKKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   EVAL      WKFENR = *ZERO
     C                   IF        KDEWFGZT <> '1'                              Kunde ist nicht
     C                   EVAL      WKFENR = '1647'                              F-Gas berechtigt
     C                   ENDIF
     C*
     C                   EVAL      RTTRNDFENR = WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen, ob das Land, in das der Auftrag versendet werden soll,    ***
     C***  durch die Hinterlegung in der Datei WAOX von der Lieferung mit in ***
     C***  TEEW als "Gefahrgut" gekennzeichneten Artikeln ausgeschlossen ist ***
     C**************************************************************************
     C     PRWAOX        BEGSR
     C*
     C                   EVAL      RTTRNDFENR = *ZERO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C                   EVAL      WKFENR = *ZERO
     C                   IF        TEEWGFHR <> '1'                              Kein Gefahrgut
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      KYADJH = %INT(%SUBST(EXTRNDKEYB:1:4))        ERMITTELN
     C                   EVAL      KYADAF = %SUBST(EXTRNDKEYB:5:6)              VERSANDLAND
     C                   EVAL      KYADPO = *ZERO
     C                   EVAL      KYADAA = 'ADVS'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C                   IF        CHI(5) = 'N'
     C                   EVAL      KYADAA = 'ADAG'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C                   EVAL      WKFENR = *ZERO
     C                   IF        CHI(5) = 'N'
     C                             OR ADLAND = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      KYWAOXTENR = TEEWTENR
     C                   EVAL      KYWAOXLAND = ADLAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOX
     C                   EVAL      WKFENR = *ZERO
     C                   IF        CHI(5) = 'J'                                 Gefahrgut-Artikel,
     C                   EVAL      WKFENR = '1648'                              kein Versand in
     C                   ENDIF                                                  das Land
     C*
     C                   EVAL      RTTRNDFENR = WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen, ob das Land, in das der Auftrag versendet werden soll,    ***
     C***  durch die Hinterlegung in der Datei WAOY von der Lieferung mit    ***
     C***  dem Artikel ausgeschlossen ist bzw. ob der Artikel für den Versand***
     C***  in dieses Land zugelassen ist                                     ***
     C**************************************************************************
     C     PRWAOY        BEGSR

     C                   EVAL      RTTRNDFENR = *ZERO
     C                   EVAL      WKEINSCHL = *OFF

     C                   EVAL      KYADJH = %INT(%SUBST(EXTRNDKEYB:1:4))        ERMITTELN
     C                   EVAL      KYADAF = %SUBST(EXTRNDKEYB:5:6)              VERSANDLAND
     C                   EVAL      KYADPO = *ZERO
     C                   EVAL      KYADAA = 'ADVS'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C                   IF        CHI(5) = 'N'
     C                   EVAL      KYADAA = 'ADAG'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C                   EVAL      WKFENR = *ZERO
     C                   IF        CHI(5) = 'N'
     C                             OR ADLAND = *BLANK
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      KYWAOYLAND = ADLAND
     C                   CLEAR                   KYWAOYTENR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAOY
     C                   EVAL      WKFENR = *ZERO
     C                   DOW       CHI(5) = 'J'
     C                             AND WAOYFIRM = KYWAOYFIRM
     C                             AND WAOYLAND = KYWAOYLAND

                         // Der gerade gelesene über WAOY zugeordnete Artikel
                         // ist gleich dem übergebenen Artikel
     C                   IF        WAOYTENR = KYTENR

                         // Ausschluss
     C                   IF        WAOYEASC = '2'
                         // Der Artikel ist vom Versand in das Land ausgeschlossen
     C                   EVAL      RTTRNDFENR = '0357'
     C                   EVAL      RTTRNDDATE = '#MO'                           Nachrichten-Art
     C                   ELSE
                         // Der übergebene Artikel ist dem Land als "Einschluss"
                         // zugeordnet. d. h. für die Lieferung in das Land zugelassen
     C                   ENDIF

                         // Eine Zuordnung des übergebenen Artikels dem Zieland (Einschluss oder
                         // Ausschluss) wurde gefunden, daher keine weitere Prüfung erforderlich
     C                   LEAVESR
     C                   ENDIF

                         // Ein ANDERER Artikel als der übergebene ist dem
                         // Versand-Zielland als "EINSCHLUSS" zugeordnet
     C                   IF        WAOYEASC = '1'
     C                   EVAL      WKEINSCHL = *ON
     C                   ENDIF

     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAOY
     C                   EVAL      WKFENR = *ZERO
     C                   ENDDO

     C                   IF        WKEINSCHL = *ON
                         // Der Artikel ist für den Versand in das Land nicht zugelassen
                         // (gemeint ist der übergebene Artikel), da dieser dem Zielland
                         // nicht zugeordnet ist und es mindestens einen anderen Artikel gibt,
                         // der dem Zielland als Einschluss zugeordnet ist.
     C                   EVAL      RTTRNDFENR = '0358'
     C                   EVAL      RTTRNDDATE = '#MO'                           Nachrichten-Art
     C                   LEAVESR
     C                   ENDIF

                         // Dem Versand-Zielland ist weder der übergebene Artikel als "Ausschluss"
                         // zugeordnet noch ein anderer Artikel als "Einschluss".
                         // Es wird nun geprüft, ob der übergebene Artikel über eine Hinterlegung in
                         // der WAOY einem ANDEREN Land als das Versand-Zielland als "EINSCHLUSS"
                         // zugeordnet. Ist dies der Fall, ist der übergebene Artikel für den
                         // Versand in das Versand-Zielland (AFAD.ADLAND) NICHT zugelassen.
     C                   EVAL      KYWAOYTENR = KYTENR
     C                   CLEAR                   KYWAOYLAND
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHWAOY
     C                   EVAL      WKFENR = *ZERO
     C                   DOW       CHI(5) = 'J'
     C                             AND WAOYFIRM = KYWAOYFIRM
     C                             AND WAOYTENR = KYWAOYTENR

                         // Das gerade gelesene über WAOY dem pbergebenen Artikel zugeordnete Land
                         // ist ein ANDERES als das Ziel-Versandland (AFAD.ADLAND)
     C                   IF        WAOYLAND <> ADLAND

                         // Einschluss
     C                   IF        WAOYEASC = '1'
                         // Der Artikel ist für den Versand in das Land nicht zugelassen
     C                   EVAL      RTTRNDFENR = '0358'
     C                   EVAL      RTTRNDDATE = '#MO'                           Nachrichten-Art
                         // Der übergebenene Artikel ist also zumindest einem anderen Land
                         // als "Einschluss" zugeordnet. Dies schleißt dessen Versand in das
                         // ihm nicht zugeordnete Versand-Zielland aus, daher keine weitere
                         // Prüfung erforderlich
     C                   LEAVESR
     C                   ENDIF

     C                   ENDIF

     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHWAOY
     C                   EVAL      WKFENR = *ZERO
     C                   ENDDO

     C                   ENDSR
     C**************************************************************************
     C***  Prüfen, ob für das Auftragswerk (AKWKNR) die Werk-Nr im Artikel-  ***
     C***  vorhanden ist. Ansonsten Fehlermeldung.                           ***
     C**************************************************************************
     C     PRWA11        BEGSR
     C*
     C                   EVAL      RTTRNDFENR = *ZERO
     C                   EVAL      KYWA11WKNR = EXTRNDWKNR
     C                   EVAL      KYWA11TEWK = *LOVAL
     C*-------------------------------------------------------------------------
     C* Prüfen ob überhaupt ein Satz für das AKWKNR vorhanden ist.
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWA11
     C                   IF        CHI(5) = 'N'
     C                             OR WA11FIRM <> KYWA11FIRM
     C                             OR WA11WKNR <> KYWA11WKNR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Prüfen ob ein passender Satz für das AKWKNR/TEWKNR vorhanden ist.
     C                   EVAL      KYWA11WKNR = EXTRNDWKNR
     C                   EVAL      KYWA11TEWK = EXTRNDTEWK
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA11
     C                   IF        CHI(5) = 'N'
     C                   EVAL      WKFENR = '1207'
     C                   EVAL      RTTRNDFENR = WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C** Die Artikel welche in der Datei WA14 hinterlegt sind, werden bei     **
     C** der Auftragsverwaltung auf Status 17 gesetzt "manueller Reservierung"**
     C**************************************************************************
     C     PRWA14        BEGSR
     C*
     C                   CLEAR                   EXTREND
     C                   EVAL      EXTRNDKEYB  = KYTENR
     C                   EVAL      EXTRNDPGST  = 'PRWA14'
     C                   CALL      'TRWA14'                             99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN WA13                                                    ***
     C**************************************************************************
     C     ERWA13        BEGSR
     C*
     C                   EVAL      RTTRNDFENR = *ZERO
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDAFAT    KYWA13AFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWA13
     C                   EVAL      RTTRNDDATE = WA13
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
       //*************************************************************************
       //**  Ermitteln verfügbarer Gesamtbestand                               ***
       //*************************************************************************
       BEGSR ERVGBS;

         DSLAGB = *ZERO;                                                        // LAGERBESTAND

         DSRESN = *ZERO;                                                        // BEDARF

         DSBESN = *ZERO;                                                        // BESTELLBESTAND

         CLEAR EXLBB2;
         CLEAR RTLBB2;
         KOM = *BLANK;
         IF %SUBST(EXTRNDDATE:86:3) = '004';
         KOM(1) = *OFF;                                                         // PRÜFUNG-KZ
         ELSE;
         KOM(1) = *ON;                                                          // PRÜFUNG-KZ
         ENDIF;
         KOM(2) = *ON;                                                          // ERM.LAGERBESTAND
         IF WKTRPADART = '02' OR WKTRPADART = '03';
           KOM(3) = *ON;                                                        // ERM.LAGERRESERV.
         ELSE;
           KOM(3) = *OFF;
         ENDIF;

         KOM(4) = *ON;                                                          // ERM.DIST RESERV.
         KOM(5) = *OFF;                                                         // BEDARFSPLAN-LAGER
         %SUBST(KOMDS:6) = *BLANK;
         KOM(7) = *ON;                                                          // LAGERPLATZSPERRUN
         KOM(9) = *OFF;                                                         // NUR ABFÜLLBESTAND
         %SUBST(KOMDS:10:15) = KYTENR;
         IF %SUBST(EXTRNDDATE:86:3) = *BLANK;
         %SUBST(KOMDS:25:3) = %SUBST(EXTRNDDATE:82:3);
         ELSE;
         %SUBST(KOMDS:99:3) = %SUBST(EXTRNDDATE:86:3);
         // Lagerbereich für "Status 80" - Prüfung
         %SUBST(KOMDS:99:3) = WKTRPALGBE;
         ENDIF;
         KOM(215) = *ON;                                                        // QUALITÄTSTYP PRÜF
         #CKOMM = KOMDS;
         #CPGST = *BLANK;

         EXLBB2VPKZ = 'V';

         C_TRLBB2(EXTR02:EXLBB2:RTLBB2);
         KOMDS  = #CKOMM;

         DUC013 = %SUBST(KOMDS:01);
         DSLAGB = DUN134;

         DUC013 = %SUBST(KOMDS:40);
         DSRESN = DUN134;

         IF WKTRPAPLBD = *ON;
           //DSRESN += RTLBB2RESP;
           DUC007 = %SUBST(KOMDS:213:007);
           MONITOR;
             *IN(97) = *ON;
             DUN071 *= 1;
           ON-ERROR *PROGRAM;
             *IN(97) = *OFF;
             EXSR RMVMONMSG;
           ENDMON;
           IF *IN97 <> *ON;
             DUC007 = *ZERO;
           ENDIF;

           DSRESN += DUN071;
         ENDIF;

         DUC013 = %SUBST(KOMDS:66);
         DSBESN = DUN134;

         EXSR WAO00Y;

         CLEAR RTTREND;
         RTTRNDFENR = *ZERO;
         // Verfügbarer Gesamtbestand
         DUN112 = (DSLAGB + DSBESN + DSUNTW) - DSRESN;
         %SUBST(RTTRNDDATE:01:11) = DUC011;

       ENDSR;

       //*************************************************************************
       //**  WAO00Y   WAECO                                                    ***
       //*************************************************************************
       BEGSR WAO00Y;

         WKFENR = *ZERO;
         DSUNTW = *ZERO;

         CLEAR EXTREND;
         CLEAR RTTREND;
         %SUBST(EXTRNDKEYB:01) = KYTENR;
         %SUBST(EXTRNDKEYB:16) = 'V';
         C_WAO00Y(EXTREND:RTTREND);

         // Ware Unterwegs
         DUC013 = %SUBST(RTTRNDDATE:016:013);
         MONITOR;
           *IN(97) = *ON;
           DUN134 *= 1;
         ON-ERROR *PROGRAM;
           *IN(97) = *OFF;
           EXSR RMVMONMSG;
         ENDMON;
         IF *IN97 <> *ON;
           DUC013 = *ZERO;
         ENDIF;
         EVAL(H) DSUNTW = DUN134;

       ENDSR;

      /END-FREE
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C* Ermitteln Lieferanten-Nr für Bestell-Generierung
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'TRAB06'      KYTATC
     C                   MOVEL(P)  'LFNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALFNR
     C*-------------------------------------------------------------------------
     C* Ermitteln Kunden-Nr für Streckengeschäft
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'LFNRKD'      KYTATC
     C                   MOVEL(P)  WKTRPALFNR    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   EVAL      WKTRPAKDNR  = %SUBST(TAPTXT:01:10)
     C                   EVAL      WKTRPAFIRM  = %SUBST(TAPTXT:14:02)
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO00X'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'LANR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALANR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'TESTPR'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASTPR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'APPRAR'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAPRAR
      /FREE
       KYTATA = 'TRLBB2';                                                       // ERMITTELN
       KYTATC = 'DIST';                                                         // DIST-BEDARF EINSC
       KYTAPA = 'PLBD';                                                         // PLAN-BEDARF
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPAPLBD = TAPCDE;
       IF WKTRPAPLBD <> *ON;
         WKTRPAPLBD = *OFF;
       ENDIF;

       KYTATA = 'FIRM';                                                         // ERMITTELN
       KYTATC = 'DIST';                                                         // DISPOART
       KYTAPA = 'DART';
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPADART = TAPCDE;

       KYTATA = 'MODWAO';
       KYTATC = 'MOAFPO';
       KYTAPA = 'TEIL80LGBE';
       CHIDS = '01C';
       EXSR CHTRPA;
       WKTRPALGBE = TAPCDE;
      /END-FREE
     C*-------------------------------------------------------------------------
     C                   EXSR      ERKDGR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERKDGR     ERMITTELN KUNDEGRUPPE                               ***
     C**************************************************************************
     C     ERKDGR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I2
     C                   MOVE      *BLANK        KDGR
     C*-------------------------------------------------------------------------
     C                   MOVEL     '$$WAOKDGR'   KYSYTPTART
     C                   MOVEL     *BLANK        KYSYTPTCDE
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHSYTP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     SYTPFIRM      IFNE      KYSYTPFIRM
     C     SYTPTART      ORNE      KYSYTPTART
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I2            IFLT      999
     C                   ADD       1             I2
     C                   MOVEL     SYTPTCDE      KDGR(I2)
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHSYTP
     C*-------------------------------------------------------------------------
     C                   ENDDO
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
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C*
     C     *LIKE         DEFINE    WKC001        WKEINSCHL
     C     *LIKE         DEFINE    WKC001        WKTRPASTPR
     C     *LIKE         DEFINE    WKC001        WKTRPAPRAR
     C     *LIKE         DEFINE    WKC001        WKTRPALANR      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPALFNR      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAKDNR      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAFIRM      + 1
     C     *LIKE         DEFINE    WKC001        WKTRPAAPKM      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAAPTE      + 9
     C     *LIKE         DEFINE    WKC001        EXTRNDAFAT      + 2
     C     *LIKE         DEFINE    WKC001        EXTRNDLAND      + 2
     C     *LIKE         DEFINE    WKC001        EXTRNDPRAR      + 2
     C     *LIKE         DEFINE    WKC001        EXTRNDKDGR      + 3
     C     *LIKE         DEFINE    WKC001        EXTRNDWKNR      + 2
     C     *LIKE         DEFINE    WKC001        EXTRNDTEWK      + 2
     C     *LIKE         DEFINE    APPRGR        EXTRNDPRGR
     C     *LIKE         DEFINE    APKDNR        EXTRNDKDNR
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
     C     *LIKE         DEFINE    DUC002        RTTRNDAFST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKAFJJ        EXTRNDAFJJ
     C     *LIKE         DEFINE    AKAFNR        EXTRNDAFNR
     C     *LIKE         DEFINE    DUN113        EXTRNDSTPR
     C     *LIKE         DEFINE    DUN113        EXTRNDEZPR
     C     *LIKE         DEFINE    WKC001        WKAKPS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHERTE
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAKPS
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKPIF
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHWAOU
     C/COPY QCPYSRC,CHWAOX
     C/COPY QCPYSRC,CHWAOY
     C/COPY QCPYSRC,CHWA11
     C/COPY QCPYSRC,CHWA12
     C/COPY QCPYSRC,CHWA13
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,VRMVMONMSG
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
