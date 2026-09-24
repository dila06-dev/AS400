     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE Verdichten FIBU-Sätze und Übertragen in Schnittstellendatei FQBATCH
     H**************************************************************************
     H*  Copyright 1998 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 23.12.1998
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 08.01.1999 Bei Parameter FIRM/BUHA/ZABD = *ON
     H*            Zahlungsbedingung rechtsbündig
     H*  Änderung: SZ 28.01.1999 Steuerbetrag in Fremdwährung errechnen (EURO)
     H*  Änderung: SZ 10.01.1999 Kurs als Mengennotiz ermitteln
     H*  Änderung: SZ 11.01.1999 Kurs bei Installationen außerhalb des WWU-Raums
     H*            als Preisnotiz zwischen den beteiligten Währungen ermitteln,
     H*            bei WWU-Währungen nicht als Notierung gegenüber dem EURO.
     H*  Änderung: SZ 11.01.1999 Nach Erweiterung FIBU Steuerbetrag in Fremd-
     H*            währung übergeben.
     H*  Änderung: SZ 14.01.1999 Bei Steuersplitt die Steuerbeträge aus der
     H*            Führungsbuchung auf die Positionen entsprechend des Steuer-
     H*            schlüssels verteilen.
     H*  Änderung: SZ 07.05.1999 Bei Eingangsrechnungen das Feld 'Zusatztext'
     H*            in BCRFNR übergeben, wenn das Feld 'Zusatztext' mit '$'
     H*            beginnt (Referenznummer Zahlschein).
     H*  Änderung: SZ 12.07.1999 Korrektur Übergabe Belegdatum
     H*  Änderung: SZ 13.07.1999 Arbeiten mit WK-Feldern statt FB-Feldern, da in
     H*            den FB-Feldern immer die Werte des Folgesatzes stehen
     H*  Anderung: SZ 13.07.1999 Übergabe Kostenträger aus BKT2 parallel zu
     H*            Kostenstelle aus BKT1
     H*  Änderung: SZ 22.07.1999 Bei Ausgangsrechnungen Gutschrift immer ZABD
     H*            '00' übergeben (sofort fällig)
     H*  Änderung: SZ 26.07.1999 Bei MODHAW Text 'RECHNUNG' bzw. 'GUTSCHRIFT'
     H*            abhängig von Belegart ausgeben.
     H*  Änderung: SZ 27.08.1999 Belegjahr in FIBU berücksichtigen, FIBU über
     H*            KEY 02 lesen.
     H*  Änderung: SZ 30.09.1999 Buchungstext bei Buchungsposition aus Tabelle,
     H*            wenn Tabelle gefüllt (TRKT16).
     H*  Änderung: SZ 05.10.1999 Abweichende Buchungsperiode anhand Parameter
     H*            FIRM/BUHA/SMGJ errechnen (abweichendes Geschäftsjahr)
     H*  Änderung: SZ 11.10.1999 Buchungstext bei Buchungskopf aus Tabelle,
     H*            wenn Tabelle gefüllt, bei Buchungsposition Kunden- bzw.
     H*            Lieferantenkurzname als Text. Wenn aber Tabelle TRKT16 auf
     H*            Position 5-8 gefüllt ist, dann diese Texte. Änderung vom
     H*            30.09.1999 somit ergänzt, Änderung vom 26.07.1999 bei MODHAW
     H*            entfernt, da jetzt über Tabelle steuerbar.
     H*  Änderung: SZ 15.12.1999 bei MODCAL *ON Bereich übergeben (WKNR)
     H*  Änderung: SZ 10.01.2000 SADREM gegen FQOPADR getauscht (Einmaladressen)
     H*  Änderung: SZ 30.11.2000 Aufgrund der Änderung in TRWAUM, wonach mit dem
     H*            Kurs Verkauf gerechnet wird, sofern vorhanden, muss bei der
     H*            Kursermittlung hier auch berücksichtigt werden, ob es sich um
     H*            den Kurs Einkauf bzw. den Kurs Verkauf handelt.
     H*  Änderung: SZ 09.01.2001 Die 7-stellige Belegnummer soll in den ersten
     H*            beiden Stellen die Jahreszahl und dann nur 5 Stellen der
     H*            Belegnummer enthalten. Das gilt nur für Ausgangsrechnungen.
     H*  Änderung: SZ 12.01.2001 Die Berechnung der Buchungsperiode bei
     H*            abweichendem Geschäftsjahr war falsch. Zur Prüfung der 2.
     H*            Hauswährung wird jetzt der Parameter FIRM/BUHA/WAC2 ebgefragt
     H*  Änderung: SZ 23.01.2001 Kennzeichen BCEFEU abhängig von WKFWCD füllen.
     H*  Änderung: SZ 09.08.2001 Übergabe Referenznummer auch für HAWA
     H*  Änderung: BA 10.01.2002 Übergabe Kostenträger nicht unter MODSUD
     H*  Änderung: SZ 27.02.2002 Anpassungen für Sachbuchungen
     H*  Änderung: SZ 28.05.2002 Modifikationen aus MODHAW wieder vollständig
     H*            integriert, jetzt wieder ein Programmstand. HAWA hat auf
     H*            Schilling Release 2.05 gewechselt, Projekt 1238
     H*  Änderung: SZ 07.06.2002 Anruf Hr. Wirz. Da die Belegnummer in Schilling
     H*            jetzt 10stellig ist, kann zur Vermeidung von doppelten
     H*            Nummern jetzt die vollständige Belegnummer von trend incl.
     H*            Jahr übergeben werden.
     H*  Änderung: SZ 08.10.2002 Hotline 11847, Feyco, Steuerbetrag in Fremd-
     H*            währung bei Teilbuchung nicht füllen, wenn Steuerbetrag in
     H*            Stammwährung = 0
     H*  Änderung: SZ 28.02.2003 Projekt 1506, HAWA, Buchungstext Kopf aus
     H*            erster Position ermitteln
     H*  Änderung: SZ 19.08.2004 Projekt 3036, HAWA, bei Eingangsrechnungen die
     H*            Kostenrechnungsfelder füllen.
     H*  Änderung: GD 20.04.2005  HAWA Ausgabe externe-Belegdatum als Belegadatum
     H*            Schilling.
     H*  Änderung: HR 12.05.2005  HAWA ab Schilling Releasestand 2.06
     H*            wird das Feld BCVRKZ nicht mehr verwendet
     H*  Änderung: SZ 02.11.2005 BCRELI mit Rechnungslistennr. füllen
     H*  Änderung: SZ 11.09.2007 HL8944, Mail Hr. Turowski, Schilling: Keine
     H*            Übergabe Steurercode, wenn Endbetrag Null
     H*  Änderung: SZ 28.12.2010 Projekt 7028, Dometic-WAECO, Buchung Warenein-
     H*            satz bei Ausgangsrechnungen.
     H*  Änderung: SZ 12.01.2011 Projekt 7028, Dometic-WAECO, Belegart Rechnungs
     H*            ausgang immer 'XRA', auch bei Gutschriften
     H*  Änderung: SZ 13.01.2011 Projekt 7028, Dometic-WAECO, Artikelnummer in
     H*            Feld "Infotext1".
     H*  Änderung: SZ 18.01.2011 Projekt 7028, Dometic-WAECO, aus WAEH ermitteln
     H*            ob der Kurs in Mengennotiz oder in Preisnotiz gepflegt wurde.
     H*  Änderung: SZ 19.01.2011 Projekt 7028, Dometic-WAECO, bei bestimmten
     H*            Konten müssen bei den Wareneinsatzbuchungen Splittbuchungen
     H*            erzeugt werden, da die Kostenstellen abweichen.
     H*  Änderung: SZ 21.01.2011 Projekt 7028, Dometic-WAECO, die Kostenstellen
     H*            müssen in den Sachbuchungen übergeben werden, da die Konten
     H*            keine Stammkostenstelle haben.
     H*  Änderung: SZ 22.01.2011 Projekt 7028, Dometic-WAECO, Zuordnung der
     H*            Kostenstellen zu den Konten geändert.
     H*  Änderung: SZ 22.02.2011 Projekt 7028, Dometic-WAECO, Gutschriften sind
     H*            sofort fällig.
     H*  Änderung: SZ 02.05.2011 Dometic-WAECO, keine Wareneinsatzbuchungen,
     H*            wenn Bestandsführung auf 'N' gestellt ist.
     H*  Änderung: SZ 05.05.2011 Dometic-WAECO, keine Wareneinsatzbuchungen,
     H*            wenn Statistik Menge auf 'N' gestellt ist, nicht Bestands-
     H*            führung.
     H*  Änderung: SZ 14.07.2011  HAWA, Feld AEOPNR wurde bei Einmaladressen
     H*            seit 1994 nicht gefüllt. Ist aber Keyelement in FQOPADR00.
     H*            Es gibt eine Dupkeymeldung wenn bei der gleichen Übernahme
     H*            zwei Einmaladressen mit der gleichen Adressnummer übergeben
     H*            werden.
     H*  Änderung: SZ 22.01.2013 Dometic CH, Wareneinsatzbuchung in Feld DM-
     H*            betrag übergeben, nicht Euro.
     H*            Personenkonten 5-stellig
     H*  Änderung: SZ 24.01.2013 Dometic CH, Untergrenze/Obergrenze bei Steuer-
     H*            splitt war mit 1,00 +/- zu gross. Auf 0,02 geändert.
     H*  Änderung: SZ 28.01.2013 Dometic CH, ESR Nummer auch bei Ausgangs-
     H*            rechnungen übergeben, für automatische Zuordnung der Zahlung.
     H*  Änderung: SZ 29.01.2013 Dometic CH, Absprache mit Herrn Steinbach,
     H*            Übergabe Belegnummer für Dometic CH ohne führendes Jahr. Dann
     H*            entspricht die OP Nummer der auf dem ESR Beleg gedruckten.
     H*  Änderung: SZ 31.01.2013 Dometic NL, Personenkonten 7-stellig
     H*  Änderung: SZ 31.01.2013 Dometic NL, Personenkonten 7-stellig mit füh-
     H*            render '0'
     H*  Änderung: SZ 13.02.2013 Dometic NL, bei Kontenklasse '9' keine Kosten-
     H*            stelle übergeben.
     H*  Änderung: SZ 24.02.2013 Dometic Projekt 9274, Zugriff BLKO zur Ermit-
     H*            tlung der Dokumenten Id bei Eingangsrechnungen zur Übergabe
     H*            als Belegnummer an Schilling.
     H*  Änderung: SZ 20.06.2013 Dometic Projekt 9649, Fälligkeit Gutschriften
     H*            für die Mandanten <> '01' abhängig von der Zahlungsbedingung
     H*  Änderung: RE 27.08.2013 Projekt 9822
     H*            neues Feld Projekt-Nr WAO9PJNR
     H*  Änderung: SZ 10.06.2015 Dometic CH, keine Übergabe Referenz bei 'ER'
     H*  Änderung: SZ 31.08.2015 Projekt 11614, Dometic AT, Integration Fa. '61'
     H*  Änderung: SZ 06.10.2015 Projekt 11614, Dometic AT, Wareneinsatzbuchung
     H*            auf abweichendes Konto, SR VFQBAW, EWAO9, KDNR = '054939'
     H*            Da aktuell aber nur Dometic AT auf Konto 108350 gebucht wird,
     H*            erfolgt die Ermittlung des Wareneinsatzkontos allein aufgrund
     H*            der Kontenzuordnung in WAO9, Begriff 'WEIN'. (Kto. 110380)
     H*  Änderung: SZ 15.10.2015 Projekt 11614, Dometic AT, Integration Fa. '61'
     H*            Übergabe Dokumenten-Id. als Belegnummer
     H*  Änderung: SZ 22.01.2016 Anforderung Hr. Schneider: Auftragsart '84' +
     H*            '85' Kostenstelle 011 einsetzen.
     H*  Änderung: JK 08.09.2017 Projekt 13108 Dometic / EZetil Kundennummer 8 stellig
     H*  Änderung: JK 08.09.2017 Projekt 13108 Dometic / EZetil Kundennummer 8 stellig
     H*  Änderung: JK 09.10.2020 Projekt 13108 Dometic / werkssteuerung für fibu mandant
     H*  Änderung: JK 03.12.2020 Projekt 13108 Dometic / Vorgänge aus Firma 01/Werk 005
     H*            mit Stammwährung CHF übergeben an die FiBu
     H*  Änderung: JK 24.02.2021 Korrektur wegen Rappenrundung - es kommt vor, dass ein-
     H*            und derselbe steuercode zweimal in der Führungskontierung zu stehen kommt
     H*            -->  mit steuerbetrag 2 = 0 - dann steuercode 2 auf *blank
     H*  Änderung: SZ 13.11.2021 Projekt 16858 Releasewechsel Schilling, Steuercode
     H*            Schilling jetzt 3-stellig.
     H*  Änderung: JK 03.07.2023 Projekt 230340 Dometic / Vorgänge aus Firma 01/Werk 010
     H*            mit Stammwährung SEK übergeben an die FiBu (analog der Anpassung vom
     H*            03.12.2023 projekt 13108)
     H*  Änderung: JK 31.10.2023 Projekt 230340 Wareneinsatzwert umrechnen in SEK
     H*            --> SR SRMODWAOW
     H*  Änderung: JK 19.12.2023 Projekt 230340 Medius flow
     H*            Medius Belegnummer als Belegnummer an Schilling und
     H*            trend Belegnummer als Buchungstext 1
     H*  Änderung: JK 09.07.2024 ELPS Ablösung
     H*  Änderung: JK 11.07.2024 dometic service case #03727973 IGLOO Daten für Schilling
     H*            Differenzen aus der SEK Umrechung ausgleichen (max. zulässig: 0,01 SEK)
     H*  Änderung: JK 12.07.2024 dometic service case #03727973 IGLOO Daten für Schilling
     H*            Ausgleichsroutine nur aufrufen, wenn aus trend Mandant 01 die Übergabe läuft
     H*            Ermitteln des FiBu Mandanten für IGLOO aus Datei
     H*  Änderung: MG 13.12.2024 DOMETIC Case 04088856 Ziel für eine numerische Operation zu klein
     H*            Erweiterung WKRUNDUNG und WKRUNDSUM von 5,2 auf 13,2 (like BCQDM)
     H**************************************************************************
     F*
     F*  Dieses Programm verdichtet auf Basis von gleichen Kontonummern die
     F*  Datei FIBU und überträgt die Werte summiert in die Schnittstellendatei
     F*  FQBATCH von Schilling. Die übernommenen Sätze erhalten als Status '99'.
     F*  Diese FIBU Sätze gelten als erledigt.
     F*
     F*  Die Personenkonten haben im Konzern Dometic aus historischen Gründen
     F*  unterschiedliche Längen. Ausserdem wurden die Nummern auch noch unter-
     F*  schiedlich in Schilling geführt, entweder mit angehängten Nullen oder
     F*  mit führenden Nullen. Hier die einzelnen Vorgaben:
     F*
     F*  Firma 01, Dometic-WAECO Emsdetten
     F*  Debitor  6-stellig, linksbündig
     F*  Kreditor 5-stellig, linksbündig
     F*
     F*  Firma 08, Dometic Halle, Belgien
     F*  Debitor  7-stellig, rechtsbündig
     F*  Kreditor 7,-stellig, linksbündig
     F*
     F*  Firma 20, EZetil
     F*  Debitor  8-stellig, rechtsbündig
     F*  Kreditor 8,-stellig, linksbündig
     F*
     F*  Firma 52, Dometic Etten-Leur, Niederlande
     F*  Debitor  7-stellig, rechtsbündig
     F*  Kreditor 7-stellig, linksbündig
     F*
     F*  Firma 55, Dometic Rümlang, Schweiz
     F*  Debitor  5-stellig, linksbündig
     F*  Kreditor 5-stellig, linksbündig
     F*
     F*  Firma 61, Dometic Österreich
     F*  Debitor  6-stellig, linksbündig
     F*  Kreditor 6-stellig, linksbündig
     F*
     F*  Die Belegnummer wird bei Ausgangs- und Eingangsrechnungen grundsätzlich
     F*  mit der trend Belegnummer mit führender Jahreszahl gefüllt, also 10-
     F*  stellig. Ausnahmen sind die Ausgangsrechnungen für Mandant '55' (CH).
     F*  Hier wird die Belegnummer ohne Jahr übergeben, da der Überweisungsbeleg
     F*  auch ohne Jahreszahl in der ESR Nummer erstellt wurde und ansonsten die
     F*  Zahlungen nicht automatisch zugeordnet werden können.
     F*  Weitere Ausnahme sind die Eingangsrechnungen bei Mandant '08' (BE).
     F*  Dort wird die Barcodenummer (Dokumenten Id) als Belegnummer übergeben.
     F*  Diese wird als fortlaufende Nummer auf die Eingangsrechnungen aufge-
     F*  klebt. Die Belege werden einem externen Dienstleister zum scannen über-
     F*  geben. Die Daten lasen sich anschliessend über die Dokumenten Id auf-
     F*  rufen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FFQOPADR   O  A E             DISK
     FFQBATCH   O  A E             DISK
     FFQBATCH00 UF   E           K DISK    RENAME(BCSATZ:BCSATZ00)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D*
     D KON             S             40    DIM(100)                             TEXT KONST. FELDG
     D W10             S              1    DIM(10)                              WORK-FELDGRP.
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
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
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFRK          E DS                  INZ
     D KYAFRK        E DS                  INZ
     D*
     D BBEL          E DS                  INZ
     D KYBBEL        E DS                  INZ
     D*
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D FIBU          E DS                  INZ
     D KYFIBU        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
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
     D WAEH          E DS                  INZ
     D KYWAEH        E DS                  INZ
     D*
     D WAO9          E DS                  INZ
     D KYWAO9        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D WKBCSATZ      E DS                  EXTNAME(FQBATCH) PREFIX(WK)
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D PF0             C                   CONST('0946827135')
     D PF1             C                   CONST('9468271350')
     D PF2             C                   CONST('4682713509')
     D PF3             C                   CONST('6827135094')
     D PF4             C                   CONST('8271350946')
     D PF5             C                   CONST('2713509468')
     D PF6             C                   CONST('7135094682')
     D PF7             C                   CONST('1350946827')
     D PF8             C                   CONST('3509468271')
     D PF9             C                   CONST('5094682713')
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKDISO         S               D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D EXWAUM        E DS                  INZ
     D EXNUUM        E DS                  INZ
     D*
     D EXKOND        E DS                  INZ
     D RTKOND        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D  DABEGR               242    243
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
     C*    Schlüssel für FQBATCH00
     C     KYFQB00       KLIST
     C                   KFLD                    WKBCFA
     C                   KFLD                    WKBCRCNR
     C                   KFLD                    KYBCFGKZ
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   EXSR      ERMKO
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   MOVEL(P)  '00'          KYFBST
     C                   MOVEA     '02L     '    CHI
     C                   EXSR      CHFIBU
     C*-------------------------------------------------------------------------
     C     *INLR         DOWNE     *ON
     C                   MOVEA     '02RU    '    CHI
     C                   EXSR      CHFIBU
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFNE      'J'                                          DATEIENDE
     C     FBFIRM        ORNE      KYFBFI
     C     FBSTAT        ORGT      KYFBST
     C*--------------------------------------------------------
     C     WKFIRM        IFNE      *BLANK
     C                   EXSR      VFQBAT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02F     '    CHI
     C                   EXSR      CHFIBU
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKFIRM        IFNE      *BLANK                                       ERSTER ZYKLUS
     C*--------------------------------------------------------
     C     FBFIRM        IFNE      WKFIRM                                       AUSGABE SATZ
     C     FBABTL        ORNE      WKABTL                                       BEI WECHSEL DES
     C     FBBLAT        ORNE      WKBLAT                                       SCHLÜSSELBEGRIFFS
     C     FBBLJJ        ORNE      WKBLJJ
     C     FBBLIN        ORNE      WKBLIN
     C     FBBUKZ        ORNE      WKBUKZ
     C     FBKTAT        ORNE      WKKTAT
     C     FBKTNR        ORNE      WKKTNR
     C     FBSHKZ        ORNE      WKSHKZ
     C     FBGKTA        ORNE      WKGKTA
     C     FBGKTN        ORNE      WKGKTN
     C     FBBAT1        ORNE      WKBAT1
     C     FBBKT1        ORNE      WKBKT1
     C     FBSTC1        ORNE      WKSTCD
     C     FBSKKZ        ORNE      WKSKKZ
     C     FBTENR        ORNE      WKTENR
     C                   EXSR      VFQBAT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FBFIRM        WKFIRM                         RETTEN DES
     C                   MOVEL(P)  FBBLAT        WKBLAT                         VERGLEICHSKEY
     C                   Z-ADD     FBBLJJ        WKBLJJ
     C                   MOVEL(P)  FBBLIN        WKBLIN
     C                   MOVEL(P)  FBBUKZ        WKBUKZ
     C                   MOVEL(P)  FBKTAT        WKKTAT
     C                   MOVEL(P)  FBKTNR        WKKTNR
     C                   MOVEL(P)  FBSHKZ        WKSHKZ
     C                   MOVEL(P)  FBGKTA        WKGKTA
     C                   MOVEL(P)  FBGKTN        WKGKTN
     C                   MOVEL(P)  FBBAT1        WKBAT1
     C                   MOVEL(P)  FBBKT1        WKBKT1
     C                   MOVEL(P)  FBSTC1        WKSTCD
     C                   MOVEL(P)  FBSKKZ        WKSKKZ
     C                   MOVEL(P)  FBABTL        WKABTL
     C                   MOVEL(P)  FBTENR        WKTENR
     C*-------------------------------------------------------------------------
     C                   EXSR      VFIBU
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      SRMODWAOI
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C                   MOVE      *ZERO         WKN032            3 2
     C                   MOVE      *ZERO         WKN152           15 2
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKW010FAKT        7 6          Faktor
     C                   MOVE      *ZERO         WKRUNDUNG        13 2          einzelner Rundungswe
     C                   MOVE      *ZERO         WKRUNDSUM        13 2          Summe Rundungswerte
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKPROG
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKBIBL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYADFI                         AFAD
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYKLFI                         AFLK
     C                   MOVEL(P)  DAFIRM        KYALFI                         AFLP
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYRKFI                         AFRK
     C                   MOVEL(P)  DAFIRM        KYELFI                         BBEL
     C                   MOVEL(P)  DAFIRM        KYBLKOFIRM                     BLKO
     C                   MOVEL(P)  DAFIRM        KYAEFI                         BWAE
     C                   MOVEL(P)  DAFIRM        KYFBFI                         FIBU
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYWAFI                         WAEH
     C                   MOVEL(P)  DAFIRM        KYWAO9FIRM                     WAO9
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETEREINSTELLUNGEN                                  ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRKT16'      KYTATC                         KUNDENSTATUS FÜR
     C                   MOVEL(P)  'KDST'        KYTAPA                         EINMALKUNDEN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKDST
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRBA70'      KYTATC                         STATUS FÜR
     C                   MOVEL(P)  'ELST'        KYTAPA                         EINMALLIEFERANT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKELST
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'POLD'        KYTATC                         POSTALISCHES
     C                   MOVEL(P)  'POLD'        KYTAPA                         LAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  TAPCDE        WKPOLD
     C                   ELSE
     C                   MOVE      *BLANK        WKPOLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'BUHA'        KYTATC                         STAMMWÄHRUNG
     C                   MOVEL(P)  'WACD'        KYTAPA                         FIBU
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTWC
     C*--------------------------------------------------------
     C     WKSTWC        IFEQ      *BLANK
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG
     C                   MOVEL(P)  'WACD'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTWC
     C                   ENDIF
     C                   EVAL      SVSTWC = WKSTWC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN 2.
     C                   MOVEL(P)  'BUHA'        KYTATC                         STAMMWÄHRUNG
     C                   MOVEL(P)  'WAC2'        KYTAPA                         FIBU
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTW2
     C*--------------------------------------------------------
     C     WKSTW2        IFEQ      *BLANK
     C                   MOVE      *HIVAL        WKSTW2
     C                   ENDIF
     C                   EVAL      SVSTW2 = WKSTW2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'LAND'        KYTATC                         STAMMLAND
     C                   MOVEL(P)  'LAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  TAPCDE        WKLAND
     C                   ELSE
     C                   MOVE      *BLANK        WKLAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'FIRM'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     TAPCDE        ANDNE     *BLANK
     C                   MOVEL(P)  TAPCDE        WKIFIR
     C                   ELSE
     C                   MOVEL(P)  'FIRM'        WKIFIR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'SMGJ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     TAPCDE        ANDNE     *BLANK
     C                   MOVEL(P)  TAPCDE        WKTRPASMGJ
     C                   ELSE
     C                   MOVEL(P)  '01'          WKTRPASMGJ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART DEBITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTDE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTDE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART KREDITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTKR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTKR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART SACHKONTO
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTSA'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTSA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART BEREICH-
     C                   MOVEL(P)  'BUHA'        KYTATC                         KONTO ERMITTELN
     C                   MOVEL(P)  'KTBE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTBE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART KOSTEN-
     C                   MOVEL(P)  'BUHA'        KYTATC                         TRÄGER ERMITTELN
     C                   MOVEL(P)  'KTKT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTKT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART PROJEKT
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTPJ'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTPJ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'DBNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKIDBN
     C*
     C     WKIDBN        IFNE      *ON
     C                   MOVE      *OFF          WKIDBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'KRNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKIKRN
     C*
     C     WKIKRN        IFNE      *ON
     C                   MOVE      *OFF          WKIKRN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'SANR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKISAN
     C*
     C     WKISAN        IFNE      *ON
     C                   MOVE      *OFF          WKISAN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'ZABD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAZABD
     C*
     C     WKTRPAZABD    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAZABD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'GUTS'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAGUTS
     C*
     C     WKTRPAGUTS    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAGUTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         BELEGART RECHNUNGS-
     C                   MOVEL(P)  'BUHA'        KYTATC                         AUSGANG ERMITTELN
     C                   MOVEL(P)  'BARA'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKBARA
     C*
     C     WKBARA        IFEQ      *BLANK
     C                   MOVEL(P)  'AR'          WKBARA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         BELEGART RECHNUNGS-
     C                   MOVEL(P)  'BUHA'        KYTATC                         EINGANG ERMITTELN
     C                   MOVEL(P)  'BARE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKBARE
     C*
     C     WKBARE        IFEQ      *BLANK
     C                   MOVEL(P)  'ER'          WKBARE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         BELEGART GUTSCHRIFT
     C                   MOVEL(P)  'BUHA'        KYTATC                         DEBITOR ERMITTELN
     C                   MOVEL(P)  'BAGD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKBAGD
     C*
     C     WKBAGD        IFEQ      *BLANK
     C                   MOVEL(P)  'GD'          WKBAGD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         BELEGART GUTSCHRIFT
     C                   MOVEL(P)  'BUHA'        KYTATC                         KREDITOR ERMITTELN
     C                   MOVEL(P)  'BAGK'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKBAGK
     C*
     C     WKBAGK        IFEQ      *BLANK
     C                   MOVEL(P)  'GK'          WKBAGK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         BELEGART SACHBUCHUNG
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'BASA'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKBASA
     C*
     C     WKBASA        IFEQ      *BLANK
     C                   MOVEL(P)  'SA'          WKBASA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         MANDANT FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'MAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMAND
     C*
     C     WKTRPAMAND    IFEQ      *BLANK
     C                   MOVEL(P)  '00'          WKTRPAMAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODFEY'      KYTATC
     C                   MOVEL(P)  'MODFEY'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODFEY
     C*
     C     MODFEY        IFNE      *ON
     C                   MOVE      *OFF          MODFEY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODCAL'      KYTATC
     C                   MOVEL(P)  'MODCAL'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODCAL
     C                   ELSE
     C                   MOVE      *OFF          MODCAL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODHAW'      KYTATC
     C                   MOVEL(P)  'MODHAW'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODHAW
     C                   ELSE
     C                   MOVE      *OFF          MODHAW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODKEL'      KYTATC
     C                   MOVEL(P)  'MODKEL'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODKEL
     C*
     C     MODKEL        IFNE      *ON
     C                   MOVE      *OFF          MODKEL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODMAS'      KYTATC
     C                   MOVEL(P)  'MODMAS'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODMAS
     C*
     C     MODMAS        IFNE      *ON
     C                   MOVE      *OFF          MODMAS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODSUD'      KYTATC
     C                   MOVEL(P)  'MODSUD'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODSUD
     C                   ELSE
     C                   MOVE      *OFF          MODSUD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'XLAFRK90'    KYTATA
     C                   MOVEL(P)  'INTR'        KYTATC
     C                   MOVEL(P)  'INTR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPTXT        WKTRPARFNR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KONSTANTE                                               ***
     C**************************************************************************
     C     ERMKO         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        KON
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKT16'      KYTPTA                         VORBEREITEN
     C                   MOVEL(P)  'TRKT16'      KYTPTC                         SCHLÜSSELFELDER
     C*--------------------------------------------------------
     C                   MOVEL(P)  KYTPFI        OFTPFI                         OBERGRENZE-
     C                   MOVEL(P)  KYTPSP        OFTPSP                         FELDER
     C                   MOVEL(P)  KYTPTA        OFTPTA
     C                   MOVEL(P)  KYTPTC        OFTPTC
     C*--------------------------------------------------------
     C                   MOVEA     '01L     '    CHI                            SETLL
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C                   DO        100           I1
     C                   MOVEA     '01R     '    CHI                            READ
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C     TPFIRM        ORGT      OFTPFI                                       OBERGRENZE
     C     TPSPCD        ORGT      OFTPSP                                       ÜBERSCHRITTEN
     C     TPTART        ORGT      OFTPTA
     C     TPTCDE        ORGT      OFTPTC
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  TPTTXT        KON(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUFROUTINE                                                    ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKLAND        KYLNNR                         IST DAS STAMMLAND
     C                   MOVEA     '01C     '    CHI                            AUS DEM WWU-RAUM?
     C                   EXSR      CHLAND
     C*
     C     LNWUKZ        IFEQ      DAJNKZ
     C     WKSTWC        OREQ      'EUR'
     C                   MOVE      *ON           WKWUKZ
     C                   ELSE
     C                   MOVE      *OFF          WKWUKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKSTC1
     C                   MOVE      *BLANK        WKSTC2
     C                   MOVE      *BLANK        WKSTC3
     C                   Z-ADD     *ZERO         WKSTB1
     C                   Z-ADD     *ZERO         OGSTB1
     C                   Z-ADD     *ZERO         WKSTB2
     C                   Z-ADD     *ZERO         OGSTB2
     C                   Z-ADD     *ZERO         WKSTB3
     C                   Z-ADD     *ZERO         OGSTB3
     C                   Z-ADD     *ZERO         WKSB1F
     C                   Z-ADD     *ZERO         OGSB1F
     C                   Z-ADD     *ZERO         WKSB2F
     C                   Z-ADD     *ZERO         OGSB2F
     C                   Z-ADD     *ZERO         WKSB3F
     C                   Z-ADD     *ZERO         OGSB3F
     C                   Z-ADD     *ZERO         WKSTP1
     C                   Z-ADD     *ZERO         WKSTP2
     C                   Z-ADD     *ZERO         WKSTP3
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN FIBU-SATZ                                             ***
     C**************************************************************************
     C     VFIBU         BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        FBFIRM = '01'
     C                             AND FBABTL = '005'
     C                   EVAL      WKSTWC = 'CHF'
     C                   EVAL      WKSTW2 = 'CHF'
     C                   ELSE
     C                   IF        FBFIRM = '01'
     C                             AND FBABTL = '010'
     C                   EVAL      WKSTWC = 'SEK'
     C                   EVAL      WKSTW2 = 'SEK'
     C                   ELSE
     C                   IF        WKSTWC <> SVSTWC
     C                             OR WKSTW2 <> SVSTW2
     C                   EVAL      WKSTWC = SVSTWC
     C                   EVAL      WKSTW2 = SVSTW2
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     FBJDAT        WKJDAT
     C                   Z-ADD     FBBDIN        WKBDIN
     C                   Z-ADD     FBBUDA        WKBUDA
     C                   Z-ADD     FBBDEX        WKBDEX
     C                   MOVEL(P)  FBBLEX        WKBLEX
     C                   Z-ADD     FBVADA        WKVADA
     C                   MOVEL(P)  FBFWCD        WKFWCD
     C                   MOVEL(P)  FBABTL        WKBUNR
     C                   MOVEL(P)  FBGKTN        WKGKT1
     C                   Z-ADD     FBPEDA        WKPEDA
     C                   MOVEL(P)  FBBUTX        WKBUTX
     C                   Z-ADD     FBKURS        WKKURS
     C                   MOVEL(P)  FBKSDM        WKKSDM
     C                   MOVEL(P)  FBPRGR        WKPRGR
     C                   ADD       FBGLMG        WKGLMG
     C                   MOVEL(P)  FBMEIN        WKMEIN
     C*--------------------------------------------------------
     C                   MOVEL(P)  FBSTC1        WKSTCD
     C                   Z-ADD     FBSTB1        WKSTBT
     C                   Z-ADD     FBSB1F        WKSTBF
     C                   Z-ADD     FBSTP1        WKSTPZ
     C*--------------------------------------------------------
     C     FBBUKZ        IFEQ      'F'                                          NUR BEI
     C                   MOVEL(P)  FBSTC1        WKSTC1                         FÜHRUNGSBUCHUNG
     C                   MOVEL(P)  FBSTC2        WKSTC2
     C                   MOVEL(P)  FBSTC3        WKSTC3
     C                   Z-ADD     FBSTB1        WKSTB1
     C                   Z-ADD     FBSTB1        OGSTB1
     C                   Z-ADD     FBSTB2        WKSTB2
     C                   Z-ADD     FBSTB2        OGSTB2
     C                   Z-ADD     FBSTB3        WKSTB3
     C                   Z-ADD     FBSTB3        OGSTB3
     C                   Z-ADD     FBSB1F        WKSB1F
     C                   Z-ADD     FBSB1F        OGSB1F
     C                   Z-ADD     FBSB2F        WKSB2F
     C                   Z-ADD     FBSB2F        OGSB2F
     C                   Z-ADD     FBSB3F        WKSB3F
     C                   Z-ADD     FBSB3F        OGSB3F
     C                   Z-ADD     FBSTP1        WKSTP1
     C                   Z-ADD     FBSTP2        WKSTP2
     C                   Z-ADD     FBSTP3        WKSTP3
     C                   Z-ADD     *ZERO         WKGLMG
     C*
     C*-------------------------------------------------------------------------
     C                   IF        FBFIRM = '01'
     C                             and FBABTL = '005'
     C                   EXSR      SRMODWAO1
     C                   ENDIF
     C                   IF        FBFIRM = '01'
     C                             and FBABTL = '010'
     C                   EXSR      SRMODWAO1S
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FBBAT2        WKBAT2
     C                   MOVEL(P)  FBBKT2        WKBKT2
     C                   MOVEL(P)  FBBAT3        WKBAT3
     C                   MOVEL(P)  FBBKT3        WKBKT3
     C*-------------------------------------------------------------------------
     C                   IF        FBFIRM = '01'
     C                             AND FBABTL = '005'
     C                   EXSR      SRMODWAO2
     C                   ELSE
     C                   IF        FBFIRM = '01'
     C                             AND FBABTL = '010'
     C                   EXSR      SRMODWAO2S
     C                   ELSE
     C                   ADD       FBBBLW        WKBBLW
     C                   ADD       FBBBFW        WKBBFW
     C                   ADD       FBSTB1        WKMWWL
     C                   ADD       FBSTB2        WKMWWL
     C                   ADD       FBSTB3        WKMWWL
     C                   ADD       FBSB1F        WKMWWF
     C                   ADD       FBSB2F        WKMWWF
     C                   ADD       FBSB3F        WKMWWF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     FBSKD1        WKSKD1
     C                   Z-ADD     FBSKT1        WKSKT1
     C                   Z-ADD     FBSKP1        WKSKP1
     C                   Z-ADD     FBSKB1        WKSKB1
     C                   Z-ADD     FBSKD2        WKSKD2
     C                   Z-ADD     FBSKT2        WKSKT2
     C                   Z-ADD     FBSKP2        WKSKP2
     C                   Z-ADD     FBSKB2        WKSKB2
     C                   Z-ADD     FBSKD3        WKSKD3
     C                   Z-ADD     FBSKT3        WKSKT3
     C                   Z-ADD     FBSKP3        WKSKP3
     C                   Z-ADD     FBSKB3        WKSKB3
     C                   Z-ADD     FBSKNT        WKSKNT
     C                   Z-ADD     FBFADA        WKFADA
     C                   MOVEL(P)  FBZABD        WKZABD
     C*-------------------------------------------------------------------------
     C     FBBUKZ        IFEQ      'F'                                          FÜR DRUCK ÜBERNAHME-
     C                   MOVEL(P)  '99'          FBSTAT                         PROTOKOLL AUF '80'
     C                   ELSE                                                   STELLEN
     C                   MOVEL(P)  '99'          FBSTAT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02U     '    CHI
     C                   EXSR      CHFIBU
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE FQBATCH-DATEI                                             ***
     C**************************************************************************
     C     VFQBAT        BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     WKBUKZ        WHENEQ    'F'                                          FÜHRUNGSBUCHUNG
     C                   EXSR      EAFRK
     C*
     C                   IF        DABEGR      = 'RE'
     C                   EVAL      WKFQBABLAT  = 'XSE'
     C                   EXSR      EBLKO
     C                   ELSE
     C                   EVAL      WKFQBABLAT  = 'XRA'
     C                   ENDIF
     C*
     C                   EXSR      VFQBAK
     C                   EXSR      VFQBAF
     C                   Z-ADD     BCRCNR        WKRCNR
     C*
     C                   SELECT
     C     WKKTAT        WHENEQ    '1'                                          PRUEFEN
     C                   EXSR      PEINK                                        EINMALKUNDE
     C     WKKTAT        WHENEQ    '2'                                          PRUEFEN
     C                   EXSR      PEINL                                        EINMALLIEFERANT
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKBUKZ        WHENEQ    'S'                                          SACHBUCHUNG
     C     WKBLAT        ANDEQ     WKBASA
     C                   EVAL      WKFQBABLAT  = 'XSB'
     C                   EXSR      VFQBAK
     C                   EXSR      VFQBAP
     C*--------------------------------------------------------
     C     WKBUKZ        WHENEQ    'T'                                          TEILBUCHUNG
     C     DABEGR        ANDEQ     'RA'
     C                   EXSR      VFQBAP
     C                   EVAL      WKFQBABLAT  = 'XSB'
     C                   EXSR      VFQBAK
     C                   EXSR      VFQBAW
     C                   EVAL      BCBGAR      = 'XRA'
     C*--------------------------------------------------------
     C     WKBUKZ        WHENEQ    'T'                                          TEILBUCHUNG
     C     DABEGR        ANDEQ     'RE'
     C                   EXSR      VFQBAP
     C*--------------------------------------------------------
     C     WKBUKZ        WHENEQ    'B'                                          BEREICHBUCHUNG
     C                   EXSR      VFQBAB
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKBBLW
     C                   Z-ADD     *ZERO         WKBBFW
     C                   Z-ADD     *ZERO         WKMWWL
     C                   Z-ADD     *ZERO         WKMWWF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERSTELLEN DATEN BUCHUNGSKOPF                                      ***
     C**************************************************************************
     C     VFQBAK        BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BCSATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '1'           BCSTAT
     C                   MOVEL(P)  '0208'        BCRSNR
     C                   Z-ADD     *ZERO         BCFA                           NUMERISCH
     C*--------------------------------------------------------
     C                   SELECT

     C     WKIFIR        WHENEQ    'FIRM'
     C     WKTRPAMAND    ANDNE     *ZERO
     C                   MOVE      WKTRPAMAND    BCFA
     C*
     C     WKIFIR        WHENEQ    'FIRM'
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        BCFA                           RECHTSBÜNDIG!
     C                   ENDIF
     C*
     C     WKIFIR        WHENEQ    'WERK'
     C                   EXSR      EWERK
     C*
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        BCFA                           RECHTSBÜNDIG!
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         BCRCNR
     C                   MOVEA(P)  'NUMMER'      KOM(01)
     C                   Z-ADD     WKBLJJ        DUN040
     C                   MOVEA     DUC004        KOM(11)
     C                   MOVEA     'FIBU'        KOM(15)
     C                   MOVEA(P)  KOM           #CKOMM
     C                   CALL      'TRNUMM'
     C                   PARM                    EXTR02
     C*
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA     KOM(11)       DUC010
     C                   Z-ADD     DUN100        BCRCNR
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCFGKZ
     C                   EVAL      BCBGAR      = WKFQBABLAT
     C                   MOVEL(P)  'N'           BCSTOR
     C*--------------------------------------------------------
     C     DABEGR        IFEQ      'RE'
     C                   MOVE      WKBDEX        BCBGJT                          ALPHA
     C                   ELSE
     C                   MOVE      WKBDIN        BCBGJT
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEDA        IFNE      *ZERO
     C                   EXSR      VPEDA
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKBLIN        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    BCBGNR
     C*
     C                   IF        DAFIRM     <> '55'
     C                   Z-ADD     WKBLJJ        DUN040
     C                   MOVEL     DUN040        BCBGNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C***                IF        DABEGR      = 'RE'          AND
     C                   IF        DABEGR      = 'RE'
     C***                          (DAFIRM     = '08'          OR
     C***                          DAFIRM      = '20'          OR
     C***                          DAFIRM      = '61')
     C**                 EVAL      DUC010      = BLKODCID
      /Free
                         XXBUTX = %trimr(%subst(WKBUTX:12:10));
                         Select;
                           When %subst(XXBUTX:5:1) = *BLANK;
                             %subst(XXBUT2:7:4) = %subst(XXBUTX:1:4);
                             %subst(XXBUT2:1:6) = '000000';

                           When %subst(XXBUTX:6:1) = *BLANK;
                             %subst(XXBUT2:6:5) = %subst(XXBUTX:1:5);
                             %subst(XXBUT2:1:5) = '00000';

                           When %subst(XXBUTX:7:1) = *BLANK;
                             %subst(XXBUT2:5:6) = %subst(XXBUTX:1:6);
                             %subst(XXBUT2:1:4) = '0000';

                           When %subst(XXBUTX:8:1) = *BLANK;
                             %subst(XXBUT2:4:7) = %subst(XXBUTX:1:7);
                             %subst(XXBUT2:1:3) = '000';

                           When %subst(XXBUTX:9:1) = *BLANK;
                             %subst(XXBUT2:3:8) = %subst(XXBUTX:1:8);
                             %subst(XXBUT2:1:2) = '00';

                           When %subst(XXBUTX:10:1) = *BLANK;
                             %subst(XXBUT2:2:9) = %subst(XXBUTX:1:9);
                             %subst(XXBUT2:1:1) = '0';
                           Other;
                             XXBUT2 = XXBUTX;
                         ENDSL;

                         DUC010 = XXBUT2;

      /End-Free
     C                   TESTN                   DUC010               97
     C*--------------------------------------------------------
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN100        BCBGNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRKT16'      BCAEUS
     C                   MOVEL(P)  WKUSER        BCAEWS
     C                   MOVE      WKJDAT        BCAEJT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE FQBATCH-DATEI FÜHRUNGSBUCHUNG (BUCHUNGSKOPF)              ***
     C**************************************************************************
     C     VFQBAF        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C                   Z-ADD     EXNUUMNUMM    DUN050
     C                   Z-ADD     EXNUUMNUMM    DUN070
     C                   Z-ADD     EXNUUMNUMM    DUN080
     C*
     C     DABEGR        IfEq      'RA'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        OrEq      'RE'
     C     DAFIRM        AndEq     '01'

     C                   EVAL      BCKTO       = WKKTAT + %Subst(WKKTNR:1:8)

     C                   ELSE
     C*
     C                   SELECT
     C                   WHEN      DAFIRM      = '55'          AND
     C                             ((WKIDBN    = *ON           AND
     C                             WKKTAT      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR))
     C                   EVAL      BCKTO       = WKKTAT + DUC005 + '000'
     C                   WHEN      DAFIRM      = '55'          AND
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO       = WKKTAT + DUC006 + '00'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIDBN     = *ON           AND
     C                             WKKTAT      = WKKTDE)
     C                   EVAL      BCKTO       = WKKTAT + '0' + DUC007
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR)
     C                   EVAL      BCKTO       = WKKTAT + DUC007 + '0'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO       = WKKTAT + DUC006 + '00'

     C                   WHEN      DAFIRM      = '20'          AND
     C                             (WKKTAT     = WKKTDE        OR
     C                             WKKTAT      = WKKTKR)
     C                   EVAL      BCKTO       = WKKTAT + DUC008
     C**                 EVAL      BCKTO       = WKKTAT + %subst(WKKTNR:1:8)

     C                   WHEN      (WKIDBN     = *ON           AND
     C                             WKKTAT      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR)       OR
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO       = WKKTAT + DUC006 + '00'
     C                   WHEN      DAFIRM      = '55'          AND
     C                             WKKTAT      = WKKTDE        OR
     C                             DAFIRM      = '55'          AND
     C                             WKKTAT      = WKKTKR
     C                   EVAL      BCKTO = DUC005 + '0000'
     C
     C                   WHEN      WKKTAT      = WKKTDE        OR
     C                             WKKTAT      = WKKTKR
     C                   EVAL      BCKTO = DUC006 + '000'
     C                   OTHER
     C                   EVAL      BCKTO = WKKTNR
     C                   ENDSL
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCGKTO
     C                   MOVEL(P)  WKSHKZ        BCSH
     C*--------------------------------------------------------
     C                   MOVE      *ON           WKISSP
     C*
     C                   IF        WKSTC2 = WKSTC1
     C                   Eval      WKSTC2 = *BLANK
     C                   ENDIF
     C*
     C                   SELECT
     C                   WHEN      DAFIRM      = '55'          AND
     C                             (WKSTC1    <> *BLANK        AND
     C                             WKSTC2      = *BLANK        AND
     C                             WKSTC3      = *BLANK)
     C                   EVAL      BCSTSL      = %SUBST(WKSTCD:1:2)
     C                   EVAL      WKISSP      = *OFF
     C                   WHEN      (WKSTC1    <> *BLANK        AND              PRÜFEN
     C                             WKSTC2      = *BLANK        AND              STEUERSPLIT
     C                             WKSTC3      = *BLANK)
     C                   EVAL      BCSTSL      = %SUBST(WKSTC1:2:2)             RECHTSBÜNDIG !
     C                   MOVE      *OFF          WKISSP
     C                   ENDSL
     C*--------------------------------------------------------
     C                   SELECT
     C     WKSTWC        WHENNE    'EUR'
     C                   Z-ADD     WKBBLW        BCQDM
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTB1        BCQSTD
     C                   ADD       WKSTB2        BCQSTD
     C                   ADD       WKSTB3        BCQSTD
     C                   MOVE      '+'           BCSTVZ
     C     WKFWCD        WHENEQ    WKSTW2
     C     WKFWCD        ANDNE     'EUR'
     C                   Z-ADD     WKBBFW        BCQDM
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSB1F        BCQSTD
     C                   ADD       WKSB2F        BCQSTD
     C                   ADD       WKSB3F        BCQSTD
     C                   MOVE      '+'           BCSTVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFWCD        IFNE      WKSTWC
     C     WKFWCD        ANDNE     WKSTW2
     C                   Z-ADD     WKBBFW        BCQWGD
     C                   MOVEL(P)  WKFWCD        BCWG
     C                   ENDIF
     C*--------------------------------------------------------
     C     BCQWGD        IFNE      *ZERO
     C     BCQSTD        ANDNE     *ZERO
     C                   Z-ADD     WKSB1F        BCQWGS
     C                   ADD       WKSB2F        BCQWGS
     C                   ADD       WKSB3F        BCQWGS
     C                   ENDIF
     C*--------------------------------------------------------
     C     BCQDM         IFLT      *ZERO
     C                   MULT      -1            BCQDM
     C                   MOVE      '-'           BCDMVZ
     C                   ENDIF
     C*
     C     BCQSTD        IFLT      *ZERO
     C                   MULT      -1            BCQSTD
     C                   MOVE      '-'           BCSTVZ
     C                   ENDIF
     C*
     C     BCQWGD        IFLT      *ZERO
     C                   MULT      -1            BCQWGD
     C                   ENDIF
     C*
     C     BCQWGS        IFLT      *ZERO
     C                   MULT      -1            BCQWGS
     C                   ENDIF
     C*--------------------------------------------------------
     C     MODCAL        IFEQ      *ON
     C     MODSUD        OREQ      *ON
     C                   MOVEL(P)  WKBUNR        BCBR
     C                   ELSE
     C                   MOVE      *BLANK        BCBR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCKS
     C                   MOVE      *BLANK        BCKTR
     C                   MOVE      *BLANK        BCPJ
     C                   MOVEL(P)  WKBLEX        BCLERN
     C*--------------------------------------------------------
     C                   SELECT
     C     WKBLAT        WHENEQ    WKBARE
     C     WKBLAT        OREQ      WKBAGK
     C                   MOVEL(P)  'E'           BCHK
     C     WKBLAT        WHENEQ    WKBARA
     C     WKBLAT        OREQ      WKBAGD
     C                   MOVEL(P)  'F'           BCHK
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        AKKDSB
     C                   MOVE      *BLANK        WKAFAT
     C                   MOVE      *ON           WKBSFU
     C                   MOVE      *ON           WKSTMG
     C                   EXSR      EINFO                                        ERM. INFO-FELDER
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCBGTS
     C                   MOVE      *BLANK        BCRFNR
     C*
     C                   SELECT
     C                   WHEN      DABEGR      = 'RA'
     C                   MOVEL(P)  AKREF1        BCBGT1
     C                   WHEN      DABEGR      = 'RE'
     C***                MOVEL(P)  WKBUTX        BCBGT1
     C                   Eval      BCBGT1 = %EDITC(BLKOBLJJ:'X')+'/'+BLKOBLNR
     C                   ENDSL
     C*--------------------------------------------------------
     C                   IF        DAFIRM      = '55' AND
     C                             DABEGR      = 'RA'
     C                   Z-ADD     BCBGNR        DUN060
     C                   EVAL      BCRFNR      = %TRIM(WKTRPARFNR) + DUC006 +
     C                                           %SUBST(BCKTO:2:5) + '0'
     C     ' ':'0'       XLATE     BCRFNR        BCRFNR
     C                   EXSR      EPRZF
     C                   EVAL      BCRFNR      = %TRIM(BCRFNR) + DUC001
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     KON(01)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBARA
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(01)       BCBGT1
     C     KON(02)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBAGD
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(02)       BCBGT1
     C     KON(03)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBARE
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(03)       BCBGT1
     C     KON(04)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(04)       BCBGT1
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCBGT2
     C*
     C                   IF        DABEGR      = 'RA'
     C                   EVAL      BCIFT1 = %SUBST(AKKDSB:1:20)
     C                   EVAL      BCIFT2 = %SUBST(AKKDSB:21:10)
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        BCMNT1
     C                   MOVE      *BLANK        BCMNT2
     C                   MOVE      *BLANK        BCZAT1
     C                   MOVE      *BLANK        BCZAT2
     C*--------------------------------------------------------
     C                   Z-ADD     WKSKP1        BCQSP1
     C                   Z-ADD     WKSKT1        BCQST1
     C                   Z-ADD     WKSKP2        BCQSP2
     C                   Z-ADD     WKSKT2        BCQST2
     C                   Z-ADD     WKSKP3        BCQSP3
     C                   Z-ADD     WKSKT3        BCQST3
     C                   Z-ADD     WKSKNT        BCQNET
     C*
     C     WKFADA        IFNE      *ZERO
     C                   MOVE      WKFADA        BCFLJT
     C                   ELSE
     C                   MOVE      *BLANK        BCFLJT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKBLAT        WHENEQ    WKBAGD
     C     WKTRPAZABD    ANDEQ     *ON
     C     DAFIRM        ANDEQ     '01'
     C                   MOVE      '00'          BCZBD
     C                   Z-ADD     *ZERO         BCQSP1
     C                   Z-ADD     *ZERO         BCQST1
     C                   Z-ADD     *ZERO         BCQSP2
     C                   Z-ADD     *ZERO         BCQST2
     C                   Z-ADD     *ZERO         BCQSP3
     C                   Z-ADD     *ZERO         BCQST3
     C                   Z-ADD     1             BCQNET
     C     WKBLAT        WHENEQ    WKBAGD
     C     WKTRPAZABD    ANDEQ     *OFF
     C     DAFIRM        ANDEQ     '01'
     C                   MOVEL(P)  '00'          BCZBD
     C                   Z-ADD     *ZERO         BCQSP1
     C                   Z-ADD     *ZERO         BCQST1
     C                   Z-ADD     *ZERO         BCQSP2
     C                   Z-ADD     *ZERO         BCQST2
     C                   Z-ADD     *ZERO         BCQSP3
     C                   Z-ADD     *ZERO         BCQST3
     C                   Z-ADD     1             BCQNET
     C     WKTRPAZABD    WHENEQ    *ON
     C                   MOVE      WKZABD        BCZBD
     C                   OTHER
     C                   MOVEL(P)  WKZABD        BCZBD                          Zahlungsbedingung
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         BCQVLT
     C*
     C     WKVADA        IFNE      *ZERO
     C     WKVADA        ANDNE     19000000
     C                   MOVE      WKVADA        BCVLJT
     C                   ELSE
     C                   MOVE      *BLANK        BCVLJT
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        BCMNKT
     C                   MOVE      *BLANK        BCMNKZ
     C                   MOVE      *BLANK        BCMNUS
     C                   Z-ADD     *ZERO         BCMNNR
     C                   MOVE      *BLANK        BCZAEM
     C                   MOVE      *BLANK        BCZAKZ
     C                   MOVE      *BLANK        BCZAAR
     C                   Z-ADD     *ZERO         BCOPNR
     C                   MOVEL(P)  'N'           BCNOPK
     C                   Z-ADD     *ZERO         BCQSKD
     C                   Z-ADD     *ZERO         BCQSDW
     C                   MOVEL(P)  'J'           BCSKKZ
     C                   Z-ADD     *ZERO         BCQMG
     C                   MOVE      *BLANK        BCMZWF
     C                   MOVE      *BLANK        BCAZBK
     C                   MOVE      *BLANK        BCAZVA
     C                   MOVE      *BLANK        BCDKVR
     C                   MOVE      *BLANK        BCBTR1
     C                   MOVE      *BLANK        BCBTR2
     C                   MOVE      *BLANK        BCBTR3
     C                   MOVE      *BLANK        BCBTR4
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCKZVK
     C                   Z-ADD     *ZERO         BCBUFA
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCEFEU
     C                   Z-ADD     *ZERO         BCQSKE
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFWCD        WHENEQ    'EUR'
     C     WKSTWC        ANDNE     'EUR'
     C     WKWUKZ        ANDEQ     *ON
     C                   Z-ADD     WKBBFW        BCQDE                          IN DIESE FELDER DARF
     C                   MOVE      '+'           BCDMVZ                         AUSSCHLIESSLICH DER
     C                   Z-ADD     WKSB1F        BCQSTE                         EUROBETRAG AUSGEGEBE
     C                   ADD       WKSB2F        BCQSTE                         WERDEN, WENN DER EUR
     C                   ADD       WKSB3F        BCQSTE                         1. ODER 2. HAUSWÄHRG
     C                   MOVE      '+'           BCSTVZ                         IST
     C                   MOVE      'J'           BCEFEU
     C     WKSTWC        WHENEQ    'EUR'
     C                   Z-ADD     WKBBLW        BCQDE
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTB1        BCQSTE
     C                   ADD       WKSTB2        BCQSTE
     C                   ADD       WKSTB3        BCQSTE
     C                   MOVE      '+'           BCSTVZ
     C*
     C     WKFWCD        IFEQ      'EUR'
     C                   MOVE      'J'           BCEFEU
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C     BCQDE         IFEQ      *ZERO                                        KEIN STEUERSCHLÜSSEL
     C     BCQDM         ANDEQ     *ZERO                                        WENN BETRAG LEER
     C                   MOVE      *BLANK        BCSTSL
     C                   ENDIF
     C*--------------------------------------------------------
     C     BCQDE         IFLT      *ZERO
     C                   MULT      -1            BCQDE
     C                   MOVE      '-'           BCDMVZ
     C                   ENDIF
     C*
     C     BCQSTE        IFLT      *ZERO
     C                   MULT      -1            BCQSTE
     C                   MOVE      '-'           BCSTVZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         BCQKUR
     C*
     C     BCWG          IFNE      *BLANK
     C
     C                   IF        FBFIRM = '01'
     C                             AND WKABTL = '005'
     C                             AND WKFWCD <> 'CHF'
     C                             AND WKFWCD <> 'EUR'
     C                             OR FBFIRM = '01'
     C                             AND WKABTL = '010'
     C                             AND WKFWCD <> 'SEK'
     C                             AND WKFWCD <> 'EUR'
     C
     C                   IF        WKBBLW <> 0
     C                   EVAL(H)   WKKURS = WKBBFW / WKBBLW
     C                   ELSE
     C                   EVAL      WKKURS = 1
     C                   ENDIF
     C
     C                   ELSE
     C
     C                   EXSR      EKURS
     C                   ENDIF
     C
     C                   Z-ADD     WKKURS        BCQKUR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     BCQKUR        WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *ON
     C     WKIMGN        ANDEQ     *OFF
     C                   MOVEL(P)  'E'           BCEFKU                         BEZUG KURS
     C     BCQKUR        WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *ON
     C     WKIMGN        ANDEQ     *ON
     C                   MOVEL(P)  'I'           BCEFKU
     C     BCQKUR        WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *OFF
     C                   MOVEL(P)  'D'           BCEFKU
     C                   OTHER
     C                   MOVE      *BLANK        BCEFKU
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EVAL      WKFQBAQSP1  = BCQSP1
     C                   EVAL      WKFQBAQST1  = BCQST1
     C                   EVAL      WKFQBAQSP2  = BCQSP2
     C                   EVAL      WKFQBAQST2  = BCQST2
     C                   EVAL      WKFQBAQSP3  = BCQSP3
     C                   EVAL      WKFQBAQST3  = BCQST3
     C                   EVAL      WKFQBAQNET  = BCQNET
     C                   EVAL      WKFQBAFLJT  = BCFLJT
     C                   EVAL      WKFQBAZABD  = BCZBD
     C                   EVAL      WKFQBAVLJT  = BCVLJT
     C                   EVAL      WKFQBAQKUR  = BCQKUR
     C                   EVAL      WKFQBAEFKU  = BCEFKU
     C                   MOVE      *BLANK        BCRGUL
     C                   Z-ADD     *ZERO         BCRGNR
     C                   MOVEL(P)  WKRELI        BCRELI
     C*--------------------------------------------------------
     C                   SELECT
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGD
     C     BCSH          ANDEQ     'H'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'S'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   MOVE      '-'           BCSTVZ
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCSH          ANDEQ     'S'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'H'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   MOVE      '-'           BCSTVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C                   IF        WKBBFW      = *ZERO         AND
     C                             WKBBLW      = *ZERO         AND
     C                             BCQSTE      = *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
  1  C     WKABTL        IFEQ      '010'
     C     DAFIRM        ANDEQ     '01'
     C
 2   C                   IF        BCWG = *BLANK
     C                   MOVEL     WKFWCD        BCWG
 2   C                   ENDIF
 2   C                   IF        BCWG <> 'SEK'
 3   C                   IF        BCQWGD <> 0
     C     BCQDM         DIV(H)    BCQWGD        BCQKUR
     C                   MOVE      'D'           BCEFKU
 3x  C                   ELSE
     C                   MOVE      1             BCQKUR
     C                   MOVE      'D'           BCEFKU
 3   C                   ENDIF
 2   C                   ENDIF
     C     BCEFEU        IFEQ      'J'
     C                   MOVE      ' '           BCEFEU
     C                   Z-ADD     0             BCQDE
     C                   Z-ADD     0             BCQSTE
     C                   Z-ADD     0             BCQSKE
     C                   ENDIF
     C
 1   C                   ENDIF
     C*--------------------------------------------------------
     C                   WRITE     BCSATZ                                       HINZUFÜGEN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE FQBATCH-DATEI TEILBUCHUNG (AUFLÖSUNGSBUCHUNG)             ***
     C**************************************************************************
     C     VFQBAP        BEGSR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNR        BCRCNR
     C*--------------------------------------------------------
     C                   SELECT
     C     WKBLAT        WHENEQ    WKBARE
     C     WKBLAT        OREQ      WKBAGK
     C                   MOVEL(P)  'E'           BCHK
     C     WKBLAT        WHENEQ    WKBARA
     C     WKBLAT        OREQ      WKBAGD
     C                   MOVEL(P)  'F'           BCHK
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  'N'           BCNOPK
     C                   MOVEL(P)  'J'           BCSKKZ
     C                   MOVEL(P)  WKRELI        BCRELI
     C                   MOVEL(P)  WKFQBAVLJT    BCVLJT
     C                   Z-ADD     WKFQBAQKUR    BCQKUR                         PRÜFEN
     C                   MOVEL(P)  WKFQBAEFKU    BCEFKU                         PRÜFEN
     C                   Z-ADD     WKFQBAQSP1    BCQSP1
     C                   Z-ADD     WKFQBAQST1    BCQST1
     C                   Z-ADD     WKFQBAQSP2    BCQSP2
     C                   Z-ADD     WKFQBAQST2    BCQST2
     C                   Z-ADD     WKFQBAQSP3    BCQSP3
     C                   Z-ADD     WKFQBAQST3    BCQST3
     C                   Z-ADD     WKFQBAQNET    BCQNET
     C                   MOVEL(P)  WKFQBAFLJT    BCFLJT
     C                   MOVEL(P)  WKFQBAZABD    BCZBD
     C                   MOVE      *BLANK        BCLERN
     C                   MOVE      *BLANK        BCIFT1
     C                   MOVE      *BLANK        BCIFT2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C                   Z-ADD     EXNUUMNUMM    DUN050
     C                   Z-ADD     EXNUUMNUMM    DUN070
     C                   Z-ADD     EXNUUMNUMM    DUN080
     C*
     C     WKKTAT        IfEq      '1'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        AndEq     'RA'
     C     WKKTAT        OrEq      '3'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        AndEq     'RE'
     C
     C     DABEGR        IfEq      'RE'
     C                   IF        %subst(WKKTNR:1:1) = '3'
     C                   Eval      BCKTO = %subst(WKKTNR:1:8)
     C                   Else
     C                   Eval      BCKTO = WKKTAT + %subst(WKKTNR:1:8)
     C                   EndIf
     C                   Else
     C                   Eval      BCKTO = WKKTAT + %subst(WKKTNR:1:8)
     C                   EndIf
     C
     C                   Else
     C
     C                   SELECT
     C                   WHEN      DAFIRM      = '55'          AND
     C                             ((WKIDBN    = *ON           AND
     C                             WKKTAT      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR))
     C                   EVAL      BCKTO       = WKKTAT + DUC005 + '000'
     C                   WHEN      DAFIRM      = '55'          AND
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO       = WKKTAT + DUC006 + '00'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIDBN     = *ON           AND
     C                             WKKTAT      = WKKTDE)
     C                   EVAL      BCKTO       = WKKTAT + '0' + DUC007
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR)
     C                   EVAL      BCKTO       = WKKTAT + DUC007 + '0'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO       = WKKTAT + DUC006 + '00'
     C
     C                   WHEN      DAFIRM      = '20'          AND
     C                             (WKKTAT     = WKKTDE        OR
     C                             WKKTAT      = WKKTKR)
     C                   EVAL      BCKTO       = WKKTAT + DUC008
     C**                 EVAL      BCKTO       = WKKTAT + %subst(WKKTNR:1:8)
     C
     C                   WHEN      (WKIDBN     = *ON           AND
     C                             WKKTAT      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKKTAT      = WKKTKR)       OR
     C                             (WKISAN     = *ON           AND
     C                             WKKTAT      = WKKTSA)
     C                   EVAL      BCKTO = WKKTAT + DUC006 + '00'
     C                   WHEN      WKKTAT      = WKKTDE        OR
     C                             WKKTAT      = WKKTKR
     C                   EVAL      BCKTO = DUC006 + '000'
     C                   OTHER
     C                   EVAL      BCKTO = WKKTNR
     C                   ENDSL
     C
     C                   EndIf
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKGKTN        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C                   Z-ADD     EXNUUMNUMM    DUN050
     C                   Z-ADD     EXNUUMNUMM    DUN070
     C                   Z-ADD     EXNUUMNUMM    DUN080
     C*
     C*
     C     WKGKTA        IfEq      '1'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        AndEq     'RA'
     C     WKGKTA        OrEq      '2'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        AndEq     'RE'
     C     WKGKTA        OrEq      '3'
     C     DAFIRM        AndEq     '01'
     C     DABEGR        AndEq     'RE'
     C
     C                   Eval      BCGKTO = WKGKTA + %subst(WKGKTN:1:8)
     C
     C                   Else
     C                   SELECT
     C                   WHEN      DAFIRM      = '55'          AND
     C                             ((WKIDBN    = *ON           AND
     C                             WKGKTA      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKGKTA      = WKKTKR))
     C                   EVAL      BCGKTO      = WKGKTA + DUC005 + '000'
     C                   WHEN      DAFIRM      = '55'          AND
     C                             (WKISAN     = *ON           AND
     C                             WKGKTA      = WKKTSA)
     C                   EVAL      BCGKTO      = WKGKTA + DUC006 + '00'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIDBN     = *ON           AND
     C                             WKGKTA      = WKKTDE)
     C                   EVAL      BCGKTO      = WKGKTA + '0' + DUC007
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKIKRN     = *ON           AND
     C                             WKGKTA      = WKKTKR)
     C                   EVAL      BCGKTO      = WKGKTA + DUC007 + '0'
     C                   WHEN      (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             (WKISAN     = *ON           AND
     C                             WKGKTA      = WKKTSA)
     C                   EVAL      BCGKTO      = WKGKTA + DUC006 + '00'

     C                   WHEN      DAFIRM      = '20'          AND
     C                             (WKISAN     = *ON           AND
     C                             WKGKTA      = WKKTSA)
     C                   EVAL      BCGKTO      = WKGKTA + DUC006

     C                   WHEN      (WKIDBN     = *ON           AND
     C                             WKGKTA      = WKKTDE)       OR
     C                             (WKIKRN     = *ON           AND
     C                             WKGKTA      = WKKTKR)       OR
     C                             (WKISAN     = *ON           AND
     C                             WKGKTA      = WKKTSA)
     C                   EVAL      BCGKTO      = WKGKTA + DUC006 + '00'
     C                   WHEN      WKKTAT      = WKKTDE        OR
     C                             WKKTAT      = WKKTKR
     C                   EVAL      BCGKTO = DUC006 + '000'
     C                   OTHER
     C                   EVAL      BCGKTO = WKGKTN
     C                   ENDSL

     C                   EndIf
     C*--------------------------------------------------------
     C     WKBLAT        IFEQ      WKBASA
     C                   MOVE      *BLANK        BCFGKZ
     C                   ELSE
     C                   MOVEL(P)  'A'           BCFGKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKSHKZ        BCSH
     C*
     C                   IF        DAFIRM      = '55'
     C                   EVAL      BCSTSL      = %SUBST(WKSTCD:1:2)
     C                   ELSE
     C                   EVAL      BCSTSL      = %SUBST(WKSTCD:2:2)             RECHTSBÜNDIG !
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKISSP        IFEQ      *ON
     C     WKSTBT        ANDEQ     *ZERO
     C                   EXSR      ESTPZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKSTWC        WHENNE    'EUR'
     C                   Z-ADD     WKBBLW        BCQDM
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTBT        BCQSTD
     C                   MOVE      '+'           BCSTVZ
     C     WKFWCD        WHENEQ    WKSTW2
     C     WKFWCD        ANDNE     'EUR'
     C                   Z-ADD     WKBBFW        BCQDM
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTBF        BCQSTD
     C                   MOVE      '+'           BCSTVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFWCD        IFNE      WKSTWC
     C     WKFWCD        ANDNE     WKSTW2
     C                   Z-ADD     WKBBFW        BCQWGD
     C                   IF        FBFIRM = '01'
     C                             AND WKABTL = '005'
     C                             AND WKFWCD = 'EUR'
     C                   ELSE
     C                   IF        FBFIRM = '01'
     C                             AND WKABTL = '010'
     C                             AND WKFWCD = 'EUR'
     C                   ELSE
     C                   MOVEL(P)  WKFWCD        BCWG
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     WKSTBF        BCQWGS
     C                   ENDIF
     C*--------------------------------------------------------
     C     BCQSTD        IFEQ      *ZERO
     C                   Z-ADD     *ZERO         BCQWGS
     C                   ENDIF
     C*--------------------------------------------------------
     C     BCQDM         IFLT      *ZERO
     C                   MULT      -1            BCQDM
     C                   MOVE      '-'           BCDMVZ
     C                   ENDIF
     C*
     C     BCQSTD        IFLT      *ZERO
     C                   MULT      -1            BCQSTD
     C                   MOVE      '-'           BCSTVZ
     C                   ENDIF
     C*
     C     BCQWGD        IFLT      *ZERO
     C                   MULT      -1            BCQWGD
     C                   ENDIF
     C*
     C     BCQWGS        IFLT      *ZERO
     C                   MULT      -1            BCQWGS
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCKS
     C                   MOVE      *BLANK        BCKTR
     C                   MOVE      *BLANK        BCPJ
     C*
     C                   SELECT
     C                   WHEN      WKBAT1      = WKKTKT
     C                   MOVEL(P)  WKBKT1        BCKTR                          KOSTENTRÄGER
     C                   WHEN      WKBAT1      = WKKTBE
     C                   MOVEL(P)  WKBKT1        BCKS                           KOSTENSTELLE
     C                   WHEN      WKBAT1      = WKKTPJ
     C                   MOVEL(P)  WKBKT1        BCPJ                           PROJEKT
     C                   ENDSL
     C*
     C                   SELECT
     C                   WHEN      WKBAT2      = WKKTKT
     C                   MOVEL(P)  WKBKT2        BCKTR                          KOSTENTRÄGER
     C                   WHEN      WKBAT2      = WKKTBE
     C                   MOVEL(P)  WKBKT2        BCKS                           KOSTENSTELLE
     C                   WHEN      WKBAT2      = WKKTPJ
     C                   MOVEL(P)  WKBKT2        BCPJ                           PROJEKT
     C                   ENDSL
     C*
     C                   SELECT
     C                   WHEN      WKBAT3      = WKKTKT
     C                   MOVEL(P)  WKBKT3        BCKTR                          KOSTENTRÄGER
     C                   WHEN      WKBAT3      = WKKTBE
     C                   MOVEL(P)  WKBKT3        BCKS                           KOSTENSTELLE
     C                   WHEN      WKBAT3      = WKKTPJ
     C                   MOVEL(P)  WKBKT3        BCPJ                           PROJEKT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      EWAO9PJNR
     C                   MOVEL(P)  WKPJNR        BCPJ
     C*--------------------------------------------------------
     C                   IF        (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')         AND
     C                             WKKTAT      = WKKTSA        AND
     C                             %SUBST(WKKTNR:1:1) = '9'
     C                   EVAL      BCKS        = *BLANK
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        (WKAFAT = '84' OR WKAFAT = '85')
     C                   EXSR      EWAO9KOST
     C                   EVAL      BCKS = WKKOST
     C                   ENDIF
     C*--------------------------------------------------------
     C     MODSUD        IFEQ      *ON
     C                   MOVE      *BLANK        BCKTR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        BCBGTS
     C                   MOVEL(P)  WKBUTX        BCBGT1
     C*--------------------------------------------------------
     C                   SELECT
     C     KON(05)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBARA
     C                   MOVEL(P)  KON(01)       BCBGT1
     C     KON(06)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBAGD
     C                   MOVEL(P)  KON(02)       BCBGT1
     C     KON(07)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBARE
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(03)       BCBGT1
     C     KON(08)       WHENNE    *BLANK
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCBGT1        ANDEQ     *BLANK
     C                   MOVEL(P)  KON(04)       BCBGT1
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKTENR        BCIFT1
     C                   MOVEL(P)  ' '           BCBTR4                         WERT ERMITTELN
     C                   MOVE      *BLANK        BCEFEU
     C                   Z-ADD     *ZERO         BCQSKE
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFWCD        WHENEQ    'EUR'
     C     WKSTWC        ANDNE     'EUR'
     C     WKWUKZ        ANDEQ     *ON
     C                   Z-ADD     WKBBFW        BCQDE
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTBF        BCQSTE
     C                   MOVE      '+'           BCSTVZ
     C                   MOVE      'J'           BCEFEU
     C     WKSTWC        WHENEQ    'EUR'
     C                   Z-ADD     WKBBLW        BCQDE
     C                   MOVE      '+'           BCDMVZ
     C                   Z-ADD     WKSTBT        BCQSTE
     C                   MOVE      '+'           BCSTVZ
     C*
     C     WKFWCD        IFEQ      'EUR'
     C                   MOVE      'J'           BCEFEU
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C     BCQDE         IFLT      *ZERO
     C                   MULT      -1            BCQDE
     C                   MOVE      '-'           BCDMVZ
     C                   ENDIF
     C*
     C     BCQSTE        IFLT      *ZERO
     C                   MULT      -1            BCQSTE
     C                   MOVE      '-'           BCSTVZ
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGD
     C     BCSH          ANDEQ     'S'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'H'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   MOVE      '-'           BCSTVZ
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCSH          ANDEQ     'H'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'S'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   MOVE      '-'           BCSTVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C                   IF        WKBBFW      = *ZERO         AND
     C                             WKBBLW      = *ZERO         AND
     C                             BCQSTE      = *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
  1  C     WKABTL        IFEQ      '010'
     C     DAFIRM        ANDEQ     '01'
     C
 2   C                   IF        BCWG = *BLANK
     C                   MOVEL     WKFWCD        BCWG
 2   C                   ENDIF
 2   C                   IF        BCWG <> 'SEK'
 3   C                   IF        BCQWGD <> 0
     C     BCQDM         DIV(H)    BCQWGD        BCQKUR
     C                   MOVE      'D'           BCEFKU
 3x  C                   ELSE
     C                   MOVE      1             BCQKUR
     C                   MOVE      'D'           BCEFKU
 3   C                   ENDIF
 2   C                   ENDIF
     C     BCEFEU        IFEQ      'J'
     C                   MOVE      ' '           BCEFEU
     C                   Z-ADD     0             BCQDE
     C                   Z-ADD     0             BCQSTE
     C                   Z-ADD     0             BCQSKE
     C                   ENDIF
     C
 1   C                   ENDIF
     C*--------------------------------------------------------
     C                   WRITE     BCSATZ                                       HINZUFÜGEN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SBATCH-DATEI BEREICHBUCHUNG (SPLITTBUCHUNG)               ***
     C**************************************************************************
     C     VFQBAB        BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SBATCH-DATEI WARENEINSATZBUCHUNG                          ***
     C**************************************************************************
     C     VFQBAW        BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        WKTENR      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKWERT      = *ZERO
     C                   EVAL      WKKTN1      = *BLANK
     C                   EVAL      WKKTN2      = *BLANK
     C                   EVAL      WKKOST      = *BLANK
     C                   EVAL      WKKSST      = *BLANK
     C                   EVAL      WKERKS      = *BLANK
     C                   EVAL      WKPJNR      = *BLANK
     C*--------------------------------------------------------
     C                   IF        WKGLMG     <> *ZERO
     C                   EXSR      ETEIL
     C                   ENDIF
     C*
     C                   IF        WKWERT      = *ZERO                          KEINE SACHBUCHUNG
     C                   LEAVESR                                                MIT NULLBETRAG
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EWAO9
     C*--------------------------------------------------------
     C                   IF        WKKTN1      = *BLANK        OR
     C                             WKKTN2      = *BLANK        OR
     C                             WKAFAT      = '41'          OR               INTERNER AUFTRAG
     C                             WKAFAT      = '70'          OR               GUTSCHRIFT WERT
     C                             WKAFAT      = '77'          OR
     C                             WKAFAT      = '88'                           SONDERLIEFERUNG
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C**                 IF        WKBSFU      = *OFF          OR               BESTANDSFÜHRUNG
     C                   IF        WKSTMG      = *OFF                           STATISTIK MENGE
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKTN1        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   IF        WKISAN      = *ON
     C                   EVAL      BCKTO       = WKKTSA + DUC006 + '00'
     C                   ELSE
     C                   EVAL      BCKTO       = DUC006 + '000'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKTN2        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   IF        WKISAN      = *ON
     C                   EVAL      BCGKTO      = WKKTSA + DUC006 + '00'
     C                   ELSE
     C                   EVAL      BCGKTO      = DUC006 + '000'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKSHKZ        BCSH
     C                   MOVEL(P)  *BLANK        BCPJ
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKOST        BCKS                           KOSTENSTELLE
     C                   MOVE      *BLANK        BCKTR                          KOSTENTRÄGER
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WAO9SPLT    = *ON
     C                   EVAL      BCGKTO      = *BLANK
     C                   EVAL      BCKS        = WKWEKS
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKBUTX        BCBGT1
     C                   MOVEL(P)  WKTENR        BCIFT1
     C                   MOVEL(P)  'N'           BCNOPK
     C                   MOVEL(P)  'N'           BCSKKZ
     C                   MOVEL(P)  'S'           BCHK
     C                   MOVEL(P)  'TRKT16'      BCAEUS
     C                   MOVEL(P)  WKUSER        BCAEWS
     C                   MOVE      WKJDAT        BCAEJT
     C                   MOVE      '+'           BCDMVZ
     C*
     C                   IF        WKSTWC     <> 'EUR'
     C                   Z-ADD     WKWERT        BCQDM
     C                   MOVE      ' '           BCEFEU
     C                   ELSE
     C                   Z-ADD     WKWERT        BCQDE
     C                   MOVE      'J'           BCEFEU
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGD
     C     BCSH          ANDEQ     'S'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'H'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCSH          ANDEQ     'H'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'S'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C                   WRITE     BCSATZ                                       HINZUFÜGEN
     C*--------------------------------------------------------
     C                   IF        WAO9SPLT    = *ON                            SPLITBUCHUNG WEGEN
     C                   EXSR      VFQBAS                                       KOSTENSTELLEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE SBATCH-DATEI WARENEINSATZ SPLITTBUCHUNG (KOSTENSTELLEN)   ***
     C**************************************************************************
     C     VFQBAS        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'A'           BCFGKZ                         FOLGEBUCHUNG
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKTN2        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   IF        WKISAN      = *ON
     C                   EVAL      BCKTO       = WKKTSA + DUC006 + '00'
     C                   ELSE
     C                   EVAL      BCKTO       = DUC006 + '000'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKTN1        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   IF        WKISAN      = *ON
     C                   EVAL      BCGKTO      = WKKTSA + DUC006 + '00'
     C                   ELSE
     C                   EVAL      BCGKTO      = DUC006 + '000'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKSHKZ      = 'S'
     C                   MOVEL(P)  'H'           BCSH
     C                   WHEN      WKSHKZ      = 'H'
     C                   MOVEL(P)  'S'           BCSH
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKERKS        BCKS
     C                   MOVE      *BLANK        BCKTR
     C                   MOVE      *BLANK        BCPJ
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKBUTX        BCBGT1
     C                   MOVEL(P)  WKTENR        BCIFT1
     C                   MOVEL(P)  'N'           BCNOPK
     C                   MOVEL(P)  'N'           BCSKKZ
     C                   MOVEL(P)  'S'           BCHK
     C                   MOVEL(P)  'TRKT16'      BCAEUS
     C                   MOVEL(P)  WKUSER        BCAEWS
     C                   MOVE      WKJDAT        BCAEJT
     C                   MOVE      '+'           BCDMVZ
     C*
     C                   IF        WKSTWC     <> 'EUR'
     C                   Z-ADD     WKWERT        BCQDM
     C                   MOVE      ' '           BCEFEU
     C                   ELSE
     C                   Z-ADD     WKWERT        BCQDE
     C                   MOVE      'J'           BCEFEU
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGD
     C     BCSH          ANDEQ     'S'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'H'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C     WKTRPAGUTS    WHENEQ    *ON
     C     WKBLAT        ANDEQ     WKBAGK
     C     BCSH          ANDEQ     'H'
     C     BCDMVZ        ANDEQ     '+'
     C                   MOVE      'S'           BCSH
     C                   MOVE      '-'           BCDMVZ
     C                   ENDSL
     C*--------------------------------------------------------
     C                   WRITE     BCSATZ                                       HINZUFÜGEN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN PERIODENDATUM FÜR ABWEICHENDES GESCHÄFTSJAHR          ***
     C**************************************************************************
     C     VPEDA         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      WKPEDA        WKDISO
     C*-------------------------------------------------------------------------
     C     WKTRPASMGJ    IFNE      '01'
     C                   MOVE      WKTRPASMGJ    DUC002
     C                   TESTN                   DUC002               97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   SUB       1             DUN020
     C     WKDISO        SUBDUR    DUN020:*M     WKDISO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXTRCT    WKDISO:*Y     DUN040
     C                   MOVEL(P)  DUC004        BCJP                            ALPHA
     C                   EXTRCT    WKDISO:*M     DUN020
     C                   MOVE      DUC002        BCJP
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KURS                                                    ***
     C**************************************************************************
     C     EKURS         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIMGN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKSTWC        KYWASW
     C                   MOVEL(P)  WKFWCD        KYWAWC
     C                   Z-ADD     WKBDIN        KYWADA
     C                   MOVEL(P)  DANEKZ        KYWAPL
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHWAEH
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             WAFIRM      = KYWAFI        AND
     C                             WASTWC      = KYWASW        AND
     C                             WAWACD      = KYWAWC        AND
     C                             WAMGNZ      = DAJNKZ
     C                   MOVE      *ON           WKIMGN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  WKSTWC        WAUMWACV
     C                   MOVEL(P)  WKFWCD        WAUMWACN
     C                   Z-ADD     1             WAUMWBTV
     C                   Z-ADD     WKBDIN        WAUMDATE
     C                   MOVE      *OFF          WAUMKUKZ
     C*
     C     WKIMGN        IFEQ      *ON
     C                   MOVE      'M'           WAUMRTCD                       MENGENNOTIZ
     C                   ELSE
     C                   MOVE      'P'           WAUMRTCD                       PREISNOTIZ
     C                   ENDIF
     C*
     C                   EXSR      TRWAUM
     C*--------------------------------------------------------
     C                   SELECT
     C     WAUMKRS2      WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *ON
     C     WAUMRTCD      ANDEQ     'M'
     C     DABEGR        ANDEQ     'RA'                                         KURS VERKAUF
     C                   Z-ADD     WAUMKRS2      WKKURS
     C                   MOVEL(P)  WAUMKDI2      WKKSDM
     C     WAUMKRS1      WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *ON
     C     WAUMRTCD      ANDEQ     'M'
     C                   Z-ADD     WAUMKRS1      WKKURS
     C                   MOVEL(P)  WAUMKDI1      WKKSDM
     C     WAUMKRS2      WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *OFF
     C     WAUMRTCD      ANDEQ     'P'
     C     DABEGR        ANDEQ     'RA'                                         KURS VERKAUF
     C                   Z-ADD     WAUMKRS2      WKKURS
     C                   MOVEL(P)  WAUMKDI2      WKKSDM
     C     WAUMKRS1      WHENNE    *ZERO
     C     WKWUKZ        ANDEQ     *OFF
     C     WAUMRTCD      ANDEQ     'P'
     C                   Z-ADD     WAUMKRS1      WKKURS
     C                   MOVEL(P)  WAUMKDI1      WKKSDM
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WAUMKRS1      IFNE      *ZERO
     C     WKWUKZ        ANDEQ     *OFF
     C     WAUMRTCD      ANDEQ     'P'
     C*--------------------------------------------------------
     C                   SELECT
     C     WKFWCD        WHENEQ    'FRF'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'NLG'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'DEM'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'ITL'
     C     WKLAND        ANDEQ     '037'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'ITL'
     C     WKLAND        ANDEQ     '039'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'ITL'
     C                   MOVEL(P)  '4'           WKKSDM
     C     WKFWCD        WHENEQ    'IEP'
     C                   MOVEL(P)  '1'           WKKSDM
     C     WKFWCD        WHENEQ    'PTE'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'ESP'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'BEF'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'LUF'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'FIM'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'ATS'
     C                   MOVEL(P)  '3'           WKKSDM
     C     WKFWCD        WHENEQ    'GRD'
     C                   MOVEL(P)  '3'           WKKSDM
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  WKKSDM        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MULT      TPTNUM        WKKURS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KONTEN AUS WAO9                                         ***
     C**************************************************************************
     C     EWAO9         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKKOST
     C*
     C                   SELECT
     C                   WHEN      WKBAT1      = WKKTBE
     C                   MOVEL(P)  WKBKT1        WKKOST
     C                   WHEN      WKBAT2      = WKKTBE
     C                   MOVEL(P)  WKBKT2        WKKOST
     C                   WHEN      WKBAT3      = WKKTBE
     C                   MOVEL(P)  WKBKT3        WKKOST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO9BEGR  = 'PRGR'                         BEGR = PRGR
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = WKPRGR
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9BEGR  = 'AFAT'                         BEGR = AFAT
     C                   EVAL      KYWAO9AFAT  = WKAFAT
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9BEGR  = 'WEIN'                         BEGR = WEIN
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKTN1      = WAO9EBKT
     C                   EVAL      WKKTN2      = WAO9WBKT
     C                   EVAL      WKKSST      = WAO9KSST
     C                   EVAL      WKERKS      = WAO9ERKS
     C                   EVAL      WKWEKS      = WAO9WEKS
     C                   EVAL      WKPJNR      = WAO9PJNR
     C*-------------------------------------------------------------------------
     C                   IF        WAO9SPLT    = *OFF          AND
     C                             WAO9WEKS   <> *BLANK
     C                   EVAL      WKKOST      = WAO9WEKS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KONTEN AUS WAO9                                         ***
     C**************************************************************************
     C     EWAO9PJNR     BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKKOST
     C*
     C                   SELECT
     C                   WHEN      WKBAT1      = WKKTBE
     C                   MOVEL(P)  WKBKT1        WKKOST
     C                   WHEN      WKBAT2      = WKKTBE
     C                   MOVEL(P)  WKBKT2        WKKOST
     C                   WHEN      WKBAT3      = WKKTBE
     C                   MOVEL(P)  WKBKT3        WKKOST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO9BEGR  = 'PRGR'                         BEGR = PRGR
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = WKPRGR
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9BEGR  = 'AFAT'                         BEGR = AFAT
     C                   EVAL      KYWAO9AFAT  = WKAFAT
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      KYWAO9BEGR  = 'WEIN'                         BEGR = WEIN
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = *BLANK
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9ERKS  = WKKOST
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHWAO9
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKPJNR      = WAO9PJNR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KOSTENSTELLE AUS WAO9                                   ***
     C**************************************************************************
     C     EWAO9KOST     BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKKOST
     C*
     C                   SELECT
     C                   WHEN      WKBAT1      = WKKTBE
     C                   MOVEL(P)  WKBKT1        WKKOST
     C                   WHEN      WKBAT2      = WKKTBE
     C                   MOVEL(P)  WKBKT2        WKKOST
     C                   WHEN      WKBAT3      = WKKTBE
     C                   MOVEL(P)  WKBKT3        WKKOST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAO9BEGR  = 'PRGR'                         BEGR = PRGR
     C                   EVAL      KYWAO9AFAT  = *BLANK
     C                   EVAL      KYWAO9PRGR  = WKPRGR
     C                   EVAL      KYWAO9KONT  = WKKTNR
     C                   EVAL      KYWAO9KSST  = WKKOST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO9
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKOST      = WAO9ERKS
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN STANDARDPREIS AUS TEIL                                  ***
     C**************************************************************************
     C     ETEIL         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTENR      = WKTENR
     C                   EVAL      KYTEEZ      = *BLANK
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   EXSR      BRPRKO
     C
     C                   IF        FBFIRM = '01'
     C                             and FBABTL = '010'
     C                   EXSR      SRMODWAOW
     C                   ENDIF
     C                   Z-ADD     *ZERO         WKGLMG
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION WORKFELDER                                             ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN31                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN41          +19            IND. LÖSCHEN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIFIR          + 3            IND.FIRMA
     C     *LIKE         DEFINE    WKC001        WKIDBN                         IND.DEBITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKIKRN                         IND.KREDITORNUMMER
     C     *LIKE         DEFINE    WKC001        WKISAN                         IND.SACHKONTONUMMER
     C     *LIKE         DEFINE    WKC001        WKWUKZ                         IND.WÄHRUNGSUNION
     C     *LIKE         DEFINE    WKC001        WKIMGN                         IND.MENGENNOTIZ
     C     *LIKE         DEFINE    WKC001        WKISSP                         IND.STEUERSPLITT
     C     *LIKE         DEFINE    WKC001        WKTRPAZABD                     IND.ZABD
     C     *LIKE         DEFINE    WKC001        WKTRPAGUTS                     IND.GUTSCHRIFT
     C     *LIKE         DEFINE    WKC001        WKTRPASMGJ      + 1            STARTMONAT GESCHJAHR
     C     *LIKE         DEFINE    WKC001        WKTRPAMAND      + 1            MANDANT FIBU
     C     *LIKE         DEFINE    WKC001        MODFEY                         IND.MOD.FEYCO
     C     *LIKE         DEFINE    WKC001        MODCAL                         IND.MOD.CALEPPIO
     C     *LIKE         DEFINE    WKC001        MODHAW                         IND.MOD.HAWA
     C     *LIKE         DEFINE    WKC001        MODKEL                         IND.MOD.DR.KELLER
     C     *LIKE         DEFINE    WKC001        MODMAS                         IND.MOD.MASA
     C     *LIKE         DEFINE    WKC001        MODSUD                         IND.MOD.S + D
     C     *LIKE         DEFINE    WAUMKUKZ      WKKUKZ
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKDST          + 1
     C     *LIKE         DEFINE    WKC001        WKELST          + 1
     C     *LIKE         DEFINE    WKC001        WKFQBABLAT      + 2
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        XXBUTX           +9
     C     *LIKE         DEFINE    WKC001        XXBUT2           +9
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX 0
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX 2
     C     *LIKE         DEFINE    WKN010        I3              + 2            INDEX 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN152        WKBBLW
     C     *LIKE         DEFINE    WKN152        WKBBFW
     C     *LIKE         DEFINE    WKN152        WKMWWL
     C     *LIKE         DEFINE    WKN152        WKMWWF
     C     *LIKE         DEFINE    WKN152        WKWERT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DABIBL        WKBIBL                         BIBLIOTHEK
     C     *LIKE         DEFINE    DAPROG        WKPROG                         PROGRAMM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    FBJDAT        WKJDAT
     C     *LIKE         DEFINE    FBFIRM        WKFIRM
     C     *LIKE         DEFINE    FBBLAT        WKBLAT
     C     *LIKE         DEFINE    FBBLJJ        WKBLJJ
     C     *LIKE         DEFINE    FBBLIN        WKBLIN
     C     *LIKE         DEFINE    FBBUKZ        WKBUKZ
     C     *LIKE         DEFINE    FBKTAT        WKKTAT
     C     *LIKE         DEFINE    FBKTNR        WKKTNR
     C     *LIKE         DEFINE    FBKTNR        WKKTN1
     C     *LIKE         DEFINE    FBKTNR        WKKTN2
     C     *LIKE         DEFINE    FBSHKZ        WKSHKZ
     C     *LIKE         DEFINE    FBKTAT        WKGKTA
     C     *LIKE         DEFINE    FBKTNR        WKGKTN
     C     *LIKE         DEFINE    FBBUTX        WKBUTX
     C     *LIKE         DEFINE    FBBDIN        WKBDIN
     C     *LIKE         DEFINE    FBBUDA        WKBUDA
     C     *LIKE         DEFINE    FBBDEX        WKBDEX
     C     *LIKE         DEFINE    FBBLEX        WKBLEX
     C     *LIKE         DEFINE    FBVADA        WKVADA
     C     *LIKE         DEFINE    FBFWCD        WKFWCD
     C     *LIKE         DEFINE    FBFWCD        WKSTWC
     C     *LIKE         DEFINE    FBFWCD        WKSTW2
     C     *LIKE         DEFINE    FBFWCD        SVSTWC
     C     *LIKE         DEFINE    FBFWCD        SVSTW2
     C     *LIKE         DEFINE    FBABTL        WKBUNR
     C     *LIKE         DEFINE    FBABTL        WKABTL
     C     *LIKE         DEFINE    FBGKTN        WKGKT1
     C     *LIKE         DEFINE    FBPEDA        WKPEDA
     C     *LIKE         DEFINE    FBBAT1        WKBAT1
     C     *LIKE         DEFINE    FBBKT1        WKBKT1
     C     *LIKE         DEFINE    FBBAT2        WKBAT2
     C     *LIKE         DEFINE    FBBKT2        WKBKT2
     C     *LIKE         DEFINE    FBBAT3        WKBAT3
     C     *LIKE         DEFINE    FBBKT3        WKBKT3
     C     *LIKE         DEFINE    FBBKT1        WKKOST
     C     *LIKE         DEFINE    FBBKT1        WKKSST
     C     *LIKE         DEFINE    FBBKT1        WKERKS
     C     *LIKE         DEFINE    FBBKT1        WKWEKS
     C     *LIKE         DEFINE    FBSKKZ        WKSKKZ
     C     *LIKE         DEFINE    FBKURS        WKKURS
     C     *LIKE         DEFINE    FBKSDM        WKKSDM
     C     *LIKE         DEFINE    FBTENR        WKTENR
     C     *LIKE         DEFINE    FBPRGR        WKPRGR
     C     *LIKE         DEFINE    FBGLMG        WKGLMG
     C     *LIKE         DEFINE    FBMEIN        WKMEIN
     C*
     C     *LIKE         DEFINE    FBSTC1        WKSTCD
     C     *LIKE         DEFINE    FBSTC1        WKSTC1
     C     *LIKE         DEFINE    FBSTC2        WKSTC2
     C     *LIKE         DEFINE    FBSTC3        WKSTC3
     C     *LIKE         DEFINE    FBSTB1        WKSTBT
     C     *LIKE         DEFINE    FBSTB1        UGSTBT
     C     *LIKE         DEFINE    FBSTB1        OGSTBT
     C     *LIKE         DEFINE    FBSTB1        WKSTB1
     C     *LIKE         DEFINE    FBSTB1        OGSTB1
     C     *LIKE         DEFINE    FBSTB2        WKSTB2
     C     *LIKE         DEFINE    FBSTB2        OGSTB2
     C     *LIKE         DEFINE    FBSTB3        WKSTB3
     C     *LIKE         DEFINE    FBSTB3        OGSTB3
     C     *LIKE         DEFINE    FBSB1F        WKSTBF
     C     *LIKE         DEFINE    FBSB1F        UGSTBF
     C     *LIKE         DEFINE    FBSB1F        OGSTBF
     C     *LIKE         DEFINE    FBSB1F        WKSB1F
     C     *LIKE         DEFINE    FBSB1F        OGSB1F
     C     *LIKE         DEFINE    FBSB2F        WKSB2F
     C     *LIKE         DEFINE    FBSB2F        OGSB2F
     C     *LIKE         DEFINE    FBSB3F        WKSB3F
     C     *LIKE         DEFINE    FBSB3F        OGSB3F
     C     *LIKE         DEFINE    FBSTP1        WKSTPZ
     C     *LIKE         DEFINE    FBSTP1        WKSTP1
     C     *LIKE         DEFINE    FBSTP2        WKSTP2
     C     *LIKE         DEFINE    FBSTP3        WKSTP3
     C*
     C     *LIKE         DEFINE    FBSKD1        WKSKD1
     C     *LIKE         DEFINE    FBSKT1        WKSKT1
     C     *LIKE         DEFINE    FBSKP1        WKSKP1
     C     *LIKE         DEFINE    FBSKB1        WKSKB1
     C     *LIKE         DEFINE    FBSKD2        WKSKD2
     C     *LIKE         DEFINE    FBSKT2        WKSKT2
     C     *LIKE         DEFINE    FBSKP2        WKSKP2
     C     *LIKE         DEFINE    FBSKB2        WKSKB2
     C     *LIKE         DEFINE    FBSKD3        WKSKD3
     C     *LIKE         DEFINE    FBSKT3        WKSKT3
     C     *LIKE         DEFINE    FBSKP3        WKSKP3
     C     *LIKE         DEFINE    FBSKB3        WKSKB3
     C     *LIKE         DEFINE    FBSKNT        WKSKNT
     C     *LIKE         DEFINE    FBFADA        WKFADA
     C     *LIKE         DEFINE    FBZABD        WKZABD
     C*
     C     *LIKE         DEFINE    FBKTAT        WKKTDE
     C     *LIKE         DEFINE    FBKTAT        WKKTKR
     C     *LIKE         DEFINE    FBKTAT        WKKTSA
     C     *LIKE         DEFINE    FBKTAT        WKKTBE
     C     *LIKE         DEFINE    FBKTAT        WKKTKT
     C     *LIKE         DEFINE    FBKTAT        WKKTPJ
     C     *LIKE         DEFINE    FBBLAT        WKBARE
     C     *LIKE         DEFINE    FBBLAT        WKBARA
     C     *LIKE         DEFINE    FBBLAT        WKBAGD
     C     *LIKE         DEFINE    FBBLAT        WKBAGK
     C     *LIKE         DEFINE    FBBLAT        WKBASA
     C     *LIKE         DEFINE    WAO9PJNR      WKPJNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    LNLDNR        WKLAND
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    ADPOLD        WKPOLD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AKAFAT        WKAFAT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AABSFU        WKBSFU
     C     *LIKE         DEFINE    AASTMG        WKSTMG
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    BCRELI        WKRELI
     C     *LIKE         DEFINE    BCRCNR        WKRCNR
     C     *LIKE         DEFINE    BCVLJT        WKFQBAVLJT
     C     *LIKE         DEFINE    BCQKUR        WKFQBAQKUR
     C     *LIKE         DEFINE    BCEFKU        WKFQBAEFKU
     C     *LIKE         DEFINE    BCQSP1        WKFQBAQSP1
     C     *LIKE         DEFINE    BCQST1        WKFQBAQST1
     C     *LIKE         DEFINE    BCQSP2        WKFQBAQSP2
     C     *LIKE         DEFINE    BCQST2        WKFQBAQST2
     C     *LIKE         DEFINE    BCQSP3        WKFQBAQSP3
     C     *LIKE         DEFINE    BCQST3        WKFQBAQST3
     C     *LIKE         DEFINE    BCQNET        WKFQBAQNET
     C     *LIKE         DEFINE    BCFLJT        WKFQBAFLJT
     C     *LIKE         DEFINE    BCZBD         WKFQBAZABD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    BCQDM         WKW010NTWK
     C     *LIKE         DEFINE    BCQDM         WKW010NTWP
     C     *LIKE         DEFINE    BCQDM         WKW010DIFF
     C     *LIKE         DEFINE    BCFGKZ        KYBCFGKZ
     C     *LIKE         DEFINE    BCFA          WKW010BCFA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    TAPTXT        WKTRPARFNR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRUEFEN EINMALKUNDE                                               ***
     C**************************************************************************
     C     PEINK         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        AKKDSB
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKBDIN        KYALRD                         ERMITTELN DER
     C                   MOVEL     WKBDIN        KYALRJ                         AUFTRAGSNUMMER
     C                   MOVEL(P)  WKBLIN        KYALRN
     C                   Z-ADD     *ZERO         KYALLJ
     C                   MOVE      *BLANK        KYALLI
     C                   Z-ADD     *ZERO         KYALLP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHAFLP
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     ALFIRM        ORGT      KYALFI
     C     ALRGJJ        ORGT      KYALRJ
     C     ALRGNR        ORGT      KYALRN
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        KYKDNR                         PRUEFEN STATUS
     C                   MOVEA     '01C     '    CHI                            EINMALKUNDE
     C                   EXSR      CHKUND
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     KDKDST        ORNE      WKKDST
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ALAFJJ        KYADJH                         ERMITTELN
     C                   MOVEL(P)  ALAFNR        KYADAF                         ADRESSE
     C                   Z-ADD     *ZERO         KYADPO                         RECHNUNGS-
     C                   MOVEL(P)  'ADRE'        KYADAA                         EMPFÄNGER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*
     C     CHI(5)        IFEQ      'N'                                          KEINE ADRESSE
     C                   LEAVESR                                                GEFUNDEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   AESATZ
     C                   MOVE      *BLANK        AESTAT
     C                   MOVE      *BLANK        AELOCK
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         AEFA
     C*
     C                   SELECT
     C     WKIFIR        WHENEQ    'FIRM'
     C     WKTRPAMAND    ANDNE     *ZERO
     C                   MOVE      WKTRPAMAND    AEFA
     C     WKIFIR        WHENEQ    'FIRM'
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        AEFA
     C                   ENDIF
     C*
     C     WKIFIR        WHENEQ    'WERK'
     C                   EXSR      EWERK
     C*
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        AEFA
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   SELECT
     C     WKIDBN        WHENEQ    *ON
     C                   EVAL      AEKTO = WKKTDE + DUC006 + '000'
     C                   OTHER
     C                   EVAL      AEKTO = DUC006 + '0000'
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     BCBGNR        AEOPNR
     C                   MOVE      *BLANK        AEANR
     C                   MOVEL(P)  ADNAM1        AENAM1
     C                   MOVEL(P)  ADNAM2        AENAM2
     C                   MOVEL(P)  ADNAM3        AENAM3
     C                   MOVEL(P)  ADPOFA        AEPF
     C                   MOVEL(P)  ADPOLN        AEPLZP
     C                   MOVEL(P)  ADSTRA        AESTR
     C                   EVAL      AEPLOR      = %TRIM(ADPOLZ) + ' ' +
     C                                           %TRIM(ADWORT)
     C                   MOVEL(P)  ADPOLD        AELAND
     C                   MOVE      *BLANK        AESPR
     C                   MOVE      *BLANK        AEADSU
     C                   MOVE      *BLANK        AETEL
     C                   MOVE      *BLANK        AETLX
     C                   MOVE      *BLANK        AEFAX
     C                   MOVE      *BLANK        AEBTX
     C                   MOVE      *BLANK        AEBLZ
     C                   MOVE      *BLANK        AEBKKO
     C                   MOVEL(P)  ADUSER        AEAEUS
     C                   MOVEL(P)  ADJNAM        AEAEWS
     C                   MOVEL(P)  ADJDAT        AEAEJT
     C                   MOVE      *BLANK        AEFIL
     C*--------------------------------------------------------
     C                   WRITE     AESATZ                               98      HINZUFÜGEN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRUEFEN EINMALLIEFERANT                                           ***
     C**************************************************************************
     C     PEINL         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        KYLFNR                         PRUEFEN STATUS
     C                   MOVEA     '01C     '    CHI                            EINMALLIEFERANT
     C                   EXSR      CHLIEF
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'                                          NICHT RELEVANT
     C     LFLFST        ORNE      WKELST
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKBDIN        KYAEBJ                         ERMITTELN DER
     C                   MOVEL(P)  WKBLIN        KYAEBN                         AUFTRAGSNUMMER
     C                   Z-ADD     *ZERO         KYAEWJ
     C                   MOVE      *BLANK        KYAEWE
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHBWAE
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     AEFIRM        ORGT      KYAEFI
     C     AEBLJJ        ORGT      KYAEBJ
     C     AEBLGN        ORGT      KYAEBN
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     AEBEJJ        KYELJH                         ERMITTELN
     C                   MOVEL(P)  AEBENR        KYELBE                         BESTELLADRESSE
     C                   Z-ADD     *ZERO         KYELPO
     C                   MOVEL(P)  'BBAD'        KYELAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEL
     C*
     C     CHI(5)        IFEQ      'N'                                          KEINE ADRESSE
     C                   LEAVESR                                                GEFUNDEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   AESATZ
     C                   MOVE      *BLANK        AESTAT
     C                   MOVE      *BLANK        AELOCK
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         AEFA
     C*
     C                   SELECT
     C     WKIFIR        WHENEQ    'FIRM'
     C     WKTRPAMAND    ANDNE     *ZERO
     C                   MOVE      WKTRPAMAND    AEFA
     C     WKIFIR        WHENEQ    'FIRM'
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        AEFA
     C                   ENDIF
     C*
     C     WKIFIR        WHENEQ    'WERK'
     C                   TESTN                   WKABTL               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKABTL        AEFA
     C                   ENDIF
     C*
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKTNR        EXNUUMALPH
     C                   EXSR      NUMUMS
     C                   Z-ADD     EXNUUMNUMM    DUN060
     C*
     C                   SELECT
     C     WKIKRN        WHENEQ    *ON
     C                   EVAL      AEKTO = WKKTKR + DUC006 + '000'
     C                   OTHER
     C                   EVAL      AEKTO = DUC006 + '0000'
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     BCBGNR        AEOPNR
     C                   MOVE      *BLANK        AEANR
     C                   MOVEL(P)  ELNAM1        AENAM1
     C                   MOVEL(P)  ELNAM2        AENAM2
     C                   MOVEL(P)  ELNAM3        AENAM3
     C                   MOVEL(P)  ELPOFA        AEPF
     C                   MOVEL(P)  ELPOLN        AEPLZP
     C                   MOVEL(P)  ELSTRA        AESTR
     C                   EVAL      AEPLOR      = %TRIM(ELPOLZ) + ' ' +
     C                                           %TRIM(ELWORT)
     C                   MOVEL(P)  ELPOLD        AELAND
     C                   MOVE      *BLANK        AESPR
     C                   MOVE      *BLANK        AEADSU
     C                   MOVE      *BLANK        AETEL
     C                   MOVE      *BLANK        AETLX
     C                   MOVE      *BLANK        AEFAX
     C                   MOVE      *BLANK        AEBTX
     C                   MOVE      *BLANK        AEBLZ
     C                   MOVE      *BLANK        AEBKKO
     C                   MOVEL(P)  ELUSER        AEAEUS
     C                   MOVEL(P)  ELJNAM        AEAEWS
     C                   MOVEL(P)  ELJDAT        AEAEJT
     C                   MOVE      *BLANK        AEFIL
     C*--------------------------------------------------------
     C                   WRITE     AESATZ                               98      HINZUFÜGEN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN INFOTEXTE                                               ***
     C**************************************************************************
     C     EINFO         BEGSR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKBDIN        KYALRD                         ERMITTELN DER
     C                   Z-ADD     WKBLJJ        KYALRJ                         AUFTRAGSNUMMER
     C                   MOVEL(P)  WKBLIN        KYALRN
     C                   Z-ADD     *ZERO         KYALLJ
     C                   MOVE      *BLANK        KYALLI
     C                   Z-ADD     *ZERO         KYALLP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHAFLP
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C     ALFIRM        ORGT      KYALFI
     C     ALRGJJ        ORGT      KYALRJ
     C     ALRGNR        ORGT      KYALRN
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ALAFJJ        KYAKJH                         ERMITTELN
     C                   MOVEL(P)  ALAFNR        KYAKAF                         SACHBEARBEITER
     C                   MOVEA     '01C     '    CHI                            KUNDE
     C                   EXSR      CHAFKO
     C                   EVAL      WKAFAT      = AKAFAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*--------------------------------------------------------
     C                   IF        AABSFU      = DANEKZ
     C                   EVAL      WKBSFU      = *OFF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        AASTMG      = DANEKZ
     C                   EVAL      WKSTMG      = *OFF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN STEUERPROZENTWERT                                       ***
     C**************************************************************************
     C     ESTPZ         BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     WKSTCD        WHENEQ    WKSTC1
     C     WKBBLW        MULT      WKSTP1        WKSTBT
     C     WKSTBT        DIV       100           WKSTBT
     C     WKBBFW        MULT      WKSTP1        WKSTBF
     C     WKSTBF        DIV       100           WKSTBF
     C                   EXSR      EUGOG
     C                   EXSR      PSTB1
     C*--------------------------------------------------------
     C     WKSTCD        WHENEQ    WKSTC2
     C     WKBBLW        MULT      WKSTP2        WKSTBT
     C     WKSTBT        DIV       100           WKSTBT
     C     WKBBFW        MULT      WKSTP2        WKSTBF
     C     WKSTBF        DIV       100           WKSTBF
     C                   EXSR      EUGOG
     C                   EXSR      PSTB2
     C*--------------------------------------------------------
     C     WKSTCD        WHENEQ    WKSTC3
     C     WKBBLW        MULT      WKSTP3        WKSTBT
     C     WKSTBT        DIV       100           WKSTBT
     C     WKBBFW        MULT      WKSTP3        WKSTBF
     C     WKSTBF        DIV       100           WKSTBF
     C                   EXSR      EUGOG
     C                   EXSR      PSTB3
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UG UND OG STEUERBETRAG ERMITTELN                                  ***
     C**************************************************************************
     C     EUGOG         BEGSR
     C*-------------------------------------------------------------------------
     C     WKSTBT        IFNE      *ZERO
     C     WKSTBT        SUB       0,02          UGSTBT
     C     WKSTBT        ADD       0,02          OGSTBT
     C                   ELSE
     C                   Z-ADD     *ZERO         UGSTBT
     C                   Z-ADD     *ZERO         OGSTBT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKSTBF        IFNE      *ZERO
     C     WKSTBF        SUB       0,02          UGSTBF
     C     WKSTBF        ADD       0,02          OGSTBF
     C                   ELSE
     C                   Z-ADD     *ZERO         UGSTBF
     C                   Z-ADD     *ZERO         OGSTBF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN STEUERBETRAG 1                                             ***
     C**************************************************************************
     C     PSTB1         BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKSTB1        WHENEQ    *ZERO
     C                   Z-ADD     *ZERO         WKSTBT
     C                   Z-ADD     *ZERO         WKSTBF
     C     WKSTB1        WHENGE    UGSTBT
     C     WKSTB1        ANDLE     OGSTBT
     C                   Z-ADD     WKSTB1        WKSTBT
     C                   Z-ADD     WKSB1F        WKSTBF
     C                   OTHER
     C                   SUB       WKSTBT        WKSTB1
     C                   SUB       WKSTBF        WKSB1F
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN STEUERBETRAG 2                                             ***
     C**************************************************************************
     C     PSTB2         BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKSTB2        WHENEQ    *ZERO
     C                   Z-ADD     *ZERO         WKSTBT
     C                   Z-ADD     *ZERO         WKSTBF
     C     WKSTB2        WHENGE    UGSTBT
     C     WKSTB2        ANDLE     OGSTBT
     C                   Z-ADD     WKSTB2        WKSTBT
     C                   Z-ADD     WKSB2F        WKSTBF
     C                   OTHER
     C                   SUB       WKSTBT        WKSTB2
     C                   SUB       WKSTBF        WKSB2F
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN STEUERBETRAG 3                                             ***
     C**************************************************************************
     C     PSTB3         BEGSR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKSTB3        WHENEQ    *ZERO
     C                   Z-ADD     *ZERO         WKSTBT
     C                   Z-ADD     *ZERO         WKSTBF
     C     WKSTB3        WHENGE    UGSTBT
     C     WKSTB3        ANDLE     OGSTBT
     C                   Z-ADD     WKSTB3        WKSTBT
     C                   Z-ADD     WKSB3F        WKSTBF
     C                   OTHER
     C                   SUB       WKSTBT        WKSTB3
     C                   SUB       WKSTBF        WKSB3F
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS AFRK                                          ***
     C**************************************************************************
     C     EAFRK         BEGSR
     C*
     C                   MOVE      *BLANK        WKRELI
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKBLJJ        KYRKRJ
     C                   MOVEL(P)  WKBLIN        KYRKRN
     C                   Z-ADD     *ZERO         KYRKLJ
     C                   MOVE      *BLANK        KYRKLI
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFRK
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     RKFIRM        ANDEQ     KYRKFI
     C     RKRGJJ        ANDEQ     KYRKRJ
     C     RKRGNR        ANDEQ     KYRKRN
     C                   Z-ADD     RKEKJJ        DUN040
     C                   MOVEL(P)  RKEKNR        WKRELI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  NUMERISCH UMSETZEN                                                ***
     C**************************************************************************
     C     NUMUMS        BEGSR
     C*-------------------------------------------------------------------------
     C                   CALL      'TRNUUM'
     C                   PARM                    EXNUUM
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  BERECHEN PREIS                                                    ***
     C**************************************************************************
     C     BRPRKO        BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        WKGLMG      < *ZERO
     C                   EVAL      WKGLMG      = WKGLMG * -1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOND
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           EXKONDKUKZ
     C                   MOVEL(P)  'V'           EXKONDVPKZ
     C                   MOVEL(P)  WKTENR        EXKONDTENR
     C                   MOVEL(P)  TEMEIN        EXKONDMEPR
     C                   Z-ADD     TESTPR        EXKONDPREI
     C                   MOVEL(P)  TEPDAV        EXKONDPDIM
     C                   Z-ADD     WKGLMG        EXKONDMENG
     C                   MOVEL(P)  WKMEIN        EXKONDMEIN
     C*--------------------------------------------------------
     C                   MOVEL(P)  'BRPRKO'      EXKONDPGST
     C                   CALL      'BRPRKO'
     C                   PARM                    EXKOND
     C                   PARM                    RTKOND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTKONDNESU    WKWERT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PRÜFZIFFER                                              ***
     C**************************************************************************
     C     EPRZF         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      DUC026      = BCRFNR
     C*-------------------------------------------------------------------------
     C                   Z-ADD(H)  1             I1
     C                   Z-ADD(H)  *ZERO         I2
     C                   Z-ADD(H)  *ZERO         I3
     C*-------------------------------------------------------------------------
     C     I1            DOWLE     26
     C                   EVAL      DUC001 = %SUBST(DUC026:I1:1)
     C     DUN010        ADD(H)    1             I2
     C*
     C                   SELECT
     C     I3            WHENEQ    0
     C                   MOVEA     PF0           W10
     C     I3            WHENEQ    1
     C                   MOVEA     PF1           W10
     C     I3            WHENEQ    2
     C                   MOVEA     PF2           W10
     C     I3            WHENEQ    3
     C                   MOVEA     PF3           W10
     C     I3            WHENEQ    4
     C                   MOVEA     PF4           W10
     C     I3            WHENEQ    5
     C                   MOVEA     PF5           W10
     C     I3            WHENEQ    6
     C                   MOVEA     PF6           W10
     C     I3            WHENEQ    7
     C                   MOVEA     PF7           W10
     C     I3            WHENEQ    8
     C                   MOVEA     PF8           W10
     C     I3            WHENEQ    9
     C                   MOVEA     PF9           W10
     C                   ENDSL
     C*
     C                   MOVEA     W10(I2)       DUC001
     C                   Z-ADD(H)  DUN010        I3
     C                   ADD(H)    1             I1
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     10            SUB(H)    I3            DUN010
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS BLKO                                          ***
     C**************************************************************************
     C     EBLKO         BEGSR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKBLJJ        KYBLKOBLJJ
     C                   MOVEL(P)  WKBLIN        KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*-------------------------------------------------------------------------
     C                   ENDSR
      //*************************************************************************
      //**  ERMITTELN MANDANT AUS DATEI WERK                                  ***
      //*************************************************************************
     C     EWERK         BEGSR
     C
     C                   eval      KYWRNR = WKABTL
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C
     C                   IF        WKFENR = *ZERO
     C                   EVAL      WKFIRM = WRMAND
     C                   ENDIF
     C
     C                   ENDSR
      //*************************************************************************
      //**  Routine1 für Währungstausch Firma 01/werk 005                     ***
      //**           Felder Führungskontierung                                ***
      //*************************************************************************
     C     SRMODWAO1     BEGSR
     C                   Select
     C                   When      FBFWCD = 'CHF'
     C                   Z-ADD     0             WKSB1F
     C                   Z-ADD     0             OGSB1F
     C                   Z-ADD     0             WKSB2F
     C                   Z-ADD     0             OGSB2F
     C                   Z-ADD     0             WKSB3F
     C                   Z-ADD     0             OGSB3F
     C                   Z-ADD     FBSB1F        WKSTB1
     C                   Z-ADD     FBSB1F        OGSTB1
     C                   Z-ADD     FBSB2F        WKSTB2
     C                   Z-ADD     FBSB2F        OGSTB2
     C                   Z-ADD     FBSB3F        WKSTB3
     C                   Z-ADD     FBSB3F        OGSTB3
     C                   EVAL      WKFWCD = 'CHF'
     C
     C                   When      FBFWCD = 'EUR'
     C                   Z-ADD     0             WKSB1F
     C                   Z-ADD     0             OGSB1F
     C                   Z-ADD     0             WKSB2F
     C                   Z-ADD     0             OGSB2F
     C                   Z-ADD     0             WKSB3F
     C                   Z-ADD     0             OGSB3F
     C                   Z-ADD     FBSTB1        WKSTB1
     C                   Z-ADD     FBSTB1        OGSTB1
     C                   Z-ADD     FBSTB2        WKSTB2
     C                   Z-ADD     FBSTB2        OGSTB2
     C                   Z-ADD     FBSTB3        WKSTB3
     C                   Z-ADD     FBSTB3        OGSTB3
     C                   EVAL      WKFWCD = 'CHF'
     C                   EXSR      SRMODWAO3
     C
     C                   OTHER
     C                   Z-ADD     FBSTB1        WKSTB1
     C                   Z-ADD     FBSTB1        OGSTB1
     C                   Z-ADD     FBSTB2        WKSTB2
     C                   Z-ADD     FBSTB2        OGSTB2
     C                   Z-ADD     FBSTB3        WKSTB3
     C                   Z-ADD     FBSTB3        OGSTB3
     C                   EXSR      SRMODWAO3
     C
     C                   ENDSL
     C
     C                   ENDSR
      //*************************************************************************
      //**  Routine1 für Währungstausch Firma 01/werk 010                     ***
      //**           Felder Führungskontierung                                ***
      //*************************************************************************
     C     SRMODWAO1S    BEGSR
     C                   Select
     C                   When      FBFWCD = 'SEK'
     C                   Z-ADD     0             WKSB1F
     C                   Z-ADD     0             OGSB1F
     C                   Z-ADD     0             WKSB2F
     C                   Z-ADD     0             OGSB2F
     C                   Z-ADD     0             WKSB3F
     C                   Z-ADD     0             OGSB3F
     C                   Z-ADD     FBSB1F        WKSTB1
     C                   Z-ADD     FBSB1F        OGSTB1
     C                   Z-ADD     FBSB2F        WKSTB2
     C                   Z-ADD     FBSB2F        OGSTB2
     C                   Z-ADD     FBSB3F        WKSTB3
     C                   Z-ADD     FBSB3F        OGSTB3
     C                   EVAL      WKFWCD = 'SEK'
     C
     C                   When      FBFWCD = 'EUR'
     C                   Z-ADD     FBSTB1        WKSB1F
     C                   Z-ADD     FBSTB1        OGSB1F
     C                   Z-ADD     FBSTB2        WKSB2F
     C                   Z-ADD     FBSTB2        OGSB2F
     C                   Z-ADD     FBSTB3        WKSB3F
     C                   Z-ADD     FBSTB3        OGSB3F
     C                   Z-ADD     FBSTB1        WKSTB1
     C                   Z-ADD     FBSTB1        OGSTB1
     C                   Z-ADD     FBSTB2        WKSTB2
     C                   Z-ADD     FBSTB2        OGSTB2
     C                   Z-ADD     FBSTB3        WKSTB3
     C                   Z-ADD     FBSTB3        OGSTB3
     C                   EVAL      WKFWCD = 'EUR'
     C                   EXSR      SRMODWAO3S
     C
     C                   OTHER
     C                   Z-ADD     FBSB1F        WKSB1F
     C                   Z-ADD     FBSB1F        OGSB1F
     C                   Z-ADD     FBSB2F        WKSB2F
     C                   Z-ADD     FBSB2F        OGSB2F
     C                   Z-ADD     FBSB3F        WKSB3F
     C                   Z-ADD     FBSB3F        OGSB3F
     C                   Z-ADD     FBSTB1        WKSTB1
     C                   Z-ADD     FBSTB1        OGSTB1
     C                   Z-ADD     FBSTB2        WKSTB2
     C                   Z-ADD     FBSTB2        OGSTB2
     C                   Z-ADD     FBSTB3        WKSTB3
     C                   Z-ADD     FBSTB3        OGSTB3
     C                   EVAL      WKFWCD = FBFWCD
     C                   EXSR      SRMODWAO3S
     C
     C                   ENDSL
     C
     C                   ENDSR
      //*************************************************************************
      //**  Routine2 für Währungstausch Firma 01/werk 005                     ***
      //**           Felder Gegenkontierungen                                 ***
      //*************************************************************************
     C     SRMODWAO2     BEGSR
     C                   SELECT
     C                   WHEN      FBFWCD = 'CHF'
     C                   ADD       FBBBFW        WKBBLW
     C                   ADD       FBSB1F        WKMWWL
     C                   ADD       FBSB2F        WKMWWL
     C                   ADD       FBSB3F        WKMWWL
     C
     C                   WHEN      FBFWCD = 'EUR'
     C                   ADD       FBBBLW        WKBBLW
     C                   ADD       FBSTB1        WKMWWL
     C                   ADD       FBSTB2        WKMWWL
     C                   ADD       FBSTB3        WKMWWL
     C                   EXSR      SRMODWAO4
     C
     C                   OTHER
     C                   ADD       FBBBLW        WKBBLW
     C                   ADD       FBSTB1        WKMWWL
     C                   ADD       FBSTB2        WKMWWL
     C                   ADD       FBSTB3        WKMWWL
     C                   EXSR      SRMODWAO4
     C                   ENDSL
     C
     C                   ENDSR
      //*************************************************************************
      //**  Routine2 für Währungstausch Firma 01/werk 010                    ***
      //**           Felder Gegenkontierungen                                 ***
      //*************************************************************************
     C     SRMODWAO2S    BEGSR
     C                   SELECT
     C                   WHEN      FBFWCD = 'SEK'
     C                   ADD       FBBBFW        WKBBLW
     C                   ADD       FBSB1F        WKMWWL
     C                   ADD       FBSB2F        WKMWWL
     C                   ADD       FBSB3F        WKMWWL

     C                   WHEN      FBFWCD = 'EUR'
     C                   ADD       FBBBLW        WKBBLW
     C                   ADD       FBSTB1        WKMWWL
     C                   ADD       FBSTB2        WKMWWL
     C                   ADD       FBSTB3        WKMWWL

     C                   ADD       FBBBLW        WKBBFW
     C                   ADD       FBSTB1        WKMWWF
     C                   ADD       FBSTB2        WKMWWF
     C                   ADD       FBSTB3        WKMWWF
     C                   EXSR      SRMODWAO4S

     C                   OTHER
     C                   ADD       FBBBLW        WKBBLW
     C                   ADD       FBSTB1        WKMWWL
     C                   ADD       FBSTB2        WKMWWL
     C                   ADD       FBSTB3        WKMWWL

     C                   ADD       FBBBFW        WKBBFW
     C                   ADD       FBSB1F        WKMWWF
     C                   ADD       FBSB2F        WKMWWF
     C                   ADD       FBSB3F        WKMWWF
     C                   EXSR      SRMODWAO4S
     C                   ENDSL
     C
     C                   ENDSR
      //*************************************************************************
      //**  Routine3 für Kursumrechnung Werk 005                              ***
      //*************************************************************************
      /FREE
       BEGSR SRMODWAO3;

         WKKUKZ = *ON;
         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'CHF';
         WAUMWBTV = WKSTB1;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB1 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB1 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB1 = WKSTB1;
         ENDSL;
         OGSTB1 = WKSTB1;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'CHF';
         WAUMWBTV = WKSTB2;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB2 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB2 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB2 = WKSTB2;
         ENDSL;
         OGSTB2 = WKSTB2;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'CHF';
         WAUMWBTV = WKSTB3;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB3 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB3 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB3 = WKSTB3;
         ENDSL;
         OGSTB3 = WKSTB3;

       ENDSR;
      //*************************************************************************
      //**  Routine3 für Kursumrechnung Werk 010                              ***
      //*************************************************************************
      /FREE
       BEGSR SRMODWAO3S;

         WKKUKZ = *ON;
         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKSTB1;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB1 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB1 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB1 = WKSTB1;
         ENDSL;
         OGSTB1 = WKSTB1;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKSTB2;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB2 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB2 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB2 = WKSTB2;
         ENDSL;
         OGSTB2 = WKSTB2;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKSTB3;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKSTB3 = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKSTB3 = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKSTB3 = WKSTB3;
         ENDSL;
         OGSTB3 = WKSTB3;

       ENDSR;
      //*************************************************************************
      //**  Routine für Kursumrechnung Wareneinsatzwert (std preis aus TEIL)  ***
      //*************************************************************************
      /FREE
       BEGSR SRMODWAOW;

         WKKUKZ = *ON;
         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKWERT;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKWERT = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKWERT = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKWERT = WKWERT;
         ENDSL;
       ENDSR;
      //*************************************************************************
      //**  Routine4 für Kursumrechnung werk 005                              ***
      //*************************************************************************
       BEGSR SRMODWAO4;

         WKKUKZ = *ON;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'CHF';
         WAUMWBTV = WKBBLW;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKBBLW = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKBBLW = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKBBLW = WKBBLW;
         ENDSL;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'CHF';
         WAUMWBTV = WKMWWL;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKMWWL = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKMWWL = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKMWWL = WKMWWL;
         ENDSL;

       ENDSR;
      //*************************************************************************
      //**  Routine4 für Kursumrechnung Werk 010                              ***
      //*************************************************************************
       BEGSR SRMODWAO4S;

         WKKUKZ = *ON;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKBBLW;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKBBLW = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKBBLW = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKBBLW = WKBBLW;
         ENDSL;

         CLEAR EXWAUM;
         WAUMWACV = 'EUR';
         WAUMWACN = 'SEK';
         WAUMWBTV = WKMWWL;
         WAUMDATE = FBBUDA;
         WAUMKUKZ = WKKUKZ;
         WAUMRTCD = 'A';
         EXSR TRWAUM;

         SELECT;
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *ON;
           WKMWWL = %DEC(WAUMWBTN:11:2);
         WHEN WAUMFENR = *ZERO
           AND WKKUKZ = *OFF;
           WKMWWL = %DECH(WAUMWBTN:11:2);
         OTHER;
           WKMWWL = WKMWWL;
         ENDSL;

       ENDSR;
      //*************************************************************************
      //**  Routine für Differenzenausgleich Werk 010 IGLOO                   ***
      //*************************************************************************
       BEGSR SRMODWAOI;
         // ermitteln FiBu mandant für Firma 01 / werk 010
         IF DAFIRM = '01';
           WKABTL = '010' ;
           EXSR EWERK;
      //END-FREE
     C                   TESTN                   WKFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKFIRM        WKW010BCFA
     C                   ENDIF
      //FREE

           // Cursor für Führungsbuchungen zum Werk 010
           EXEC SQL   DECLARE W010 CURSOR FOR SELECT *
             FROM FQBATCH WHERE
             BCFA   = :WKW010BCFA and
             BCHK   = 'F' and
             BCFGKZ = ' ' and
             BCGKTO = ' '
             FOR READ ONLY;
           Exec SQL Open W010;
           DoW SQLCOD = 0;
             EXEC SQL fetch W010 into :WKBCSATZ;

             IF SQLCOD = 0;
               // ermitteln Summe der Gegenkontierungswerte
               WKW010NTWK = WKBCQDM - WKBCQSTD;
               EXSR SRMODWAOI1;
               IF WKW010DIFF > 0,01 or WKW010DIFF < -0,01;
                 EXSR SRMODWAOI2;
               ENDIF;
             ENDIF;
           ENDDO;
           EXEC SQL Close W010;
         ENDIF;
       ENDSR;
      //*************************************************************************
      //**  Routine für ermitteln Wert der Gegenkontierungen                  ***
      //*************************************************************************
       BEGSR SRMODWAOI1;
         EXEC SQL SELECT SUM(BCQDM) into :WKW010NTWP
           FROM FQBATCH WHERE
           BCFA   = :WKW010BCFA and
           BCRCNR = :WKBCRCNR and
           BCHK   = 'F' and
           BCFGKZ = 'A';
         IF SQLCOD = 0;
           // Differenz ermitteln
           WKW010DIFF = WKW010NTWK - WKW010NTWP;
         ELSE;
           WKW010DIFF = 0;
           SQLCOD = 0;
         ENDIF;

       ENDSR;
      //*************************************************************************
      //**  Differenz anteilig auf die Gegenkontierungen verteilen            ***
      //*************************************************************************
       BEGSR SRMODWAOI2;
         WKRUNDSUM = 0;
         KYBCFGKZ = 'A';
      //END-FREE
     C     KYFQB00       SETLL     FQBATCH00
     C*
     C                   DOW       1=1
     C     KYFQB00       READE     FQBATCH00                              99
     C                   IF        *IN99 = *ON
     C                   LEAVE
     C                   ENDIF
      /Free
         WKW010FAKT = BCQDM / WKW010NTWK;
         Eval(H) WKRUNDUNG = WKW010DIFF * WKW010FAKT;
         BCQDM += WKRUNDUNG;
         WKRUNDSUM += WKRUNDUNG;
      /End-Free
     C***                If        1 <> 1
     C                   UPDATE    BCSATZ00
     C***                ENDIF
     C                   ENDDO
      //FREE
       ENDSR;
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFRK
     C/COPY QCPYSRC,CHBBEL
     C/COPY QCPYSRC,CHBLKO
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHFIBU
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAEH
     C/COPY QCPYSRC,CHWAO9
     C/COPY QCPYSRC,TRWAUM
     C/COPY QCPYSRC,CHWERK
     C*
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
