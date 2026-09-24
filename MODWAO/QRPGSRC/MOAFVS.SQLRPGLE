     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Sendungsdaten bereitstellen
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 16.12.2010
     H*  -----------------------------------------------------------------------
     H*  Änderung: SZ 26.12.2010 Ermitteln SSCC für Boll/Unitrans LFNR=90292
     H*  Änderung: SZ 17.02.2011 Ermitteln Versandbedingung aus AFKM, keine
     H*            Ausgabe für Boll/Unitrans wenn Aufruf aus TRLBAK oder TRAB32
     H*  Änderung: SZ 22.02.2011 Vor Aufruf TRSP16 prüfen, ob AFVS-Satz vorhan-
     H*            den ist
     H*  Änderung: SZ 10.03.2011 Anzahl Sendungen an T1AFVS übergeben
     H*  Änderung: SZ 18.05.2011 Versandbedingung zur Ermittlung des Spediteurs
     H*            zuerst aus AFLK lesen.
     H*  Änderung: ZG 09.06.2011 keine Etiketten für Warenrückgabe vom Kunden
     H*            AFAT = '50 '
     H*  Änderung: SZ 22.07.2011 parallel zu Boll auch Schenker abfragen,
     H*            gleiche Abwicklung
     H*  Änderung: SZ 26.07.2011 keine Etiketten und Versanddaten in den Sped.-
     H*            Schnittstellen bei Gutschriften
     H*  Änderung: SZ 02.08.2011 Ermittlung URL für Sendungsverfolgung
     H*            Projekt 7649
     H*  Änderung: SZ 04.08.2011 Anpassung Sendungsverfolgung für tof
     H*  Änderung: SZ 18.08.2011 Projekt 7722, versch. Anpassungen
     H*  Änderung: SZ 22.08.2011 verhindern der Anlage doppelter Sätze in AVFS
     H*            auch in SR VAFVS.
     H*  Änderung: SZ 10.01.2012 Bei verschiedenen Sendungen wurde die Versand-
     H*            bedingung auch beim Lieferschein nicht angepasst. Daher wurde
     H*            bei der Sendungsverfolgung eine falsche URL generiert.
     H*            Bei Verarbeitung der Rückdaten von der Spedition erfolgt aber
     H*            ein Update des Spediteurs in AFSP. Daher wird jetzt zur Er-
     H*            mittlung der Versandbedingung zur Sendungsverfolgung zuerst
     H*            AFSP gelesen, dann AFLK, dann AFKM, danach ggf. noch VSBD.
     H*  Änderung: SZ 15.02.2012 Für DHL auch die PLZ an den 2. Teil der URL
     H*            anhängen.
     H*  Änderung: SZ 16.02.2012 Projekt 8260, Kühne + Nagel wie Schenker
     H*  Änderung: SZ 04.07.2012 Projekt 8390, Schenker Spanien
     H*  Änderung: SZ 05.07.2012 Projekt 8625, Satz aus AFVS löschen, wenn die
     H*            Versandbedingung auf eine Bedingung gewechselt wird, die
     H*            intern abgehandelt wird (Boll, Schenker, Kühne + Nagel)
     H*  Änderung: SZ 30.11.2012 Projekt 9128, neue Spedition BRT Italien
     H*  Änderung: SZ 05.03.2013 Projekt 8997, neue Schnittstelle TNT
     H*  Änderung: SZ 11.03.2013 Projekt 8997, Sendungsnr. für TNT mit 6 Stellen
     H*            für fortlaufende Nummerierung erstellen. Barcode dann nicht
     H*            2/5 sondern Code 128.
     H*  Änderung: SZ 24.04.2013 Projekt 9228, neue Schnittstelle Loxx
     H*  Änderung: SZ 27.07.2018 Projekt 13987, Daten aus PWINORD und aus LFS zu
     H*            Sendungsdaten an XLAFLK06 zurückgeben.
     H*  Änderung: SZ 29.08.2018 Projekt 13987, Ergänzung Kundenbestellnummer
     H*  Änderung: SZ 10.05.2019 'BP' an den Anfang der Referenz setzen
     H*            Noch fraglich, ob in jedem Fall oder nur für Hymer.
     H*  Änderung: SZ 14.05.2019 Nach Rücksprache mit Hr. Sauter von Hymer das
     H*            Prefix 'BP' entfernt, da auf unseren Labeln schon das vor-
     H*            gesehene Prefix 'K' gedruckt wird.
     H*  Änderung: SZ 26.06.2019 Projekt 13987, Ergänzungen
     H*  Änderung: GS 26.04.2023 Projekt 230214 Erweiterung der AKREF1.- Suche
     H*            von bisher (AKREF1 2,6) auf (AKREF1 1,7)
     F**************************************************************************
     F*
     F*  PGST = 'SPED'
     F*  Dieses Programm ruft pro übergebener Belegnummer das Programm zum
     F*  Übertrag der Daten an die Speditionen (TRSP16) auf.
     F*  Vorab wird über Aufruf T1AFVS ein Datensatz in AFVS geschrieben.
     F*
     F*  PGST = 'SSCC'
     F*  Das Programm ermittelt eine neue SSCC. Eigene ILN in WERK muss gefüllt
     F*  sein!
     F*
     F*  PGST = 'SENDNG'
     F*  Das Programm ermittelt die URL für die Sendungsverfolgung entsprechend
     F*  dem in der Versandbedingung VSBD zugeordneten Spediteur aus TRUR.
     F*  Teilweise werden Daten ergänzt (PLZ).
     F*
     F*  PGST = 'ERAFVS'
     F*  Das Programm ermittelt Daten für den Druck des Warenanhängers über
     F*  Programm XLAFLK06. Der Aufruf erfolgt von dort.
     F*
     F*  PGST = *undefiniert*
     F*  Es wird geprüft, ob ein AFVS Satz vorhanden ist. Wenn nicht, wird ein
     F*  Satz angelegt. Danach wird über TRSP16 ein Datensatz in die Speditions-
     F*  schnittstelle geschrieben.
     F*
     F*  Für Boll/Unitrans und Schenker wird das Anlegen von Sätzen in AFVS über
     F*  dieses Programm verhindert. Diese Speditionen werden direkt auf der
     F*  iSeries abgewickelt, es gibt keinen eigenen "Speditionsrechner" und
     F*  damit auch keine Schnittstellen. Die Sätze in AFVS werden erst mit der
     F*  generierten SSCC direkt in T1AFVS angelegt.
     F*  Gilt auch für Kühne + Nagel.
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
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D AFVS          E DS                  INZ
     D KYAFVS        E DS                  INZ
     D*
     D SPDP          E DS                  INZ
     D KYSPDP        E DS                  INZ
     D*
     D TRUR          E DS                  INZ
     D KYTRUR        E DS                  INZ
     D*
     D VSBD          E DS                  INZ
     D KYVSBD        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXSP16        E DS                  INZ
     D*
     D EXAFVS        E DS                  INZ
     D RTAFVS        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
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
     C     *ENTRY        PLIST
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBDTA
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C                   WHEN      EXTRNDPGST  = 'SSCC'        AND              TNT
     C                             WKSPED      = '90169'
     C                   EXSR      EBARC
     C                   WHEN      EXTRNDPGST  = 'SSCC'
     C                   EXSR      ESSCC
     C                   WHEN      EXTRNDPGST  = 'SPED'        AND
     C                             EXTRNDPROG  = 'TRLBAK'
     C                   EXSR      VAFVS
     C                   WHEN      EXTRNDPGST  = 'SPED'        AND
     C                             EXTRNDPROG  = 'TRAB32'
     C                   EXSR      VAFVS
     C                   WHEN      EXTRNDPGST  = 'SENDNG'
     C                   EXSR      SENDNG
     C                   WHEN      EXTRNDPGST  = 'ERAFVS'
     C                   EXSR      ERAFVS
     C                   OTHER
     C                   EXSR      PAFVS
     C                   EXSR      TRSP16
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
     C                   Z-ADD     *ZERO         WKGWNT           15 4          NETTOGEWICHT
     C                   Z-ADD     *ZERO         WKGWBT           15 4          BRUTTOGEWICHT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYKLFI                         AFLK
     C                   MOVEL(P)  DAFIRM        KYASFI                         AFSP
     C                   MOVEL(P)  DAFIRM        KYAVFI                         AFVS
     C                   MOVEL(P)  DAFIRM        KYSPDPFIRM                     SPDP
     C                   MOVEL(P)  DAFIRM        KYTRURFIRM                     TRUR
     C                   MOVEL(P)  DAFIRM        KYVBFI                         VSBD
     C*-------------------------------------------------------------------------
     C                   EVAL      WKLFDN      = *ZERO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSPED      = %SUBST(EXTRNDKEYB:11:10)
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   EVAL      RTTRNDFENR  = *ZERO
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
     C     *LIKE         DEFINE    WKC001        WKI002                         IND.2
     C     *LIKE         DEFINE    WKC001        WKI003                         IND.3
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKWKNR          + 2            WERKSNUMMER
     C     *LIKE         DEFINE    WKC001        WKURL1         +127            URL TEIL 1
     C     *LIKE         DEFINE    WKC001        WKURL2         +127            URL TEIL 2
     C     *LIKE         DEFINE    WKC001        WKMAAF         +  9            MAN. AUFTRAGSNR.
     C     *LIKE         DEFINE    WKC001        WKREF1         + 29            REFERENZ 1
     C     *LIKE         DEFINE    WKC001        WKREF2         + 29            REFERENZ 2
     C     *LIKE         DEFINE    WKC001        WKH330         + 19            LIEFERANT B. KUNDEN
     C     *LIKE         DEFINE    WKC001        WKD235         + 14            KUNDENIDENTNR.
     C     *LIKE         DEFINE    WKC001        WKD236         + 14            KDN.BESTELLNUMMER
     C     *LIKE         DEFINE    WKC001        WKAFLPTENR     + 14            IDENTNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKLFDN          + 4            ZÄHLER
     C     *LIKE         DEFINE    WKN010        WKJDAT          + 5            DATUM 6-STELLIG
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXSP16SPE1    WKSPED
     C     *LIKE         DEFINE    EXSP16AJ10    WKKMJJ
     C     *LIKE         DEFINE    EXSP16AN10    WKKMNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXAFVSKLKZ    WKKLKZ
     C     *LIKE         DEFINE    EXAFVSANZA    WKANZA
     C     *LIKE         DEFINE    EXAFVSPAKN    WKAFVSPAKN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    AMVSBD        WKVSBD
     C     *LIKE         DEFINE    AMAFAT        WKAFAT
     C     *LIKE         DEFINE    AMPOLZ        WKPOLZ
     C     *LIKE         DEFINE    AMAFJJ        WKAFJJ
     C     *LIKE         DEFINE    AMAFNR        WKAFNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KLLIJJ        WKAFLKLIJJ
     C     *LIKE         DEFINE    KLLINR        WKAFLKLINR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    SPDPSPSN      WKSPSN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AFVS                                              ***
     C**************************************************************************
     C     EAFVS         BEGSR
     C*
     C                   EVAL      WKI002      = *OFF
     C                   EVAL      WKI003      = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAVKJ      = WKKMJJ
     C                   EVAL      KYAVKM      = WKKMNR
     C                   EVAL      KYAVPO      = *ZERO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             AVFIRM      = KYAVFI        AND
     C                             AVKMJJ      = KYAVKJ        AND
     C                             AVKMNR      = KYAVKM
     C                   EVAL      WKI002      = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        AVPAKN     <> *BLANK
     C                   EVAL      WKI003      = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AFVS, WENN NICHT VORHANDEN --> ANLEGEN                     ***
     C**************************************************************************
     C     PAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      DUC004      = EXTRNDKEYB
     C                   Z-ADD     DUN040        WKKMJJ
     C                   EVAL      WKKMNR      = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      WKSPED      = %SUBST(EXTRNDKEYB:11:10)
     C*-------------------------------------------------------------------------
     C                   IF        %SUBST(DAPROG:1:6)  = 'T1AFVS'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EAFVS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C                   WHEN      WKSPED      = '90292'       OR               BOLL/UNITRANS
     C                             WKSPED      = '90481'       OR               SCHENKER OBI
     C                             WKSPED      = '90169'       OR               TNT
     C                             WKSPED      = '92222'       OR               KÜHNE+NAGEL
     C                             WKSPED      = '92224'       OR               SCHENKER SPANIEN
     C                             WKSPED      = '92225'       OR               BRT ITALIEN
     C                             WKSPED      = '92230'                        LOXX
     C*
     C                   IF        WKI002      = *ON           AND
     C                             WKI003      = *OFF
     C                   EXSR      DLAFVS
     C                   ENDIF
     C*--------------------------------------------------------
     C                   WHEN      WKI002      = *ON
     C                   LEAVESR
     C*--------------------------------------------------------
     C                   OTHER
     C                   EVAL      WKFENR      = *ZERO
     C                   EVAL      WKKLKZ      = 'L'
     C                   EVAL      WKANZA      = 1
     C                   EXSR      T1AFVS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN AFVS UND ÜBERGABE IN SPEDITIONSDATEI BEI AUFRUF AUS     ***
     C***  TRLBAK                                                            ***
     C**************************************************************************
     C     VAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSPED      = *BLANK
     C                   EVAL      WKANZA      = 1
     C                   EVAL      DUC004      = EXTRNDKEYB
     C                   Z-ADD     DUN040        WKKMJJ
     C                   EVAL      WKKMNR      = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      DUC005      = %SUBST(EXTRNDKEYB:21:5)
     C                   TESTN                   DUC005               97
     C*
     C                   IF        *IN97       = *ON
     C                   Z-ADD     DUN050        WKANZA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EVSBD
     C*--------------------------------------------------------
     C                   IF        WKAFAT      = '02 '         OR               Nachberechnung
     C                             WKAFAT      = '14 '         OR               Gutschrift
     C                             WKAFAT      = '50 '         OR               Warenrückgabe
     C                             WKAFAT      = '70 '         OR               Preisdifferenz
     C                             WKAFAT      = '71 '         OR               Gutschrift Menge
     C                             WKAFAT      = '82 '                          Gutschrift Market In
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      KYVBBD      = WKVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHVSBD
     C                   EVAL      WKSPED      = VBSPED
     C*-------------------------------------------------------------------------
     C                   EXSR      EAFVS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C                   WHEN      WKSPED      = '90292'       OR               BOLL/UNITRANS
     C                             WKSPED      = '90481'       OR               SCHENKER OBI
     C                             WKSPED      = '90169'       OR               TNT
     C                             WKSPED      = '92222'       OR               KÜHNE+NAGEL
     C                             WKSPED      = '92224'       OR               SCHENKER SPANIEN
     C                             WKSPED      = '92225'       OR               BRT ITALIEN
     C                             WKSPED      = '92230'                        LOXX
     C*
     C                   IF        WKI002      = *ON           AND
     C                             WKI003      = *OFF
     C                   EXSR      DLAFVS
     C                   ENDIF
     C*
     C                   LEAVESR
     C*--------------------------------------------------------
     C                   WHEN      WKI002      = *OFF
     C                   EVAL      WKKLKZ      = 'L'
     C                   EXSR      T1AFVS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      TRSP16
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN AFVS SATZ                                               ***
     C**************************************************************************
     C     T1AFVS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFVS
     C                   EVAL      EXAFVSPGST  = 'WRITE'
     C                   EVAL      EXAFVSPROG  = 'MOAFVS'
     C                   EVAL      EXAFVSKMJJ  = WKKMJJ
     C                   EVAL      EXAFVSKMNR  = WKKMNR
     C                   EVAL      EXAFVSKMPO  = *ZERO
     C                   EVAL      EXAFVSKDLI  = WKSPED
     C                   EVAL      EXAFVSKLKZ  = WKKLKZ
     C                   EVAL      EXAFVSANZA  = WKANZA
     C*--------------------------------------------------------
     C                   CALL      'T1AFVS'
     C                   PARM                    EXAFVS
     C                   PARM                    RTAFVS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN AFVS SATZ                                                 ***
     C**************************************************************************
     C     DLAFVS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAFVS
     C                   EVAL      EXAFVSPGST  = 'DELETE'
     C                   EVAL      EXAFVSPROG  = 'MOAFVS'
     C                   EVAL      EXAFVSKMJJ  = WKKMJJ
     C                   EVAL      EXAFVSKMNR  = WKKMNR
     C                   EVAL      EXAFVSKMPO  = *ZERO
     C                   EVAL      EXAFVSKDLI  = WKSPED
     C                   EVAL      EXAFVSKLKZ  = WKKLKZ
     C                   EVAL      EXAFVSANZA  = WKANZA
     C*--------------------------------------------------------
     C                   CALL      'T1AFVS'
     C                   PARM                    EXAFVS
     C                   PARM                    RTAFVS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN SCHNITTSTELLENSATZ                                      ***
     C**************************************************************************
     C     TRSP16        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSP16
     C                   EVAL      EXSP16PGST  = 'EINZEL'
     C                   EVAL      EXSP16PROG  = 'MOAFVS'
     C                   EVAL      EXSP16SPE1  = WKSPED
     C                   Z-ADD     WKKMJJ        EXSP16AJ10
     C                   EVAL      EXSP16AN10  = WKKMNR
     C*--------------------------------------------------------
     C                   CALL      'TRSP16'
     C                   PARM                    EXSP16
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN EINER NEUEN SSCC                                        ***
     C**************************************************************************
     C     ESSCC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKWKNR      = %SUBST(EXTRNDKEYB:1:3)
     C                   EVAL      WKSPED      = %SUBST(EXTRNDKEYB:11:10)
     C*-------------------------------------------------------------------------
     C                   IF        WKSPED     <> '90292'       AND
     C                             WKSPED     <> '90481'       AND
     C                             WKSPED     <> '92222'       AND
     C                             WKSPED     <> '92224'       AND
     C                             WKSPED     <> '92225'
     C                   EVAL      RTTRNDFENR  = '0031'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTR02
     C                   EVAL      %SUBST(#CKOMM:21:3) = WKWKNR
     C*--------------------------------------------------------
     C                   CALL      'TRSSCC'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE  = %SUBST(#CKOMM:1:20)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BARCODE FÜR TNT                                         ***
     C**************************************************************************
     C     EBARC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKWKNR      = %SUBST(EXTRNDKEYB:1:3)
     C                   EVAL      WKSPED      = %SUBST(EXTRNDKEYB:11:10)
     C*-------------------------------------------------------------------------
     C                   IF        WKSPED     <> '90169'
     C                   EVAL      RTTRNDFENR  = '0031'
     C                   EVAL      RTTRNDFFLD  = 'WKSPED'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ERLFDN
     C                   Z-ADD     WKJDAT        DUN060
     C                   EVAL      RTTRNDDATE  = DUC006
     C                   Z-ADD     WKLFDN        DUN060
     C                   EVAL      RTTRNDDATE  = %TRIM(RTTRNDDATE) + DUC006
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SPEDITEUR                                               ***
     C**************************************************************************
     C     EAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYASJH      = WKKMJJ
     C                   EVAL      KYASNR      = WKKMNR
     C                   EVAL      KYASKA      = 'KMNR'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFSP
     C                   EVAL      WKSPED      = ASSPED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VERSANDBEDINGUNG                                        ***
     C**************************************************************************
     C     EVSBD         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKVSBD      = *BLANK
     C                   EVAL      WKAFAT      = *BLANK
     C                   EVAL      WKPOLZ      = *BLANK
     C*-------------------------------------------------------------------------
     C                   EVAL      KYKLKJ      = WKKMJJ
     C                   EVAL      KYKLKN      = WKKMNR
     C                   EVAL      KYKLJH      = *ZERO
     C                   EVAL      KYKLLI      = *BLANK
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHAFLK
     C*--------------------------------------------------------
     C                   IF        WKFENR      = *ZERO         AND
     C                             KLFIRM      = KYKLFI        AND
     C                             KLKMJJ      = KYKLKJ        AND
     C                             KLKMNR      = KYKLKN
     C                   EVAL      WKVSBD      = KLVSBD
     C                   EVAL      WKAFAT      = KLAFAT
     C                   EVAL      WKPOLZ      = KLPOLZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        WKVSBD     <> *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAMJH      = WKKMJJ
     C                   EVAL      KYAMKM      = WKKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C                   EVAL      WKVSBD      = AMVSBD
     C                   EVAL      WKAFAT      = AMAFAT
     C                   EVAL      WKPOLZ      = AMPOLZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN FÜR SENDUNGSVERFOLGUNG                            ***
     C**************************************************************************
     C     SENDNG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKURL1      = *BLANK
     C                   EVAL      WKURL2      = *BLANK
     C*-------------------------------------------------------------------------
     C                   EVAL      DUC004      = EXTRNDKEYB
     C                   Z-ADD     DUN040        WKKMJJ
     C                   EVAL      WKKMNR      = %SUBST(EXTRNDKEYB:5:6)
     C                   EVAL      WKSPED      = %SUBST(EXTRNDKEYB:11:10)
     C*-------------------------------------------------------------------------
     C                   EXSR      EAFSP
     C                   EXSR      EVSBD
     C*-------------------------------------------------------------------------
     C                   IF        WKSPED      = *BLANK
     C                   EVAL      KYVBBD      = WKVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHVSBD
     C                   EVAL      WKSPED      = VBSPED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTRURKEY1  = 'LFNR'
     C                   EVAL      KYTRURKEY2  = WKSPED
     C                   EVAL      KYTRURLFZN  = *ZERO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRUR
     C                   EVAL      WKURL1      = TRURURLP
     C*--------------------------------------------------------
     C                   IF        WKURL1     <> *BLANK
     C                   EVAL      KYTRURKEY1  = 'LFNR'
     C                   EVAL      KYTRURKEY2  = WKSPED
     C                   EVAL      KYTRURLFZN  = 1
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRUR
     C                   EVAL      WKURL2      = TRURURLP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      WKFENR      = *ZERO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKSPED      = '90864'                        TOF
     C                   EVAL      WKURL2      = %TRIM(WKURL2) + %TRIM(WKPOLZ)
     C                   WHEN      WKSPED      = '90513'                        DHL
     C                   EVAL      WKURL2      = %TRIM(WKURL2) + %TRIM(WKPOLZ)
     C                   WHEN      WKSPED      = 'xxxxx'                        HERMES
     C                   EVAL      WKURL2      = %TRIM(WKURL2) + %TRIM(WKPOLZ)
     C                   WHEN      WKSPED      = '92213'                        PartsExpress
     C                   EVAL      WKURL2      = %TRIM(WKURL2) + %TRIM(WKPOLZ)
     C                   WHEN      WKSPED      = '0000726'                      PartsExpress
     C                   EVAL      WKURL2      = %TRIM(WKURL2) + %TRIM(WKPOLZ)
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EVAL      %SUBST(RTTRNDDATE:1:128) = WKURL1
     C                   EVAL      %SUBST(RTTRNDDATE:129:128) = WKURL2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LAUFENDE NUMMER                                         ***
     C**************************************************************************
     C     ERLFDN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        WKSPED      = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKSPSN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKWKNR        KYSPDPWKNR
     C                   MOVEL(P)  WKSPED        KYSPDPSPED
     C                   Z-ADD     *YEAR         KYSPDPJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSPDP
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO                          DATENSATZ EXISTIERT
     C                   MOVEL(P)  WKWKNR        KYSPDPWKNR                     NICHT
     C                   MOVEL(P)  WKSPED        KYSPDPSPED
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
     C                   MOVEL(P)  WKWKNR        KYSPDPWKNR
     C                   MOVEL(P)  WKSPED        KYSPDPSPED
     C                   Z-ADD     *YEAR         KYSPDPJAHR
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
     C                   Z-ADD     SPDPJDAT      WKJDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
       //*************************************************************************
       //** ERMITTELN PAKETDATEN ZUM LIEFERSCHEIN                              ***
       //*************************************************************************
       BEGSR ERAFVS;

       WKMAAF = *BLANK;
       WKREF1 = *BLANK;
       WKREF2 = *BLANK;
       WKD235 = *BLANK;
       WKD236 = *BLANK;
       WKH330 = *BLANK;
       WKAFJJ = *ZERO;
       WKAFNR = *BLANK;
       WKGWBT = *ZERO;
       WKGWNT = *ZERO;

       MONITOR;
         WKAFLKLIJJ = %DEC(%SUBST(EXTRNDDATE:1:4):4:0);
       ON-ERROR *PROGRAM;
         WKAFLKLIJJ = *ZERO;
         EXSR RMVMONMSG;
       ENDMON;
       WKAFLKLINR = %SUBST(EXTRNDDATE:5:6);
       WKAFVSPAKN = %SUBST(EXTRNDDATE:11:20);
       WKAFLPTENR = %SUBST(EXTRNDDATE:31:15);

       EXEC SQL
         SELECT DISTINCT
         AKMAAF,
         SUBSTR(AKREF1, 1, 7),
         SUBSTR(AKREF2, 1, 10),
         ORD235,
         ORD236,
         KLAFJJ,
         KLAFNR

         INTO :WKMAAF, :WKREF1, :WKREF2, :WKD235, :WKD236, :WKAFJJ, :WKAFNR

         FROM AFLK

         LEFT JOIN AFKO
         ON KLFIRM = AKFIRM
         AND KLAFJJ = AKAFJJ
         AND KLAFNR = AKAFNR

         LEFT JOIN TVRELWAECO/PWINORDS
         ON SUBSTR(AKREF1, 1, 7) = ORD040

         WHERE KLFIRM = :DAFIRM
         AND KLLIJJ = :WKAFLKLIJJ
         AND KLLINR = :WKAFLKLINR
         AND ORD220 = :WKAFLPTENR;

       EXEC SQL
         SELECT DISTINCT
         PK1.PKNGEW,
         PK1.PKBGEW

         INTO :WKGWNT, :WKGWBT

         FROM AFLK

         LEFT JOIN DOMCOMV7/PPAKET2 AS PK1
         ON PK1.PKANR1 = 'K' || KLFIRM || DIGITS(KLKMJJ) || KLKMNR
         AND PK1.PKIDEN = ' '

         WHERE KLFIRM = :DAFIRM
         AND KLLIJJ = :WKAFLKLIJJ
         AND KLLINR = :WKAFLKLINR;

       EXEC SQL
         SELECT DISTINCT
         ORH330
         INTO :WKH330
         FROM AFKO

         LEFT JOIN TVRELWAECO/PWINORHS
         ON SUBSTR(AKREF1, 1, 7) = ORH040

         WHERE AKFIRM = :DAFIRM
         AND AKAFJJ = :WKAFJJ
         AND AKAFNR = :WKAFNR;

         %SUBST(RTTRNDDATE:1:30) = WKREF2;
         %SUBST(RTTRNDDATE:31:15) = WKD235;
         %SUBST(RTTRNDDATE:46:15) = %EDITC(WKGWNT:'X');
         %SUBST(RTTRNDDATE:61:15) = %EDITC(WKGWBT:'X');
         %SUBST(RTTRNDDATE:76:20) = WKH330;
         %SUBST(RTTRNDDATE:96:15) = WKD236;
         %SUBST(RTTRNDDATE:111:10) = WKMAAF;
       ENDSR;
      /END-FREE
     C**************************************************************************
     C***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHAFVS
     C/COPY QCPYSRC,CHSPDP
     C/COPY QCPYSRC,CHTRUR
     C/COPY QCPYSRC,CHVSBD
     C/COPY QCPYSRC,VRMVMONMSG
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
