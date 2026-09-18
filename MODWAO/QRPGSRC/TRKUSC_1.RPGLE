     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE  Aufruf Verwalten Kundenstamm Schilling Fibu
     H**************************************************************************
     H*  Copyright 1995/98 by trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  ----------------------------------------------------------------------
     H*  Erstellt: SZ 24.11.1995
     H*  ----------------------------------------------------------------------
     H*  Änderung: SZ 08.10.2009 Übernahme in MODWAO, bei Aufruf über den
     H*            Client Übergabe der Daten im Batch, keine Anzeige der
     H*            Formate von Schilling.
     H*  Änderung: AL 22.12.2009 Projekt 3267 Ersetzen *DATE durch WKTDAT
     H*  Änderung: SZ 18.01.2011 Statistikfelder füllen
     H*  Änderung: SZ 20.01.2011 wenn die Debitornummer abweicht kein Update
     H*            auf das Konto in der Fibu!
     H*  Änderung: SZ 03.01.2013 Batch/Interaktiv/Client über C#JOBA abfragen
     H*  Änderung: SZ 26.02.2013 Personenkonto für Mandant '08' und '52' mit
     H*            führender '0' übergeben
     H*  Änderung: SZ 08.03.2013 Übergabe für Mandant '08' und '52' sofort unter
     H*            binden. Das Feld für das Personenkonto ist in der alten
     H*            Schnittstelle nur 8-stellig.
     H*  Änderung: SZ 08.03.2013 Anpassung SADR anhand SASS/X04SADRRCV
     H*            Anpassung SKDY anhand SASS/X04FKDBRCV, PGMCAL auf X04F130
     H*            geändert.
     H*  Änderung: SZ 08.05.2013 Sprachcode 'N' nach 'H' übersetzen
     H*            Änderung vom 08.03.2013 rückgängig gemacht, da in der neuen
     H*            releasesicheren Schnittstelle von Schilling das Personenkonto
     H*            jetzt 9-stellig ist.
     H*            3. Parameter für Aufruf X04F130
     H*  Änderung: SZ 15.07.2013 Anpassung für Schilling Release 2.10, Projekt
     H*            9235, SADR Basis SFBS/X06FADRRCV, SKDY Basis SFBS/X06FPKTRCV,
     H*            Callprogramm ist X06F130
     H*  Änderung: SZ 17.07.2013 Anforderung Herr Steinbach, Übergabe ZABD für
     H*            Mandant '08' und '52' (jetzt 3-stellig)
     H*  Änderung: SZ 06.09.2013 Anforderung Frau Uytdehaag, Übergabe UStId auch
     H*            für Inland.
     H*  Änderung: SZ 05.12.2014 Das passende Programm zu den X06... Strukturen
     H*            ist X06F31 (und nicht X06F130).
     H*  Änderung: SZ 09.09.2015 Projekt 11614, Anpassungen Firma 61 Dometic AT
     H*  Änderung: SZ 29.11.2019 Kreditlimit nicht mehr übergeben. Daher auch
     H*            das Kennzeichen Kreditlimit nicht mehr mit 'J' füllen.
     H*  Änderung: JK 27.10.2020 Pj 16061 Dometic länderkennz. AT und BE für Schilling
     H*            zu A und B konvertieren
     H*  Änderung: JK 17.12.2020 Pj 16061 Sprachcode N soll nicht mehr nach H umgesetzt werden
     H*            Änderung vom Mai 2013 ausgesternt
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus der Kundenstammverwaltung aufgerufen
     F*  und erhält über die Datenstruktur KUND Daten, die an den
     F*  Schilling-Kundenstamm weitergereicht werden.
     F*
     F*  SINP erstellt aus SASS/X05SINP
     F*  SADR erstellt aus SFBS/X06FADRRCV
     F*  SKDY erstellt aus SFBS/X06FPKTRCV
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FTRKUSCFM  CF   E             WORKSTN USROPN
     FFQPSKTO   UF A E             DISK    USROPN
     F                                     RENAME(QPSATZ:QPSATZ1)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D ORT             S              1    DIM(40)                              AGB. LD/PLZ/ORT
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDDB          E DS                  INZ
     D KYKDDB        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUEG          E DS                  INZ
     D KYKUEG        E DS                  INZ
     D*
     D KUND          E DS
     D KYKUND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRUE          E DS                  INZ
     D KYTRUE        E DS                  INZ
     D*
     D VEZU          E DS                  INZ
     D KYVEZU        E DS                  INZ
     D*
     D ZKUN          E DS                  INZ
     D KYZKUN        E DS                  INZ
     D*
     D**************************************************************************
     D***  KONSTANTE                                                         ***
     D**************************************************************************
     D PGMCAL          C                   CONST('X06F131')
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXWAUM        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D SINP          E DS                  INZ
     D SADR          E DS                  INZ
     D SKDY          E DS                  INZ
     D FQPSKTO1      E DS                  INZ EXTNAME(FQPSKTO)
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
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    KUND
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON                                          ANFANGSROUTINE
     C                   MOVE      *ON           WKI000
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C*   ländercodes umschlüsseln
     C                   SELECT
     C                   WHEN      KDPOLD = 'AT'
     C                   EVAL      KDPOLD = 'A '
     C                   WHEN      KDPOLD = 'BE'
     C                   EVAL      KDPOLD = 'B '
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      FFIRM
     C                   MOVE      *OFF          WKIEND
     C                   EXSR      SCHILL
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*
     C                   IF        WKIEND      = *ON
     C                   EVAL      WKIFMT      = '00'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   MOVE      C#IN28        *IN28
     C*-------------------------------------------------------------------------
     C                   IF        (C#JOBA     = '1'           OR
     C                             C#JOBA      = '2')          AND
     C                             WKIEND      = *OFF
     C                   EXSR      OFQPSKTO
     C                   EVAL      WKIFMT      = '00'
     C                   ENDIF
     C**************************************************************************
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   EXSR      AUFFOR
     C                   OPEN      TRKUSCFM                             98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     TRKUSCFM                             98
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN                         DATUMFELDER
     C                   Z-ADD     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAPROG        WKCHPN                         PROGR
     C                   MOVEL(P)  DABIBL        WKCHPL                         BIBL.
     C                   MOVEL(P)  DAUSER        WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDDBFIRM                     KDDB
     C                   MOVEL(P)  DAFIRM        KYKEFI                         KUEG
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYVZFI                         VEZU
     C                   MOVEL(P)  DAFIRM        KYKZFI                         ZKUN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        WKJDAT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN30
     C                   MOVE      *OFF          *IN31
     C                   MOVE      *IN30         WKIN30
     C                   MOVE      *IN31         WKIN31
     C*-------------------------------------------------------------------------
     C                   MOVE      '00'          WKIFMT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN ÜBERSCHRIFTEN FÜR FORMAT                              ***
     C**************************************************************************
     C     AUFFOR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAUSSP        KYUESP                         ÜBERSCHRIFT
     C                   MOVEL(P)  'UEB'         KYUEMA                         PROGRAMMNAME
     C                   MOVEL(P)  'KUSC'        KYUEMN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRUE
     C*
     C                   MOVEA     UEMSGT        W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         KYUEMA                         KONSTANTE
     C                   MOVEL(P)  'POFA'        KYUEMN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRUE
     C                   MOVEL(P)  UEMSGT        TXPOFA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DER PARAMETERWERTE                                      ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'LAND'        KYTATC                         STAMMLAND
     C                   MOVEL(P)  'LAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKSTLD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'POLD'        KYTATC                         POSTALISCHES
     C                   MOVEL(P)  'POLD'        KYTAPA                         LAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKPOLD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTAPA
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'ABFR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     TAPCDE        ANDNE     *BLANK
     C                   MOVEL(P)  TAPCDE        WKABFR
     C                   ELSE
     C                   MOVE      *OFF          WKABFR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'DBNR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     TAPCDE        ANDNE     *BLANK
     C                   MOVEL(P)  TAPCDE        WKIDBN
     C                   ELSE
     C                   MOVE      *OFF          WKIDBN
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
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART DEBITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTDE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTDE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'BUHA'        KYTATC                         ÜBERGABE
     C                   MOVEL(P)  'STKT'        KYTAPA                         STATISTIKKUNDE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASTKT
     C*
     C     WKTRPASTKT    IFNE      *ON
     C                   MOVE      *OFF          WKTRPASTKT
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
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C                   MOVEA     KOM(01)       WKWKNR
     C                   MOVEA     KOM(04)       WKDBNR
     C                   MOVEA     KOM(14)       WKLFBK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUFROUTINE                                                    ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKABFR        IFEQ      *ON
     C                   MOVE      '01'          WKIFMT
     C                   ELSE
     C                   MOVE      '00'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        FMT
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
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
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5            INT.PROGR.STAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN31                         RETTEN INDICAT.
     C     *LIKE         DEFINE    WKC001        WKIN41          +39            IND. LÖSCHEN
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKIEND                         IND.ENDE
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKC011          +10            WORKFELD
     C     *LIKE         DEFINE    WKC001        WKC013          +12            WORKFELD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFIR          + 3            FIRMA
     C     *LIKE         DEFINE    WKC001        WKABFR                         IND.ABFRAGE
     C     *LIKE         DEFINE    WKC001        WKIDBN                         IND.DEBITORNR.
     C     *LIKE         DEFINE    WKC001        WKKTDE
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        WKTRPASTKT
     C     *LIKE         DEFINE    WKC001        WKTRPAMAND      + 1            MANDANT FIBU
     C     *LIKE         DEFINE    WKC001        TXPOFA          + 9            TEXT POSTFACH
     C     *LIKE         DEFINE    WKC001        WKWKNR          + 2            WERK
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX 0
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKNFIR          + 4            NACH FIRMA
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    #CKOMM        WKKOMM
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KDPOLD        WKPOLD                         POSTAL.LAND
     C     *LIKE         DEFINE    KDLAND        WKSTLD                         STAMMLAND
     C     *LIKE         DEFINE    KDDBKD        WKDBNR                         DEBITOR
     C     *LIKE         DEFINE    KDKDNR        WKKDNR                         KUNDENNUMMER
     C     *LIKE         DEFINE    KDLIFN        WKLFBK                         LFNR. B. KUNDEN
     C     *LIKE         DEFINE    KDWACD        WKSTWC                         WÄHRUNGSCODE
     C     *LIKE         DEFINE    KDJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    KDKLSU        WKKLSU                         KREDITLIMIT
     C     *LIKE         DEFINE    KDHVSU        WKHVSU                         HERMESVERSICHERUNG
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    VZVTN1        WKVTNR                         VERTRETER
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
     C     WKIFMT        DOWEQ     '01'                                         SENDEN BILD-
     C                   WRITE     TRKUSC01                                     SCHIRMFORMAT
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*--------------------------------------------------------
     C                   MOVEA     WKIN41        *IN(41)                        LÖSCHEN CURSOR
     C                   MOVE      *OFF          *IN22                          LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   READ      TRKUSC01                             9899    LESEN DES BILDS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     *IN98         WHENEQ    *ON                                          FEHLER
     C     *IN99         OREQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     *IN03         WHENEQ    *ON                                          F3=VERLASSEN
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     *IN04         WHENEQ    *ON                                          F4=AUSWAHL
     C                   EXSR      B01F04
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     *IN12         WHENEQ    *ON                                          F12=ABBRECHEN
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     *IN13         WHENEQ    *ON                                          INFO-SYSTEM
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      B01PR                                        PRÜFUNGEN
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      FFIRM
     C                   EXSR      SCHILL
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
     C                   MOVE      WKIN30        *IN30                          EINGABE SPERRE
     C                   MOVE      WKIN31        *IN31
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DSNFIR                         IMMER LÖSCHEN
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR                         FEHLER LÖSCHEN
     C                   MOVEA     WKIN41        *IN(41)                        CURSER LÖSCHEN
     C                   MOVE      *ON           *IN41                          CURSER SETZEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILD01                                           ***
     C**************************************************************************
     C     B01F04        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *ON           *IN22
     C                   MOVEA     WKIN41        *IN(41)
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           *IN41
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSNFIR'
     C                   MOVE      '0050'        WKFENR
     C                   MOVE      *ON           *IN41
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILD01                                          ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     DSNFIR        IFEQ      *ZERO
     C                   MOVE      *ON           *IN41
     C                   MOVE      '0031'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN FIRMA BUCHHALTUNG                                          ***
     C**************************************************************************
     C     FFIRM         BEGSR
     C*
     C                   CLEAR                   SADR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         SAFIRM                         Firma
     C*
     C                   SELECT
     C     MODWAO        WHENEQ    *ON
     C                   MOVE      WKTRPAMAND    SAFIRM
     C     WKIFIR        WHENEQ    'FIRM'
     C     WKIFMT        ANDEQ     '00'
     C                   TESTN                   DAFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      DAFIRM        SAFIRM
     C                   ENDIF
     C*
     C     WKIFIR        WHENEQ    'WERK'
     C     WKIFMT        ANDEQ     '00'
     C                   TESTN                   WKWKNR               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKWKNR        SAFIRM
     C                   ENDIF
     C*
     C     WKIFMT        WHENEQ    '01'
     C                   Z-ADD     DSNFIR        SAFIRM
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE-ROUTINE SCHILLING BUCHHALTUNG                              ***
     C**************************************************************************
     C     SCHILL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SINP
     C                   EVAL      UIANWV      = 'F'
     C                   EVAL      UIPROG      = 'TRKUSC'
     C                   EVAL      UISPCD      = DASPCD
     C                   EVAL      UIUSER      = DAUSER
     C*
     C                   SELECT
     C                   WHEN      DAUSER = 'TRDSZ'
     C                   EVAL      UIUSER = 'SFBPGMR'
     C                   WHEN      DAUSER = 'WENTKER1'
     C                   EVAL      UIUSER = 'SFBPGMR'
     C                   WHEN      DAUSER = 'FEITH1'
     C                   EVAL      UIUSER = 'SFBPGMR'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SKDY
     C*
     C                   MOVE      *BLANK        WKKDNR
     C                   MOVE      *BLANK        WKVTNR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFIR        WHENEQ    'FIRM'
     C     KDDBKD        ANDNE     *BLANK
     C                   MOVEL(P)  KDDBKD        WKKDNR
     C                   MOVEL(P)  KDLIFN        WKLFBK
     C     WKIFIR        WHENEQ    'WERK'
     C     WKDBNR        ANDNE     *BLANK
     C                   MOVEL(P)  WKDBNR        WKKDNR
     C                   OTHER
     C                   MOVEL(P)  KDKDNR        WKKDNR
     C                   MOVEL(P)  KDLIFN        WKLFBK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKKDNR     <> KDKDNR
     C                   EVAL      WKIEND      = *ON
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        ORT
     C*-------------------------------------------------------------------------
     C     KDPOFA        IFNE      *BLANK
     C     KDPOLN        ANDNE     *BLANK
     C                   EVAL      I2          = %LEN(%TRIMR(KDPOLN))
     C                   ELSE
     C                   EVAL      I2          = %LEN(%TRIMR(KDPOLZ))
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ADD       2             I2
     C*-------------------------------------------------------------------------
     C     KDPOLD        IFEQ      *BLANK                                       POSTALISCHES
     C     KDPOLD        OREQ      WKPOLD                                       LAND VORHANDEN
     C*--------------------------------------------------------
     C     I2            IFGT      2
     C                   MOVEA     KDPOLZ        ORT(01)                        AUSGABE PLZ
     C                   MOVEA     KDWORT        ORT(I2)                        UND ORT
     C                   ELSE
     C                   MOVEA     KDWORT        ORT(01)                        ODER NUR ORT
     C                   ENDIF                                                  WENN KEINE PLZ
     C*--------------------------------------------------------                 EINGEGEBEN
     C                   ELSE
     C*--------------------------------------------------------
     C     I2            IFGT      2
     C**                 MOVEA     KDPOLD        ORT(01)                        FÜR AUSLAND
     C                   MOVEA     KDPOLZ        ORT(01)                        AUSGABE PLZ
     C                   MOVEA     KDWORT        ORT(I2)                        UND ORT
     C                   ELSE
     C                   MOVEA     KDWORT        ORT(01)                        ODER NUR ORT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        SAADNR                         Adressnummer
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKIDBN      = *ON           AND
     C                             (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')
     C                   EVAL      SAADNR      = WKKTDE + '0'
     C                                         + %SUBST(WKKDNR : 1 : 8)
     C                   WHEN      WKIDBN      = *ON
     C                   MOVEL(P)  WKKTDE        WKC011
     C                   MOVE      WKKDNR        WKC011
     C                   MOVEL(P)  WKC011        SAADNR
     C                   OTHER
     C                   MOVEL(P)  WKKDNR        SAADNR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     WKPGST        WHENEQ    'W     '                                     NEUANLAGE
     C                   MOVE      *BLANK        SATAST                         Tastencode
     C                   MOVE      *BLANK        SAADNV                         Adressnummer von
     C                   MOVE      *BLANK        SAFIL1                         Leerfeld
     C                   MOVE      *BLANK        SAANRD                         Anrede
     C*
     C                   IF        C#JOBA      = '0'
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C                   MOVEL(P)  'LESEN'       SAFUNK                         Funktion
     C                   CALL      PGMCAL                               9899
     C                   PARM                    SINP
     C                   PARM                    SADR                           ALTEN SATZ IN
     C                   PARM                    SKDY                           SCHILLING ZEIGEN
     C                   ENDIF
     C*
     C                   IF        KDSPCD     <> DASPCD
     C                   MOVEL(P)  KDSPCD        SASPCD                         Sprache
     C                   ENDIF
     C*
     C**                 IF        SASPCD      = 'N'
     C**                 EVAL      SASPCD      = 'H'                            Holländisch
     C**                 ENDIF
     C*
     C                   MOVE      *BLANK        SAFIL2                         Leerfeld
     C                   EXSR      FSKDY
     C                   EXSR      FFKDB
     C*
     C     SARCOD        IFNE      ' '
     C                   MOVEL(P)  'J'           SAWNEU                         Neuanlage
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPGST        WHENEQ    'U     '                                     UPDATE
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C*
     C                   IF        KDSPCD     <> DASPCD
     C                   MOVEL(P)  KDSPCD        SASPCD                         Sprache
     C                   ENDIF
     C*
     C**                 IF        SASPCD      = 'N'
     C**                 EVAL      SASPCD      = 'H'                            Holländisch
     C**                 ENDIF
     C*
     C                   MOVEL(P)  KDSABE        FKSABE                         Sachbearbeiter
     C                   MOVE      'V'           FKKZSB                         KZ Sachbearbeiter
     C                   EXSR      FSKDY
     C*--------------------------------------------------------
     C     WKPGST        WHENEQ    'L     '                                     LÖSCHEN
     C                   MOVE      'L'           SAAENA                         Änderungsart
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     WKPGST        IFNE      'L     '
     C                   EXSR      FSADR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        (C#JOBA     = '1'           OR
     C                             C#JOBA      = '2')
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     SATAST        IFEQ      *BLANK
     C     SATAST        OREQ      '00'
     C     SATAST        OREQ      '12'
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C                   MOVEL(P)  'SCHREIBEN'   SAFUNK                         Funktion
     C                   CALL      PGMCAL                               9899
     C                   PARM                    SINP
     C                   PARM                    SADR
     C                   PARM                    SKDY
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN DATENSTRUKTUR PARAMETER ADRESSE                            ***
     C**************************************************************************
     C     FSADR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     32            SAMAXL                         max.Länge Adr.-Zeile
     C                   MOVEL(P)  'J'           SAFRMD                         Aufruf aus Fremdanw.
     C                   TIME                    DUN060
     C                   MOVEL(P)  DUC006        SAJZEI                         Änderungszeit
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDNAM1        SANAM1                         Name 1
     C                   MOVEL(P)  KDNAM2        SANAM2                         Name 2
     C                   MOVEL(P)  KDNAM3        SANAM3                         Name 3
     C*
     C     KDPOFA        IFNE      *BLANK
     C                   MOVEA(P)  TXPOFA        W99(01)
     C                   MOVEA     KDPOFA        W99(10)
     C                   MOVEA(P)  W99(01)       SAPOFA                         Postfach
     C                   ELSE
     C                   MOVE      *BLANK        SAPOFA
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDPOLN        SAPLZP                         PLZ Postfach
     C                   EVAL      SASTRA      = %TRIM(KDSTRA)                  Straße
     C                   MOVEA(P)  ORT           SAPOLZ                         PLZ/Ort
     C*
     C     KDPOLD        IFNE      WKPOLD
     C                   MOVEL(P)  KDPOLD        SAPOLD                         Land
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDMCBG        SAMATC                         Matchcode
     C                   MOVEL(P)  KDTLNR        SATELF                         Telefon
     C                   MOVEL(P)  KDTXNR        SATELX                         Telex
     C                   MOVEL(P)  KDTFNR        SATLFA                         Telefax
     C*
     C                   MOVE      *BLANK        SAKZAN                         KZ Anrede
     C                   MOVE      'J'           SAKZN1                         KZ Name 1
     C                   MOVE      'J'           SAKZN2                         KZ Name 2
     C                   MOVE      'J'           SAKZN3                         KZ Name 3
     C                   MOVE      'J'           SAKZPF                         KZ Postfach
     C                   MOVE      'J'           SAKZPP                         KZ PLZ Postfach
     C                   MOVE      'J'           SAKZST                         KZ Straße
     C                   MOVE      'J'           SAKZPZ                         KZ PLZ Ort
     C                   MOVE      'J'           SAKZLD                         KZ Land
     C                   MOVE      'J'           SAKZSP                         KZ Sprache
     C                   MOVE      'J'           SAKZMC                         KZ Matchcode
     C                   MOVE      'J'           SAKZTL                         KZ Telefon
     C                   MOVE      'J'           SAKZTX                         KZ Telex
     C                   MOVE      'J'           SAKZFX                         KZ Telefax
     C                   MOVE      *BLANK        SAKZBX                         KZ BTX
     C                   MOVE      *BLANK        SAKZM2                         KZ Matchcode 2
     C                   MOVE      *BLANK        SAKZML                         KZ e-Mail
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN DATENSTRUKTUR PARAMETER KUNDENSTAMM                        ***
     C**************************************************************************
     C     FSKDY         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'VE3'         KYVZBG                         ERMITTELN
     C                   MOVE      *BLANK        KYVZLD                         VERTRETER
     C                   MOVEL(P)  WKKDNR        KYVZKL
     C                   MOVE      *BLANK        KYVZVS
     C                   MOVE      *BLANK        KYVZKG
     C                   MOVE      *BLANK        KYVZPG
     C                   MOVE      *BLANK        KYVZVG
     C                   MOVE      *BLANK        KYVZPZ
     C                   MOVE      *BLANK        KYVZTE
     C                   MOVE      *BLANK        KYVZWC
     C                   Z-ADD     WKJDAT        KYVZDA
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHVEZU
     C*
     C     CHI(5)        IFEQ      'J'
     C     VZFIRM        ANDEQ     KYVZFI
     C     VZBEGR        ANDEQ     KYVZBG
     C     VZLAND        ANDEQ     KYVZLD
     C     VZKDLI        ANDEQ     KYVZKL
     C     VZVSNR        ANDEQ     KYVZVS
     C     VZKDLG        ANDEQ     KYVZKG
     C     VZPRGR        ANDEQ     KYVZPG
     C     VZVKGB        ANDEQ     KYVZVG
     C     VZPOLZ        ANDEQ     KYVZPZ
     C     VZTENR        ANDEQ     KYVZTE
     C                   MOVEL(P)  VZVTN1        WKVTNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKNAM        SKKTBZ                         Kontobezeichng.
     C                   MOVE      *BLANK        SKDIKZ                         diverses Kto. KZ
     C*--------------------------------------------------------
     C     KDWACD        IFEQ      WKSTWC
     C                   MOVE      *BLANK        SKWHRG
     C                   MOVE      *BLANK        SKKZWG
     C                   ELSE
     C                   MOVEL(P)  KDWACD        SKWHRG                         Währung
     C                   MOVE      'V'           SKKZWG                         KZ Währung
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        SKVBKZ                         verb. Unternehmen
     C                   MOVE      *BLANK        SKVBMG                         Verbandsmitgliednr.
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKIDBN      = *ON           AND
     C                             KDVBKD     <> *BLANK        AND
     C                             (DAFIRM     = '08'          OR
     C                             DAFIRM      = '52')
     C                   EVAL      SKVBNR      = WKKTDE + '0'                   Verbandsnummer
     C                                         + %SUBST(KDVBKD : 1 : 8)
     C                   WHEN      WKIDBN      = *ON           AND
     C                             KDVBKD     <> *BLANK
     C                   EVAL      SKVBNR      = WKKTDE + %SUBST(KDVBKD : 1 : 8)
     C                   OTHER
     C                   MOVE      *BLANK        SKVBNR
     C                   ENDSL
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM      = '01'          OR
     C                             DAFIRM      = '61'          OR
     C                             DAFIRM      = '55'
     C                   MOVE      *BLANK        SKZABD
     C                   OTHER
     C                   MOVEL(P)  KDZABD        SKZABD                         Zahlungsbedingung
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     KDKLSU        WKKLSU
     C                   EXSR      EKLSU
     C*
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  KDWACD        WAUMWACV
     C                   MOVEL(P)  WKSTWC        WAUMWACN
     C                   Z-ADD     KDKLSU        WAUMWBTV
     C                   Z-ADD     WKJDAT        WAUMDATE
     C                   MOVE      '1'           WAUMKUKZ
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKKLSU
     C                   ENDIF
     C*
     C                   Z-ADD     KDHVSU        WKHVSU
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  KDWACD        WAUMWACV
     C                   MOVEL(P)  WKSTWC        WAUMWACN
     C                   Z-ADD     KDHVSU        WAUMWBTV
     C                   Z-ADD     WKJDAT        WAUMDATE
     C                   MOVE      '1'           WAUMKUKZ
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKHVSU
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     KDVALT        SKVATG                         Valutatage
     C                   MOVE      *BLANK        SKBONI                         Bonität
     C*
     C                   MOVE      *BLANK        SKLIGP                         Limitkontrollgruppe
     C                   MOVE      *BLANK        SKLID1                         Limitdatum 1
     C**   WKKLSU        DIV(H)    1000          SKLI01                         Limit 1
     C                   Z-ADD     *ZERO         SKLI01
     C                   Z-ADD     *ZERO         SKLI02                         Limit 2
     C                   MOVE      *BLANK        SKLID2                         Limitdatum 2
     C                   Z-ADD     *ZERO         SKLIA2                         Limitart 2
     C                   MOVE      *BLANK        SKLIR2                         Limitreferenz 2
     C*--------------------------------------------------------
     C                   EVAL      KYKDEWKDNR  = WKKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C                   EVAL      KYTPTA      = 'KOST'
     C                   EVAL      KYTPTC      = KDEWKSST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SKSKD1
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      DAFIRM  = '01' OR
     C                             DAFIRM      = '55'
     C                   MOVEL(P)  KDKDGR        SKSKD1                         Statistikkdnr. 1
     C                   MOVEL(P)  KDNIGB        SKSKD2                         Statistikkdnr. 2
     C                   MOVEL(P)  KDKSTC        SKSKD3                         Statistikkdnr. 3
     C                   WHEN      DAFIRM = '61'
     C                   EVAL      SKSKD1 = %SUBST(SKSKD1:1:5)                  Statistikkdnr. 1
     C                   EVAL      SKSKD2 = '999'                               Statistikkdnr. 2
     C                   EVAL      SKSKD3 = *BLANK                              Statistikkdnr. 3
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SKBBNR                         Bundes-Betriebsnr.
     C                   Z-ADD     *ZERO         SKBBSN                         Betriebsstättennr.
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        SKUSTL                         USt Landeskennz.
     C                   MOVE      *BLANK        SKUSTI                         USt Identnummer
     C                   EXSR      EUSTI
     C*--------------------------------------------------------
     C                   EXSR      EILNR
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        SKUIPR                         USt Id geprüft
     C                   MOVE      *BLANK        SKUIDA                         USt Id geprüft am
     C                   MOVEL(P)  WKLFBK        SKKTOK                         Kto. beim Kunden
     C                   MOVE      *BLANK        SKMAEP                         Mahnempfänger
     C                   MOVEL(P)  WKVTNR        SKVTNR                         Vertreter
     C                   MOVE      *BLANK        SKLI2G                         Limit 2 gültig ab
     C                   MOVE      *BLANK        SKEEPF                         Einzugempfänger
     C                   Z-ADD     *ZERO         SKZIEL                         KVZiel
     C*--------------------------------------------------------
     C                   MOVE      'V'           SKKZKB                         KZ Kontobezeichnung
     C                   MOVE      *BLANK        SKKZDI                         KZ div. Konto
     C                   MOVE      *BLANK        SKKZVB                         KZ verb. Unternehmen
     C                   MOVE      *BLANK        SKKZVN                         KZ Verbandsnummer
     C                   MOVE      *BLANK        SKKZVM                         KZ Verbandsmitgliedn
     C                   MOVE      'V'           SKKZZB                         KZ Zahlungsbedingung
     C                   MOVE      'J'           SKKZVA                         KZ Valutatage
     C                   MOVE      *BLANK        SKKZBO                         KZ Bonität
     C                   MOVE      *BLANK        SKKZLG                         KZ Limitkontrollgrp
     C                   MOVE      *BLANK        SKKZL1                         KZ Limit 1
     C                   MOVE      *BLANK        SKKZD1                         KZ Limitdatum 1
     C                   MOVE      *BLANK        SKKZL2                         KZ Limit 2
     C                   MOVE      *BLANK        SKKZD2                         KZ Limitdatum 2
     C                   MOVE      *BLANK        SKKZLA                         KZ Limitart 2
     C                   MOVE      *BLANK        SKKZLR                         KZ Limitreferenz 2
     C                   MOVE      'V'           SKKZS1                         KZ Statistikkdnr. 1
     C                   MOVE      'V'           SKKZS2                         KZ Statistikkdnr. 2
     C                   MOVE      'V'           SKKZS3                         KZ Statistikkdnr. 3
     C                   MOVE      *BLANK        SKKZBB                         KZ Bundes-Betriebsnr
     C                   MOVE      *BLANK        SKKZBS                         KZ Betriebsstättennr
     C*--------------------------------------------------------
     C     SKUSTI        IFEQ      *BLANK
     C                   MOVE      *BLANK        SKKZUL
     C                   MOVE      *BLANK        SKKZUI
     C                   ELSE
     C                   MOVE      'J'           SKKZUL                         KZ USt Landeskennz.
     C                   MOVE      'J'           SKKZUI                         KZ USt Identnummer
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        SKKZIP                         KZ USt Id geprüft
     C                   MOVE      *BLANK        SKKZID                         KZ USt Id geprüft am
     C                   MOVE      'V'           SKKZKK                         KZ Kto. beim Kunden
     C                   MOVE      *BLANK        SKKZME                         KZ Mahnempfänger
     C                   MOVE      *BLANK        SKKZLD                         KZ Limit 2 gültig ab
     C                   MOVE      *BLANK        SKKZEP                         KZ Einzugempfänger
     C                   MOVE      *BLANK        SKKZKV                         KZ KVZiel
     C*--------------------------------------------------------
     C     WKVTNR        IFNE      *BLANK
     C                   MOVE      'V'           SKKZVT                         KZ Vertreter
     C                   ELSE
     C                   MOVE      *BLANK        SKKZVT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN DATENSTRUKTUR PARAMETER KUNDENSTAMM                        ***
     C**************************************************************************
     C     FFKDB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        FKSKSL                         Sammelkontoschlüssel
     C                   MOVE      *BLANK        FKBLZL                         Bankleitzahl
     C                   MOVE      *BLANK        FKBKTO                         Bankkonto
     C                   MOVE      *BLANK        FKEZGA                         Einzugart
     C                   MOVE      *BLANK        FKBESB                         Bankeinz. SaBe
     C                   Z-ADD     *ZERO         FKSKTG                         Skontotoleranztage
     C**                 MOVE      *BLANK        FKLFNR                         Lieferant
     C                   MOVE      *BLANK        FKVRKZ                         Verrechnungskennz.
     C                   MOVE      *BLANK        FKMAKZ                         Mahnkennzeichen
     C                   MOVE      *BLANK        FKMASB                         Mahnsachbearbeiter
     C                   MOVE      *BLANK        FKZIKZ                         Zinsrechnungkennz.
     C                   Z-ADD     *ZERO         FKZITG                         zinsfreie Tage
     C                   MOVEL(P)  KDSABE        FKSABE                         Sachbearbeiter
     C                   MOVE      *BLANK        FKMGKZ                         Meldung bei BuchungK
     C                   MOVE      *BLANK        FKMGTX                         Meldungtextschlüssel
     C**                 MOVE      *BLANK        FKKMKZ                         Kontomerkkennzeichen
     C                   MOVE      *BLANK        FKMIBP                         bebuchen ab Periode
     C                   MOVE      *BLANK        FKMABP                         bebuchen bis Periode
     C                   MOVE      *BLANK        FKBKLD                         Bankland
     C*
     C                   MOVE      *BLANK        FKKZSL                         KZ Sammelkontoschlüs
     C                   MOVE      *BLANK        FKKZBZ                         KZ Bankleitzahl
     C                   MOVE      *BLANK        FKKZKT                         KZ Bankkonto
     C                   MOVE      *BLANK        FKKZEZ                         KZ Einzugsart
     C                   MOVE      *BLANK        FKKZBS                         KZ Bankeinz. SaBe
     C                   MOVE      *BLANK        FKKZST                         KZ Skontoleranztage
     C**                 MOVE      *BLANK        FKKZLF                         KZ Lieferant
     C                   MOVE      *BLANK        FKKZVR                         KZ Verrechnungskz.
     C                   MOVE      *BLANK        FKKZMA                         KZ Mahnkennzeichen
     C                   MOVE      *BLANK        FKKZMG                         KZ Mahngebührenkz.
     C                   MOVE      *BLANK        FKKZMS                         KZ Mahnsachbearbeite
     C                   MOVE      *BLANK        FKKZZI                         KZ Zinsrechnungkz.
     C                   MOVE      *BLANK        FKKZZT                         KZ zinsfreie Tage
     C                   MOVE      'V'           FKKZSB                         KZ Sachbearbeiter
     C                   MOVE      *BLANK        FKKZBK                         KZ Meldung bei BchgK
     C                   MOVE      *BLANK        FKKZTX                         KZ Meldungtextschl.
     C**                 MOVE      *BLANK        FKKZMK                         KZ Kontomerkkennz.
     C                   MOVE      *BLANK        FKKZAP                         KZ bebuchen ab Perio
     C                   MOVE      *BLANK        FKKZBP                         KZ bebuchen bis Peri
     C                   MOVE      *BLANK        FKKZBL                         KZ Bankland
     C                   MOVE      *BLANK        FKFIL2                         Leerfeld 2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN UST-ID.                                                 ***
     C**************************************************************************
     C     EUSTI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     KDLAND        IFNE      WKSTLD                                       UST-ID-NUMMER
     C     DAFIRM        OREQ      '08'
     C     DAFIRM        OREQ      '52'
     C                   MOVEL(P)  KDKDNR        KYKEKD
     C                   MOVEL(P)  KDLAND        KYKELD
     C                   MOVE      *BLANK        KYKEVS
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUEG
     C                   MOVEL(P)  KEUSTI        SKUSTL                         KEUSTI = 15 STELLEN
     C                   MOVE      KEUSTI        WKC013
     C                   MOVEL(P)  WKC013        SKUSTI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN ILN-Nr.                                                 ***
     C**************************************************************************
     C     EILNR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTLEN KREDITLIMIT                                             ***
     C**************************************************************************
     C     EKLSU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BATCH-SCHNITTSTELLE                                        ***
     C**************************************************************************
     C     OFQPSKTO      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   OPEN      FQPSKTO
     C                   CLEAR                   FQPSKTO1
     C*-------------------------------------------------------------------------
     C                   EVAL      QPSTAT      = *BLANK                         Satzstatus
     C                   EVAL      QPRSNR      = *BLANK                         Release-Nr
     C                   EVAL      QPFA        = SAFIRM                         Firma
     C                   EVAL      QPKTO       = SAADNR                         Kontonummer
     C*
     C                   SELECT
     C                   WHEN      WKPGST      = 'L'
     C                   EVAL      QPAEN       = 'L'                            Änderungsart
     C                   OTHER
     C                   EVAL      QPAEN       = *BLANK
     C                   ENDSL
     C*
     C                   EVAL      QPANR       = SAANRD                         Anrede
     C                   EVAL      QPNAM1      = SANAM1                         Name 1
     C                   EVAL      QPNAM2      = SANAM2                         Name 2
     C                   EVAL      QPNAM3      = SANAM3                         Name-3/Ortsteil
     C                   EVAL      QPPF        = SAPOFA                         Postfach
     C                   EVAL      QPPLZP      = SAPLZP                         Postleitzahl für PF
     C                   EVAL      QPSTR       = SASTRA                         Strasse
     C                   EVAL      QPPLOR      = SAPOLZ                         PLZ/Ort
     C                   EVAL      QPLAND      = SAPOLD                         Land
     C                   EVAL      QPSPR       = SASPCD                         Sprache
     C                   EVAL      QPADSU      = SAMATC                         Suchbegriff
     C                   EVAL      QPTEL       = SATELF                         Telefon-Nr
     C                   EVAL      QPTLX       = SATELX                         Telex-Nr
     C                   EVAL      QPFAX       = SATLFA                         Telefax-Nr
     C                   EVAL      QPBTX       = SABTXN                         BTX-Nummer
     C                   EVAL      QPADS2      = *BLANK                         Suchbegriff-2 Adress
     C                   EVAL      QPEMN1      = *BLANK                         E-Mail-Nummer 1
     C                   EVAL      QPEMN2      = *BLANK                         E-Mail-Nummer 2
     C                   EVAL      QPITNR      = *BLANK                         Internet-Adresse
     C                   EVAL      QPTIT       = *BLANK                         Titel in Adresse
     C                   EVAL      QPEMKZ      = *BLANK                         E-Mail versenden J,N
     C                   EVAL      QPKTBZ      = SKKTBZ                         Kontobezeichnung
     C                   EVAL      QPKTDV      = SKDIKZ                         Kennz. diverses Kont
     C                   EVAL      QPWG        = SKWHRG                         Währung
     C                   EVAL      QPVERB      = SKVBKZ                         Kennz. verbundende U
     C                   EVAL      QPVBNR      = SKVBNR                         Verbands-Nummer
     C                   EVAL      QPVBMG      = SKVBMG                         Verbands-Mitgliedsnu
     C                   EVAL      QPZBD       = SKZABD                         Zahlungsbedingung
     C                   EVAL      QPQVLT      = SKVATG                         Valutatage
     C                   EVAL      QPBONI      = SKBONI                         Bonität
     C                   EVAL      QPLKGR      = SKLIGP                         Limit-Kontrollgruppe
     C                   EVAL      QPQL1       = SKLI01                         Kreditlimit-1
     C                   EVAL      QPL1JT      = SKLID1                         Kreditlimit-1 gültig
     C                   EVAL      QPQL2       = SKLI02                         Kreditlimit-2
     C                   EVAL      QPL2JT      = SKLID2                         Kreditlimit-2 gültig
     C                   EVAL      QPL2AR      = SKLIA2                         Limit-2 Art
     C                   EVAL      QPL2NR      = SKLIR2                         Limit-2 Referenznumm
     C                   EVAL      QPRKJT      = *BLANK                         Rückwirkend vers. ab
     C                   EVAL      QPL2JV      = *BLANK                         Kreditlimit-2 gültig
     C                   EVAL      QPEXKT      = *BLANK                         externe Kontonummer
     C                   EVAL      QPSK1       = SKSKD1                         Stat-SL Debitor 1
     C                   EVAL      QPSK2       = SKSKD2                         Stat-SL Debitor 2
     C                   EVAL      QPSK3       = SKSKD3                         Stat-SL Debitor 3
     C                   EVAL      QPSSL1      = *BLANK                         Stat-SL Kreditor 1
     C                   EVAL      QPSSL2      = *BLANK                         Stat-SL Kreditor 2
     C                   EVAL      QPSSL3      = *BLANK                         Stat-SL Kreditor 3
     C                   EVAL      QPBBN       = SKBBNR                         Bundesbetriebsnummer
     C                   EVAL      QPBBS       = SKBBSN                         Bundes-Betriebsstätt
     C                   EVAL      QPSTLD      = SKUSTL                         Umsatzsteuer-Länderk
     C                   EVAL      QPSTIN      = SKUSTI                         Umsatzsteuer-IdentNr
     C                   EVAL      QPSTOK      = SKUIPR                         UmsatzsteueridentNr
     C                   EVAL      QPIDJT      = SKUIDA                         Ident-Nr geprüft am
     C**SZ               EVAL      QPZAEM      = SKZAEP                         abw. Zahlungsempfäng
     C                   EVAL      QPMAEM      = SKMAEP                         Mahnempfänger
     C                   EVAL      QPVTR       = SKVTNR                         Vertreter
     C                   EVAL      QPEZEM      = SKEEPF                         Abw. Einzugsempfänge
     C                   EVAL      QPKVZL      = SKZIEL                         Kreditziel in Monate
     C**SZ               EVAL      QPILN       = SFILNN                         Internationale Lokat
     C                   EVAL      QPIBAN      = *BLANK                         International Bank A
     C                   EVAL      QPEUJT      = *BLANK                         Euro ab Datum
     C                   EVAL      QPSMKT      = FKSKSL                         Sammelkonto-Schlüsse
     C                   EVAL      QPBKLD      = FKBKLD                         Land der Bankverbind
     C                   EVAL      QPBLZ       = FKBLZL                         Bankleitzahl
     C                   EVAL      QPBKKO      = FKBKTO                         Bankkonto-Nr
     C                   EVAL      QPBKNR      = *BLANK                         Banknummer
     C                   EVAL      QPAVSL      = *BLANK                         AZV-Vorbesetzungssch
     C                   EVAL      QPEZAR      = FKEZGA                         Einzugsart
     C                   EVAL      QPZVSB      = *BLANK                         Sachbearbeiter Zahlu
     C                   EVAL      QPBESB      = FKBESB                         Sachbearbeiter Banke
     C                   EVAL      QPQSTT      = FKSKTG                         Toleranztage Skonto
     C                   EVAL      QPRFKT      = *BLANK                         Referenz-Konto-Nr.
     C                   EVAL      QPVRRK      = *BLANK                         Verrechnung Debitor/
     C**SZ               EVAL      QPZAAR      = FKZAAT                         Zahlungsart
     C**SZ               EVAL      QPZAKZ      = FKZAKZ                         Zahlungs-Kennz.
     C                   EVAL      QPMNKZ      = FKMAKZ                         Mahn-Kennzeichen
     C                   EVAL      QPMNSB      = *BLANK                         Sachbearbeiter Mahnu
     C                   EVAL      QPMNGR      = *BLANK                         Mahngruppe
     C                   EVAL      QPMVKZ      = *BLANK                         Mahnungen über Verba
     C                   EVAL      QPEVKZ      = *BLANK                         Bankeinzug über Verb
     C                   EVAL      QPZNKZ      = FKZIKZ                         Zinsrechnung
     C                   EVAL      QPQZTT      = *ZERO                          Zinstoleranztage
     C                   EVAL      QPSB        = FKSABE                         Sachbearbeiter
     C**SZ               EVAL      QPNEBU      = FKNBKZ                         Kennz. Netto buchen
     C                   EVAL      QPMSKZ      = FKMGKZ                         Kz. Meldung bei Buch
     C                   EVAL      QPMSSL      = FKMGTX                         Schlüssel für Meldun
     C                   EVAL      QPMIJP      = FKMIBP                         bebuchen ab BuPer
     C                   EVAL      QPMXJP      = FKMABP                         bebuchen bis BuPer
     C                   EVAL      QPVWZB      = *BLANK                         Verwendungszweck-Sch
     C                   EVAL      QPVWZZ      = *BLANK                         Verwendungszweck-Sch
     C                   EVAL      QPQDPZ      = FKDKPZ                         Delkredere-Prozentsa
     C                   EVAL      QPDCBK      = *BLANK                         Delkredere von Brutt
     C                   EVAL      QPRLKZ      = *BLANK                         Rechnungsliste
     C                   EVAL      QPEZEL      = *BLANK                         Einzugsermächtigung
     C                   EVAL      QPRFFA      = *ZERO                          Referenz-Firma
     C                   EVAL      QPBBGK      = *BLANK                         Begleitschreiben Ban
     C                   EVAL      QPZBGK      = *BLANK                         Begleitschreiben Zah
     C                   EVAL      QPVBR0      = *BLANK                         Regulierer
     C                   EVAL      QPKZIP      = *BLANK                         Aus Import
     C                   EVAL      QPSTDN      = *BLANK                         SteuerNr beim Finanz
     C                   EVAL      QPCOSC      = *BLANK                         Konditionsschema
     C                   EVAL      QPBIC       = *BLANK                         BIC-Adresse
     C                   EVAL      QPZVVK      = *BLANK                         Zahlung über Verband
     C                   EVAL      QPSSTF      = *BLANK                         Sicherheits-Stufe
     C                   EVAL      QPKTIN      = *BLANK                         Kontoinhaber
     C                   EVAL      QPCOZK      = *BLANK                         Kondition im ZV abre
     C                   EVAL      QPCOBK      = *BLANK                         Kondition im BE abre
     C**                 EVAL      QPLAK0      = *BLANK                         letzte Auskunft vom
     C                   EVAL      QPFIL2      = *BLANK
     C                   EVAL      QPBOKZ      = *BLANK                         Kennzeichen BO-Wechs
     C                   EVAL      QPLCKZ      = *BLANK                         Kennzeichen LCR-Wech
     C                   EVAL      QPSCKZ      = *BLANK                         Scheckdruck
     C                   EVAL      QPUBWK      = *BLANK                         Überweisungsdruck
     C                   EVAL      QPESRR      = *BLANK                         ESR-ReferenzNr-Forma
     C                   EVAL      QPTNNR      = *ZERO                          TeilnehmerNr (Schwei
     C                   EVAL      QPKDID      = *ZERO                          Kunden-ID-Nr (bei Ba
     C                   EVAL      QPPOKT      = *ZERO                          Postscheck-Konto (Sc
     C                   EVAL      QPPOKB      = *ZERO                          Bank-Postscheck-Kont
     C                   EVAL      QPSDLD      = *ZERO                          SAD-Ländercode (Schw
     C                   EVAL      QPPOAL      = *BLANK                         Postscheck-Kto Ausla
     C                   EVAL      QPFEKE      = *BLANK                         Kennung Empfänger
     C                   EVAL      QPKVRA      = *ZERO                          Kostenverrechnungssc
     C                   EVAL      QPFIL3      = *BLANK
     C                   EVAL      QPAEUS      = *BLANK                         Benutzer bei ltz Änd
     C                   EVAL      QPAEWS      = *BLANK                         Bildschirm-ID letzte
     C                   EVAL      QPAEJT      = *BLANK                         Datum letzte Änderun
     C*-------------------------------------------------------------------------
     C                   WRITE     QPSATZ1
     C                   CLOSE     FQPSKTO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT                         MSG-ART (F,I)
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9            ÜBERGABEPARAMET
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9            ÜBERGABEPARAMET
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'                           98
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
     C                   MOVEL     'TRKUSC'      PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           *IN90                          SUBFILE
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'                                         WINDOW
     C                   OTHER
     C                   WRITE     TRKUSCCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          *IN90
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'                                         WINDOW
     C                   OTHER
     C                   WRITE     TRKUSCCT
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
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUEG
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,CHKDDB
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRUE
     C/COPY QCPYSRC,CHVEZU
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDAUM
     C/COPY QCPYSRC,TRWAUM
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     C*
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
