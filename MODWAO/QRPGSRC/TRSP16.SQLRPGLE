     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Übernahme Speditionsdaten
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 16.11.2010
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 04.01.2011 Bei Parts Express muß immer ein Gewicht über-
     H*            geben werden.
     H*  Änderung: SZ 05.01.2011 Bei trans-o-flex kein Länderkennzeichen wenn
     H*            Inland
     H*  Änderung: SZ 06.01.2011 Referenznummer zusammensetzen wenn Aufruf aus
     H*            TRAFSP
     H*  Änderung: SZ 09.01.2011 PLZ in Zusatzfeld bei DPD ohne Leerzeichen
     H*  Änderung: SZ 11.01.2011 KDNR bei Ausgabe für Parts Express vorüberge-
     H*            hend auf 5 Stellen kürzen
     H*  Änderung: SZ 12.01.2011 KDNR Parts Express wieder vollständig
     H*  Änderung: SZ 13.01.2011 Hellmann Aktionsversand über eigene Datei
     H*  Änderung: SZ 20.01.2011 Nachnahmebetrag Parts Express bei Teillieferung
     H*            nachrechnen. VAFLP darf nicht den ganzen Auftrag durchrechnen
     H*            nur den jeweiligen Kom.-Schein
     H*  Änderung: SZ 04.02.2011 Leitgebiet + Abstellfach für Boll ermitteln
     H*            ILN aus ZKUN ermitteln, nicht KDVS.
     H*  Änderung: SZ 22.02.2011 DPD Aktionsversand über eigene Datei
     H*  Änderung: SZ 16.03.2011 Versandbedingung aus AFKM, nicht aus AFKO
     H*  Änderung: SZ 14.04.2011 für DPD Aktionsversand die Menge der Pack-
     H*            stücke aus AFSP lesen, nicht AFVS. Gewicht ist Gesamtgewicht
     H*            dividiert durch Anzahl Packstücke.
     H*  Änderung: SZ 11.05.2011 auch bei Hellmann Aktionsversand die Menge der
     H*            Packstücke aus AFSP lesen, nicht AFVS.
     H*  Änderung: SZ 30.05.2011 Projekt 7357, Schenker
     H*  Änderung: VU 14.06.2011 Projekt 7189, Hamacher - Übergabe Tel.Avis
     H*  Änderung: VU 15.06.2011 Projekt 7485, Rouingdaten Schenker ermitteln
     H*  Änderung: SZ 27.07.2011 NightStar und Hellmann trennen.
     H*  Änderung: SZ 12.08.2011 Anforderung Herr Meier, neue Kundennummer für
     H*            Hellmann Hagebaumärkte (ZEUS).
     H*  Änderung: SZ 18.08.2011 Projekt 7722, weitere Spediteurnummer GLS
     H*  Änderung: SZ 19.08.2011 Projekt 7722, Absprachen mit Hr. Mach von GLS
     H*  Änderung: SZ 24.08.2011 Projekt 7087, Update WAO8 angepaßt.
     H*  Änderung: SZ 01.09.2011 Absprache mit Hr. Gang, statt Feld AKREF1 al-
     H*            ternativ Füllung aus AKMAAF für Axapta Nr. vorsehen, dann
     H*            kann AKREF1 anderweitig belegt werden.
     H*  Änderung: SZ 07.09.2011 Projekt 7189, Hamacher, Anpassung aktiviert
     H*  Änderung: SZ 21.09.2011 Projekt 7760, Hellmann, Übergabe Fixtermin
     H*            und Texte vorberteitet.
     H*  Änderung: SZ 29.09.2011 Projekt 7760, Ermitteln Texte zunächst weiter-
     H*            hin aus IFAT, weil noch nicht alle alten Aufträge geliefert
     H*            sind. Textart in IFAT aber von 4 auf 1 geändert und DRKZ
     H*            auf F (entspricht der neuen Füllung).
     H*  Änderung: SZ 18.10.2011 Projekt 7896, für Hamacher die Anzahl der be-
     H*            reits erstellten Lieferscheine ermitteln und einen Index zur
     H*            MAAF übergeben.
     H*  Änderung: SZ 27.12.2011 Projekt 8118, weitere Spediteurnummern GLS und
     H*            Hellmann für Dometic Siegen.
     H*  Änderung: SZ 15.02.2012 Projekt 8260, weitere Schnittstellendatei für
     H*            Kühne + Nagel.
     H*  Änderung: SZ 09.05.2012 auch Daten für Sendungen ohne Fakturierung be-
     H*            reitstellen
     H*  Änderung: SZ 09.05.2012 im Kopfsatz K + N das Gesamtgewicht ausgeben.
     H*  Änderung: SZ 25.05.2012 Projekt 8390, Schnittstelle Schenker für ES/PT
     H*  Änderung: SZ 11.07.2012 Projekt 8390, Anzahl Paletten auf Positions-
     H*            ebene
     H*  Änderung: SZ 27.07.2012 bei Boll das Gesamtgewicht im Kopfsatz ausgeben
     H*            HL20120726-011
     H*  Änderung: SZ 28.08.2012 Projekt 8732, Übergabe Packstückmasse aus AFVS
     H*  Änderung: SZ 29.08.2012 bei Hellmann lesen Textschlüssel aus Textfeld
     H*            Wenn gültiger Schlüssel, dann aus Text entfernen und Resttext
     H*            mit diesem Schlüssel übergeben.
     H*  Änderung: SZ 04.10.2012 Projekt 8581, SR ERNABT angepasst. Feld WKNABT
     H*            wird jetzt ausser bei PartsExpress auch in weiteren Schnitt-
     H*            stellenfiles übergeben. Ob es sich um eine Nachnahme handelt
     H*            wird über ERZABD ermittelt.
     H*  Änderung: SZ 30.11.2012 Projekt 9128, neue Schnittstelle BRT
     H*  Änderung: SZ 04.12.2012 Übergabe nur für Firma '01' bzw. '51'
     H*  Änderung: SZ 20.12.2012 Projekt 9128, zusätzliche Textfelder
     H*  Änderung: SZ 27.01.2013 Projekt 9032, Abfrage "Parts Express" Firma
     H*            '52', Nachnahme "Parts Express" dort auch Standard, nicht
     H*            WAO8
     H*  Änderung: SZ 31.01.2013 Projekt 9032, für Firma '08' und '52' auch
     H*            Schnittstellendaten übergeben. KDNR = 7-stellig!
     H*  Änderung: MG 31.01.2013 Projekt 9032, Speichern LS-Nr
     H*  Änderung: SZ 03.02.2013 Projekt 9286, Sendungsnummer SPDP zum Jahres-
     H*            anfang weiterzählen.
     H*  Änderung: SZ 07.02.2013 Projekt 9032, Schnittstelle Parts Express,
     H*            Anpassung Struktur wegen PLZ
     H*  Änderung: SZ 07.02.2013 Projekt 9032, Schnittstelle Parts Express,
     H*            Anpassung Struktur wegen PLZ
     H*  Änderung: SZ 12.02.2013 Projekt 9032, Schnittstelle Parts Express,
     H*            Anpassung Versandweg DAGB, usw.
     H*  Änderung: SZ 27.02.2013 Projekt 9032, Schnittstelle Parts Express,
     H*            Anpassung Versandweg DAGB, usw. wenn Auftrag aus Firma '01'
     H*  Änderung: SZ 04.03.2013 Projekt 8997, Schnittstelle TNT
     H*  Änderung: SZ 11.03.2013 Projekt 8997, WAOS für Leitgebiet TNT
     H*  Änderung: SZ 25.03.2013 Projekt 8997, Gewicht mit 3 Nachkommastellen
     H*  Änderung: SZ 02.04.2013 Projekt 8997, Gewicht für TNT mindestens 0,01kg
     H*  Änderung: SZ 22.04.2013 Projekt 9228, Spedition Loxx (Österreich)
     H*  Änderung: SZ 08.08.2013 Service 20130628-010, Adresse aus AFAD statt
     H*            aus AFKM.
     H*  Änderung: SZ 11.04.2013 Anforderung Hr. Gang, Nachnahme für SCs (NABT1)
     H*  Änderung: SZ 20.05.2013 Anforderung Hr. Gang, Nachnahmebetrag DPD ist
     H*            ohne Nachkommastellen. Daher * 100.
     H*  Änderung: SZ 23.05.2013 Projekt 10511, Gewichtfelder in SPED50 auch
     H*            ohne Nachkommastellen. Daher * 100. (DPD055)
     H*  Änderung: SZ 02.06.2013 Projekt 10511, zusätzliche SCs für Nachnahme
     H*  Änderung: RE 27.08.2014 Service 20140826-014
     H*  Änderung: ZG 09.07.2021 Service Service#: 20210709-012 Abbruch TRSP16
     H*            Anzahl Lieferschein beschränkt auf 99
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm erstellt die Datei für die Übergabe der Versanddaten
     F*  an die Speditionen. Als Selektionsprogramm dient TRSP15.
     F*  Die Selektionsparameter werden über EXSP16 an dieses Programm über-
     F*  geben.
     F*
     F*  Die Verarbeitung über dieses Programm wird durchgeführt für Firma
     F*  01 WAECO
     F*  08 Dometic BE
     F*  51 Dometic WAECO (neu)
     F*  52 Dometic NL
     F*
     F*  Zur Ansteuerung spezifischer Routinen werden im Programm verschiedene
     F*  Spediteurnummern einzeln abgefragt.
     F*  Die zentrale Steuerung zur Verteilung der Daten erfolgt in Routine
     F*  'VERTEIL':
     F*  ASSPED = '90164' SPED00 Gebr. Hellmann Osnabrück     AUSGM400
     F*  ASSPED = '92215' SPED00 Gebr. Hellmann Osnabrück UK  AUSGM400
     F*  ASSPED = '92219' SPED00 Hellmann Osnabrück Hagebau   AUSGM400
     F*  ASSPED = '92221' SPED00 Hellmann Dometic Siegen      AUSGM400
     F*  ASSPED = '92213' SPED10 PartsExpress                 AUSGM410
     F*  ASSPED = '90163' SPED20 Hamacher Logistik Gronau     AUSGM420
     F*  ASSPED = '90864' SPED30 trans-o-flex Weinheim        AUSGM430
     F*  ASSPED = '90748' SPED40 General Logistics Systems    AUSGM440
     F*  ASSPED = '91258' SPED40 GLS Market Intervention      AUSGM440
     F*  ASSPED = '92220' SPED40 GLS Dometic Siegen           AUSGM440
     F*  ASSPED = '92214' SPED50 DPD Bad Bentheim             AUSGM450
     F*  ASSPED = '90292' SPED60 Georg Boll GmbH Meppen       AUSGM460
     F*  ASSPED = '     ' SPED70 Adlatus                      AUSGM470
     F*  ASSPED = '90330' SPED80 Dachser                      AUSGM480
     F*  ASSPED = '92217' SPEDA0 Hellmann Aktion              AUSGM4A0
     F*  ASSPED = '92216' SPEDB0 DPD Aktion                   AUSGM4B0
     F*  ASSPED = '90796' SPEDC0 NightStar                    AUSGM4C0
     F*  ASSPED = '90481' SPEDD0 DB Schenker (Obi)            AUSGM4D0
     F*  ASSPED = '92222' SPEDF0 Kühne + Nagel Greven         AUSGM4F0
     F*  ASSPED = '92224' SPEDG0 DB Schenker                  AUSGM4G0
     F*  ASSPED = '92225' SPEDH0 BRT Italien                  AUSGM4H0
     F*  ASSPED = '90169' SPEDI0 TNT Innight GmbH, Mannheim   AUSGM4I0
     F*  ASSPED = '92230' SPEDK0 LOXX Gelsenkirchen           AUSGM4K0
     F*
     F*  Für PartsExpress werden anhand der unterschiedlichen Versandbedingungen
     F*  und des Versandlands Werte für die Versandart umgesetzt
     F*  wenn AMVSBD = '578' dann WKVSCD = 'DAYB '
     F*  wenn AMVSBD = '579' dann WKVSCD = 'DAGL '
     F*  wenn AMVSBD = '580' dann WKVSCD = 'NACHT'
     F*  wenn AMVSBD = '581' dann WKVSCD = 'NACHB'
     F*  wenn AMVSBD = '582' dann WKVSCD = 'NACHL'
     F*  wenn WKPOLD = 'BE ' dann WKVSCD = 'DAYB '
     F*  wenn WKPOLD = 'LU ' dann WKVSCD = 'DAGL '
     F*  sonst WKVSCD = 'DAG  '
     F*
     F*  Die Ansteuerung der Routinen zur Ermittlung des Nachnahmebetrags erfolgt
     F*  anhand der Kundennummern der SCs.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FSPED00    O  A E           K DISK                                         HELLMANN
     FSPED10    O  A E           K DISK    PREFIX(S10:3)                        PARTS EXPRESS
     FSPED20    O  A E           K DISK                                         HAMACHER
     FSPED30    O  A E           K DISK    PREFIX(S30:3)                        TRANS-O-FLEX
     FSPED40    O  A E           K DISK    RENAME(HEL00R1:SPED401)              GERMAN PARCEL/GLS
     FSPED50    O  A E           K DISK                                         DPD
     FSPED60    O  A E           K DISK    PREFIX(S60:3)                        BOLL/UNITRANS
     FSPED70    O  A E           K DISK    RENAME(ROOY0R1:SPED701)              ADLATUS
     F                                     PREFIX(S70:3)
     FSPED80    O  A E           K DISK                                         DACHSER
     FSPEDA0    O  A E           K DISK    RENAME(HCI_F0:SPEDA01)               HELLMANN AKTION
     F                                     PREFIX(SA0:3)
     FSPEDB0    O  A E           K DISK    RENAME(DPD00R1:SPEDB01)              DPD AKTION
     F                                     PREFIX(SB0:3)
     FSPEDC0    O  A E           K DISK                                         NIGHTSTAR
     FSPEDD0    O  A E           K DISK                                         SCHENKER OBI
     FSPEDF0    O  A E           K DISK                                         KÜHNE+NAGEL
     FSPEDG0    O  A E           K DISK                                         SCHENKER
     FSPEDH0    O  A E           K DISK                                         BRT ITALIEN
     FSPEDI0    O  A E           K DISK                                         TNT
     FSPEDK0    O  A E           K DISK                                         LOXX
     F*
     FTRSP16DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D W100            S              1    DIM(100)                             FELDGRUPPE DATEN
     D KON             S             40    DIM(100)                             TEXT KONST. FELDG
     D*
     D FGCODP          S                   DIM(999) LIKE(WAO8CODP)
     D FGCODU          S                   DIM(999) LIKE(WAO8CODU)
     D FGAFPO          S                   DIM(999) LIKE(WAO8AFPO)
     D FGIFPO          S                   DIM(999) LIKE(WAO8IFPO)
     D FGKMJJ          S                   DIM(999) LIKE(WAO8KMJJ)
     D FGKMNR          S                   DIM(999) LIKE(WAO8KMNR)
     D FGBSMG          S                   DIM(999) LIKE(IFAPBSMG)
     D FGGLMG          S                   DIM(999) LIKE(ALGLMG)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D AFVS          E DS                  INZ
     D KYAFVS        E DS                  INZ
     D*
     D IFAK          E DS                  INZ
     D KYIFAK        E DS                  INZ
     D*
     D IFAP          E DS                  INZ
     D KYIFAP        E DS                  INZ
     D*
     D IFAT          E DS                  INZ
     D KYIFAT        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D LPIF          E DS                  INZ
     D KYLPIF        E DS                  INZ
     D*
     D SPDA          E DS                  INZ
     D KYSPDA        E DS                  INZ
     D*
     D SPDP          E DS                  INZ
     D KYSPDP        E DS                  INZ
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
     D TXBE          E DS                  INZ
     D KYTXBE        E DS                  INZ
     D*
     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ
     D*
     D WAOB          E DS                  INZ
     D KYWAOB        E DS                  INZ
     D*
     D WAOH          E DS                  INZ
     D KYWAOH        E DS                  INZ
     D*
     D WAOI          E DS                  INZ
     D KYWAOI        E DS                  INZ
     D*
     D WAOJ          E DS                  INZ
     D KYWAOJ        E DS                  INZ
     D*
     D WAOS          E DS                  INZ
     D KYWAOS        E DS                  INZ
     D*
     D WAO8          E DS                  INZ
     D KYWAO8        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D ZKUN          E DS                  INZ
     D KYZKUN        E DS                  INZ
     D*
     D ZABD          E DS                  INZ
     D KYZABD        E DS                  INZ
     D*
     D**************************************************************************
     D***  KONSTANTE                                                         ***
     D**************************************************************************
     D UP              C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ-
     D                                     [\]')
     D LO              C                   CONST('abcdefghijklmnopqrstuvwxyzäöü-
     D                                     {¦}')
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXSP16        E DS
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXAFKN        E DS                  INZ
     D RTAFKN        E DS                  INZ
     D*
     D EXZABD        E DS                  INZ
     D RTZABD        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D  WKDATE         S               D   DATFMT(*EUR) INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
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
     C                   PARM                    EXSP16
     C*
     C                   EXSR      UEBDTA
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   IF        DAFIRM     <> '01'          AND
     C                             DAFIRM     <> '08'          AND
     C                             DAFIRM     <> '51'          AND
     C                             DAFIRM     <> '52'
     C                   EVAL      *INLR       = *ON
     C                   RETURN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C                   EXSR      ERMKO                                        TEXTKONSTANTEN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KON(14)       WKIUPD                         KZ UPDATE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C                   WHEN      EXSP16PGST  = 'EINZEL'
     C                   EVAL      EXSP16BOKZ  = DANEKZ
     C                   EXSR      EAFSP
     C                   OTHER
     C                   EXSR      OAFSP                                        ÖFFNEN AFSPC1
     C                   EXSR      VAFSP                                        VERARB.AFSPC1
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
     C                   Z-ADD     *ZERO         WKN032            3 2
     C                   Z-ADD     *ZERO         WKN043            4 3
     C                   Z-ADD     *ZERO         WKN110           11 0
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKZEZA
     C                   Z-ADD     *ZERO         DSZEZA
     C                   MOVE      *OFF          W1KOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYADFI                         AFAD
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYKLFI                         AFLK
     C                   MOVEL(P)  DAFIRM        KYALFI                         AFLP
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYASFI                         AFSP
     C                   MOVEL(P)  DAFIRM        KYAVFI                         AFVS
     C                   MOVEL(P)  DAFIRM        KYIFAPFIRM                     IFAP
     C                   MOVEL(P)  DAFIRM        KYIFAKFIRM                     IFAK
     C                   MOVEL(P)  DAFIRM        KYIFATFIRM                     IFAT
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYLPFI                         LPIF
     C                   MOVEL(P)  DAFIRM        KYSPDAFIRM                     SPDA
     C                   MOVEL(P)  DAFIRM        KYSPDPFIRM                     SPDP
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTBFI                         TXBE
     C                   MOVEL(P)  DAFIRM        KYVBFI                         VSBD
     C                   MOVEL(P)  DAFIRM        KYWAOBFIRM                     WAOB
     C                   MOVEL(P)  DAFIRM        KYWAO8FIRM                     WAO8
     C                   MOVEL(P)  DAFIRM        KYWAOHFIRM                     WAOH
     C                   MOVEL(P)  DAFIRM        KYWAOIFIRM                     WAOI
     C                   MOVEL(P)  DAFIRM        KYWAOJFIRM                     WAOJ
     C                   MOVEL(P)  DAFIRM        KYWAOSFIRM                     WAOS
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C                   MOVEL(P)  DAFIRM        KYKZFI                         ZKUN
     C                   MOVEL     DAFIRM        KYZBFI                         ZABD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKSAZA
     C                   Z-ADD     *ZERO         W1DATE
     C                   Z-ADD     *ZERO         WKANZA
     C                   Z-ADD     *ZERO         WKAZPL
     C                   Z-ADD     *ZERO         WKAZAF                         ANZAHL AUFTRÄGE
     C                   Z-ADD     *ZERO         WKAZCO                         ANZAHL COLLI
     C                   Z-ADD     *ZERO         WKGSGW                         GESAMTGEWICHT
     C                   Z-ADD     *ZERO         WKGLMG
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I1
     C                   Z-ADD     *ZERO         I2
     C                   Z-ADD     *ZERO         I3
     C                   Z-ADD     *ZERO         I4
     C                   Z-ADD     *ZERO         I5
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKKOPF
     C                   MOVE      *BLANK        WKAFVS
     C                   MOVE      *BLANK        W1AFVS
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C     *JOBRUN       MOVE      DUN060        WKDATE
     C                   MOVEL     DUN120        PTTIME
     C                   MOVE      WKTDAT        W1DATE
     C                   MOVE      WKTDAT        #CDATV
     C                   MOVEL(P)  '*ISO'        #CFMTV
     C                   MOVEL(P)  '*EUR'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        PTDATE
     C                   MOVE      WKTDAT        #CDATV
     C                   MOVEL(P)  '*ISO'        #CFMTV
     C                   MOVEL(P)  '*DMY'        #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVEL     #CDATN        WKDAT1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             PTSEIT
     C*-------------------------------------------------------------------------
     C                   EVAL      EXFIRMFIRM = DAFIRM
     C                   EXSR      PRFIRMFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXSP16SPE1    SP16BSP1
     C                   MOVEL(P)  EXSP16SPE2    SP16BSP2
     C                   MOVEL(P)  EXSP16SPE3    SP16BSP3
     C*
     C                   Z-ADD     EXSP16AJ10    SP16BJ10
     C                   Z-ADD     EXSP16AJ11    SP16BJ11
     C                   Z-ADD     EXSP16AJ12    SP16BJ12
     C                   Z-ADD     EXSP16AJ13    SP16BJ13
     C                   Z-ADD     EXSP16AJ14    SP16BJ14
     C                   Z-ADD     EXSP16AJ15    SP16BJ15
     C                   Z-ADD     EXSP16AJ16    SP16BJ16
     C                   Z-ADD     EXSP16AJ17    SP16BJ17
     C                   Z-ADD     EXSP16AJ18    SP16BJ18
     C                   Z-ADD     EXSP16AJ19    SP16BJ19
     C*
     C                   MOVEL(P)  EXSP16AN10    SP16BN10
     C                   MOVEL(P)  EXSP16AN11    SP16BN11
     C                   MOVEL(P)  EXSP16AN12    SP16BN12
     C                   MOVEL(P)  EXSP16AN13    SP16BN13
     C                   MOVEL(P)  EXSP16AN14    SP16BN14
     C                   MOVEL(P)  EXSP16AN15    SP16BN15
     C                   MOVEL(P)  EXSP16AN16    SP16BN16
     C                   MOVEL(P)  EXSP16AN17    SP16BN17
     C                   MOVEL(P)  EXSP16AN18    SP16BN18
     C                   MOVEL(P)  EXSP16AN19    SP16BN19
     C*
     C                   Z-ADD     EXSP16AJ20    SP16BJ20
     C                   Z-ADD     EXSP16AJ21    SP16BJ21
     C                   Z-ADD     EXSP16AJ22    SP16BJ22
     C                   Z-ADD     EXSP16AJ23    SP16BJ23
     C                   Z-ADD     EXSP16AJ24    SP16BJ24
     C                   Z-ADD     EXSP16AJ25    SP16BJ25
     C                   Z-ADD     EXSP16AJ26    SP16BJ26
     C                   Z-ADD     EXSP16AJ27    SP16BJ27
     C                   Z-ADD     EXSP16AJ28    SP16BJ28
     C                   Z-ADD     EXSP16AJ29    SP16BJ29
     C*
     C                   MOVEL(P)  EXSP16AN20    SP16BN20
     C                   MOVEL(P)  EXSP16AN21    SP16BN21
     C                   MOVEL(P)  EXSP16AN22    SP16BN22
     C                   MOVEL(P)  EXSP16AN23    SP16BN23
     C                   MOVEL(P)  EXSP16AN24    SP16BN24
     C                   MOVEL(P)  EXSP16AN25    SP16BN25
     C                   MOVEL(P)  EXSP16AN26    SP16BN26
     C                   MOVEL(P)  EXSP16AN27    SP16BN27
     C                   MOVEL(P)  EXSP16AN28    SP16BN28
     C                   MOVEL(P)  EXSP16AN29    SP16BN29
     C*
     C                   Z-ADD     EXSP16AJ30    SP16BJ30
     C                   Z-ADD     EXSP16AJ31    SP16BJ31
     C                   Z-ADD     EXSP16AJ32    SP16BJ32
     C                   Z-ADD     EXSP16AJ33    SP16BJ33
     C                   Z-ADD     EXSP16AJ34    SP16BJ34
     C                   Z-ADD     EXSP16AJ35    SP16BJ35
     C                   Z-ADD     EXSP16AJ36    SP16BJ36
     C                   Z-ADD     EXSP16AJ37    SP16BJ37
     C                   Z-ADD     EXSP16AJ38    SP16BJ38
     C                   Z-ADD     EXSP16AJ39    SP16BJ39
     C*
     C                   MOVEL(P)  EXSP16AN30    SP16BN30
     C                   MOVEL(P)  EXSP16AN31    SP16BN31
     C                   MOVEL(P)  EXSP16AN32    SP16BN32
     C                   MOVEL(P)  EXSP16AN33    SP16BN33
     C                   MOVEL(P)  EXSP16AN34    SP16BN34
     C                   MOVEL(P)  EXSP16AN35    SP16BN35
     C                   MOVEL(P)  EXSP16AN36    SP16BN36
     C                   MOVEL(P)  EXSP16AN37    SP16BN37
     C                   MOVEL(P)  EXSP16AN38    SP16BN38
     C                   MOVEL(P)  EXSP16AN39    SP16BN39
     C*-------------------------------------------------------------------------
     C     EXSP16SPE1    IFEQ      *BLANK
     C     EXSP16SPE2    ANDEQ     *BLANK
     C     EXSP16SPE3    ANDEQ     *BLANK
     C                   MOVE      *HIVAL        SP16BSP1
     C                   MOVE      *HIVAL        SP16BSP2
     C                   MOVE      *HIVAL        SP16BSP3
     C                   ENDIF
     C*--------------------------------------------------------
     C     EXSP16AN10    IFEQ      *BLANK
     C     EXSP16AN11    ANDEQ     *BLANK
     C     EXSP16AN12    ANDEQ     *BLANK
     C     EXSP16AN13    ANDEQ     *BLANK
     C     EXSP16AN14    ANDEQ     *BLANK
     C     EXSP16AN15    ANDEQ     *BLANK
     C     EXSP16AN16    ANDEQ     *BLANK
     C     EXSP16AN17    ANDEQ     *BLANK
     C     EXSP16AN18    ANDEQ     *BLANK
     C     EXSP16AN19    ANDEQ     *BLANK
     C                   MOVE      *HIVAL        SP16BJ10
     C                   MOVE      *HIVAL        SP16BN10
     C                   ENDIF
     C*--------------------------------------------------------
     C     EXSP16AN20    IFEQ      *BLANK
     C     EXSP16AN21    ANDEQ     *BLANK
     C     EXSP16AN22    ANDEQ     *BLANK
     C     EXSP16AN23    ANDEQ     *BLANK
     C     EXSP16AN24    ANDEQ     *BLANK
     C     EXSP16AN25    ANDEQ     *BLANK
     C     EXSP16AN26    ANDEQ     *BLANK
     C     EXSP16AN27    ANDEQ     *BLANK
     C     EXSP16AN28    ANDEQ     *BLANK
     C     EXSP16AN29    ANDEQ     *BLANK
     C                   MOVE      *HIVAL        SP16BJ20
     C                   MOVE      *HIVAL        SP16BN20
     C                   ENDIF
     C*--------------------------------------------------------
     C     EXSP16AN30    IFEQ      *BLANK
     C     EXSP16AN31    ANDEQ     *BLANK
     C     EXSP16AN32    ANDEQ     *BLANK
     C     EXSP16AN33    ANDEQ     *BLANK
     C     EXSP16AN34    ANDEQ     *BLANK
     C     EXSP16AN35    ANDEQ     *BLANK
     C     EXSP16AN36    ANDEQ     *BLANK
     C     EXSP16AN37    ANDEQ     *BLANK
     C     EXSP16AN38    ANDEQ     *BLANK
     C     EXSP16AN39    ANDEQ     *BLANK
     C                   MOVE      *HIVAL        SP16BJ30
     C                   MOVE      *HIVAL        SP16BN30
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXSP16WPNR    PTWPNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN TEXT-KONSTANTEN                                         ***
     C**************************************************************************
     C     ERMKO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C                   MOVEL(P)  'TRSP16'      KYTPTA
     C                   MOVEL(P)  'TRSP16'      KYTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYTPFI        OFTPFI
     C                   MOVEL(P)  KYTPSP        OFTPSP
     C                   MOVEL(P)  KYTPTA        OFTPTA
     C                   MOVEL(P)  KYTPTC        OFTPTC
     C*
     C                   MOVE      *BLANK        KON
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C                   DO        100           I1
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C*--------------------------------------------------------
     C     TPFIRM        IFGT      OFTPFI                                       URSPRUNGSGRENZE
     C     TPSPCD        ORGT      OFTPSP                                       ÜBERSCHRITTEN
     C     TPTART        ORGT      OFTPTA
     C     TPTCDE        ORGT      OFTPTC
     C     CHI(5)        OREQ      'N'
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  TPTTXT        KON(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KON(01)       KON001
     C                   MOVEL(P)  KON(02)       KON002
     C                   MOVEL(P)  KON(03)       KON003
     C                   MOVEL(P)  KON(04)       KON004
     C                   MOVEL(P)  KON(05)       KON005
     C                   MOVEL(P)  KON(06)       KON006
     C                   MOVEL(P)  KON(07)       KON007
     C                   MOVEL(P)  KON(08)       KON008
     C                   MOVEL(P)  KON(09)       KON009
     C                   MOVEL(P)  KON(10)       KON010
     C                   MOVEL(P)  KON(15)       KON015
     C                   MOVEL(P)  KON(16)       KON016
     C                   MOVEL(P)  KON(17)       KON017
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        W1KOPF                         ERSTER ZYKLUS
     C     *LIKE         DEFINE    WKC001        WKIAFL                         SATZ IN AFLP
     C     *LIKE         DEFINE    WKC001        WKISUM                         SUMMENSATZ AUSG
     C     *LIKE         DEFINE    WKC001        WKIARK                         IND.ZUGRIFF RECHNUNG
     C     *LIKE         DEFINE    WKC001        WKIBER                         IND.BERECHNEN NACHN.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC014          +13            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKC033          +32            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKKOPF                         DRUCKKOPF
     C     *LIKE         DEFINE    WKC001        WKAFVS
     C     *LIKE         DEFINE    WKC001        W1AFVS
     C     *LIKE         DEFINE    WKC001        WKC003          + 2            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKILFT                         KENNZ. LF-TERMIN
     C     *LIKE         DEFINE    WKC001        WKSPFI          +10            KDNR BEI SPEDITIO
     C     *LIKE         DEFINE    WKC001        WKIUPD                         KZ UPDATE
     C     *LIKE         DEFINE    WKC001        WKTXBE                         KZ TXBE
     C     *LIKE         DEFINE    WKC001        WKFRAN          + 1            FRANKATUR
     C     *LIKE         DEFINE    WKC001        WKFRA1                         FRANKATUR
     C     *LIKE         DEFINE    WKC001        WKCDVP          + 1            CODE VERPACKUNG
     C     *LIKE         DEFINE    WKC001        WKCODE          + 2            WERK CODE
     C     *LIKE         DEFINE    WKC001        WKREFN          +14            REFERENZ
     C     *LIKE         DEFINE    WKC001        WKDAT1          + 5            DATUM 6-STELLIG
     C     *LIKE         DEFINE    WKC001        WKILNW          + 6            ILN WAECO
     C     *LIKE         DEFINE    WKC001        WKILNE          +19            ILN EMPFÄNGER
     C     *LIKE         DEFINE    WKC001        WKSSCC          +19            SSCC
     C     *LIKE         DEFINE    WKC001        WKBARC          +23            BARCODE
     C     *LIKE         DEFINE    WKC001        WKLGEB          + 7            LEITGEBIET
     C     *LIKE         DEFINE    WKC001        WKFACH          + 3            ABSTELLFACH
     C     *LIKE         DEFINE    WKC001        WKPLZL          + 9            PLZ LANG
     C     *LIKE         DEFINE    WKC001        WKLFTE          + 7            LIEFERTERMIN
     C     *LIKE         DEFINE    WKC001        WKLFT2          + 7            LIEFERTERMIN
     C     *LIKE         DEFINE    WKC001        WKLANG          + 4            LÄNGE
     C     *LIKE         DEFINE    WKC001        WKBREI          + 4            BREITE
     C     *LIKE         DEFINE    WKC001        WKHOHE          + 4            HÖHE
     C     *LIKE         DEFINE    WKC001        WKTNR1          + 2            TEXTNR.1
     C     *LIKE         DEFINE    WKC001        WKTNR2          + 2            TEXTNR.2
     C     *LIKE         DEFINE    WKC001        WKTNR3          + 2            TEXTNR.3
     C     *LIKE         DEFINE    WKC001        WKTNR4          + 2            TEXTNR.4
     C     *LIKE         DEFINE    WKC001        WKTNR5          + 2            TEXTNR.5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        TXPRGR          +14            TEXT PRODUKTGRUPPE
     C     *LIKE         DEFINE    WKC001        TXMCBG          + 9            TEXT MATCHCODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIGST                         IND.GESCHÄFTSSTELLE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKTN2          + 1            KETTE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX 2
     C     *LIKE         DEFINE    WKN010        I3              + 2            INDEX 3
     C     *LIKE         DEFINE    WKN010        I4              + 2            INDEX 4
     C     *LIKE         DEFINE    WKN010        I5              + 2            INDEX 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKSAZA          + 5
     C     *LIKE         DEFINE    WKN010        W1DATE          + 7
     C     *LIKE         DEFINE    WKN010        WKANZA          + 2
     C     *LIKE         DEFINE    WKN010        WKAZPL          + 2
     C     *LIKE         DEFINE    WKN010        WKAZAF          + 4            ANZAHL AUFTRÄGE
     C     *LIKE         DEFINE    WKN010        WKAZCO          + 4            ANZAHL COLLI
     C     *LIKE         DEFINE    WKN010        WKGWBR          + 4
     C     *LIKE         DEFINE    WKN010        WKGWPL          + 4
     C     *LIKE         DEFINE    WKN010        WKGWNT          + 6
     C     *LIKE         DEFINE    WKN010        WKGEWI          + 6
     C     *LIKE         DEFINE    WKN010        WKGSGW          +17            GESAMTGEWICHT
     C     *LIKE         DEFINE    WKN010        WKZEZA          + 2            WORK ZEILENZÄHL
     C     *LIKE         DEFINE    WKN010        DSZEZA          + 2            ZEILENZÄHL.GES.
     C     *LIKE         DEFINE    WKN010        WKN050          + 4            WORKFELD
     C     *LIKE         DEFINE    WKN010        WKLFDN          + 9            ZÄHLER
     C     *LIKE         DEFINE    WKN010        WKZUGR          + 1
     C     *LIKE         DEFINE    WKN010        WKAZLS          + 1            ANZAHL LIEFERSCHEINE
     C*
     C     *LIKE         DEFINE    WKN032        WKGWB2          + 2
     C     *LIKE         DEFINE    WKN043        WKGWB3          + 4
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXSP16SPE1    SP16BSP1
     C     *LIKE         DEFINE    EXSP16SPE1    SP16BSP2
     C     *LIKE         DEFINE    EXSP16SPE1    SP16BSP3
     C*
     C     *LIKE         DEFINE    EXSP16AJ10    SP16BJ10
     C     *LIKE         DEFINE    EXSP16AJ11    SP16BJ11
     C     *LIKE         DEFINE    EXSP16AJ12    SP16BJ12
     C     *LIKE         DEFINE    EXSP16AJ13    SP16BJ13
     C     *LIKE         DEFINE    EXSP16AJ14    SP16BJ14
     C     *LIKE         DEFINE    EXSP16AJ15    SP16BJ15
     C     *LIKE         DEFINE    EXSP16AJ16    SP16BJ16
     C     *LIKE         DEFINE    EXSP16AJ17    SP16BJ17
     C     *LIKE         DEFINE    EXSP16AJ18    SP16BJ18
     C     *LIKE         DEFINE    EXSP16AJ19    SP16BJ19
     C*
     C     *LIKE         DEFINE    EXSP16AN10    SP16BN10
     C     *LIKE         DEFINE    EXSP16AN11    SP16BN11
     C     *LIKE         DEFINE    EXSP16AN12    SP16BN12
     C     *LIKE         DEFINE    EXSP16AN13    SP16BN13
     C     *LIKE         DEFINE    EXSP16AN14    SP16BN14
     C     *LIKE         DEFINE    EXSP16AN15    SP16BN15
     C     *LIKE         DEFINE    EXSP16AN16    SP16BN16
     C     *LIKE         DEFINE    EXSP16AN17    SP16BN17
     C     *LIKE         DEFINE    EXSP16AN18    SP16BN18
     C     *LIKE         DEFINE    EXSP16AN19    SP16BN19
     C*
     C     *LIKE         DEFINE    EXSP16AJ20    SP16BJ20
     C     *LIKE         DEFINE    EXSP16AJ21    SP16BJ21
     C     *LIKE         DEFINE    EXSP16AJ22    SP16BJ22
     C     *LIKE         DEFINE    EXSP16AJ23    SP16BJ23
     C     *LIKE         DEFINE    EXSP16AJ24    SP16BJ24
     C     *LIKE         DEFINE    EXSP16AJ25    SP16BJ25
     C     *LIKE         DEFINE    EXSP16AJ26    SP16BJ26
     C     *LIKE         DEFINE    EXSP16AJ27    SP16BJ27
     C     *LIKE         DEFINE    EXSP16AJ28    SP16BJ28
     C     *LIKE         DEFINE    EXSP16AJ29    SP16BJ29
     C*
     C     *LIKE         DEFINE    EXSP16AN10    SP16BN20
     C     *LIKE         DEFINE    EXSP16AN11    SP16BN21
     C     *LIKE         DEFINE    EXSP16AN12    SP16BN22
     C     *LIKE         DEFINE    EXSP16AN13    SP16BN23
     C     *LIKE         DEFINE    EXSP16AN14    SP16BN24
     C     *LIKE         DEFINE    EXSP16AN15    SP16BN25
     C     *LIKE         DEFINE    EXSP16AN16    SP16BN26
     C     *LIKE         DEFINE    EXSP16AN17    SP16BN27
     C     *LIKE         DEFINE    EXSP16AN18    SP16BN28
     C     *LIKE         DEFINE    EXSP16AN19    SP16BN29
     C*
     C     *LIKE         DEFINE    EXSP16AJ30    SP16BJ30
     C     *LIKE         DEFINE    EXSP16AJ31    SP16BJ31
     C     *LIKE         DEFINE    EXSP16AJ32    SP16BJ32
     C     *LIKE         DEFINE    EXSP16AJ33    SP16BJ33
     C     *LIKE         DEFINE    EXSP16AJ34    SP16BJ34
     C     *LIKE         DEFINE    EXSP16AJ35    SP16BJ35
     C     *LIKE         DEFINE    EXSP16AJ36    SP16BJ36
     C     *LIKE         DEFINE    EXSP16AJ37    SP16BJ37
     C     *LIKE         DEFINE    EXSP16AJ38    SP16BJ38
     C     *LIKE         DEFINE    EXSP16AJ39    SP16BJ39
     C*
     C     *LIKE         DEFINE    EXSP16AN10    SP16BN30
     C     *LIKE         DEFINE    EXSP16AN11    SP16BN31
     C     *LIKE         DEFINE    EXSP16AN12    SP16BN32
     C     *LIKE         DEFINE    EXSP16AN13    SP16BN33
     C     *LIKE         DEFINE    EXSP16AN14    SP16BN34
     C     *LIKE         DEFINE    EXSP16AN15    SP16BN35
     C     *LIKE         DEFINE    EXSP16AN16    SP16BN36
     C     *LIKE         DEFINE    EXSP16AN17    SP16BN37
     C     *LIKE         DEFINE    EXSP16AN18    SP16BN38
     C     *LIKE         DEFINE    EXSP16AN19    SP16BN39
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AKMAAF        WKMAAF
     C     *LIKE         DEFINE    AKMAAF        WKMAA2
     C     *LIKE         DEFINE    AKREF1        WKREF1
     C     *LIKE         DEFINE    AKWACD        WKWACD
     C     *LIKE         DEFINE    AKZABD        WKZABD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    ASNUMM        WKNUMM
     C     *LIKE         DEFINE    ASSPED        WKSPED
     C     *LIKE         DEFINE    ASPLAZ        WKPLAZ
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AMJDAT        WKJDAT
     C     *LIKE         DEFINE    AMJZEI        WKJZEI
     C     *LIKE         DEFINE    AMNAM1        WKNAM1
     C     *LIKE         DEFINE    AMNAM2        WKNAM2
     C     *LIKE         DEFINE    AMNAM3        WKNAM3
     C     *LIKE         DEFINE    AMSTRA        WKSTRA
     C     *LIKE         DEFINE    AMPOLD        WKPOLD
     C     *LIKE         DEFINE    AMPOLD        W2POLD
     C     *LIKE         DEFINE    AMPOLZ        WKPOLZ
     C     *LIKE         DEFINE    AMWORT        WKWORT
     C     *LIKE         DEFINE    AMPOFA        WKPOFA
     C     *LIKE         DEFINE    AMTOUR        WKTOUR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    ALRGJJ        WKRGJJ
     C     *LIKE         DEFINE    ALRGNR        WKRGNR
     C     *LIKE         DEFINE    ALLIJJ        WKLIJJ
     C     *LIKE         DEFINE    ALLINR        WKLINR
     C     *LIKE         DEFINE    ALGLMG        WKGLMG                         UMG. MENGE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    TETENR        WKTENR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    LFKNAM        WKKNAM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTLNR          +19            Telefonnummer Avis
     C     *LIKE         DEFINE    IFATTEXT      WKTXT1
     C     *LIKE         DEFINE    IFATTEXT      WKTXT2
     C     *LIKE         DEFINE    IFATTEXT      WKTXT3
     C     *LIKE         DEFINE    IFATTEXT      WKTXT4
     C     *LIKE         DEFINE    IFATTEXT      WKTXT5
     C     *LIKE         DEFINE    IFATIFZN      WKIFATZN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    SPDPSPSN      WKSPSN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAO8SPWG      WKVSCD
     C     *LIKE         DEFINE    WAO8CODW      WKCODW
     C     *LIKE         DEFINE    WAO8CODS      WKCODS
     C     *LIKE         DEFINE    WAO8CODM      WKCODM
     C     *LIKE         DEFINE    WAO8CODB      WKCODB
     C     *LIKE         DEFINE    WAO8CODB      WKNABT
     C     *LIKE         DEFINE    WAO8CODV      WKCODV
     C     *LIKE         DEFINE    WAO8CODK      WKCODK
     C     *LIKE         DEFINE    WAO8CODI      WKCODI
     C     *LIKE         DEFINE    WAO8CODP      WKCODP
     C     *LIKE         DEFINE    WAO8CODU      WKCODU
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOIGENR      WKGST1          + 1            Gesch.Stelle 1
     C     *LIKE         DEFINE    WAOIGENR      WKGST2                         Gesch.Stelle 2
     C     *LIKE         DEFINE    WAOITOUR      WKTOUR                         Tour
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOJKTNR      WKKTNR
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB1
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOSRLTN      WKRLTN
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN134        WKBETR
     C     *LIKE         DEFINE    DUN134        WKMWST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERSTELLEN CURSOR AFSPC1 AUS AFSP UND AFKM                         ***
     C**************************************************************************
     C     OAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE AFSPC1 CURSOR FOR SELECT * FROM AFSP,AFKM WHERE
     C+   AMFIRM     =  :DAFIRM     AND
     C+   AMLOCK     =  ' '         AND
     C+   AMWKVS     =  :EXSP16WKNR AND
     C+   AMKMDA     <= :EXSP16GADA AND
     C+   ASJAHR     =   AMKMJJ     AND
     C+   ASNUMM     =   AMKMNR     AND
     C+   ASKART     =  'KMNR'      AND
     C+   ASFIRM     =  :DAFIRM     AND
     C+   ASLOCK     =  ' '         AND
     C+   ASSPED     <> ' '         AND
     C+   ASSTAT     =  '  '        AND
     C+   ASPENR     <> ' '         AND
     C+ (((:EXSP16SPE1 =  '          ' AND
     C+    ASSPED BETWEEN :EXSP16SPE1  AND :SP16BSP1)            OR
     C+  (:EXSP16SPE1 <> '          '  AND  ASSPED = :EXSP16SPE1 AND
     C+ ((AMAFJJ BETWEEN :EXSP16AJ10 AND :SP16BJ10   AND AMAFNR BETWEEN
     C+                  :EXSP16AN10 AND :SP16BN10  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ11 AND :SP16BJ11   AND AMAFNR BETWEEN
     C+                  :EXSP16AN11 AND :SP16BN11  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ12 AND :SP16BJ12   AND AMAFNR BETWEEN
     C+                  :EXSP16AN12 AND :SP16BN12  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ13 AND :SP16BJ13   AND AMAFNR BETWEEN
     C+                  :EXSP16AN13 AND :SP16BN13  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ14 AND :SP16BJ14   AND AMAFNR BETWEEN
     C+                  :EXSP16AN14 AND :SP16BN14  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ15 AND :SP16BJ15   AND AMAFNR BETWEEN
     C+                  :EXSP16AN15 AND :SP16BN15  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ16 AND :SP16BJ16   AND AMAFNR BETWEEN
     C+                  :EXSP16AN16 AND :SP16BN16  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ17 AND :SP16BJ17   AND AMAFNR BETWEEN
     C+                  :EXSP16AN17 AND :SP16BN17  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ18 AND :SP16BJ18   AND AMAFNR BETWEEN
     C+                  :EXSP16AN18 AND :SP16BN18  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ19 AND :SP16BJ19   AND AMAFNR BETWEEN
     C+                  :EXSP16AN19 AND :SP16BN19  )))) OR
     C+ ((:EXSP16SPE2 =  '          '  AND
     C+    ASSPED BETWEEN :EXSP16SPE2  AND :SP16BSP2    )        OR
     C+  (:EXSP16SPE2 <> '          '  AND  ASSPED = :EXSP16SPE2 AND
     C+ ((AMAFJJ BETWEEN :EXSP16AJ20 AND :SP16BJ20   AND AMAFNR BETWEEN
     C+                  :EXSP16AN20 AND :SP16BN20  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ21 AND :SP16BJ21   AND AMAFNR BETWEEN
     C+                  :EXSP16AN21 AND :SP16BN21  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ22 AND :SP16BJ22   AND AMAFNR BETWEEN
     C+                  :EXSP16AN22 AND :SP16BN22  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ23 AND :SP16BJ23   AND AMAFNR BETWEEN
     C+                  :EXSP16AN23 AND :SP16BN23  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ24 AND :SP16BJ24   AND AMAFNR BETWEEN
     C+                  :EXSP16AN24 AND :SP16BN24  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ25 AND :SP16BJ25   AND AMAFNR BETWEEN
     C+                  :EXSP16AN25 AND :SP16BN20  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ26 AND :SP16BJ26   AND AMAFNR BETWEEN
     C+                  :EXSP16AN26 AND :SP16BN20  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ27 AND :SP16BJ27   AND AMAFNR BETWEEN
     C+                  :EXSP16AN27 AND :SP16BN20  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ28 AND :SP16BJ28   AND AMAFNR BETWEEN
     C+                  :EXSP16AN28 AND :SP16BN20  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ29 AND :SP16BJ29   AND AMAFNR BETWEEN
     C+                  :EXSP16AN29 AND :SP16BN20  )))) OR
     C+ ((:EXSP16SPE3 =  '          '  AND
     C+    ASSPED BETWEEN :EXSP16SPE3  AND :SP16BSP3  )          OR
     C+  (:EXSP16SPE3 <> '          '  AND  ASSPED = :EXSP16SPE3 AND
     C+ ((AMAFJJ BETWEEN :EXSP16AJ30 AND :SP16BJ30   AND AMAFNR BETWEEN
     C+                  :EXSP16AN30 AND :SP16BN30  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ31 AND :SP16BJ31   AND AMAFNR BETWEEN
     C+                  :EXSP16AN31 AND :SP16BN31  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ32 AND :SP16BJ32   AND AMAFNR BETWEEN
     C+                  :EXSP16AN32 AND :SP16BN32  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ33 AND :SP16BJ33   AND AMAFNR BETWEEN
     C+                  :EXSP16AN33 AND :SP16BN33  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ34 AND :SP16BJ34   AND AMAFNR BETWEEN
     C+                  :EXSP16AN34 AND :SP16BN34  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ35 AND :SP16BJ35   AND AMAFNR BETWEEN
     C+                  :EXSP16AN35 AND :SP16BN35  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ36 AND :SP16BJ36   AND AMAFNR BETWEEN
     C+                  :EXSP16AN36 AND :SP16BN36  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ37 AND :SP16BJ37   AND AMAFNR BETWEEN
     C+                  :EXSP16AN37 AND :SP16BN37  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ38 AND :SP16BJ38   AND AMAFNR BETWEEN
     C+                  :EXSP16AN38 AND :SP16BN38  ) OR
     C+  (AMAFJJ BETWEEN :EXSP16AJ39 AND :SP16BJ39   AND AMAFNR BETWEEN
     C+                  :EXSP16AN39 AND :SP16BN39  )))))
     C+ ORDER BY
     C+ ASFIRM,ASSPED,AMKDNR,AMNAM1,AMNAM2,AMNAM3,AMSTRA,AMPOLD,
     C+ AMPOLZ,AMWORT,AMPOFA,AMKMJJ,AMKMNR FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+        OPEN AFSPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN CURSOR AFSPC1                                         ***
     C**************************************************************************
     C     VAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C                   MOVE      *OFF          WKISUM
     C*-------------------------------------------------------------------------
     C     EXSP16BOKZ    IFEQ      DAJNKZ                                       DRUCKEN BORDERO
     C     W1KOPF        ANDEQ     *OFF                                         KOPFDATEN
     C                   WRITE     EXSTR1
     C                   WRITE     EXDR00
     C                   WRITE     EXSTR1
     C                   WRITE     EXLEER
     C                   MOVE      *ON           W1KOPF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ FETCH AFSPC1 INTO :AFSP, :AFKM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     ASSPED        IFNE      WKSPED                                       WECHSEL SPEDITEUR
     C*--------------------------------------------------------
     C     WKKOPF        IFEQ      *ON
     C                   EXSR      AUSGM990                                     SUMMENSATZ
     C                   ENDIF                                                  VORHERG. SPED.
     C*--------------------------------------------------------
     C     WKKOPF        IFEQ      *ON
     C     EXSP16BOKZ    ANDEQ     DAJNKZ                                       DRUCKEN BORDERO
     C                   EXSR      DBORD3                                       SUMMENSATZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      AUSGM000
     C*--------------------------------------------------------
     C     EXSP16BOKZ    IFEQ      DAJNKZ                                       DRUCKEN BORDERO
     C                   EXSR      DBORD1
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         PTLFNR
     C                   Z-ADD     *ZERO         PTSUKO
     C                   Z-ADD     *ZERO         PTSUGW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKISUM
     C                   Z-ADD     ASPLAZ        WKAZPL
     C*--------------------------------------------------------
     C     ASNUMM        IFNE      WKNUMM                                       WECHSEL KOMM.-NR.
     C                   MOVEL(P)  ASNUMM        WKNUMM
     C                   MOVE      *OFF          WKKOPF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIAFL
     C*--------------------------------------------------------
     C                   MOVEL(P)  ASFIRM        KYALFI
     C                   Z-ADD     ASJAHR        KYALKJ
     C                   MOVEL(P)  ASNUMM        KYALKN
     C                   Z-ADD     *ZERO         KYALKP
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     ALFIRM        IFNE      KYALFI
     C     ALKMJJ        ORNE      KYALKJ
     C     ALKMNR        ORNE      KYALKN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     ALAFST        IFGT      '40'
     C                   MOVEA     '04R     '    CHI
     C                   EXSR      CHAFLP
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           WKIAFL
     C                   LEAVE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKIAFL        IFEQ      *ON
     C*--------------------------------------------------------
     C                   IF        WKKOPF      = *OFF
     C                   EXSR      AUSGM200
     C                   EXSR      VAFLK
     C                   EXSR      VAFLP
     C                   EXSR      ENABT
     C                   EXSR      ENABT1
     C                   EXSR      ENABT2
     C                   EXSR      ELGEB
     C                   EXSR      VAFVS
     C                   EXSR      VERTEIL
     C                   ADD       WKGEWI        WKGSGW                         GESAMTGEWICHT
     C*
     C                   IF        EXSP16BOKZ  = DAJNKZ                         DRUCKEN BORDERO
     C                   EXSR      DBORD2
     C                   ENDIF
     C*
     C                   ADD       WKANZA        WKAZCO                         ANZAHL COLLI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON                            UPDATE
     C                   EXSR      UAFSP                                        SPEDITIONSDATEI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         CLOSE AFSPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     WKISUM        IFEQ      *ON
     C                   EXSR      AUSGM990                                     SUMMENSATZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKISUM        IFEQ      *ON
     C     EXSP16BOKZ    ANDEQ     DAJNKZ                                       DRUCKEN BORDERO
     C                   EXSR      DBORD3                                       SUMMENSATZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN AFSP EINZELN                                          ***
     C**************************************************************************
     C     EAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXSP16AJ10    KYASJH
     C                   MOVEL(P)  EXSP16AN10    KYASNR
     C                   MOVEL(P)  'KMNR'        KYASKA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFSP
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASPLAZ        WKAZPL
     C                   EXSR      AUSGM000
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIAFL
     C*--------------------------------------------------------
     C                   MOVEL(P)  ASFIRM        KYALFI
     C                   Z-ADD     ASJAHR        KYALKJ
     C                   MOVEL(P)  ASNUMM        KYALKN
     C                   Z-ADD     *ZERO         KYALKP
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     ALFIRM        IFNE      KYALFI
     C     ALKMJJ        ORNE      KYALKJ
     C     ALKMNR        ORNE      KYALKN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     ALAFST        IFGT      '40'
     C     ALAFST        ANDNE     '90'                                         OHNE FAKTURA
     C                   MOVEA     '04R     '    CHI
     C                   EXSR      CHAFLP
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           WKIAFL
     C                   LEAVE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKIAFL      = *OFF
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      AUSGM200
     C                   EXSR      VAFLK
     C                   EXSR      VAFLP
     C                   EXSR      ENABT
     C                   EXSR      ENABT1
     C                   EXSR      ENABT2
     C                   EXSR      ELGEB
     C                   EXSR      VAFVS
     C                   EXSR      VERTEIL
     C*--------------------------------------------------------
     C                   IF        WKIUPD      = *ON                            UPDATE
     C                   EXSR      UAFSP                                        SPEDITIONSDATEI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN POSITIONEN AFVS BOLL/UNITRANS, SCHENKER, KÜHNE+NAGEL,   ***
     C***  BRT, TNT                                                          ***
     C**************************************************************************
     C     EAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKGWBR
     C                   Z-ADD     *ZERO         WKGWB2
     C                   Z-ADD     *ZERO         I5
     C                   EVAL      WKLANG      = *BLANK
     C                   EVAL      WKHOHE      = *BLANK
     C                   EVAL      WKBREI      = *BLANK
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAVKJ
     C                   MOVEL(P)  ASNUMM        KYAVKM
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO
     C*--------------------------------------------------------
     C                   IF        AVFIRM     <> KYAVFI        OR               OBERGRENZE
     C                             AVKMJJ     <> KYAVKJ        OR               ERREICHT
     C                             AVKMNR     <> KYAVKM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        WKCDVP
     C                   ADD       1             I5
     C*--------------------------------------------------------
     C                   EVAL      KYLPLF      = WKSPED
     C                   EVAL      KYLPTE      = AVTENR
     C                   EVAL      KYLPDA      = W1DATE
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHLPIF
     C*
     C                   IF        WKFENR      = *ZERO         AND
     C                             LPFIRM      = KYLPFI        AND
     C                             LPLFNR      = KYLPLF        AND
     C                             LPTENR      = KYLPTE
     C                   EVAL      WKCDVP      = LPIDEN
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKCDVP      = *BLANK
     C                   MOVEL(P)  'VERPACKUNG'  KYTPTA
     C                   MOVEL(P)  AVTENR        KYTPTC
     C                   Z-ADD     *ZERO         KYTPTF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        WKCDVP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKCDVP      = *BLANK
     C                   EVAL      WKCDVP      = 'FP'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  AVTENR        KYTENR                         IDENTNR. VERPACKUNG
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C     AVGWBR        IFEQ      *ZERO                                        GEWICHT
     C     AVANZA        MULT(H)   TEGWNT        WKN112                         VERPACKUNG
     C     WKN112        MULT(H)   1             WKN050
     C                   Z-ADD     WKN050        WKGWBR
     C                   Z-ADD(H)  WKN112        WKGWB2
     C*
     C     I5            IFEQ      1
     C                   ADD       WKGWNT        WKGWBR                         + INHALT
     C                   ADD       WKGWNT        WKGWB2
     C                   ENDIF
     C*
     C                   ELSE
     C     AVGWBR        MULT(H)   1             WKGWBR                         SENDUNGSGEWICHT
     C     AVGWBR        MULT(H)   1             WKGWB2
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        AVABMS     <> *BLANK
     C*
     C                   IF        %SUBST(AVABMS:1:1) = 'L'
     C                   EVAL      WKLANG      = '0' + %SUBST(AVABMS:2:4)
     C                   ENDIF
     C*
     C                   IF        %SUBST(AVABMS:6:1) = 'B'
     C                   EVAL      WKBREI      = '0' + %SUBST(AVABMS:7:4)
     C                   ENDIF
     C*
     C                   IF        %SUBST(AVABMS:11:1) = 'H'
     C                   EVAL      WKHOHE      = '0' + %SUBST(AVABMS:12:4)
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKSSCC      = AVPAKN
     C                   EVAL      WKBARC      = '22' + %TRIM(WKSPFI)
     C                                         + %TRIM(AVPAKN)
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      ASSPED      = '90292'
     C                   EXSR      AUSGM461
     C                   WHEN      ASSPED      = '90481'
     C                   EXSR      AUSGM4D1
     C                   WHEN      ASSPED      = '92222'
     C                   EXSR      AUSGM4F1
     C                   WHEN      ASSPED      = '92224'
     C                   EXSR      AUSGM4G1
     C                   WHEN      ASSPED      = '92225'
     C                   EXSR      AUSGM4H1
     C                   WHEN      ASSPED      = '90169'
     C                   EXSR      AUSGM4I1
     C                   WHEN      ASSPED      = '92230'
     C                   EXSR      AUSGM4K1
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFVS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN LADEMITTEL                                            ***
     C**************************************************************************
     C     VAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKANZA
     C                   Z-ADD     *ZERO         WKGEWI
     C                   Z-ADD     *ZERO         WKGWBR
     C                   Z-ADD     *ZERO         WKGWB2
     C                   Z-ADD     *ZERO         WKGWB3
     C                   Z-ADD     *ZERO         WKGWPL
     C                   Z-ADD     *ZERO         I5
     C                   MOVE      *BLANK        WKREFN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASPLAZ        WKPLAZ                         ANZAHL PALETTEN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAVKJ                         SCHLÜSSEL
     C                   MOVEL(P)  ASNUMM        KYAVKM                         VORBEREITEN
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'                                          LESEN
     C*--------------------------------------------------------
     C     AVFIRM        IFNE      KYAVFI                                       OBERGRENZE
     C     AVKMJJ        ORNE      KYAVKJ                                       ERREICHT
     C     AVKMNR        ORNE      KYAVKM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        WKCDVP
     C                   ADD       1             I5
     C*--------------------------------------------------------
     C                   ADD       AVANZA        WKANZA                         SUMME ANZAHL KOLL
     C*
     C                   MOVEL(P)  AVTENR        KYTENR                         IDENTNR. VERPACKUNG
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   EVAL      KYLPLF      = WKSPED
     C                   EVAL      KYLPTE      = AVTENR
     C                   EVAL      KYLPDA      = W1DATE
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHLPIF
     C*
     C                   IF        WKFENR      = *ZERO         AND
     C                             LPFIRM      = KYLPFI        AND
     C                             LPLFNR      = KYLPLF        AND
     C                             LPTENR      = KYLPTE
     C                   EVAL      WKCDVP      = LPIDEN
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKCDVP      = *BLANK
     C                   MOVEL(P)  'VERPACKUNG'  KYTPTA
     C                   MOVEL(P)  AVTENR        KYTPTC
     C                   Z-ADD     *ZERO         KYTPTF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        WKCDVP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKCDVP      = *BLANK
     C                   EVAL      WKCDVP      = 'KT'
     C                   ENDIF
     C*--------------------------------------------------------
     C     AVGWBR        IFEQ      *ZERO                                        GEWICHT
     C     AVANZA        MULT(H)   TEGWNT        WKN112                         VERPACKUNG
     C     WKN112        MULT(H)   1             WKN050
     C                   Z-ADD     WKN050        WKGWBR
     C                   Z-ADD(H)  WKN112        WKGWB2
     C                   Z-ADD(H)  WKN112        WKGWB3
     C                   ADD       WKN050        WKGEWI
     C*
     C     I5            IFEQ      1
     C                   ADD       WKGWNT        WKGWBR                         + INHALT
     C                   ADD       WKGWNT        WKGWB2
     C                   ADD       WKGWNT        WKGWB3
     C                   ADD       WKGWNT        WKGEWI
     C                   ENDIF
     C*
     C                   ELSE
     C     AVGWBR        MULT(H)   1             WKGWBR                         SENDUNGSGEWICHT
     C     AVGWBR        MULT(H)   1             WKGWB2
     C     AVGWBR        MULT(H)   1             WKGWB3
     C                   ADD       WKGWBR        WKGEWI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKGWB3      < 0,01
     C                   Z-ADD     0,01          WKGWB3
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        ALLINR      = *BLANK
     C                   MOVEL(P)  ALAFNR        ALLINR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKREFN      = *BLANK        AND
     C                             AVDPDN     <> *BLANK
     C                   EVAL      WKREFN      = '0' + AVDPDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFVS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKREFN      = *BLANK        AND
     C                             (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')
     C                   EVAL      WKREFN      = '0' + %TRIM(AMKDNR) +          KDNR 7-stellig
     C                                           %TRIM(AMKMNR) + '1'
     C                   WHEN      WKREFN      = *BLANK
     C                   EVAL      WKREFN      = '01' + %TRIM(AMKDNR) +
     C                                           %TRIM(AMKMNR) + '1'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKAZPL     <> *ZERO
     C     WKGWBR        DIV       WKAZPL        WKGWPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKGWBR      = *ZERO
     C                   ADD       1             WKGWBR
     C                   ADD       1             WKGWB2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BORDERO TEIL 1 DRUCKEN                                            ***
     C**************************************************************************
     C     DBORD1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKNAM        PTSPED
     C                   MOVE      WKSPFI        PTKDNR                         ANGABEN SPEDITION
     C                   MOVEL(P)  WRWKBZ        PTANS1
     C                   MOVEL(P)  WRSTRA        PTANS2
     C*
     C                   MOVEA(P)  WRPOLD        W99(01)
     C                   MOVEA     WRPOLZ        W99(04)
     C                   MOVEA     WRWORT        W99(10)
     C*
     C                   MOVEA(P)  W99(01)       PTANS3
     C*-------------------------------------------------------------------------
     C                   Z-ADD     9             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR01                                       AUSGABE KOPF
     C                   WRITE     EXLEER                                       JE SPEDITION
     C                   WRITE     EXDR02
     C                   WRITE     EXLEER
     C                   WRITE     EXDR03
     C                   WRITE     EXSTR1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BORDERO TEIL 2 DRUCKEN                                            ***
     C**************************************************************************
     C     DBORD2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   ADD       1             PTLFNR                         POSITIONEN
     C                   Z-ADD     AMKMJJ        DUN040
     C                   MOVEA(P)  DUC004        W99(01)
     C                   MOVEA     AMKMNR        W99(05)
     C                   MOVEA     W99(01)       PTAFNR
     C                   MOVEL(P)  WKNAM1        PTNAM1
     C                   MOVEL(P)  WKSTRA        PTSTRA
     C                   MOVEL(P)  WKPOLD        PTPOLD
     C                   MOVEL(P)  WKPOLZ        PTPOLZ
     C                   MOVEL(P)  WKWORT        PTWORT
     C                   Z-ADD     WKANZA        PTANKO                         ANZ. PACKSTÜCKE
     C                   Z-ADD     WKGEWI        PTGEWI
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR06
     C*
     C                   ADD       WKANZA        PTSUKO
     C                   ADD       WKGEWI        PTSUGW
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BORDERO TEIL 3 DRUCKEN                                            ***
     C**************************************************************************
     C     DBORD3        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     8             WKZEZA                         SUMMENZEILE
     C                   EXSR      ZEILZA
     C                   WRITE     EXLEER
     C                   WRITE     EXSTR1
     C                   WRITE     EXDR10
     C                   WRITE     EXSTR1
     C                   WRITE     EXLEER
     C                   WRITE     EXDR11
     C*
     C                   Z-ADD     *ZERO         PTSUKO
     C                   Z-ADD     *ZERO         PTSUGW
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN FÜR AUSGABE KOPF                                  ***
     C**************************************************************************
     C     AUSGM000      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAMJH
     C                   MOVEL(P)  ASNUMM        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYWRNR                         WERKSADRESS-
     C                   IF        ASWKNR = *BLANK AND
     C                             AMWKNR <> *BLANK
     C                   MOVEL(P)  AMWKNR        KYWRNR
     C                   ENDIF
     C                   MOVEA     '01C     '    CHI                            DATEI
     C                   EXSR      CHWERK
     C                   EVAL      WKILNW      = WREDIL
     C*--------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYSPDAWKNR                     ERMITTELN KUNDEN-
     C                   MOVEL(P)  ASSPED        KYSPDASPED                     NUMMER BEIM
     C                   MOVEA     '01C     '    CHI                            SPEDITEUR
     C                   EXSR      CHSPDA
     C                   MOVEL(P)  SPDAKDBS      WKSPFI                         11 STELLEN
     C                   MOVEL(P)  SPDASPNC      WKCODE
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WKJZEI
     C                   MOVE      WKTDAT        WKJDAT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKSAZA
     C                   Z-ADD     *ZERO         WKGSGW                         GESAMTGEWICHT
     C                   Z-ADD     *ZERO         WKAZAF                         ANZAHL AUFTRÄGE
     C                   Z-ADD     *ZERO         WKAZCO                         ANZAHL COLLI
     C                   MOVE      *BLANK        WKKNAM
     C                   MOVE      *BLANK        WKFRAN
     C                   MOVE      *BLANK        WKFRA1
     C*
     C                   MOVEL(P)  ASSPED        WKSPED
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKSPED        KYLFNR                         ERMITTELN
     C                   MOVEA     '01C     '    CHI                            SPEDITIONSBEZCHNG
     C                   EXSR      CHLIEF
     C*
     C                   MOVEL(P)  LFKNAM        WKKNAM
     C*
     C                   IF        WKSPFI      = *BLANK
     C                   EVAL      WKSPFI      = %TRIM(LFKDBL)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN FÜR AUSGABE POSITION                              ***
     C**************************************************************************
     C     AUSGM200      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKKOPF
     C                   ADD       1             WKAZAF                         ANZAHL AUFTRÄGE
     C                   EVAL      WKVSCD      = *BLANK
     C                   EVAL      WKCODW      = *BLANK
     C                   EVAL      WKCODS      = *ZERO
     C                   EVAL      WKCODM      = *ZERO
     C                   EVAL      WKCODB      = *ZERO
     C                   EVAL      WKCODV      = *ZERO
     C                   EVAL      WKCODK      = *ZERO
     C                   EVAL      WKCODI      = *ZERO
     C                   EVAL      WKCODP      = *ZERO
     C                   EVAL      WKCODU      = *ZERO
     C                   EVAL      WKNABT      = *ZERO
     C                   EVAL      WKWACD      = *BLANK
     C                   EVAL      WKLFDN      = *ZERO
     C                   EVAL      WKMAAF      = *BLANK
     C                   EVAL      WKMAA2      = *BLANK
     C                   EVAL      WKREF1      = *BLANK
     C                   EVAL      WKLFTE      = *BLANK
     C                   EVAL      WKLFT2      = *BLANK
     C                   EVAL      WKTLNR      = *BLANK
     C                   EVAL      WKTXT1      = *BLANK
     C                   EVAL      WKTXT2      = *BLANK
     C                   EVAL      WKTXT3      = *BLANK
     C                   EVAL      WKTXT4      = *BLANK
     C                   EVAL      WKTXT5      = *BLANK
     C                   EVAL      WKTNR1      = *BLANK
     C                   EVAL      WKTNR2      = *BLANK
     C                   EVAL      WKTNR3      = *BLANK
     C                   EVAL      WKTNR4      = *BLANK
     C                   EVAL      WKTNR5      = *BLANK
     C                   EVAL      WKAZLS      = *ZERO
     C                   MOVE      *OFF          WKILFT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAMJH
     C                   MOVEL(P)  ASNUMM        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*--------------------------------------------------------
     C                   EVAL      WKTOUR      = AMTOUR
     C*
     C                   IF        AMTOUR      = *BLANK
     C                   EVAL      WKTOUR      = '099'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKNAM1      = AMNAM1
     C                   EVAL      WKNAM2      = AMNAM2
     C                   EVAL      WKNAM3      = AMNAM3
     C                   EVAL      WKSTRA      = AMSTRA
     C                   EVAL      WKPOLD      = AMPOLD
     C                   EVAL      WKPOLZ      = AMPOLZ
     C                   EVAL      WKWORT      = AMWORT
     C                   EXSR      EAFAD
     C*--------------------------------------------------------
     C                   EVAL      W2POLD      = WKPOLD
     C*
     C                   IF        WKPOLD      = 'DE '
     C                   EVAL      W2POLD      = *BLANK
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKPLZL      = *BLANK
     C*
     C                   DO        10            I1
     C*
     C                   IF        %SUBST(WKPOLZ:I1:1) <> ' '
     C                   EVAL      WKPLZL      = %TRIM(WKPLZL) +
     C                                           %SUBST(WKPOLZ:I1:1)
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AMKDNR        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*--------------------------------------------------------
     C                   EVAL      WKILNE      = KZEDIB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AMLAND        KYLNNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLAND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYAKJH                         AUFTRAGSKOPF
     C                   MOVEL(P)  AMAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*--------------------------------------------------------
     C                   EVAL      WKMAAF      = AKMAAF
     C                   EVAL      WKMAA2      = AKMAAF
     C                   EVAL      WKREF1      = AKREF1
     C                   EVAL      WKZABD      = AKZABD
     C                   EVAL      WKWACD      = AKWACD
     C*--------------------------------------------------------
     C                   IF        WKWACD = *BLANK
     C                   EVAL      WKWACD = EXFIRMWACD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYVBBD      = AMVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHVSBD
     C*
     C                   IF        VBSPTF     <> *BLANK
     C                   EVAL      WKFRAN      = VBSPTF + '0'
     C                   EVAL      WKFRA1      = VBSPTF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKFRAN      = *BLANK
     C                   MOVEL(P)  'FRANKATUR'   KYTPTA
     C                   MOVEL(P)  AMVSBD        KYTPTC
     C                   Z-ADD     *ZERO         KYTPTF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        WKFRAN
     C                   MOVEL(P)  TPTTXT        WKFRA1
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKFRAN      = *BLANK
     C                   EVAL      WKFRAN      = '90'
     C                   EVAL      WKFRA1      = '0'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYWAO8AFJJ
     C                   MOVEL(P)  AMAFNR        KYWAO8AFNR
     C                   Z-ADD     *ZERO         KYWAO8AFPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             WAO8FIRM    = KYWAO8FIRM    AND
     C                             WAO8AFJJ    = KYWAO8AFJJ    AND
     C                             WAO8AFNR    = KYWAO8AFNR
     C                   EVAL      WKVSCD      = WAO8SPWG
     C                   EVAL      WKCODW      = WAO8CODW                       COD Währung
     C                   EVAL      WKCODS      = WAO8CODS                       Skonto
     C                   EVAL      WKCODM      = WAO8CODM                       MWST
     C                   EVAL      WKCODB      = WAO8CODB                       Betrag gesamt
     C*
     C                   IF        WAO8IFST   <> '90'
     C                   EVAL      WKCODV      = WAO8CODV                       Versandkosten
     C                   EVAL      WKCODK      = WAO8CODK                       Verpackungskosten
     C                   EVAL      WKCODI      = WAO8CODI                       Versicherungskosten
     C                   ENDIF
     C*
     C                   IF        WAO8LFTE   <> *ZERO
     C                   EVAL      WKLFTE      = %CHAR(WAO8LFTE)
     C                   EVAL      WKLFT2      = %SUBST(%CHAR(WAO8LFTE):7:2) +
     C                                           '.' +
     C                                           %SUBST(%CHAR(WAO8LFTE):5:2) +
     C                                           '.' +
     C                                           %SUBST(%CHAR(WAO8LFTE):3:2)
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKVSCD      = *BLANK
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      AMVSBD      = '578'
     C                   EVAL      WKVSCD      = 'DAYB '
     C                   WHEN      AMVSBD      = '579'
     C                   EVAL      WKVSCD      = 'DAGL '
     C                   WHEN      AMVSBD      = '580'
     C                   EVAL      WKVSCD      = 'NACHT'
     C                   WHEN      AMVSBD      = '581'
     C                   EVAL      WKVSCD      = 'NACHB'
     C                   WHEN      AMVSBD      = '582'
     C                   EVAL      WKVSCD      = 'NACHL'
     C                   WHEN      WKPOLD      = 'BE '
     C                   EVAL      WKVSCD      = 'DAYB '
     C                   WHEN      WKPOLD      = 'LU '
     C                   EVAL      WKVSCD      = 'DAGL '
     C                   OTHER
     C                   EVAL      WKVSCD      = 'DAG  '
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        ASSPED      = '90169'
     C                   EXSR      ERLTN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ERTEXT                                       Ermitteln Text IFAT
     C**                 EXSR      VTXBE
     C                   EXSR      VTEXT
     C                   EXSR      ERLFDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Ermitteln Text aus IFAT für Telefonnummer Avis und Versandinfo    ***
     C**************************************************************************
     C     ERTEXT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYIFAKAFJJ
     C                   MOVEL(P)  AMAFNR        KYIFAKAFNR
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHIFAK
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYIFATIFFI  = IFAKIFFI
     C                   EVAL      KYIFATIFTX  = '1'
     C                   EVAL      KYIFATIFNR  = IFAKIFNR
     C                   EVAL      KYIFATIFPO  = *ZERO
     C                   EVAL      KYIFATIFUP  = *ZERO
     C                   EVAL      KYIFATIFUC  = *BLANK
     C                   EVAL      KYIFATIFZN  = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHIFAT
     C*
     C                   DOW       WKFENR      = *ZERO         AND
     C                             IFATIFFI    = KYIFATIFFI    AND
     C                             IFATIFTX    = KYIFATIFTX    AND
     C                             IFATIFNR    = KYIFATIFNR    AND
     C                             IFATIFPO    = KYIFATIFPO
     C*
     C                   IF        IFATDRK1    = 'F'           AND
     C                             (%SUBST(IFATTEXT:1:1) = '0' OR
     C                             %SUBST(IFATTEXT:1:1)  = '+' OR
     C                             %SUBST(IFATTEXT:1:3)  = 'TEL')
     C                   MOVEL(P)  IFATTEXT      WKTLNR                         Telefonnummer Avis
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHIFAT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      KYIFATIFFI  = IFAKIFFI
     C                   EVAL      KYIFATIFTX  = '1'
     C                   EVAL      KYIFATIFNR  = IFAKIFNR
     C                   EVAL      KYIFATIFPO  = *ZERO
     C                   EVAL      KYIFATIFUP  = *ZERO
     C                   EVAL      KYIFATIFUC  = *ZERO
     C                   EVAL      KYIFATIFZN  = *ZERO
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHIFAT
     C                   Z-ADD     1             WKIFATZN
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             WKIFATZN   <= 5
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHIFAT
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO         OR
     C                             IFATIFFI   <> KYIFATIFFI    OR
     C                             IFATIFTX   <> KYIFATIFTX    OR
     C                             IFATIFNR   <> KYIFATIFNR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        IFATDRK1   <> 'F'           AND
     C                             IFATDRK2   <> 'F'           AND
     C                             IFATDRK3   <> 'F'           AND
     C                             IFATDRK4   <> 'F'           AND
     C                             IFATDRK5   <> 'F'           AND
     C                             IFATDRK6   <> 'F'           AND
     C                             IFATDRK7   <> 'F'           AND
     C                             IFATDRK8   <> 'F'           AND
     C                             IFATDRK9   <> 'F'
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKIFATZN    = 1
     C                   EVAL      WKTXT1      = IFATTEXT
     C                   WHEN      WKIFATZN    = 2
     C                   EVAL      WKTXT2      = IFATTEXT
     C                   WHEN      WKIFATZN    = 3
     C                   EVAL      WKTXT3      = IFATTEXT
     C                   WHEN      WKIFATZN    = 4
     C                   EVAL      WKTXT4      = IFATTEXT
     C                   WHEN      WKIFATZN    = 5
     C                   EVAL      WKTXT5      = IFATTEXT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ADD       1             WKIFATZN
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN TEXTE                                                 ***
     C**************************************************************************
     C     VTEXT         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        WKTXT1     <> *BLANK
     C                   EVAL      WKTNR1      = '300'
     C                   ENDIF
     C*
     C                   IF        WKTXT2     <> *BLANK
     C                   EVAL      WKTNR2      = '300'
     C                   ENDIF
     C*
     C                   IF        WKTXT3     <> *BLANK
     C                   EVAL      WKTNR3      = '300'
     C                   ENDIF
     C*
     C                   IF        WKTXT4     <> *BLANK
     C                   EVAL      WKTNR4      = '300'
     C                   ENDIF
     C*
     C                   IF        WKTXT5     <> *BLANK
     C                   EVAL      WKTNR5      = '300'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(WKTXT1 : 1 : 3) = '300' OR
     C                             %SUBST(WKTXT1 : 1 : 3) = '301' OR
     C                             %SUBST(WKTXT1 : 1 : 3) = '311'
     C                   EVAL      WKTNR1      = %SUBST(WKTXT1 : 1 : 3)
     C                   EVAL      WKTXT1      = %TRIM(%SUBST(WKTXT1 : 4 : 62))
     C                   ENDIF
     C*
     C                   IF        %SUBST(WKTXT2 : 1 : 3) = '300' OR
     C                             %SUBST(WKTXT2 : 1 : 3) = '301' OR
     C                             %SUBST(WKTXT2 : 1 : 3) = '311'
     C                   EVAL      WKTNR2      = %SUBST(WKTXT2 : 1 : 3)
     C                   EVAL      WKTXT2      = %TRIM(%SUBST(WKTXT2 : 4 : 62))
     C                   ENDIF
     C*
     C                   IF        %SUBST(WKTXT3 : 1 : 3) = '300' OR
     C                             %SUBST(WKTXT3 : 1 : 3) = '301' OR
     C                             %SUBST(WKTXT3 : 1 : 3) = '311'
     C                   EVAL      WKTNR3      = %SUBST(WKTXT3 : 1 : 3)
     C                   EVAL      WKTXT3      = %TRIM(%SUBST(WKTXT3 : 4 : 62))
     C                   ENDIF
     C*
     C                   IF        %SUBST(WKTXT4 : 1 : 3) = '300' OR
     C                             %SUBST(WKTXT4 : 1 : 3) = '301' OR
     C                             %SUBST(WKTXT4 : 1 : 3) = '311'
     C                   EVAL      WKTNR4      = %SUBST(WKTXT4 : 1 : 3)
     C                   EVAL      WKTXT4      = %TRIM(%SUBST(WKTXT4 : 4 : 62))
     C                   ENDIF
     C*
     C                   IF        %SUBST(WKTXT5 : 1 : 3) = '300' OR
     C                             %SUBST(WKTXT5 : 1 : 3) = '301' OR
     C                             %SUBST(WKTXT5 : 1 : 3) = '311'
     C                   EVAL      WKTNR5      = %SUBST(WKTXT5 : 1 : 3)
     C                   EVAL      WKTXT5      = %TRIM(%SUBST(WKTXT5 : 4 : 62))
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKLFT2     <> *BLANK        AND              NUR BEI HELLMANN
     C                             (ASSPED     = '90164'       OR               UND FIXTERMIN
     C                             ASSPED      = '90481'       OR
     C                             ASSPED      = '92215'       OR
     C                             ASSPED      = '92216'       OR
     C                             ASSPED      = '92219'       OR
     C                             ASSPED      = '92221')
     C                   EVAL      WKTNR5      = WKTNR4
     C                   EVAL      WKTXT5      = WKTXT4
     C                   EVAL      WKTNR4      = WKTNR3
     C                   EVAL      WKTXT4      = WKTXT3
     C                   EVAL      WKTNR3      = WKTNR2
     C                   EVAL      WKTXT3      = WKTXT2
     C                   EVAL      WKTNR2      = WKTNR1
     C                   EVAL      WKTXT2      = WKTXT1
     C                   EVAL      WKTNR1      = '100'
     C                   EVAL      WKTXT1      = WKLFT2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE HELLMANN                                                  ***
     C**************************************************************************
     C     AUSGM400      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   HCI_F0
     C                   EVAL      HCISATZART  = 'S'
     C*
     C                   IF        ASSPED      = '90164'       OR
     C                             ASSPED      = '92215'       OR
     C                             ASSPED      = '92219'       OR
     C                             ASSPED      = '92221'
     C                   EVAL      HCIPRODUKT  = 'HEV'
     C                   ELSE
     C                   EVAL      HCIPRODUKT  = 'NSE'                          NIGHT STAR
     C                   ENDIF
     C*
     C                   EVAL      HCINIEDERL  = '490'
     C                   EVAL      HCISTATUS   = '1'
     C                   EVAL      HCIVDATUM   = %CHAR(WKDATE)
     C                   EVAL      HCIKDNR     = WKSPFI
     C                   EVAL      HCIREFNR    = WKREFN
     C*
     C                   IF        ASSPED     <> '92215'
     C                   EVAL      HCIVNAME1   = WRNAM1
     C                   EVAL      HCIVNAME2   = WRNAM2
     C                   EVAL      HCIVSTR     = WRSTRA
     C                   EVAL      HCIVLAND    = WRPOLD
     C                   EVAL      HCIVPLZ     = WRPOLZ
     C                   EVAL      HCIVORT     = WRWORT
     C                   ENDIF
     C*
     C                   EVAL      HCIEKDNR    = '  ' + AMKDNR                  EMPFÄNGER EIGEN
     C                   EVAL      HCIENAME1   = WKNAM1
     C                   EVAL      HCIENAME2   = WKNAM2
     C                   EVAL      HCIESTR     = WKSTRA
     C                   EVAL      HCIELAND    = LNLISO
     C                   EVAL      HCIEPLZ     = WKPOLZ
     C                   EVAL      HCIEORT     = WKWORT
     C                   EVAL      HCIFRANKA   = WKFRAN                         FRANKATURKZ.
     C                   EVAL      HCIANZ1     = %CHAR(WKANZA)                  ANZAHL1
     C                   EVAL      HCIVERP1    = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      HCIGEW1     = %CHAR(WKGWBR)                  SENDUNGSGEWICHT
     C                   EVAL      HCIWARENI1  = TXPRGR                         WARENINHALT
     C                   EVAL      HCIWWERT    = *BLANK                         WARENWERT
     C                   EVAL      HCIWAE      = *BLANK                         WÄHRUNG
     C                   EVAL      HCIVOL      = *BLANK                         VOLUMEN
     C                   EVAL      HCILADEMTR  = *BLANK                         LADEMETER
     C                   EVAL      HCINNBETR   = *BLANK                         NACHNAHMEBETRAG
     C                   EVAL      HCIWAENN    = WKWACD                         WÄHRUNG NACHNAHME
     C                   EVAL      HCIARTNN    = *BLANK                         ART DER NACHNAHME
     C                   EVAL      HCIE_ANR    = WKMAAF                         EMPFÄNGER AUFTRAGNR.
     C                   EVAL      HCITEXTNR1  = WKTNR1                         TEXTNR. 1
     C                   EVAL      HCITEXTZU1  = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      HCITEXTNR2  = WKTNR2                         TEXTNR. 2
     C                   EVAL      HCITEXTZU2  = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      HCITEXTNR3  = WKTNR3                         TEXTNR. 3
     C                   EVAL      HCITEXTZU3  = WKTXT3                         TEXTZUSATZ 3
     C*
     C                   WRITE     HCI_F0
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE PARTS EXPRESS                                             ***
     C**************************************************************************
     C     AUSGM410      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ROOY0R1
     C                   EVAL      S10010      = 'N'                            SATZART
     C                   EVAL      S10020      = WKREFN                         AUFTRAGSREFERENZ
     C                   EVAL      S10030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      S10040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      S10050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      S10060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      DUC002      = *BLANK
     C*
     C                   SELECT
     C                   WHEN      %SUBST(WRPOLZ:5:1) = ' '
     C                   EVAL      DUC004      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC004               97
     C*
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN040        S10070
     C                   ENDIF
     C*
     C                   EVAL      DUC002      = %SUBST(WRPOLZ:6:2)
     C*
     C                   IF        DUC002     <> *BLANK
     C                   EVAL      S10080      = DUC002 + ' ' + WRWORT          ABSENDER ORT
     C                   ELSE
     C                   EVAL      S10080      = WRWORT
     C                   ENDIF
     C*
     C                   WHEN      %SUBST(WRPOLZ:1:1) = ' '    AND
     C                             %SUBST(WRPOLZ:5:1) <> ' '
     C                   EVAL      DUC004      = %SUBST(WRPOLZ:2:4)             ABSENDER PLZ
     C                   TESTN                   DUC004               97
     C*
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN040        S10070
     C                   ENDIF
     C*
     C                   EVAL      DUC002      = %SUBST(WRPOLZ:7:2)
     C*
     C                   IF        DUC002     <> *BLANK
     C                   EVAL      S10080      = DUC002 + ' ' + WRWORT          ABSENDER ORT
     C                   ELSE
     C                   EVAL      S10080      = WRWORT
     C                   ENDIF
     C*
     C                   OTHER
     C                   EVAL      DUC005      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S10070      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S10080      = WRWORT                         ABSENDER ORT
     C                   ENDSL
     C*
     C                   EVAL      S10090      = WKSPFI                         KUNDENNUMMER
     C                   EVAL      S10100      = WKDAT1                         DATUM
     C                   EVAL      S10110      = *BLANK                         STATUS
     C                   EVAL      S10120      = WKNAM1                         EMPFÄNGER-NAME-1
     C                   EVAL      S10130      = WKNAM2                         EMPFÄNGER-NAME-2
     C                   EVALR     S10130      = WKVSCD                         VERSANDCODE
     C                   EVAL      S10140      = WKSTRA                         EMPFÄNGER STRASSE
     C                   EVAL      S10150      = WKPOLD                         EMPFÄNGER LKZ
     C                   EVAL      DUC002      = *BLANK
     C*
     C                   SELECT
     C                   WHEN      %SUBST(WKPOLZ:5:1) = ' '
     C                   EVAL      DUC004      = WKPOLZ                         EMPFÄNGER-PLZ
     C                   TESTN                   DUC004               97
     C*
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN040        S10160
     C                   ENDIF
     C*
     C                   EVAL      DUC002      = %SUBST(WKPOLZ:6:2)
     C*
     C                   IF        DUC002     <> *BLANK
     C                   EVAL      S10170      = DUC002 + ' ' + WKWORT          EMPFÄNGER ORT
     C                   ELSE
     C                   EVAL      S10170      = WKWORT
     C                   ENDIF
     C*
     C                   WHEN      %SUBST(WKPOLZ:1:1) = ' '    AND
     C                             %SUBST(WKPOLZ:5:1) <> ' '
     C                   EVAL      DUC004      = %SUBST(WKPOLZ:2:4)             EMPFÄNGER PLZ
     C                   TESTN                   DUC004               97
     C*
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN040        S10160
     C                   ENDIF
     C*
     C                   EVAL      DUC002      = %SUBST(WKPOLZ:7:2)
     C*
     C                   IF        DUC002     <> *BLANK
     C                   EVAL      S10170      = DUC002 + ' ' + WKWORT          EMPFÄNGER ORT
     C                   ELSE
     C                   EVAL      S10170      = WKWORT
     C                   ENDIF
     C*
     C                   OTHER
     C                   EVAL      DUC005      = WKPOLZ                         EMPFÄNGER-PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S10160      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S10170      = WKWORT                         EMPFÄNGER ORT
     C                   ENDSL
     C*
     C                   EVALR     S10180      = %TRIM(AMKDNR)                  EMPFÄNGER EIGEN
     C                   EVAL      S10250      = *ZERO                          WARENWERT
     C                   EVAL      S10260      = WKNABT                         NACHNAHMEBETRAG
     C                   EVAL      S10270      = *BLANK                         BORDEROTEXT
     C                   EVAL      S10300      = WKREF1                         RECHNUNGSTEXT
     C                   EVAL      S10310      = WKTOUR                         TOUR
     C                   Z-ADD     WKGWBR        S10320                         GEWICHT
     C                   EVAL      DUC002      = WKFRAN                         FRANKATUR
     C                   EVAL      S10340      = DUN020
     C                   EVAL      S10350      = WKTENR                         ARTNR. 1
     C                   EVAL      S10360      = 1                              ANZ.VERPACKUNG 1
     C                   EVAL      S10370      = WKCDVP                         CODE VERPACKUNG 1
     C                   Z-ADD     WKGWBR        S10380                         GEWICHT 1
     C                   WRITE     ROOY0R1
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE HAMACHER                                                  ***
     C**************************************************************************
     C     AUSGM420      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPED201
     C                   EVAL      S20010      = 'N'                            SATZART
     C                   EVAL      S20020      = WKREFN                         AUFTRAGSREFERENZ
     C                   EVAL      S20030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      S20040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      S20050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      S20060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      S20070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      S20080      = WRWORT                         ABSENDER ORT
     C                   EVAL      S20090      = WKSPFI                         KUNDENNUMMER
     C                   EVAL      S20100      = WKDAT1                         DATUM
     C                   EVAL      S20110      = *BLANK                         STATUS
     C                   EVAL      S20120      = WKNAM1                         EMPFÄNGER-NAME-1
     C                   EVAL      S20130      = WKNAM2                         EMPFÄNGER-NAME-2
     C                   EVAL      S20140      = WKSTRA                         EMPFÄNGER STRASSE
     C                   EVAL      S20150      = WKPOLD                         EMPFÄNGER LKZ
     C                   EVAL      S20160      = WKPOLZ                         EMPFÄNGER-PLZ
     C                   EVAL      S20170      = WKWORT                         EMPFÄNGER ORT
     C                   EVALR     S20180      = %TRIM(AMKDNR)                  EMPFÄNGER EIGEN
     C                   EVAL      S20190      = *BLANK                         FRACHTZAHLER-NAME-1
     C                   EVAL      S20200      = *BLANK                         FRACHTZAHLER-NAME-2
     C                   EVAL      S20210      = *BLANK                         FRACHTZAHLER-STRASSE
     C                   EVAL      S20220      = *BLANK                         FRACHTZAHLER-LKZ
     C                   EVAL      S20230      = *ZERO                          FRACHTZAHLER-PLZ
     C                   EVAL      S20240      = *BLANK                         FRACHTZAHLER-ORT
     C                   EVAL      S20250      = *ZERO                          WARENWERT
     C                   Z-ADD     WKNABT        S20260                         NACHNAHMEBETRAG
     C                   EVAL      S20270      = *BLANK                         BORDEROTEXT
     C                   EVAL      S20300      = WKMAA2                         RECHNUNGSTEXT
     C                   EVAL      S20310      = WKTOUR                         TOUR
     C                   Z-ADD     WKGWBR        S20320                         GEWICHT
     C                   EVAL      DUC002      = WKFRAN                         FRANKATUR
     C                   EVAL      S20340      = DUN020
     C                   EVAL      S20350      = WKTENR                         ARTNR. 1
     C                   EVAL      S20360      = 1                              ANZ.VERPACKUNG 1
     C                   EVAL      S20370      = WKCDVP                         CODE VERPACKUNG 1
     C                   Z-ADD     WKGWBR        S20380                         GEWICHT 1
     C                   EVAL      S20480      = WKTLNR                         Telfonnummer Avis
     C                   EVAL      S20490      = WKTXT1                         Versandinfo/Anweisun
     C                   EVAL      S20500      = WKTXT2                         Text 2
     C                   EVAL      S20510      = WKTXT3                         Text 3
     C                   EVAL      S20520      = WKTXT4                         Text 4
     C                   EVAL      S20530      = WKTXT5                         Text 5
     C                   EVAL      S20540      = WKLFTE                         Fixtermin
     C                   WRITE     SPED201
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE TRANS-O-FLEX                                              ***
     C**************************************************************************
     C     AUSGM430      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   HEL00R1
     C                   EVAL      S30010      = 'J'
     C                   EVAL      S30020      = WKREFN
     C                   EVAL      S30030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      S30040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      S30050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      S30060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      DUC005      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S30070      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S30080      = WRWORT                         ABSENDER ORT
     C                   EVAL      S30090      = WKSPFI
     C                   EVALR     S30100      = '1'
     C                   EVAL      S30110      = ' '                            STATUS
     C                   EVAL      S30120      = WKNAM1
     C                   EVAL      S30130      = WKNAM2
     C                   EVAL      S30140      = WKSTRA
     C                   EVAL      S30150      = W2POLD
     C                   EVAL      DUC005      = WKPOLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S30160      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S30170      = WKWORT
     C                   EVALR     S30180      = %SUBST(AMKDNR:1:6)             EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        S30260                         NACHNAHMEBETRAG
     C                   EVAL      S30270      = WKREF1                         BORDEROTEXT
     C                   EVAL      S30300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      S30310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGWBR        S30320                         SENDUNGSGEWICHT
     C                   EVAL      DUC002      = WKFRAN
     C                   EVAL      S30340      = DUN020                         FRANKATURKZ.
     C                   EVAL      S30350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        S30360                         ANZAHL 1
     C                   EVAL      S30370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      S30380      = TXMCBG                         MATCHCODE
     C                   WRITE     HEL00R1
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE GERMAN PARCEL/GLS                                         ***
     C**************************************************************************
     C     AUSGM440      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPED401
     C                   EVAL      HEL010      = 'J'
     C                   EVAL      HEL020      = WKREFN
     C                   EVAL      HEL030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      HEL040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      HEL050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      HEL060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      DUC005      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      HEL070      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      HEL080      = WRWORT                         ABSENDER ORT
     C                   EVAL      HEL090      = WKSPFI
     C*
     C                   SELECT
     C                   WHEN      ASSPED      = '91258'                        MARKET INTERVENTION
     C                   EVALR     HEL100      = '7'
     C                   WHEN      ASSPED      = '92220'                        DOMETIC SIEGEN
     C                   EVALR     HEL100      = '8'
     C                   OTHER
     C                   EVALR     HEL100      = '1'
     C                   ENDSL
     C*
     C                   EVAL      HEL110      = ' '                            STATUS
     C                   EVAL      HEL120      = WKNAM1
     C                   EVAL      HEL130      = WKNAM2
     C                   EVAL      HEL140      = WKSTRA
     C                   EVAL      HEL150      = WKPOLD
     C                   EVAL      DUC005      = WKPOLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      HEL160      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      HEL170      = WKWORT
     C                   EVALR     HEL180      = %SUBST(AMKDNR:1:6)             EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        HEL260                         NACHNAHMEBETRAG
     C*
     C                   IF        HEL260     <> *ZERO
     C                   EVAL      HEL270      = 'COD'                          BORDEROTEXT
     C                   ENDIF
     C*
     C                   EVAL      HEL300      = WKREF1                         RECHNUNGSTEXT
     C                   EVAL      HEL310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGWBR        HEL320                         SENDUNGSGEWICHT
     C                   EVAL      DUC002      = WKFRAN
     C                   EVAL      HEL340      = DUN020                         FRANKATURKZ.
     C                   EVAL      HEL350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        HEL360                         ANZAHL 1
     C                   EVAL      HEL370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      HEL380      = TXMCBG                         MATCHCODE
     C                   WRITE     SPED401
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE DPD                                                       ***
     C**************************************************************************
     C     AUSGM450      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DPD00R1
     C                   EVAL      DPD010      = %SUBST(AMKDNR:1:6)             KD.-NR.
     C                   EVAL      DPD015      = WKNAM1                         NAME 1
     C                   EVAL      DPD020      = WKNAM2                         NAME 2
     C                   EVAL      DPD025      = WKNAM3                         NAME 3
     C                   EVAL      DPD030      = WKSTRA                         STRASSE
     C                   EVAL      DPD035      = WKPOLD                         LAND
     C                   EVAL      DUC005      = WKPOLZ                         PLZ (nicht relevant,
     C                   TESTN                   DUC005               97        siehe WKPLZL)
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      DPD040      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      DPD045      = WKWORT                         ORT
     C                   Z-ADD     WKANZA        DPD050                         PAKETE
     C     WKGWB2        MULT      100           DPD055                         GEWICHT
     C** nicht füllen    EVAL      DPD060      = %CHAR(WKDATE) Fehler           DATUM
     C                   EVAL      DPD065      = WKREFN                         LIEFERSCHEIN
     C                   EVAL      DPD070      = *BLANK                         RECHNUNG
     C                   Z-ADD     *ZERO         DPD075                         PACKSTÜCK
     C     WKNABT        MULT      100           DPD080                         NACHNAHME BETRAG
     C                   EVAL      DPD085      = WKWACD                         WÄHRUNG
     C                   EVAL      DPD090      = *BLANK                         ZAHLUNGSART
     C                   EVAL      DPD095      = WKPLZL                         VERW.ZWECK -> PLZ
     C                   EVAL      DPD100      = *BLANK                         TELEFON
     C                   EVAL      DPD105      = *BLANK                         TELEFAX
     C                   MOVEL(P)  WKFRAN        DUC001
     C                   Z-ADD     DUN010        DPD110                         PAKETSCHEINART
     C                   Z-ADD     *ZERO         DPD305                         ZUSTELLUNGSZEIT
     C                   EVAL      DPD310      = *BLANK                         DRINGLK.STUFE
     C                   EVAL      DPD315      = *BLANK                         KOSTENSTELLE
     C                   EVAL      DPD320      = *BLANK                         FREIFELD 1
     C                   EVAL      DPD325      = *BLANK                         FREIFELD 2
     C                   EVAL      DPD330      = *BLANK                         FREIFELD 3
     C                   EVAL      DPD335      = *BLANK                         INHALT
     C                   EVAL      DPD490      = *BLANK                         NEUTRAL KDNR
     C                   EVAL      DPD495      = *BLANK                         NEUTRAL NAME 1
     C                   EVAL      DPD500      = *BLANK                         NEUTRAL NAME 2
     C                   EVAL      DPD505      = *BLANK                         NEUTRAL NAME 3
     C                   EVAL      DPD510      = *BLANK                         NEUTRAL STRASSE
     C                   EVAL      DPD515      = *BLANK                         NEUTRAL LAND
     C                   EVAL      DUC005      = *ZERO
     C                   EVAL      DPD520      = DUN050                         NEUTRAL PLZ
     C                   EVAL      DPD525      = *BLANK                         NEUTRAL ORT
     C                   EVAL      DPD530      = *BLANK                         NEUTRAL TELEFON
     C                   EVAL      DPD535      = *BLANK                         NEUTRAL TELEFAX
     C                   WRITE     DPD00R1
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE BOLL/UNITRANS KOPF                                        ***
     C**************************************************************************
     C     AUSGM460      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   HEL60R1
     C                   EVAL      S60010      = 'N'
     C                   EVAL      S60020      = WKREFN
     C                   EVAL      S60030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      S60040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      S60050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      S60060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      DUC005      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S60070      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S60080      = WRWORT                         ABSENDER ORT
     C                   EVAL      S60090      = WKSPFI
     C                   EVAL      S60110      = *BLANK                         STATUS
     C                   EVAL      S60120      = WKNAM1
     C                   EVAL      S60130      = WKNAM2
     C                   EVAL      S60140      = WKSTRA
     C                   EVAL      S60150      = WKPOLD
     C                   EVAL      DUC005      = WKPOLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      S60160      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      S60170      = WKWORT
     C                   EVALR     S60180      = %SUBST(AMKDNR:1:6)             EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        S60260                         NACHNAHMEBETRAG
     C                   EVAL      S60270      = WKREF1                         BORDEROTEXT
     C                   EVAL      S60290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      S60300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      S60310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGEWI        S60320                         SENDUNGSGEWICHT
     C                   EVAL      DUC002      = WKFRAN
     C                   EVAL      S60340      = DUN020                         FRANKATURKZ.
     C                   EVAL      S60350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        S60360                         ANZAHL 1
     C                   EVAL      S60370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      S60380      = TXMCBG                         MATCHCODE
     C                   EVAL      S60450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      S60460      = '$$R$$'                        INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      S60470      = DUN070                         ILN WAECO
     C                   EVAL      S60475      = WKILNE                         ILN EMPF.
     C                   EVAL      S60480      = *BLANK                         NVE
     C                   EVAL      S60490      = *BLANK                         SHUTTLE
     C                   EVAL      S60500      = WKLGEB                         LEITGEBIET
     C                   EVAL      S60510      = WKFACH                         ABSTELLFACH
     C                   EVAL      S60520      = 'N'                            DRUCKEN J/N
     C                   WRITE     HEL60R1
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE BOLL/UNITRANS POSITIONEN                                  ***
     C**************************************************************************
     C     AUSGM461      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   HEL60R1
     C                   EVAL      S60020      = WKREFN
     C                   Z-ADD     WKGWBR        S60320                         SENDUNGSGEWICHT
     C                   EVAL      S60350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        S60360                         ANZAHL 1
     C                   EVAL      S60370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      S60380      = TXMCBG                         MATCHCODE
     C                   EVAL      S60450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVALR     S60475      = '*NVE*'                        ILN EMPF.
     C                   EVAL      S60480      = WKSSCC                         NVE
     C                   WRITE     HEL60R1
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE ADLATUS                                                   ***
     C**************************************************************************
     C     AUSGM470      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     SPED701
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE DACHSER                                                   ***
     C**************************************************************************
     C     AUSGM480      BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPED801
     C                   EVAL      S80010      = 'N'                            SATZART
     C                   EVAL      S80020      = WKREFN                         AUFTRAGSREFERENZ
     C                   EVAL      S80030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      S80040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      S80050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      S80060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      S80070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      S80080      = WRWORT                         ABSENDER ORT
     C                   EVAL      S80090      = WKSPFI                         KUNDENNUMMER
     C                   EVAL      S80100      = WKDAT1                         DATUM
     C                   EVAL      S80110      = *BLANK                         STATUS
     C                   EVAL      S80120      = WKNAM1                         EMPFÄNGER-NAME-1
     C                   EVAL      S80130      = WKNAM2                         EMPFÄNGER-NAME-2
     C                   EVAL      S80140      = WKSTRA                         EMPFÄNGER STRASSE
     C                   EVAL      S80150      = WKPOLD                         EMPFÄNGER LKZ
     C                   EVAL      S80160      = WKPOLZ                         EMPFÄNGER-PLZ
     C                   EVAL      S80170      = WKWORT                         EMPFÄNGER ORT
     C                   EVALR     S80180      = %TRIM(AMKDNR)                  EMPFÄNGER EIGEN
     C                   EVAL      S80190      = *BLANK                         FRACHTZAHLER-NAME-1
     C                   EVAL      S80200      = *BLANK                         FRACHTZAHLER-NAME-2
     C                   EVAL      S80210      = *BLANK                         FRACHTZAHLER-STRASSE
     C                   EVAL      S80220      = *BLANK                         FRACHTZAHLER-LKZ
     C                   EVAL      S80230      = *ZERO                          FRACHTZAHLER-PLZ
     C                   EVAL      S80240      = *BLANK                         FRACHTZAHLER-ORT
     C                   EVAL      S80250      = *ZERO                          WARENWERT
     C                   Z-ADD     WKNABT        S80260                         NACHNAHMEBETRAG
     C                   EVAL      S80270      = *BLANK                         BORDEROTEXT
     C                   EVAL      S80300      = WKMAA2                         RECHNUNGSTEXT
     C                   EVAL      S80310      = WKTOUR                         TOUR
     C                   Z-ADD     WKGWBR        S80320                         GEWICHT
     C                   EVAL      DUC002      = WKFRAN                         FRANKATUR
     C                   EVAL      S80340      = DUN020
     C                   EVAL      S80350      = WKTENR                         ARTNR. 1
     C                   EVAL      S80360      = 1                              ANZ.VERPACKUNG 1
     C                   WRITE     SPED801
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE HELLMANN AKTION                                           ***
     C**************************************************************************
     C     AUSGM4A0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDA01
     C                   EVAL      SA0SATZART  = 'S'
     C                   EVAL      SA0PRODUKT  = 'HEV'
     C                   EVAL      SA0NIEDERL  = '490'
     C                   EVAL      SA0STATUS   = '1'
     C                   EVAL      SA0VDATUM   = %CHAR(WKDATE)
     C                   EVAL      SA0KDNR     = WKSPFI
     C                   EVAL      SA0REFNR    = WKREFN
     C                   EVAL      SA0VNAME1   = WRNAM1
     C                   EVAL      SA0VNAME2   = WRNAM2
     C                   EVAL      SA0VSTR     = WRSTRA
     C                   EVAL      SA0VLAND    = WRPOLD
     C                   EVAL      SA0VPLZ     = WRPOLZ
     C                   EVAL      SA0VORT     = WRWORT
     C                   EVAL      SA0EKDNR    = '  ' + AMKDNR                  EMPFÄNGER EIGEN
     C                   EVAL      SA0ENAME1   = WKNAM1
     C                   EVAL      SA0ENAME2   = WKNAM2
     C                   EVAL      SA0ESTR     = WKSTRA
     C                   EVAL      SA0ELAND    = LNLISO
     C                   EVAL      SA0EPLZ     = WKPOLZ
     C                   EVAL      SA0EORT     = WKWORT
     C                   EVAL      SA0FRANKA   = WKFRAN                         FRANKATURKZ.
     C                   EVAL      SA0ANZ1     = %CHAR(WKAZPL)                  ANZAHL1
     C                   EVAL      SA0VERP1    = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      SA0GEW1     = %CHAR(WKGWPL)                  SENDUNGSGEWICHT
     C                   EVAL      SA0WARENI1  = TXPRGR                         WARENINHALT
     C                   EVAL      SA0WWERT    = *BLANK                         WARENWERT
     C                   EVAL      SA0WAE      = *BLANK                         WÄHRUNG
     C                   EVAL      SA0VOL      = *BLANK                         VOLUMEN
     C                   EVAL      SA0LADEMTR  = *BLANK                         LADEMETER
     C                   EVAL      SA0NNBETR   = *BLANK                         NACHNAHMEBETRAG
     C                   EVAL      SA0WAENN    = WKWACD                         WÄHRUNG NACHNAHME
     C                   EVAL      SA0ARTNN    = *BLANK                         ART DER NACHNAHME
     C                   EVAL      SA0E_ANR    = WKMAAF                         EMPFÄNGER AUFTRAGNR.
     C                   EVAL      SA0TEXTNR1  = WKTNR1                         TEXTNR. 1
     C                   EVAL      SA0TEXTZU1  = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      SA0TEXTNR2  = WKTNR2                         TEXTNR. 2
     C                   EVAL      SA0TEXTZU2  = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      SA0TEXTNR3  = WKTNR3                         TEXTNR. 3
     C                   EVAL      SA0TEXTZU3  = WKTXT3                         TEXTZUSATZ 3
     C*
     C                   WRITE     SPEDA01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE DPD AKTION                                                ***
     C**************************************************************************
     C     AUSGM4B0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      ASSPED      = '92214'                        NORMAL
     C                   WHEN      ASSPED      = '92216'                        AKTION
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDB01
     C                   EVAL      SB0010      = %SUBST(AMKDNR:1:6)             KD.-NR.
     C                   EVAL      SB0015      = WKNAM1                         NAME 1
     C                   EVAL      SB0020      = WKNAM2                         NAME 2
     C                   EVAL      SB0025      = WKNAM3                         NAME 3
     C                   EVAL      SB0030      = WKSTRA                         STRASSE
     C                   EVAL      SB0035      = WKPOLD                         LAND
     C                   EVAL      SB0040      = WKPLZL                         PLZ
     C                   EVAL      SB0045      = WKWORT                         ORT
     C                   Z-ADD     WKAZPL        SB0050                         PAKETE
     C                   Z-ADD     WKGWPL        SB0055                         GEWICHT
     C** nicht füllen    EVAL      SB0060      = %CHAR(WKDATE) Fehler           DATUM
     C                   EVAL      SB0065      = WKREFN                         LIEFERSCHEIN
     C                   EVAL      SB0070      = *BLANK                         RECHNUNG
     C                   Z-ADD     *ZERO         SB0075                         PACKSTÜCK
     C                   Z-ADD     WKNABT        SB0080                         NACHNAHME BETRAG
     C                   EVAL      SB0085      = WKWACD                         WÄHRUNG
     C                   EVAL      SB0090      = *BLANK                         ZAHLUNGSART
     C                   EVAL      SB0095      = *BLANK                         VERW.ZWECK
     C                   EVAL      SB0100      = *BLANK                         TELEFON
     C                   EVAL      SB0105      = *BLANK                         TELEFAX
     C                   MOVEL(P)  WKFRAN        DUC001
     C                   Z-ADD     DUN010        SB0110                         PAKETSCHEINART
     C                   Z-ADD     *ZERO         SB0305                         ZUSTELLUNGSZEIT
     C                   EVAL      SB0310      = *BLANK                         DRINGLK.STUFE
     C                   EVAL      SB0315      = *BLANK                         KOSTENSTELLE
     C                   EVAL      SB0320      = *BLANK                         FREIFELD 1
     C                   EVAL      SB0325      = *BLANK                         FREIFELD 2
     C                   EVAL      SB0330      = *BLANK                         FREIFELD 3
     C                   EVAL      SB0335      = *BLANK                         INHALT
     C                   EVAL      SB0490      = *BLANK                         NEUTRAL KDNR
     C                   EVAL      SB0495      = *BLANK                         NEUTRAL NAME 1
     C                   EVAL      SB0500      = *BLANK                         NEUTRAL NAME 2
     C                   EVAL      SB0505      = *BLANK                         NEUTRAL NAME 3
     C                   EVAL      SB0510      = *BLANK                         NEUTRAL STRASSE
     C                   EVAL      SB0515      = *BLANK                         NEUTRAL LAND
     C                   EVAL      SB0520      = *BLANK                         NEUTRAL PLZ
     C                   EVAL      SB0525      = *BLANK                         NEUTRAL ORT
     C                   EVAL      SB0530      = *BLANK                         NEUTRAL TELEFON
     C                   EVAL      SB0535      = *BLANK                         NEUTRAL TELEFAX
     C                   EVAL      SB0590      = WKLFDN                         LFD.NUMMER
     C                   WRITE     SPEDB01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE NIGHTSTAR                                                 ***
     C**************************************************************************
     C     AUSGM4C0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   NSE_F0
     C                   EVAL      NSESATZART  = 'S'
     C                   EVAL      NSEPRODUKT  = 'NSE'                          NIGHT STAR
     C                   EVAL      NSENIEDERL  = '490'
     C                   EVAL      NSESTATUS   = '1'
     C                   EVAL      NSEVDATUM   = %CHAR(WKDATE)
     C                   EVAL      NSEKDNR     = WKSPFI
     C                   EVAL      NSEREFNR    = WKREFN
     C                   EVAL      NSEVNAME1   = WRNAM1
     C                   EVAL      NSEVNAME2   = WRNAM2
     C                   EVAL      NSEVSTR     = WRSTRA
     C                   EVAL      NSEVLAND    = WRPOLD
     C                   EVAL      NSEVPLZ     = WRPOLZ
     C                   EVAL      NSEVORT     = WRWORT
     C                   EVAL      NSEEKDNR    = '  ' + AMKDNR                  EMPFÄNGER EIGEN
     C                   EVAL      NSEENAME1   = WKNAM1
     C                   EVAL      NSEENAME2   = WKNAM2
     C                   EVAL      NSEESTR     = WKSTRA
     C                   EVAL      NSEELAND    = LNLISO
     C                   EVAL      NSEEPLZ     = WKPOLZ
     C                   EVAL      NSEEORT     = WKWORT
     C                   EVAL      NSEFRANKA   = WKFRAN                         FRANKATURKZ.
     C                   EVAL      NSEANZ1     = %CHAR(WKANZA)                  ANZAHL1
     C                   EVAL      NSEVERP1    = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      NSEGEW1     = %CHAR(WKGWBR)                  SENDUNGSGEWICHT
     C                   EVAL      NSEWARENI1  = TXPRGR                         WARENINHALT
     C                   EVAL      NSEWWERT    = *BLANK                         WARENWERT
     C                   EVAL      NSEWAE      = *BLANK                         WÄHRUNG
     C                   EVAL      NSEVOL      = *BLANK                         VOLUMEN
     C                   EVAL      NSELADEMTR  = *BLANK                         LADEMETER
     C                   EVAL      NSENNBETR   = *BLANK                         NACHNAHMEBETRAG
     C                   EVAL      NSEWAENN    = WKWACD                         WÄHRUNG NACHNAHME
     C                   EVAL      NSEARTNN    = *BLANK                         ART DER NACHNAHME
     C                   EVAL      NSEE_ANR    = WKMAAF                         EMPFÄNGER AUFTRAGNR.
     C                   EVAL      NSETEXTNR1  = WKTNR1                         TEXTNR. 1
     C                   EVAL      NSETEXTZU1  = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      NSETEXTNR2  = WKTNR2                         TEXTNR. 2
     C                   EVAL      NSETEXTZU2  = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      NSETEXTNR3  = WKTNR3                         TEXTNR. 3
     C                   EVAL      NSETEXTZU3  = WKTXT3                         TEXTZUSATZ 3
     C*
     C                   WRITE     NSE_F0
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SCHENKER KOPF                                             ***
     C**************************************************************************
     C     AUSGM4D0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDD01
     C                   EVAL      SCH010      = 'S'
     C                   EVAL      SCH020      = WKREFN
     C                   EVAL      SCH030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      SCH040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      SCH050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      SCH060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      DUC005      = WRPOLZ                         ABSENDER PLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      SCH070      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      SCH080      = WRWORT                         ABSENDER ORT
     C                   EVAL      SCH090      = WKSPFI
     C                   EVAL      SCH110      = *BLANK                         STATUS
     C                   EVAL      SCH120      = WKNAM1
     C                   EVAL      SCH130      = WKNAM2
     C                   EVAL      SCH140      = WKSTRA
     C                   EVAL      SCH150      = WKPOLD
     C                   EVAL      DUC005      = WKPOLZ
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      SCH160      = DUN050
     C                   ENDIF
     C*
     C                   EVAL      SCH170      = WKWORT
     C                   EVALR     SCH180      = %SUBST(AMKDNR:1:6)             EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        SCH260                         NACHNAHMEBETRAG
     C                   EVAL      SCH270      = WKREF1                         BORDEROTEXT
     C                   EVAL      SCH290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      SCH300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      SCH310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGWBR        SCH320                         SENDUNGSGEWICHT
     C                   EVAL      DUC002      = WKFRAN
     C                   EVAL      SCH340      = DUN020                         FRANKATURKZ.
     C                   EVAL      SCH350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        SCH360                         ANZAHL 1
     C                   EVAL      SCH370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      SCH380      = TXMCBG                         MATCHCODE
     C                   EVAL      SCH450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      SCH460      = '$$R$$'                        INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      SCH470      = DUN070                         ILN WAECO
     C                   EVAL      SCH475      = WKILNE                         ILN EMPF.
     C                   EVAL      SCH480      = *BLANK                         NVE
     C                   EVAL      SCH490      = WKKTNR                         HUBKETTE
     C*
     C                   IF        WKKTN2     <> *BLANK
     C                   EVAL      SCH490      = %TRIM(WKKTN2) + ';' +
     C                                           %TRIM(WKKTNR)
     C                   ENDIF
     C*
     C                   EVAL      SCH500      = %TRIM(WKGST1)                  GESCHÄFTSSTELLE
     C*
     C                   IF        WKGST2     <> *BLANK
     C                   EVAL      SCH500      = %TRIM(WKGST2) + ';' +
     C                                           %TRIM(WKGST1)
     C                   ENDIF
     C*
     C                   EVAL      SCH510      = WKTOUR                         NAHVERKEHRSTOUR
     C                   EVAL      SCH520      = 'N'                            DRUCKEN J/N
     C                   WRITE     SPEDD01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SCHENKER POSITIONEN                                       ***
     C**************************************************************************
     C     AUSGM4D1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDD01
     C                   EVAL      SCH010      = ' '
     C                   EVAL      SCH020      = WKREFN
     C                   Z-ADD     WKGWBR        SCH320                         SENDUNGSGEWICHT
     C                   EVAL      SCH350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        SCH360                         ANZAHL 1
     C                   EVAL      SCH370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      SCH380      = TXMCBG                         MATCHCODE
     C                   EVAL      SCH450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVALR     SCH475      = '*NVE*'                        ILN EMPF.
     C                   EVAL      SCH480      = WKSSCC                         NVE
     C                   WRITE     SPEDD01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KÜHNE+NAGEL KOPF                                          ***
     C**************************************************************************
     C     AUSGM4F0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDF01
     C                   EVAL      KUN010      = 'K'
     C                   EVAL      KUN020      = WKREFN
     C                   EVAL      KUN030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      KUN040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      KUN050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      KUN060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      KUN070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      KUN080      = WRWORT                         ABSENDER ORT
     C                   EVAL      KUN090      = WKSPFI
     C                   EVAL      KUN110      = *BLANK                         STATUS
     C                   EVAL      KUN120      = WKNAM1
     C                   EVAL      KUN130      = WKNAM2
     C                   EVAL      KUN140      = WKSTRA
     C                   EVAL      KUN150      = WKPOLD
     C                   EVAL      KUN160      = WKPOLZ
     C                   EVAL      KUN170      = WKWORT
     C                   EVAL      KUN180      = AMKDNR                         EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        KUN260                         NACHNAHMEBETRAG
     C                   EVAL      KUN270      = WKREF1                         BORDEROTEXT
     C                   EVAL      KUN290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      KUN300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      KUN310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGEWI        KUN320                         SENDUNGSGEWICHT
     C                   EVAL      KUN340      = WKFRAN                         FRANKATURKZ.
     C                   EVAL      KUN350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        KUN360                         ANZAHL 1
     C                   EVAL      KUN370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      KUN380      = TXMCBG                         MATCHCODE
     C                   EVAL      KUN450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      KUN460      = *BLANK                         INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      KUN470      = DUN070                         ILN WAECO
     C                   EVAL      KUN475      = WKILNE                         ILN EMPF.
     C                   EVAL      KUN480      = *BLANK                         NVE
     C                   EVAL      KUN490      = *BLANK                         HUBKETTE
     C                   EVAL      KUN500      = *BLANK                         GESCHÄFTSSTELLE
     C                   EVAL      KUN510      = *BLANK                         NAHVERKEHRSTOUR
     C                   EVAL      KUN520      = 'N'                            DRUCKEN J/N
     C                   WRITE     SPEDF01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KÜHNE+NAGEL POSITIONEN                                    ***
     C**************************************************************************
     C     AUSGM4F1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDF01
     C                   EVAL      KUN010      = 'P'
     C                   EVAL      KUN020      = WKREFN
     C                   Z-ADD     WKGWBR        KUN320                         SENDUNGSGEWICHT
     C                   EVAL      KUN350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        KUN360                         ANZAHL 1
     C                   EVAL      KUN370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      KUN380      = TXMCBG                         MATCHCODE
     C                   EVAL      KUN450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVALR     KUN475      = '*NVE*'                        ILN EMPF.
     C                   EVAL      KUN480      = WKSSCC                         NVE
     C                   EVAL      KUN540      = WKLANG                         LÄNGE
     C                   EVAL      KUN550      = WKBREI                         BREITE
     C                   EVAL      KUN560      = WKHOHE                         HÖHE
     C                   WRITE     SPEDF01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SCHENKER KOPF                                             ***
     C**************************************************************************
     C     AUSGM4G0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDG01
     C                   EVAL      SC2010      = 'S'
     C                   EVAL      SC2020      = WKREFN
     C                   EVAL      SC2030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      SC2040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      SC2050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      SC2060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      SC2070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      SC2080      = WRWORT                         ABSENDER ORT
     C                   EVAL      SC2090      = WKSPFI
     C                   EVAL      SC2110      = *BLANK                         STATUS
     C                   EVAL      SC2120      = WKNAM1
     C                   EVAL      SC2130      = WKNAM2
     C                   EVAL      SC2140      = WKSTRA
     C                   EVAL      SC2150      = WKPOLD
     C                   EVAL      SC2160      = WKPOLZ
     C                   EVAL      SC2170      = WKWORT
     C                   EVAL      SC2180      = AMKDNR                         EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        SC2260                         NACHNAHMEBETRAG
     C                   EVAL      SC2270      = WKREF1                         BORDEROTEXT
     C                   EVAL      SC2290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      SC2300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      SC2310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGEWI        SC2320                         SENDUNGSGEWICHT
     C                   EVAL      SC2340      = WKFRAN                         FRANKATURKZ.
     C                   EVAL      SC2350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        SC2360                         ANZAHL 1
     C                   EVAL      SC2370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      SC2380      = TXMCBG                         MATCHCODE
     C                   EVAL      SC2450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      SC2460      = *BLANK                         INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      SC2470      = DUN070                         ILN WAECO
     C                   EVAL      SC2475      = WKILNE                         ILN EMPF.
     C                   EVAL      SC2480      = *BLANK                         NVE
     C                   EVAL      SC2490      = WKKTNR                         HUBKETTE
     C*
     C                   IF        WKKTN2     <> *BLANK
     C                   EVAL      SC2490      = %TRIM(WKKTN2) + ';' +
     C                                           %TRIM(WKKTNR)
     C                   ENDIF
     C*
     C                   EVAL      SC2500      = %TRIM(WKGST1)                  GESCHÄFTSSTELLE
     C*
     C                   IF        WKGST2     <> *BLANK
     C                   EVAL      SC2500      = %TRIM(WKGST2) + ';' +
     C                                           %TRIM(WKGST1)
     C                   ENDIF
     C*
     C                   EVAL      SC2510      = WKTOUR                         NAHVERKEHRSTOUR
     C                   EVAL      SC2520      = 'N'                            DRUCKEN J/N
     C                   WRITE     SPEDG01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SCHENKER POSITIONEN                                       ***
     C**************************************************************************
     C     AUSGM4G1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDG01
     C                   EVAL      SC2010      = 'P'
     C                   EVAL      SC2020      = WKREFN
     C                   Z-ADD     WKGWBR        SC2320                         SENDUNGSGEWICHT
     C                   EVAL      SC2350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     1             SC2360                         ANZAHL 1
     C                   EVAL      SC2370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      SC2380      = TXMCBG                         MATCHCODE
     C                   EVAL      SC2450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVALR     SC2475      = '*NVE*'                        ILN EMPF.
     C                   EVAL      SC2480      = WKSSCC                         NVE
     C                   EVAL      SC2540      = WKLANG                         LÄNGE
     C                   EVAL      SC2550      = WKBREI                         BREITE
     C                   EVAL      SC2560      = WKHOHE                         HÖHE
     C                   WRITE     SPEDG01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE BRT ITALIEN KOPF                                          ***
     C**************************************************************************
     C     AUSGM4H0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDH01
     C                   EVAL      BRT010      = 'S'
     C                   EVAL      BRT020      = WKREFN
     C                   EVAL      BRT030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      BRT040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      BRT050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      BRT060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      BRT070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      BRT080      = WRWORT                         ABSENDER ORT
     C                   EVAL      BRT090      = WKSPFI
     C                   EVAL      BRT110      = *BLANK                         STATUS
     C                   EVAL      BRT120      = WKNAM1
     C                   EVAL      BRT130      = WKNAM2
     C                   EVAL      BRT140      = WKSTRA
     C                   EVAL      BRT150      = WKPOLD
     C                   EVAL      BRT160      = WKPOLZ
     C                   EVAL      BRT170      = WKWORT
     C                   EVAL      BRT180      = AMKDNR                         EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        BRT260                         NACHNAHMEBETRAG
     C                   EVAL      BRT270      = WKREF1                         BORDEROTEXT
     C                   EVAL      BRT290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      BRT300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      BRT310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGEWI        BRT320                         SENDUNGSGEWICHT
     C                   EVAL      BRT340      = WKFRAN                         FRANKATURKZ.
     C                   EVAL      BRT350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        BRT360                         ANZAHL 1
     C                   EVAL      BRT370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      BRT380      = TXMCBG                         MATCHCODE
     C                   EVAL      BRT450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      BRT460      = *BLANK                         INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      BRT470      = DUN070                         ILN WAECO
     C                   EVAL      BRT475      = WKILNE                         ILN EMPF.
     C                   EVAL      BRT480      = *BLANK                         NVE
     C                   EVAL      BRT490      = WKKTNR                         HUBKETTE
     C*
     C                   IF        WKKTN2     <> *BLANK
     C                   EVAL      BRT490      = %TRIM(WKKTN2) + ';' +
     C                                           %TRIM(WKKTNR)
     C                   ENDIF
     C*
     C                   EVAL      BRT500      = %TRIM(WKGST1)                  GESCHÄFTSSTELLE
     C*
     C                   IF        WKGST2     <> *BLANK
     C                   EVAL      BRT500      = %TRIM(WKGST2) + ';' +
     C                                           %TRIM(WKGST1)
     C                   ENDIF
     C*
     C                   EVAL      BRT510      = WKTOUR                         NAHVERKEHRSTOUR
     C                   EVAL      BRT520      = 'N'                            DRUCKEN J/N
     C                   EVAL      BRT640      = WKTNR1                         TEXTNR. 1
     C                   EVAL      BRT650      = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      BRT660      = WKTNR2                         TEXTNR. 2
     C                   EVAL      BRT670      = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      BRT680      = WKTNR3                         TEXTNR. 3
     C                   EVAL      BRT690      = WKTXT3                         TEXTZUSATZ 3
     C                   WRITE     SPEDH01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE BRT ITALIEN POSITIONEN                                    ***
     C**************************************************************************
     C     AUSGM4H1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDH01
     C                   EVAL      BRT010      = 'P'
     C                   EVAL      BRT020      = WKREFN
     C                   Z-ADD     WKGWBR        BRT320                         SENDUNGSGEWICHT
     C                   EVAL      BRT350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     1             BRT360                         ANZAHL 1
     C                   EVAL      BRT370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      BRT380      = TXMCBG                         MATCHCODE
     C                   EVAL      BRT450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVALR     BRT475      = '*NVE*'                        ILN EMPF.
     C                   EVAL      BRT480      = WKSSCC                         NVE
     C                   EVAL      BRT540      = WKLANG                         LÄNGE
     C                   EVAL      BRT550      = WKBREI                         BREITE
     C                   EVAL      BRT560      = WKHOHE                         HÖHE
     C                   WRITE     SPEDH01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE TNT KOPF                                                  ***
     C**************************************************************************
     C     AUSGM4I0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDI01
     C                   EVAL      TNT010      = 'S'
     C                   EVAL      TNT020      = WKREFN
     C                   EVAL      TNT030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      TNT040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      TNT050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      TNT060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      TNT070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      TNT080      = WRWORT                         ABSENDER ORT
     C                   EVAL      TNT090      = WKSPFI
     C                   EVAL      TNT110      = *BLANK                         STATUS
     C                   EVAL      TNT120      = WKNAM1
     C                   EVAL      TNT130      = WKNAM2
     C                   EVAL      TNT140      = WKSTRA
     C                   EVAL      TNT150      = WKPOLD
     C                   EVAL      TNT160      = WKPOLZ
     C                   EVAL      TNT170      = WKWORT
     C                   EVAL      TNT180      = AMKDNR                         EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        TNT260                         NACHNAHMEBETRAG
     C                   EVAL      TNT270      = WKREF1                         BORDEROTEXT
     C                   EVAL      TNT290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      TNT300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      TNT310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGWB3        TNT320                         SENDUNGSGEWICHT
     C                   EVAL      TNT340      = WKFRA1                         FRANKATURKZ.
     C                   EVAL      TNT350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        TNT360                         ANZAHL 1
     C                   EVAL      TNT370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      TNT380      = TXMCBG                         MATCHCODE
     C                   EVAL      TNT450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      TNT460      = *BLANK                         INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      TNT470      = DUN070                         ILN WAECO
     C                   EVAL      TNT475      = WKILNE                         ILN EMPF.
     C                   EVAL      TNT480      = *BLANK                         NVE
     C                   EVAL      TNT490      = *BLANK                         HUBKETTE
     C                   EVAL      TNT500      = WKRLTN                         GESCHÄFTSSTELLE
     C                   EVAL      TNT510      = *BLANK                         NAHVERKEHRSTOUR
     C                   EVAL      TNT520      = 'N'                            DRUCKEN J/N
     C                   EVAL      TNT640      = WKTNR1                         TEXTNR. 1
     C                   EVAL      TNT650      = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      TNT660      = WKTNR2                         TEXTNR. 2
     C                   EVAL      TNT670      = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      TNT680      = WKTNR3                         TEXTNR. 3
     C                   EVAL      TNT690      = WKTXT3                         TEXTZUSATZ 3
     C                   WRITE     SPEDI01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE TNT POSITIONEN                                            ***
     C**************************************************************************
     C     AUSGM4I1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDI01
     C                   EVAL      TNT010      = 'P'
     C                   EVAL      TNT020      = WKREFN
     C                   Z-ADD     WKGWB3        TNT320                         SENDUNGSGEWICHT
     C                   EVAL      TNT350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     1             TNT360                         ANZAHL 1
     C                   EVAL      TNT370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      TNT380      = TXMCBG                         MATCHCODE
     C                   EVAL      TNT450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      TNT480      = WKBARC                         BARCODE
     C                   EVAL      TNT520      = 'N'                            DRUCKEN J/N
     C                   EVAL      TNT540      = WKLANG                         LÄNGE
     C                   EVAL      TNT550      = WKBREI                         BREITE
     C                   EVAL      TNT560      = WKHOHE                         HÖHE
     C                   WRITE     SPEDI01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE LOXX KOPF                                                 ***
     C**************************************************************************
     C     AUSGM4K0      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDK01
     C                   EVAL      LOX010      = 'S'
     C                   EVAL      LOX020      = WKREFN
     C                   EVAL      LOX030      = WRNAM1                         ABSENDER NAME 1
     C                   EVAL      LOX040      = WRNAM2                         ABSENDER NAME 2
     C                   EVAL      LOX050      = WRSTRA                         ABSENDER STRASSE
     C                   EVAL      LOX060      = WRPOLD                         ABSENDER LKZ
     C                   EVAL      LOX070      = WRPOLZ                         ABSENDER PLZ
     C                   EVAL      LOX080      = WRWORT                         ABSENDER ORT
     C                   EVAL      LOX090      = WKSPFI
     C                   EVAL      LOX110      = *BLANK                         STATUS
     C                   EVAL      LOX120      = WKNAM1
     C                   EVAL      LOX130      = WKNAM2
     C                   EVAL      LOX140      = WKSTRA
     C                   EVAL      LOX150      = WKPOLD
     C                   EVAL      LOX160      = WKPOLZ
     C                   EVAL      LOX170      = WKWORT
     C                   EVAL      LOX180      = AMKDNR                         EMPFÄNGER EIGEN
     C                   Z-ADD     WKNABT        LOX260                         NACHNAHMEBETRAG
     C                   EVAL      LOX270      = WKREF1                         BORDEROTEXT
     C                   EVAL      LOX290      = '000000000'                    TEXTZUSATZ
     C                   EVAL      LOX300      = '01' + %SUBST(AMKDNR:1:6) +    RECHNUNGSTEXT
     C                                           AMKMNR + '1'
     C                   EVAL      LOX310      = WKTOUR                         TOURNUMMER
     C                   Z-ADD     WKGWB3        LOX320                         SENDUNGSGEWICHT
     C                   EVAL      LOX340      = WKFRA1                         FRANKATURKZ.
     C                   EVAL      LOX350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     WKANZA        LOX360                         ANZAHL 1
     C                   EVAL      LOX370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      LOX380      = TXMCBG                         MATCHCODE
     C                   EVAL      LOX450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      LOX460      = *BLANK                         INHALT 3
     C                   EVAL      DUC007      = WKILNW
     C                   EVAL      LOX470      = DUN070                         ILN WAECO
     C                   EVAL      LOX475      = WKILNE                         ILN EMPF.
     C                   EVAL      LOX480      = *BLANK                         NVE
     C                   EVAL      LOX490      = *BLANK                         HUBKETTE
     C                   EVAL      LOX500      = WKRLTN                         GESCHÄFTSSTELLE
     C                   EVAL      LOX510      = *BLANK                         NAHVERKEHRSTOUR
     C                   EVAL      LOX520      = 'N'                            DRUCKEN J/N
     C                   EVAL      LOX640      = WKTNR1                         TEXTNR. 1
     C                   EVAL      LOX650      = WKTXT1                         TEXTZUSATZ 1
     C                   EVAL      LOX660      = WKTNR2                         TEXTNR. 2
     C                   EVAL      LOX670      = WKTXT2                         TEXTZUSATZ 2
     C                   EVAL      LOX680      = WKTNR3                         TEXTNR. 3
     C                   EVAL      LOX690      = WKTXT3                         TEXTZUSATZ 3
     C                   WRITE     SPEDK01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE LOXX POSITIONEN                                           ***
     C**************************************************************************
     C     AUSGM4K1      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SPEDK01
     C                   EVAL      LOX010      = 'P'
     C                   EVAL      LOX020      = WKREFN
     C                   Z-ADD     WKGWB3        LOX320                         SENDUNGSGEWICHT
     C                   EVAL      LOX350      = TXPRGR                         ZEICHEN 1
     C                   Z-ADD     1             LOX360                         ANZAHL 1
     C                   EVAL      LOX370      = WKCDVP                         VERPACKUNGSCODE 1
     C                   EVAL      LOX380      = TXMCBG                         MATCHCODE
     C                   EVAL      LOX450      = 'N'                            VERPACKUNGSSCHLÜSSEL
     C                   EVAL      LOX480      = WKBARC                         BARCODE
     C                   EVAL      LOX520      = 'N'                            DRUCKEN J/N
     C                   EVAL      LOX540      = WKLANG                         LÄNGE
     C                   EVAL      LOX550      = WKBREI                         BREITE
     C                   EVAL      LOX560      = WKHOHE                         HÖHE
     C                   WRITE     SPEDK01
     C*--------------------------------------------------------
     C                   ADD       1             WKSAZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SATZART M990 AUSGEBEN                                             ***
     C**************************************************************************
     C     AUSGM990      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKGSGW        DUN180                         GESAMTGEWICHT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKKOPF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERTEILEN AUSGABE NACH SPEDITEUR                                  ***
     C**************************************************************************
     C     VERTEIL       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      ASSPED      = '90164'       OR
     C                             ASSPED      = '92215'       OR
     C                             ASSPED      = '92219'       OR
     C                             ASSPED      = '92221'
     C                   EXSR      AUSGM400                                     HELLMANN
     C                   WHEN      (ASSPED     = '92213' AND DAFIRM ='01') OR
     C                             (ASSPED     = '0000726' AND DAFIRM ='52') OR
     C                             (ASSPED     = '0000726' AND DAFIRM ='08')
     C                   EXSR      AUSGM410                                     PARTS EXPRESS
     C                   WHEN      ASSPED      = '90163'
     C                   EXSR      AUSGM420                                     HAMACHER
     C                   WHEN      ASSPED      = '90864'
     C                   EXSR      AUSGM430                                     TRANS-O-FLEX
     C                   WHEN      ASSPED      = '90748'
     C                   EXSR      AUSGM440                                     GERMAN PARCEL/GLS
     C                   WHEN      ASSPED      = '91258'
     C                   EXSR      AUSGM440                                     GLS MARKET INTERVENT
     C                   WHEN      ASSPED      = '92220'
     C                   EXSR      AUSGM440                                     GLS DOMETIC SIEGEN
     C                   WHEN      ASSPED      = '92214'
     C                   EXSR      AUSGM450                                     DPD
     C                   WHEN      ASSPED      = '90292'
     C                   EXSR      AUSGM460                                     BOLL/UNITRANS
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '9xxxx'
     C                   EXSR      AUSGM470                                     ADLATUS
     C                   WHEN      ASSPED      = '90330'
     C                   EXSR      AUSGM480                                     DACHSER
     C                   WHEN      ASSPED      = '92217'
     C                   EXSR      AUSGM4A0                                     HELLMANN AKTION
     C                   WHEN      ASSPED      = '92216'
     C                   EXSR      AUSGM4B0                                     DPD AKTION
     C                   WHEN      ASSPED      = '90796'
     C                   EXSR      AUSGM4C0                                     NIGHT STAR
     C                   WHEN      ASSPED      = '90481'
     C                   EXSR      EGSTL
     C                   EXSR      AUSGM4D0                                     SCHENKER OBI
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '92222'
     C                   EXSR      AUSGM4F0                                     KÜHNE + NAGEL
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '92224'
     C                   EXSR      EGSTL
     C                   EXSR      AUSGM4G0                                     SCHENKER
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '92225'
     C                   EXSR      AUSGM4H0                                     BRT ITALIEN
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '90169'
     C                   EXSR      AUSGM4I0                                     TNT
     C                   EXSR      EAFVS
     C                   WHEN      ASSPED      = '92230'
     C                   EXSR      AUSGM4K0                                     LOXX
     C                   EXSR      EAFVS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LAUFENDE NUMMER                                         ***
     C**************************************************************************
     C     ERLFDN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        ASSPED      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKSPSN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYSPDPWKNR
     C                   MOVEL(P)  ASSPED        KYSPDPSPED
     C                   MOVEL     ASJDAT        KYSPDPJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSPDP
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO                          DATENSATZ EXISTIERT
     C                   MOVEL(P)  ASWKNR        KYSPDPWKNR                     NICHT
     C                   MOVEL(P)  ASSPED        KYSPDPSPED
     C                   Z-ADD     *HIVAL        KYSPDPJAHR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHSPDP
     C*
     C                   IF        WKFENR      = *ZERO         AND              LFD.NUMMER AUS VOR-
     C                             SPDPFIRM    = KYSPDPFIRM    AND              JAHR ÜBERNEHMEN
     C                             SPDPWKNR    = KYSPDPWKNR    AND
     C                             SPDPSPED    = KYSPDPSPED
     C                   Z-ADD     SPDPSPSN      WKSPSN
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYSPDPWKNR
     C                   MOVEL(P)  ASSPED        KYSPDPSPED
     C                   MOVEL     ASJDAT        KYSPDPJAHR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHSPDP
     C*-------------------------------------------------------------------------
     C                   EVAL      SPDPSPSN    = SPDPSPSN + WKSPSN + 1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        SPDPJNAM
     C                   MOVEL(P)  EXPSDSPROC    SPDPPROG
     C                   MOVEL(P)  EXPSDSBIBL    SPDPBIBL
     C                   MOVEL(P)  EXPSDSUSER    SPDPUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        SPDPJZEI
     C                   MOVE      WKTDAT        SPDPJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHSPDP                                       FÜGEN
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHSPDP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SPDPSPSN      WKLFDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AUFTRAGS-SPEDITIONSDATEN                                   ***
     C**************************************************************************
     C     UAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYASJH
     C                   MOVEL(P)  ASNUMM        KYASNR
     C                   MOVEL(P)  ASKART        KYASKA
     C                   MOVEA     '01CU    '    CHI                            LESEN/UPDATEN
     C                   EXSR      CHAFSP
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  DAJNAM        ASJNAM
     C                   MOVEL(P)  EXPSDSPROC    ASPROG
     C                   MOVEL(P)  EXPSDSBIBL    ASBIBL
     C                   MOVEL(P)  EXPSDSUSER    ASUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        ASJZEI
     C                   MOVE      WKTDAT        ASJDAT
     C*--------------------------------------------------------
     C                   Z-ADD     ASJDAT        ASSPDA
     C                   MOVEL(P)  '10'          ASSTAT
     C*--------------------------------------------------------
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHAFSP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN LIEFERSCHEINE                                         ***
     C**************************************************************************
     C     VAFLK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYKLAJ      = AMAFJJ
     C                   EVAL      KYKLAF      = AMAFNR
     C                   EVAL      KYKLJH      = *ZERO
     C                   EVAL      KYKLLI      = *BLANK
     C                   MOVEA     '09+     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             KLFIRM      = KYKLFI        AND
     C                             KLAFJJ      = KYKLAJ        AND
     C                             KLAFNR      = KYKLAF
     C                   EVAL      KYKLJH      = KLLIJJ
     C                   EVAL      KYKLLI      = KLLINR
     C                   IF        WKAZLS      < 99
     C                   EVAL      WKAZLS      = WKAZLS + 1
     C                   ENDIF
     C                   MOVEA     '09R     '    CHI
     C                   EXSR      CHAFLK
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKAZLS      < 2
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKAZLS      = 2
     C                   EVAL      DUC001      = '0'
     C                   WHEN      WKAZLS      = 3
     C                   EVAL      DUC001      = '1'
     C                   WHEN      WKAZLS      = 4
     C                   EVAL      DUC001      = '2'
     C                   WHEN      WKAZLS      = 5
     C                   EVAL      DUC001      = '3'
     C                   WHEN      WKAZLS      = 6
     C                   EVAL      DUC001      = '4'
     C                   WHEN      WKAZLS      = 7
     C                   EVAL      DUC001      = '5'
     C                   WHEN      WKAZLS      = 8
     C                   EVAL      DUC001      = '6'
     C                   WHEN      WKAZLS      = 9
     C                   EVAL      DUC001      = '7'
     C                   WHEN      WKAZLS      = 10
     C                   EVAL      DUC001      = '8'
     C                   WHEN      WKAZLS      = 11
     C                   EVAL      DUC001      = '9'
     C                   WHEN      WKAZLS      = 12
     C                   EVAL      DUC001      = 'A'
     C                   WHEN      WKAZLS      = 13
     C                   EVAL      DUC001      = 'B'
     C                   WHEN      WKAZLS      = 14
     C                   EVAL      DUC001      = 'C'
     C                   WHEN      WKAZLS      = 15
     C                   EVAL      DUC001      = 'D'
     C                   WHEN      WKAZLS      = 16
     C                   EVAL      DUC001      = 'E'
     C                   WHEN      WKAZLS      = 17
     C                   EVAL      DUC001      = 'F'
     C                   WHEN      WKAZLS      = 18
     C                   EVAL      DUC001      = 'G'
     C                   WHEN      WKAZLS      = 19
     C                   EVAL      DUC001      = 'H'
     C                   WHEN      WKAZLS      = 20
     C                   EVAL      DUC001      = 'I'
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EVAL      WKMAA2      = %TRIM(WKMAAF) + DUC001
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN LIEFERPOSITIONEN                                      ***
     C**************************************************************************
     C     VAFLP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIARK
     C                   MOVE      *OFF          WKILFT
     C                   Z-ADD     *ZERO         WKGWNT
     C                   MOVE      *BLANK        TXPRGR
     C                   MOVE      *BLANK        TXMCBG
     C                   MOVE      *BLANK        WKTENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASFIRM        KYALFI
     C                   Z-ADD     ASJAHR        KYALKJ
     C                   MOVEL(P)  ASNUMM        KYALKN
     C                   Z-ADD     *ZERO         KYALKP
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     ALFIRM        IFNE      KYALFI                                       URSPRUNGSGRENZE
     C     ALKMJJ        ORNE      KYALKJ                                       UNTER BZW.
     C     ALKMNR        ORNE      KYALKN                                       ÜBERSCHRITTEN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  ALTENR        KYTENR                         ERMITTELN DATEN
     C                   MOVEA     '01C     '    CHI                            AUS IDENTSTAMM
     C                   EXSR      CHTEIL
     C*
     C     CHI(5)        IFEQ      'N'
     C                   Z-ADD     *ZERO         TEGWNT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        TXPRGR      = *BLANK
     C                   EVAL      TXMCBG      = TEMCBG
     C*
     C                   MOVEL(P)  DASPCD        KYTPSP
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  TEPRGR        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   EVAL      TXPRGR      = TPTTXT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  ALTENR        KYTUTE                         UMRECHNEN
     C                   MOVEL(P)  ALMEIN        KYTUME                         GELIEFERTE
     C                   Z-ADD     ALGLMG        WKV1V2                         MENGE IN
     C                   Z-ADD     ALAFDA        WKTUEGDATE
     C                   EXSR      VTEUF                                        IDENTSTAMM-ME
     C                   Z-ADD     WKV1V2        WKGLMG
     C*
     C                   MOVEL(P)  DASPCD        KYTPSP
     C                   MOVEL(P)  'GDIM'        KYTPTA                         ERMITTELN GEWICHT
     C                   MOVEL(P)  TEGWDI        KYTPTC                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKGLMG        MULT(H)   TEGWNT        WKN112                         GEWICHT NETTO
     C                   DIV(H)    TPTNUM        WKN112
     C     WKN112        MULT(H)   1             WKN050
     C                   ADD       WKN050        WKGWNT                         SUMME GEWICHT
     C*--------------------------------------------------------
     C     WKILFT        IFEQ      *OFF                                         ERMITTELN
     C                   Z-ADD     ALAFJJ        KYAPJH                         LIEFERTERMIN AUS
     C                   MOVEL(P)  ALAFNR        KYAPAF                         AUFTRAGSPOSITION
     C                   Z-ADD     ALAFPO        KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*
     C                   IF        WKFENR      = *ZERO         AND
     C                             (APLFDR     = '1'           OR               AN DIESEM TAG
     C                             APLFDR      = '2')                           BIS ZU DIESEM TAG
     C                   MOVE      *ON           WKILFT
     C                   EVAL      WKLFTE      = %CHAR(APLFTE)
     C                   EVAL      WKLFT2      = %SUBST(%CHAR(APLFTE):7:2) +
     C                                           '.' +
     C                                           %SUBST(%CHAR(APLFTE):5:2) +
     C                                           '.' +
     C                                           %SUBST(%CHAR(APLFTE):3:2)
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     ALLIJJ        WKLIJJ
     C                   MOVEL(P)  ALLINR        WKLINR
     C*
     C     ALRGJJ        IFNE      WKRGJJ
     C     ALRGNR        ORNE      WKRGNR
     C                   Z-ADD     ALRGJJ        WKRGJJ                         RETTEN FÜR
     C                   MOVEL(P)  ALRGNR        WKRGNR                         ZUGRIFF RECHNUNG
     C                   MOVE      *ON           WKIARK
     C                   ENDIF
     C*--------------------------------------------------------
     C     ALLINR        IFEQ      *BLANK
     C                   MOVEL(P)  ALAFNR        ALLINR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKTENR      = *BLANK
     C                   EVAL      WKTENR      = ALTENR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '04R     '    CHI                            READ
     C                   EXSR      CHAFLP
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKEN DER KOPFDATEN                                             ***
     C**************************************************************************
     C     DRKOPF        BEGSR
     C*
     C                   ADD       1             PTSEIT
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR1
     C                   WRITE     EXDR00
     C                   WRITE     EXSTR1
     C                   WRITE     EXDR01
     C                   WRITE     EXDR02
     C                   WRITE     EXLEER
     C                   WRITE     EXDR03
     C                   WRITE     EXSTR1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     14            DSZEZA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZEILENZAEHLER                                                     ***
     C**************************************************************************
     C     ZEILZA        BEGSR
     C*
     C     WKSPAZ        ADD       WKZEZA        DSZEZA
     C*-------------------------------------------------------------------------
     C     DSZEZA        IFGE      WKSPUZ
     C                   EXSR      DRKOPF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LEITGEBIET                                              ***
     C**************************************************************************
     C     ELGEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKLGEB      = *BLANK
     C                   EVAL      WKFACH      = *BLANK
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOBPLZV  = WKPOLZ
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHWAOB
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             WAOBFIRM    = KYWAOBFIRM    AND
     C                             WAOBPLZB   >= WKPOLZ
     C                   EVAL      WKLGEB      = WAOBLGEB
     C                   EVAL      WKFACH      = WAOBABFA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN NACHNAHMEBETRAG                                         ***
     C**************************************************************************
     C     ENABT         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        ASSPED     <> '92213'                        NICHT PARTS EXPRESS
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKCODB      = *ZERO                          KEINE NACHNAHME
     C                   EVAL      WKWACD      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKCODB        WKNABT                         GESAMTBETRAG
     C*-------------------------------------------------------------------------
     C* ÜBER WAO8 PRÜFEN, OB DIE GELIEFERTE MENGE DER BESTELLTEN MENGE ENTSPRICHT
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C                   MOVEA     *ZERO         FGCODP
     C                   MOVEA     *ZERO         FGCODU
     C                   MOVEA     *ZERO         FGAFPO
     C                   MOVEA     *ZERO         FGIFPO
     C                   MOVEA     *ZERO         FGBSMG
     C                   MOVEA     *ZERO         FGGLMG
     C                   MOVEA     *ZERO         FGKMJJ
     C                   MOVEA     *BLANK        FGKMNR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYWAO8AFJJ                     ÜBER DIE AUFTRAGNR.
     C                   MOVEL(P)  AMAFNR        KYWAO8AFNR                     DEN KOPF ERMITTELN
     C                   Z-ADD     *ZERO         KYWAO8AFPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHWAO8
     C*
     C                   IF        WKFENR     <> *ZERO         OR
     C                             WAO8FIRM   <> KYWAO8FIRM    OR
     C                             WAO8AFJJ   <> KYWAO8AFJJ    OR
     C                             WAO8AFNR   <> KYWAO8AFNR
     C                   EVAL      WKWACD      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO8IFFI  = WAO8IFFI
     C                   EVAL      KYWAO8IFNR  = WAO8IFNR
     C                   EVAL      KYWAO8IFPO  = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             WAO8IFFI    = KYWAO8IFFI    AND
     C                             WAO8IFNR    = KYWAO8IFNR
     C                   EVAL      I1          = I1 + 1
     C                   EVAL      FGCODP(I1)  = WAO8CODP                       Nettopreis p.Stück
     C                   EVAL      FGCODU(I1)  = WAO8CODU                       Betrag p.Stück
     C                   EVAL      FGAFPO(I1)  = WAO8AFPO                       Position
     C                   EVAL      FGIFPO(I1)  = WAO8IFPO
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHWAO8
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGIFPO(I1)  = 0
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYIFAPIFFI  = KYWAO8IFFI
     C                   EVAL      KYIFAPIFNR  = KYWAO8IFNR
     C                   EVAL      KYIFAPIFPO  = FGIFPO(I1)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHIFAP
     C                   EVAL      FGBSMG(I1)  = IFAPBSMG
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = 0
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYALJH      = AMAFJJ
     C                   EVAL      KYALAF      = AMAFNR
     C                   EVAL      KYALPO      = FGAFPO(I1)
     C                   EVAL      KYALKJ      = AMKMJJ
     C                   EVAL      KYALKN      = AMKMNR
     C                   EVAL      KYALKP      = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFLP
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             ALFIRM      = KYALFI        AND
     C                             ALAFJJ      = KYALJH        AND
     C                             ALAFNR      = KYALAF        AND
     C                             ALAFPO      = KYALPO        AND
     C                             ALKMJJ      = KYALKJ        AND
     C                             ALKMNR      = KYALKN
     C                   EVAL      FGGLMG(I1)  = ALGLMG
     C                   EVAL      FGKMJJ(I1)  = ALKMJJ
     C                   EVAL      FGKMNR(I1)  = ALKMNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      WKIBER      = *OFF
     C                   EVAL      I1          = 0
     C*-------------------------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1) <> *ZERO         OR
     C                             FGBSMG(I1) <> FGGLMG(I1)
     C                   EVAL      WKIBER      = *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1)  = *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKIBER      = *OFF                           LIEFERUNG ENTSPRICHT
     C                   EXSR      UWAO8                                        DER BESTELLUNG
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* BERECHNEN NACHNAHMEBETRAG
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C                   EVAL      WKBETR      = 0
     C                   EVAL      DUN134      = 0
     C*--------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C                   EVAL      DUN134      = FGCODP(I1) * FGGLMG(I1)
     C                   EVAL      WKBETR      = WKBETR + DUN134
     C                   EVAL      DUN134      = FGCODU(I1) * FGGLMG(I1)
     C                   EVAL      WKBETR      = WKBETR + DUN134
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1)  = *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      WKBETR      = WKBETR + WKCODV                Versandkosten
     C                   EVAL      WKBETR      = WKBETR + WKCODK                Verpackungskosten
     C                   EVAL      WKBETR      = WKBETR + WKCODI                Versicherungskosten
     C*--------------------------------------------------------
     C                   IF        WKCODM     <> *ZERO
     C                   EVAL(H)   WKMWST      = WKBETR * (WKCODM/100)
     C                   EVAL(H)   WKBETR      = WKBETR + WKMWST                MWST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     WKBETR        WKNABT
     C*-------------------------------------------------------------------------
     C*                            WKCODW                                       COD Währung
     C*                            WKCODS                                       Skonto
     C*-------------------------------------------------------------------------
     C                   EXSR      UWAO8
     C*-------------------------------------------------------------------------
     C                   IF        WKNABT      = 0
     C                   EVAL      WKWACD      = *BLANK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN NACHNAHMEBETRAG SC                                      ***
     C**************************************************************************
     C     ENABT1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        AKKDNR     <> '055278' AND                   NICHT ITALY
     C                             AKKDNR     <> '098264' AND                   NICHT SIEGEN
     C                             AKKDNR     <> '040631' AND                   NICHT GB
     C                             AKKDNR     <> '054939'                       NICHT ÖSTERREICH
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKCODB      = *ZERO                          KEINE NACHNAHME
     C                   EVAL      WKWACD      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKCODB        WKNABT                         GESAMTBETRAG
     C*-------------------------------------------------------------------------
     C                   IF        WKNABT      = 0
     C                   EVAL      WKWACD      = *BLANK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN NACHNAHMEBETRAG                                         ***
     C**************************************************************************
     C     ENABT2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        ASSPED      = '92213'                        PARTS EXPRESS
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKZABD        KYZBZA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZABD
     C*
     C                   IF        ZBNAKZ     <> DAJNKZ
     C                   EVAL      WKWACD      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFKN
     C                   MOVEL(P)  'TRSP16'      EXANPROG
     C                   MOVEL(P)  'AFLK'        EXANDANA
     C                   Z-ADD     KYKLJH        EXANAFJJ
     C                   MOVEL(P)  KYKLLI        EXANAFNR
     C                   MOVE      *ON           EXANAFKN
     C                   MOVE      *ON           EXANMWST
     C                   MOVE      *ON           EXANSKTO
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM(1)        #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'VEAFKN'
     C                   PARM                    EXTR02
     C                   PARM                    EXAFKN
     C                   PARM                    RTAFKN
     C*------------------------------------------------------------
     C                   IF        RTANFENR    = *ZERO
     C                   Z-ADD     RTANBRSU      WKNABT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXZABD
     C                   MOVEL(P)  WKZABD        EXZABDZABD
     C                   MOVEL(P)  DASPCD        EXZABDSPCD
     C                   Z-ADD     KLLSDA        EXZABDREDA
     C                   Z-ADD     WKNABT        EXZABDBRSU
     C                   Z-ADD     WKNABT        EXZABDSKFB
     C                   MOVEL     'AFZABD'      EXZABDPGST
     C                   CALL      'ERZABD'
     C                   PARM                    EXZABD
     C                   PARM                    RTZABD
     C*
     C                   EVAL      WKNABT      = WKNABT - RTZABDSKB1
     C*-------------------------------------------------------------------------
     C                   IF        WKNABT      < 0
     C                   EVAL      WKNABT      = *ZERO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKNABT      = 0
     C                   EVAL      WKWACD      = *BLANK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE WAO8                                                       ***
     C**************************************************************************
     C     UWAO8         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*-------------------------------------------------------------------------
     C                   DO        999
     C                   EVAL      I1          = I1 + 1
     C*--------------------------------------------------------
     C                   IF        FGAFPO(I1)  = *ZERO         AND
     C                             FGIFPO(I1)  = *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYWAO8IFFI  = KYIFAPIFFI                     UPDATE STATUS
     C                   EVAL      KYWAO8IFNR  = KYIFAPIFNR
     C                   EVAL      KYWAO8IFPO  = FGIFPO(I1)
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHWAO8
     C*--------------------------------------------------------
     C                   IF        FGKMNR(I1)  = *BLANK        AND
     C                             WAO8KMNR    = *BLANK
     C                   EVAL      WAO8CODV    = *ZERO
     C                   EVAL      WAO8CODK    = *ZERO
     C                   EVAL      WAO8CODI    = *ZERO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        FGKMNR(I1) <> *BLANK
     C                   EVAL      WAO8KMJJ    = FGKMJJ(I1)
     C                   EVAL      WAO8KMNR    = FGKMNR(I1)
     C                   EVAL      WAO8IFST    = '90'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WAO8ERUS    = *BLANK
     C                   EVAL      WAO8ERUS    = WAO8USER
     C                   ENDIF
     C*
     C                   IF        WAO8ERDA    = *ZERO
     C                   EVAL      WAO8ERDA    = WAO8JDAT
     C                   ENDIF
     C*
     C                   IF        WAO8ERZT    = *ZERO
     C                   EVAL      WAO8ERZT    = WAO8JZEI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        FGKMNR(I1) <> *BLANK
     C                   MOVEL(P)  DAJNAM        WAO8JNAM
     C                   MOVEL(P)  EXPSDSPROC    WAO8PROG
     C                   MOVEL(P)  EXPSDSBIBL    WAO8BIBL
     C                   MOVEL(P)  EXPSDSUSER    WAO8USER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        WAO8JZEI
     C                   MOVE      WKTDAT        WAO8JDAT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAO8
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN GESCHÄFTSSTELLEN/TOUR                                   ***
     C**************************************************************************
     C     EGSTL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKGST1      = *BLANK
     C                   EVAL      WKGST2      = *BLANK
     C                   EVAL      WKTOUR      = *BLANK
     C                   EVAL      WKHUB1      = *BLANK
     C                   EVAL      WKHUB2      = *BLANK
     C                   EVAL      WKKTNR      = *BLANK
     C                   EVAL      WKKTN2      = *BLANK
     C                   EVAL      WKIGST      = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOHPOLZ  = WKPOLZ                         PLZ PRÜFEN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOH
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      WKTOUR      = '950'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOIGENR  = '84'                           Schenker Osnabrück
     C                   EVAL      KYWAOIPOLZ  = WKPOLZ
     C*-------------------------------------------------------------------------
     C     1             DO        3             WKZUGR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHWAOI
     C                   EXSR      ERWAOI
     C*--------------------------------------------------------
     C                   IF        WKIGST      = *ON                            ROUTING BEENDET
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN ROUTING                                                 ***
     C**************************************************************************
     C     ERWAOI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WAOIPOLZ      IFGT      WKPOLZ
     C     WKFENR        ORNE      *ZERO
     C                   EVAL      WKTOUR      = '950'
     C                   EVAL      WKIGST      = *ON
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKZUGR        CASEQ     1             ERROUTE01
     C     WKZUGR        CASEQ     2             ERROUTE02
     C     WKZUGR        CASEQ     3             ERROUTE03
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  1. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE01     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   EVAL      WKGST1      = %SUBST(WAOITOUR:2:2)
     C                   EVAL      KYWAOIGENR  = %SUBST(WAOITOUR:2:2)
     C                   EVAL      WKIGST      = *OFF                           NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKGST1      = WAOITOUR                       3 STELLEN !
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  2. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE02     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   EVAL      WKGST2      = %SUBST(WAOITOUR:2:2)
     C                   EVAL      KYWAOIGENR  = %SUBST(WAOITOUR:2:2)
     C                   EVAL      WKIGST      = *OFF                           NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EXSR      ERWAOJ
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EXSR      ERWAOJ
     C                   EVAL      WKIGST      = *ON
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  3. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE03     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   EVAL      WKGST1      = *BLANK                         GEFUNDENE WERTE
     C                   EVAL      WKGST2      = *BLANK                         LÖSCHEN
     C                   EVAL      WKTOUR      = '950'
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Zugriff auf HUB-Datei WAOJ                                        ***
     C**************************************************************************
     C     ERWAOJ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOJGENR  = '84'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C                   IF        WKFENR      = *ZERO
     C                   EVAL      WKHUB2      = WAOJHUBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOJGENR  = WKGST1
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C                   IF        WKFENR      = *ZERO
     C                   EVAL      WKKTNR      = WAOJKTNR
     C                   EVAL      WKHUB1      = WAOJHUBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKHUB1        WHENEQ    '31'
     C     WKHUB1        OREQ      '81'
     C                   EVAL      WKKTN2      = WKHUB1
     C     WKHUB1        WHENEQ    *BLANK
     C     WKHUB1        ANDEQ     WKHUB2
     C**                 EVAL                  = '91'                           NUR FÜR BARCODE
     C     WKHUB1        WHENNE    *BLANK
     C     WKHUB1        ANDNE     WKHUB2
     C**                 EVAL                  = '91'                           NUR FÜR BARCODE
     C     WKHUB1        WHENNE    *BLANK
     C     WKHUB1        ANDEQ     WKHUB2
     C**                 EVAL                  = WKHUB1                         NUR FÜR BARCODE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN BEWEGUNGUNDSTEXTE                                     ***
     C**************************************************************************
     C     VTXBE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      I1          = 0
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTBTA      = 'AFDA'
     C                   EVAL      KYTBJH      = AMAFJJ
     C                   EVAL      KYTBNR      = AMAFNR
     C                   EVAL      KYTBPO      = *ZERO
     C                   EVAL      KYTBUP      = *ZERO
     C                   EVAL      KYTBTC      = 'TXKO'
     C                   EVAL      KYTBA1      = *BLANK
     C                   EVAL      KYTBA2      = *BLANK
     C                   EVAL      KYTBSP      = *BLANK
     C                   EVAL      KYTBUC      = *BLANK
     C                   EVAL      KYTBZN      = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTXBE
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             TBFIRM      = KYTBFI        AND
     C                             TBTXAR      = KYTBTA        AND
     C                             TBJHJJ      = KYTBJH        AND
     C                             TBAFNR      = KYTBNR        AND
     C                             TBPOSI      = KYTBPO        AND
     C                             TBUPOS      = KYTBUP        AND
     C                             TBTCDE      = KYTBTC
     C*--------------------------------------------------------
     C     TBLFZN        IFEQ      *ZERO
     C                   MOVE      *OFF          WKTXBE
     C*
     C     TBDRK1        IFEQ      'F'
     C     TBDRK2        OREQ      'F'
     C     TBDRK3        OREQ      'F'
     C     TBDRK4        OREQ      'F'
     C     TBDRK5        OREQ      'F'
     C                   MOVE      *ON           WKTXBE
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKTXBE        IFEQ      *ON
     C                   EVAL      I1          = I1 + 1
     C*
     C                   SELECT
     C                   WHEN      I1          = 1
     C                   EVAL      WKTXT1      = TBTEXT
     C                   WHEN      I1          = 2
     C                   EVAL      WKTXT2      = TBTEXT
     C                   WHEN      I1          = 3
     C                   EVAL      WKTXT3      = TBTEXT
     C                   WHEN      I1          = 4
     C                   EVAL      WKTXT4      = TBTEXT
     C                   WHEN      I1          = 5
     C                   EVAL      WKTXT5      = TBTEXT
     C                   ENDSL
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTXBE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN RELATION                                                ***
     C**************************************************************************
     C     ERLTN         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKRLTN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LNLISO        KYWAOSLISO
     C                   MOVEL(P)  WKPOLZ        KYWAOSPLZV
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHWAOS
     C*
     C     CHI(5)        IFEQ      'J'
     C     WAOSFIRM      ANDEQ     KYWAOSFIRM
     C     WAOSLISO      ANDEQ     KYWAOSLISO
     C     WAOSPLZB      ANDGE     WKPOLZ
     C                   MOVEL(P)  WAOSRLTN      WKRLTN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN AUFTRAGSADRESSE                                         ***
     C**************************************************************************
     C     EAFAD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYADJH
     C                   MOVEL(P)  AMAFNR        KYADAF
     C                   MOVEL(P)  'ADVS'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C                   IF        WKFENR     <> '0000'
     C                   Z-ADD     AMAFJJ        KYADJH
     C                   MOVEL(P)  AMAFNR        KYADAF
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*
     C                   IF        WKFENR     <> '0000'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKNAM1      = ADNAM1
     C                   EVAL      WKNAM2      = ADNAM2
     C                   EVAL      WKNAM3      = ADNAM3
     C                   EVAL      WKSTRA      = ADSTRA
     C                   EVAL      WKPOLD      = ADPOLD
     C                   EVAL      WKPOLZ      = ADPOLZ
     C                   EVAL      WKWORT      = ADWORT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHAFVS
     C/COPY QCPYSRC,CHIFAK
     C/COPY QCPYSRC,CHIFAP
     C/COPY QCPYSRC,CHIFAT
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHLPIF
     C/COPY QCPYSRC,CHSPDA
     C/COPY QCPYSRC,CHSPDP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTXBE
     C/COPY QCPYSRC,CHVSBD
     C/COPY QCPYSRC,CHWAOB
     C/COPY QCPYSRC,CHWAOH
     C/COPY QCPYSRC,CHWAOI
     C/COPY QCPYSRC,CHWAOJ
     C/COPY QCPYSRC,CHWAOS
     C/COPY QCPYSRC,CHWAO8
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,CHZABD
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDAUM
     C/COPY QCPYSRC,VTEUF
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
