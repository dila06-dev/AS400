     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Verarbeiten Speditionsdaten
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 15.03.2011 Projekt 7190
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 02.08.2011 Testszenario geändert, eMail Adresse aus TXST,
     H*            Kunden-Ansprechpartner
     H*  Änderung: SZ 03.08.2011 eMail Adresse direkt aus TXST ermitteln, ohne
     H*            Aufruf TRTX50
     H*  Änderung: SZ 03.08.2011 Testeinträge entfernt
     H*  Änderung: SZ 11.08.2011 Update Spediteur in AFVS/AFSP bei Abweichung
     H*  Änderung: SZ 19.08.2011 Projekt 7722, zusätzliche Spediteurnr. GLS
     H*  Änderung: SZ 23.08.2011 Texte aus Tabelle 'TRSP18', URLs über MOAFVS
     H*            aus TRUR.
     H*  Änderung: SZ 19.08.2011 Projekt 7197, Hinweis in AVFREX ausgeben
     H*  Änderung: SZ 18.10.2011 Projekt 7197, AVFREX in AVHINW umbenannt
     H*  Änderung: SZ 06.03.2012 Projekt 8260, eMail Versand auch bei interner
     H*            Verarbeitung (Boll, Schenker, Kühne + Nagel).
     H*  Änderung: SZ 05.07.2012 kein Update AFSP, AFVS bei interner Verarbei-
     H*            tung
     H*  Änderung: SZ 30.08.2012 Projekt 8330, eMail Versand an den Endkunden
     H*            der SCs.
     H*  Änderung: RE 31.08.2012 Projekt 8646, eMail Versand mit Lieferschein
     H*  Änderung: SZ 16.02.2013 Projekt 9032, Anpassung Parts Express für Firma
     H*            '08' und '52'.
     H*  Änderung: SZ 01.03.2013 VSBD '033' auch über Hellmann.
     H*  Änderung: SZ 15.05.2013 Projekt 8646, Korrektur Aufteilung der Texte
     H*            bei Übergabe an TRXPRK
     H*  Änderung: SZ 15.08.2013 Anpassung VSBD '113' für DPD
     H*  Änderung: SZ 14.04.2014 Zugriff TXBE über Key02 ohne Sprachcode.
     H*            Update Gewicht nur, wenn in den Rückdaten gefüllt.
     H*  Änderung: SZ 18.07.2014 Anpassung VSBD '213' für DPD zusätzlich
     H*  Änderung: SZ 16.10.2014 Verarbeitung E-Mail auch für SPEDH2
     H*  Änderung: SZ 16.02.2017 Die Namen der Files sind für die Zuordnung
     H*            der Daten nicht mehr relevant. Die Daten werden einheitlich
     H*            von Hr. Gang in WAOE geschrieben. Kom.-Jahr + Nummer sind
     H*            dann schon gefüllt.
     H*  Änderung: SZ 10.04.2017 Sprachcode für Zugriff TRTP aus dem E-Mail-
     H*            Adresseintrag in TXBE ermitteln. Herr Gang schreibt den
     H*            Eintrag mit dem entsprechenden Sprachcode.
     H*  Änderung: SZ 28.06.2017 Projekt 13036, Anpassung Betreff je nach
     H*            Auftragsart
     H*  Änderung: SZ 22.10.2020 Nach Problem mit falsch ersandten E-Mails
     H*            Prüfung, ob zu dem Kom.-Schein aus WAOE auch ein Lieferschein
     H*            existiert. Ansonsten bleibt der Satz unverarbeitet.
     H*  Änderung: SZ 23.03.2022 Service 20220323-013, durch ein Programm von
     H*            Dometic wurde ein Kom.-Schein doppelt in WAOE geschrieben.
     H*            Das hat beim Update dazu geführt, dass immer der bereits
     H*            bearbeitete Datensatz anhand des Keys aktualisiert wurde.
     H*            Der zweite Satz wurde auf Grund des Status immer wieder ver-
     H*            arbeitet. Daher Update WAOE in Schleife.
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus TRSP17 aufgerufen. Es verarbeitet die gerade
     F*  vom Speditionsrechner übertragenen Daten und generiert die eMails mit
     F*  den Links zu den Sendungen.
     F*
     F*  Feld-Name  Feldtext                  Länge
     F*  ------------------------------------------
     F*  EXMAILFROM Mail-Adresse Absender       256
     F*  EXMAILRCPT Mail-Adresse Empfänger      256
     F*  EXMAILSUBJ Betreff der Mail            256
     F*  EXMAILBODY Body der Mail              1024
     F*  EXMAILCC   E-Mail-Adresse              256
     F*  EXMAILBCC  E-Mail-Adresse              256
     F*
     F*  Die folgenden Dateinamen werden den anschließend genannten Spediteur-
     F*  nummern zugeordnet:
     F*
     F*  SPED02 = 90164 Hellmann
     F*  SPED12 = 92213 Parts Express
     F*  SPED22 = 90163 Hamacher
     F*  SPED32 = 90864 trans-o-flex
     F*  SPED42 = 90748 GLS
     F*  SPED52 = 92214 DPD
     F*  SPED62 = 90292 Boll (Dummy)
     F*  SPED72 =       Adlatus
     F*  SPED82 = 90330 Dachser
     F*  SPEDA2 = 90164 Hellmann Aktion
     F*  SPEDC2 = 90796 Night Star
     F*  SPEDD2 = 90481 Schenker Obi (Dummy)
     F*  SPEDE2 = 91258 GLS Market Intervention
     F*  SPEDF2 = 92222 Kühne + Nagel (Dummy)
     F*  SPEDG2 = 92224 Schenker (Dummy)
     F*  SPEDH2 = 92225 BRT Italien (Dummy)
     F*  SPEDI2 = 90169 TNT (Dummy)
     F*  SPEDK2 = 92230 Loxx (Dummy)
     F*
     F*  Das Programm wird nach Einführung von LFS und Rhenania nur noch zum
     F*  Update der Sendungsnummer in AFVS und zum Erstellen von E-Mail Benach-
     F*  richtigungen genutzt. Die Daten werden durch ein Programm von Dometic
     F*  in WAOE geschrieben. Es wird nur noch der Dateiname "RHENANIA" benutzt.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D AFVS          E DS                  INZ
     D KYAFVS        E DS                  INZ
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
     D TXST          E DS                  INZ
     D KYTXST        E DS                  INZ
     D*
     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ
     D*
     D WAOE          E DS                  INZ
     D KYWAOE        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXMAIL        E DS                  INZ
     D EXTXST        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXAFLK01      E DS                  INZ
     D*
     D E1XLST        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXXPRT        E DS                  INZ
     D RTXPRT        E DS                  INZ
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
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    WKDATN
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VWAOE
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  EROEFFNUNGSZYKLUS                                                 ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C                   Z-ADD     *ZERO         WKN110           11 0
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYKLFI                         AFLK
     C                   MOVEL(P)  DAFIRM        KYAVFI                         AFVS
     C                   MOVEL(P)  DAFIRM        KYASFI                         AFSP
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTBFI                         TXBE
     C                   MOVEL(P)  DAFIRM        KYTTFI                         TXST
     C                   MOVEL(P)  DAFIRM        KYVBFI                         VSBD
     C                   MOVEL(P)  DAFIRM        KYWAOEFIRM                     WAOE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I1
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER KONSTANTEN                                          ***
     C**************************************************************************
     C     ERMKO         BEGSR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTPSP      = WKSPCD                         ABSENDER
     C                   EVAL      KYTPTA      = 'TRSP18'
     C                   EVAL      KYTPTC      = 'ABSENDER'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   EVAL      WKFROM      = TPTTXT
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTPSP      = WKSPCD                         BETREFF
     C                   EVAL      KYTPTA      = 'TRSP18'
     C                   EVAL      KYTPTC      = 'BETREFF'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   EVAL      WKSUBJ      = TPTTXT
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTPSP      = WKSPCD                         INHALT
     C                   EVAL      KYTPTA      = 'TRSP18'
     C                   EVAL      KYTPTC      = 'INHALT'
     C*
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
     C                   IF        TPFIRM     <> OFTPFI        OR               URSPRUNGSGRENZE
     C                             TPSPCD     <> OFTPSP        OR               ÜBERSCHRITTEN
     C                             TPTART     <> OFTPTA        OR
     C                             TPTCDE     <> OFTPTC        OR
     C                             WKFENR     <> *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  TPTTXT        KON(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      WKBODY      = KON(02) + KON(03) + KON(04) +
     C                                           KON(05) + KON(06) + KON(07) +
     C                                           KON(08) + KON(09) + KON(10) +
     C                                           KON(11) + KON(12) + KON(13) +
     C                                           KON(14) + KON(15) + KON(16) +
     C                                           KON(17) + KON(18) + KON(19) +
     C                                           KON(20) + KON(21) + KON(22) +
     C                                           KON(23) + KON(24) + KON(25)
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER                                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIUPD                         IND.UPDATE
     C     *LIKE         DEFINE    WKC001        WKIINT                         IND.INTERN
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IND.TABELLE
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKI1DG          + 1            1. SATZ
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKAVKZ
     C     *LIKE         DEFINE    WKC001        WKURL1         +127
     C     *LIKE         DEFINE    WKC001        WKURL2         +127
     C     *LIKE         DEFINE    WKC001        WKURLG         +511
     C     *LIKE         DEFINE    WKC001        WKBODY        +1023
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 3            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 3            INDEX 2
     C     *LIKE         DEFINE    WKN010        I3              + 3            INDEX 3
     C     *LIKE         DEFINE    WKN010        I4              + 3            INDEX 4
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    DASPCD        WKSPCD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AMJDAT        WKJDAT
     C     *LIKE         DEFINE    AMJZEI        WKJZEI
     C     *LIKE         DEFINE    AMPOLZ        WKPOLZ
     C     *LIKE         DEFINE    AMVSBD        WKVSBD
     C     *LIKE         DEFINE    AMAFJJ        WKAFJJ
     C     *LIKE         DEFINE    AMAFNR        WKAFNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AKMAAF        WKMAAF
     C     *LIKE         DEFINE    AKREF1        WKREF1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KLLIJJ        WKLIJJ
     C     *LIKE         DEFINE    KLLINR        WKLINR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AVKDLI        WKLFNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOEKMJJ      WKKMJJ
     C     *LIKE         DEFINE    WAOEKMNR      WKKMNR
     C     *LIKE         DEFINE    WAOEKMPO      WKKMPO
     C     *LIKE         DEFINE    WAOEKDNR      WKKDNR
     C     *LIKE         DEFINE    WAOEPAKN      WKPAKN
     C     *LIKE         DEFINE    WAOEGWBR      WKGWBR
     C     *LIKE         DEFINE    WAOEGWDI      WKGWDI
     C     *LIKE         DEFINE    WAOEVPMI      WKVPMI
     C     *LIKE         DEFINE    WAOEAZVP      WKAZVP
     C     *LIKE         DEFINE    WAOESEDA      WKSEDA
     C     *LIKE         DEFINE    WAOEDATN      WKDATN
     C     *LIKE         DEFINE    WAOESTAT      WKSTAT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXMAILFROM    WKFROM
     C     *LIKE         DEFINE    EXMAILRCPT    WKRCPT
     C     *LIKE         DEFINE    EXMAILSUBJ    WKSUBJ          +16
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXXPRTTSTP    WKXPRTTSTP
     C     *LIKE         DEFINE    EXXPRTUCDE    WKXPRTUCDE
     C     *LIKE         DEFINE    EXXPRTLFZN    WKXPRTLFZN
     C     *LIKE         DEFINE    EXXPRTTEXT    WKXPRTTEXT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS AFKM                                          ***
     C**************************************************************************
     C     EAFKM         BEGSR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAOEKMJJ      KYAMJH
     C                   MOVEL(P)  WAOEKMNR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKVSBD      = AMVSBD
     C                   EVAL      WKAFJJ      = AMAFJJ
     C                   EVAL      WKAFNR      = AMAFNR
     C                   EVAL      WKKDNR      = AMKDNR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMKMJJ        KYKLKJ
     C                   MOVEL(P)  AMKMNR        KYKLKN
     C                   Z-ADD     *ZERO         KYKLJH
     C                   MOVEL(P)  *BLANK        KYKLLI
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHAFLK
     C*
     C                   IF        WKFENR     <> *ZERO         OR
     C                             KLFIRM     <> KYKLFI        OR
     C                             KLKMJJ     <> KYKLKJ        OR
     C                             KLKMNR     <> KYKLKN
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   Z-ADD     KLLIJJ        WKLIJJ
     C                   MOVEL(P)  KLLINR        WKLINR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AMAFJJ        KYAKJH
     C                   MOVEL(P)  AMAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKMAAF        WKMAAF
     C                   MOVEL(P)  AKREF1        WKREF1
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  INITIALISIEREN WK-FELDER                                          ***
     C**************************************************************************
     C     IWKFLD        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKKMPO      = *ZERO
     C                   EVAL      WKLFNR      = *BLANK
     C                   EVAL      WKKMNR      = *BLANK
     C                   EVAL      WKPAKN      = *BLANK
     C                   EVAL      WKVPMI      = *BLANK
     C                   EVAL      WKVSBD      = *BLANK
     C                   EVAL      WKAFJJ      = *ZERO
     C                   EVAL      WKAFNR      = *BLANK
     C                   EVAL      WKLIJJ      = *ZERO
     C                   EVAL      WKLINR      = *BLANK
     C                   EVAL      WKMAAF      = *BLANK
     C                   EVAL      WKREF1      = *BLANK
     C                   EVAL      WKKDNR      = *BLANK
     C                   EVAL      WKAZVP      = 1
     C                   MOVE      WKTDAT        WKSEDA
     C                   EVAL      WKIUPD      = *OFF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEI WAOE                                            ***
     C**************************************************************************
     C     VWAOE         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOEDATN  = WKDATN
     C                   EVAL      KYWAOESTAT  = '10'
     C                   EVAL      KYWAOEKMJJ  = *ZERO
     C                   EVAL      KYWAOEKMNR  = *BLANK
     C                   EVAL      KYWAOEKMPO  = *ZERO
     C                   EVAL      KYWAOEUPOS  = *ZERO
     C                   MOVEA     '03L     '    CHI
     C                   EXSR      CHWAOE
     C*-------------------------------------------------------------------------
     C                   DOW       *INLR       = *OFF
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHWAOE
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO         OR
     C                             WAOEFIRM   <> KYWAOEFIRM    OR
     C                             WAOEDATN   <> KYWAOEDATN    OR
     C                             WAOESTAT   <> KYWAOESTAT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      IWKFLD
     C                   EVAL      WKSTAT      = '00'
     C                   EVAL      WKIINT      = *OFF
     C                   EVAL      WKKMPO      = WAOEKMPO
     C                   EXSR      PAFVS
     C*--------------------------------------------------------
     C                   IF        WKSTAT      = '00'          OR
     C                             WKIINT      = *ON
     C                   EXSR      EAFKM
     C                   EXSR      EVSBD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKLINR      = *BLANK
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKSTAT      = '00'
     C                   EXSR      UAFVS
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKIINT      = *OFF
     C                   EXSR      UAFSP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        WKSTAT      = '00'          OR
     C                             WKIINT      = *ON
     C                   EXSR      EMAIL1
     C                   EXSR      EMAIL2
     C**                 EXSR      EMAIL3      nur für Test, Empfänger GANG
     C                   EVAL      WKSTAT      = '90'
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UWAOE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AFVS                                                       ***
     C**************************************************************************
     C     PAFVS         BEGSR
     C*
     C                   EVAL      WKAVKZ      = 'W'
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAVPN      = WAOEPAKN
     C                   EVAL      KYAVKJ      = WAOEKMJJ
     C                   EVAL      KYAVKM      = WAOEKMNR
     C                   EVAL      KYAVDN      = *BLANK
     C                   EVAL      KYAVPO      = *ZERO
     C                   MOVEA     '07+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             AVFIRM      = KYAVFI        AND
     C                             AVPAKN      = KYAVPN        AND
     C                             AVKMJJ      = KYAVKJ        AND
     C                             AVKMNR      = KYAVKM
     C*--------------------------------------------------------
     C                   IF        AVPAKN     <> *BLANK
     C                   EVAL      WKSTAT      = '90'
     C                   EVAL      WKAVKZ      = 'X'
     C                   EVAL      WKKMPO      = AVKMPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        AVPAKN      = *BLANK
     C                   EVAL      WKAVKZ      = 'U'
     C                   EVAL      WKKMPO      = AVKMPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '07R     '    CHI
     C                   EXSR      CHAFVS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EVAL      WKIINT      = *ON
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AFVS                                                       ***
     C**************************************************************************
     C     UAFVS         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAVKJ      = WAOEKMJJ
     C                   EVAL      KYAVKM      = WAOEKMNR
     C                   EVAL      KYAVPO      = WKKMPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   IF        WKIINT      = *OFF
     C                   EVAL      AVPAKN      = WAOEPAKN
     C                   EVAL      AVANZA      = WAOEAZVP
     C                   EVAL      AVHINW      = WAOEHINW
     C*
     C                   IF        WAOEVPMI   <> *BLANK
     C                   EVAL      AVTENR      = WAOEVPMI
     C                   ENDIF
     C*
     C                   IF        WAOEGWBR   <> *ZERO
     C                   EVAL      AVGWBR      = WAOEGWBR
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      AVKLKZ      = 'L'
     C                   EVAL      AVKDLI      = WKLFNR
     C                   EVAL      AVDSKZ      = DANEKZ
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        AVJNAM
     C                   MOVEL(P)  EXPSDSPROC    AVPROG
     C                   MOVEL(P)  EXPSDSBIBL    AVBIBL
     C                   MOVEL(P)  EXPSDSUSER    AVUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        AVJZEI
     C                   MOVE      WKTDAT        AVJDAT
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      CHI(06)     = *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHAFVS
     C                   WHEN      CHI(06)     = *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFVS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE AFSP                                                       ***
     C**************************************************************************
     C     UAFSP         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYASJH      = WAOEKMJJ
     C                   EVAL      KYASNR      = WAOEKMNR
     C                   EVAL      KYASKA      = 'KMNR'
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFSP
     C*-------------------------------------------------------------------------
     C                   IF        ASSPED      = WKLFNR
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHAFSP
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      ASSPED      = WKLFNR
     C*--------------------------------------------------------
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
     C                   SELECT
     C                   WHEN      CHI(06)     = *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHAFSP
     C                   WHEN      CHI(06)     = *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFSP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SPEDITEUR                                               ***
     C**************************************************************************
     C     EVSBD         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYVBBD      = WAOEVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHVSBD
     C                   EVAL      WKLFNR      = VBSPED
     C*
     C                   IF        WAOESPED <> *BLANK
     C                   EVAL      WKLFNR      = WAOESPED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN DER MAILS                                              ***
     C**************************************************************************
     C     VMAIL         BEGSR
     C*-------------------------------------------------------------------------
     C                   EXSR      MOAFVS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   E1XLST
     C                   CLEAR                   EXTR04
     C                   CLEAR                   EXAFLK01
     C                   Z-ADD     WKLIJJ        EXKL01LIJ1
     C                   MOVEL     WKLINR        EXKL01LIN1
     C                   MOVEL(P)  'M'           EXKL01VEAR
     C                   MOVEL     *ON           EXKL01DRSD
     C                   MOVEL(P)  DANEKZ        EXKL01DANZ
     C                   MOVEL(P)  *OFF          E1XLSTARKZ
     C*
     C                   CALL      'DRAFLK01'
     C                   PARM                    EXAFLK01
     C                   PARM                    E1XLST
     C                   PARM                    EXTR04
     C*
     C                   IN        EXTRLD
     C     DAFEHL        IFEQ      *ON
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EXSR      UPMAILFROM
     C                   EXSR      UPMAILRCPT
     C                   EXSR      UPMAILBODY
     C                   EXSR      UPMAILSUBJ
     C*
     C                   CLEAR                   EXAFLK01
     C                   Z-ADD     WKLIJJ        EXKL01LIJ1
     C                   MOVEL     WKLINR        EXKL01LIN1
     C                   MOVEL(P)  'M'           EXKL01VEAR                     MAIL
     C                   MOVE      *OFF          EXKL01DRSD                     NUR DRUCKEN
     C                   MOVEL(P)  DANEKZ        EXKL01DANZ                     OHNE DRUCKWINDOW
     C                   MOVEL(P)  *OFF          E1XLSTARKZ
     C*
     C                   CALL      'DRAFLK01'
     C                   PARM                    EXAFLK01
     C                   PARM                    E1XLST
     C                   PARM                    EXTR04
     C*-------------------------------------------------------------------------
     C                   EVAL      WKRCPT      = *BLANK
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ABSENDER                                                          ***
     C**************************************************************************
     C     UPMAILFROM    BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '4     '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'MAILFROM'    WKXPRTUCDE
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'MAILFROM'    WKXPRTUCDE
     C                   Z-ADD     *ZERO         WKXPRTLFZN
     C                   MOVEL(P)  WKFROM        WKXPRTTEXT
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  EMPFÄNGER                                                         ***
     C**************************************************************************
     C     UPMAILRCPT    BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '4     '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'MAILTO  '    WKXPRTUCDE
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'MAILTO  '    WKXPRTUCDE
     C                   Z-ADD     *ZERO         WKXPRTLFZN
     C                   MOVEL(P)  WKRCPT        WKXPRTTEXT
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  BODY                                                              ***
     C**************************************************************************
     C     UPMAILBODY    BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKURLG      = %TRIM(WKURL1) + %TRIM(WAOEPAKN)
     C                                         + %TRIM(WKURL2)
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '4     '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   MOVEL(P)  *ZERO         WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = KON(01)
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = *BLANK
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:1:65)
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:66:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:131:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:196:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:261:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:326:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:391:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:456:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:521:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:586:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:651:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:716:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:781:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKBODY:846:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = *BLANK
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKURLG:1:65)
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKURLG:66:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKURLG:131:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = %SUBST(WKURLG:196:65)
     C*
     C                   IF        WKXPRTTEXT <> *BLANK
     C                   EXSR      TRXPRT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT  = *BLANK
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT=%TRIM(KON(31))+' '+%TRIM(WKMAAF)
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BODY    '    WKXPRTUCDE
     C                   ADD       5             WKXPRTLFZN
     C                   EVAL      WKXPRTTEXT=%TRIM(KON(32))+' '+%TRIM(WKREF1)
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  BETREFF                                                           ***
     C**************************************************************************
     C     UPMAILSUBJ    BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '4     '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BETREFF '    WKXPRTUCDE
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '      '      PCPGST
     C                   MOVE      E1XLSTTSTP    WKXPRTTSTP
     C                   MOVEL(P)  'BETREFF '    WKXPRTUCDE
     C                   Z-ADD     *ZERO         WKXPRTLFZN
     C                   EVAL      DUN040      = WKAFJJ
     C*
     C                   SELECT
     C                   WHEN      AKAFAT = 'A02'
     C                   EVAL      WKXPRTTEXT  = %TRIM(WKSUBJ) + ' ' + WKMAAF
     C                   WHEN      AKAFAT = '08'
     C                   EVAL      WKXPRTTEXT  = %TRIM(WKSUBJ) + ' ' + WKREF1
     C                   OTHER
     C                   EVAL      WKXPRTTEXT  = %TRIM(WKSUBJ) + ' ' +
     C                                           DUC004 + '/' + WKAFNR
     C                   ENDSL
     C*
     C                   EXSR      TRXPRT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI XPRT                                                 ***
     C**************************************************************************
     C     TRXPRT        BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXXPRT
     C                   MOVEL(P)  PCPGST        EXXPRTPGST
     C                   MOVE      WKXPRTTSTP    EXXPRTTSTP
     C                   MOVEL(P)  WKXPRTUCDE    EXXPRTUCDE
     C*
     C     PCPGST        IFEQ      *BLANK
     C                   MOVEL(P)  *OFF          EXXPRTIFKZ
     C                   MOVEL(P)  DASPCD        EXXPRTSPCD
     C                   MOVEL(P)  WKXPRTLFZN    EXXPRTLFZN
     C                   MOVEL(P)  WKXPRTTEXT    EXXPRTTEXT
     C                   ENDIF
     C*
     C                   CALL      'TRXPRT'
     C                   PARM                    EXXPRT
     C                   PARM                    RTXPRT
     C*
     C                   MOVEL(P)  RTXPRTFENR    WKFENR
     C                   MOVEL(P)  RTXPRTRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  SENDUNGSVERFOLGUNG                                                ***
     C**************************************************************************
     C     MOAFVS        BEGSR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   EVAL      EXTRNDPGST  = 'SENDNG'
     C                   EVAL      EXTRNDKEYB  = %CHAR(WAOEKMJJ) + WAOEKMNR
     C*
     C                   CALL      'MOAFVS'                             98
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   EVAL      WKURL1      = %SUBST(RTTRNDDATE:1:128)
     C                   EVAL      WKURL2      = %SUBST(RTTRNDDATE:129:128)
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE WAOE                                                       ***
     C**************************************************************************
     C     UWAOE         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOEKMJJ  = WAOEKMJJ
     C                   EVAL      KYWAOEKMNR  = WAOEKMNR
     C                   EVAL      KYWAOEKMPO  = WAOEKMPO
     C                   EVAL      KYWAOEUPOS  = WAOEUPOS
     C                   MOVEA     '01+U    '    CHI
     C                   EXSR      CHWAOE
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR = '0000'
     C                             AND WAOEFIRM = KYWAOEFIRM
     C                             AND WAOEKMJJ = KYWAOEKMJJ
     C                             AND WAOEKMNR = KYWAOEKMNR
     C                             AND WAOEKMPO = KYWAOEKMPO
     C                             AND WAOEUPOS = KYWAOEUPOS
     C                   EVAL      WAOESTAT    = WKSTAT
     C*
     C                   IF        WAOESPED    = *BLANK
     C                   EVAL      WAOESPED    = WKLFNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        CHI(06) = *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHWAOE
     C                   ENDIF
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHWAOE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHWAOE
     C                   EVAL      WKFENR = '0000'
     C                   ENDSR
     C**************************************************************************
     C***  EMAIL VERSAND, EMPFÄNGER AUS TXST                                 ***
     C**************************************************************************
     C     EMAIL1        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKI1DG      = *OFF
     C*-------------------------------------------------------------------------
     C                   DO        10
     C                   EVAL      WKRCPT = *BLANK
     C                   EVAL      WKSPCD = DASPCD
     C                   EXSR      ETXST
     C                   EXSR      ERMKO
     C*--------------------------------------------------------
     C                   IF        WKRCPT      = *BLANK                         KEIN EMAIL-EMPFÄNGER
     C                   LEAVESR                                                HINTERLEGT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      VMAIL
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  EMAIL VERSAND, EMPFÄNGER AUS TXBE                                 ***
     C**************************************************************************
     C     EMAIL2        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKI1DG = *OFF
     C*-------------------------------------------------------------------------
     C                   DO        10
     C                   EVAL      WKRCPT = *BLANK
     C                   EVAL      WKSPCD = DASPCD
     C                   EXSR      ETXBE
     C                   EXSR      ERMKO
     C*--------------------------------------------------------
     C                   IF        WKRCPT = *BLANK                              KEIN EMAIL-EMPFÄNGER
     C                   LEAVESR                                                HINTERLEGT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      VMAIL
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  EMAIL VERSAND TEST                                                ***
     C**************************************************************************
     C     EMAIL3        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      WKI1DG      = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKRCPT = *BLANK
     C                   EVAL      WKSPCD = DASPCD
     C                   EXSR      ETXBE
     C                   EVAL      WKRCPT      = 'manfred.gang@dometic.com'
     C                   EXSR      ERMKO
     C                   EXSR      VMAIL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN EMAIL ADRESSE                                           ***
     C**************************************************************************
     C     ETXST         BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        WKI1DG      = *OFF
     C                   MOVEL(P)  'TRTX27'      KYTTTC                         ANSPRECHPARTNER
     C                   MOVEL(P)  WKKDNR        KYTTKL
     C                   MOVE      *BLANK        KYTTTE
     C                   MOVEL(P)  'EK'          KYTTA1
     C                   MOVE      *BLANK        KYTTA2
     C                   MOVE      *BLANK        KYTTSP
     C                   MOVEL(P)  'EMAIL '      KYTTUC
     C                   Z-ADD     *ZERO         KYTTDA
     C                   Z-ADD     *ZERO         KYTTZN
     C                   MOVEL(P)  'EB'          EXTTDR01
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTXST
     C                   EVAL      WKI1DG      = *ON
     C                   ELSE
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTXST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             TTFIRM      = KYTTFI        AND
     C                             TTTCDE      = KYTTTC        AND
     C                             TTKDLI      = KYTTKL        AND
     C                             TTTENR      = KYTTTE        AND
     C                             TTA115      = KYTTA1
     C*
     C                   IF        TTUCDE      = 'EMAIL'       AND
     C                             TTDR01      = 'EB'
     C                   MOVEL(P)  TTTEXT        WKRCPT
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTXST
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN EMAIL ADRESSE                                           ***
     C**************************************************************************
     C     ETXBE         BEGSR
     C*-------------------------------------------------------------------------
     C                   IF        WKI1DG      = *OFF
     C                   MOVEL(P)  'AFDA'        KYTBTA
     C                   Z-ADD     WKAFJJ        KYTBJH
     C                   MOVEL(P)  WKAFNR        KYTBNR
     C                   Z-ADD     *ZERO         KYTBPO
     C                   Z-ADD     *ZERO         KYTBUP
     C                   MOVE      *BLANK        KYTBA1
     C                   MOVE      *BLANK        KYTBA2
     C                   MOVEL(P)  'TXVS'        KYTBTC
     C                   MOVEL(P)  '1'           KYTBUC
     C                   MOVE      *BLANK        KYTBSP
     C                   Z-ADD     *ZERO         KYTBZN
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHTXBE
     C                   EVAL      WKI1DG      = *ON
     C                   ELSE
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHTXBE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             TBFIRM      = KYTBFI        AND
     C                             TBTXAR      = KYTBTA        AND
     C                             TBJHJJ      = KYTBJH        AND
     C                             TBAFNR      = KYTBNR        AND
     C                             TBPOSI      = KYTBPO        AND
     C                             TBUPOS      = KYTBUP        AND
     C                             TBA115      = KYTBA1        AND
     C                             TBA215      = KYTBA2        AND
     C                             TBTCDE      = KYTBTC        AND
     C                             TBUCDE      = KYTBUC
     C*
     C                   IF        TBDRK1      = 'M'
     C                   MOVEL(P)  TBTEXT        WKRCPT
     C                   EVAL      WKSPCD = TBSPCD
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHTXBE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHAFVS
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTXBE
     C/COPY QCPYSRC,CHTXST
     C/COPY QCPYSRC,CHVSBD
     C/COPY QCPYSRC,CHWAOE
     C/COPY QCPYSRC,TRDATE
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
