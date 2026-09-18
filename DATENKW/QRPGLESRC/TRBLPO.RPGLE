     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Beleg-Position
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: mg 21.11.2003 gemäss Projekt-Nr 2085
     H*  -----------------------------------------------------------------------
     H*  Änderung: HR 13.05.2004 Standard
     H*  Änderung: mg 14.05.2004 gemäss Besprechung HR/SR
     H*            Das Feld BLPABLAT in BLPABLGA umbenennt
     H*            Das Feld BLKOBLAT in BLKOBLGA umbenennt
     H*  Änderung: mg 21.05.2004 gemäss Besprechung HR/SR
     H*            Ermitteln Wert, Menge, Gewicht aus zugeordnete Beleg-Position
     H*            Sperren der Felder Ident-Nr, Bezeichnung, Mengneinheit bei
     H*            Beleg-Zuordnung (Bestell-Pos., WE-Nr, Rücklieferung, ...)
     H*  Änderung: mg 02.07.2004 Konditions-Verteilung auf Positionsebene Ja/Nei
     H*  Änderung: HR 19.07.2004 Updateroutinen ABBLPO, UTEIL, ULBST, UBBEP, TRW
     H*  Änderung: GS 18.08.2004 Standard Prüfen auf den Parameterinhalt WKTRPAO
     H*            damit bei blank keine Prüfung erfolgt.
     H*  Änderung: X2 30.08.2004 Anpassung trend-Java-Client
     H*  Änderung: HR 29.09.2004 Korr. SR-EBLPOBWAE
     H*  Änderung: MG 26.10.2004 Umstellen der TRDN-Eintragungen von BLPO... nac
     H*  Änderung: MG 25.11.2004 Standard gemäss Anforderung HR
     H*            Bei Frachtkosten bzw. Zollrechnung erfolgt keine Prüfung,
     H*            ob der Wareneingang bereits berechnet wurde.
     H*  Änderung: MG 29.11.2004 Release-Freigabe 2004/V1
     H*            Initialisieren Textfelder in B04DS
     H*            Eindeutige Fehlermeldung STA-2549
     H*  Änderung: MG 10.12.2004 Release-Freigabe 2004/V1
     H*            Prüfen ob, Bestell-Position mehrfach im Beleg STA-2550
     H*  Änderung: HR 29.12.2004 Standard Verwalten MWST-Code auf Postionsebene
     H*  Änderung: HR 17.01.2005 Standard Konditionsverteilung mit Verteilung de
     H*            Rundungsdifferenz auf die letzte Position
     H*            BILD05 Übernahme Kondition in Belegposition
     H*  Änderung: MG 18.01.2005 gemäss Service-Nr 3073 Kunde BUSCH
     H*            Prüfen, ob WE-Lager = QS-Wareneingang STA-2321
     H*  Änderung: HR 20.01.2005 Fa. Eurocolor Projekt 3172 Berücksichtigung
     H*            Skonto und Fortschreibung im Inventurpreis FIRM/MODEUC/MODEUC
     H*            Standard: Parameter TRBLPO/SKONTO/TELBPN Berücksichtigen Skon
     H*            bei Berechnung des RP-Netto-Preises in UTEIL und ULBST
     H*  Änderung: HR 31.01.2005 Fa.Busch Korr. Prüfung PRBLPOBEPO für BWAE PRBL
     H*  Änderung: RE 25.02.2005 Standard
     H*            DANEKZ statt 'N'
     H*  Änderung: HR 10.03.2005 Fa.Weinmayr HL-3580 Berechnete Menge in BBEP
     H*  Änderung: HR 14.04.2005 Standard Abweichende Mengeneinheit eingebbar
     H*            Mengenprüfung in PRBLPOBWAE ausgesternt
     H*  Änderung: HR 21.04.2005 Mengenprüfung geändert in PRBLPOBWAE
     H*  Änderung: HR 13.05.2005 Fa. Riha HL-4241 Korrektur Löschen - Update
     H*            Bestellposition SR-SBBEP
     H*  Änderung: HR 30.05.2005 Fa. BFE Konditionsverteilung negativer Wert
     H*  Änderung: HR 30.05.2005 Fa. Waeco Projekt 3384 Wertverteilung mit
     H*            Zolltarifnummer
     H*  Änderung: GS 03.08.2006 Waeco/HB-Standard Cursor im BLPO01-Format auf P
     H*  Änderung: HR 22.11.2006 Waeco Korrektur PRBLPOVTWT
     H*  Änderung: HR 22.12.2006/ 27.07.2005 Fa. BFE Korr. ERBLPOBBEP Statusprüf
     H*  Änderung: HR 29.06.2006 Fa. Joma Berücksichtigung des Beistell-Material
     H*            beim Preis-Update im Identstamm
     F**************************************************************************
     F*
     F*  Dieses Programm verwaltet die Datei BLPO.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRBLPOFM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D KOND            S                   LIKE(BLKOKON1) DIM(4) INZ
     D KOWT            S                   LIKE(BLKOKOW1) DIM(4) INZ
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D*
     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ
     D*
     D BBUP          E DS                  INZ
     D KYBBUP        E DS                  INZ
     D*
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ
     D*
     D BLPO          E DS                  INZ
     D KYBLPO        E DS                  INZ
     D*
     D BLPA          E DS                  INZ
     D KYBLPA        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D BWPM          E DS                  INZ
     D KYBWPM        E DS                  INZ
     D*
     D BZUR          E DS                  INZ
     D KYBZUR        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D LBST          E DS                  INZ
     D KYLBST        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D MWST          E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D ZOTN          E DS                  INZ
     D KYZOTN        E DS                  INZ
     D*
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
     D EXTXBE        E DS                  INZ
     D EXWAUM        E DS                  INZ
     D*
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXKOND        E DS                  INZ
     D RTKOND        E DS                  INZ
     D*
     D EXBZUR        E DS                  INZ
     D RTBZUR        E DS                  INZ
     D*
     D EXBLPO        E DS
     D RTBLPO        E DS
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
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     D**************************************************************************
     D***  WORK-DATENSTRUKTUR  FÜR KOPIERFUNKTION                            ***
     D**************************************************************************
     D D$DAST          DS          2048
     D KYSAVE          DS          1024
     D D$DAST1         DS          2048
     D KYSAVE1         DS          1024
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXBLPO
     C                   PARM                    RTBLPO
     C*
     C                   EXSR      UEBBLPO
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   MOVE      *ON           C#WNDW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ENDE  '
     C*
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRBLPOFM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '3     '
     C                   MOVE      'K1'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'KBLPO '
     C                   EXSR      KBLPO
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BILD03'
     C                   MOVE      '03'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BILD04'
     C                   MOVE      '04'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BILD05'
     C                   MOVE      '05'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BILD06'
     C                   MOVE      '06'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'BWAE  '
     C     PCPGST        OREQ      'BZUR  '
     C     PCPGST        OREQ      'BBEP  '
     C     PCPGST        OREQ      'BLPO  '
     C                   MOVE      *BLANK        PCPGST
     C                   EXSR      B01DS
     C*
     C     EXBLPOPGST    IFEQ      'BWAE  '
     C                   EXSR      PRBLPOWENR
     C                   ELSE
     C                   EXSR      PRBLPOBEPO
     C                   ENDIF
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C                   ELSE
     C                   MOVE      '00'          WKIFMT
     C                   ENDIF
     C*
     C*                  MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PBLPO '
     C                   EXSR      PBLPO
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '4     '
     C                   EXSR      PBLPO
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      LBLPO
     C                   ENDIF
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ABBLPO'
     C                   EXSR      ABBLPO
     C*
     C                   MOVE      '00'          WKIFMT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERVTWT'
     C                   EXSR      ERVTWT
     C*
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
     C                   OPEN      TRBLPOFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     '02'          BILD02
     C     WKIFMT        CASEQ     '03'          BILD03
     C     WKIFMT        CASEQ     '04'          BILD04
     C     WKIFMT        CASEQ     '05'          BILD05
     C     WKIFMT        CASEQ     '06'          BILD06
     C     WKIFMT        CASEQ     'K1'          BILDK1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     WKIOKZ        ANDEQ     *ON
     C     PCPGST        OREQ      'MUSTER'
     C                   CLOSE     TRBLPOFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTBLPORTCD
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
     C                   Z-ADD     *ZERO         WKN219           21 9
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYEPFI
     C                   MOVE      DAFIRM        KYBUFI
     C                   MOVEL(P)  DAFIRM        KYPAFI
     C                   MOVEL(P)  DAFIRM        KYBLKOFIRM
     C                   MOVEL(P)  DAFIRM        KYBLPOFIRM
     C                   MOVEL(P)  DAFIRM        KYBLPAFIRM
     C                   MOVEL(P)  DAFIRM        KYAEFI
     C                   MOVEL(P)  DAFIRM        KYWPFI
     C                   MOVEL(P)  DAFIRM        KYBZFI
     C                   MOVEL(P)  DAFIRM        KYLFFI
     C                   MOVEL(P)  DAFIRM        KYLDFI
     C                   MOVEL(P)  DAFIRM        KYLTFI
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYTUFI
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   EXSR      VTRTPPDIM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRBLPOFM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPB
     C                   MOVEL(P)  'TRBLPOFM'    EXTRPBBPRG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER  EXBLPO                         ***
     C**************************************************************************
     C     UEBBLPO       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXBLPOPGST    PCPGST
     C*
     C                   Z-ADD     EXBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  EXBLPOBLNR    KYBLPOBLNR
     C                   Z-ADD     EXBLPOBLPO    KYBLPOBLPO
     C*
     C                   Z-ADD     EXBLPOBLJJ    DSBLPOBLJJ
     C                   MOVEL(P)  EXBLPOBLNR    DSBLPOBLNR
     C                   Z-ADD     EXBLPOBLPO    DSBLPOBLPO
     C*
     C                   Z-ADD     EXBLPONBLJ    DSBLPONBLJ
     C                   MOVEL(P)  EXBLPONBLN    DSBLPONBLN
     C                   Z-ADD     EXBLPONBLP    DSBLPONBLP
     C*
     C                   Z-ADD     EXBLPOUGWT    DSBLPOUGWT
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL     *ZERO         RTBLPOFENR
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
     C                   MOVE      *OFF          C#LCK2
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C                   MOVE      C#LCK2        WKIN32
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
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'BILD03'
     C                   MOVEL(P)  'TRBLPO03'    EXTRDNDANA
     C     PCPGST        WHENEQ    'BILD04'
     C                   MOVEL(P)  'TRBLPO04'    EXTRDNDANA
     C                   OTHER
     C                   MOVEL(P)  'TRBLPO'      EXTRDNDANA
     C                   ENDSL
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   EXSR      EBLKO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
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
     C                   WRITE     TRBLPO01
     C                   WRITE     TRBLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO01                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UBLPO
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      WKPGST
     C                   EXSR      TRTRDZ
     C*--------------------------------------------------------
     C                   MOVEL(P)  'DIREKT'      EXTBPGCD
     C                   MOVEL(P)  'TRBLPO01'    EXTBDSPF
     C                   EXSR      VTX55
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      *BLANK
     C     WKCFMT        OREQ      *ON
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   ELSE
     C                   MOVE      *ZERO         DSBLPOBLPO
     C                   EXSR      RFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHBLPO
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHBLPO
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
     C                   MOVE      WKIN32        C#LCK2
     C                   MOVE      *OFF          WKINF1
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    *BLANK
     C     PCPGST        OREQ      'MUSTER'
     C                   CLEAR                   BLPO
     C                   EXSR      ETRMU
     C     PCPGST        CASEQ     *BLANK        EBLPOBLPO
     C                   ENDCS
     C                   Z-ADD     KYBLPOBLJJ    BLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    BLPOBLNR
     C                   Z-ADD     KYBLPOBLPO    BLPOBLPO
     C                   MOVEL(P)  BLKOMWC1      BLPOMWCD
     C*
     C     EXBLPOWENR    CASNE     *BLANK        EBWAE
     C     EXBLPOBENR    CASNE     *BLANK        EBBEP
     C     EXBLPOZUNR    CASNE     *BLANK        EZUPO
     C                   ENDCS
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVEL(P)  BLPOUSER      WKUSER
     C                   Z-ADD     BLPOJDAT      WKJDAT
     C                   Z-ADD     BLPOJZEI      WKJZEI
     C*
     C     PCPGST        IFEQ      '2     '
     C                   MOVEA     '01CL    '    CHI
     C                   EXSR      CHBLPO
     C                   EXSR      EBLPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'L'
     C                   MOVE      'F     '      PCPGST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      DSBLPOBLJJ
     C                   MOVEL(P)  BLPOBLNR      DSBLPOBLNR
     C                   Z-ADD     BLPOBLPO      DSBLPOBLPO
     C                   MOVEL(P)  BLPOTENR      DSBLPOTENR
     C                   Z-ADD     BLPOMENG      DSBLPOMENG
     C                   MOVEL(P)  BLPOTBZ1      DSBLPOTBZ1
     C                   MOVEL(P)  BLPOTBZ2      DSBLPOTBZ2
     C                   MOVEL(P)  BLPOMEIN      DSBLPOMEIN
     C                   MOVEL(P)  BLPOMEPR      DSBLPOMEPR
     C                   MOVEL(P)  BLPOPRAR      DSBLPOPRAR
     C                   Z-ADD     BLPOPREI      DSBLPOPREI
     C                   MOVEL(P)  BLPOPDIM      DSBLPOPDIM
     C                   Z-ADD     BLPONESU      DSBLPONESU
     C                   MOVEL(P)  BLPOKON1      DSBLPOKON1
     C                   Z-ADD     BLPOKOW1      DSBLPOKOW1
     C                   MOVEL(P)  BLPOPRZ1      DSBLPOPRZ1
     C                   MOVEL(P)  BLPOPDI1      DSBLPOPDI1
     C                   MOVEL(P)  BLPOBAS1      DSBLPOBAS1
     C                   MOVEL(P)  BLPOKON2      DSBLPOKON2
     C                   Z-ADD     BLPOKOW2      DSBLPOKOW2
     C                   MOVEL(P)  BLPOPRZ2      DSBLPOPRZ2
     C                   MOVEL(P)  BLPOPDI2      DSBLPOPDI2
     C                   MOVEL(P)  BLPOBAS2      DSBLPOBAS2
     C                   MOVEL(P)  BLPOKON3      DSBLPOKON3
     C                   Z-ADD     BLPOKOW3      DSBLPOKOW3
     C                   MOVEL(P)  BLPOPRZ3      DSBLPOPRZ3
     C                   MOVEL(P)  BLPOPDI3      DSBLPOPDI3
     C                   MOVEL(P)  BLPOBAS3      DSBLPOBAS3
     C                   MOVEL(P)  BLPOKON4      DSBLPOKON4
     C                   Z-ADD     BLPOKOW4      DSBLPOKOW4
     C                   MOVEL(P)  BLPOPRZ4      DSBLPOPRZ4
     C                   MOVEL(P)  BLPOPDI4      DSBLPOPDI4
     C                   MOVEL(P)  BLPOBAS4      DSBLPOBAS4
     C                   MOVEL(P)  BLPOKON5      DSBLPOKON5
     C                   Z-ADD     BLPOKOW5      DSBLPOKOW5
     C                   MOVEL(P)  BLPOPRZ5      DSBLPOPRZ5
     C                   MOVEL(P)  BLPOPDI5      DSBLPOPDI5
     C                   MOVEL(P)  BLPOBAS5      DSBLPOBAS5
     C                   MOVEL(P)  BLPOKSST      DSBLPOKSST
     C                   MOVEL(P)  BLPOWBKT      DSBLPOWBKT
     C                   MOVEL(P)  BLPOKOTR      DSBLPOKOTR
     C                   Z-ADD     BLPOBEJJ      DSBLPOBEJJ
     C                   MOVEL(P)  BLPOBENR      DSBLPOBENR
     C                   Z-ADD     BLPOBEPO      DSBLPOBEPO
     C                   Z-ADD     BLPOWEJJ      DSBLPOWEJJ
     C                   MOVEL(P)  BLPOWENR      DSBLPOWENR
     C                   Z-ADD     BLPOUPOS      DSBLPOUPOS
     C                   Z-ADD     BLPOZUJJ      DSBLPOZUJJ
     C                   MOVEL(P)  BLPOZUNR      DSBLPOZUNR
     C                   Z-ADD     BLPOZUPO      DSBLPOZUPO
     C                   MOVEL(P)  BLPOMWCD      DSBLPOMWCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXBLPOMEIN
     C                   MOVE      *BLANK        TXBLPOMEPR
     C*-------------------------------------------------------------------------
     C     DSBLPOMEIN    CASNE     *BLANK        PRBLPOMEIN
     C                   ENDCS
     C     DSBLPOMEPR    CASNE     *BLANK        PRBLPOMEPR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      BRPRKO01
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        EXFLPOFLDN
     C                   MOVEL(P)  'TRBLPO01'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C     PCRTCD        IFEQ      'W'
     C                   MOVE      '0070'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOBENR    IFNE      *BLANK
     C     DSBLPOWENR    ORNE      *BLANK
     C     DSBLPOZUNR    ORNE      *BLANK
     C                   MOVE      *ON           C#LCK2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C                   MOVE      *ON           C#LCK2
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSBLPOPRAR'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSBLPOPRAR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSBLPOTENR'  EXFLPOFLDN
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
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOBLPO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PCPGST        IFEQ      *BLANK
     C*--------------------------------------------------------
     C                   Z-ADD     DSBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLPOBLNR
     C                   Z-ADD     DSBLPOBLPO    KYBLPOBLPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPO
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSBLPOBLNR'  EXFLPOFLDN
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOTENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOTBZ1
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOTBZ2
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMENG
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMEIN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMEPR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMWCD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BRPRKO01
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
     C                   WRITE     TRBLPOW1
     C                   WRITE     TRBLPO02
     C                   WRITE     W1BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO02                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     PCPGST        IFNE      '5     '
     C     PCPGST        ANDNE     'F     '
     C*--------------------------------------------------------
     C     PCPGST        IFNE      'MUSTER'
     C                   EXSR      B02PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      UBLPO
     C*--------------------------------------------------------
     C     PCPGST        CASEQ     'MUSTER'      UTRMU
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      RFMTS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'F     '
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHBLPO
     C     #CRTCD        WHENEQ    'N'
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHBLPO
     C                   ENDSL
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
     C                   MOVE      *BLANK        TXBLPOKSST
     C                   MOVE      *BLANK        TXBLPOWBKT
     C                   MOVE      *BLANK        TXBLPOKOTR
     C*-------------------------------------------------------------------------
     C     DSBLPOKSST    CASNE     *BLANK        PRBLPOKSST
     C                   ENDCS
     C     DSBLPOWBKT    CASNE     *BLANK        PRBLPOWBKT
     C                   ENDCS
     C     DSBLPOKOTR    CASNE     *BLANK        PRBLPOKOTR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRBLPO02'    EXTRPBBFMT
     C                   EXSR      CSTRPB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '5     '
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    '2     '
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSBLPOKSST'  EXFLPOFLDN
     C*
     C     RTTRPBCUSR    IFNE      *BLANK
     C                   MOVEL(P)  RTTRPBCUSR    EXFLPOFLDN
     C                   ENDIF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVE      *ON           C#LCK1
     C                   MOVEL(P)  'DSBLPOKSST'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'F     '
     C                   MOVE      '0001'        WKFENR
     C                   MOVE      *ON           C#LCK0
     C                   MOVE      *ON           C#LCK1
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEL(P)  'DSBLPOKSST'  EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
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
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKSST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOWBKT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKOTR
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
     C***  STEUERROUTINE BILD03                                              ***
     C**************************************************************************
     C     BILD03        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B03DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '03'
     C                   EXSR      EFLPO
     C                   WRITE     TRBLPOW2
     C                   WRITE     TRBLPO03
     C                   WRITE     W2BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO03                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B03PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*---------------------------------------------------------
     C     DSBLPOWTKZ    CASEQ     DAJNKZ        VBLPOFM03
     C     DSBLPOMGKZ    CASEQ     DAJNKZ        VBLPOFM03
     C     DSBLPOGWKZ    CASEQ     DAJNKZ        VBLPOFM03
     C     DSBLPOABKZ    CASEQ     DAJNKZ        VBLPOFM03
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 03                                        ***
     C**************************************************************************
     C     B03DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      DANEKZ        DSBLPOWTKZ
     C                   MOVE      DANEKZ        DSBLPOMGKZ
     C                   MOVE      DANEKZ        DSBLPOGWKZ
     C                   MOVE      DANEKZ        DSBLPOABKZ
     C*--------------------------------------------------------
     C                   EXSR      EBLPOFM03
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXBLPOWTKZ
     C                   MOVE      *BLANK        TXBLPOMGKZ
     C                   MOVE      *BLANK        TXBLPOGWKZ
     C                   MOVE      *BLANK        TXBLPOABKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOWTKZ    CASNE     *BLANK        PRBLPOWTKZ
     C                   ENDCS
     C     DSBLPOMGKZ    CASNE     *BLANK        PRBLPOMGKZ
     C                   ENDCS
     C     DSBLPOGWKZ    CASNE     *BLANK        PRBLPOGWKZ
     C                   ENDCS
     C     DSBLPOABKZ    CASNE     *BLANK        PRBLPOABKZ
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOWTKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD03                                          ***
     C**************************************************************************
     C     B03PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOWTKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMGKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOGWKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOABKZ
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
     C***  STEUERROUTINE BILD04                                              ***
     C**************************************************************************
     C     BILD04        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B04DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '04'
     C                   EXSR      EFLPO
     C                   WRITE     TRBLPOW3
     C                   WRITE     TRBLPO04
     C                   WRITE     W3BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO04                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B04PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*---------------------------------------------------------
     C     DSBLPOWTKZ    CASEQ     DAJNKZ        VBLPOFM04
     C     DSBLPOMGKZ    CASEQ     DAJNKZ        VBLPOFM04
     C     DSBLPOGWKZ    CASEQ     DAJNKZ        VBLPOFM04
     C     DSBLPOABKZ    CASEQ     DAJNKZ        VBLPOFM04
     C                   ENDCS
     C*---------------------------------------------------------
     C     WKFM04        IFEQ      *ON
     C     DSBLPOKOND    ANDNE     *BLANK
     C                   EXSR      ERBLPOVTWT
     C     DSBLPOVTWT    IFNE      DSBLPOKOWT
     C                   EXSR      VBLPODIFF
     C                   EXSR      ERBLPOVTWT
     C                   ENDIF
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 04                                        ***
     C**************************************************************************
     C     B04DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C                   MOVE      *OFF          WKFM04
     C*-------------------------------------------------------------------------
     C     BLKOVTK1      IFEQ      *BLANK
     C                   MOVEL     DAJNKZ        BLKOVTK1
     C                   ENDIF
     C     BLKOVTK2      IFEQ      *BLANK
     C                   MOVEL     DAJNKZ        BLKOVTK2
     C                   ENDIF
     C     BLKOVTK3      IFEQ      *BLANK
     C                   MOVEL     DAJNKZ        BLKOVTK3
     C                   ENDIF
     C     BLKOVTK4      IFEQ      *BLANK
     C                   MOVEL     DAJNKZ        BLKOVTK4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I1
     C                   MOVE      *BLANK        KOND
     C                   MOVE      *ZERO         KOWT
     C*
     C     BLKOKON1      IFNE      *BLANK
     C     BLKOVTK1      ANDEQ     DAJNKZ
     C                   ADD       1             I1
     C                   MOVEL(P)  BLKOKON1      KOND(I1)
     C                   Z-ADD     BLKOKOW1      KOWT(I1)
     C                   ENDIF
     C*
     C     BLKOKON2      IFNE      *BLANK
     C     BLKOVTK2      ANDEQ     DAJNKZ
     C                   ADD       1             I1
     C                   MOVEL(P)  BLKOKON2      KOND(I1)
     C                   Z-ADD     BLKOKOW2      KOWT(I1)
     C                   ENDIF
     C*
     C     BLKOKON3      IFNE      *BLANK
     C     BLKOVTK3      ANDEQ     DAJNKZ
     C                   ADD       1             I1
     C                   MOVEL(P)  BLKOKON3      KOND(I1)
     C                   Z-ADD     BLKOKOW3      KOWT(I1)
     C                   ENDIF
     C*
     C     BLKOKON4      IFNE      *BLANK
     C     BLKOVTK4      ANDEQ     DAJNKZ
     C                   ADD       1             I1
     C                   MOVEL(P)  BLKOKON4      KOND(I1)
     C                   Z-ADD     BLKOKOW4      KOWT(I1)
     C                   ENDIF
     C*
     C                   MOVEL(P)  KOND(1)       DSBLKOKON1
     C                   MOVEL(P)  KOND(2)       DSBLKOKON2
     C                   MOVEL(P)  KOND(3)       DSBLKOKON3
     C                   MOVEL(P)  KOND(4)       DSBLKOKON4
     C*
     C                   Z-ADD     KOWT(1)       DSBLKOKOW1
     C                   Z-ADD     KOWT(2)       DSBLKOKOW2
     C                   Z-ADD     KOWT(3)       DSBLKOKOW3
     C                   Z-ADD     KOWT(4)       DSBLKOKOW4
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        DSBLPOKOND
     C*
     C                   MOVE      DANEKZ        DSBLPOWTKZ
     C                   MOVE      DANEKZ        DSBLPOMGKZ
     C                   MOVE      DANEKZ        DSBLPOGWKZ
     C                   MOVE      DANEKZ        DSBLPOABKZ
     C*--------------------------------------------------------
     C                   EXSR      EBLPOFM03
     C                   Z-ADD     *ZERO         DSBLPOVTWT
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXBLKOKON1
     C                   MOVE      *BLANK        TXBLKOKON2
     C                   MOVE      *BLANK        TXBLKOKON3
     C                   MOVE      *BLANK        TXBLKOKON4
     C*
     C                   MOVE      *BLANK        TXBLPOKOND
     C                   MOVE      *BLANK        TXBLPOWTKZ
     C                   MOVE      *BLANK        TXBLPOMGKZ
     C                   MOVE      *BLANK        TXBLPOGWKZ
     C                   MOVE      *BLANK        TXBLPOABKZ
     C*-------------------------------------------------------------------------
     C     DSBLKOKON1    CASNE     *BLANK        PRBLKOKON1
     C                   ENDCS
     C     DSBLKOKON2    CASNE     *BLANK        PRBLKOKON2
     C                   ENDCS
     C     DSBLKOKON3    CASNE     *BLANK        PRBLKOKON3
     C                   ENDCS
     C     DSBLKOKON4    CASNE     *BLANK        PRBLKOKON4
     C                   ENDCS
     C     DSBLPOWTKZ    CASNE     *BLANK        PRBLPOWTKZ
     C                   ENDCS
     C     DSBLPOMGKZ    CASNE     *BLANK        PRBLPOMGKZ
     C                   ENDCS
     C     DSBLPOGWKZ    CASNE     *BLANK        PRBLPOGWKZ
     C                   ENDCS
     C     DSBLPOABKZ    CASNE     *BLANK        PRBLPOABKZ
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKOND'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD04                                          ***
     C**************************************************************************
     C     B04PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKOND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOVTWT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOWTKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMGKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOGWKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOABKZ
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
     C***  STEUERROUTINE BILD05                                              ***
     C**************************************************************************
     C     BILD05        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B05DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '05'
     C                   EXSR      EFLPO
     C                   WRITE     TRBLPOW1
     C                   WRITE     TRBLPO05
     C                   WRITE     W1BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO05                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B05PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*---------------------------------------------------------
     C                   EXSR      VBLPOFM05
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 04                                        ***
     C**************************************************************************
     C     B05DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSBLPOKOND
     C                   MOVE      *ZERO         DSBLPOKONW
     C                   MOVE      *BLANK        DSBLPOKOPZ
     C                   MOVE      *BLANK        DSBLPOKODI
     C*
     C                   MOVE      *BLANK        T1BLPOKOND
     C                   MOVE      *BLANK        TXBLPOKOPZ
     C                   MOVE      *BLANK        TXBLPOKODI
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKOND'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD04                                          ***
     C**************************************************************************
     C     B05PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKOND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKONW
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKOPZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOKODI
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
     C***  STEUERROUTINE BILD06                                              ***
     C**************************************************************************
     C     BILD06        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B06DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '06'
     C                   EXSR      EFLPO
     C                   WRITE     TRBLPOW2
     C                   WRITE     TRBLPO06
     C                   WRITE     W2BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPO06                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B06PR
     C*
     C     WKFENR        IFNE      *ZERO
     C     C#CHNG        OREQ      *ON
     C                   ITER
     C                   ENDIF
     C*---------------------------------------------------------
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C     DSBLPOMGKZ    OREQ      DAJNKZ
     C     DSBLPOGWKZ    OREQ      DAJNKZ
     C     DSBLPOABKZ    OREQ      DAJNKZ
     C                   EXSR      VBLPOFM06
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B06DS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 06                                        ***
     C**************************************************************************
     C     B06DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      DAJNKZ        DSBLPOWTKZ
     C                   MOVE      DANEKZ        DSBLPOMGKZ
     C                   MOVE      DANEKZ        DSBLPOGWKZ
     C                   MOVE      DANEKZ        DSBLPOABKZ
     C*--------------------------------------------------------
     C                   MOVE      *ZERO         DSBLPOZTBT
     C                   MOVE      *BLANK        DSBLPOZOTN
     C*--------------------------------------------------------
     C                   EXSR      ERBLPOUGWT
     C                   EXSR      EBLPOFM03
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXBLPOWTKZ
     C                   MOVE      *BLANK        TXBLPOMGKZ
     C                   MOVE      *BLANK        TXBLPOGWKZ
     C                   MOVE      *BLANK        TXBLPOABKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOWTKZ    CASNE     *BLANK        PRBLPOWTKZ
     C                   ENDCS
     C     DSBLPOMGKZ    CASNE     *BLANK        PRBLPOMGKZ
     C                   ENDCS
     C     DSBLPOGWKZ    CASNE     *BLANK        PRBLPOGWKZ
     C                   ENDCS
     C     DSBLPOABKZ    CASNE     *BLANK        PRBLPOABKZ
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOZTBT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD06                                          ***
     C**************************************************************************
     C     B06PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOZTBT
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOZOTN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EBLPOFM03
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOWTKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOMGKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOGWKZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPOABKZ
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
     C***  STEUERROUTINE BILDK1                                              ***
     C**************************************************************************
     C     BILDK1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BK1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'K1'
     C                   EXSR      EFLPO
     C                   WRITE     TRBLPOW2
     C                   WRITE     TRBLPOK1
     C                   WRITE     W2BLPOB1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      TRBLPOK1                             9899
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
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      BK1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KBLPO
     C*                  EXSR      UBLPO
     C*---------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C                   Z-ADD     KYBLPOBLJJ    RTBLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    RTBLPOBLNR
     C                   Z-ADD     KYBLPOBLPO    RTBLPOBLPO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      #CRTCD        RTBLPORTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT K1                                        ***
     C**************************************************************************
     C     BK1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    DSBLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    DSBLPOBLNR
     C*
     C                   MOVE      *YEAR         DSBLPONBLJ
     C                   MOVE      *BLANK        DSBLPONBLN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPONBLN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDK1                                          ***
     C**************************************************************************
     C     BK1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPONBLJ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBLPONBLN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPONBLJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPONBLN    KYBLPOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVE      '0092'        WKFENR
     C                   MOVEL(P)  'DSBLPONBLN'  EXFLPOFLDN
     C                   LEAVESR
     C                   ELSE
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
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
     C                   MOVE      *ZERO         C#CLEA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     C#LCK0        WHENEQ    *ON
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     C#LCK1        WHENEQ    *ON
     C     FLDNAM        ANDEQ     'DSBLPOTENR'
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSBLPOMENG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOTENR'
     C                   EXSR      MCBLPOTENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOMEIN'
     C                   EXSR      MCBLPOMEIN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOMEPR'
     C                   EXSR      MCBLPOMEPR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRAR'
     C                   EXSR      MCBLPOPRAR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDIM'
     C                   EXSR      MCBLPOPDIM
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKON1'
     C                   EXSR      MCBLPOKON1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRZ1'
     C                   EXSR      MCBLPOPRZ1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDI1'
     C                   EXSR      MCBLPOPDI1
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKON2'
     C                   EXSR      MCBLPOKON2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRZ2'
     C                   EXSR      MCBLPOPRZ2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDI2'
     C                   EXSR      MCBLPOPDI2
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKON3'
     C                   EXSR      MCBLPOKON3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRZ3'
     C                   EXSR      MCBLPOPRZ3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDI3'
     C                   EXSR      MCBLPOPDI3
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKON4'
     C                   EXSR      MCBLPOKON4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRZ4'
     C                   EXSR      MCBLPOPRZ4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDI4'
     C                   EXSR      MCBLPOPDI4
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKON5'
     C                   EXSR      MCBLPOKON5
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPRZ5'
     C                   EXSR      MCBLPOPRZ5
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOPDI5'
     C                   EXSR      MCBLPOPDI5
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKSST'
     C                   EXSR      MCBLPOKSST
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOWBKT'
     C                   EXSR      MCBLPOWBKT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKOTR'
     C                   EXSR      MCBLPOKOTR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOWTKZ'
     C                   EXSR      MCBLPOWTKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOMGKZ'
     C                   EXSR      MCBLPOMGKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOGWKZ'
     C                   EXSR      MCBLPOGWKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOABKZ'
     C                   EXSR      MCBLPOABKZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKOND'
     C                   EXSR      MCBLPOKOND
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOMWCD'
     C                   EXSR      MCBLPOMWCD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKOPZ'
     C                   EXSR      MCBLPOKOPZ
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOKODI'
     C                   EXSR      MCBLPOKODI
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSBLPOZOTN'
     C                   EXSR      MCBLPOZOTN
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRMU                                                 ***
     C**************************************************************************
     C     UTRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BLPO'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTRMU
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         BLPOFREI
     C*
     C                   MOVEL(P)  BLPO          TRMUDATA
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
     C***  KOPIEREN SÄTZE AUS DATEI BLPO                                     ***
     C**************************************************************************
     C     KBLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLPOBLNR
     C                   Z-ADD     DSBLPOBLPO    KYBLPOBLPO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    OFBLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    OFBLPOBLNR
     C                   Z-ADD     KYBLPOBLPO    OFBLPOBLPO
     C*--------------------------------------------------------
     C     KYBLPOBLPO    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFBLPOBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '00+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     OFBLPOBLJJ
     C     BLPOBLNR      ANDLE     OFBLPOBLNR
     C     BLPOBLPO      ANDLE     OFBLPOBLPO
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      DSBLPOBLJJ
     C                   MOVEL(P)  BLPOBLNR      DSBLPOBLNR
     C                   Z-ADD     BLPOBLPO      DSBLPOBLPO
     C                   MOVEL(P)  BLPOTENR      DSBLPOTENR
     C                   Z-ADD     BLPOMENG      DSBLPOMENG
     C                   MOVEL(P)  BLPOTBZ1      DSBLPOTBZ1
     C                   MOVEL(P)  BLPOTBZ2      DSBLPOTBZ2
     C                   MOVEL(P)  BLPOMEIN      DSBLPOMEIN
     C                   MOVEL(P)  BLPOMEPR      DSBLPOMEPR
     C                   MOVEL(P)  BLPOPRAR      DSBLPOPRAR
     C                   Z-ADD     BLPOPREI      DSBLPOPREI
     C                   MOVEL(P)  BLPOPDIM      DSBLPOPDIM
     C                   Z-ADD     BLPONESU      DSBLPONESU
     C                   MOVEL(P)  BLPOKON1      DSBLPOKON1
     C                   Z-ADD     BLPOKOW1      DSBLPOKOW1
     C                   MOVEL(P)  BLPOPRZ1      DSBLPOPRZ1
     C                   MOVEL(P)  BLPOPDI1      DSBLPOPDI1
     C                   MOVEL(P)  BLPOBAS1      DSBLPOBAS1
     C                   MOVEL(P)  BLPOKON2      DSBLPOKON2
     C                   Z-ADD     BLPOKOW2      DSBLPOKOW2
     C                   MOVEL(P)  BLPOPRZ2      DSBLPOPRZ2
     C                   MOVEL(P)  BLPOPDI2      DSBLPOPDI2
     C                   MOVEL(P)  BLPOBAS2      DSBLPOBAS2
     C                   MOVEL(P)  BLPOKON3      DSBLPOKON3
     C                   Z-ADD     BLPOKOW3      DSBLPOKOW3
     C                   MOVEL(P)  BLPOPRZ3      DSBLPOPRZ3
     C                   MOVEL(P)  BLPOPDI3      DSBLPOPDI3
     C                   MOVEL(P)  BLPOBAS3      DSBLPOBAS3
     C                   MOVEL(P)  BLPOKON4      DSBLPOKON4
     C                   Z-ADD     BLPOKOW4      DSBLPOKOW4
     C                   MOVEL(P)  BLPOPRZ4      DSBLPOPRZ4
     C                   MOVEL(P)  BLPOPDI4      DSBLPOPDI4
     C                   MOVEL(P)  BLPOBAS4      DSBLPOBAS4
     C                   MOVEL(P)  BLPOKON5      DSBLPOKON5
     C                   Z-ADD     BLPOKOW5      DSBLPOKOW5
     C                   MOVEL(P)  BLPOPRZ5      DSBLPOPRZ5
     C                   MOVEL(P)  BLPOPDI5      DSBLPOPDI5
     C                   MOVEL(P)  BLPOBAS5      DSBLPOBAS5
     C                   MOVEL(P)  BLPOKSST      DSBLPOKSST
     C                   MOVEL(P)  BLPOWBKT      DSBLPOWBKT
     C                   MOVEL(P)  BLPOKOTR      DSBLPOKOTR
     C                   Z-ADD     BLPOBEJJ      DSBLPOBEJJ
     C                   MOVEL(P)  BLPOBENR      DSBLPOBENR
     C                   Z-ADD     BLPOBEPO      DSBLPOBEPO
     C                   Z-ADD     BLPOWEJJ      DSBLPOWEJJ
     C                   MOVEL(P)  BLPOWENR      DSBLPOWENR
     C                   Z-ADD     BLPOUPOS      DSBLPOUPOS
     C                   MOVEL(P)  BLPOMWCD      DSBLPOMWCD
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C*
     C                   MOVEL(P)  '3     '      EXTBPGCD
     C                   MOVE      *BLANK        EXTBDSPF
     C                   EXSR      VTX55
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '00R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB BLPO-SATZ GELÖSCHT WERDEN DARF                         ***
     C**************************************************************************
     C     PBLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    KYBLKOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C*
     C                   SELECT
     C     BLKORPST      WHENLT    '15'
     C                   MOVE      *OFF          WKBBEP
     C     BLPABLAT      WHENEQ    'RE '
     C     BLPABLAT      OREQ      'BA '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C     BLPABLAT      OREQ      'GD '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C                   MOVE      *ON           WKBBEP
     C                   OTHER
     C                   MOVE      *OFF          WKBBEP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    OFBLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    OFBLPOBLNR
     C                   Z-ADD     KYBLPOBLPO    OFBLPOBLPO
     C*--------------------------------------------------------
     C     KYBLPOBLPO    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFBLPOBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     OFBLPOBLJJ
     C     BLPOBLNR      ANDLE     OFBLPOBLNR
     C     BLPOBLPO      ANDLE     OFBLPOBLPO
     C*--------------------------------------------------------
     C     BLPOLOCK      IFEQ      'L'
     C                   MOVE      '0004'        WKFENR
     C                   MOVEL(P)  'BLPOLOCK'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN SÄTZE DATEI BLPO                                          ***
     C**************************************************************************
     C     LBLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    OFBLPOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    OFBLPOBLNR
     C                   Z-ADD     KYBLPOBLPO    OFBLPOBLPO
     C*--------------------------------------------------------
     C     KYBLPOBLPO    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFBLPOBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     OFBLPOBLJJ
     C     BLPOBLNR      ANDLE     OFBLPOBLNR
     C     BLPOBLPO      ANDLE     OFBLPOBLPO
     C                   EXSR      LPOSI
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      KYBLPOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLPOBLNR
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBLPO
     C*
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHBLPO
     C*
     C     BLPOUPOS      CASNE     *ZERO         TRBZUR
     C     BLPOWENR      CASNE     *BLANK        TRBWAE
     C                   ENDCS
     C     WKBBEP        CASEQ     *ON           SBBEP
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN DER ABHÄNGIG. SÄTZE                                       ***
     C**************************************************************************
     C     LPOSI         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '4     '      EXTBPGCD
     C                   MOVE      *BLANK        EXTBDSPF
     C                   EXSR      VTX55
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STORNO BERECHNETE MENGE                                           ***
     C**************************************************************************
     C     SBBEP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      ERBLPOBBEP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYEPJH
     C                   MOVEL(P)  BLPOBENR      KYEPBE
     C                   Z-ADD     BLPOBEPO      KYEPPO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C     EPMEIN        IFEQ      TEMEIN
     C                   Z-ADD     WKBLPOBRMG    EPBRMG
     C                   ELSE
     C                   MOVEL     EPTENR        KYTUTE
     C                   MOVEL     EPMEIN        KYTUME
     C                   Z-ADD     WKBLPOBRMG    WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV2V1        EPBRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '50'
     C     EPBEST        OREQ      '60'
     C*
     C     EPBRMG        IFGT      *ZERO
     C                   MOVE      '50'          EPBEST
     C                   ELSE
     C                   MOVE      '40'          EPBEST
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '30'
     C     EPBEST        OREQ      '35'
     C     EPBEST        OREQ      '36'
     C     EPBEST        OREQ      '38'
     C     EPBEST        OREQ      '40'
     C     EPBEST        OREQ      '45'
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBBEP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BETRAG-VERTEILUNG                                                 ***
     C**************************************************************************
     C     VBLPOFM03     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         WKWERT
     C                   Z-ADD     *ZERO         WKMENG
     C                   MOVE      *BLANK        WKMEIN
     C                   Z-ADD     *ZERO         WKGWNT
     C*
     C                   EXSR      EBWAEFM03
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   EXSR      B01DS
     C*
     C                   MOVEL(P)  BLPAPRAR      DSBLPOPRAR
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDIM
     C*
     C                   SELECT
     C     DSBLPOWTKZ    WHENEQ    DAJNKZ
     C     DSBLPOWERT    ANDNE     *ZERO
     C     DSBLPOUGWT    MULT      WKWERT        DUN219
     C     DUN219        DIV       DSBLPOWERT    DSBLPOPREI
     C*
     C     DSBLPOMGKZ    WHENEQ    DAJNKZ
     C     DSBLPOGSMG    ANDNE     *ZERO
     C     DSBLPOUGWT    MULT      WKMENG        DUN219
     C     DUN219        DIV       DSBLPOGSMG    DSBLPOPREI
     C*
     C     DSBLPOGWKZ    WHENEQ    DAJNKZ
     C     DSBLPOGEWI    ANDNE     *ZERO
     C     DSBLPOUGWT    MULT      WKGWNT        DUN219
     C     DUN219        DIV       DSBLPOGEWI    DSBLPOPREI
     C*
     C     DSBLPOABKZ    WHENEQ    DAJNKZ
     C     DSBLPOPOAZ    ANDNE     *ZERO
     C     DSBLPOUGWT    DIV       DSBLPOPOAZ    DSBLPOPREI
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KONDITIONS-VERTEILUNG                                             ***
     C**************************************************************************
     C     VBLPOFM04     BEGSR
     C*
     C                   MOVE      *ON           WKFM04
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         WKWERT
     C                   Z-ADD     *ZERO         WKMENG
     C                   MOVE      *BLANK        WKMEIN
     C                   Z-ADD     *ZERO         WKGWNT
     C*
     C                   EXSR      EBLPOFM04
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   EXSR      B01DS
     C*
     C                   SELECT
     C     DSBLPOWTKZ    WHENEQ    DAJNKZ
     C     DSBLPOWERT    ANDNE     *ZERO
     C     DSBLPOKOWT    MULT      WKWERT        DUN219
     C     DUN219        DIV       DSBLPOWERT    WKKOWT
     C*
     C     DSBLPOMGKZ    WHENEQ    DAJNKZ
     C     DSBLPOGSMG    ANDNE     *ZERO
     C     DSBLPOKOWT    MULT      WKMENG        DUN219
     C     DUN219        DIV       DSBLPOGSMG    WKKOWT
     C*
     C     DSBLPOGWKZ    WHENEQ    DAJNKZ
     C     DSBLPOGEWI    ANDNE     *ZERO
     C     DSBLPOKOWT    MULT      WKGWNT        DUN219
     C     DUN219        DIV       DSBLPOGEWI    WKKOWT
     C*
     C     DSBLPOABKZ    WHENEQ    DAJNKZ
     C     DSBLPOPOAZ    ANDNE     *ZERO
     C     DSBLPOKOWT    DIV       DSBLPOPOAZ    WKKOWT
     C                   ENDSL
     C*
     C                   SELECT
     C     DSBLPOKON1    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON1
     C                   Z-ADD     WKKOWT        DSBLPOKOW1
     C                   MOVE      DANEKZ        DSBLPOPRZ1
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDI1
     C     DSBLPOKON2    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON2
     C                   Z-ADD     WKKOWT        DSBLPOKOW2
     C                   MOVE      DANEKZ        DSBLPOPRZ2
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDI2
     C     DSBLPOKON3    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON3
     C                   Z-ADD     WKKOWT        DSBLPOKOW3
     C                   MOVE      DANEKZ        DSBLPOPRZ3
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDI3
     C     DSBLPOKON4    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON4
     C                   Z-ADD     WKKOWT        DSBLPOKOW4
     C                   MOVE      DANEKZ        DSBLPOPRZ4
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDI4
     C     DSBLPOKON5    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON5
     C                   Z-ADD     WKKOWT        DSBLPOKOW5
     C                   MOVE      DANEKZ        DSBLPOPRZ5
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDI5
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BETRAG-VERTEILUNG MIT ZOLLTARIF-NR.                               ***
     C**************************************************************************
     C     VBLPOFM06     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     PCPGST        IFEQ      'BILD06'
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     TEZOTN        IFNE      DSBLPOZOTN
     C     TEZOTN        OREQ      *BLANK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         WKWERT
     C                   Z-ADD     *ZERO         WKMENG
     C                   MOVE      *BLANK        WKMEIN
     C                   Z-ADD     *ZERO         WKGWNT
     C*
     C                   EXSR      EBWAEFM03
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   EXSR      B01DS
     C*
     C                   MOVEL(P)  BLPAPRAR      DSBLPOPRAR
     C                   MOVEL(P)  WKTRTPPDIM    DSBLPOPDIM
     C*
     C                   SELECT
     C     DSBLPOWTKZ    WHENEQ    DAJNKZ
     C     DSBLPOWERT    ANDNE     *ZERO
     C     DSBLPOZTBT    MULT      WKWERT        DUN219
     C     DUN219        DIV       DSBLPOWERT    DSBLPOPREI
     C*
     C     DSBLPOMGKZ    WHENEQ    DAJNKZ
     C     DSBLPOGSMG    ANDNE     *ZERO
     C     DSBLPOZTBT    MULT      WKMENG        DUN219
     C     DUN219        DIV       DSBLPOGSMG    DSBLPOPREI
     C*
     C     DSBLPOGWKZ    WHENEQ    DAJNKZ
     C     DSBLPOGEWI    ANDNE     *ZERO
     C     DSBLPOZTBT    MULT      WKGWNT        DUN219
     C     DUN219        DIV       DSBLPOGEWI    DSBLPOPREI
     C*
     C     DSBLPOABKZ    WHENEQ    DAJNKZ
     C     DSBLPOPOAZ    ANDNE     *ZERO
     C     DSBLPOZTBT    DIV       DSBLPOPOAZ    DSBLPOPREI
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VERTEILUNGSWERT                                         ***
     C**************************************************************************
     C     ERBLPOVTWT    BEGSR
     C*
     C                   MOVE      *ZERO         DSBLPOVTWT
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDEQ     KYBLPOBLJJ
     C     BLPOBLNR      ANDEQ     KYBLPOBLNR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      'B'           EXKONDVPKZ
     C                   MOVE      BLPOTENR      EXKONDTENR
     C                   Z-ADD     BLPOMENG      EXKONDMENG
     C                   MOVE      BLPOMEIN      EXKONDMEIN
     C                   MOVE      BLPOMEPR      EXKONDMEPR
     C                   MOVE      BLPOWACD      EXKONDWACD
     C*--------------------------------------------------------
     C                   MOVE      BLPOPRAR      EXKONDPRAR
     C                   Z-ADD     BLPOPREI      EXKONDPREI
     C                   MOVE      BLPOPDIM      EXKONDPDIM
     C*--------------------------------------------------------
     C                   MOVE      BLPOKON1      EXKONDKON1
     C                   Z-ADD     BLPOKOW1      EXKONDKOW1
     C                   MOVE      BLPOPRZ1      EXKONDPRZ1
     C                   MOVE      BLPOPDI1      EXKONDPDI1
     C                   MOVE      BLPOBAS1      EXKONDBAS1
     C*
     C                   MOVE      BLPOKON2      EXKONDKON2
     C                   Z-ADD     BLPOKOW2      EXKONDKOW2
     C                   MOVE      BLPOPRZ2      EXKONDPRZ2
     C                   MOVE      BLPOPDI2      EXKONDPDI2
     C                   MOVE      BLPOBAS2      EXKONDBAS2
     C*
     C                   MOVE      BLPOKON3      EXKONDKON3
     C                   Z-ADD     BLPOKOW3      EXKONDKOW3
     C                   MOVE      BLPOPRZ3      EXKONDPRZ3
     C                   MOVE      BLPOPDI3      EXKONDPDI3
     C                   MOVE      BLPOBAS3      EXKONDBAS3
     C*
     C                   MOVE      BLPOKON4      EXKONDKON4
     C                   Z-ADD     BLPOKOW4      EXKONDKOW4
     C                   MOVE      BLPOPRZ4      EXKONDPRZ4
     C                   MOVE      BLPOPDI4      EXKONDPDI4
     C                   MOVE      BLPOBAS4      EXKONDBAS4
     C*
     C                   MOVE      BLPOKON5      EXKONDKON5
     C                   Z-ADD     BLPOKOW5      EXKONDKOW5
     C                   MOVE      BLPOPRZ5      EXKONDPRZ5
     C                   MOVE      BLPOPDI5      EXKONDPDI5
     C                   MOVE      BLPOBAS5      EXKONDBAS5
     C*
     C                   MOVE      *ON           EXKONDPMKZ
     C                   MOVE      *OFF          EXKONDKUKZ
     C                   MOVE      'BRPRKO'      EXKONDPGST
     C*--------------------------------------------------------
     C                   CALL      'BRPRKO01'
     C                   PARM                    EXKOND
     C                   PARM                    RTKOND
     C*-------------------------------------------------------------------------
     C     BLPOKON1      IFEQ      DSBLPOKOND
     C                   ADD       RTKONDERG1    DSBLPOVTWT
     C                   ENDIF
     C*
     C     BLPOKON2      IFEQ      DSBLPOKOND
     C                   ADD       RTKONDERG2    DSBLPOVTWT
     C                   ENDIF
     C*
     C     BLPOKON3      IFEQ      DSBLPOKOND
     C                   ADD       RTKONDERG3    DSBLPOVTWT
     C                   ENDIF
     C*
     C     BLPOKON4      IFEQ      DSBLPOKOND
     C                   ADD       RTKONDERG4    DSBLPOVTWT
     C                   ENDIF
     C*
     C     BLPOKON5      IFEQ      DSBLPOKOND
     C                   ADD       RTKONDERG5    DSBLPOVTWT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERTEILUNG RUNDUNGSDIFFERENZ                                      ***
     C**************************************************************************
     C     VBLPODIFF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSBLPOVTWT    IFEQ      *ZERO
     C     DSBLPOKOWT    OREQ      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKOWT    SUB       DSBLPOVTWT    WKDIFF
     C*
     C                   SELECT
     C     WKDIFF        WHENEQ    *ZERO
     C                   LEAVE
     C     WKDIFF        WHENGT    *ZERO
     C     WKDIFF        ANDGT     1
     C                   LEAVE
     C     WKDIFF        WHENLT    *ZERO
     C     WKDIFF        ANDLT     -1
     C                   LEAVE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYBLPOBLPO
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDEQ     KYBLPOBLJJ
     C     BLPOBLNR      ANDEQ     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C                   SELECT
     C     BLPOKON1      WHENEQ    DSBLPOKOND
     C                   ADD       WKDIFF        BLPOKOW1
     C     BLPOKON2      WHENEQ    DSBLPOKOND
     C                   ADD       WKDIFF        BLPOKOW2
     C     BLPOKON3      WHENEQ    DSBLPOKOND
     C                   ADD       WKDIFF        BLPOKOW3
     C     BLPOKON4      WHENEQ    DSBLPOKOND
     C                   ADD       WKDIFF        BLPOKOW4
     C     BLPOKON5      WHENEQ    DSBLPOKOND
     C                   ADD       WKDIFF        BLPOKOW5
     C                   ENDSL
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBLPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KONDITIONS-VERTEILUNG                                             ***
     C**************************************************************************
     C     VBLPOFM05     BEGSR
     C*
     C                   MOVE      *ON           WKFM04
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C     BLPOKON1      IFEQ      DSBLPOKOND
     C     BLPOKON2      OREQ      DSBLPOKOND
     C     BLPOKON3      OREQ      DSBLPOKOND
     C     BLPOKON4      OREQ      DSBLPOKOND
     C     BLPOKON5      OREQ      DSBLPOKOND
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C                   EXSR      B01DS
     C*--------------------------------------------------------
     C                   SELECT
     C     DSBLPOKON1    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON1
     C                   Z-ADD     DSBLPOKONW    DSBLPOKOW1
     C                   MOVE      DSBLPOKOPZ    DSBLPOPRZ1
     C                   MOVEL(P)  DSBLPOKODI    DSBLPOPDI1
     C     DSBLPOKON2    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON2
     C                   Z-ADD     DSBLPOKONW    DSBLPOKOW2
     C                   MOVE      DSBLPOKOPZ    DSBLPOPRZ2
     C                   MOVEL(P)  DSBLPOKODI    DSBLPOPDI2
     C     DSBLPOKON3    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON3
     C                   Z-ADD     DSBLPOKONW    DSBLPOKOW3
     C                   MOVE      DSBLPOKOPZ    DSBLPOPRZ3
     C                   MOVEL(P)  DSBLPOKODI    DSBLPOPDI3
     C     DSBLPOKON4    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON4
     C                   Z-ADD     DSBLPOKONW    DSBLPOKOW4
     C                   MOVE      DSBLPOKOPZ    DSBLPOPRZ4
     C                   MOVEL(P)  DSBLPOKODI    DSBLPOPDI4
     C     DSBLPOKON5    WHENEQ    *BLANK
     C                   MOVEL(P)  DSBLPOKOND    DSBLPOKON5
     C                   Z-ADD     DSBLPOKONW    DSBLPOKOW5
     C                   MOVE      DSBLPOKOPZ    DSBLPOPRZ5
     C                   MOVEL(P)  DSBLPOKODI    DSBLPOPDI5
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      B01PR
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      UBLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BLPO                                                 ***
     C**************************************************************************
     C     UBLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLPOBLNR
     C                   Z-ADD     DSBLPOBLPO    KYBLPOBLPO
     C*
     C     PCPGST        IFEQ      '3     '
     C     PCPGST        OREQ      'KBLPO '
     C                   Z-ADD     DSBLPONBLJ    KYBLPOBLJJ
     C                   MOVE(P)   DSBLPONBLN    KYBLPOBLNR
     C                   Z-ADD     DSBLPONBLP    KYBLPOBLPO
     C     DSBLPONBLP    IFEQ      *ZERO
     C                   Z-ADD     DSBLPOBLPO    KYBLPOBLPO
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTENR    BLPOTENR
     C                   Z-ADD     DSBLPOMENG    BLPOMENG
     C                   MOVEL(P)  DSBLPOTBZ1    BLPOTBZ1
     C                   MOVEL(P)  DSBLPOTBZ2    BLPOTBZ2
     C                   MOVEL(P)  DSBLPOMEIN    BLPOMEIN
     C                   MOVEL(P)  DSBLPOMEPR    BLPOMEPR
     C                   MOVEL(P)  DSBLPOPRAR    BLPOPRAR
     C                   Z-ADD     DSBLPOPREI    BLPOPREI
     C                   MOVEL(P)  DSBLPOPDIM    BLPOPDIM
     C                   Z-ADD     DSBLPONESU    BLPONESU
     C                   MOVEL(P)  DSBLPOKON1    BLPOKON1
     C                   Z-ADD     DSBLPOKOW1    BLPOKOW1
     C                   MOVEL(P)  DSBLPOPRZ1    BLPOPRZ1
     C                   MOVEL(P)  DSBLPOPDI1    BLPOPDI1
     C                   MOVEL(P)  DSBLPOBAS1    BLPOBAS1
     C                   MOVEL(P)  DSBLPOKON2    BLPOKON2
     C                   Z-ADD     DSBLPOKOW2    BLPOKOW2
     C                   MOVEL(P)  DSBLPOPRZ2    BLPOPRZ2
     C                   MOVEL(P)  DSBLPOPDI2    BLPOPDI2
     C                   MOVEL(P)  DSBLPOBAS2    BLPOBAS2
     C                   MOVEL(P)  DSBLPOKON3    BLPOKON3
     C                   Z-ADD     DSBLPOKOW3    BLPOKOW3
     C                   MOVEL(P)  DSBLPOPRZ3    BLPOPRZ3
     C                   MOVEL(P)  DSBLPOPDI3    BLPOPDI3
     C                   MOVEL(P)  DSBLPOBAS3    BLPOBAS3
     C                   MOVEL(P)  DSBLPOKON4    BLPOKON4
     C                   Z-ADD     DSBLPOKOW4    BLPOKOW4
     C                   MOVEL(P)  DSBLPOPRZ4    BLPOPRZ4
     C                   MOVEL(P)  DSBLPOPDI4    BLPOPDI4
     C                   MOVEL(P)  DSBLPOBAS4    BLPOBAS4
     C                   MOVEL(P)  DSBLPOKON5    BLPOKON5
     C                   Z-ADD     DSBLPOKOW5    BLPOKOW5
     C                   MOVEL(P)  DSBLPOPRZ5    BLPOPRZ5
     C                   MOVEL(P)  DSBLPOPDI5    BLPOPDI5
     C                   MOVEL(P)  DSBLPOBAS5    BLPOBAS5
     C                   MOVEL(P)  DSBLPOKSST    BLPOKSST
     C                   MOVEL(P)  DSBLPOWBKT    BLPOWBKT
     C                   MOVEL(P)  DSBLPOKOTR    BLPOKOTR
     C                   Z-ADD     DSBLPOBEJJ    BLPOBEJJ
     C                   MOVEL(P)  DSBLPOBENR    BLPOBENR
     C                   Z-ADD     DSBLPOBEPO    BLPOBEPO
     C                   Z-ADD     DSBLPOWEJJ    BLPOWEJJ
     C                   MOVEL(P)  DSBLPOWENR    BLPOWENR
     C                   Z-ADD     DSBLPOUPOS    BLPOUPOS
     C                   Z-ADD     DSBLPOZUJJ    BLPOZUJJ
     C                   MOVEL(P)  DSBLPOZUNR    BLPOZUNR
     C                   Z-ADD     DSBLPOZUPO    BLPOZUPO
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSBLPOWACD    BLPOWACD
     C                   MOVEL(P)  DSBLPOMWCD    BLPOMWCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        BLPOJNAM
     C                   MOVEL(P)  WKCHPN        BLPOPROG
     C                   MOVEL(P)  WKCHPL        BLPOBIBL
     C                   MOVEL(P)  DAUSER        BLPOUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        BLPOJZEI
     C                   MOVE      WKTDAT        BLPOJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'MUSTER'
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   CALL      'EXTSTP'
     C                   PARM                    BLPOTSTP
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHBLPO
     C*
     C     DSBLPOUPOS    CASNE     *ZERO         TRBZUR
     C     DSBLPOWENR    CASNE     *BLANK        TRBWAE
     C                   ENDCS
     C*
     C                   MOVE      'W'           #CRTCD
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBLPO
     C*
     C     DSBLPOUPOS    CASNE     *ZERO         TRBZUR
     C     DSBLPOWENR    CASNE     *BLANK        TRBWAE
     C                   ENDCS
     C*
     C                   MOVE      'U'           #CRTCD
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BESTELL-POSITION                                           ***
     C**************************************************************************
     C     PRBLPOBEPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOBLPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOBEJJ    KYBLPOBEJJ
     C                   MOVEL(P)  DSBLPOBENR    KYBLPOBENR
     C                   Z-ADD     DSBLPOBEPO    KYBLPOBEPO
     C                   Z-ADD     DSBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C*----------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBEJJ      ANDEQ     KYBLPOBEJJ
     C     BLPOBENR      ANDEQ     KYBLPOBENR
     C     BLPOBEPO      ANDEQ     KYBLPOBEPO
     C     BLPOBLJJ      ANDEQ     KYBLPOBLJJ
     C     BLPOBLNR      ANDEQ     KYBLPOBLNR
     C     BLPOBLPO      ANDNE     DSBLPOBLPO
     C                   MOVE      '2550'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(DSBLPOBEJJ : 'Z'))
     C                   EVAL      W$PA04 = DSBLPOBENR
     C                   EVAL      W$PA05 = %TRIM(%EDITC(DSBLPOBEPO : 'Z'))
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WENR                                                       ***
     C**************************************************************************
     C     PRBLPOWENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOBLPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOWEJJ    KYBLPOWEJJ
     C                   MOVEL(P)  DSBLPOWENR    KYBLPOWENR
     C                   Z-ADD     DSBLPOBLJJ    KYBLPOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C*----------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOWEJJ      ANDEQ     KYBLPOWEJJ
     C     BLPOWENR      ANDEQ     KYBLPOWENR
     C     BLPOBLJJ      ANDEQ     KYBLPOBLJJ
     C     BLPOBLNR      ANDEQ     KYBLPOBLNR
     C     BLPOBLPO      ANDNE     DSBLPOBLPO
     C                   MOVE      '2550'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(DSBLPOBEJJ : 'Z'))
     C                   EVAL      W$PA04 = DSBLPOBENR
     C                   EVAL      W$PA05 = %TRIM(%EDITC(DSBLPOBEPO : 'Z'))
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BELEG-POSITION                                             ***
     C**************************************************************************
     C     PRBLPOBLPO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOBLPO'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOBLPO    IFEQ      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN IDENT-STAMM                                              ***
     C**************************************************************************
     C     MCBLPOTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOTENR'  EXFLPOFLDN
     C*----------------------------------------------------
     C     DSBLPOTENR    IFEQ      *BLANK
     C                   MOVE      *BLANK        DSBLPOTBZ1
     C                   MOVE      *BLANK        DSBLPOTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOTENR    KOM(01)
     C                   MOVEL(P)  '0117'        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C                   EXSR      MCTEIL
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TETENR        DSBLPOTENR
     C                   MOVEL(P)  TETBZ1        DSBLPOTBZ1
     C                   MOVEL(P)  TETBZ2        DSBLPOTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN IDENT-NR                                                   ***
     C**************************************************************************
     C     PRBLPOTENR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOTENR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEL(P)  TETENR        DSBLPOTENR
     C*-------------------------------------------------------------------------
     C     DSBLPOTBZ1    IFEQ      *BLANK
     C*--------------------------------------------------------
     C                   MOVEL(P)  TETBZ1        DSBLPOTBZ1
     C                   MOVEL(P)  TETBZ2        DSBLPOTBZ2
     C                   MOVEL(P)  TEMEEK        DSBLPOMEIN
     C                   MOVEL(P)  TEMPEK        DSBLPOMEPR
     C*
     C     TEMEEK        IFEQ      *BLANK
     C                   MOVEL(P)  TEMEIN        DSBLPOMEIN
     C                   ENDIF
     C*
     C     TEMPEK        IFEQ      *BLANK
     C                   MOVEL(P)  TEMEIN        DSBLPOMEPR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BEZEICHNUNG 1                                              ***
     C**************************************************************************
     C     PRBLPOTBZ1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOTBZ1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOTBZ1    IFEQ      *BLANK
     C     DSBLPOTBZ2    ANDEQ     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BEZEICHNUNG 2                                              ***
     C**************************************************************************
     C     PRBLPOTBZ2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOTBZ2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOTBZ1    IFEQ      *BLANK
     C     DSBLPOTBZ2    ANDEQ     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGE                                                      ***
     C**************************************************************************
     C     PRBLPOMENG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMENG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     BLPAPRAR      WHENNE    *BLANK
     C     BLPABBKZ      OREQ      DAJNKZ
     C*
     C     DSBLPOMENG    IFLT      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   OTHER
     C*
     C     DSBLPOMENG    IFLE      *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C     DSBLPOUPOS    CASNE     *ZERO         PRBLPOBZUR
     C     DSBLPOWENR    CASNE     *BLANK        PRBLPOBWAE
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN WE-MENGE                                                   ***
     C**************************************************************************
     C     PRBLPOBWAE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMENG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOWEJJ    KYAEWJ
     C                   MOVEL(P)  DSBLPOWENR    KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPABLAT      IFNE      'BA '
     C*
     C                   MOVEL(P)  AEBWLA        KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C                   MOVE      *ZERO         WKFENR
     C*--------------------------------------------------------
     C                   SELECT
     C     LDQSWE        WHENEQ    DAJNKZ
     C     LDWEVE        ANDEQ     '4'
     C                   EXSR      PRBWPM
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C     LDQSWE        WHENEQ    DAJNKZ
     C     LDWEVE        ANDNE     '4'
     C     MODJOM        ANDEQ     *OFF
     C     MODHAW        ANDEQ     *OFF
     C     MODMAS        ANDEQ     *OFF
     C     MODWAO        ANDEQ     *OFF
     C                   MOVE      '2321'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(AEWEJJ : 'Z'))
     C                   EVAL      W$PA04 = AEWENR
     C                   LEAVESR
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPALPKZ      IFEQ      DAJNKZ
     C*
     C     AELFNR        IFNE      BLKOLFNR
     C                   MOVE      '2491'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLKOBENR      IFNE      *BLANK
     C*
     C     AEBEJJ        IFNE      BLKOBEJJ
     C     AEBENR        ORNE      BLKOBENR
     C                   MOVE      '2515'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPAPRAR      IFNE      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C
     C                   MOVEL(P)  BLPOTENR      KYTUTE
     C                   MOVEL(P)  BLPOMEIN      KYTUME
     C                   Z-ADD     BLPOMENG      WKV1V2
     C                   EXSR      VTEUF
     C*
     C                   MOVEL(P)  BLPOTENR      KYTUTE
     C                   MOVEL(P)  AEMEIN        KYTUME
     C                   Z-ADD     WKV1V2        WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV2V1        WKBLMG
     C*
     C                   MOVEL(P)  DSBLPOTENR    KYTUTE
     C                   MOVEL(P)  DSBLPOMEIN    KYTUME
     C                   Z-ADD     DSBLPOMENG    WKV1V2
     C                   EXSR      VTEUF
     C*
     C                   MOVEL(P)  DSBLPOTENR    KYTUTE
     C                   MOVEL(P)  AEMEIN        KYTUME
     C                   Z-ADD     WKV1V2        WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV2V1        W1BLMG
     C*
     C     AEBRMG        SUB       WKBLMG        DUN112
     C                   ADD       W1BLMG        DUN112
     C*
     C     DUN112        IFGT      AEMENG
     C     WKINF1        ANDEQ     *OFF
     C                   MOVE      '2516'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(DUN112 : '4'))
     C                   EVAL      W$PA04 = AEMEIN
     C                   EVAL      W$PA05 = %TRIM(%EDITC(AEMENG : '4'))
     C                   EVAL      W$PA06 = AEMEIN
     C                   MOVE      *ON           WKINF1
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN RÜCKLIEFERMENGE                                            ***
     C**************************************************************************
     C     PRBLPOBZUR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMENG'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOBEJJ    KYBZJH
     C                   MOVEL(P)  DSBLPOBENR    KYBZBE
     C                   Z-ADD     DSBLPOBEPO    KYBZPO
     C                   Z-ADD     DSBLPOWEJJ    KYBZWJ
     C                   MOVEL(P)  DSBLPOWENR    KYBZWE
     C                   Z-ADD     DSBLPOUPOS    KYBZUP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBZUR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPALPKZ      IFEQ      DAJNKZ
     C*
     C     BZLFNR        IFNE      BLKOLFNR
     C                   MOVE      '2491'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLKOBENR      IFNE      *BLANK
     C*
     C     BZBEJJ        IFNE      BLKOBEJJ
     C     BZBENR        ORNE      BLKOBENR
     C                   MOVE      '2515'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOMENG    IFGT      BZMENG
     C                   MOVE      '2517'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(BZMENG : '4'))
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN IDENT-STAMM UMRECHNUNGSFAKTOR                            ***
     C**************************************************************************
     C     MCBLPOMEIN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOMEIN'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOMEIN    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOTENR    KOM(1)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTEUF
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TUMEIN        DSBLPOMEIN
     C                   EXSR      PRBLPOMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGENEINHEIT                                              ***
     C**************************************************************************
     C     PRBLPOMEIN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMEIN'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOMEIN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTENR    KYTUTE
     C                   MOVEL(P)  DSBLPOMEIN    KYTUME
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEUF
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '1236'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  DSBLPOMEIN    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOMEIN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN IDENT-STAMM UMRECHNUNGSFAKTOR                            ***
     C**************************************************************************
     C     MCBLPOMEPR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOMEPR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOMEPR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOMEPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOTENR    KOM(1)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTEUF
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TUMEIN        DSBLPOMEPR
     C                   EXSR      PRBLPOMEPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MENGENEINHEIT                                              ***
     C**************************************************************************
     C     PRBLPOMEPR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMEPR'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOMEPR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTENR    KYTUTE
     C                   MOVEL(P)  DSBLPOMEPR    KYTUME
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEUF
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      '1236'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEIN'        KYTPTA
     C                   MOVEL(P)  DSBLPOMEPR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOMEPR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-PREIS-ARTEN                                     ***
     C**************************************************************************
     C     MCBLPOPRAR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRAR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPRAR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPRAR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'LFPR'        KOM(02)
     C                   MOVEA     DSBLPOPRAR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPRAR
     C                   MOVEL(P)  TPTTXT        TXBLPOPRAR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN EINKAUFS-PREIS-ART                                         ***
     C**************************************************************************
     C     PRBLPOPRAR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPRAR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LFPR'        KYTPTA
     C                   MOVEL(P)  DSBLPOPRAR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPRAR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDIM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDIM'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDIM    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDIM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDIM    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDIM
     C                   MOVEL(P)  TPTTXT        TXBLPOPDIM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PREIS-DIMENSION                                            ***
     C**************************************************************************
     C     PRBLPOPDIM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDIM'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDIM    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDIM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKON1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKON1'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKON1    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKON1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKON1    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKON1
     C                   MOVEL(P)  TPTTXT        TXBLPOKON1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKON1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKON1'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOKON1
     C*-------------------------------------------------------------------------
     C     DSBLPOKON1    IFEQ      *BLANK
     C     DSBLPOKOW1    ANDEQ     *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKON1    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKON1
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKON1    IFEQ      DSBLPOKON2
     C     DSBLPOKON1    OREQ      DSBLPOKON3
     C     DSBLPOKON1    OREQ      DSBLPOKON4
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOPRZ1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRZ1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOPRZ1    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOPRZ1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDI1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDI1'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDI1    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDI1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDI1    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDI1
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOPDI1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDI1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOPDI1    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDI1    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKON2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKON2'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKON2    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKON2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKON2    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKON2
     C                   MOVEL(P)  TPTTXT        TXBLPOKON2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKON2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKON2'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOKON2
     C*-------------------------------------------------------------------------
     C     DSBLPOKON2    IFEQ      *BLANK
     C     DSBLPOKOW2    ANDEQ     *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKON2    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKON2
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKON2    IFEQ      DSBLPOKON1
     C     DSBLPOKON2    OREQ      DSBLPOKON3
     C     DSBLPOKON2    OREQ      DSBLPOKON4
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOPRZ2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRZ2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOPRZ2    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOPRZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDI2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDI2'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDI2    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDI2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDI2    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDI2
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOPDI2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDI2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOPDI2    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDI2    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKON3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKON3'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKON3    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKON3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKON3    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKON3
     C                   MOVEL(P)  TPTTXT        TXBLPOKON3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKON3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKON3'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOKON3
     C*-------------------------------------------------------------------------
     C     DSBLPOKON3    IFEQ      *BLANK
     C     DSBLPOKOW3    ANDEQ     *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKON3    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKON3
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKON3    IFEQ      DSBLPOKON1
     C     DSBLPOKON3    OREQ      DSBLPOKON2
     C     DSBLPOKON3    OREQ      DSBLPOKON4
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOPRZ3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRZ3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOPRZ3    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOPRZ3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDI3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDI3'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDI3    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDI3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDI3    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDI3
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOPDI3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDI3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOPDI3    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDI3    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKON4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKON4'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKON4    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKON4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKON4    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKON4
     C                   MOVEL(P)  TPTTXT        TXBLPOKON4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKON4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKON4'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOKON4
     C*-------------------------------------------------------------------------
     C     DSBLPOKON4    IFEQ      *BLANK
     C     DSBLPOKOW4    ANDEQ     *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKON4    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKON4
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKON4    IFEQ      DSBLPOKON1
     C     DSBLPOKON4    OREQ      DSBLPOKON2
     C     DSBLPOKON4    OREQ      DSBLPOKON3
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOPRZ4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRZ4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOPRZ4    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOPRZ4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDI4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDI4'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDI4    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDI4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDI4    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDI4
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOPDI4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDI4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOPDI4    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDI4    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKON5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKON5'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKON5    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKON5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKON5    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKON5
     C                   MOVEL(P)  TPTTXT        TXBLPOKON5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKON5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKON5'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXBLPOKON5
     C*-------------------------------------------------------------------------
     C     DSBLPOKON5    IFEQ      *BLANK
     C     DSBLPOKOW5    ANDEQ     *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKON5    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKON5
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKON5    IFEQ      DSBLPOKON1
     C     DSBLPOKON5    OREQ      DSBLPOKON2
     C     DSBLPOKON5    OREQ      DSBLPOKON3
     C                   MOVE      '2219'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOPRZ5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPRZ5'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOPRZ5    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOPRZ5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOPDI5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOPDI5'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOPDI5    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOPDI5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOPDI5    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOPDI5
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOPDI5    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPDI5'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOPDI5    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOPDI5    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOPDI5
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KOSTEN-STELLEN                                           ***
     C**************************************************************************
     C     MCBLPOKSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKSST'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKSST    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOST'        KOM(02)
     C                   MOVEA     DSBLPOKSST    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKSST
     C                   MOVEL(P)  TPTTXT        TXBLPOKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KOSTEN-STELLE                                              ***
     C**************************************************************************
     C     PRBLPOKSST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKSST'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOKSST    IFNE      *BLANK
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  DSBLPOKSST    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKSST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KONTEN                                                   ***
     C**************************************************************************
     C     MCBLPOWBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOWBKT'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOWBKT    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOWBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOZK'        KOM(02)
     C                   MOVEA     DSBLPOWBKT    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOWBKT
     C                   MOVEL(P)  TPTTXT        TXBLPOWBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONTO                                                      ***
     C**************************************************************************
     C     PRBLPOWBKT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOWBKT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOWBKT    IFNE      *BLANK
     C                   MOVEL(P)  'KOZK'        KYTPTA
     C                   MOVEL(P)  DSBLPOWBKT    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOWBKT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN KOSTEN-TRÄGER                                            ***
     C**************************************************************************
     C     MCBLPOKOTR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKOTR'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKOTR    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKOTR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KOTR'        KOM(02)
     C                   MOVEA     DSBLPOKOTR    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKOTR
     C                   MOVEL(P)  TPTTXT        TXBLPOKOTR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KOSTEN-TRÄGER                                              ***
     C**************************************************************************
     C     PRBLPOKOTR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKOTR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOKOTR    IFNE      *BLANK
     C                   MOVEL(P)  'KOTR'        KYTPTA
     C                   MOVEL(P)  DSBLPOKOTR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKOTR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN TEILBETRAG ZOLL-NR                                         ***
     C**************************************************************************
     C     PRBLPOZTBT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOZTBT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOZTBT    IFEQ      *ZERO
     C     DSBLPOZTBT    ORGT      DSBLKONTBT
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN ZOLLTARIF-NR.                                            ***
     C**************************************************************************
     C     MCBLPOZOTN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOZOTN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOZOTN    KOM(1)
     C                   MOVE      'ZOTN01'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCZOTN
     C*-------------------------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  ZOTNZOTN      DSBLPOZOTN
     C**                 MOVEL(P)  ZOTNABEZ      TXZOTN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN ZOLL-TARIFNR                                               ***
     C**************************************************************************
     C     PRBLPOZOTN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOZOTN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOZOTN    IFEQ      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOZOTN    KOM(01)
     C                   MOVEA(P)  KOM           #CKOMM
     C                   MOVE      'ERMFLD'      #CPGST
     C*
     C                   CALL      'TRZOTN'
     C                   PARM                    EXTR02
     C*--------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA(P)  KOM(01)       ZOTNZOTN
     C**                 MOVEA(P)  KOM(16)       TXZOTN
     C*
     C**   DSBLPOZOTN    IFNE      ZOTNZOTN
     C**                 MOVE      '0031'        WKFENR
     C**                 ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOWTKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOWTKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOWTKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOWTKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOWTKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VERTEILUNGS-ART                                            ***
     C**************************************************************************
     C     PRBLPOWTKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOWTKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOWTKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOWTKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C     DSBLPOWERT    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C*
     C     DSBLPOMGKZ    IFEQ      DAJNKZ
     C     DSBLPOGWKZ    OREQ      DAJNKZ
     C     DSBLPOABKZ    OREQ      DAJNKZ
     C                   MOVE      '2534'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOMGKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOMGKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOMGKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOMGKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOMGKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VERTEILUNGS-ART                                            ***
     C**************************************************************************
     C     PRBLPOMGKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMGKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOMGKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOMGKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOMGKZ    IFEQ      DAJNKZ
     C     DSBLPOGSMG    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOMGKZ    IFEQ      DAJNKZ
     C*
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C     DSBLPOGWKZ    OREQ      DAJNKZ
     C     DSBLPOABKZ    OREQ      DAJNKZ
     C                   MOVE      '2534'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOGWKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOGWKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOGWKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOGWKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOGWKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VERTEILUNGS-ART                                            ***
     C**************************************************************************
     C     PRBLPOGWKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOGWKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOGWKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOGWKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOGWKZ    IFEQ      DAJNKZ
     C     DSBLPOGEWI    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOGWKZ    IFEQ      DAJNKZ
     C*
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C     DSBLPOMGKZ    OREQ      DAJNKZ
     C     DSBLPOABKZ    OREQ      DAJNKZ
     C                   MOVE      '2534'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOABKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOABKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOABKZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOABKZ
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOABKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN VERTEILUNGS-ART                                            ***
     C**************************************************************************
     C     PRBLPOABKZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOABKZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOABKZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOABKZ
     C*-------------------------------------------------------------------------
     C     DSBLPOABKZ    IFEQ      DAJNKZ
     C     DSBLPOPOAZ    ANDEQ     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOABKZ    IFEQ      DAJNKZ
     C*
     C     DSBLPOWTKZ    IFEQ      DAJNKZ
     C     DSBLPOMGKZ    OREQ      DAJNKZ
     C     DSBLPOGWKZ    OREQ      DAJNKZ
     C                   MOVE      '2534'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOABKZ    IFNE      DAJNKZ
     C     DSBLPOWTKZ    ANDNE     DAJNKZ
     C     DSBLPOMGKZ    ANDNE     DAJNKZ
     C     DSBLPOGWKZ    ANDNE     DAJNKZ
     C                   MOVE      '2535'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLKOKON1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLKOKON1'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOLS'        KYTPTA
     C                   MOVEL(P)  DSBLKOKON1    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLKOKON1
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLKOKON2    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLKOKON2'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOLS'        KYTPTA
     C                   MOVEL(P)  DSBLKOKON2    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLKOKON2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLKOKON3    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLKOKON3'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOLS'        KYTPTA
     C                   MOVEL(P)  DSBLKOKON3    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLKOKON3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLKOKON4    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLKOKON4'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KOLS'        KYTPTA
     C                   MOVEL(P)  DSBLKOKON4    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLKOKON4
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN EINKAUFS-KONDITIONEN                                     ***
     C**************************************************************************
     C     MCBLPOKOND    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKOND'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKOND    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKOND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'KONL'        KOM(02)
     C                   MOVEA     DSBLPOKOND    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKOND
     C                   MOVEL(P)  TPTTXT        TXBLPOKOND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION                                                  ***
     C**************************************************************************
     C     PRBLPOKOND    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKOND'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KONL'        KYTPTA
     C                   MOVEL(P)  DSBLPOKOND    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKOND
     C                   MOVEL(P)  TPTTXT        T1BLPOKOND
     C*-------------------------------------------------------------------------
     C     PCPGST        IFEQ      'BILD04'
     C*--------------------------------------------------------
     C                   SELECT
     C     DSBLPOKOND    WHENEQ    DSBLKOKON1
     C                   Z-ADD     DSBLKOKOW1    DSBLPOKOWT
     C     DSBLPOKOND    WHENEQ    DSBLKOKON2
     C                   Z-ADD     DSBLKOKOW2    DSBLPOKOWT
     C     DSBLPOKOND    WHENEQ    DSBLKOKON3
     C                   Z-ADD     DSBLKOKOW3    DSBLPOKOWT
     C     DSBLPOKOND    WHENEQ    DSBLKOKON4
     C                   Z-ADD     DSBLKOKOW4    DSBLPOKOWT
     C                   OTHER
     C                   MOVE      '2549'        WKFENR
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITIONSWERT                                             ***
     C**************************************************************************
     C     PRBLPOKONW    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKONW'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOKONW    IFEQ      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN JA/NEIN-KENNZEICHEN                                      ***
     C**************************************************************************
     C     MCBLPOKOPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKOPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRPC
     C                   MOVEL(P)  '5     '      EXTRPCPGST
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOKOPZ    EXTRPCCODE
     C                   MOVEL(P)  '0010'        EXTRPCUEBE
     C                   EXSR      MCTRPC
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  EXTRPCCODE    DSBLPOKOPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN PROZENT                                                   ***
     C**************************************************************************
     C     PRBLPOKOPZ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKOPZ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'JNKZ'        EXTRPCPGGR
     C                   MOVEL(P)  DSBLPOKOPZ    EXTRPCCODE
     C                   MOVEL(P)  'PRUEFE'      EXTRPCPGST
     C                   EXSR      PRTRPC
     C                   MOVEL(P)  EXTRPCTEXT    TXBLPOKOPZ
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN PREIS-DIMENSION                                          ***
     C**************************************************************************
     C     MCBLPOKODI    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOKODI'  EXFLPOFLDN
     C*--------------------------------------------------------
     C     DSBLPOKODI    IFEQ      *BLANK
     C                   MOVE      *BLANK        TXBLPOKODI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'PDIM'        KOM(02)
     C                   MOVEA     DSBLPOKODI    KOM(12)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  TPTCDE        DSBLPOKODI
     C                   MOVEL(P)  TPTTXT        TXBLPOKODI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KODITIONS-DIMENSION                                       ***
     C**************************************************************************
     C     PRBLPOKODI    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOKODI'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOKODI    IFNE      *BLANK
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  DSBLPOKODI    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        TXBLPOKODI
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOKOPZ    IFEQ      DAJNKZ
     C     DSBLPOKODI    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN VOR-, MEHRWERTSTEUER                                     ***
     C**************************************************************************
     C     MCBLPOMWCD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'DSBLPOMWCD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSBLPOMWCD    KOM(1)
     C                   Z-ADD     WKDATE        DUN080
     C                   MOVEA     DUC008        KOM(3)
     C                   MOVEA(P)  KOM           #CKOMM
     C                   MOVE      'MWST02'      #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCMWST
     C*--------------------------------------------------------
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVE      *ON           WKTRTP
     C                   MOVEL(P)  MWSTMWCD      DSBLPOMWCD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN MEHRWERTSTEUER-CODE                                        ***
     C**************************************************************************
     C     PRBLPOMWCD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOMWCD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DSBLPOMWCD    DUC002
     C                   Z-ADD     WKDATE        DUN080
     C                   EXSR      TRMWST
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSBLPOMWCD    IFNE      BLKOMWC1
     C     DSBLPOMWCD    ANDNE     BLKOMWC2
     C     DSBLPOMWCD    ANDNE     BLKOMWC3
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN KONDITION-VERTEILUNGSWERT                                  ***
     C**************************************************************************
     C     PRBLPOVTWT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOVTWT'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPOKOND    IFEQ      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ERBLPOVTWT
     C*
     C                   SELECT
     C     DSBLPOKOND    WHENEQ    DSBLKOKON1
     C     DSBLKOKOW1    ANDGT     *ZERO
     C     DSBLPOVTWT    ANDGE     DSBLKOKOW1
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON1
     C     DSBLKOKOW1    ANDLT     *ZERO
     C     DSBLPOVTWT    ANDLE     DSBLKOKOW1
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON2
     C     DSBLKOKOW2    ANDGT     *ZERO
     C     DSBLPOVTWT    ANDGE     DSBLKOKOW2
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON2
     C     DSBLKOKOW2    ANDLT     *ZERO
     C     DSBLPOVTWT    ANDLE     DSBLKOKOW2
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON3
     C     DSBLKOKOW3    ANDGT     *ZERO
     C     DSBLPOVTWT    ANDGE     DSBLKOKOW3
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON3
     C     DSBLKOKOW3    ANDLT     *ZERO
     C     DSBLPOVTWT    ANDLE     DSBLKOKOW3
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON4
     C     DSBLKOKOW4    ANDGT     *ZERO
     C     DSBLPOVTWT    ANDGE     DSBLKOKOW4
     C                   MOVE      '2544'        WKFENR
     C     DSBLPOKOND    WHENEQ    DSBLKOKON4
     C     DSBLKOKOW4    ANDLT     *ZERO
     C     DSBLPOVTWT    ANDLE     DSBLKOKOW4
     C                   MOVE      '2544'        WKFENR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN EINLAGERUNG                                                ***
     C**************************************************************************
     C     PRBWPM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AEWEJJ        KYWPWJ
     C                   MOVEL(P)  AEWENR        KYWPWE
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBWPM
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C     WPFIRM        ANDEQ     KYWPFI
     C     WPWEJJ        ANDEQ     KYWPWJ
     C     WPWENR        ANDEQ     KYWPWE
     C*--------------------------------------------------------
     C     WPBWLA        IFEQ      AEBWLA
     C                   MOVE      '2321'        WKFENR
     C                   EVAL      W$PA03 = %TRIM(%EDITC(AEWEJJ : 'Z'))
     C                   EVAL      W$PA04 = AEWENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBWPM
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BELEG-JAHR (NACH)                                          ***
     C**************************************************************************
     C     PRBLPONBLJ    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPONBLJ'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSBLPONBLJ    EXDATEJAHR
     C                   MOVE      'TRJJPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN BELEG-NR (NACH)                                            ***
     C**************************************************************************
     C     PRBLPONBLN    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPONBLN'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     DSBLPONBLN    IFEQ      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN UND BERECHNEN PREIS/KONDITION POSITION                     ***
     C**************************************************************************
     C     BRPRKO01      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         C#CLEA
     C                   MOVEL(P)  'DSBLPOPRAR'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSBLPOPRAR    IFEQ      WKTRPAOHBE
     C     WKTRPAOHBE    ANDNE     *BLANK
     C     DSBLPOPREI    ANDEQ     *ZERO
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      *ZERO         RTKONDFENR
     C                   MOVE      *BLANK        DSBLPOPDIM
     C                   MOVE      *BLANK        DSBLPOKON1
     C                   MOVE      *ZERO         DSBLPOKOW1
     C                   MOVE      *BLANK        DSBLPOPRZ1
     C                   MOVE      *BLANK        DSBLPOPDI1
     C                   MOVE      *BLANK        DSBLPOBAS1
     C                   MOVE      *BLANK        DSBLPOKON2
     C                   MOVE      *ZERO         DSBLPOKOW2
     C                   MOVE      *BLANK        DSBLPOPRZ2
     C                   MOVE      *BLANK        DSBLPOPDI2
     C                   MOVE      *BLANK        DSBLPOBAS2
     C                   MOVE      *BLANK        DSBLPOKON3
     C                   MOVE      *ZERO         DSBLPOKOW3
     C                   MOVE      *BLANK        DSBLPOPRZ3
     C                   MOVE      *BLANK        DSBLPOPDI3
     C                   MOVE      *BLANK        DSBLPOBAS3
     C                   MOVE      *BLANK        DSBLPOKON4
     C                   MOVE      *ZERO         DSBLPOKOW4
     C                   MOVE      *BLANK        DSBLPOPRZ4
     C                   MOVE      *BLANK        DSBLPOPDI4
     C                   MOVE      *BLANK        DSBLPOBAS4
     C                   MOVE      *BLANK        DSBLPOKON5
     C                   MOVE      *ZERO         DSBLPOKOW5
     C                   MOVE      *BLANK        DSBLPOPRZ5
     C                   MOVE      *BLANK        DSBLPOPDI5
     C                   MOVE      *BLANK        DSBLPOBAS5
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPAPRAR      IFNE      *BLANK
     C*
     C     DSBLPOPRAR    IFEQ      *BLANK
     C     DSBLPOPREI    ANDEQ     *ZERO
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      *ZERO         RTKONDFENR
     C                   MOVE      *BLANK        DSBLPOPDIM
     C                   MOVE      *BLANK        DSBLPOKON1
     C                   MOVE      *ZERO         DSBLPOKOW1
     C                   MOVE      *BLANK        DSBLPOPRZ1
     C                   MOVE      *BLANK        DSBLPOPDI1
     C                   MOVE      *BLANK        DSBLPOBAS1
     C                   MOVE      *BLANK        DSBLPOKON2
     C                   MOVE      *ZERO         DSBLPOKOW2
     C                   MOVE      *BLANK        DSBLPOPRZ2
     C                   MOVE      *BLANK        DSBLPOPDI2
     C                   MOVE      *BLANK        DSBLPOBAS2
     C                   MOVE      *BLANK        DSBLPOKON3
     C                   MOVE      *ZERO         DSBLPOKOW3
     C                   MOVE      *BLANK        DSBLPOPRZ3
     C                   MOVE      *BLANK        DSBLPOPDI3
     C                   MOVE      *BLANK        DSBLPOBAS3
     C                   MOVE      *BLANK        DSBLPOKON4
     C                   MOVE      *ZERO         DSBLPOKOW4
     C                   MOVE      *BLANK        DSBLPOPRZ4
     C                   MOVE      *BLANK        DSBLPOPDI4
     C                   MOVE      *BLANK        DSBLPOBAS4
     C                   MOVE      *BLANK        DSBLPOKON5
     C                   MOVE      *ZERO         DSBLPOKOW5
     C                   MOVE      *BLANK        DSBLPOPRZ5
     C                   MOVE      *BLANK        DSBLPOPDI5
     C                   MOVE      *BLANK        DSBLPOBAS5
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      'B'           EXKONDVPKZ
     C                   MOVE      DSBLPOTENR    EXKONDTENR
     C                   Z-ADD     DSBLPOMENG    EXKONDMENG
     C                   MOVE      DSBLPOMEIN    EXKONDMEIN
     C                   MOVE      DSBLPOMEPR    EXKONDMEPR
     C                   MOVE      DSBLPOWACD    EXKONDWACD
     C*--------------------------------------------------------
     C                   MOVE      DSBLPOPRAR    EXKONDPRAR
     C                   Z-ADD     DSBLPOPREI    EXKONDPREI
     C                   MOVE      DSBLPOPDIM    EXKONDPDIM
     C*--------------------------------------------------------
     C                   MOVE      DSBLPOKON1    EXKONDKON1
     C                   Z-ADD     DSBLPOKOW1    EXKONDKOW1
     C                   MOVE      DSBLPOPRZ1    EXKONDPRZ1
     C                   MOVE      DSBLPOPDI1    EXKONDPDI1
     C                   MOVE      DSBLPOBAS1    EXKONDBAS1
     C*
     C                   MOVE      DSBLPOKON2    EXKONDKON2
     C                   Z-ADD     DSBLPOKOW2    EXKONDKOW2
     C                   MOVE      DSBLPOPRZ2    EXKONDPRZ2
     C                   MOVE      DSBLPOPDI2    EXKONDPDI2
     C                   MOVE      DSBLPOBAS2    EXKONDBAS2
     C*
     C                   MOVE      DSBLPOKON3    EXKONDKON3
     C                   Z-ADD     DSBLPOKOW3    EXKONDKOW3
     C                   MOVE      DSBLPOPRZ3    EXKONDPRZ3
     C                   MOVE      DSBLPOPDI3    EXKONDPDI3
     C                   MOVE      DSBLPOBAS3    EXKONDBAS3
     C*
     C                   MOVE      DSBLPOKON4    EXKONDKON4
     C                   Z-ADD     DSBLPOKOW4    EXKONDKOW4
     C                   MOVE      DSBLPOPRZ4    EXKONDPRZ4
     C                   MOVE      DSBLPOPDI4    EXKONDPDI4
     C                   MOVE      DSBLPOBAS4    EXKONDBAS4
     C*
     C                   MOVE      DSBLPOKON5    EXKONDKON5
     C                   Z-ADD     DSBLPOKOW5    EXKONDKOW5
     C                   MOVE      DSBLPOPRZ5    EXKONDPRZ5
     C                   MOVE      DSBLPOPDI5    EXKONDPDI5
     C                   MOVE      DSBLPOBAS5    EXKONDBAS5
     C*
     C                   MOVE      *ON           EXKONDPMKZ
     C*--------------------------------------------------------
     C                   MOVE      *OFF          EXKONDKUKZ
     C                   MOVE      'BRPRKO'      EXKONDPGST
     C*--------------------------------------------------------
     C                   CALL      'BRPRKO01'
     C                   PARM                    EXKOND
     C                   PARM                    RTKOND
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTKONDERGB    DSBLPOERGB
     C                   Z-ADD     RTKONDNESU    DSBLPONESU
     C*
     C                   Z-ADD     RTKONDERG1    DSBLPOERG1
     C                   Z-ADD     RTKONDKUM1    DSBLPOKUM1
     C*
     C                   Z-ADD     RTKONDERG2    DSBLPOERG2
     C                   Z-ADD     RTKONDKUM2    DSBLPOKUM2
     C*
     C                   Z-ADD     RTKONDERG3    DSBLPOERG3
     C                   Z-ADD     RTKONDKUM3    DSBLPOKUM3
     C*
     C                   Z-ADD     RTKONDERG4    DSBLPOERG4
     C                   Z-ADD     RTKONDKUM4    DSBLPOKUM4
     C*
     C                   Z-ADD     RTKONDERG5    DSBLPOERG5
     C                   Z-ADD     RTKONDKUM5    DSBLPOKUM5
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        TXBLPOPRAR
     C                   MOVE      *BLANK        TXBLPOPDIM
     C                   MOVE      *BLANK        TXBLPOKON1
     C                   MOVE      *BLANK        TXBLPOPDI1
     C                   MOVE      *BLANK        TXBLPOKON2
     C                   MOVE      *BLANK        TXBLPOPDI2
     C                   MOVE      *BLANK        TXBLPOKON3
     C                   MOVE      *BLANK        TXBLPOPDI3
     C                   MOVE      *BLANK        TXBLPOKON4
     C                   MOVE      *BLANK        TXBLPOPDI4
     C                   MOVE      *BLANK        TXBLPOKON5
     C                   MOVE      *BLANK        TXBLPOPDI5
     C*-------------------------------------------------------------------------
     C     DSBLPOPRAR    CASNE     *BLANK        PRBLPOPRAR
     C                   ENDCS
     C     DSBLPOPDIM    CASNE     *BLANK        PRBLPOPDIM
     C                   ENDCS
     C     DSBLPOKON1    CASNE     *BLANK        PRBLPOKON1
     C                   ENDCS
     C     DSBLPOPDI1    CASNE     *BLANK        PRBLPOPDI1
     C                   ENDCS
     C     DSBLPOKON2    CASNE     *BLANK        PRBLPOKON2
     C                   ENDCS
     C     DSBLPOPDI2    CASNE     *BLANK        PRBLPOPDI2
     C                   ENDCS
     C     DSBLPOKON3    CASNE     *BLANK        PRBLPOKON3
     C                   ENDCS
     C     DSBLPOPDI3    CASNE     *BLANK        PRBLPOPDI3
     C                   ENDCS
     C     DSBLPOKON4    CASNE     *BLANK        PRBLPOKON4
     C                   ENDCS
     C     DSBLPOPDI4    CASNE     *BLANK        PRBLPOPDI4
     C                   ENDCS
     C     DSBLPOKON5    CASNE     *BLANK        PRBLPOKON5
     C                   ENDCS
     C     DSBLPOPDI5    CASNE     *BLANK        PRBLPOPDI5
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     RTKONDFENR    IFNE      *ZERO
     C                   MOVE      RTKONDFENR    WKFENR
     C                   MOVE      RTKONDFFLD    EXFLPOFLDN
     C                   MOVEL     'DSBLPO'      EXFLPOFLDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BLPO'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TRMUDATA      BLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VORBELEGUNG BEI ÄNDERUNG FÜR NEUE FELDER                ***
     C**************************************************************************
     C     EBLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BELEG-POS. BEI NEUANLAGE                                ***
     C**************************************************************************
     C     EBLPOBLPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYBLPOBLPO
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDEQ     KYBLPOBLJJ
     C     BLPOBLNR      ANDEQ     KYBLPOBLNR
     C     BLPOBLPO      ADD       BLPASFLG      DSBLPOBLPO
     C                   ELSE
     C                   Z-ADD     BLPASFLG      DSBLPOBLPO
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   BLPO
     C                   Z-ADD     DSBLPOBLPO    KYBLPOBLPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS BELEG-KOPF                                    ***
     C**************************************************************************
     C     EBLKO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOBLJJ    KYBLKOBLJJ
     C                   MOVEL(P)  DSBLPOBLNR    KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C                   Z-ADD     BLKONTBT      DSBLKONTBT
     C                   MOVEL(P)  BLKOWACD      DSNTBTWACD
     C                   MOVEL(P)  BLKOWACD      DSUGWTWACD
     C                   MOVEL(P)  BLKOWACD      DSZTBTWACD
     C*
     C                   MOVEL(P)  BLKOWACD      DSBLPOWACD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C                   MOVEL(P)  BLPAABEZ      TXBLPOBLGA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLKOLFNR      KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   MOVEL(P)  LFKNAM        DSLFNRKNAM
     C                   MOVEL(P)  LFPOLD        DSLFNRPOLD
     C                   MOVEL(P)  LFPOLZ        DSLFNRPOLZ
     C                   MOVEL(P)  LFWORT        DSLFNRWORT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKTRPAMWDA    WHENEQ    'DSEIDA'
     C                   Z-ADD     BLKOEIDA      WKDATE
     C     WKTRPAMWDA    WHENEQ    'DSBLDA'
     C     WKTRPAMWDA    OREQ      'DSEXDA'
     C                   Z-ADD     BLKOBLDA      WKDATE
     C     WKTRPAMWDA    WHENEQ    'DSBUDA'
     C                   Z-ADD     BLKOBUDA      WKDATE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS WARENEINGANG BEI NEUANLAGE                    ***
     C**************************************************************************
     C     EBWAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXBLPOWEJJ    KYAEWJ
     C                   MOVEL(P)  EXBLPOWENR    KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AETENR        BLPOTENR
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPAPRAR      WHENEQ    *BLANK
     C     AEMENG        SUB       AENRMG        BLPOMENG
     C                   SUB       AEBRMG        BLPOMENG
     C                   MOVEL(P)  AEMEIN        BLPOMEIN
     C*--------------------------------------------------------
     C     BLPAPRAR      WHENNE    *BLANK
     C                   Z-ADD     1             BLPOMENG
     C                   MOVEL(P)  AEBRME        BLPOMEIN
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  AETBZ1        BLPOTBZ1
     C                   MOVEL(P)  AETBZ2        BLPOTBZ2
     C                   MOVEL(P)  AEMEIN        BLPOMEIN
     C                   MOVEL(P)  AEMEPR        BLPOMEPR
     C*--------------------------------------------------------
     C     BLPAPRAR      IFEQ      *BLANK
     C*
     C     EXBLPOPGST    IFEQ      'BZUR  '
     C     AEWEST        ANDGT     '00'
     C     AEBRMG        ANDGT     *ZERO
     C                   EXSR      EBLPOBWAE
     C                   ENDIF
     C*
     C     AEWACD        CASNE     BLKOWACD      EBWAEWAUM
     C                   ENDCS
     C*
     C                   MOVEL(P)  AEPRAR        BLPOPRAR
     C                   Z-ADD     AEPREI        BLPOPREI
     C                   MOVEL(P)  AEPDIM        BLPOPDIM
     C                   Z-ADD     AENESU        BLPONESU
     C                   MOVEL(P)  AEKON1        BLPOKON1
     C                   Z-ADD     AEKOW1        BLPOKOW1
     C                   MOVEL(P)  AEPRZ1        BLPOPRZ1
     C                   MOVEL(P)  AEPDI1        BLPOPDI1
     C                   MOVEL(P)  AEBAS1        BLPOBAS1
     C                   MOVEL(P)  AEKON2        BLPOKON2
     C                   Z-ADD     AEKOW2        BLPOKOW2
     C                   MOVEL(P)  AEPRZ2        BLPOPRZ2
     C                   MOVEL(P)  AEPDI2        BLPOPDI2
     C                   MOVEL(P)  AEBAS2        BLPOBAS2
     C                   MOVEL(P)  AEKON3        BLPOKON3
     C                   Z-ADD     AEKOW3        BLPOKOW3
     C                   MOVEL(P)  AEPRZ3        BLPOPRZ3
     C                   MOVEL(P)  AEPDI3        BLPOPDI3
     C                   MOVEL(P)  AEBAS3        BLPOBAS3
     C                   MOVEL(P)  AEKON4        BLPOKON4
     C                   Z-ADD     AEKOW4        BLPOKOW4
     C                   MOVEL(P)  AEPRZ4        BLPOPRZ4
     C                   MOVEL(P)  AEPDI4        BLPOPDI4
     C                   MOVEL(P)  AEBAS4        BLPOBAS4
     C                   MOVEL(P)  AEKON5        BLPOKON5
     C                   Z-ADD     AEKOW5        BLPOKOW5
     C                   MOVEL(P)  AEPRZ5        BLPOPRZ5
     C                   MOVEL(P)  AEPDI5        BLPOPDI5
     C                   MOVEL(P)  AEBAS5        BLPOBAS5
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  AEKOST        BLPOKSST
     C                   MOVEL(P)  AEWBKT        BLPOWBKT
     C                   MOVEL(P)  AEKOTR        BLPOKOTR
     C                   Z-ADD     AEBEJJ        BLPOBEJJ
     C                   MOVEL(P)  AEBENR        BLPOBENR
     C                   Z-ADD     AEBEPO        BLPOBEPO
     C                   Z-ADD     AEWEJJ        BLPOWEJJ
     C                   MOVEL(P)  AEWENR        BLPOWENR
     C*-------------------------------------------------------------------------
     C     EXBLPOUPOS    CASNE     *ZERO         EBZUR
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS BELEG-POSITION FÜR RÜCKLIEFERUNG              ***
     C**************************************************************************
     C     EBLPOBWAE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYBLPO        KYSAVE
     C                   MOVEL(P)  BLPO          D$DAST
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AEWEJJ        KYBLPOWEJJ
     C                   MOVEL     AEWENR        KYBLPOWENR
     C                   MOVE      *LOVAL        KYBLPOBLJJ
     C                   MOVE      *LOVAL        KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BLPOFIRM      IFGT      KYBLPOFIRM
     C     BLPOWEJJ      ORGT      KYBLPOWEJJ
     C     BLPOWENR      ORGT      KYBLPOWENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOBLJJ      IFEQ      DSBLPOBLJJ
     C     BLPOBLNR      ANDEQ     DSBLPOBLNR
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHBLPO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOPRAR      AEPRAR
     C                   Z-ADD     BLPOPREI      AEPREI
     C                   MOVEL(P)  BLPOPDIM      AEPDIM
     C                   Z-ADD     BLPONESU      AENESU
     C                   MOVEL(P)  BLPOKON1      AEKON1
     C                   Z-ADD     BLPOKOW1      AEKOW1
     C                   MOVEL(P)  BLPOPRZ1      AEPRZ1
     C                   MOVEL(P)  BLPOPDI1      AEPDI1
     C                   MOVEL(P)  BLPOBAS1      AEBAS1
     C                   MOVEL(P)  BLPOKON2      AEKON2
     C                   Z-ADD     BLPOKOW2      AEKOW2
     C                   MOVEL(P)  BLPOPRZ2      AEPRZ2
     C                   MOVEL(P)  BLPOPDI2      AEPDI2
     C                   MOVEL(P)  BLPOBAS2      AEBAS2
     C                   MOVEL(P)  BLPOKON3      AEKON3
     C                   Z-ADD     BLPOKOW3      AEKOW3
     C                   MOVEL(P)  BLPOPRZ3      AEPRZ3
     C                   MOVEL(P)  BLPOPDI3      AEPDI3
     C                   MOVEL(P)  BLPOBAS3      AEBAS3
     C                   MOVEL(P)  BLPOKON4      AEKON4
     C                   Z-ADD     BLPOKOW4      AEKOW4
     C                   MOVEL(P)  BLPOPRZ4      AEPRZ4
     C                   MOVEL(P)  BLPOPDI4      AEPDI4
     C                   MOVEL(P)  BLPOBAS4      AEBAS4
     C                   MOVEL(P)  BLPOKON5      AEKON5
     C                   Z-ADD     BLPOKOW5      AEKOW5
     C                   MOVEL(P)  BLPOPRZ5      AEPRZ5
     C                   MOVEL(P)  BLPOPDI5      AEPDI5
     C                   MOVEL(P)  BLPOBAS5      AEBAS5
     C                   LEAVE
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYSAVE        KYBLPO
     C                   MOVEL     D$DAST        BLPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMRECHNEN WÄHRUNG                                                 ***
     C**************************************************************************
     C     EBWAEWAUM     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C     AEPREI        MULT      10            WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C     WAUMWBTN      DIV       10            AEPREI
     C                   ENDIF
     C*--------------------------------------------------------
     C     AEKOW1        IFNE      *ZERO
     C     AEPRZ1        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     AEKOW1        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      AEKOW1
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     AEKOW2        IFNE      *ZERO
     C     AEPRZ2        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     AEKOW2        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      AEKOW2
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     AEKOW3        IFNE      *ZERO
     C     AEPRZ3        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     AEKOW3        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      AEKOW3
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     AEKOW4        IFNE      *ZERO
     C     AEPRZ4        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     AEKOW4        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      AEKOW4
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     AEKOW5        IFNE      *ZERO
     C     AEPRZ5        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  AEWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     AEKOW5        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      AEKOW5
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS RÜCKLIEFERUNG BEI NEUANLAGE                   ***
     C**************************************************************************
     C     EBZUR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXBLPOBEJJ    KYBZJH
     C                   MOVEL(P)  EXBLPOBENR    KYBZBE
     C                   Z-ADD     EXBLPOBEPO    KYBZPO
     C                   Z-ADD     EXBLPOWEJJ    KYBZWJ
     C                   MOVEL(P)  EXBLPOWENR    KYBZWE
     C                   Z-ADD     EXBLPOUPOS    KYBZUP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBZUR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BZMENG        BLPOMENG
     C                   MOVEL(P)  BZMEIN        BLPOMEIN
     C                   Z-ADD     BZBEJJ        BLPOBEJJ
     C                   MOVEL(P)  BZBENR        BLPOBENR
     C                   Z-ADD     BZBEPO        BLPOBEPO
     C                   Z-ADD     BZWEJJ        BLPOWEJJ
     C                   MOVEL(P)  BZWENR        BLPOWENR
     C                   Z-ADD     BZUPOS        BLPOUPOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS BESTELL-POSITION BEI NEUANLAGE                ***
     C**************************************************************************
     C     EBBEP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXBLPOBEJJ    KYEPJH
     C                   MOVEL(P)  EXBLPOBENR    KYEPBE
     C                   Z-ADD     EXBLPOBEPO    KYEPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EPTENR        BLPOTENR
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPAPRAR      WHENEQ    *BLANK
     C     EPMENG        SUB       EPNRMG        BLPOMENG
     C                   MOVEL(P)  EPMEIN        BLPOMEIN
     C*--------------------------------------------------------
     C     BLPAPRAR      WHENNE    *BLANK
     C                   Z-ADD     1             BLPOMENG
     C                   MOVEL(P)  EPMEIN        BLPOMEIN
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  EPTBZ1        BLPOTBZ1
     C                   MOVEL(P)  EPTBZ2        BLPOTBZ2
     C                   MOVEL(P)  EPMEIN        BLPOMEIN
     C                   MOVEL(P)  EPMEPR        BLPOMEPR
     C*--------------------------------------------------------
     C     BLPAPRAR      IFEQ      *BLANK
     C*
     C     EPWACD        CASNE     BLKOWACD      EBBEPWAUM
     C                   ENDCS
     C*
     C                   MOVEL(P)  EPPRAR        BLPOPRAR
     C                   Z-ADD     EPPREI        BLPOPREI
     C                   MOVEL(P)  EPPDIM        BLPOPDIM
     C                   Z-ADD     EPNESU        BLPONESU
     C                   MOVEL(P)  EPKON1        BLPOKON1
     C                   Z-ADD     EPKOW1        BLPOKOW1
     C                   MOVEL(P)  EPPRZ1        BLPOPRZ1
     C                   MOVEL(P)  EPPDI1        BLPOPDI1
     C                   MOVEL(P)  EPBAS1        BLPOBAS1
     C                   MOVEL(P)  EPKON2        BLPOKON2
     C                   Z-ADD     EPKOW2        BLPOKOW2
     C                   MOVEL(P)  EPPRZ2        BLPOPRZ2
     C                   MOVEL(P)  EPPDI2        BLPOPDI2
     C                   MOVEL(P)  EPBAS2        BLPOBAS2
     C                   MOVEL(P)  EPKON3        BLPOKON3
     C                   Z-ADD     EPKOW3        BLPOKOW3
     C                   MOVEL(P)  EPPRZ3        BLPOPRZ3
     C                   MOVEL(P)  EPPDI3        BLPOPDI3
     C                   MOVEL(P)  EPBAS3        BLPOBAS3
     C                   MOVEL(P)  EPKON4        BLPOKON4
     C                   Z-ADD     EPKOW4        BLPOKOW4
     C                   MOVEL(P)  EPPRZ4        BLPOPRZ4
     C                   MOVEL(P)  EPPDI4        BLPOPDI4
     C                   MOVEL(P)  EPBAS4        BLPOBAS4
     C                   MOVEL(P)  EPKON5        BLPOKON5
     C                   Z-ADD     EPKOW5        BLPOKOW5
     C                   MOVEL(P)  EPPRZ5        BLPOPRZ5
     C                   MOVEL(P)  EPPDI5        BLPOPDI5
     C                   MOVEL(P)  EPBAS5        BLPOBAS5
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  EPKOST        BLPOKSST
     C                   MOVEL(P)  EPWBKT        BLPOWBKT
     C                   MOVEL(P)  EPKOTR        BLPOKOTR
     C                   Z-ADD     EPBEJJ        BLPOBEJJ
     C                   MOVEL(P)  EPBENR        BLPOBENR
     C                   Z-ADD     EPBEPO        BLPOBEPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMRECHNEN WÄHRUNG                                                 ***
     C**************************************************************************
     C     EBBEPWAUM     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C     EPPREI        MULT      10            WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C     WAUMWBTN      DIV       10            EPPREI
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPKOW1        IFNE      *ZERO
     C     EPPRZ1        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     EPKOW1        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      EPKOW1
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPKOW2        IFNE      *ZERO
     C     EPPRZ2        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     EPKOW2        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      EPKOW2
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPKOW3        IFNE      *ZERO
     C     EPPRZ3        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     EPKOW3        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      EPKOW3
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPKOW4        IFNE      *ZERO
     C     EPPRZ4        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     EPKOW4        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      EPKOW4
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPKOW5        IFNE      *ZERO
     C     EPPRZ5        ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  EPWACD        WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     EPKOW5        WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      EPKOW5
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS BELEG-POSITION BEI NEUANLAGE                  ***
     C**************************************************************************
     C     EZUPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPO          WKBLPO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXBLPOZUJJ    KYBLPOBLJJ
     C                   MOVEL(P)  EXBLPOZUNR    KYBLPOBLNR
     C                   Z-ADD     EXBLPOZUPO    KYBLPOBLPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  WKBLPO        BLPO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      DSBLPOTENR
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPAPRAR      WHENEQ    *BLANK
     C                   Z-ADD     BLPOMENG      DSBLPOMENG
     C                   MOVEL(P)  BLPOMEIN      DSBLPOMEIN
     C*--------------------------------------------------------
     C     BLPAPRAR      WHENNE    *BLANK
     C                   Z-ADD     1             DSBLPOMENG
     C                   MOVEL(P)  BLPOMEIN      DSBLPOMEIN
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOTBZ1      DSBLPOTBZ1
     C                   MOVEL(P)  BLPOTBZ2      DSBLPOTBZ2
     C                   MOVEL(P)  BLPOMEIN      DSBLPOMEIN
     C                   MOVEL(P)  BLPOMEPR      DSBLPOMEPR
     C*--------------------------------------------------------
     C     BLPAPRAR      IFEQ      *BLANK
     C*
     C     BLPOWACD      CASNE     BLKOWACD      EZUPOWAUM
     C                   ENDCS
     C*
     C                   MOVEL(P)  BLPOPRAR      DSBLPOPRAR
     C                   Z-ADD     BLPOPREI      DSBLPOPREI
     C                   MOVEL(P)  BLPOPDIM      DSBLPOPDIM
     C                   Z-ADD     BLPONESU      DSBLPONESU
     C                   MOVEL(P)  BLPOKON1      DSBLPOKON1
     C                   Z-ADD     BLPOKOW1      DSBLPOKOW1
     C                   MOVEL(P)  BLPOPRZ1      DSBLPOPRZ1
     C                   MOVEL(P)  BLPOPDI1      DSBLPOPDI1
     C                   MOVEL(P)  BLPOBAS1      DSBLPOBAS1
     C                   MOVEL(P)  BLPOKON2      DSBLPOKON2
     C                   Z-ADD     BLPOKOW2      DSBLPOKOW2
     C                   MOVEL(P)  BLPOPRZ2      DSBLPOPRZ2
     C                   MOVEL(P)  BLPOPDI2      DSBLPOPDI2
     C                   MOVEL(P)  BLPOBAS2      DSBLPOBAS2
     C                   MOVEL(P)  BLPOKON3      DSBLPOKON3
     C                   Z-ADD     BLPOKOW3      DSBLPOKOW3
     C                   MOVEL(P)  BLPOPRZ3      DSBLPOPRZ3
     C                   MOVEL(P)  BLPOPDI3      DSBLPOPDI3
     C                   MOVEL(P)  BLPOBAS3      DSBLPOBAS3
     C                   MOVEL(P)  BLPOKON4      DSBLPOKON4
     C                   Z-ADD     BLPOKOW4      DSBLPOKOW4
     C                   MOVEL(P)  BLPOPRZ4      DSBLPOPRZ4
     C                   MOVEL(P)  BLPOPDI4      DSBLPOPDI4
     C                   MOVEL(P)  BLPOBAS4      DSBLPOBAS4
     C                   MOVEL(P)  BLPOKON5      DSBLPOKON5
     C                   Z-ADD     BLPOKOW5      DSBLPOKOW5
     C                   MOVEL(P)  BLPOPRZ5      DSBLPOPRZ5
     C                   MOVEL(P)  BLPOPDI5      DSBLPOPDI5
     C                   MOVEL(P)  BLPOBAS5      DSBLPOBAS5
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOKSST      DSBLPOKSST
     C                   MOVEL(P)  BLPOWBKT      DSBLPOWBKT
     C                   MOVEL(P)  BLPOKOTR      DSBLPOKOTR
     C                   Z-ADD     BLPOBEJJ      DSBLPOBEJJ
     C                   MOVEL(P)  BLPOBENR      DSBLPOBENR
     C                   Z-ADD     BLPOBEPO      DSBLPOBEPO
     C                   Z-ADD     BLPOWEJJ      DSBLPOWEJJ
     C                   MOVEL(P)  BLPOWENR      DSBLPOWENR
     C                   Z-ADD     BLPOUPOS      DSBLPOUPOS
     C                   Z-ADD     BLPOBLJJ      DSBLPOZUJJ
     C                   MOVEL(P)  BLPOBLNR      DSBLPOZUNR
     C                   Z-ADD     BLPOBLPO      DSBLPOZUPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKBLPO        BLPO
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      KYBLPOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLPOBLNR
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTENR    BLPOTENR
     C                   Z-ADD     DSBLPOMENG    BLPOMENG
     C                   MOVEL(P)  DSBLPOMEIN    BLPOMEIN
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSBLPOTBZ1    BLPOTBZ1
     C                   MOVEL(P)  DSBLPOTBZ2    BLPOTBZ2
     C                   MOVEL(P)  DSBLPOMEIN    BLPOMEIN
     C                   MOVEL(P)  DSBLPOMEPR    BLPOMEPR
     C*--------------------------------------------------------
     C     BLPAPRAR      IFEQ      *BLANK
     C                   MOVEL(P)  DSBLPOPRAR    BLPOPRAR
     C                   Z-ADD     DSBLPOPREI    BLPOPREI
     C                   MOVEL(P)  DSBLPOPDIM    BLPOPDIM
     C                   Z-ADD     DSBLPONESU    BLPONESU
     C                   MOVEL(P)  DSBLPOKON1    BLPOKON1
     C                   Z-ADD     DSBLPOKOW1    BLPOKOW1
     C                   MOVEL(P)  DSBLPOPRZ1    BLPOPRZ1
     C                   MOVEL(P)  DSBLPOPDI1    BLPOPDI1
     C                   MOVEL(P)  DSBLPOBAS1    BLPOBAS1
     C                   MOVEL(P)  DSBLPOKON2    BLPOKON2
     C                   Z-ADD     DSBLPOKOW2    BLPOKOW2
     C                   MOVEL(P)  DSBLPOPRZ2    BLPOPRZ2
     C                   MOVEL(P)  DSBLPOPDI2    BLPOPDI2
     C                   MOVEL(P)  DSBLPOBAS2    BLPOBAS2
     C                   MOVEL(P)  DSBLPOKON3    BLPOKON3
     C                   Z-ADD     DSBLPOKOW3    BLPOKOW3
     C                   MOVEL(P)  DSBLPOPRZ3    BLPOPRZ3
     C                   MOVEL(P)  DSBLPOPDI3    BLPOPDI3
     C                   MOVEL(P)  DSBLPOBAS3    BLPOBAS3
     C                   MOVEL(P)  DSBLPOKON4    BLPOKON4
     C                   Z-ADD     DSBLPOKOW4    BLPOKOW4
     C                   MOVEL(P)  DSBLPOPRZ4    BLPOPRZ4
     C                   MOVEL(P)  DSBLPOPDI4    BLPOPDI4
     C                   MOVEL(P)  DSBLPOBAS4    BLPOBAS4
     C                   MOVEL(P)  DSBLPOKON5    BLPOKON5
     C                   Z-ADD     DSBLPOKOW5    BLPOKOW5
     C                   MOVEL(P)  DSBLPOPRZ5    BLPOPRZ5
     C                   MOVEL(P)  DSBLPOPDI5    BLPOPDI5
     C                   MOVEL(P)  DSBLPOBAS5    BLPOBAS5
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DSBLPOKSST    BLPOKSST
     C                   MOVEL(P)  DSBLPOWBKT    BLPOWBKT
     C                   MOVEL(P)  DSBLPOKOTR    BLPOKOTR
     C                   Z-ADD     DSBLPOBEJJ    BLPOBEJJ
     C                   MOVEL(P)  DSBLPOBENR    BLPOBENR
     C                   Z-ADD     DSBLPOBEPO    BLPOBEPO
     C                   Z-ADD     DSBLPOWEJJ    BLPOWEJJ
     C                   MOVEL(P)  DSBLPOWENR    BLPOWENR
     C                   Z-ADD     DSBLPOUPOS    BLPOUPOS
     C                   Z-ADD     DSBLPOZUJJ    BLPOZUJJ
     C                   MOVEL(P)  DSBLPOZUNR    BLPOZUNR
     C                   Z-ADD     DSBLPOZUPO    BLPOZUPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UMRECHNEN WÄHRUNG                                                 ***
     C**************************************************************************
     C     EZUPOWAUM     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C     BLPOPREI      MULT      10            WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C     WAUMWBTN      DIV       10            BLPOPREI
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOKOW1      IFNE      *ZERO
     C     BLPOPRZ1      ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     BLPOKOW1      WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      BLPOKOW1
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOKOW2      IFNE      *ZERO
     C     BLPOPRZ2      ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     BLPOKOW2      WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      BLPOKOW2
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOKOW3      IFNE      *ZERO
     C     BLPOPRZ3      ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     BLPOKOW3      WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      BLPOKOW3
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOKOW4      IFNE      *ZERO
     C     BLPOPRZ4      ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     BLPOKOW4      WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      BLPOKOW4
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     BLPOKOW5      IFNE      *ZERO
     C     BLPOPRZ5      ANDNE     DAJNKZ
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  BLKOWACD      WAUMWACN
     C                   Z-ADD     BLPOKOW5      WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      BLPOKOW5
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN UNGEPRÜFTER WERT                                        ***
     C**************************************************************************
     C     ERBLPOUGWT    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLKONTBT      DSBLPOUGWT
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   SUB       BLPONESU      DSBLPOUGWT
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BETRAG-VERTEILUNG                                       ***
     C**************************************************************************
     C     EBLPOFM03     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSBLPOWERT
     C                   Z-ADD     *ZERO         DSBLPOGSMG
     C                   MOVE      *BLANK        DSBLPOMEIN
     C                   Z-ADD     *ZERO         DSBLPOGEWI
     C                   Z-ADD     *ZERO         DSBLPOPOAZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     BLPOFIRM      ANDEQ     KYBLPOFIRM
     C     BLPOBLJJ      ANDLE     KYBLPOBLJJ
     C     BLPOBLNR      ANDLE     KYBLPOBLNR
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     PCPGST        IFEQ      'BILD06'
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     TEZOTN        IFNE      DSBLPOZOTN
     C     TEZOTN        OREQ      *BLANK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         WKWERT
     C                   Z-ADD     *ZERO         WKMENG
     C                   MOVE      *BLANK        WKMEIN
     C                   Z-ADD     *ZERO         WKGWNT
     C*
     C     PCPGST        CASEQ     'BILD03'      EBWAEFM03
     C     PCPGST        CASEQ     'BILD04'      EBLPOFM04
     C     PCPGST        CASEQ     'BILD06'      EBWAEFM03
     C                   ENDCS
     C*
     C                   ADD       WKWERT        DSBLPOWERT
     C                   SELECT
     C     DSBLPOMEIN    WHENEQ    *BLANK
     C                   ADD       WKMENG        DSBLPOGSMG
     C                   MOVEL(P)  WKMEIN        DSBLPOMEIN
     C     DSBLPOMEIN    WHENEQ    WKMEIN
     C                   ADD       WKMENG        DSBLPOGSMG
     C                   OTHER
     C                   Z-ADD     *ZERO         DSBLPOGSMG
     C                   ENDSL
     C                   ADD       WKGWNT        DSBLPOGEWI
     C                   ADD       1             DSBLPOPOAZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBLPO
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BETRAG-VERTEILUNG                                       ***
     C**************************************************************************
     C     EBWAEFM03     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     BLPOZUJJ      IFNE      *ZERO
     C     BLPOZUNR      ANDNE     *BLANK
     C     BLPOZUPO      ANDNE     *ZERO
     C                   MOVEL(P)  BLPO          WKBLPO
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOWEJJ      KYBLPOWEJJ
     C                   MOVEL(P)  BLPOWENR      KYBLPOWENR
     C                   Z-ADD     BLPOZUJJ      KYBLPOBLJJ
     C                   MOVEL(P)  BLPOZUNR      KYBLPOBLNR
     C                   Z-ADD     BLPOZUPO      KYBLPOBLPO
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHBLPO
     C*
     C                   EXSR      EBLPOFM04
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKBLPO        BLPO
     C*
     C                   Z-ADD     BLPOBLJJ      KYBLPOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLPOBLNR
     C                   Z-ADD     BLPOBLPO      KYBLPOBLPO
     C*
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOWEJJ      KYAEWJ
     C                   MOVEL(P)  BLPOWENR      KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* ERMITTELN WE BZW. BERECHNETE-MENGE
     C*-------------------------------------------------------------------------
     C     AEBRMG        IFNE      *ZERO
     C                   Z-ADD     AEBRMG        WKMENG
     C                   MOVEL(P)  AEBRME        WKMEIN
     C                   ELSE
     C                   Z-ADD     AEMENG        WKMENG
     C                   MOVEL(P)  AEMEIN        WKMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* ERMITTELN NETTO-BETRAG
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      'B'           EXKONDVPKZ
     C                   MOVE      AETENR        EXKONDTENR
     C                   Z-ADD     WKMENG        EXKONDMENG
     C                   MOVE      WKMEIN        EXKONDMEIN
     C                   MOVE      AEWACD        EXKONDWACD
     C*--------------------------------------------------------
     C                   MOVE      AEPRAR        EXKONDPRAR
     C                   Z-ADD     AEPREI        EXKONDPREI
     C                   MOVE      AEPDIM        EXKONDPDIM
     C*--------------------------------------------------------
     C                   MOVE      AEKON1        EXKONDKON1
     C                   Z-ADD     AEKOW1        EXKONDKOW1
     C                   MOVE      AEPRZ1        EXKONDPRZ1
     C                   MOVE      AEPDI1        EXKONDPDI1
     C                   MOVE      AEBAS1        EXKONDBAS1
     C*
     C                   MOVE      AEKON2        EXKONDKON2
     C                   Z-ADD     AEKOW2        EXKONDKOW2
     C                   MOVE      AEPRZ2        EXKONDPRZ2
     C                   MOVE      AEPDI2        EXKONDPDI2
     C                   MOVE      AEBAS2        EXKONDBAS2
     C*
     C                   MOVE      AEKON3        EXKONDKON3
     C                   Z-ADD     AEKOW3        EXKONDKOW3
     C                   MOVE      AEPRZ3        EXKONDPRZ3
     C                   MOVE      AEPDI3        EXKONDPDI3
     C                   MOVE      AEBAS3        EXKONDBAS3
     C*
     C                   MOVE      AEKON4        EXKONDKON4
     C                   Z-ADD     AEKOW4        EXKONDKOW4
     C                   MOVE      AEPRZ4        EXKONDPRZ4
     C                   MOVE      AEPDI4        EXKONDPDI4
     C                   MOVE      AEBAS4        EXKONDBAS4
     C*
     C                   MOVE      AEKON5        EXKONDKON5
     C                   Z-ADD     AEKOW5        EXKONDKOW5
     C                   MOVE      AEPRZ5        EXKONDPRZ5
     C                   MOVE      AEPDI5        EXKONDPDI5
     C                   MOVE      AEBAS5        EXKONDBAS5
     C*--------------------------------------------------------
     C                   MOVE      *OFF          EXKONDKUKZ
     C                   MOVE      *OFF          EXKONDPMKZ
     C                   MOVE      'BRPRKO'      EXKONDPGST
     C*--------------------------------------------------------
     C                   CALL      'BRPRKO'
     C                   PARM                    EXKOND
     C                   PARM                    RTKOND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTKONDNESU    WKWERT
     C*-------------------------------------------------------------------------
     C* ERMITTELN GEWICHT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AETENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C     WKMEIN        IFNE      TEMEIN
     C                   MOVEL(P)  AETENR        KYTUTE
     C                   MOVEL(P)  WKMEIN        KYTUME
     C                   Z-ADD     WKMENG        WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        DUN112
     C                   ELSE
     C                   Z-ADD     WKMENG        DUN112
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'GDIM'        KYTPTA
     C                   MOVEL(P)  TEGWDI        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*--------------------------------------------------------
     C     DUN112        MULT      TEGWNT        DUN219
     C                   DIV       TPTNUM        DUN219
     C*
     C                   Z-ADD     DUN219        WKGWNT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KONDITIONS-VERTEILUNG                                   ***
     C**************************************************************************
     C     EBLPOFM04     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* ERMITTELN WE BZW. BERECHNETE-MENGE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOMENG      WKMENG
     C                   MOVEL(P)  BLPOMEIN      WKMEIN
     C*-------------------------------------------------------------------------
     C* ERMITTELN NETTO-BETRAG
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOND
     C                   CLEAR                   RTKOND
     C                   MOVE      'B'           EXKONDVPKZ
     C                   MOVE      BLPOTENR      EXKONDTENR
     C                   Z-ADD     WKMENG        EXKONDMENG
     C                   MOVE      WKMEIN        EXKONDMEIN
     C                   MOVE      BLKOWACD      EXKONDWACD
     C*--------------------------------------------------------
     C                   MOVE      BLPOPRAR      EXKONDPRAR
     C                   Z-ADD     BLPOPREI      EXKONDPREI
     C                   MOVE      BLPOPDIM      EXKONDPDIM
     C*--------------------------------------------------------
     C                   MOVE      BLPOKON1      EXKONDKON1
     C                   Z-ADD     BLPOKOW1      EXKONDKOW1
     C                   MOVE      BLPOPRZ1      EXKONDPRZ1
     C                   MOVE      BLPOPDI1      EXKONDPDI1
     C                   MOVE      BLPOBAS1      EXKONDBAS1
     C*
     C                   MOVE      BLPOKON2      EXKONDKON2
     C                   Z-ADD     BLPOKOW2      EXKONDKOW2
     C                   MOVE      BLPOPRZ2      EXKONDPRZ2
     C                   MOVE      BLPOPDI2      EXKONDPDI2
     C                   MOVE      BLPOBAS2      EXKONDBAS2
     C*
     C                   MOVE      BLPOKON3      EXKONDKON3
     C                   Z-ADD     BLPOKOW3      EXKONDKOW3
     C                   MOVE      BLPOPRZ3      EXKONDPRZ3
     C                   MOVE      BLPOPDI3      EXKONDPDI3
     C                   MOVE      BLPOBAS3      EXKONDBAS3
     C*
     C                   MOVE      BLPOKON4      EXKONDKON4
     C                   Z-ADD     BLPOKOW4      EXKONDKOW4
     C                   MOVE      BLPOPRZ4      EXKONDPRZ4
     C                   MOVE      BLPOPDI4      EXKONDPDI4
     C                   MOVE      BLPOBAS4      EXKONDBAS4
     C*
     C                   MOVE      BLPOKON5      EXKONDKON5
     C                   Z-ADD     BLPOKOW5      EXKONDKOW5
     C                   MOVE      BLPOPRZ5      EXKONDPRZ5
     C                   MOVE      BLPOPDI5      EXKONDPDI5
     C                   MOVE      BLPOBAS5      EXKONDBAS5
     C*--------------------------------------------------------
     C                   MOVE      *OFF          EXKONDKUKZ
     C                   MOVE      *OFF          EXKONDPMKZ
     C                   MOVE      'BRPRKO'      EXKONDPGST
     C*--------------------------------------------------------
     C                   CALL      'BRPRKO'
     C                   PARM                    EXKOND
     C                   PARM                    RTKOND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTKONDNESU    WKWERT
     C*-------------------------------------------------------------------------
     C* ERMITTELN GEWICHT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C     WKMEIN        IFNE      TEMEIN
     C                   MOVEL(P)  BLPOTENR      KYTUTE
     C                   MOVEL(P)  WKMEIN        KYTUME
     C                   Z-ADD     WKMENG        WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        DUN112
     C                   ELSE
     C                   Z-ADD     WKMENG        DUN112
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'GDIM'        KYTPTA
     C                   MOVEL(P)  TEGWDI        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*--------------------------------------------------------
     C     DUN112        MULT      TEGWNT        DUN219
     C                   DIV       TPTNUM        DUN219
     C*
     C                   Z-ADD     DUN219        WKGWNT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ABSCHLIESSEN BLPO                                                 ***
     C**************************************************************************
     C     ABBLPO        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        WKFFLD
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYBLPOBLJJ    KYBLKOBLJJ
     C                   MOVEL(P)  KYBLPOBLNR    KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'BLKOBLNR'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL(P)  'BLKOBLGA'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*
     C     BLPABLAT      IFEQ      'AZ '
     C                   MOVEL(P)  'BLKOBLAT'    WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*
     C     BLPABLAT      IFEQ      'RE '
     C     BLPABLAT      OREQ      'BA '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C     BLPABLAT      OREQ      'GD '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C                   MOVE      *ON           WKBBEP
     C                   ELSE
     C                   MOVE      *OFF          WKBBEP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* VERARBEITEN DER BELEPOSITIONEN
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '00+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BLPOFIRM      IFGT      KYBLPOFIRM
     C     BLPOBLJJ      ORGT      KYBLPOBLJJ
     C     BLPOBLNR      ORGT      KYBLPOBLNR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOWEJJ      KYAEWJ
     C                   MOVEL(P)  BLPOWENR      KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYEPJH
     C                   MOVEL(P)  BLPOBENR      KYEPBE
     C                   Z-ADD     BLPOBEPO      KYEPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*--------------------------------------------------------
     C                   MOVEL     EPBEAT        KYPAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBPA
     C*--------------------------------------------------------
     C                   MOVE      BLPOTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C     PAUPPR        IFEQ      DAJNKZ
     C     TETART        ANDNE     'P'
     C                   EXSR      ERBLPOBWAE
     C                   EXSR      UTEIL
     C                   EXSR      ULBST
     C                   ENDIF
     C     WKBBEP        CASEQ     *ON           UBBEP
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVEA     '00R     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BLPO                                                    ***
     C**************************************************************************
     C     ERBLPOBWAE    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKBLPOMENG
     C                   Z-ADD     *ZERO         WKBLPONESU
     C                   Z-ADD     *ZERO         WKBLPOPREI
     C                   Z-ADD     *ZERO         W1BLPOMENG
     C                   Z-ADD     *ZERO         W1BLPONESU
     C                   Z-ADD     *ZERO         W1BLPOPREI
     C                   MOVE      *OFF          WKBBUP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYBLPO        KYSAVE
     C                   MOVEL(P)  BLPO          D$DAST
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOWEJJ      KYBLPOWEJJ
     C                   MOVEL     BLPOWENR      KYBLPOWENR
     C                   MOVE      *LOVAL        KYBLPOBLJJ
     C                   MOVE      *LOVAL        KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BLPOFIRM      IFGT      KYBLPOFIRM
     C     BLPOWEJJ      ORGT      KYBLPOWEJJ
     C     BLPOWENR      ORGT      KYBLPOWENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      KYBLKOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C*--------------------------------------------------------
     C                   MOVEL     BLPOMEIN      KYTUME
     C                   Z-ADD     BLPOMENG      WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKBLPOMENG
     C*--------------------------------------------------------
     C                   MOVEL     BLPOTENR      KYTUTE
     C                   MOVEL     BLPOMEPR      KYTUME
     C                   Z-ADD     BLPOPREI      WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV2V1        WKBLPOPREI
     C*--------------------------------------------------------
     C     WKBBUP        IFEQ      *OFF
     C                   EXSR      ERBBUP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'PDIM'        KYTPTA
     C                   MOVEL     BLPOPDIM      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C     WKBLPOMENG    IFNE      *ZERO
     C     WKBLPOPREI    DIV       WKBLPOMENG    WKBLPOPREI
     C                   ENDIF
     C*
     C                   ELSE
     C     WKBLPOPREI    DIV       TPTNUM        WKBLPOPREI
     C                   ENDIF
     C*
     C     WKBLPOMENG    IFNE      *ZERO
     C     WKBLPOPREI    MULT      WKBLPOMENG    WKBLPOPREI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     BLPONESU      WKBLPONESU
     C*-------------------------------------------------------------------------
     C     BLPOWACD      IFNE      WKTRPAWACD
     C     BLPOWACD      ANDNE     *BLANK
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  WKTRPAWACD    WAUMWACN
     C                   Z-ADD     WKBLPONESU    WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C                   Z-ADD     WAUMWBTN      WKBLPONESU
     C*
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  BLPOWACD      WAUMWACV
     C                   MOVEL(P)  WKTRPAWACD    WAUMWACN
     C                   Z-ADD     WKBLPOPREI    WAUMWBTV
     C                   Z-ADD     BLKOBLDA      WAUMDATE
     C                   Z-ADD     BLKOKURS      WAUMKRS1
     C                   MOVEL(P)  BLKOKUPD      WAUMKDI1
     C                   MOVE      *OFF          WAUMKUKZ
     C                   EXSR      TRWAUM
     C                   Z-ADD     WAUMWBTN      WKBLPOPREI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPAPMKZ      WHENEQ    '+'
     C     BLPAPRAR      ANDEQ     *BLANK
     C                   ADD       WKBLPOMENG    W1BLPOMENG
     C                   ADD       WKBLPONESU    W1BLPONESU
     C                   ADD       WKBLPOPREI    W1BLPOPREI
     C     BLPAPMKZ      WHENEQ    '-'
     C     BLPAPRAR      ANDEQ     *BLANK
     C     BLPOUPOS      ANDNE     *ZERO
     C                   SUB       WKBLPOMENG    W1BLPOMENG
     C                   SUB       WKBLPONESU    W1BLPONESU
     C                   SUB       WKBLPOPREI    W1BLPOPREI
     C     BLPAPMKZ      WHENEQ    '-'
     C     BLPAPRAR      ANDEQ     *BLANK
     C                   SUB       WKBLPONESU    W1BLPONESU
     C                   SUB       WKBLPOPREI    W1BLPOPREI
     C     BLPAPMKZ      WHENEQ    '+'
     C     BLPAPRAR      ANDNE     *BLANK
     C                   ADD       WKBLPONESU    W1BLPONESU
     C                   ADD       WKBLPOPREI    W1BLPOPREI
     C     BLPAPMKZ      WHENEQ    '-'
     C     BLPAPRAR      ANDNE     *BLANK
     C                   SUB       WKBLPONESU    W1BLPONESU
     C                   SUB       WKBLPOPREI    W1BLPOPREI
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYSAVE        KYBLPO
     C                   MOVEL     D$DAST        BLPO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     'PDIM'        KYTPTA
     C                   MOVEL     TEPDEK        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C     W1BLPOMENG    IFEQ      *ZERO
     C                   Z-ADD     1             W1BLPOMENG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     W1BLPONESU    DIV       W1BLPOMENG    WKN219
     C     WKN219        MULT(H)   TPTNUM        W1BLPONESU
     C     W1BLPOPREI    DIV       W1BLPOMENG    WKN219
     C     WKN219        MULT(H)   TPTNUM        W1BLPOPREI
     C*-------------------------------------------------------------------------
     C     WKBBUP        IFEQ      *ON
     C     WKBUWT        MULT      TPTNUM        WKN219
     C                   ADD       WKN219        W1BLPOPREI
     C                   ADD       WKN219        W1BLPONESU
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     MODEUC        WHENEQ    *ON
     C                   EXSR      TRZABD
     C     W1BLPONESU    MULT      WKSKPZ        WKN219
     C     WKN219        DIV(H)    100           WKN219
     C     WKBLPONESU    SUB       WKN219        WKINPR
     C*
     C     WKTRPASKONTO  WHENEQ    *ON
     C                   EXSR      TRZABD
     C     W1BLPONESU    MULT      WKSKPZ        WKN219
     C     WKN219        DIV(H)    100           WKN219
     C                   SUB       WKN219        WKBLPONESU
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEIL                                                 ***
     C**************************************************************************
     C     UTEIL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '00CU    '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLKOBUDA      TELERE
     C                   Z-ADD     W1BLPOPREI    TELBPB
     C                   Z-ADD     W1BLPONESU    TELBPN
     C     MODEUC        IFEQ      *ON
     C                   Z-ADD     WKINPR        TEINPR
     C                   Z-ADD     BLKOBUDA      TEINDA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '00U     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBST                                                 ***
     C**************************************************************************
     C     ULBST         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      BLPOTENR      KYLTTE
     C                   MOVE      *BLANK        KYLTEZ
     C                   MOVE      AEBWLA        KYLTLA
     C*-------------------------------------------------------------------------
     C                   MOVEA     '00CU    '    CHI
     C                   EXSR      CHLBST
     C*-------------------------------------------------------------------------
     C                   Z-ADD     W1BLPOPREI    LTLBPB
     C                   Z-ADD     W1BLPONESU    LTLBPN
     C     MODEUC        IFEQ      *ON
     C                   Z-ADD     WKINPR        LTINPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '00U     '    CHI
     C                   EXSR      CHLBST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN MATERIALPREIS AUS BEISTELLSTÜCKLISTE                    ***
     C**************************************************************************
     C     ERBBUP        BEGSR
     C*
     C                   Z-ADD     *ZERO         WKBUWT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYTEIL        KYSAVE1
     C                   MOVEL(P)  TEIL          D$DAST1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYBUJH
     C                   MOVEL     BLPOBENR      KYBUBE
     C                   Z-ADD     BLPOBEPO      KYBUPO
     C                   MOVE      *LOVAL        KYBUUP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBBUP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BUFIRM        IFNE      KYBUFI
     C     BUBEJJ        ORNE      KYBUJH
     C     BUBENR        ORNE      KYBUBE
     C     BUBEPO        ORNE      KYBUPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *ON           WKBBUP
     C*--------------------------------------------------------
     C                   MOVE      BUKOTE        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C     TETART        IFEQ      'P'
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBBUP
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     TETART        WHENEQ    '1'
     C     TEDUP2        ANDNE     *ZERO
     C     WKTRPADUP2    ANDEQ     *ON
     C                   Z-ADD     TEDUP2        WKBAPR
     C                   MOVE      TEPDAV        WKBAPD
     C     TETART        WHENEQ    '1'
     C                   Z-ADD     TEVEP2        WKBAPR
     C                   MOVE      TEPDAV        WKBAPD
     C*
     C                   OTHER
     C                   Z-ADD     TEDUPR        WKBAPR
     C                   MOVE      TEPDEK        WKBAPD
     C     WKBAPR        IFEQ      *ZERO
     C     MODJOM        ANDEQ     *ON
     C                   Z-ADD     TESTPR        WKBAPR
     C                   ENDIF
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL     'PDIM'        KYTPTA
     C                   MOVEL     WKBAPD        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKBAPR        MULT      BUMENG        WKN219
     C                   DIV       TPTNUM        WKN219
     C     BUBAMG        IFNE      *ZERO
     C                   DIV       BUBAMG        WKN219
     C                   ENDIF
     C*
     C                   ADD       WKN219        WKBUWT
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHBBUP
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYSAVE1       KYTEIL
     C                   MOVEL     D$DAST1       TEIL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI UBBEP                                                ***
     C**************************************************************************
     C     UBBEP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      ERBLPOBBEP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYEPJH
     C                   MOVEL(P)  BLPOBENR      KYEPBE
     C                   Z-ADD     BLPOBEPO      KYEPPO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C     EPMEIN        IFEQ      TEMEIN
     C                   Z-ADD     WKBLPOBRMG    EPBRMG
     C                   ELSE
     C                   MOVEL     EPTENR        KYTUTE
     C                   MOVEL     EPMEIN        KYTUME
     C                   Z-ADD     WKBLPOBRMG    WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV2V1        EPBRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '30'
     C     EPBEST        OREQ      '35'
     C     EPBEST        OREQ      '36'
     C                   MOVE      '36'          EPBEST
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '38'
     C     EPBEST        OREQ      '40'
     C     EPBEST        OREQ      '50'
     C     EPBEST        OREQ      '60'
     C*
     C     EPBRMG        IFGE      EPGLMG
     C                   MOVE      '60'          EPBEST
     C                   ELSE
     C                   MOVE      '50'          EPBEST
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '45'
     C*
     C     EPBRMG        IFGE      EPGLMG
     C                   MOVE      '60'          EPBEST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBBEP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN BERECHNETE MENGE AUS BLPO                               ***
     C**************************************************************************
     C     ERBLPOBBEP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKBLPOBRMG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYBLPO        KYSAVE
     C                   MOVEL(P)  BLPO          D$DAST
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYBLPOBEJJ
     C                   MOVEL     BLPOBENR      KYBLPOBENR
     C                   Z-ADD     BLPOBEPO      KYBLPOBEPO
     C                   MOVE      *LOVAL        KYBLPOBLJJ
     C                   MOVE      *LOVAL        KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BLPOFIRM      IFGT      KYBLPOFIRM
     C     BLPOBEJJ      ORGT      KYBLPOBEJJ
     C     BLPOBENR      ORGT      KYBLPOBENR
     C     BLPOBEPO      ORGT      KYBLPOBEPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      KYBLKOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*
     C     BLKOBLJJ      IFNE      EXBLPOBLJJ
     C     BLKOBLNR      ORNE      EXBLPOBLNR
     C     BLKORPST      IFLT      '10'
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C*--------------------------------------------------------
     C                   MOVEL     BLPOMEIN      KYTUME
     C                   Z-ADD     BLPOMENG      WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKBLPOMENG
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPABLAT      WHENEQ    'RE '
     C                   ADD       WKBLPOMENG    WKBLPOBRMG
     C     BLPABLAT      WHENEQ    'BA '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C     BLPABLAT      OREQ      'GD '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C                   SUB       WKBLPOMENG    WKBLPOBRMG
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYSAVE        KYBLPO
     C                   MOVEL     D$DAST        BLPO
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
     C                   MOVEL(P)  'TRBLPO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKCFMT
     C*
     C     WKCFMT        IFNE      *ON
     C                   MOVE      *OFF          WKCFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'PREI'        KYTATC
     C                   MOVEL(P)  'OHNEBERE'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAOHBE
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRBBUP'      KYTATA
     C                   MOVEL     'PREIBASEF'   KYTATC
     C                   MOVEL     'TEDUP2'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPADUP2
     C     WKTRPADUP2    IFNE      *ON
     C                   MOVE      *OFF          WKTRPADUP2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'WACD'        KYTATC
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAWACD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRBLKO'      KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'MWDA'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMWDA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODJOM'      KYTATC
     C                   MOVEL(P)  'MODJOM'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODJOM
     C*
     C     MODJOM        IFNE      *ON
     C                   MOVE      *OFF          MODJOM
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
     C                   MOVEL(P)  'MODWAO'      KYTATC
     C                   MOVEL(P)  'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODWAO
     C*
     C     MODWAO        IFNE      *ON
     C                   MOVE      *OFF          MODWAO
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
     C                   MOVEL(P)  'MODEUC'      KYTATC
     C                   MOVEL(P)  'MODEUC'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFEQ      '01'
     C                   MOVE      *ON           MODEUC
     C                   ELSE
     C                   MOVE      *OFF          MODEUC
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRBLPO'      KYTATA
     C                   MOVEL     'SKONTO'      KYTATC
     C                   MOVEL     'TELBPN'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASKONTO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VERTEILUNGSWERT                                         ***
     C**************************************************************************
     C     ERVTWT        BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        WKFFLD
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     EXBLPOKOND    IFEQ      *BLANK
     C                   MOVEL(P)  'EXBLPOKOND'  WKFFLD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXBLPOKOND    DSBLPOKOND
     C*-------------------------------------------------------------------------
     C                   EXSR      ERBLPOVTWT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTBLPO
     C                   MOVEL(P)  WKPROG        RTBLPOPROG
     C                   MOVEL(P)  WKDANA        RTBLPODANA
     C                   MOVEL(P)  WKFFLD        RTBLPOFFLD
     C                   MOVEL(P)  WKFENR        RTBLPOFENR
     C                   MOVEL(P)  W$PA03        RTBLPOPA03
     C                   MOVEL(P)  W$PA04        RTBLPOPA04
     C                   MOVEL(P)  W$PA05        RTBLPOPA05
     C                   MOVEL(P)  W$PA06        RTBLPOPA06
     C                   MOVEL(P)  W$PA07        RTBLPOPA07
     C*-------------------------------------------------------------------------
     C                   Z-ADD     DSBLPOVTWT    RTBLPOVTWT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BWAE                                                 ***
     C**************************************************************************
     C     TRBWAE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     BLPOZUNR      IFNE      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BLPAPMKZ      IFEQ      '-'
     C     BLPAPRAR      ORNE      *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOWEJJ      DUN040
     C                   MOVEA(P)  DUC004        KOM(1)
     C                   MOVEA     BLPOWENR      KOM(5)
     C                   Z-ADD     BLPOBLJJ      DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA     BLPOBLNR      KOM(15)
     C                   Z-ADD     BLPOBEJJ      DUN040
     C                   MOVEA(P)  DUC004        KOM(31)
     C                   MOVEA     BLPOBENR      KOM(35)
     C                   Z-ADD     BLPOBEPO      DUN040
     C                   MOVEA(P)  DUC004        KOM(41)
     C                   MOVEA(P)  KOM           #CKOMM
     C                   MOVEL(P)  'TRBLPO'      #CPGST
     C*
     C                   CALL      'TRBWAE'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI BZUR                                                 ***
     C**************************************************************************
     C     TRBZUR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXBZUR
     C                   CLEAR                   RTBZUR
     C                   MOVEL(P)  'TRBLPO'      EXBZURPGST
     C                   Z-ADD     BLPOBEJJ      EXBZURBEJJ
     C                   MOVEL(P)  BLPOBENR      EXBZURBENR
     C                   Z-ADD     BLPOBEPO      EXBZURBEPO
     C                   Z-ADD     BLPOWEJJ      EXBZURWEJJ
     C                   MOVEL(P)  BLPOWENR      EXBZURWENR
     C                   Z-ADD     BLPOUPOS      EXBZURUPOS
     C*
     C     PCPGST        IFEQ      '4     '
     C                   MOVEL(P)  '00'          EXBZURZUST
     C                   ELSE
     C                   MOVEL(P)  '20'          EXBZURZUST
     C                   Z-ADD     BLPOBLJJ      EXBZURBAJJ
     C                   MOVEL(P)  BLPOBLNR      EXBZURBANR
     C                   ENDIF
     C*
     C                   CALL      'TRBZUR'
     C                   PARM                    EXBZUR
     C                   PARM                    RTBZUR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTBZURPROG    WKPROG
     C                   MOVEL(P)  RTBZURDANA    WKDANA
     C                   MOVEL(P)  RTBZURFFLD    WKFFLD
     C                   MOVEL(P)  RTBZURFENR    WKFENR
     C                   MOVEL(P)  RTBZURPA03    W$PA03
     C                   MOVEL(P)  RTBZURPA04    W$PA04
     C                   MOVEL(P)  RTBZURPA05    W$PA05
     C                   MOVEL(P)  RTBZURPA06    W$PA06
     C                   MOVEL(P)  RTBZURPA07    W$PA07
     C*
     C                   MOVEL(P)  RTBZURRTCD    #CRTCD
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
     C                   MOVE      *OFF          WKTRDZZYKL
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRDN
     C                   MOVEL(P)  WKPGST        EXTRDNPGST
     C                   MOVEL(P)  'TRBLPO'      EXTRDNPGNA
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C                   WRITE     TRBLPO01
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C*-------------------------------------------------------------------------
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TRBLPO02'
     C                   MOVE      '02'          WKIFMT
     C                   EXSR      BILD02
     C*--------------------------------------------------------
     C     EXTRDNDANA    WHENEQ    'TXBE'
     C                   MOVE      *BLANK        EXTBPGCD
     C                   MOVEL(P)  'MCBLPO01'    EXTBDSPF
     C                   EXSR      VTX55
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     EXTRDNPGST    IFEQ      'DIREKT'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C     EXTRDNPGST    IFEQ      'WEITER'
     C                   MOVEL(P)  'WEITER'      WKPGST
     C                   MOVE      *ZERO         WKFENR
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        #CRTCD
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BEWEGUNGSTEXTE                                                    ***
     C**************************************************************************
     C     VTX55         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXTBPGCD      SAVPGST
     C     *LIKE         DEFINE    EXTBDSPF      SAVDSPF
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTBPGCD      SAVPGST
     C                   MOVEL     EXTBDSPF      SAVDSPF
     C                   CLEAR                   EXTXBE
     C                   MOVEL     'TRBLKO'      EXTBCALL
     C                   MOVEL     'AUBLKO'      EXTBAUSW
     C                   MOVEL     SAVPGST       EXTBPGCD
     C                   MOVEL     'BLKO'        EXTBTXAR
     C                   Z-ADD     BLPOBLJJ      EXTBJHJJ
     C                   MOVEL     BLPOBLNR      EXTBAFNR
     C                   Z-ADD     BLPOBLPO      EXTBPOSI
     C                   MOVEL     'TXPO'        EXTBTCDE
     C                   MOVEL     'TRBLPO'      EXTBPROG
     C                   MOVEL     SAVDSPF       EXTBDSPF
     C*--------------------------------------------------------
     C     EXTBPGCD      IFEQ      '3      '
     C                   MOVEL     'BLKO'        EXTBTXAR
     C                   Z-ADD     DSBLPOBLJJ    EXTBJHJJ
     C                   MOVEL     DSBLPOBLNR    EXTBAFNR
     C                   Z-ADD     DSBLPOBLPO    EXTBPOSI
     C                   MOVEL     *BLANK        EXTBTCDE
     C                   MOVEL     *BLANK        EXTBAUSW
     C*
     C                   MOVEL     'BLKO'        EXTBNTXA
     C                   Z-ADD     DSBLPONBLJ    EXTBNJHJ
     C                   MOVEL     DSBLPONBLN    EXTBNAFN
     C                   Z-ADD     DSBLPONBLP    EXTBNPOS
     C     DSBLPONBLP    IFEQ      *ZERO
     C                   Z-ADD     DSBLPOBLPO    EXTBNPOS
     C                   ENDIF
     C                   MOVEL     *BLANK        EXTBNTCD
     C                   ENDIF
     C*--------------------------------------------------------
     C     EXTBPGCD      IFEQ      '4      '
     C                   MOVE      *BLANK        EXTBTCDE
     C                   MOVE      *BLANK        EXTBAUSW
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        #CUEBE
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   EXSR      TRTX55
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VOR-, MEHRWERTSTEUER                                    ***
     C**************************************************************************
     C     TRMWST        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DUC002        KOM(1)
     C                   MOVEA     DUC008        KOM(3)
     C                   MOVEA     DASPCD        KOM(11)
     C                   MOVEA(P)  KOM           #CKOMM
     C                   MOVEL(P)  'ERMFLD'      #CPGST
     C*
     C                   CALL      'TRMWST'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C                   MOVE      '0031'        WKFENR
     C                   ELSE
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA     KOM(03)       DUC011
     C                   Z-ADD     DUN115        TPTNUM
     C                   MOVEA     KOM(20)       TPTTXT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SKONTO                                                  ***
     C**************************************************************************
     C     TRZABD        BEGSR
     C*
     C                   Z-ADD     *ZERO         WKSKPZ
     C*-------------------------------------------------------------------------
     C     EPZABD        IFNE      *BLANK
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     BLKOZABD      KOM(1)
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   MOVEL     'ERZABD'      #CPGST
     C                   CALL      'TRZABD'
     C                   PARM                    EXTR02
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC005
     C                   TESTN                   DUC005               98
     C     *IN(98)       IFNE      '1'
     C                   MOVE      *ZERO         DUC005
     C                   END
     C                   Z-ADD     DUN052        WKSKPZ
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        WKTRPADUP2
     C     *LIKE         DEFINE    WKC001        WKBBUP
     C     *LIKE         DEFINE    TEDUPR        WKBAPR
     C     *LIKE         DEFINE    TEPDAV        WKBAPD
     C     *LIKE         DEFINE    DUN156        WKBUWT
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
     C     *LIKE         DEFINE    WKC001        MODJOM
     C     *LIKE         DEFINE    WKC001        MODMAS
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        MODHAW
     C     *LIKE         DEFINE    WKC001        MODEUC
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTRPAWACD      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAMWDA      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPASKONTO
     C     *LIKE         DEFINE    WKC001        WKINF1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C     *LIKE         DEFINE    WKC001        WKIN32
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFM04
     C     *LIKE         DEFINE    WKC001        WKBBEP
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKDATE          + 7
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
     C     *LIKE         DEFINE    BLPO          WKBLPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYBLPOBLJJ    OFBLPOBLJJ
     C     *LIKE         DEFINE    KYBLPOBLNR    OFBLPOBLNR
     C     *LIKE         DEFINE    KYBLPOBLPO    OFBLPOBLPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOBLPO      DSBLPOBLPO
     C     *LIKE         DEFINE    BLPONESU      DSBLPONESU
     C     *LIKE         DEFINE    BLPOKOW1      DSBLPOKOWT
     C     *LIKE         DEFINE    BLPOBEJJ      DSBLPOBEJJ
     C     *LIKE         DEFINE    BLPOBENR      DSBLPOBENR
     C     *LIKE         DEFINE    BLPOBEPO      DSBLPOBEPO
     C     *LIKE         DEFINE    BLPOWEJJ      DSBLPOWEJJ
     C     *LIKE         DEFINE    BLPOWENR      DSBLPOWENR
     C     *LIKE         DEFINE    BLPOUPOS      DSBLPOUPOS
     C     *LIKE         DEFINE    BLPOZUJJ      DSBLPOZUJJ
     C     *LIKE         DEFINE    BLPOZUNR      DSBLPOZUNR
     C     *LIKE         DEFINE    BLPOZUPO      DSBLPOZUPO
     C*
     C     *LIKE         DEFINE    BLPOBLPO      DSBLPONBLP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AEKOW1        WKKOWT
     C     *LIKE         DEFINE    AENESU        WKWERT
     C     *LIKE         DEFINE    AEMENG        WKMENG
     C     *LIKE         DEFINE    AEMEIN        WKMEIN
     C     *LIKE         DEFINE    TEGWNT        WKGWNT
     C*
     C     *LIKE         DEFINE    BLPOPRAR      WKTRPAOHBE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTBLPOPROG    WKPROG
     C     *LIKE         DEFINE    RTBLPODANA    WKDANA
     C     *LIKE         DEFINE    RTBLPOFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN134        WKBLPOMENG
     C     *LIKE         DEFINE    DUN219        WKBLPONESU
     C     *LIKE         DEFINE    DUN219        WKBLPOPREI
     C     *LIKE         DEFINE    DUN134        W1BLPOMENG
     C     *LIKE         DEFINE    DUN219        W1BLPONESU
     C     *LIKE         DEFINE    DUN219        W1BLPOPREI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOMENG      WKBLPOBRMG
     C     *LIKE         DEFINE    BLPOKOW1      WKDIFF
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEINPR        WKINPR
     C     *LIKE         DEFINE    DUN052        WKSKPZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOMENG      WKBLMG
     C     *LIKE         DEFINE    BLPOMENG      W1BLMG
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
     C                   MOVEL(P)  'TRBLPO'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTBLPOW1
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTBLPOW2
     C     WKIFMT        WHENEQ    '04'
     C                   WRITE     CTBLPOW3
     C     WKIFMT        WHENEQ    '05'
     C                   WRITE     CTBLPOW1
     C     WKIFMT        WHENEQ    '06'
     C                   WRITE     CTBLPOW2
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTBLPOW2
     C                   OTHER
     C                   WRITE     TRBLPOCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    '02'
     C                   WRITE     CTBLPOW1
     C     WKIFMT        WHENEQ    '03'
     C                   WRITE     CTBLPOW2
     C     WKIFMT        WHENEQ    '04'
     C                   WRITE     CTBLPOW3
     C     WKIFMT        WHENEQ    '05'
     C                   WRITE     CTBLPOW1
     C     WKIFMT        WHENEQ    '06'
     C                   WRITE     CTBLPOW2
     C     WKIFMT        WHENEQ    'K1'
     C                   WRITE     CTBLPOW2
     C                   OTHER
     C                   WRITE     TRBLPOCT
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
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBBPA
     C/COPY QCPYSRC,CHBLKO
     C/COPY QCPYSRC,CHBLPO
     C/COPY QCPYSRC,CHBLPA
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHBWPM
     C/COPY QCPYSRC,CHBZUR
     C/COPY QCPYSRC,CHLBSD
     C/COPY QCPYSRC,CHLBST
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,MCMWST
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CSTRPB
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,MCTEIL
     C/COPY QCPYSRC,MCTEUF
     C/COPY QCPYSRC,MCTRPC
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCZOTN
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,TRTX55
     C/COPY QCPYSRC,TRWAUM
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,VTRTPPDIM
     C/COPY QCPYSRC,CHBBUP
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
