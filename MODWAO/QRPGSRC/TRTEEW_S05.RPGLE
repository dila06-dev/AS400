     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Datei TEEW
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 16.11.2010 für Kunde Waeco Besuch
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 10.12.2010 Projekt 6864 für Kunde DOMETIC (WAECO). Prüfung und F4-Zugriff
     H*            im Feld DSTEEWPRGR (PEGR/Dometic) auf die Tabelle $$TEEWPRGR integriert.
     H*  Änderung: GS 30.03.2011 Mail von Herrn Schneider, Feld TEEWSKUN die Prüfung aus dem
     H*            Programm entfernt da nur noch ein Ausgabefeld.
     H*  Änderung: PH 13.07.2011 Projekt 7513. Neue Felder "Vorlauf-Zeit" und "Vorlauf-Art"
     H*            (für QS-pflichtige Ident-Nr)
     H*  Änderung: MG 23.11.2012 PROJEKT 9021 - "Konzernschlüßel" für die
     H*            Felder "Kz-Lieferant"/ "Kz-Hersteller" TEEWKZLF, TEEWKZHS
     H*            sowie 5 Felder "Verkaufsgruppe 1-5"  TEEWVKG1-TEEWVKG5
     H*  Änderung: RE 13.09.2013 Projekt 9687 Neues Feld "Verwiterungsbetrag"
     H*  Änderung: MG 14.01.2014 Projekt 9787 Neues Feld "SDB Pflicht"
     H*  Änderung: MG 05.05.2014 Projekt 9969 Mandantübergreifende Kopierfunktion
     H*  Änderung: MG 12.05.2014 Projekt 9969 Übernahme Produktgruppe aus dem
     H*            Ident-Stamm bei Mandant Belgien/NL
     H*  Änderung: MG 12.06.2015 Projekt 10804 Neue Felder TEEWPRMG
     H*            "Produktmanager", TEEWKATL "Katalogartikel", TEEWOEAT
     H*            "OE-Artikel", TEEWEXSV "Exklusiv-Artikel", TEEWVRVM
     H*            "Vorratsvermögen", TEEWTART "Artikel-Art", TEEWIDCO
     H*            "IDCO-Materialgruppe"
     H*  Änderung: PH 13.08.2015 Projekt 11567. Neue Felder TEEWFGVE
     H*            "F-Gas Verordnung" und TEEWGFHR "Gefahrgut"
     H*  Änderung: MG 04.12.2015 DOMETIC Projekt 11579 Erweiterung der
     H*            Kopierfunktion des Artikelstamms von Niederlande nach Belgien
     H*  Änderung: ZG 08.11.2017 Telefonat mit Frau Klein -Feld TEEWSKUN als I/O
     A*  Änderung: PH 09.07.2018 Projekt 14116-01. Neue Felder TEEWPLTE
     A*            "Plan-Artikel" (15A) und TEEWTEAK "Artikel-Aktuell" (1/0)
     H*  Änderung: PH 12.08.2018 Projekt 14116-01. In Rücksprache mit IK
     H*            wurde das Feld "Plan-Artikel" aus der Datei wieder entfernt
     A*  Änderung: JK 15.04.2019 DOMETIC PJ 14874 Neues Feld Production Area
     A*            Code
     H*  Änderung: PH 24.03.2021 Projekt 16425-01. Neues Feld TEEWPACO "Lagercode"
     H*  Änderung: GS 27.01.2022 Projekt 16278-01. Neues Feld TEEWARKL "Artikelklasse"
     H*  Änderung: PH 10.02.2022 Projekt 17051-01. Neues Feld TEEWITTY "Item-Type"
     H*  Änderung: PH 11.11.2022 Projekt 220527-01. Das Feld TEEWIDCO "IDCO" von 4 auf
     H*            5 Stellen erweitert und hinten eingefügt. Das alte TEEWIDCO  in
     H*            TEEWFR01 (4A, Freifeld) umbenannt.
     H*  Änderung: PH 16.08.2024 Case #03813767. Neue Felder TEEWRFTY "Refrigerant type" (5A),
     H*            TEEWRFQT "Refrigerant qty" (3,0) und TEEWGWPN "GWP" (4.0). Im Format TRTEEW01
     H*            werden diese Felder nur angezeigt (reine Ausgabe-Felder DSTEEWRFTY, DSTEEWRFQT
     H*            und DSTEEWGWPN). Aufruf eines neuen Formats TRTEEW02 zum Verwalten dieser Felder
     H*            (Ein-/Ausgabe-Felder DSTEE1RFTY, DSTEE1RFQT und DSTEE1GWPN) über eine Option.
     H*  Änderung: PH 09.09.2024 Case #03841288. Die Größe des Formats TRTEEW01 von 24x80 auf 27x132
     H*            umgestellt. Neue Felder TEEWEOPR "End of Pro" ("End of Production"), TEEWEOSP
     H*            "End of SP" ("End of Spare Part").
     A*  Änderung: PH 23.09.2024 Case #03841288. Neues separates Feld TEEWPCGR "Product Group" (4A).
     H*  Änderung: PH 04.02.2025 Case #04109201. Das Feld DSTEEWFGVE "F-Gas Verordnun" ist jetzt im
     H*            Format TRTEEW01 auch ein rein Ausgabe-Feld. Das Feld TEEWFGVE "F-Gas Verordnun"
     H*            kann nun nur noch im Format TRTEEW02 verwaltet werden (Ein-/Ausgabe-Feld
     H*            DSTEE1FGVE).
     H*  Änderung: PH 11.03.2025 Case #04143218. Das bisherige Feld TEEWGWPN "GWP" (4,0) als (7,3)
     H*            umdefiniert. Neues Feld TEEWTOTO "TCE" ("Total Tonnes CO2-eq") (11,3) als reines
     H*            Ausgabe-Feld DSTEEWTOTO in das Format TRTEEW01 aufgenommen. DSTEEWTOTO wird wie
     H*            folgt berechnet: DSTEEWTOTO = DSTEEWGWPN * (1 * DSTEEWRFQT / 1000) / 1000.
     A*  Änderung: PH 20.05.2025 Case #04303134. Neues Feld TEEWALPN "Altern.-Produkt" (15A)
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei TEEW.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRTEEWFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D FIR             S                   LIKE(DAFIRM) DIM(20)                 UPDATE ANDERE FIRMEN
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D WKTEEW        E DS                  EXTNAME(TEEW) PREFIX(WK)
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ
     D*
     D SYTK          E DS                  INZ
     D KYSYTK        E DS                  INZ
     D*
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D                 DS                  INZ
     D  DSTEEWVKGR                   10
     D   DSTEEWVKG1                        OVERLAY(DSTEEWVKGR:*NEXT)
     D   DSTEEWVKG2                        OVERLAY(DSTEEWVKGR:*NEXT)
     D   DSTEEWVKG3                        OVERLAY(DSTEEWVKGR:*NEXT)
     D   DSTEEWVKG4                        OVERLAY(DSTEEWVKGR:*NEXT)
     D   DSTEEWVKG5                        OVERLAY(DSTEEWVKGR:*NEXT)
     D*
     D                 DS                  INZ
     D  EXTEEWKEYB                  256
     D   EXTEEWTENR                        OVERLAY(EXTEEWKEYB:*NEXT)
     D                                     LIKE(TEEWTENR)
     D  EXTEEWPRKZ                  256
     D   EXTEEWIFKZ                   1    OVERLAY(EXTEEWPRKZ:*NEXT)
     D*
     D                 DS                  INZ
     D  EXTEEWNKEY                  256
     D   EXTEEWNTEN                        OVERLAY(EXTEEWNKEY:*NEXT)
     D                                     LIKE(TEEWTENR)
     D*
     D                 DS                  INZ
     D  EXTEEWDATE                 1024
     D   EXTEEWSKUN                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWSKUN)
     D   EXTEEWPNCN                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPNCN)
     D   EXTEEWPRGR                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPRGR)
     D   EXTEEWERUS                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWERUS)
     D   EXTEEWLVZT                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWLVZT)
     D   EXTEEWLVZA                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWLVZA)
     D   EXTEEWKZLF                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKZLF)
     D   EXTEEWKZHS                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKZHS)
     D   EXTEEWVKG1                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG1)
     D   EXTEEWVKG2                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG2)
     D   EXTEEWVKG3                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG3)
     D   EXTEEWVKG4                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG4)
     D   EXTEEWVKG5                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG5)
     D   EXTEEWVWIT                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVWIT)
     D   EXTEEWSDBP                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWSDBP)
     D   EXTEEWPRMG                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPRMG)
     D   EXTEEWKATL                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKATL)
     D   EXTEEWOEAT                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWOEAT)
     D   EXTEEWEXSV                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEXSV)
     D   EXTEEWVRVM                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVRVM)
     D   EXTEEWTART                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTART)
     D   EXTEEWGWPN                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWGWPN)
     D   EXTEEWFGVE                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWFGVE)
     D   EXTEEWGFHR                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWGFHR)
     D   EXTEEWTEAK                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTEAK)
     D   EXTEEWPACD                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPACD)
     D   EXTEEWPACO                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPACO)
     D   EXTEEWARKL                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWARKL)
     D   EXTEEWITTY                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWITTY)
     D   EXTEEWIDCO                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWIDCO)
     D   EXTEEWRFTY                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWRFTY)
     D   EXTEEWRFQT                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWRFQT)
     D   EXTEEWEOPR                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEOPR)
     D   EXTEEWEOSP                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEOSP)
     D   EXTEEWPCGR                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPCGR)
     D   EXTEEWTOTO                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTOTO)
     D   EXTEEWALPN                        OVERLAY(EXTEEWDATE:*NEXT)
     D                                     LIKE(TEEWALPN)
     D*
     D                 DS                  INZ
     D  RTTEEWKEYB                  256
     D   RTTEEWTENR                        OVERLAY(RTTEEWKEYB:*NEXT)
     D                                     LIKE(TEEWTENR)
     D*
     D                 DS                  INZ
     D  RTTEEWDATE                 1024
     D   RTTEEWSKUN                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWSKUN)
     D   RTTEEWPNCN                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPNCN)
     D   RTTEEWPRGR                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPRGR)
     D   RTTEEWERUS                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWERUS)
     D   RTTEEWLVZT                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWLVZT)
     D   RTTEEWLVZA                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWLVZA)
     D   RTTEEWKZLF                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKZLF)
     D   RTTEEWKZHS                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKZHS)
     D   RTTEEWVKG1                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG1)
     D   RTTEEWVKG2                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG2)
     D   RTTEEWVKG3                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG3)
     D   RTTEEWVKG4                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG4)
     D   RTTEEWVKG5                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVKG5)
     D   RTTEEWVWIT                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVWIT)
     D   RTTEEWSDBP                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWSDBP)
     D   RTTEEWPRMG                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPRMG)
     D   RTTEEWKATL                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWKATL)
     D   RTTEEWOEAT                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWOEAT)
     D   RTTEEWEXSV                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEXSV)
     D   RTTEEWVRVM                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWVRVM)
     D   RTTEEWTART                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTART)
     D   RTTEEWGWPN                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWGWPN)
     D   RTTEEWFGVE                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWFGVE)
     D   RTTEEWGFHR                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWGFHR)
     D   RTTEEWTEAK                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTEAK)
     D   RTTEEWPACD                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPACD)
     D   RTTEEWPACO                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPACO)
     D   RTTEEWARKL                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWARKL)
     D   RTTEEWITTY                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWITTY)
     D   RTTEEWIDCO                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWIDCO)
     D   RTTEEWRFTY                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWRFTY)
     D   RTTEEWRFQT                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWRFQT)
     D   RTTEEWEOPR                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEOPR)
     D   RTTEEWEOSP                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWEOSP)
     D   RTTEEWPCGR                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWPCGR)
     D   RTTEEWTOTO                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWTOTO)
     D   RTTEEWALPN                        OVERLAY(RTTEEWDATE:*NEXT)
     D                                     LIKE(TEEWALPN)
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
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
     C     WKFIRM        CASNE     DAFIRM        ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '                                     BILDSCHIRMFORMAT
     C*                                                                         SCHLIESSEN
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRTEEWFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ESICHT'
     C                   EXSR      ESICHT
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'KTEIL '                                     ZUSATZ-DATEN
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     CHI(5)        IFEQ      'J'
     C                   EXSR      KTEEW                                        KOPIEREN
     C                   EXSR      UTEEW
     C                   ENDIF
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PTEEW '
     C                   EXSR      PTEEW
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PTEEW
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LTEEW
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRAUFR'                                     EXTERNE PRÜFUNG
     C                   EXSR      PRAUFR
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     EXTEEWIFKZ    WHENNE    *BLANK                                       EXTERNES
     C                   EXSR      IFTEEW                                       UPDATE
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     DATEST        WHENEQ    '5'
     C                   MOVE      '5     '      PCPGST
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      TRTEEWFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C                   ENDCS
     C     WKIFMT        CASEQ     '02'          BILD02
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     TRTEEWFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        WKFIRM
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
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM                     TEEW
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTKFI                         TRTK
     C                   MOVEL(P)  DASPCD        KYTKSP
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYZTFI                         ZTDI
      /FREE
                         KYSYTPFIRM = DAFIRM;
                         KYSYTKFIRM = DAFIRM;
      /END-FREE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEEWFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRTEEWFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTRND                         ***
     C**************************************************************************
     C     UEBTRND       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C                   MOVEL(P)  EXTRNDPRKZ    EXTEEWPRKZ
     C                   MOVEL(P)  EXTRNDKEYB    EXTEEWKEYB
     C                   MOVEL(P)  EXTRNDNKEY    EXTEEWNKEY
     C*
     C                   MOVEL(P)  EXTEEWTENR    KYTEEWTENR
     C                   MOVEL(P)  EXTEEWTENR    DSTEEWTENR
     C*
     C                   MOVEL(P)  EXTEEWNTEN    DSTEEWNTEN
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
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C*-------------------------------------------------------------------------
     C     DSTEEWTENR    IFNE      *BLANK
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR                     PRÜFEN OB,
     C                   MOVEA     '01C     '    CHI                            BERREITS VORHA
     C                   EXSR      CHTEEW
     C*
     C     WKFENR        IFEQ      *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVEL(P)  '2     '      PCPGST
     C                   ENDIF
     C*
     C     WKFENR        IFNE      *ZERO                                        NEUANLAGE
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      *BLANK        PCPGST
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   ENDIF
     C*
     C                   MOVE      *ON           WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITUNG FÜR FORMATANZEIGE                                    ***
     C**************************************************************************
     C     AUFFOR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  'TEEW'        EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99           DSKOPF
     C*                  MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD01                                              ***
     C**************************************************************************
     C     BILD01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   MOVEL     'TRTEEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   WRITE     TRTEEW01
     C                   WRITE     TRTEEWB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRTEEW01                             9899
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#ACCS        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   MOVEL(P)  'AUFRUF'      WKPGST
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF

     C                   IF        EXTRDNDANA = 'TRTEEW02'
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UTEEW
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHTEEW
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHTEEW
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   TEEW
     C                   EXSR      ETRMU
     C                   EXSR      ETEEW
     C                   MOVEL(P)  KYTEEWTENR    TEEWTENR
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVEL(P)  TEEWUSER      WKUSER
     C                   Z-ADD     TEEWJDAT      WKJDAT
     C                   Z-ADD     TEEWJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHTEEW
     C                   EXSR      ETEEW
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     DAFIRM        IFEQ      '08'
     C     DAFIRM        OREQ      '52'
     C                   MOVEL(P)  EXTRNDDATE    EXTEEWDATE
     C                   MOVEL(P)  EXTEEWPRGR    TEEWPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEEWTENR      DSTEEWTENR
     C                   MOVEL(P)  TEEWSKUN      DSTEEWSKUN
     C                   MOVEL(P)  TEEWPNCN      DSTEEWPNCN
     C                   MOVEL(P)  TEEWPRGR      DSTEEWPRGR
     C                   EVAL      DSTEEWPCGR = TEEWPCGR
     C                   EVAL      DSTEEWALPN = TEEWALPN
     C                   Z-ADD     TEEWLVZT      DSTEEWLVZT
     C                   MOVEL(P)  TEEWLVZA      DSTEEWLVZA
     C                   MOVEL(P)  TEEWKZLF      DSTEEWKZLF
     C                   MOVEL(P)  TEEWKZHS      DSTEEWKZHS
     C                   MOVEL(P)  TEEWVKG1      DSTEEWVKG1
     C                   MOVEL(P)  TEEWVKG2      DSTEEWVKG2
     C                   MOVEL(P)  TEEWVKG3      DSTEEWVKG3
     C                   MOVEL(P)  TEEWVKG4      DSTEEWVKG4
     C                   MOVEL(P)  TEEWVKG5      DSTEEWVKG5
     C                   MOVEL(P)  TEEWVWIT      DSTEEWVWIT
     C                   MOVEL(P)  TEEWSDBP      DSTEEWSDBP
     C                   MOVEL(P)  TEEWPRMG      DSTEEWPRMG
     C                   MOVEL(P)  TEEWKATL      DSTEEWKATL
     C                   MOVEL(P)  TEEWOEAT      DSTEEWOEAT
     C                   MOVEL(P)  TEEWEXSV      DSTEEWEXSV
     C                   MOVEL(P)  TEEWVRVM      DSTEEWVRVM
     C                   MOVEL(P)  TEEWTART      DSTEEWTART
     C                   MOVEL(P)  TEEWIDCO      DSTEEWIDCO
     C                   MOVEL(P)  TEEWFGVE      DSTEEWFGVE
     C                   MOVEL(P)  TEEWGFHR      DSTEEWGFHR
      /FREE
          DSTEEWRFTY = TEEWRFTY;
          DSTEEWRFQT = TEEWRFQT;
          DSTEEWGWPN = TEEWGWPN;
          if TEEWTOTO <> *ZERO;
            DSTEEWTOTO = TEEWTOTO;
          else;
            eval(h) DSTEEWTOTO = DSTEEWGWPN * (1 * DSTEEWRFQT / 1000) / 1000;
          endif;

          CLEAR EXDATE;
          EXDATEDATV = TEEWEOPR;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOPR = RTDATEDATE;

          CLEAR EXDATE;
          EXDATEDATV = TEEWEOSP;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOSP = RTDATEDATE;
      /END-FREE
     C                   MOVEL(P)  TEEWTEAK      DSTEEWTEAK
     C                   MOVEL(P)  TEEWPACD      DSTEEWPACD
     C                   MOVEL(P)  TEEWPACO      DSTEEWPACO
     C                   MOVEL(P)  TEEWARKL      DSTEEWARKL
     C                   MOVEL(P)  TEEWITTY      DSTEEWITTY
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        DSTENRTBZ1                     INITIALISIEREN
     C                   MOVEL     *BLANK        DSTENRTBZ2                     TEXTFELDER
     C                   MOVEL     *BLANK        TXTEEWPRGR
     C                   MOVEL     *BLANK        TXTEEWPCGR
     C                   MOVEL     *BLANK        TXTEEWLVZA
     C                   MOVEL     *BLANK        TXTEEWKZLF
     C                   MOVEL     *BLANK        TXTEEWKZHS
     C                   MOVEL     *BLANK        TXTEEWVKGR
     C                   MOVEL     *BLANK        TXTEEWVWIT
     C                   MOVEL     *BLANK        TXTEEWSDBP
     C                   MOVEL     *BLANK        TXTEEWPRMG
     C                   MOVEL     *BLANK        TXTEEWKATL
     C                   MOVEL     *BLANK        TXTEEWOEAT
     C                   MOVEL     *BLANK        TXTEEWEXSV
     C                   MOVEL     *BLANK        TXTEEWVRVM
     C                   MOVEL     *BLANK        TXTEEWTART
     C                   MOVEL     *BLANK        TXTEEWIDCO
     C                   MOVEL     *BLANK        TXTEEWFGVE
     C                   MOVEL     *BLANK        TXTEEWRFTY
     C                   MOVEL     *BLANK        TXTEEWGFHR
     C                   MOVEL     *BLANK        TXTEEWTEAK
     C                   MOVEL     *BLANK        TXTEEWPACD
     C                   MOVEL     *BLANK        TXTEEWPACO
     C                   MOVEL     *BLANK        TXTEEWARKL
     C                   MOVEL     *BLANK        TXTEEWITTY
     C*-------------------------------------------------------------------------
     C     DSTEEWTENR    CASNE     *BLANK        PRTEEWTENR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSTEEWPRGR    CASNE     *BLANK        PRTEEWPRGR
     C                   ENDCS
     C                   IF        DSTEEWPCGR <> *BLANK
     C                   EXSR      PRTEEWPCGR
     C                   ENDIF
     C     DSTEEWLVZA    CASNE     *BLANK        PRTEEWLVZA
     C                   ENDCS
     C     DSTEEWKZLF    CASNE     *BLANK        PRTEEWKZLF
     C                   ENDCS
     C     DSTEEWKZHS    CASNE     *BLANK        PRTEEWKZHS
     C                   ENDCS
     C     DSTEEWVKGR    CASNE     *BLANK        PRTEEWVKGR
     C                   ENDCS
     C     DSTEEWVWIT    CASNE     *BLANK        PRTEEWVWIT
     C                   ENDCS
     C     DSTEEWSDBP    CASNE     *BLANK        PRTEEWSDBP
     C                   ENDCS
     C     DSTEEWPRMG    CASNE     *BLANK        PRTEEWPRMG
     C                   ENDCS
     C     DSTEEWKATL    CASNE     *BLANK        PRTEEWKATL
     C                   ENDCS
     C     DSTEEWOEAT    CASNE     *BLANK        PRTEEWOEAT
     C                   ENDCS
     C     DSTEEWEXSV    CASNE     *BLANK        PRTEEWEXSV
     C                   ENDCS
     C     DSTEEWVRVM    CASNE     *BLANK        PRTEEWVRVM
     C                   ENDCS
     C     DSTEEWTART    CASNE     *BLANK        PRTEEWTART
     C                   ENDCS
     C     DSTEEWIDCO    CASNE     *BLANK        PRTEEWIDCO
     C                   ENDCS
     C     DSTEEWFGVE    CASNE     *BLANK        PRTEEWFGVE
     C                   ENDCS
     C                   IF        DSTEEWRFTY <> *BLANK
     C                   EXSR      PRTEEWRFTY
     C                   ENDIF
     C     DSTEEWGFHR    CASNE     *BLANK        PRTEEWGFHR
     C                   ENDCS
     C     DSTEEWTEAK    CASNE     *BLANK        PRTEEWTEAK
     C                   ENDCS
     C                   IF        DSTEEWPACD <> *BLANK
     C                   EXSR      PRTEEWPACD
     C                   ENDIF
     C                   IF        DSTEEWPACO <> *BLANK
     C                   EXSR      PRTEEWPACO
     C                   ENDIF
     C                   IF        DSTEEWARKL <> *BLANK
     C                   EXSR      PRTEEWARKL
     C                   ENDIF
     C                   IF        DSTEEWITTY <> *BLANK
     C                   EXSR      PRTEEWITTY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEEW01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   MOVE      *BLANK        EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     PCRTCD        IFEQ      'W'
     C                   MOVE      '0070'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DAFIRM        IFEQ      '08'
     C     DAFIRM        OREQ      '52'
     C                   MOVE      *ON           C#LCK2
     C                   ELSE
     C                   MOVE      *OFF          C#LCK2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSTEEWPNCN'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSTEEWPNCN'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSTEEWTENR'  EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     PCPGST        ANDNE     *BLANK
     C     PCPGST        ANDNE     'MUSTER'
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKJDAT        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   EVAL      W$PA03 = %TRIM(%EDITW(RTDATEDATE :
     C                              '0 .  .    '))
     C                   MOVEL(P)  WKUSER        W$PA04
     C                   EVAL      W$PA05 = %TRIM(%EDITW(WKJZEI : '0 :  :  '))
     C                   MOVE      '0076'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
       //*************************************************************************
       //**  Steuerroutine BILD02                                              ***
       //*************************************************************************
       BEGSR BILD02;

         IF WKIFMT <> FMT(FM);
           EXSR IFMTS;
         ENDIF;

         EXSR B02DS;

         DOW WKIFMT = '02';
           WKFLPORECN = 'TRTEEW02';
           EXSR EFLPO;
           WRITE TRTEEWW1;
           WRITE TRTEEW02;
           WRITE W1TEEWB1;
           EXSR OFFUKT;
           FUKT04 = *ON;
           FUKT12 = *ON;
           FUKT13 = *ON;

           IF WKFENR <> *ZERO;
             EXSR AUMSG;
           ENDIF;

           C#WNDW = *OFF;
           READ(E) TRTEEW02;

           IF %ERROR OR %EOF;
             #CRTCD = 'N';
             DAFEHL = *ON;
             #CPGST = *BLANK;
             WKIFMT = '00';
             LEAVE;
           ENDIF;

           SELECT;

           WHEN C#SELC = *ON AND FUKT04 = *ON;
             EXSR MCAUFR;
             IF WKTRTP = *ON
               OR WKFENR <> *ZERO;
               ITER;
             ENDIF;

           WHEN C#CANC = *ON AND FUKT12 = *ON;
             #CRTCD = 'N';
             #CPGST = *BLANK;
             EXSR RFMTS;
             LEAVE;

           WHEN C#FUKT <> *ZERO;
             WKFENR = '0075';
             ITER;

           ENDSL;

           IF PCPGST <> '5     ' AND PCPGST <> 'F     ';
             IF PCPGST <> 'MUSTER';
               EXSR BILDPR;
               IF WKFENR <> *ZERO;
                 ITER;
               ENDIF;
             ENDIF;

             DSTEEWRFTY = DSTEE1RFTY;
             TXTEEWRFTY = TXTEE1RFTY;
             DSTEEWRFQT = DSTEE1RFQT;
             DSTEEWGWPN = DSTEE1GWPN;
             DSTEEWFGVE = DSTEE1FGVE;
             TXTEEWFGVE = TXTEE1FGVE;

             eval(h) DSTEEWTOTO = DSTEEWGWPN * (1 * DSTEEWRFQT / 1000) / 1000;
           ENDIF;

           EXSR RFMTS;
         ENDDO;

       ENDSR;

       //*************************************************************************
       //**  Füllen Bildschirmformat 02                                        ***
       //*************************************************************************
       BEGSR B02DS;

         C#LCK0 = WKIN30;
         C#LCK1 = WKIN31;

         EXTRDNDANA = 'TRTEEW02';
         EXSR RDTRDNTRDN;
         WNKOPF = EXTRDNTEXT;

         DSTEE1RFTY = DSTEEWRFTY;
         DSTEE1RFQT = DSTEEWRFQT;
         DSTEE1GWPN = DSTEEWGWPN;
         DSTEE1FGVE = DSTEEWFGVE;

         // Initialisieren der Textfelder
         TXTEE1RFTY = *BLANK;
         TXTEE1FGVE = *BLANK;

         // Füllen der Textfelder mit Interpretationen
         IF DSTEE1RFTY <> *BLANK;
           EXSR PRTEE1RFTY;
         ENDIF;

         IF DSTEE1FGVE <> *BLANK;
           EXSR PRTEE1FGVE;
         ENDIF;

         WKFENR = *ZERO;
         W$MSGA = *BLANK;
         EXFLPOFLDN = *BLANK;

         SELECT;
         WHEN PCPGST = '5     ';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         WHEN PCPGST = '2     ';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSTEE1RFTY';

         WHEN PCPGST = 'MUSTER';
           C#LCK1 = *ON;
           EXFLPOFLDN = 'DSTEE1RFTY';

         WHEN PCPGST = 'F     ';
           C#LCK0 = *ON;
           C#LCK1 = *ON;

         OTHER;
           EXFLPOFLDN = 'DSTEE1RFTY';
         ENDSL;

         #CPGST = *BLANK;
         #CRTCD = *BLANK;

       ENDSR;
      /END-FREE
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSTEEWTENR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK2        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSTEEWPRGR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSTEEWTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWTENR'
     C                   EXSR      MCTEEWTENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWPRGR'
     C                   EXSR      MCTEEWPRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWPCGR'
     C                   EXSR      MCTEEWPCGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWLVZA'
     C                   EXSR      MCTEEWLVZA
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWKZLF'
     C                   EXSR      MCTEEWKZLF
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWKZHS'
     C                   EXSR      MCTEEWKZHS
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWVKG1'
     C     FLDNAM        OREQ      'DSTEEWVKG2'
     C     FLDNAM        OREQ      'DSTEEWVKG3'
     C     FLDNAM        OREQ      'DSTEEWVKG4'
     C     FLDNAM        OREQ      'DSTEEWVKG5'
     C                   EXSR      MCTEEWVKGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWVWIT'
     C                   EXSR      MCTEEWVWIT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWSDBP'
     C                   EXSR      MCTEEWSDBP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWEOPR'
     C                   EXSR      MCTEEWEOPR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWEOSP'
     C                   EXSR      MCTEEWEOSP
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWPRMG'
     C                   EXSR      MCTEEWPRMG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWKATL'
     C                   EXSR      MCTEEWKATL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWOEAT'
     C                   EXSR      MCTEEWOEAT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWEXSV'
     C                   EXSR      MCTEEWEXSV
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWVRVM'
     C                   EXSR      MCTEEWVRVM
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWTART'
     C                   EXSR      MCTEEWTART
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWIDCO'
     C                   EXSR      MCTEEWIDCO
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWFGVE'
     C                   EXSR      MCTEEWFGVE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEE1RFTY'
     C                   EXSR      MCTEE1RFTY
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEE1FGVE'
     C                   EXSR      MCTEE1FGVE
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWGFHR'
     C                   EXSR      MCTEEWGFHR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWTEAK'
     C                   EXSR      MCTEEWTEAK
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWPACD'
     C                   EXSR      MCTEEWPACD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWPACO'
     C                   EXSR      MCTEEWPACO
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWARKL'
     C                   EXSR      MCTEEWARKL
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTEEWITTY'
     C                   EXSR      MCTEEWITTY
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR FORMATE                                         ***
     C**************************************************************************
     C     BILDPR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*  Felder, die mit Bezugszahlen zum Sperren bedingt sind, müssen zusätz-
     C*  lich mit diesen Bezugszahlen (*IN30 - *IN39) abgefragt werden, da sonst
     C*  F4 bei einem gesperrten Feld ausgeführt werden kann und die weiteren
     C*  Aktionen nicht mehr kontrollierbar sind (Update des gesperrten Feldes).
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   MOVEA     EXFLPOFLDA    FLD
     C*-------------------------------------------------------------------------
     C     1             DO        100           FL
     C*-------------------------------------------------------------------------
     C     FLD(FL)       IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     FLD(FL)       FLDNAM
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*----------------------------------------------------------
     C                   SELECT
     C     EXFLPOKZIO    WHENEQ    *OFF
     C*
     C     FLDNAM        WHENEQ    'DSTEEWTENR'
     C     C#LCK1        ANDEQ     *OFF
     C                   EXSR      PRTEEWTENR
     C     FLDNAM        WHENEQ    'DSTEEWSKUN'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWSKUN
     C     FLDNAM        WHENEQ    'DSTEEWPNCN'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWPNCN
     C     FLDNAM        WHENEQ    'DSTEEWPRGR'
     C     C#LCK0        ANDEQ     *OFF
     C     C#LCK2        ANDEQ     *OFF
     C                   EXSR      PRTEEWPRGR
     C     FLDNAM        WHENEQ    'DSTEEWPCGR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWPCGR
     C     FLDNAM        WHENEQ    'DSTEEWALPN'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWALPN
     C     FLDNAM        WHENEQ    'DSTEEWLVZT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWLVZT
     C     FLDNAM        WHENEQ    'DSTEEWLVZA'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWLVZA
     C     FLDNAM        WHENEQ    'DSTEEWKZLF'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWKZLF
     C     FLDNAM        WHENEQ    'DSTEEWKZHS'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWKZHS
     C     FLDNAM        WHENEQ    'DSTEEWVKG1'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWVKGR
     C     FLDNAM        WHENEQ    'DSTEEWVWIT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWVWIT
     C     FLDNAM        WHENEQ    'DSTEEWSDBP'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWSDBP
     C     FLDNAM        WHENEQ    'DSTEEWEOPR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWEOPR
     C     FLDNAM        WHENEQ    'DSTEEWEOSP'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWEOSP
     C     FLDNAM        WHENEQ    'DSTEEWPRMG'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWPRMG
     C     FLDNAM        WHENEQ    'DSTEEWKATL'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWKATL
     C     FLDNAM        WHENEQ    'DSTEEWOEAT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWOEAT
     C     FLDNAM        WHENEQ    'DSTEEWEXSV'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWEXSV
     C     FLDNAM        WHENEQ    'DSTEEWVRVM'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWVRVM
     C     FLDNAM        WHENEQ    'DSTEEWTART'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWTART
     C     FLDNAM        WHENEQ    'DSTEEWIDCO'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWIDCO
     C     FLDNAM        WHENEQ    'DSTEEWFGVE'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWFGVE
     C     FLDNAM        WHENEQ    'DSTEE1RFTY'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEE1RFTY
     C     FLDNAM        WHENEQ    'DSTEE1RFQT'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEE1RFQT
     C     FLDNAM        WHENEQ    'DSTEE1GWPN'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEE1GWPN
     C     FLDNAM        WHENEQ    'DSTEE1FGVE'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEE1FGVE
     C     FLDNAM        WHENEQ    'DSTEEWGFHR'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWGFHR
     C     FLDNAM        WHENEQ    'DSTEEWTEAK'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWTEAK
     C     FLDNAM        WHENEQ    'DSTEEWPACD'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWPACD
     C     FLDNAM        WHENEQ    'DSTEEWPACO'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWPACO
     C     FLDNAM        WHENEQ    'DSTEEWARKL'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWARKL
     C     FLDNAM        WHENEQ    'DSTEEWITTY'
     C     C#LCK0        ANDEQ     *OFF
     C                   EXSR      PRTEEWITTY
     C                   ENDSL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    '3     '
     C*----------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C     PCPGST        OREQ      '      '
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C                   SELECT
     C     WKFENR        WHENEQ    *ZERO
     C     PCPGST        ANDEQ     *BLANK
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSTEEWTENR'  EXFLPOFLDN
     C                   LEAVESR
     C     WKFENR        WHENNE    *ZERO
     C     PCPGST        ANDEQ     '2     '
     C                   MOVE      '0901'        WKFENR
     C                   MOVEL(P)  'DSTEEWTENR'  EXFLPOFLDN
     C                   LEAVESR
     C                   ENDSL
     C*----------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRMU                                                 ***
     C**************************************************************************
     C     UTRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEEW'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEEW          TRMUDATA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TRMUJNAM
     C                   MOVEL(P)  WKCHPN        TRMUPROG
     C                   MOVEL(P)  WKCHPL        TRMUBIBL
     C                   MOVEL(P)  DAUSER        TRMUUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TRMUJZEI
     C                   MOVE      WKTDAT        TRMUJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'W'           #CRTCD
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTRMU
     C                   MOVE      'U'           #CRTCD
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KOPIEREN SÄTZE AUS DATEI TEEW                                     ***
     C**************************************************************************
     C     KTEEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     TEEWSKUN      DSTEEWSKUN
     C                   MOVEL     TEEWPNCN      DSTEEWPNCN
     C                   MOVEL     TEEWPRGR      DSTEEWPRGR
     C                   EVAL      DSTEEWPCGR = TEEWPCGR
     C                   EVAL      DSTEEWALPN = TEEWALPN
     C                   Z-ADD     TEEWLVZT      DSTEEWLVZT
     C                   MOVEL(P)  TEEWLVZA      DSTEEWLVZA
     C                   MOVEL(P)  TEEWKZLF      DSTEEWKZLF
     C                   MOVEL(P)  TEEWKZHS      DSTEEWKZHS
     C                   MOVEL(P)  TEEWVKG1      DSTEEWVKG1
     C                   MOVEL(P)  TEEWVKG2      DSTEEWVKG2
     C                   MOVEL(P)  TEEWVKG3      DSTEEWVKG3
     C                   MOVEL(P)  TEEWVKG4      DSTEEWVKG4
     C                   MOVEL(P)  TEEWVKG5      DSTEEWVKG5
     C                   MOVEL(P)  TEEWVWIT      DSTEEWVWIT
     C                   MOVEL(P)  TEEWSDBP      DSTEEWSDBP
     C                   MOVEL(P)  TEEWPRMG      DSTEEWPRMG
     C                   MOVEL(P)  TEEWKATL      DSTEEWKATL
     C                   MOVEL(P)  TEEWOEAT      DSTEEWOEAT
     C                   MOVEL(P)  TEEWEXSV      DSTEEWEXSV
     C                   MOVEL(P)  TEEWVRVM      DSTEEWVRVM
     C                   MOVEL(P)  TEEWTART      DSTEEWTART
     C                   MOVEL(P)  TEEWIDCO      DSTEEWIDCO
     C                   MOVEL(P)  TEEWFGVE      DSTEEWFGVE
      /FREE
          DSTEEWRFTY = TEEWRFTY;
          DSTEEWRFQT = TEEWRFQT;
          DSTEEWGWPN = TEEWGWPN;
          DSTEEWTOTO = TEEWTOTO;

          CLEAR EXDATE;
          EXDATEDATV = TEEWEOPR;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOPR = RTDATEDATE;

          CLEAR EXDATE;
          EXDATEDATV = TEEWEOSP;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOSP = RTDATEDATE;
      /END-FREE
     C                   MOVEL(P)  TEEWGFHR      DSTEEWGFHR
     C                   MOVEL(P)  TEEWTEAK      DSTEEWTEAK
     C                   MOVEL(P)  TEEWPACD      DSTEEWPACD
     C                   MOVEL(P)  TEEWPACO      DSTEEWPACO
     C                   MOVEL(P)  TEEWARKL      DSTEEWARKL
     C                   MOVEL(P)  TEEWITTY      DSTEEWITTY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB TEEW-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PTEEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYTEEWTENR    OFTEEWTENR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     TEEWFIRM      ANDEQ     KYTEEWFIRM
     C     TEEWTENR      ANDLE     OFTEEWTENR
     C*--------------------------------------------------------
     C     TEEWLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'TEEWLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI TEEW                                          ***
     C**************************************************************************
     C     LTEEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYTEEWTENR    OFTEEWTENR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     TEEWFIRM      ANDEQ     KYTEEWFIRM
     C     TEEWTENR      ANDLE     OFTEEWTENR
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   MOVEL(P)  TEEWTENR      KYTEEWTENR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTEEW
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHTEEW
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTEEW
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN DER ABHÄNGIG. SÄTZE                                       ***
     C**************************************************************************
     C     LPOSI         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN DATEI-FELDER                                               ***
     C**************************************************************************
     C     PRAUFR        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDATE    EXTEEWDATE
     C                   MOVEL     EXTEEWSKUN    DSTEEWSKUN
     C                   MOVEL     EXTEEWPNCN    DSTEEWPNCN
     C                   MOVEL     EXTEEWPRGR    DSTEEWPRGR
     C                   EVAL      DSTEEWPCGR = EXTEEWPCGR
     C                   EVAL      DSTEEWALPN = EXTEEWALPN
     C                   Z-ADD     EXTEEWLVZT    DSTEEWLVZT
     C                   MOVEL(P)  EXTEEWLVZA    DSTEEWLVZA
     C                   MOVEL(P)  EXTEEWKZLF    DSTEEWKZLF
     C                   MOVEL(P)  EXTEEWKZHS    DSTEEWKZHS
     C                   MOVEL(P)  EXTEEWVKG1    DSTEEWVKG1
     C                   MOVEL(P)  EXTEEWVKG2    DSTEEWVKG2
     C                   MOVEL(P)  EXTEEWVKG3    DSTEEWVKG3
     C                   MOVEL(P)  EXTEEWVKG4    DSTEEWVKG4
     C                   MOVEL(P)  EXTEEWVKG5    DSTEEWVKG5
     C                   MOVEL(P)  EXTEEWVWIT    DSTEEWVWIT
     C                   MOVEL(P)  EXTEEWSDBP    DSTEEWSDBP
     C                   MOVEL(P)  EXTEEWPRMG    DSTEEWPRMG
     C                   MOVEL(P)  EXTEEWKATL    DSTEEWKATL
     C                   MOVEL(P)  EXTEEWOEAT    DSTEEWOEAT
     C                   MOVEL(P)  EXTEEWEXSV    DSTEEWEXSV
     C                   MOVEL(P)  EXTEEWVRVM    DSTEEWVRVM
     C                   MOVEL(P)  EXTEEWTART    DSTEEWTART
     C                   MOVEL(P)  EXTEEWIDCO    DSTEEWIDCO
     C                   MOVEL(P)  EXTEEWFGVE    DSTEEWFGVE
      /FREE
          DSTEEWRFTY = EXTEEWRFTY;
          DSTEEWRFQT = EXTEEWRFQT;
          DSTEEWGWPN = EXTEEWGWPN;

          CLEAR EXDATE;
          EXDATEDATV = EXTEEWEOPR;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOPR = RTDATEDATE;

          CLEAR EXDATE;
          EXDATEDATV = EXTEEWEOSP;
          EXDATEFMTV = '*ISO';
          EXDATEFMTN = '*EUR';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          DSTEEWEOSP = RTDATEDATE;
      /END-FREE
     C                   MOVEL(P)  EXTEEWGFHR    DSTEEWGFHR
     C                   MOVEL(P)  EXTEEWTEAK    DSTEEWTEAK
     C                   MOVEL(P)  EXTEEWPACD    DSTEEWPACD
     C                   MOVEL(P)  EXTEEWPACO    DSTEEWPACO
     C                   MOVEL(P)  EXTEEWARKL    DSTEEWARKL
     C                   MOVEL(P)  EXTEEWITTY    DSTEEWITTY
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*    EXTRNDFLDN    WHENEQ    'TEEWSKUN'
     C*                  EXSR      PRTEEWSKUN
     C*    EXTRNDFLDN    WHENEQ    'TEEWPNCN'
     C*                  EXSR      PRTEEWPNCN
     C*    EXTRNDFLDN    WHENEQ    'TEEWPRGR'
     C*                  EXSR      PRTEEWPRGR
     C*    EXTRNDFLDN    WHENEQ    'TEEWPCGR'
     C*                  EXSR      PRTEEWPCGR
     C*    EXTRNDFLDN    WHENEQ    'TEEWALPN'
     C*                  EXSR      PRTEEWALPN
     C*    EXTRNDFLDN    WHENEQ    'TEEWLVZT'
     C*                  EXSR      PRTEEWLVZT
     C*    EXTRNDFLDN    WHENEQ    'TEEWLVZA'
     C*                  EXSR      PRTEEWLVZA
     C*    EXTRNDFLDN    WHENEQ    'TEEWKZLF'
     C*                  EXSR      PRTEEWKZLF
     C*    EXTRNDFLDN    WHENEQ    'TEEWKZHS'
     C*                  EXSR      PRTEEWKZHS
     C*    EXTRNDFLDN    WHENEQ    'TEEWVKG1'
     C*                  EXSR      PRTEEWVKGR
     C*    EXTRNDFLDN    WHENEQ    'TEEWVWIT'
     C*                  EXSR      PRTEEWVWIT
     C*    EXTRNDFLDN    WHENEQ    'TEEWSDBP'
     C*                  EXSR      PRTEEWSDBP
     C*    EXTRNDFLDN    WHENEQ    'TEEWEOPR'
     C*                  EXSR      PRTEEWEOPR
     C*    EXTRNDFLDN    WHENEQ    'TEEWEOSP'
     C*                  EXSR      PRTEEWEOSP
     C*    EXTRNDFLDN    WHENEQ    'TEEWPRMG'
     C*                  EXSR      PRTEEWPRMG
     C*    EXTRNDFLDN    WHENEQ    'TEEWKATL'
     C*                  EXSR      PRTEEWKATL
     C*    EXTRNDFLDN    WHENEQ    'TEEWOEAT'
     C*                  EXSR      PRTEEWOEAT
     C*    EXTRNDFLDN    WHENEQ    'TEEWEXSV'
     C*                  EXSR      PRTEEWEXSV
     C*    EXTRNDFLDN    WHENEQ    'TEEWVRVM'
     C*                  EXSR      PRTEEWVRVM
     C*    EXTRNDFLDN    WHENEQ    'TEEWTART'
     C*                  EXSR      PRTEEWTART
     C*    EXTRNDFLDN    WHENEQ    'TEEWIDCO'
     C*                  EXSR      PRTEEWIDCO
     C*    EXTRNDFLDN    WHENEQ    'TEEWFGVE'
     C*                  EXSR      PRTEEWFGVE
     C*    EXTRNDFLDN    WHENEQ    'TEEWRFTY'
     C*                  EXSR      PRTEEWRFTY
     C*    EXTRNDFLDN    WHENEQ    'TEEWRFQT'
     C*                  EXSR      PRTEEWRFQT
     C*    EXTRNDFLDN    WHENEQ    'TEEWGWPN'
     C*                  EXSR      PRTEEWGWPN
     C*    EXTRNDFLDN    WHENEQ    'TEEWGFHR'
     C*                  EXSR      PRTEEWGFHR
     C*    EXTRNDFLDN    WHENEQ    'TEEWTEAK'
     C*                  EXSR      PRTEEWTEAK
     C                   OTHER
     C                   MOVEL     'TRTEEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUS EXTERNEN PROGRAMMEN                                    ***
     C**************************************************************************
     C     IFTEEW        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     EXTEEWIFKZ    IFEQ      '0'
     C                   MOVEL(P)  EXTEEWTENR    KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL     *BLANK        PCPGST
     C                   ELSE
     C                   MOVEL     '2     '      PCPGST
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDATE    EXTEEWDATE
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*
     C     EXTEEWSKUN    IFNE      *BLANK
     C                   MOVEL     EXTEEWSKUN    DSTEEWSKUN
     C                   ENDIF
     C     EXTEEWPNCN    IFNE      *BLANK
     C                   MOVEL     EXTEEWPNCN    DSTEEWPNCN
     C                   ENDIF
     C     EXTEEWPRGR    IFNE      *BLANK
     C                   MOVEL     EXTEEWPRGR    DSTEEWPRGR
     C                   ENDIF
     C                   IF        DSTEEWPCGR <> *BLANK
     C                   EVAL      DSTEEWPCGR = EXTEEWPCGR
     C                   ENDIF
     C                   IF        DSTEEWALPN <> *BLANK
     C                   EVAL      DSTEEWALPN = EXTEEWALPN
     C                   ENDIF
     C     EXTEEWLVZT    IFNE      *ZERO
     C                   Z-ADD     EXTEEWLVZT    DSTEEWLVZT
     C                   ENDIF
     C     EXTEEWLVZA    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWLVZA    DSTEEWLVZA
     C                   ENDIF
     C     EXTEEWKZLF    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWKZLF    DSTEEWKZLF
     C                   ENDIF
     C     EXTEEWKZHS    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWKZHS    DSTEEWKZHS
     C                   ENDIF
     C     EXTEEWVKG1    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVKG1    DSTEEWVKG1
     C                   ENDIF
     C     EXTEEWVKG2    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVKG2    DSTEEWVKG2
     C                   ENDIF
     C     EXTEEWVKG3    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVKG3    DSTEEWVKG3
     C                   ENDIF
     C     EXTEEWVKG4    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVKG4    DSTEEWVKG4
     C                   ENDIF
     C     EXTEEWVKG5    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVKG5    DSTEEWVKG5
     C                   ENDIF
     C     EXTEEWVWIT    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVWIT    DSTEEWVWIT
     C                   ENDIF
     C     EXTEEWSDBP    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWSDBP    DSTEEWSDBP
     C                   ENDIF
     C     EXTEEWPRMG    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWPRMG    DSTEEWPRMG
     C                   ENDIF
     C     EXTEEWKATL    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWKATL    DSTEEWKATL
     C                   ENDIF
     C     EXTEEWOEAT    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWOEAT    DSTEEWOEAT
     C                   ENDIF
     C     EXTEEWEXSV    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWEXSV    DSTEEWEXSV
     C                   ENDIF
     C     EXTEEWVRVM    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWVRVM    DSTEEWVRVM
     C                   ENDIF
     C     EXTEEWTART    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWTART    DSTEEWTART
     C                   ENDIF
     C     EXTEEWIDCO    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWIDCO    DSTEEWIDCO
     C                   ENDIF
     C     EXTEEWFGVE    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWFGVE    DSTEEWFGVE
     C                   ENDIF
      /FREE
          IF DSTEEWRFTY <> *BLANK;
            DSTEEWRFTY = EXTEEWRFTY;
          ENDIF;
          IF DSTEEWRFQT <> *ZERO;
            DSTEEWRFQT = EXTEEWRFQT;
          ENDIF;
          IF DSTEEWGWPN <> *ZERO;
            DSTEEWGWPN = EXTEEWGWPN;
          ENDIF;
          if DSTEEWTOTO <> *ZERO;
            DSTEEWTOTO = EXTEEWTOTO;
          endif;

          IF EXTEEWEOPR <> *ZERO;
            CLEAR EXDATE;
            EXDATEDATV = EXTEEWEOPR;
            EXDATEFMTV = '*ISO';
            EXDATEFMTN = '*EUR';
            EXDATEPGST = 'TRDAUM';
            EXSR TRDATE;
            DSTEEWEOPR = RTDATEDATE;
          ENDIF;

          IF EXTEEWEOSP <> *ZERO;
            CLEAR EXDATE;
            EXDATEDATV = EXTEEWEOSP;
            EXDATEFMTV = '*ISO';
            EXDATEFMTN = '*EUR';
            EXDATEPGST = 'TRDAUM';
            EXSR TRDATE;
            DSTEEWEOSP = RTDATEDATE;
          ENDIF;
      /END-FREE
     C     EXTEEWGFHR    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWGFHR    DSTEEWGFHR
     C                   ENDIF
     C     EXTEEWTEAK    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWTEAK    DSTEEWTEAK
     C                   ENDIF
     C     EXTEEWPACD    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWPACD    DSTEEWPACD
     C                   ENDIF
     C     EXTEEWPACO    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWPACO    DSTEEWPACO
     C                   ENDIF
     C     EXTEEWARKL    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWARKL    DSTEEWARKL
     C                   ENDIF
     C     EXTEEWITTY    IFNE      *BLANK
     C                   MOVEL(P)  EXTEEWITTY    DSTEEWITTY
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'TRTEEW01'    WKFLPORECN
     C                   EXSR      EFLPO
     C                   EXSR      BILDPR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UTEEW
     C                   ELSE
     C                   EVAL      WKFFLD = %SUBST(EXFLPOFLDN:3:8)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
     C*-------------------------------------------------------------------------
     C     K#TEEWLOCK    IFEQ      'L'                                          WENN SATZ GE-
     C                   MOVEA     '01CF    '    CHI                            SPERRT, DANN
     C                   EXSR      CHTEEW                                       FREIGEBEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEEW                                                 ***
     C**************************************************************************
     C     UTEEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTEEWTENR    KYTEEWTENR
     C     PCPGST        IFEQ      '3     '
     C     PCPGST        OREQ      'KTEIL '
     C                   MOVE(P)   DSTEEWNTEN    KYTEEWTENR
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTEEW
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTEEWSKUN    TEEWSKUN
     C                   MOVEL(P)  DSTEEWPNCN    TEEWPNCN
     C                   MOVEL(P)  DSTEEWPRGR    TEEWPRGR
     C                   EVAL      TEEWPCGR = DSTEEWPCGR
     C                   EVAL      TEEWALPN = DSTEEWALPN
     C                   Z-ADD     DSTEEWLVZT    TEEWLVZT
     C                   MOVEL(P)  DSTEEWLVZA    TEEWLVZA
     C                   MOVEL(P)  DSTEEWKZLF    TEEWKZLF
     C                   MOVEL(P)  DSTEEWKZHS    TEEWKZHS
     C                   MOVEL(P)  DSTEEWVKG1    TEEWVKG1
     C                   MOVEL(P)  DSTEEWVKG2    TEEWVKG2
     C                   MOVEL(P)  DSTEEWVKG3    TEEWVKG3
     C                   MOVEL(P)  DSTEEWVKG4    TEEWVKG4
     C                   MOVEL(P)  DSTEEWVKG5    TEEWVKG5
     C                   MOVEL(P)  DSTEEWVWIT    TEEWVWIT
     C                   MOVEL(P)  DSTEEWSDBP    TEEWSDBP
     C                   MOVEL(P)  DSTEEWPRMG    TEEWPRMG
     C                   MOVEL(P)  DSTEEWKATL    TEEWKATL
     C                   MOVEL(P)  DSTEEWOEAT    TEEWOEAT
     C                   MOVEL(P)  DSTEEWEXSV    TEEWEXSV
     C                   MOVEL(P)  DSTEEWVRVM    TEEWVRVM
     C                   MOVEL(P)  DSTEEWTART    TEEWTART
     C                   MOVEL(P)  DSTEEWIDCO    TEEWIDCO
     C                   MOVEL(P)  DSTEEWFGVE    TEEWFGVE
      /FREE
          TEEWRFTY = DSTEEWRFTY;
          TEEWRFQT = DSTEEWRFQT;
          TEEWGWPN = DSTEEWGWPN;
          TEEWTOTO = DSTEEWTOTO;

          CLEAR EXDATE;
          EXDATEDATV = DSTEEWEOPR;
          EXDATEFMTV = '*EUR';
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          TEEWEOPR = RTDATEDATE;

          CLEAR EXDATE;
          EXDATEDATV = DSTEEWEOSP;
          EXDATEFMTV = '*EUR';
          EXDATEFMTN = '*ISO';
          EXDATEPGST = 'TRDAUM';
          EXSR TRDATE;
          TEEWEOSP = RTDATEDATE;
      /END-FREE
     C                   MOVEL(P)  DSTEEWGFHR    TEEWGFHR
     C                   MOVEL(P)  DSTEEWTEAK    TEEWTEAK
     C                   MOVEL(P)  DSTEEWPACD    TEEWPACD
     C                   MOVEL(P)  DSTEEWPACO    TEEWPACO
     C                   MOVEL(P)  DSTEEWARKL    TEEWARKL
     C                   MOVEL(P)  DSTEEWITTY    TEEWITTY
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TEEWJNAM
     C                   MOVEL(P)  DAPROG        TEEWPROG
     C                   MOVEL(P)  WKCHPL        TEEWBIBL
     C                   MOVEL(P)  DAUSER        TEEWUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TEEWJZEI
     C                   MOVE      WKTDAT        TEEWJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHTEEW
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL(P)  DAUSER        TEEWERUS
     C*
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     WKTRPATEIL    CASEQ     *ON           UTEEWFIRM
     C                   ENDCS
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     WKTRPATEIL    CASEQ     *ON           UTEEWFIRM
     C                   ENDCS
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MANDANTÜBERGREIFENDE KOPIERFUNKTION                               ***
     C**************************************************************************
     C     UTEEWFIRM     BEGSR
     C*
     C                   MOVEL(P)  TEEW          WKTEEW
     C*-------------------------------------------------------------------------
     C                   DO        20            I1
     C*
     C     FIR(I1)       IFNE      *BLANK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FIR(I1)       KYTEEWFIRM
     C                   MOVEL(P)  TEEWTENR      KYTEEWTENR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTEEW
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEEWVWIT      MODWAOVWIT
     C*
     C                   MOVEL(P)  WKTEEW        TEEW
     C                   MOVEL(P)  FIR(I1)       TEEWFIRM
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C*
     C     FIR(I1)       IFEQ      '08'
     C                   MOVEL(P)  *BLANK        TEEWVWIT
     C                   ENDIF
     C*
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHTEEW                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C*
     C     FIR(I1)       IFEQ      '08'
     C                   MOVEL(P)  MODWAOVWIT    TEEWVWIT
     C                   ENDIF
     C*
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHTEEW
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTEEW        TEEW
     C                   MOVEL(P)  TEEWFIRM      KYTEEWFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     MCTEEWTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWTENR    IFEQ      *BLANK
     C                   MOVE      *BLANK        DSTENRTBZ1
     C                   MOVE      *BLANK        DSTENRTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSTEEWTENR    KOM(01)
     C                   MOVEL(P)  '0526'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSTEEWTENR
     C                   MOVEL(P)  TETBZ1        DSTENRTBZ1
     C                   MOVEL(P)  TETBZ2        DSTENRTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE TENR                                                   ***
     C**************************************************************************
     C     PRTEEWTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSTEEWTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TETENR        DSTEEWTENR
     C                   MOVEL(P)  TETBZ1        DSTENRTBZ1
     C                   MOVEL(P)  TETBZ2        DSTENRTBZ2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SKUN                                                   ***
     C**************************************************************************
     C     PRTEEWSKUN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWSKUN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PCNN                                                   ***
     C**************************************************************************
     C     PRTEEWPNCN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWPNCN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     MCTEEWPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWPRGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWPRGR'  KOM(02)
     C                   MOVEA     DSTEEWPRGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWPRGR
     C                   MOVEL(P)  TPTTXT        TXTEEWPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     PRTEEWPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWPRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWPRGR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '$$TEEWPRGR'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C*
     C     DSTEEWPRGR    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWPRGR'  KYTPTA
     C                   MOVEL(P)  DSTEEWPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
        //*************************************************************************
        //**  MC-Routine PCGR                                                   ***
        //*************************************************************************
        BEGSR MCTEEWPCGR;

          C#WNDW = *ON;

          IF DSTEEWPCGR = *BLANK;
            TXTEEWPCGR = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = DASPCD;
          %SUBST(KOMDS:02) = '$$TEEWPCGR';
          %SUBST(KOMDS:12) = DSTEEWPCGR;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCTRTP;

          IF WKTRTP = *OFF AND WKFENR = *ZERO;
            WKTRTP = *ON;
            DSTEEWPCGR = TPTCDE;
            TXTEEWPCGR = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine PCGR                                                   ***
        //*************************************************************************
        BEGSR PRTEEWPCGR;

          EXFLPOFLDN = 'DSTEEWPCGR';
          TXTEEWPCGR = *BLANK;

          KYTKTA = '$$TEEWPCGR';
          CHIDS = '01C';
          EXSR CHTRTK;

          IF DSTEEWPCGR <> *BLANK OR TKTMSF = 'M';
            KYTPTA = '$$TEEWPCGR';
            KYTPTC = DSTEEWPCGR;
            KYTPTF = *ZERO;
            CHIDS = '01C';
            EXSR CHTRTP;
            TXTEEWPCGR = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine ALPN                                                   ***
        //*************************************************************************
        BEGSR PRTEEWALPN;

          EXFLPOFLDN = 'DSTEEWALPN';

          IF DSTEEWALPN <> *BLANK;
            KYTENR = DSTEEWALPN;
            CHIDS = '01C';
            EXSR CHTEIL;
            DSTEEWALPN = TETENR;
          ENDIF;

        ENDSR;
      /END-FREE
     C**************************************************************************
     C***  PRÜFEN VORLAUF-ZEIT                                               ***
     C**************************************************************************
     C     PRTEEWLVZT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWLVZT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSTEEWLVZT    IFEQ      *ZERO
     C     DSTEEWLVZA    ANDNE     *BLANK
     C                   MOVE      '0292'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN ZEIT-BASIS                                               ***
     C**************************************************************************
     C     MCTEEWLVZA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWLVZA'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSTEEWLVZA    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWLVZA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'LVZA'        KOM(02)
     C                   MOVEA     DSTEEWLVZA    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWLVZA
     C                   MOVEL(P)  TPTTXT        TXTEEWLVZA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VORLAUF-ZEIT BASIS                                         ***
     C**************************************************************************
     C     PRTEEWLVZA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWLVZA'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXTEEWLVZA
     C*-------------------------------------------------------------------------
     C     DSTEEWLVZA    IFEQ      *BLANK
     C     DSTEEWLVZT    ANDNE     *ZERO
     C                   MOVE      '0292'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTEEWLVZA    IFNE      *BLANK
     C*--------------------------------------------------------
     C                   MOVEL(P)  'LVZA'        KYTPTA
     C                   MOVEL(P)  DSTEEWLVZA    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  TPTTXT        TXTEEWLVZA
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSTEEWLVZA    KYZTZD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZTDI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '9184'        WKFENR                         ZEITBASIS NICHT IM
     C                   LEAVESR                                                PROGRAMM TRZTDIST
     C                   ENDIF                                                  HINTERLEGT
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KONZERNSCHLÜSSEL                                         ***
     C**************************************************************************
     C     MCTEEWKZLF    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWKZLF'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSTEEWKZLF    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWKZLF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAOKZKY'   KOM(02)
     C                   MOVEA     DSTEEWKZLF    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWKZLF
     C                   MOVEL(P)  TPTTXT        TXTEEWKZLF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KZ-LIEFERANT                                               ***
     C**************************************************************************
     C     PRTEEWKZLF    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWKZLF'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXTEEWKZLF
     C*-------------------------------------------------------------------------
     C     DSTEEWKZLF    IFEQ      *BLANK
     C                   MOVEL(P)  '$$WAOKZKY'   KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTEEWKZLF    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C     WKTRPAKZLF    OREQ      *ON
     C                   MOVEL(P)  '$$WAOKZKY'   KYTPTA
     C                   MOVEL(P)  DSTEEWKZLF    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWKZLF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KONZERNSCHLÜSSEL                                         ***
     C**************************************************************************
     C     MCTEEWKZHS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWKZHS'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSTEEWKZHS    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWKZHS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$WAOKZKY'   KOM(02)
     C                   MOVEA     DSTEEWKZHS    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWKZHS
     C                   MOVEL(P)  TPTTXT        TXTEEWKZHS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KZ-HERSTELLER                                              ***
     C**************************************************************************
     C     PRTEEWKZHS    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWKZHS'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXTEEWKZHS
     C*-------------------------------------------------------------------------
     C     DSTEEWKZHS    IFEQ      *BLANK
     C                   MOVEL(P)  '$$WAOKZKY'   KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTEEWKZHS    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$WAOKZKY'   KYTPTA
     C                   MOVEL(P)  DSTEEWKZHS    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWKZHS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN VERKAUFSGRUPPE                                           ***
     C**************************************************************************
     C     MCTEEWVKGR    BEGSR
     C*
     C                   MOVEL(P)  'DSTEEWVKG1'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSTEEWVKGR    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWVKGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWVKGR'  KOM(02)
     C                   MOVEA     DSTEEWVKGR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWVKGR
     C                   MOVEL(P)  TPTTXT        TXTEEWVKGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KZ-HERSTELLER                                              ***
     C**************************************************************************
     C     PRTEEWVKGR    BEGSR
     C*
     C                   MOVEL(P)  'DSTEEWVKG1'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXTEEWVKGR
     C*-------------------------------------------------------------------------
     C     DSTEEWVKGR    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWVKGR'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTEEWVKGR    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWVKGR'  KYTPTA
     C                   MOVEL(P)  DSTEEWVKGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWVKGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN VERKAUFSGRUPPE                                           ***
     C**************************************************************************
     C     MCTEEWVWIT    BEGSR
     C*
     C                   MOVEL(P)  'DSTEEWVWIT'  EXFLPOFLDN
     C*-------------------------------------------------------
     C     DSTEEWVWIT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWVWIT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWVWIT'  KOM(02)
     C                   MOVEA     DSTEEWVWIT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWVWIT
     C                   MOVEL(P)  TPTTXT        TXTEEWVWIT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KZ-HERSTELLER                                              ***
     C**************************************************************************
     C     PRTEEWVWIT    BEGSR
     C*
     C                   MOVEL(P)  'DSTEEWVWIT'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXTEEWVWIT
     C*-------------------------------------------------------------------------
     C     DSTEEWVWIT    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWVWIT'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSTEEWVWIT    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWVWIT'  KYTPTA
     C                   MOVEL(P)  DSTEEWVWIT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWVWIT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN AKTIV/INAKTIV-KZ                                         ***
     C**************************************************************************
     C     MCTEEWSDBP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWSDBP    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWSDBP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWSDBP    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWSDBP
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWSDBP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KZ SDB-PFLICHT                                             ***
     C**************************************************************************
     C     PRTEEWSDBP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWSDBP'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWSDBP    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWSDBP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN SACHBEARBEITER                                           ***
     C**************************************************************************
     C     MCTEEWPRMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWPRMG    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWPRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'SABE'        KOM(02)
     C                   MOVEA     DSTEEWPRMG    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWPRMG
     C                   MOVEL(P)  TPTTXT        TXTEEWPRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PRODUKT-MANAGER                                            ***
     C**************************************************************************
     C     PRTEEWPRMG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWPRMG'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWPRMG
     C*-------------------------------------------------------------------------
     C     DSTEEWPRMG    IFNE      *BLANK
     C                   MOVEL(P)  'SABE'        KYTPTA
     C                   MOVEL(P)  DSTEEWPRMG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWPRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCTEEWKATL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWKATL    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWKATL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWKATL    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWKATL
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWKATL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KATALOG-ARTIKEL                                            ***
     C**************************************************************************
     C     PRTEEWKATL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWKATL'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWKATL    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWKATL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN OE-ARTIKEL                                               ***
     C**************************************************************************
     C     MCTEEWOEAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWOEAT    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWOEAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWOEAT'  KOM(02)
     C                   MOVEA     DSTEEWOEAT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWOEAT
     C                   MOVEL(P)  TPTTXT        TXTEEWOEAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN OE-ARTIKEL                                                 ***
     C**************************************************************************
     C     PRTEEWOEAT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWOEAT'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWOEAT
     C*-------------------------------------------------------------------------
     C     DSTEEWOEAT    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWOEAT'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*
     C     DSTEEWOEAT    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWOEAT'  KYTPTA
     C                   MOVEL(P)  DSTEEWOEAT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWOEAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCTEEWEXSV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWEXSV    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWEXSV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWEXSV    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWEXSV
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWEXSV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN OE-ARTIKEL                                                 ***
     C**************************************************************************
     C     PRTEEWEXSV    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWEXSV'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWEXSV    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWEXSV
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN VORRATSVERMÖGEN                                          ***
     C**************************************************************************
     C     MCTEEWVRVM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWVRVM    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWVRVM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWVRVM'  KOM(02)
     C                   MOVEA     DSTEEWVRVM    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWVRVM
     C                   MOVEL(P)  TPTTXT        TXTEEWVRVM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VORRATSVERMÖGEN                                            ***
     C**************************************************************************
     C     PRTEEWVRVM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWVRVM'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWVRVM
     C*-------------------------------------------------------------------------
     C     DSTEEWVRVM    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWVRVM'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*
     C     DSTEEWVRVM    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWVRVM'  KYTPTA
     C                   MOVEL(P)  DSTEEWVRVM    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWVRVM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN ARTIKEL-ART                                              ***
     C**************************************************************************
     C     MCTEEWTART    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWTART    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWTART
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWTART'  KOM(02)
     C                   MOVEA     DSTEEWTART    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWTART
     C                   MOVEL(P)  TPTTXT        TXTEEWTART
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN ARTIKEL-ART                                                ***
     C**************************************************************************
     C     PRTEEWTART    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWTART'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWTART
     C*-------------------------------------------------------------------------
     C     DSTEEWTART    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWTART'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*
     C     DSTEEWTART    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWTART'  KYTPTA
     C                   MOVEL(P)  DSTEEWTART    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWTART
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN IDCO-MATERIALGRUPPE                                      ***
     C**************************************************************************
     C     MCTEEWIDCO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWIDCO    IFEQ      *BLANK
     C                   MOVEL     *BLANK        TXTEEWIDCO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     '$$TEEWIDCO'  KOM(02)
     C                   MOVEA     DSTEEWIDCO    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSTEEWIDCO
     C                   MOVEL(P)  TPTTXT        TXTEEWIDCO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN IDCO-MATERIALGRUPPE                                        ***
     C**************************************************************************
     C     PRTEEWIDCO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTEEWIDCO'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXTEEWIDCO
     C*-------------------------------------------------------------------------
     C     DSTEEWIDCO    IFEQ      *BLANK
     C                   MOVEL(P)  '$$TEEWIDCO'  KYTKTA                         MUßFELD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTK
     C                   ENDIF
     C*
     C     DSTEEWIDCO    IFNE      *BLANK
     C     TKTMSF        OREQ      'M'
     C                   MOVEL(P)  '$$TEEWIDCO'  KYTPTA
     C                   MOVEL(P)  DSTEEWIDCO    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXTEEWIDCO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-Routine FGVE                                                   ***
     C**************************************************************************
     C     MCTEEWFGVE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWFGVE    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWFGVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWFGVE    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWFGVE
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWFGVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-Routine FGVE                                                   ***
     C**************************************************************************
     C     PRTEEWFGVE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWFGVE'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWFGVE    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWFGVE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
        //*************************************************************************
        //**  MC-Routine RFTY                                                   ***
        //*************************************************************************
        BEGSR MCTEE1RFTY;

          C#WNDW = *ON;

          IF DSTEE1RFTY = *BLANK;
            TXTEE1RFTY = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = DASPCD;
          %SUBST(KOMDS:02) = '$$TEEWRFTY';
          %SUBST(KOMDS:12) = DSTEE1RFTY;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCTRTP;

          IF WKTRTP = *OFF AND WKFENR = *ZERO;
            WKTRTP = *ON;
            DSTEE1RFTY = TPTCDE;
            TXTEE1RFTY = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine RFTY                                                   ***
        //*************************************************************************
        BEGSR PRTEEWRFTY;

          EXFLPOFLDN = 'DSTEEWRFTY';
          TXTEEWRFTY = *BLANK;

          IF DSTEEWRFTY <> *BLANK;
            KYTPTA = '$$TEEWRFTY';
            KYTPTC = DSTEEWRFTY;
            KYTPTF = *ZERO;
            CHIDS = '01C';
            EXSR CHTRTP;
            TXTEEWRFTY = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  P1-Routine RFTY                                                   ***
        //*************************************************************************
        BEGSR PRTEE1RFTY;

          EXFLPOFLDN = 'DSTEE1RFTY';
          TXTEE1RFTY = *BLANK;

          IF DSTEE1RFTY <> *BLANK;
            KYTPTA = '$$TEEWRFTY';
            KYTPTC = DSTEE1RFTY;
            KYTPTF = *ZERO;
            CHIDS = '01C';
            EXSR CHTRTP;
            TXTEE1RFTY = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine RFQT                                                   ***
        //*************************************************************************
        BEGSR PRTEEWRFQT;

          EXFLPOFLDN = 'DSTEEWRFQT';

        ENDSR;

        //*************************************************************************
        //**  P1-Routine RFQT                                                   ***
        //*************************************************************************
        BEGSR PRTEE1RFQT;

          EXFLPOFLDN = 'DSTEE1RFQT';

        ENDSR;

        //*************************************************************************
        //**  PR-Routine GWPN                                                   ***
        //*************************************************************************
        BEGSR PRTEEWGWPN;

          EXFLPOFLDN = 'DSTEEWGWPN';

        ENDSR;

        //*************************************************************************
        //**  P1-Routine GWPN                                                   ***
        //*************************************************************************
        BEGSR PRTEE1GWPN;

          EXFLPOFLDN = 'DSTEE1GWPN';

        ENDSR;

        //*************************************************************************
        //**  MC-Routine FGVE                                                   ***
        //*************************************************************************
        BEGSR MCTEE1FGVE;

          C#WNDW = *ON;

          IF DSTEE1FGVE = *BLANK;
            TXTEE1FGVE = *BLANK;
          ENDIF;

          CLEAR EXTRPC;
          EXTRPCPGST = '5     ';
          EXTRPCPGGR = 'BOOL';
          EXTRPCCODE = DSTEE1FGVE;
          EXTRPCUEBE = '0010';
          EXSR MCTRPC;

          IF WKTRTP = *OFF AND WKFENR = *ZERO;
            WKTRTP = *ON;
            DSTEE1FGVE = EXTRPCCODE;
            TXTEE1FGVE = EXTRPCTEXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  P1-Routine FGVE                                                   ***
        //*************************************************************************
        BEGSR PRTEE1FGVE;

          EXFLPOFLDN = 'DSTEE1FGVE';

          EXTRPCPGGR = 'BOOL';
          EXTRPCCODE = DSTEE1FGVE;
          EXTRPCPGST = 'PRUEFE';
          EXSR PRTRPC;
          TXTEE1FGVE = EXTRPCTEXT;

        ENDSR;

        //*************************************************************************
        //**  MC-Routine EOPR                                                   ***
        //*************************************************************************
        BEGSR MCTEEWEOPR;

          C#WNDW = *ON;

          CLEAR EXDATE;
          EXDATEDATV = DSTEEWEOPR;
          EXDATEFMTV = '*EUR';
          EXDATEFMTN = '*EUR';

          IF DSTEEWEOPR = *ZERO;
            EXDATEPGCD = 'POSAKT';
          ENDIF;

          EXSR TRDATE;

          IF WKFENR = *ZERO AND WKTRTP = *OFF;
            DSTEEWEOPR = RTDATEDATE;
            WKTRTP = *ON;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine EOPR                                                   ***
        //*************************************************************************
        BEGSR PRTEEWEOPR;

          EXFLPOFLDN = 'DSTEEWEOPR';

          IF DSTEEWEOPR <> *ZERO;
            CLEAR EXDATE;
            EXDATEDATV = DSTEEWEOPR;
            EXDATEFMTV = '*EUR';
            EXDATEFMTN = '*EUR';
            EXDATEPGST = 'TRDAPR';
            EXSR TRDATE;
            IF WKFENR = *ZERO;
              DSTEEWEOPR = RTDATEDATE;
            ENDIF;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  MC-Routine EOSP                                                   ***
        //*************************************************************************
        BEGSR MCTEEWEOSP;

          C#WNDW = *ON;

          CLEAR EXDATE;
          EXDATEDATV = DSTEEWEOSP;
          EXDATEFMTV = '*EUR';
          EXDATEFMTN = '*EUR';

          IF DSTEEWEOSP = *ZERO;
            EXDATEPGCD = 'POSAKT';
          ENDIF;

          EXSR TRDATE;

          IF WKFENR = *ZERO AND WKTRTP = *OFF;
            DSTEEWEOSP = RTDATEDATE;
            WKTRTP = *ON;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine EOSP                                                   ***
        //*************************************************************************
        BEGSR PRTEEWEOSP;

          EXFLPOFLDN = 'DSTEEWEOSP';

          IF DSTEEWEOSP <> *ZERO;
            CLEAR EXDATE;
            EXDATEDATV = DSTEEWEOSP;
            EXDATEFMTV = '*EUR';
            EXDATEFMTN = '*EUR';
            EXDATEPGST = 'TRDAPR';
            EXSR TRDATE;
            IF WKFENR = *ZERO;
              DSTEEWEOSP = RTDATEDATE;
            ENDIF;
          ENDIF;

        ENDSR;
      /END-FREE
     C**************************************************************************
     C***  MC-Routine GFHR                                                   ***
     C**************************************************************************
     C     MCTEEWGFHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWGFHR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWGFHR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWGFHR    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWGFHR
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWGFHR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-Routine GFHR                                                   ***
     C**************************************************************************
     C     PRTEEWGFHR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWGFHR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWGFHR    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWGFHR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-Routine TEAK                                                   ***
     C**************************************************************************
     C     MCTEEWTEAK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSTEEWTEAK    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXTEEWTEAK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWTEAK    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSTEEWTEAK
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWTEAK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-Routine TEAK                                                   ***
     C**************************************************************************
     C     PRTEEWTEAK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSTEEWTEAK'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSTEEWTEAK    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXTEEWTEAK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'TENR'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-Routine PACD                                                   ***
     C**************************************************************************
      /FREE
        BEGSR PRTEEWPACD;

          EXFLPOFLDN = 'DSTEEWPACD';
          TXTEEWPACD = *BLANK;

          KYSYTKTART = '$$PAC   ';
          CHIDS = '01C';
          EXSR CHSYTK;

          // DEFAULT HINTERLEGT?
          IF SYTKTMSF = 'M'
            AND SYTKTDFT <> *BLANK
            AND DSTEEWPACD = *BLANK;
            DSTEEWPACD = SYTKTDFT;
          ENDIF;

          // MUSS / KANN ?
          IF SYTKTMSF = 'M'
            OR DSTEEWPACD <> *BLANK;
            KYSYTPTART = '$$PAC  ';
            KYSYTPTCDE = DSTEEWPACD;
            KYSYTPTFLG = *ZERO;
            CHIDS = '01C';
            EXSR CHSYTP;
            TXTEEWPACD = SYTPTTXT;
          ENDIF;

        ENDSR ;

      //*************************************************************************
      //**  ANZEIGEN  CHARGENFORMAT                                           ***
      //*************************************************************************
        BEGSR MCTEEWPACD;

          C#WNDW = *ON;
          EXFLPOFLDN = 'DSTEEWPACD';

          IF DSTEEWPACD = *BLANK;
            TXTEEWPACD = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = '$$PAC';
          %SUBST(KOMDS:11:2) = DSTEEWPACD;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCSYTP;

          IF WKTRTP = *OFF
              AND WKFENR = *ZERO;
              WKTRTP = *ON;
              DSTEEWPACD = SYTPTCDE;
              TXTEEWPACD = SYTPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  MC-Routine PACO                                                   ***
        //*************************************************************************
        BEGSR MCTEEWPACO;

          C#WNDW = *ON;

          IF DSTEEWPACO = *BLANK;
            TXTEEWPACO = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = '$$TEEWPACO';
          %SUBST(KOMDS:11) = DSTEEWPACO;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCSYTP;

          IF WKTRTP = *OFF AND WKFENR = *ZERO;
              WKTRTP = *ON;
              DSTEEWPACO = SYTPTCDE;
              TXTEEWPACO = SYTPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine PACO                                                   ***
        //*************************************************************************
        BEGSR PRTEEWPACO;

          EXFLPOFLDN = 'DSTEEWPACO';
          TXTEEWPACO = *BLANK;

          KYSYTKTART = '$$TEEWPACO';
          CHIDS = '01C';
          EXSR CHSYTK;

          // DEFAULT HINTERLEGT?
          IF SYTKTMSF = 'M'
            AND SYTKTDFT <> *BLANK
            AND DSTEEWPACO = *BLANK;
            DSTEEWPACO = SYTKTDFT;
          ENDIF;

          // MUSS / KANN ?
          IF SYTKTMSF = 'M'
            OR DSTEEWPACO <> *BLANK;
            KYSYTPTART = '$$TEEWPACO';
            KYSYTPTCDE = DSTEEWPACO;
            KYSYTPTFLG = *ZERO;
            CHIDS = '01C';
            EXSR CHSYTP;
            TXTEEWPACO = SYTPTTXT;
          ENDIF;
        ENDSR ;
      /END-FREE
     C**************************************************************************
     C***  PR-Routine ARKL                                                   ***
     C**************************************************************************
      /FREE
        BEGSR PRTEEWARKL;

          EXFLPOFLDN = 'DSTEEWARKL';
          TXTEEWARKL = *BLANK;

          KYTKTA = '$$TEEWARKL';
          CHIDS = '01C';
          EXSR CHTRTK;

          // DEFAULT HINTERLEGT?
          IF TKTMSF = 'M'
            AND TKTDFT <> *BLANK
            AND DSTEEWARKL = *BLANK;
            DSTEEWARKL = TKTDFT;
          ENDIF;

          // MUSS / KANN ?
          IF TKTMSF = 'M'
            OR DSTEEWARKL <> *BLANK;
            KYTPTA = '$$TEEWARKL';
            KYTPTC = DSTEEWARKL;
            KYTPTF = *ZERO;
            CHIDS = '01C';
            EXSR CHTRTP;
            TXTEEWARKL = TPTTXT;
          ENDIF;

        ENDSR ;

      //*************************************************************************
      //**  ANZEIGEN  CHARGENFORMAT                                           ***
      //*************************************************************************
        BEGSR MCTEEWARKL;

          C#WNDW = *ON;
          EXFLPOFLDN = 'DSTEEWARKL';

          IF DSTEEWARKL = *BLANK;
            TXTEEWARKL = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = DASPCD;
          %SUBST(KOMDS:02) = '$$TEEWARKL';
          %SUBST(KOMDS:12) = DSTEEWARKL;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCTRTP;

          IF WKTRTP = *OFF
              AND WKFENR = *ZERO;
              WKTRTP = *ON;
              DSTEEWARKL = TPTCDE;
              TXTEEWARKL = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  MC-Routine ITTY                                                   ***
        //*************************************************************************
        BEGSR MCTEEWITTY;

          C#WNDW = *ON;

          IF DSTEEWITTY = *BLANK;
            TXTEEWITTY = *BLANK;
          ENDIF;

          %SUBST(KOMDS:01) = DASPCD;
          %SUBST(KOMDS:02) = '$$TEEWITTY';
          %SUBST(KOMDS:12) = DSTEEWITTY;
          #CPGST = *BLANK;
          #CUEBE = '0010';
          EXSR MCTRTP;

          IF WKTRTP = *OFF AND WKFENR = *ZERO;
            WKTRTP = *ON;
            DSTEEWITTY = TPTCDE;
            TXTEEWITTY = TPTTXT;
          ENDIF;

        ENDSR;

        //*************************************************************************
        //**  PR-Routine ITTY                                                   ***
        //*************************************************************************
        BEGSR PRTEEWITTY;

          EXFLPOFLDN = 'DSTEEWITTY';
          TXTEEWITTY = *BLANK;

          KYTKTA = '$$TEEWITTY';
          CHIDS = '01C';
          EXSR CHTRTK;

          // Default hinterlegt?
          IF TKTMSF = 'M'
            AND TKTDFT <> *BLANK
            AND DSTEEWITTY = *BLANK;
            DSTEEWITTY = TKTDFT;
          ENDIF;

          // Muss / Kann ?
          IF TKTMSF = 'M' OR DSTEEWITTY <> *BLANK;
            KYTPTA = '$$TEEWITTY';
            KYTPTC = DSTEEWITTY;
            KYTPTF = *ZERO;
            CHIDS = '01C';
            EXSR CHTRTP;
            TXTEEWITTY = TPTTXT;
          ENDIF;

        ENDSR ;
      /END-FREE
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TEEW'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      TEEW
     C*
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'TEEW'        EXDATAFILE
     C                   MOVEL(P)  TEEW          EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    TEEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     ETEEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     TEEWSDBP      IFEQ      *BLANK
     C                   MOVEL     *OFF          TEEWSDBP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TEEWKATL      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        TEEWKATL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TEEWEXSV      IFEQ      *BLANK
     C                   MOVEL     DANEKZ        TEEWEXSV
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TEEWFGVE      IFEQ      *BLANK
     C                   MOVEL     *OFF          TEEWFGVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TEEWGFHR      IFEQ      *BLANK
     C                   MOVEL     *OFF          TEEWGFHR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TEEWTEAK      IFEQ      *BLANK
     C                   MOVEL     *OFF          TEEWTEAK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN DATENSATZFÜR DIE SICHT-STEUERUNG                            ***
     C**************************************************************************
     C     ESICHT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TEEW          RTTRNDDATE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   MOVEL(P)  W$PA03        RTTRNDPA03
     C                   MOVEL(P)  W$PA04        RTTRNDPA04
     C                   MOVEL(P)  W$PA05        RTTRNDPA05
     C                   MOVEL(P)  W$PA06        RTTRNDPA06
     C                   MOVEL(P)  W$PA07        RTTRNDPA07
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
     C                   MOVEL(P)  'NEUANLAGE'   KYTATA
     C                   MOVEL(P)  'AKTUALISIE'  KYTATC
     C                   MOVEL(P)  'TRTEEW'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'ZTDI'        KYTATC                         STAMM-ZEIT-BASIS
     C                   MOVEL(P)  'ZTDI'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        KYZTSZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEIL'      KYTATA
     C                   MOVEL(P)  'UPDATE'      KYTATC
     C                   MOVEL(P)  'FIRMA'       KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPATEIL
     C                   MOVEA(P)  TAPTXT        FIR
     C*
     C     WKTRPATEIL    IFNE      *ON
     C                   MOVE      *OFF          WKTRPATEIL
     C                   MOVE      *BLANK        FIR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEEW'      KYTATA                         KZ-LIEFERANT
     C                   MOVEL(P)  'PRUEFEN'     KYTATC                         ALS MUSSFELD
     C                   MOVEL(P)  'TEEWKZLF'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAKZLF
     C*
     C     WKTRPAKZLF    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAKZLF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZUGRIFFE                                                          ***
     C**************************************************************************
     C     TRTRDZ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   MOVE      *OFF          WKTRDZZYKL
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRDN
     C                   MOVEL(P)  WKPGST        EXTRDNPGST
     C                   MOVEL(P)  'TRTEEW'      EXTRDNPGNA
     C*--------------------------------------------------------
     C     C#ACCS        IFEQ      *OFF                                         F10=OPTIONEN
     C     WKPGST        ANDNE     'DIREKT'
     C*03.05.2004        MOVEL(P)  'TRTEEWB1'    EXTRDNPGNA
     C                   MOVE      C#FUKT        EXTRDNFUKT                     F-TASTEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRTEEW02'
     C                   IF        DSTEEWFGVE = *ON
                                      // Jetzt unabhängig von DSTEEWFGVE
     C                             OR DSTEEWFGVE <> *ON
     C                   EVAL      WKIFMT = '02'
     C                   EVAL      C#WNDW = *ON
     C                   EXSR      BILD02
     C                   LEAVE
     C                   ELSE
                                   // Das Kennzeichen "F-Gas Verordnung" ist inaktiv.
     C                   EVAL      WKFENR = '0030'
     C                   EVAL      W$MSGA = '#MO'
     C                   EVAL      EXFLPOFLDN = 'DSTEEWFGVE'
     C                   ENDIF
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRTK'
     C                   EXSR      MCAUFRTRTK
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     EXTRDNPGST    IFEQ      'DIREKT'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   ENDIF
     C*
     C     EXTRDNPGST    IFEQ      'WEITER'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C                   ENDIF
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#ACCS        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        #CRTCD
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
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAKZLF
     C     *LIKE         DEFINE    WKC001        WKTRPATEIL
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        FL              + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTEEWTENR    OFTEEWTENR
     C     *LIKE         DEFINE    KYTEEWTENR    DSTEEWNTEN
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEEWVWIT      MODWAOVWIT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKINFO          + 3
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9
     C     *LIKE         DEFINE    WKC001        W$MSGA          + 2
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'
     C                   PARM                    WKFENR
     C                   PARM                    KEYVAR
     C                   PARM                    DSJNAM
     C                   PARM                    DSUSER
     C                   PARM                    W$PA03
     C                   PARM                    W$PA04
     C                   PARM                    W$PA05
     C                   PARM                    W$PA06
     C                   PARM                    W$PA07
     C                   PARM                    W$MSGA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEEW'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTTEEWW1
     C                   OTHER
     C                   WRITE     TRTEEWCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTTEEWW1
     C                   OTHER
     C                   WRITE     TRTEEWCT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *BLANK        W$PA08
     C                   MOVE      *ZERO         WKFENR
     C                   EVAL      W$MSGA = *BLANK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTK
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHSYTK
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHZTDI
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCSYTP
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
