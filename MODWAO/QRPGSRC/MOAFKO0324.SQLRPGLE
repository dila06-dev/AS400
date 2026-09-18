     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2009')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen
     H**************************************************************************
     H*  Copyright 2009 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 11.11.2010 WAECO Projekt 6683
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 22.11.2010 WAECO Projekt 6943- Prüfungen Zoll-Rechnung
     H*  Änderung: ZG 23.12.2010 WAECO Projekt 6990- Umsetzung AKKMAT wegen AFAT 28
     H*            Tabelle $$WAOKMAT
     H*  Änderung: ZG 12.01.2011 WAECO Komm-Sperre abhängig von KUND.KDKOSP (HB/ZG)
     H*  Änderung: RE 07.03.2013 DOMETIC Projekt 9380
     H*            Anzeige der Stammtext für Kunden-Nr
     H*  Änderung: PH 19.03.2014 DOMETIC Projekt 9441. Direkte Eingabe eines Textbausteins für den
     H*            Kopf- und Schlußtext innerhalb der Auftragsverwaltung bzw. Auftragserfassung
     H*  Änderung: MG 02.05.2014 WAECO Projekt 10210
     H*            Prüfen Versandbedingung IC-Abwicklung (Fa.WAECO)
     H*  Änderung: ZG 07.09.2017 Dometic Besuch
     H*            Kopieren Kunden-Texte
     H*  Änderung: ZG 12.01.2018 Dometic Projekt 10722
     H*            Stammtexte beim Kunden in Auftrag übernehmen TXVS und TXSP
     H*  Änderung: ZG 14.02.2018 Dometic Projekt 10722
     H*            Service#: 20180214-008 Übertragen Texte für alle Mandanten
     H*  Änderung: PH 06.08.2018 DOMETIC Projekt 12872-04. Prüfung für den Mandanten '01' und die
     H*            übergebene KD-Auftragsart auf offene Masteraufträge mit der Art '45' und
     H*            Status < '90' für die Kundenkonditions-Nr der übergebenen Kunden-Nr
     H*  Änderung: PH 11.06.2019 DOMETIC Projekt 14921-01. Neuer PGM-Status 'ERMWCD' für die
     H*            Ermittlung und Rückgabe des MwSt-Codes abhängig vom Mandanten und KD-Af-Art.
     H*  Änderung: PH 12.06.2019 DOMETIC Projekt 14921-01. E-Mail von IK vpm 12.06.2019. Korrektur:
     H*            Vertauschen MWCD für AFAT = 'D55' und Mandanten '01' und '61' ('38' für FIRM =
     H*            '01' und '39' für FIRM = '61' statt umgekehrt wie ursprünglich im Projekt)
     H*  Änderung: GS 06.11.2019 Projekt 15205 Entfernen der MWCD-Vorbelegung für Firma 01/AFAT I55
     H*  Änderung: PH 23.09.2020 DOMETIC Projekt 15986-04. Prüfung des Versanlandes
     H*            gegen den Absatzmarkt (PRVLAM)
     H*  Änderung: PH 08.10.2020 DOMETIC Projekt 15986-04. E-Mail von IK vom 06.10.2020:
     H*            Prüfung des Versandlandes gegen ADVS/ADAG-Land statt gegen Stammland
     H*  Änderung: PH 23.11.2020 DOMETIC Projekt 15986-18. Bei der Prüfung des Versandlandes
     H*            auf den Absatzmarkt KEINE Hinweismeldung senden, sondern, den Absatzmarkt
     H*            mit 'I' vorbelegen.
     H*  Änderung: MG 20.05.2021 DOMETIC Service 20210519-015 Korrektur Vorbelegung AKMWCD
     H*  Änderung: PH 15.10.2021 DOMETIC Projekt 16928-01. Löschen Bewegungstexte der Arten 'TXSP'
     H*            und 'TXVS' zum KD-Produktionsauftrag, sofern diese die Lieferbedingung '047',
     H*            '074' oder '026' (Aufruf aus TRAFKN beim Abschluss des KD-Produktiosnauftrags).
     H*  Änderung: PH 21.10.2021 DOMETIC Projekt 16928-01. E.Mail von IK vom 21.10.2021: Beim
     H*            Löschen der 'TXSP'/'TXVS'-KD-Auftragsbewegungstexte AKVSBD statt AKLIBD abfragen.
     H*  Änderung: ZG 27.10.2021 DOMETIC Projekt 16834-02
     H*            Ermittlung der Steuercodes abhängig von den Auftragsarten "82", "83"
     H*            "EU" (Ländergruppe "0001") ,  "Inland" (Land "004") sowie Export>
     H*            Ländergruppe  <> 0001
     H*            Fixer Update des MWST-Codes im Auftragskopf
     H*  Änderung: ZG 28.06.2023 DOMETIC Projekt 230302-01 Igloo-Steuerermittlung
     H*            Versandland IT für AFAT 54I
     H*  Änderung: GS 27.03.2023 DOMETIC Projekt 230302-01 Erweiterung gemäß IK
     H*            Versandland IT für auf für AFAT I54
     F**************************************************************************
     F*
     F*  Programm für die kundenspezifischen Prüfungen und Ermittlungen
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FMOAFKOFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ

     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KDKR          E DS                  INZ
     D KYKDKR        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTXBE        E DS                  INZ
     D EXTXST        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXAKPS        E DS                  INZ
     D RTAKPS        E DS                  INZ
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
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
      //*************************************************************************
      //**  Einzelfelder                                                      ***
      //*************************************************************************
     D WKSTMT          S           1000    INZ VARYING
     D SUM_IND1        S              5I 0 INZ
     D SUM_IND2        S              5I 0 INZ

      //************************************************************************
      //**  Externe Call-Prozeduren
      //************************************************************************
      //--------------------------------------------------
      // Program name: C_TRTXBE
      // Purpose:              Verwalten Bewegungstexte
      // Returns:
      // Parameter:      #EXTR02
      // Parameter:      #EXTXBE
      //--------------------------------------------------
     D C_TRTXBE...
     D                 PR                  EXTPGM('TRTXBE')
     D  #EXTR02                            LIKEDS(EXTR02)
     D  #EXTXBE                            LIKEDS(EXTXBE)

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
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRGSKZ'
     C                   MOVEL(P)  WKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVEL(P)  KDEWKDKR      KYKDKRKDKR
     C                   MOVEL(P)  *LOVAL        KYKDKRKDNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKDKR
     C*
     C     CHI(05)       IFEQ      'N'
     C     KDKRFIRM      ORNE      KYKDKRFIRM
     C     KDKRKDKR      ORNE      KYKDKRKDKR
     C                   CLEAR                   KDKR
     C                   ENDIF
     C*
     C     KDEWGSKZ      IFEQ      *ON
     C     WKKDNR        ANDNE     KDKRKDNR
     C                   MOVEL     '01'          WKIFMT
     C                   ELSE
     C                   MOVEL     '00'          WKIFMT
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSBD'
     C     WKTRPAFIRM    ANDEQ     *BLANK
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSBD'
     C     WKAFPOGNPA    ANDEQ     *OFF
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSBD'
     C                   EVAL      KYTPFI      = WKTRPAFIRM
     C                   EVAL      KYTPSP      = WKTRPASPCD
     C                   EVAL      KYTPTA      = 'VSBD'
     C                   EVAL      KYTPTC      = WKVSBD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C                   IF        CHI(5)      = 'N'
     C                   EVAL      RTTRNDFENR = '0977'
     C                   EVAL      RTTRNDPA03 = WKVSBD
     C                   EVAL      RTTRNDPA04 = WKTRPAFIRM
     C                   ENDIF
     C*
     C                   EVAL      KYTPFI      = DAFIRM
     C                   EVAL      KYTPSP      = DASPCD
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRZOLL'
     C                   MOVEL(P)  WKKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   SELECT
     C     DAPROG        WHENNE    'WAO014DR'
     C*
     C     WKFENR        WHENNE    *ZERO
     C                   MOVEL     '0910'        RTTRNDFENR
     C     KDEWZOTN      WHENNE    DAJNKZ
     C     KDEWZPUR      ANDNE     DAJNKZ
     C                   MOVEL     '0910'        RTTRNDFENR
     C                   ENDSL
     C*
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERKMAT'
     C*
     C                   MOVEL(P)  '$$WAOKMAT'   KYTPTA                         Sammel-Aufträge
     C                   MOVEL(P)  WKAFAT        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C                   IF        WKFENR = *ZERO
     C                   MOVEL     '$$WAOKMAT'   KYTKTA                         DEFAULT-WERT
     C                   MOVEA     '01C     '    CHI                            Komm-ART
     C                   EXSR      CHTRTK
     C                   EVAL      RTTRNDDATE = TKTDFT
     C                   ELSE
     C                   EVAL      RTTRNDDATE = EXTRNDDATE
     C                   ENDIF
     C*
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UPKOSP'                                    Sperren Export
     C*
     C                   MOVEL     WKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   MOVEL(P)  '$$WAOKOSP'   KYTPTA                        Tabelle mit den
     C                   MOVEL(P)  WKAFAT        KYTPTC                        Auftragsarten
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C                   IF        WKFENR = *ZERO                               Export mit Sperre
     C*
     C                   MOVEL(P)  EXTRNDDATE    AFKO
     C*
     C                   IF        AKKOSP=DANEKZ  AND KDKOSP=DAJNKZ             Sperren
     C*
     C                   Z-ADD     AKAFJJ        KYAKJH
     C                   MOVEL(P)  AKAFNR        KYAKAF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL     DAJNAM        AKJNAM
     C                   MOVEL     WKCHPN        AKPROG
     C                   MOVEL     WKCHPL        AKBIBL
     C                   MOVEL     DAUSER        AKUSER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        AKJZEI
     C                   MOVE      WKTDAT        AKJDAT
     C*
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEL     DAJNKZ        AKKOSP
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFKO
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'FRKOSP'                                    Sperren Export
     C*
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHAFKO
     C     CHI(5)        IFEQ      'L'
     C                   MOVEL     '0001'        RTTRNDFENR
     C*                  LEAVESR
     C                   ENDIF
     C*
     C                   Z-ADD     AKAFJJ        KYAKJH
     C                   MOVEL(P)  AKAFNR        KYAKAF
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL     DAJNAM        AKJNAM
     C                   MOVEL     WKCHPN        AKPROG
     C                   MOVEL     WKCHPL        AKBIBL
     C                   MOVEL     DAUSER        AKUSER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        AKJZEI
     C                   MOVE      WKTDAT        AKJDAT
     C*
     C                   SELECT
     C     CHI(6)        WHENEQ    *ON
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEL     *BLANK        AKKOSP
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFKO
     C                   ENDSL
     C*                  ENDIF
     C*                  ENDIF
     C*
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'GNAKPS'
     C                   CLEAR                   EXAKPS
     C                   EVAL      EXAKPSPGST = 'GNAKPS'
     C                   EVAL      EXAKPSAFJJ = KYAKJH
     C                   EVAL      EXAKPSAFNR = KYAKAF
     C                   EVAL      EXAKPSAFST = '91'
     C                   CALL      'TRAKPS'
     C                   PARM                    EXAKPS
     C                   PARM                    RTAKPS
     C*
     C                   CLEAR                   EXAKPS
     C                   EVAL      EXAKPSPGST = 'GNAKPS'
     C                   EVAL      EXAKPSAFJJ = KYAKJH
     C                   EVAL      EXAKPSAFNR = KYAKAF
     C                   EVAL      EXAKPSAFST = '95'
     C                   CALL      'TRAKPS'
     C                   PARM                    EXAKPS
     C                   PARM                    RTAKPS
     C*
     C                   CLEAR                   EXAKPS
     C                   EVAL      EXAKPSPGST = 'GNAKPS'
     C                   EVAL      EXAKPSAFJJ = KYAKJH
     C                   EVAL      EXAKPSAFNR = KYAKAF
     C                   EVAL      EXAKPSAFST = '97'
     C                   CALL      'TRAKPS'
     C                   PARM                    EXAKPS
     C                   PARM                    RTAKPS
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERTXST'
     C                   MOVEL     '02'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'KTXBE '
     C                   EXSR      KTXBE
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LTXBE '
     C                   EXSR      LTXBE
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   WHEN      PCPGST = 'PRMAST'
     C                   EXSR      PRMAST
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   WHEN      PCPGST = 'ERMWCD'
     C                   EXSR      ERMWCD
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   WHEN      PCPGST = 'PRVLAM'
     C                   EXSR      PRVLAM
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   WHEN      PCPGST = 'UPMWCD'
     C                   EXSR      UPMWCD
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   WHEN      PCPGST = 'EAVSLD'
     C                   EXSR      EAVSLD
     C                   MOVEL     '00'          WKIFMT
     C*--------------------------------------------------------
     C                   ENDSL
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      MOAFKOFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C                   CLOSE     MOAFKOFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
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
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKPROG
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKBIBL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYADFI                         AFAD
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDKRFIRM                     KDKR
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTKFI                         TRTK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTKSP                         TRTK
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOAFKOFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXTREND                        ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM

     C                   SELECT

     C                   WHEN      PCPGST = 'ERTXST' OR PCPGST = 'KTXBE '
     C                             OR PCPGST = 'LTXBE '
     C                   MONITOR
     C                   EVAL      KYAKJH  = %INT(%SUBST(EXTRNDKEYB:01:04))
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      KYAKJH  = *ZERO
     C                   ENDMON
     C                   EVAL      KYAKAF  = %SUBST(EXTRNDKEYB:05:06)

     C                   WHEN      PCPGST = 'PRVSBD'
     C                   EVAL      KYAPJH  = %INT(%SUBST(EXTRNDKEYB:01:04))
     C                   EVAL      KYAPAF  = %SUBST(EXTRNDKEYB:05:06)
     C                   EXSR      PRAFPOGNPA
     C                   MOVEA     KOM(11)       WKVSBD

     C                   WHEN      PCPGST = 'ERMWCD'
     C                   EVAL      ##TRNDFIRM  = %SUBST(EXTRNDKEYB:01)
     C                   EVAL      WKAFAT  = %SUBST(EXTRNDKEYB:03)
     C                   EVAL      WKMWCD  = %SUBST(EXTRNDKEYB:06)

     C                   WHEN      PCPGST = 'EAVSLD'
     C                   EVAL      ##TRNDFIRM  = %SUBST(EXTRNDKEYB:01)
     C                   EVAL      WKAFAT  = %SUBST(EXTRNDKEYB:03)
     C                   EVAL      WKVSLD  = %SUBST(EXTRNDKEYB:06)

     C                   WHEN      PCPGST = 'PRVLAM'

     C                   MONITOR
     C                   EVAL      KYADJH = %INT(%SUBST(EXTRNDKEYB:01:04))
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      KYADJH = *ZERO
     C                   EXSR      RMVMONMSG
     C                   ENDMON
     C                   EVAL      KYADAF = %SUBST(EXTRNDKEYB:05)
     C                   EVAL      ##TRNDVSLD = %SUBST(EXTRNDKEYB:11)
     C                   EVAL      ##TRNDABMA = %SUBST(EXTRNDKEYB:14)

     C                   WHEN      PCPGST = 'UPMWCD'

     C                   MONITOR
     C                   EVAL      KYAKJH = %INT(%SUBST(EXTRNDKEYB:01:04))
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      KYAKJH = *ZERO
     C                   EXSR      RMVMONMSG
     C                   ENDMON
     C                   EVAL      KYAKAF = %SUBST(EXTRNDKEYB:05)

     C                   OTHER
     C                   MOVEA     KOM(01)       WKKDNR
     C                   MOVEA     KOM(11)       WKAFAT

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
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
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
     C                   MOVEL(P)  'MOAFKO'      EXTRDNDANA
     C                   IF        PCPGST = 'ERTXST'
     C                   MOVEL(P)  'TXBAUS'      EXTRDNDANA
     C                   ENDIF
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*
     C                   MOVEA(P)  W99(32)       WNKOPF
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
     C                   EXSR      EFLPO
     C                   WRITE     MOAFKOW2
     C                   WRITE     MOAFKO01
     C                   WRITE     W2AFKOB1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MOAFKO01                             9899
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
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      RTTRNDDATE = DSKDEWGSKZ + DSKDKRKDNR
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      EXTTPGCD
     C                   MOVEL     'TRAFKO01'    EXTTDSPF
     C                   MOVEL(P)  DAJNKZ        EXTTVHKZ                       VOR DEM FORMAT
     C                   EXSR      TRAUFRTX50
     C*-------------------------------------------------------------------------
     C                   EXSR      RFMTS
     C*-------------------------------------------------------------------------
     C                   ENDDO
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEWKDKR      KYKDKRKDKR
     C                   MOVEL(P)  *LOVAL        KYKDKRKDNR
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHKDKR
     C*
     C     CHI(05)       IFEQ      'N'
     C     KDKRFIRM      ORNE      KYKDKRFIRM
     C     KDKRKDKR      ORNE      KYKDKRKDKR
     C                   CLEAR                   KDKR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDEWKDNR      DSKDEWKDNR
     C                   MOVEL(P)  KDEWGSKZ      DSKDEWGSKZ
     C                   MOVEL(P)  KDEWKDKR      DSKDEWKDKR
     C                   MOVEL(P)  KDKRKDNR      DSKDKRKDNR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSKUNDKNAM
     C                   MOVE      *BLANK        DSKDKRKNAM                     INITIALISIEREN
     C                   MOVE      *BLANK        TXKDEWGSKZ                     TEXTFELDER
     C                   MOVE      *BLANK        TXKDEWKDKR
     C*-------------------------------------------------------------------------
     C     DSKDEWKDNR    CASNE     *BLANK        PRKDEWKDNR                     FÜLLEN
     C                   ENDCS                                                  TEXTFELDER
     C     DSKDEWGSKZ    CASNE     *BLANK        PRKDEWGSKZ
     C                   ENDCS
     C     DSKDEWKDKR    CASNE     *BLANK        PRKDEWKDKR
     C                   ENDCS
     C     DSKDKRKDNR    CASNE     *BLANK        PRKDKRKDNR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKDEWGSKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKDKRKDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD02                                              ***
     C**************************************************************************
     C     BILD02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B02DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '02'
     C                   EXSR      EFLPO
     C                   WRITE     MOAFKOW1
     C                   WRITE     MOAFKO02
     C                   WRITE     W1AFKOB1
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      MOAFKO02                             9899
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
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   EXSR      RFMTS
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      B02UP
     C*-------------------------------------------------------------------------
     C                   EXSR      RFMTS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 02                                        ***
     C**************************************************************************
     C     B02DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   EVAL      DSTXSTKOUC = *BLANK
     C                   EVAL      DSTXSTSCUC = *BLANK
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  'DSTXSTKOUC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD02                                          ***
     C**************************************************************************
     C     B02PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTXSTKOUC
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRTXSTSCUC
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C** TEXTBAUSTEINE FÜR KOPF UND SCHLUSS IN DIE KD-AF-TEXTE (TXBE) KOPIEREN**
     C**************************************************************************
     C     B02UP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        DSTXSTKOUC <> *BLANK
     C                   EVAL      EXTTPGCD = 'KTXBE '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTKOUC
     C                   EVAL      EXTTTBTCDE = 'TXKO'
     C                   EVAL      EXTTDR01 = WKTXKODRK1
     C                   EVAL      EXTTDR02 = WKTXKODRK2
     C                   EVAL      EXTTDR03 = WKTXKODRK3
     C                   EVAL      EXTTDR04 = WKTXKODRK4
     C                   EVAL      EXTTDR05 = WKTXKODRK5
     C                   EVAL      EXTTDR06 = WKTXKODRK6
     C                   EVAL      EXTTDR07 = WKTXKODRK7
     C                   EVAL      EXTTDR08 = WKTXKODRK8
     C                   EVAL      EXTTDR09 = WKTXKODRK9
     C                   EXSR      MCAUFRTXST
     C                   ENDIF
     C*
     C                   IF        DSTXSTSCUC <> *BLANK
     C                   EVAL      EXTTPGCD = 'KTXBE '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTSCUC
     C                   EVAL      EXTTTBTCDE = 'TXSC'
     C                   EVAL      EXTTDR01 = WKTXSCDRK1
     C                   EVAL      EXTTDR02 = WKTXSCDRK2
     C                   EVAL      EXTTDR03 = WKTXSCDRK3
     C                   EVAL      EXTTDR04 = WKTXSCDRK4
     C                   EVAL      EXTTDR05 = WKTXSCDRK5
     C                   EVAL      EXTTDR06 = WKTXSCDRK6
     C                   EVAL      EXTTDR07 = WKTXSCDRK7
     C                   EVAL      EXTTDR08 = WKTXSCDRK8
     C                   EVAL      EXTTDR09 = WKTXSCDRK9
     C                   EXSR      MCAUFRTXST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 FÜR ALLE BILDER                                  ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSKDEWGSKZ'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDEWGSKZ'
     C                   EXSR      MCKDEWGSKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKDKRKDNR'
     C                   EXSR      MCKDKRKDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTXSTKOUC'
     C                   EXSR      MCTXSTKOUC
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSTXSTSCUC'
     C                   EXSR      MCTXSTSCUC
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     PRKDEWKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKDEWKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL     KDKNAM        DSKUNDKNAM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE GSKZ                                                   ***
     C**************************************************************************
     C     MCKDEWGSKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*--------------------------------------------------------
     C     DSKDEWGSKZ    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXKDEWGSKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWGSKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSKDEWGSKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWGSKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GSKZ                                                   ***
     C**************************************************************************
     C     PRKDEWGSKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWGSKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BOOL'        EXTRPCPGGR
     C                   MOVEL(P)  DSKDEWGSKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXKDEWGSKZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDKR                                                   ***
     C**************************************************************************
     C     PRKDEWKDKR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDEWKDKR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDKR'        KYTPTA
     C                   MOVEL(P)  DSKDEWKDKR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXKDEWKDKR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     MCKDKRKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSKDKRKDNR'  EXFLPOFLDN
     C*----------------------------------------------------
     C                   MOVEA(P)  DSKDKRKDNR    KOM(01)
     C                   MOVE      '0526'        #CUEBE
     C                   MOVEL(P)  *BLANK        #CPGST
     C                   EXSR      MCKUND
     C*----------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  KDKDNR        DSKDKRKDNR
     C                   MOVEL     KDKNAM        DSKDKRKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GSKD                                                   ***
     C**************************************************************************
     C     PRKDKRKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKDKRKDNR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKDKRKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   MOVEL     KDKNAM        DSKDKRKNAM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KOUC                                                   ***
     C**************************************************************************
     C     MCTXSTKOUC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C                   EVAL      EXTTPGCD = 'F04   '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTKOUC
     C                   EXSR      MCAUFRTXST
     C*
     C                   IF        EXTTUCDE <> *BLANK
     C                   EVAL      WKTRTP = *ON
     C                   EVAL      DSTXSTKOUC = EXTTUCDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KOUC                                                   ***
     C**************************************************************************
     C     PRTXSTKOUC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTXSTKOUC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSTXSTKOUC <> *BLANK
     C                             OR DSTXSTSCUC = *BLANK
     C*
     C                   EVAL      EXTTPGCD = 'TEXT  '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTKOUC
     C                   EXSR      MCAUFRTXST
     C*
     C                   IF        EXTTTEXT = *BLANK
     C                   EVAL      WKFENR = '0031'
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE SCUC                                                   ***
     C**************************************************************************
     C     MCTXSTSCUC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*----------------------------------------------------
     C                   EVAL      EXTTPGCD = 'F04   '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTSCUC
     C                   EXSR      MCAUFRTXST
     C*
     C                   IF        EXTTUCDE <> *BLANK
     C                   EVAL      WKTRTP = *ON
     C                   EVAL      DSTXSTSCUC = EXTTUCDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE SCUC                                                   ***
     C**************************************************************************
     C     PRTXSTSCUC    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSTXSTSCUC'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   IF        DSTXSTSCUC <> *BLANK
     C*
     C                   EVAL      EXTTPGCD = 'TEXT  '
     C                   EVAL      EXTTDSPF = *BLANK
     C                   EVAL      EXTTUCDE = DSTXSTSCUC
     C                   EXSR      MCAUFRTXST
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN AUFTRAGSPOSITIONEN                                         ***
     C**************************************************************************
     C     PRAFPOGNPA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKAFPOGNPA  = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAPPO      = *LOVAL
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     APFIRM        ANDEQ     KYAPFI
     C     APAFJJ        ANDEQ     KYAPJH
     C     APAFNR        ANDEQ     KYAPAF
     C*----------------------------------------------------------
     C     APGNPA        IFEQ      DAJNKZ
     C                   MOVE      *ON           WKAFPOGNPA
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TXST                                                   ***
     C**************************************************************************
     C     MCAUFRTXST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C     *LIKE         DEFINE    EXTTUCDE      SAVUCDE
     C     *LIKE         DEFINE    EXTTTBTCDE    SAVTBTCDE
     C     *LIKE         DEFINE    EXTTDR01      SAVDR01
     C     *LIKE         DEFINE    EXTTDR02      SAVDR02
     C     *LIKE         DEFINE    EXTTDR03      SAVDR03
     C     *LIKE         DEFINE    EXTTDR04      SAVDR04
     C     *LIKE         DEFINE    EXTTDR05      SAVDR05
     C     *LIKE         DEFINE    EXTTDR06      SAVDR06
     C     *LIKE         DEFINE    EXTTDR07      SAVDR07
     C     *LIKE         DEFINE    EXTTDR08      SAVDR08
     C     *LIKE         DEFINE    EXTTDR09      SAVDR09
     C*-------------------------------------------------------------------------
     C                   EVAL      WKFENR = *ZERO
     C*-------------------------------------------------------------------------
     C                   EVAL      SAVPGST = EXTTPGCD
     C                   EVAL      SAVDSPF = EXTTDSPF
     C                   EVAL      SAVUCDE = EXTTUCDE
     C                   EVAL      SAVTBTCDE = EXTTTBTCDE
     C                   EVAL      SAVDR01 = EXTTDR01
     C                   EVAL      SAVDR02 = EXTTDR02
     C                   EVAL      SAVDR03 = EXTTDR03
     C                   EVAL      SAVDR04 = EXTTDR04
     C                   EVAL      SAVDR05 = EXTTDR05
     C                   EVAL      SAVDR06 = EXTTDR06
     C                   EVAL      SAVDR07 = EXTTDR07
     C                   EVAL      SAVDR08 = EXTTDR08
     C                   EVAL      SAVDR09 = EXTTDR09
     C                   CLEAR                   EXTXST
     C                   EVAL      EXTTPGCD = SAVPGST
     C                   EVAL      EXTTTCDE = 'TRTXA9'
     C                   EVAL      EXTTPROG = 'MOAFKO'
     C                   EVAL      EXTTDSPF = SAVDSPF
     C                   EVAL      EXTTUCDE = SAVUCDE
     C                   EVAL      EXTTSPCD = KDSPCD
     C*
     C                   EVAL      EXTTTBTXAR = 'AFDA'
     C                   EVAL      EXTTTBJHJJ = AKAFJJ
     C                   EVAL      EXTTTBAFNR = AKAFNR
     C                   EVAL      EXTTTBTCDE = SAVTBTCDE
     C                   EVAL      EXTTTBUCDE = WKNEUAUCDE
     C                   EVAL      EXTTTBSPCD = KDSPCD
     C*
     C                   IF        EXTTPGCD = 'KTXBE '
     C                   EVAL      EXTTDR01 = SAVDR01
     C                   EVAL      EXTTDR02 = SAVDR02
     C                   EVAL      EXTTDR03 = SAVDR03
     C                   EVAL      EXTTDR04 = SAVDR04
     C                   EVAL      EXTTDR05 = SAVDR05
     C                   EVAL      EXTTDR06 = SAVDR06
     C                   EVAL      EXTTDR07 = SAVDR07
     C                   EVAL      EXTTDR08 = SAVDR08
     C                   EVAL      EXTTDR09 = SAVDR09
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KOM = *BLANK
     C                   EVAL      #CUEBE = '0010'
     C                   EVAL      #CPGST = '5     '
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRAUFRTX50   VERZWEIGEN IN TEXTVERWALTUNG                      ***
     C**************************************************************************
     C     TRAUFRTX50    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTTPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTTDSPF      SAVDSPF
     C     *LIKE         DEFINE    EXTTVHKZ      SAVVHKZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTTPGCD      SAVPGST
     C                   MOVEL     EXTTDSPF      SAVDSPF
     C                   MOVEL(P)  EXTTVHKZ      SAVVHKZ
     C                   CLEAR                   EXTXST
     C                   MOVEL     SAVPGST       EXTTPGCD
     C                   MOVEL     'TRTX02'      EXTTTCDE
     C                   MOVEL     DSKDEWKDNR    EXTTKDLI
     C                   MOVEL     'TRAFKO'      EXTTPROG
     C                   MOVEL     SAVDSPF       EXTTDSPF
     C                   MOVEL(P)  SAVVHKZ       EXTTVHKZ
     C                   MOVEL     KDSPCD        EXTTSPCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     '5     '      #CPGST
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
      /FREE
       //*************************************************************************
       //**  SR-KTXBE      KOPIEREN STAMM-TEXTE IN DIE BEWEGUNGSTEXTE          ***
       //*************************************************************************
       BEGSR KTXBE;

       CHIDS = '01C';
       EXSR CHAFKO;

       IF AKFIRM <> '01'
         AND AKFIRM <> '20';
       //LEAVESR;
       ENDIF;

       IF KDKDNR <> AKKDNR;
         KYKDNR = AKKDNR;
         CHIDS = '01C';
         EXSR CHKUND;
       ENDIF;

       WKTXKZ = DANEKZ;
       WKFENR = '0000';
       CLEAR EXTXBE;
       EXTBPGCD = 'PRUEFEN';
       EXTBDSPF = *BLANK;
       EXTBCALL = 'TRAB03';
       EXTBAUSW = 'AUAFKO';
       EXTBTXAR = 'AFDA';
       EXTBJHJJ = AKAFJJ;
       EXTBAFNR = AKAFNR;
       EXTBTCDE = 'TXSP';
       EXTBPROG = 'MOAFKO';
       KOM = *BLANK;
       #CUEBE = *BLANK;
       SAVPGST = #CPGST;
       #CPGST = *BLANK;
       EXSR TRTX55;
       KOMDS = #CKOMM;
       SELECT;
       WHEN EXTBPGCD = 'PRUEFEN'
         AND KOM(01) = *ON;
         WKTXKZ = DAJNKZ;
       ENDSL;
       #CPGST = SAVPGST;

       IF WKTXKZ <> DAJNKZ;

         WKFENR = '0000';
         EXTTPGCD = 'KTXBE  ';
         EXTTTCDE = 'TRTX02';
         EXTTKDLI = AKKDNR;
         EXTTPROG = 'MOAFKO';
         EXTTSPCD = KDSPCD;
         EXTTUCDE = 'TXSP';
         EXTTDSPF = *BLANK;
         EXTTTBTXAR = 'AFDA';
         EXTTTBJHJJ = AKAFJJ;
         EXTTTBAFNR = AKAFNR;
         EXTTTBTCDE = 'TXSP';
         EXTTTBUCDE = '1';
         EXTTTBSPCD = KDSPCD;
         EXTTDR01 = WKTXSPDRK1;
         EXTTDR02 = WKTXSPDRK2;
         EXTTDR03 = WKTXSPDRK3;
         EXTTDR04 = WKTXSPDRK4;
         EXTTDR05 = WKTXSPDRK5;
         KOM = *BLANK;
         SAVPGST = #CPGST;
         #CPGST = *BLANK;
         EXSR TRTX50;
         #CPGST = SAVPGST;

       ENDIF;

       WKTXKZ = DANEKZ;
       WKFENR = '0000';
       CLEAR EXTXBE;
       EXTBPGCD = 'PRUEFEN';
       EXTBDSPF = *BLANK;
       EXTBCALL = 'TRAB03';
       EXTBAUSW = 'AUAFKO';
       EXTBTXAR = 'AFDA';
       EXTBJHJJ = AKAFJJ;
       EXTBAFNR = AKAFNR;
       EXTBTCDE = 'TXVS';
       EXTBPROG = 'MOAFKO';
       KOM = *BLANK;
       #CUEBE = *BLANK;
       SAVPGST = #CPGST;
       #CPGST = *BLANK;
       EXSR TRTX55;
       KOMDS = #CKOMM;
       SELECT;
       WHEN EXTBPGCD = 'PRUEFEN'
         AND KOM(01) = *ON;
         WKTXKZ = DAJNKZ;
       ENDSL;
       #CPGST = SAVPGST;

       IF WKTXKZ <> DAJNKZ;

         WKFENR = '0000';
         EXTTPGCD = 'KTXBE  ';
         EXTTTCDE = 'TRTX02';
         EXTTKDLI = AKKDNR;
         EXTTPROG = 'MOAFKO';
         EXTTSPCD = KDSPCD;
         EXTTUCDE = 'TXVS';
         EXTTDSPF = *BLANK;
         EXTTTBTXAR = 'AFDA';
         EXTTTBJHJJ = AKAFJJ;
         EXTTTBAFNR = AKAFNR;
         EXTTTBTCDE = 'TXVS';
         EXTTTBUCDE = '1';
         EXTTTBSPCD = KDSPCD;
         EXTTDR01 = WKTXVSDRK1;
         EXTTDR02 = WKTXVSDRK2;
         EXTTDR03 = WKTXVSDRK3;
         EXTTDR04 = WKTXVSDRK4;
         EXTTDR05 = WKTXVSDRK5;
         KOM = *BLANK;
         SAVPGST = #CPGST;
         #CPGST = *BLANK;
         EXSR TRTX50;
         #CPGST = SAVPGST;

       ENDIF;

       ENDSR;

       //*************************************************************************
       //**  SR-LTXBE Löschen bestimmte Bewegungstexte zum KD-Auftrag          ***
       //*************************************************************************
       BEGSR LTXBE;

         CHIDS = '01C';
         EXSR CHAFKO;

         //IF AKLIBD = '047' OR AKLIBD = '074' OR AKLIBD = '026';
         IF AKVSBD = '047' OR AKVSBD = '074' OR AKVSBD = '026';
           // Löschen Texte Spedition
           CLEAR EXTXBE;
           %SUBST(#CKOMM:01) = 'AFDA';
           %SUBST(#CKOMM:11) = %EDITC(AKAFJJ:'X');
           %SUBST(#CKOMM:15) = AKAFNR;
           %SUBST(#CKOMM:29) = 'TXSP';     // Seit dem R20.0 ist das die Stelle 31 im KOM-Bereich
           #CPGST = '4     ';
           #CUEBE = *BLANK;
           C_TRTXBE(EXTR02:EXTXBE);

           // Löschen Texte Versand
           CLEAR EXTXBE;
           %SUBST(#CKOMM:01) = 'AFDA';
           %SUBST(#CKOMM:11) = %EDITC(AKAFJJ:'X');
           %SUBST(#CKOMM:15) = AKAFNR;
           %SUBST(#CKOMM:29) = 'TXVS';     // Seit dem R20.0 ist das die Stelle 31 im KOM-Bereich
           #CPGST = '4     ';
           #CUEBE = *BLANK;
           C_TRTXBE(EXTR02:EXTXBE);
         ENDIF;

       ENDSR;

       //*************************************************************************
       //**  SR-PRMAST  Prüfung auf offene Masteraufträge (mit der Art '45')   ***
       //*************************************************************************
       BEGSR PRMAST;

         IF DAFIRM <> '01'
           OR WKAFAT <> '01';
           LEAVESR;
         ENDIF;

         KYKDNR = WKKDNR;
         CHIDS = '01C';
         EXSR CHKUND;

         AKKOKD = KDKOKD;
         IF KDKOKD = *BLANK;
           AKKOKD = KDKDNR;
         ENDIF;

         WKSTMT = 'VALUES(SELECT AKAFJJ, AKAFNR FROM AFKO'
         + ' WHERE AKFIRM = ''' + DAFIRM + ''''
         + ' AND AKKDNR = ''' + AKKOKD + ''''
         + ' AND AKAFAT = ''45'''
         + ' AND AKAFST < ''90'''
         + ' ORDER BY AKFIRM, AKAFJJ DESC, AKAFNN DESC'
         + ' FETCH FIRST 1 ROWS ONLY) INTO ?, ?';

         CLEAR AFKO;

         EXEC SQL PREPARE SQSTMT FROM :WKSTMT;

         EXEC SQL EXECUTE SQSTMT USING :AKAFJJ :SUM_IND1, :AKAFNR :SUM_IND2;

         IF SUM_IND1 < *ZERO
           OR SUM_IND2 < *ZERO;
           LEAVESR;
         ENDIF;

         RTTRNDFENR = '0344'; // Offener Masterauftrag &3&4 vorhanden
         DUC020 =  %EDITC(AKAFJJ:'X') + '/' + AKAFNR;
         RTTRNDPA03 = %SUBST(DUC020:01:10);
         RTTRNDPA04 = %SUBST(DUC020:11:10);
         RTTRNDDATE = '#MO';  // Nachrichten-Art

       ENDSR;

       //*************************************************************************
       //**  SR-ERMWCD  Ermitteln MwSt-Code                                    ***
       //*************************************************************************
       BEGSR ERMWCD;

         SELECT;
         WHEN ##TRNDFIRM = '01' AND WKAFAT = 'D55';
           RTTRNDDATE = '38';
         WHEN ##TRNDFIRM = '61' AND WKAFAT = 'D55';
           RTTRNDDATE = '39';
         OTHER ;
           RTTRNDDATE = WKMWCD;
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  SR-EAVSLD  Ermitteln Versandland für Italien                      ***
       //*************************************************************************
       BEGSR EAVSLD;

         SELECT;
         WHEN ##TRNDFIRM = '01' AND (WKAFAT = '54I' or WKAFAT = 'I54');
           RTTRNDDATE = '005';
         OTHER ;
           RTTRNDDATE = WKVSLD;
         ENDSL;

       ENDSR;

       //*************************************************************************
       //**  SR-PRVLAM  Prüfen Versandland gegen Absatzmarkt                   ***
       //*************************************************************************
       BEGSR PRVLAM;

         KYADPO = *ZERO;
         KYADAA = 'ADVS';
         CHIDS = '01C';
         EXSR CHAFAD;
         IF CHI(5) = 'N';
           KYADAA = 'ADAG';
           CHIDS = '01C';
           EXSR CHAFAD;
         ENDIF;

         IF CHI(5) = 'N' OR ADLAND = *BLANK
           OR ##TRNDVSLD <> ADLAND
           OR ##TRNDABMA <> 'E' AND ##TRNDABMA <> 'G';
           LEAVESR;
         ENDIF;

         // Absatzmarkt sollte für die Kontierung auf "I" gesetzt werden
         //RTTRNDFENR = '0353';
         // Nachrichten-Art
         //RTTRNDDATE = '#MO';
         // Absatz-Markt
         RTTRNDDATE = 'I';

       ENDSR;

       //*************************************************************************
       //**  SR-UPMWCD  Update    MwSt-Code                                    ***
       //*************************************************************************
       BEGSR UPMWCD;

         AFKO = EXTRNDDATE;

         if (AKAFAT <> '82 ' and  AKAFAT <> '83 ')
           or AKMWCD <> *BLANK or AKFIRM <> '01';
           RTTRNDDATE = AKMWCD;
           LEAVESR;
         endif;

            // Prüfen Landgruppe Versandland
         if AKVSLD <> *BLANK;
           KYLNNR = AKVSLD;
         else;
           KYLNNR = EXFIRMLDNR;
        endif;
        CHIDS  = '01C';
        EXSR CHLAND;
        IF LNLDGR <> '0001';
          RTTRNDDATE = AKMWCD;
          LEAVESR;
        ENDIF;

        KYADJH = KYAKJH;
        KYADAF = KYAKAF;
        KYADPO = *ZERO;
        KYADAA = 'ADVS';
        CHIDS = '01C';
        EXSR CHAFAD;
        IF CHI(5) = 'N';
          KYADAA = 'ADAG';
          CHIDS = '01C';
          EXSR CHAFAD;
        ENDIF;

        IF CHI(5) = 'N' OR ADLAND = *BLANK;
          RTTRNDDATE = AKMWCD;
          LEAVESR;
        ENDIF;

        if KYLNNR <> ADLAND;
          KYLNNR = ADLAND;
          CHIDS  = '01C';
          EXSR CHLAND;
        ENDIF;

        SELECT;
        WHEN AKVSLD = ADLAND;
          // Inland
          WKMWCD = WKTRPAMWCI;
        WHEN LNLDGR = '0001';
          WKMWCD = WKTRPAMWCU;
        WHEN LNLDGR <> '0001';
          WKMWCD = WKTRPAMWCE;
        ENDSL;

        CHIDS  = '01CU';
        EXSR CHAFKO;

        AKMWCD = WKMWCD;

        AKJNAM = DAJNAM;
        AKPROG = WKCHPN;
        AKBIBL = WKCHPL;
        AKUSER = DAUSER;
        AKJZEI = %DEC(%TIME());
        AKJDAT = %DEC(%DATE:*ISO);

        SELECT;
        WHEN CHI(6) = *ON;

        WHEN CHI(6) = *OFF;
          CHIDS  = '01U';
          EXSR CHAFKO;
        ENDSL;

          RTTRNDDATE = AKMWCD;

       ENDSR;

      /END-FREE
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
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
     C* Ermitteln Firmen-Nr für Streckengeschäft
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'LFNRKD'      KYTATC
     C                   MOVEL(P)  WKTRPALFNR    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   EVAL      WKTRPAKDNR  = %SUBST(TAPTXT:01:10)
     C                   EVAL      WKTRPAFIRM  = %SUBST(TAPTXT:14:02)
     C*
     C                   EVAL      EXFIRMFIRM  = WKTRPAFIRM
     C                   EXSR      PRFIRMFIRM
     C                   EVAL      WKTRPASPCD  = EXFIRMSPCD

                         // Ermitteln Stammland
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'LAND'        KYTATC
     C                   MOVEL(P)  'LAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASTLD
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTATA = 'FIRM'
     C                   EVAL      KYTATC = 'TRAB03'
     C                   EVAL      KYTAPA = 'UCDE  '
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKNEUAUCDE = TAPCDE
     C*
     C                   IF        WKNEUAUCDE = *BLANK
     C                   EVAL      KYTKFI = DAFIRM
     C                   EVAL      KYTKSP = DASPCD
     C                   EVAL      KYTKTA = 'TRAB03'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRTK
     C                   EVAL      WKNEUAUCDE = TKTDFT
     C                   ENDIF
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK1'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK1 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK2'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK2 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK3'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK3 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK4'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK4 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK5'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK5 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK6'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK6 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK7'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK7 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK8'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK8 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXKO'
     C                   EVAL      KYTAPA = 'DRK9'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXKODRK9 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK1'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK1 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK2'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK2 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK3'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK3 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK4'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK4 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK5'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK5 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK6'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK6 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK7'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK7 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK8'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK8 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSC'
     C                   EVAL      KYTAPA = 'DRK9'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSCDRK9 = TAPCDE
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSP'
     C                   EVAL      KYTAPA = 'DRK1'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSPDRK1 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSP'
     C                   EVAL      KYTAPA = 'DRK2'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSPDRK2 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSP'
     C                   EVAL      KYTAPA = 'DRK3'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSPDRK3 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSP'
     C                   EVAL      KYTAPA = 'DRK4'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSPDRK4 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXSP'
     C                   EVAL      KYTAPA = 'DRK5'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXSPDRK5 = TAPCDE
     C*-------------------------------------------------------------------------
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXVS'
     C                   EVAL      KYTAPA = 'DRK1'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXVSDRK1 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXVS'
     C                   EVAL      KYTAPA = 'DRK2'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXVSDRK2 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXVS'
     C                   EVAL      KYTAPA = 'DRK3'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXVSDRK3 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXVS'
     C                   EVAL      KYTAPA = 'DRK4'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXVSDRK4 = TAPCDE
     C*
     C                   EVAL      KYTATA = 'TRAB03'
     C                   EVAL      KYTATC = 'TXVS'
     C                   EVAL      KYTAPA = 'DRK5'
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTRPA
     C                   EVAL      WKTXVSDRK5 = TAPCDE
     C*-------------------------------------------------------------------------
     C* Ermitteln MWCD Inland
     C                   MOVEL(P)  'MOAFKO'      KYTATA
     C                   MOVEL(P)  'AFATMWCD'    KYTATC
     C                   MOVEL(P)  'INLAND'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMWCI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOAFKO'      KYTATA
     C                   MOVEL(P)  'AFATMWCD'    KYTATC
     C                   MOVEL(P)  'EU      '    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMWCU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOAFKO'      KYTATA
     C                   MOVEL(P)  'AFATMWCD'    KYTATC
     C                   MOVEL(P)  'EXPORT  '    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMWCE
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTXKZ
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPALFNR      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAKDNR      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPAFIRM      + 1
     C     *LIKE         DEFINE    WKC001        WKTRPASPCD      + 1
     C     *LIKE         DEFINE    WKC001        WKTRPASTLD      + 2
     C     *LIKE         DEFINE    WKC001        WKAFPOGNPA
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAPROG        WKPROG
     C     *LIKE         DEFINE    DABIBL        WKBIBL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    KDKDNR        WKKDNR
     C     *LIKE         DEFINE    AKAFAT        WKAFAT
     C     *LIKE         DEFINE    AKMWCD        WKMWCD
     C     *LIKE         DEFINE    AKVSBD        WKVSBD
     C     *LIKE         DEFINE    AKFIRM        ##TRNDFIRM
     C     *LIKE         DEFINE    AKVSLD        ##TRNDVSLD
     C     *LIKE         DEFINE    AKABMA        ##TRNDABMA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C     *LIKE         DEFINE    EXTTTBUCDE    WKNEUAUCDE
     C     *LIKE         DEFINE    EXTTDR01      WKTXKODRK1
     C     *LIKE         DEFINE    EXTTDR02      WKTXKODRK2
     C     *LIKE         DEFINE    EXTTDR03      WKTXKODRK3
     C     *LIKE         DEFINE    EXTTDR04      WKTXKODRK4
     C     *LIKE         DEFINE    EXTTDR05      WKTXKODRK5
     C     *LIKE         DEFINE    EXTTDR06      WKTXKODRK6
     C     *LIKE         DEFINE    EXTTDR07      WKTXKODRK7
     C     *LIKE         DEFINE    EXTTDR08      WKTXKODRK8
     C     *LIKE         DEFINE    EXTTDR09      WKTXKODRK9
     C     *LIKE         DEFINE    EXTTDR01      WKTXSCDRK1
     C     *LIKE         DEFINE    EXTTDR02      WKTXSCDRK2
     C     *LIKE         DEFINE    EXTTDR03      WKTXSCDRK3
     C     *LIKE         DEFINE    EXTTDR04      WKTXSCDRK4
     C     *LIKE         DEFINE    EXTTDR05      WKTXSCDRK5
     C     *LIKE         DEFINE    EXTTDR06      WKTXSCDRK6
     C     *LIKE         DEFINE    EXTTDR07      WKTXSCDRK7
     C     *LIKE         DEFINE    EXTTDR08      WKTXSCDRK8
     C     *LIKE         DEFINE    EXTTDR09      WKTXSCDRK9
     C     *LIKE         DEFINE    EXTBDRK1      WKTXSPDRK1
     C     *LIKE         DEFINE    EXTBDRK2      WKTXSPDRK2
     C     *LIKE         DEFINE    EXTBDRK3      WKTXSPDRK3
     C     *LIKE         DEFINE    EXTBDRK4      WKTXSPDRK4
     C     *LIKE         DEFINE    EXTBDRK5      WKTXSPDRK5
     C     *LIKE         DEFINE    EXTBDRK1      WKTXVSDRK1
     C     *LIKE         DEFINE    EXTBDRK2      WKTXVSDRK2
     C     *LIKE         DEFINE    EXTBDRK3      WKTXVSDRK3
     C     *LIKE         DEFINE    EXTBDRK4      WKTXVSDRK4
     C     *LIKE         DEFINE    EXTBDRK5      WKTXVSDRK5
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKMWCD        WKTRPAMWCI
     C     *LIKE         DEFINE    AKMWCD        WKTRPAMWCU
     C     *LIKE         DEFINE    AKMWCD        WKTRPAMWCE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKVSLD        WKVSLD
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
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOAFKO'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTAFKOW2
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTAFKOW1
     C                   OTHER
     C                   WRITE     MOAFKOCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '01'
     C                   WRITE     CTAFKOW2
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTAFKOW1
     C                   OTHER
     C                   WRITE     MOAFKOCT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *BLANK        W$PA08
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKDKR
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHTRTK
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRTX50
     C/COPY QCPYSRC,TRTX55
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,VRMVMONMSG
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
