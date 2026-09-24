     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 1998')
     H**************************************************************************
     H/TITLE  Verwalten Lieferantenstamm Schilling-FIBU
     H**************************************************************************
     H*  Copyright 1995/98 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  ----------------------------------------------------------------------
     H*  Erstellt: SZ 23.02.1998
     H*  ----------------------------------------------------------------------
     H*  Änderung: SZ 26.04.2002 Namen angepaßt
     H*  Änderung: SZ 29.10.2002 Anforderung Leicher, Mandantennummer aus Para-
     H*            meter FIRM/BUHA/MAND übergeben
     H*  Änderung: TB 21.02.2005 MODFEY ]BERGABE VON POLD NUR WENN NICHT
     H*            *BLANK UND NICHT IDENTISCH MIT PARAMETER FIRM / POLD / POLD
     H*  Änderung: TB 10.06.2005 AUFRUF IM ÀNDERUNGSMODUS ANALOG KUND ANGEPASST
     H*  Änderung: SC 10.02.2009 FAWO Service 20090210-007
     H*            FIRM/BUHA/MAND aktviert unter MODFWO
     H*  Änderung: SZ 24.04.2009 Projekt 5598, HAWA, Übergabe Daten im Batch,
     H*            wenn Aufruf über den Client erfolgt.
     H*  Änderung: SZ 29.07.2009 FAWO Service 20090723-008, SATAST ist bei Neu-
     H*            anlage jetzt offenbar nicht mehr *BLANK sondern '00'.
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm wird aus der Lieferantenstammverwaltung aufgerufen und
     F*  erhält über die Datenstruktur LIEF Daten, die in den Kontenstamm der
     F*  Schilling-FIBU gefüllt werden.
     F*
     F*  SADR erstellt aus SASS/X03SADRRCV
     F*  FLFB erstellt aus SFBS/X03FLFBRCV
     F*
     F*  Bei einer Neuanlage sieht der Anwender direkt das Bild 'NEUANLAGE' von
     F*  Schilling.
     F*  Bei einer Änderung werden zuerst die in Schilling vorhandenen Daten ge-
     F*  zeigt. Bei F3 erfolgt keine weitere Aktion, bei F12 oder Eingabetatste
     F*  wird in den Änderungsmodus verzweigt.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FISCHLIEFFMCF   E             WORKSTN USROPN
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
     D LFKR          E DS                  INZ
     D KYLFKR        E DS                  INZ
     D*
     D LIEF          E DS
     D KYLIEF        E DS                  INZ
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
     D**************************************************************************
     D***  KONSTANTE                                                         ***
     D**************************************************************************
     D PGMCAL          C                   CONST('*LIBL/X03F140')
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D SADR          E DS                  INZ
     D FLFB          E DS                  INZ
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
     D**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR02
     C                   PARM                    LIEF
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON                                          ANFANGSROUTINE
     C                   MOVE      *ON           WKI000
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C                   EVAL      C#JOBA = '1'                                 ERSTÜBERNAHME
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
     C                   OPEN      ISCHLIEFFM                           98
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C                   CLOSE     ISCHLIEFFM                           98
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
     C                   MOVEL(P)  DAFIRM        KYLFKRFIRM                     LFKR
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
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
     C                   MOVEL(P)  'LFSC'        KYUEMN
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
     C                   MOVEL(P)  'POLD'        KYTATC                         POSTALISCHES
     C                   MOVEL(P)  'POLD'        KYTAPA                         LAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKPOLD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'MODFWO'      KYTATC
     C                   MOVEL(P)  'MODFWO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODFWO
     C*
     C     MODFWO        IFNE      *ON
     C                   MOVE      *OFF          MODFWO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMWÄHRUNG FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKSTWC
     C*--------------------------------------------------------
     C     WKSTWC        IFEQ      *BLANK
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'WACD'        KYTATC                         STAMMWÄHRUNG
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
     C                   MOVEL(P)  TAPCDE        WKABFR
     C*
     C     WKABFR        IFNE      *ON
     C                   MOVE      *OFF          WKABFR
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
     C                   MOVEL(P)  'FIRM'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     CHI(5)        IFEQ      'J'
     C     TAPCDE        ANDNE     *BLANK
     C                   MOVEL(P)  TAPCDE        WKFIRM
     C                   ELSE
     C                   MOVEL(P)  'FIRM'        WKFIRM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         KONTOART KREDITOR
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'KTKR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL(P)  TAPCDE        WKKTKR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'BUHA'        KYTATC
     C                   MOVEL(P)  'STLF'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASTLF
     C*
     C     WKTRPASTLF    IFNE      *ON
     C                   MOVE      *OFF          WKTRPASTLF
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
     C                   MOVEL(P)  'FIRM'        KYTATA                         MANDANT FIBU
     C                   MOVEL(P)  'BUHA'        KYTATC                         ERMITTELN
     C                   MOVEL(P)  'MAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAMAND
     C*
     C     WKTRPAMAND    IFEQ      *BLANK
     C                   MOVEL(P)  '000'         WKTRPAMAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN, OB
     C                   MOVEL(P)  'MODLEI'      KYTATC                         LEICHER AKTIV IST
     C                   MOVEL(P)  'MODLEI'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODLEI
     C*
     C     MODLEI        IFNE      *ON
     C                   MOVE      *OFF          MODLEI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN, OB
     C                   MOVEL(P)  'MODFEY'      KYTATC                         LEICHER AKTIV IST
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
     C                   MOVE      *OFF          WKIOKZ
     C                   ELSE
     C                   MOVE      '00'          WKIFMT
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        FMT
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
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
     C                   MOVEA     KOM(04)       WKKRNR
     C                   MOVEA     KOM(14)       WKKDBL
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
     C     *LIKE         DEFINE    WKC001        MODFWO
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFIRM          + 3            FIRMA
     C     *LIKE         DEFINE    WKC001        WKABFR                         IND.ABFRAGE
     C     *LIKE         DEFINE    WKC001        WKIKRN                         IND.KREDITORNR.
     C     *LIKE         DEFINE    WKC001        WKTRPASTLF                     IND.STATISTIKLIEF.
     C     *LIKE         DEFINE    WKC001        WKTRPAZABD
     C     *LIKE         DEFINE    WKC001        WKTRPAMAND      + 2            MANDANT FIBU
     C     *LIKE         DEFINE    WKC001        WKKTKR
     C     *LIKE         DEFINE    WKC001        TXPOFA          + 9            TEXT POSTFACH
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODLEI
     C     *LIKE         DEFINE    WKC001        MODSUD
     C     *LIKE         DEFINE    WKC001        MODFEY
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
     C     *LIKE         DEFINE    LFPOLD        WKPOLD
     C     *LIKE         DEFINE    LFWKNR        WKWKNR                         WERK
     C     *LIKE         DEFINE    LFKRLF        WKKRNR                         KREDITOR
     C     *LIKE         DEFINE    LFLFNR        WKLFNR                         LIEFERANT
     C     *LIKE         DEFINE    LFKDBL        WKKDBL                         KDNR. B. LIEFERANT
     C     *LIKE         DEFINE    LFWACD        WKSTWC                         WÄHRUNGSCODE
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
     C                   WRITE     ISCHLF01                                     SCHIRMFORMAT
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG                          AUFBEREITEN
     C                   ENDCS                                                  NACHRICHTEN
     C*--------------------------------------------------------
     C                   MOVEA     WKIN41        *IN(41)                        LÖSCHEN CURSOR
     C                   MOVE      *OFF          *IN22                          LÖSCHEN CURSOR
     C*-------------------------------------------------------------------------
     C                   READ      ISCHLF01                             9899    LESEN DES BILDS
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
     C                   Z-ADD     *ZERO         DSNFIR                         IMMER LÖSCHEN
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
     C*--------------------------------------------------------
     C     MODLEI        WHENEQ    *ON
     C     MODSUD        OREQ      *ON
     C     MODFWO        OREQ      *ON
     C                   MOVE      WKTRPAMAND    SAFIRM
     C*--------------------------------------------------------
     C     WKFIRM        WHENEQ    'FIRM'
     C     WKIFMT        ANDEQ     '00'
     C                   TESTN                   DAFIRM               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      DAFIRM        SAFIRM
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKFIRM        WHENEQ    'WERK'
     C     WKIFMT        ANDEQ     '00'
     C                   TESTN                   WKWKNR               97
     C*
     C     *IN97         IFEQ      *ON
     C                   MOVE      WKWKNR        SAFIRM
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        WHENEQ    '01'
     C                   Z-ADD     DSNFIR        SAFIRM
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE-ROUTINE SCHILLING BUCHHALTUNG                              ***
     C**************************************************************************
     C     SCHILL        BEGSR
     C*
     C                   CLEAR                   FLFB
     C*
     C                   MOVE      *BLANK        WKLFNR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKFIRM        WHENEQ    'FIRM'
     C     LFKRLF        ANDNE     *BLANK
     C                   MOVEL(P)  LFKRLF        WKLFNR
     C                   MOVEL(P)  LFKDBL        WKKDBL
     C     WKFIRM        WHENEQ    'WERK'
     C     WKKRNR        ANDNE     *BLANK
     C                   MOVEL(P)  WKKRNR        WKLFNR
     C                   OTHER
     C                   MOVEL(P)  LFLFNR        WKLFNR
     C                   MOVEL(P)  LFKDBL        WKKDBL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        WKLFNR     <> LFLFNR
     C                   EVAL      WKIEND      = *ON
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I2
     C                   MOVE      *BLANK        ORT
     C                   MOVE      *BLANK        W99
     C*-------------------------------------------------------------------------
     C     LFPOFA        IFNE      *BLANK
     C     LFPOLN        ANDNE     *BLANK
     C                   MOVEA     LFPOLN        W99(01)
     C                   ELSE
     C                   MOVEA     LFPOLZ        W99(01)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     10            I2                             LÄNGE DER
     C*--------------------------------------------------------                 POSTLEITZAHL
     C     W99(I2)       DOWEQ     *BLANK
     C                   SUB       1             I2
     C*
     C     I2            IFLT      1                                            INDEX-FEHLER
     C                   LEAVE                                                  VERMEIDEN....
     C                   ENDIF
     C*
     C                   ENDDO
     C*--------------------------------------------------------
     C                   ADD       2             I2
     C*-------------------------------------------------------------------------
     C     LFPOLD        IFEQ      *BLANK                                       POSTALISCHES
     C     LFPOLD        OREQ      WKPOLD                                       LAND VORHANDEN
     C*--------------------------------------------------------
     C     I2            IFGT      2
     C                   MOVEA     LFPOLZ        ORT(01)                        AUSGABE PLZ
     C                   MOVEA     LFWORT        ORT(I2)                        UND ORT
     C                   ELSE
     C                   MOVEA     LFWORT        ORT(01)                        ODER NUR ORT
     C                   ENDIF                                                  WENN KEINE PLZ
     C*--------------------------------------------------------                 EINGEGEBEN
     C                   ELSE
     C*--------------------------------------------------------
     C     I2            IFGT      2
     C**                 MOVEA     LFPOLD        ORT(01)                        FÜR AUSLAND
     C                   MOVEA     LFPOLZ        ORT(01)                        AUSGABE PLZ
     C                   MOVEA     LFWORT        ORT(I2)                        UND ORT
     C                   ELSE
     C                   MOVEA     LFWORT        ORT(01)                        ODER NUR ORT
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     WKPGST        WHENEQ    'W     '                                     SCHREIBEN
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C                   MOVE      *BLANK        SATAST                         Tastencode
     C                   MOVE      *BLANK        SAADNV                         Adressnummer von
     C                   MOVE      *BLANK        SAFIL1                         Leerfeld
     C                   MOVE      *BLANK        SAANRD                         Anrede
     C*
     C     LFSPCD        IFNE      DASPCD
     C                   MOVEL(P)  LFSPCD        SASPCD                         Sprache
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        SABTXN                         BTX
     C                   MOVE      *BLANK        SAFIL2                         Leerfeld
     C                   EXSR      FFLFB
     C*--------------------------------------------------------
     C     WKPGST        WHENEQ    'U     '                                     UPDATE
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C*
     C     LFSPCD        IFNE      DASPCD
     C                   MOVEL(P)  LFSPCD        SASPCD                         Sprache
     C                   ENDIF
     C*
     C                   MOVEL(P)  LFSBAD        FLSABE                         Sachbearbeiter
     C                   MOVE      'J'           FLKZSB                         KZ Sachbearbeiter
     C                   EXSR      FFLFB
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
     C                   MOVE      *BLANK        SAADNR                         Adressnummer
     C*--------------------------------------------------------
     C     WKIKRN        IFEQ      *ON
     C                   MOVEL(P)  WKKTKR        WKC011
     C                   MOVE      WKLFNR        WKC011
     C                   MOVEL(P)  WKC011        SAADNR
     C                   ELSE
     C                   MOVEL(P)  WKLFNR        SAADNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        C#JOBA = '0' AND
     C                             WKPGST <> 'L     '
     C                   MOVE      'Z'           SAAENA                         Änderungsart
     C                   CALL      PGMCAL                               9899
     C                   PARM                    SADR
     C                   PARM                    FLFB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        C#JOBA = '0' AND
     C                             (SATAST = *BLANK OR
     C                             SATAST = '00' OR
     C                             SATAST = '12')
     C                   MOVE      ' '           SAAENA                         Änderungsart
     C                   CALL      PGMCAL                               9899
     C                   PARM                    SADR
     C                   PARM                    FLFB
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
     C                   MOVEL(P)  LFNAM1        SANAM1                         Name 1
     C                   MOVEL(P)  LFNAM2        SANAM2                         Name 2
     C                   MOVEL(P)  LFNAM3        SANAM3                         Name 3
     C*
     C     LFPOFA        IFNE      *BLANK
     C                   MOVEA(P)  TXPOFA        W99(01)
     C                   MOVEA     LFPOFA        W99(10)
     C                   MOVEA(P)  W99(01)       SAPOFA                         Postfach
     C                   ELSE
     C                   MOVE      *BLANK        SAPOFA
     C                   ENDIF
     C*
     C                   MOVEL(P)  LFPOLN        SAPLZP                         PLZ Postfach
     C                   MOVEL(P)  LFSTRA        SASTRA                         Straße
     C                   MOVEA(P)  ORT           SAPOLZ                         PLZ/Ort
     C*
     C                   MOVEL(P)  LFPOLD        SAPOLD                         LAND
     C     MODFEY        IFEQ      *ON
     C     LFPOLD        IFEQ      WKPOLD
     C     LFPOLD        OREQ      *BLANKS
     C                   MOVE      *BLANKS       SAPOLD
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEL(P)  LFMCBG        SAMATC                         Matchcode
     C                   MOVEL(P)  LFTLNR        SATELF                         Telefon
     C                   MOVEL(P)  LFTXNR        SATELX                         Telex
     C                   MOVEL(P)  LFTFNR        SATLFA                         Telefax
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
     C                   MOVE      *BLANK        SAFIL3                         Leerfeld
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN DATENSTRUKTUR PARAMETER LIEFERANTENSTAMM                   ***
     C**************************************************************************
     C     FFLFB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LFKNAM        SFKTBZ                         Kontobezeichng.
     C                   MOVE      *BLANK        SFDIKZ                         diverses Kto. KZ
     C*--------------------------------------------------------
     C     LFWACD        IFEQ      WKSTWC
     C                   MOVE      *BLANK        SFWHRG
     C                   MOVE      *BLANK        SFKZWG
     C                   ELSE
     C                   MOVEL(P)  LFWACD        SFWHRG                         Währung
     C                   MOVE      'V'           SFKZWG                         KZ Währung
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKDBL        SFKTLF                         Konto beim Lieferant
     C                   MOVE      *BLANK        SFVBKZ                         verb. Unternehmen
     C                   Z-ADD     LFVALT        SFVATG                         Valutatage
     C*--------------------------------------------------------
     C     WKTRPAZABD    IFEQ      *ON
     C                   MOVE      LFZABD        SFZABD
     C                   ELSE
     C                   MOVEL(P)  LFZABD        SFZABD                         Zahlungsbedingung
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SFLI01                         Limit 1
     C                   Z-ADD     *ZERO         SFLI02                         Limit 2
     C*--------------------------------------------------------
     C     WKTRPASTLF    IFEQ      *ON
     C                   MOVEL(P)  LFSTLF        SFSTL1                         Statistiklfnr. 1
     C                   MOVE      'V'           SFKZS1                         KZ Statistiklfnr. 1
     C                   ELSE
     C                   MOVE      *BLANK        SFSTL1
     C                   MOVE      *BLANK        SFKZS1
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        SFSTL2                         Statistiklfnr. 2
     C                   MOVE      *BLANK        SFSTL3                         Statistiklfnr. 3
     C                   Z-ADD     *ZERO         SFBBNR                         Bundes-Betriebsnr.
     C                   Z-ADD     *ZERO         SFBBSN                         Betriebsstättennr.
     C                   MOVE      *BLANK        SFUSTL                         USt Landeskennz.
     C                   MOVE      *BLANK        SFUSTI                         USt Identnummer
     C                   MOVE      *BLANK        SFUIPR                         USt Id geprüft
     C                   MOVE      *BLANK        SFUIDA                         USt Id geprüft am
     C                   MOVE      *BLANK        SFZAEP                         Zahl.empfänger
     C                   MOVE      *BLANK        SFILNN                         Int. Lokationsnr.
     C*
     C                   MOVE      'V'           SFKZKB                         KZ Kontobezeichnung
     C                   MOVE      *BLANK        SFKZDI                         KZ div. Konto
     C                   MOVE      'J'           SFKZKL                         KZ Konto beim Lief.
     C                   MOVE      *BLANK        SFKZVB                         KZ verb. Unternehmen
     C                   MOVE      'J'           SFKZVA                         KZ Valutatage
     C                   MOVE      'V'           SFKZZB                         KZ Zahlungsbedingung
     C                   MOVE      *BLANK        SFKZL1                         KZ Limit 1
     C                   MOVE      *BLANK        SFKZL2                         KZ Limit 2
     C                   MOVE      *BLANK        SFKZS2                         KZ Statistiklfnr. 2
     C                   MOVE      *BLANK        SFKZS3                         KZ Statistiklfnr. 3
     C                   MOVE      *BLANK        SFKZBB                         KZ Bundes-Betriebsnr
     C                   MOVE      *BLANK        SFKZBS                         KZ Betriebsstättennr
     C                   MOVE      *BLANK        SFKZUL                         KZ USt Landeskennz.
     C                   MOVE      *BLANK        SFKZUI                         KZ USt Identnummer
     C                   MOVE      *BLANK        SFKZIP                         KZ USt Id geprüft
     C                   MOVE      *BLANK        SFKZID                         KZ USt Id geprüft am
     C                   MOVE      *BLANK        SFKZME                         KZ Zahl.empfänger
     C                   MOVE      *BLANK        SFKZIL                         KZ Int. Lokationsnr.
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        FLSKSL                         Sammelkontoschlüssel
     C                   MOVE      *BLANK        FLBLZL                         Bankleitzahl
     C                   MOVE      *BLANK        FLBKTO                         Bankkonto
     C                   MOVE      *BLANK        FLBESB                         Zahlverk. SaBe
     C                   Z-ADD     *ZERO         FLSKTG                         Skontotoleranztage
     C                   MOVE      *BLANK        FLZAAT                         Zahlart
     C                   MOVE      *BLANK        FLZAKZ                         Zahlkz.
     C                   MOVE      *BLANK        FLKDNR                         Kundennr.
     C                   MOVE      *BLANK        FLVRKZ                         Verrechnungskennz.
     C                   MOVEL(P)  LFSBAD        FLSABE                         Sachbearbeiter
     C                   MOVE      *BLANK        FLNBKZ                         Netto-Buchung Kz.
     C                   MOVE      *BLANK        FLMGKZ                         Meldung bei BuchungK
     C                   MOVE      *BLANK        FLMGTX                         Meldungtextschlüssel
     C                   MOVE      *BLANK        FLKMKZ                         Kontomerkkennzeichen
     C                   MOVE      *BLANK        FLMIBP                         bebuchen ab Periode
     C                   MOVE      *BLANK        FLMABP                         bebuchen bis Periode
     C                   MOVE      *BLANK        FLBKLD                         Bankland
     C                   Z-ADD     *ZERO         FLDKPZ                         Delkredere Prozent
     C                   MOVE      *BLANK        FLVWZS                         Verwendungszweckschl
     C                   MOVE      *BLANK        FLDKKZ                         Delkredere Kz.
     C*
     C                   MOVE      *BLANK        FLKZSL                         KZ Sammelkontoschlüs
     C                   MOVE      *BLANK        FLKZBZ                         KZ Bankleitzahl
     C                   MOVE      *BLANK        FLKZKT                         KZ Bankkonto
     C                   MOVE      *BLANK        FLKZBS                         KZ Zahlverk. SaBe
     C                   MOVE      *BLANK        FLKZST                         KZ Skontoleranztage
     C                   MOVE      *BLANK        FLKZZA                         KZ Zahlart
     C                   MOVE      *BLANK        FLKZZK                         KZ Zahlkz.
     C                   MOVE      *BLANK        FLKZKD                         KZ Kundennr.
     C                   MOVE      *BLANK        FLKZVR                         KZ Verrechnungskz.
     C                   MOVE      'J'           FLKZSB                         KZ Sachbearbeiter
     C                   MOVE      *BLANK        FLKZNB                         KZ Nettobuchen
     C                   MOVE      *BLANK        FLKZBK                         KZ Meldung bei BchgK
     C                   MOVE      *BLANK        FLKZTX                         KZ Meldungtextschl.
     C                   MOVE      *BLANK        FLKZMK                         KZ Kontomerkkennz.
     C                   MOVE      *BLANK        FLKZAP                         KZ bebuchen ab Perio
     C                   MOVE      *BLANK        FLKZBP                         KZ bebuchen bis Peri
     C                   MOVE      *BLANK        FLKZBL                         KZ Bankland
     C                   MOVE      *BLANK        FLKZDP                         KZ Delkredere Prz.
     C                   MOVE      *BLANK        FLKZVW                         KZ Verwendungszweck
     C                   MOVE      *BLANK        FLKZDK                         KZ Delkredere Kz.
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
     C*
     C                   IF        WKIKRN      = *ON
     C                   MOVEL(P)  WKKTKR        WKC011
     C                   MOVE      WKLFNR        WKC011
     C                   EVAL      QPKTO       = WKC011                         Kontonummer
     C                   ELSE
     C                   EVAL      QPKTO       = WKLFNR
     C                   ENDIF
     C*
     C                   SELECT
     C                   WHEN      WKPGST      = 'L'
     C                   EVAL      QPAEN       = 'L'                            Änderungsart
     C                   OTHER
     C                   EVAL      QPAEN       = *BLANK
     C                   ENDSL
     C*
     C                   EVAL      QPANR       = *BLANK                         Anrede
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
     C                   EVAL      QPKTBZ      = SFKTBZ                         Kontobezeichnung
     C                   EVAL      QPKTDV      = SFDIKZ                         Kennz. diverses Kont
     C                   EVAL      QPWG        = SFWHRG                         Währung
     C                   EVAL      QPVERB      = SFVBKZ                         Kennz. verbundende U
     C                   EVAL      QPVBNR      = *BLANK                         Verbands-Nummer
     C                   EVAL      QPVBMG      = *BLANK                         Verbands-Mitgliedsnu
     C                   EVAL      QPZBD       = SFZABD                         Zahlungsbedingung
     C                   EVAL      QPQVLT      = SFVATG                         Valutatage
     C                   EVAL      QPBONI      = *BLANK                         Bonität
     C                   EVAL      QPLKGR      = *BLANK                         Limit-Kontrollgruppe
     C                   EVAL      QPQL1       = SFLI01                         Kreditlimit-1
     C                   EVAL      QPL1JT      = *BLANK                         Kreditlimit-1 gültig
     C                   EVAL      QPQL2       = SFLI02                         Kreditlimit-2
     C                   EVAL      QPL2JT      = *BLANK                         Kreditlimit-2 gültig
     C                   EVAL      QPL2AR      = *ZERO                          Limit-2 Art
     C                   EVAL      QPL2NR      = *BLANK                         Limit-2 Referenznumm
     C                   EVAL      QPRKJT      = *BLANK                         Rückwirkend vers. ab
     C                   EVAL      QPL2JV      = *BLANK                         Kreditlimit-2 gültig
     C                   EVAL      QPEXKT      = *BLANK                         externe Kontonummer
     C                   EVAL      QPSK1       = *BLANK                         Stat-SL Debitor 1
     C                   EVAL      QPSK2       = *BLANK                         Stat-SL Debitor 2
     C                   EVAL      QPSK3       = *BLANK                         Stat-SL Debitor 3
     C                   EVAL      QPSSL1      = SFSTL1                         Stat-SL Kreditor 1
     C                   EVAL      QPSSL2      = SFSTL2                         Stat-SL Kreditor 2
     C                   EVAL      QPSSL3      = SFSTL3                         Stat-SL Kreditor 3
     C                   EVAL      QPBBN       = SFBBNR                         Bundesbetriebsnummer
     C                   EVAL      QPBBS       = SFBBSN                         Bundes-Betriebsstätt
     C                   EVAL      QPSTLD      = SFUSTL                         Umsatzsteuer-Länderk
     C                   EVAL      QPSTIN      = SFUSTI                         Umsatzsteuer-IdentNr
     C                   EVAL      QPSTOK      = SFUIPR                         UmsatzsteueridentNr
     C                   EVAL      QPIDJT      = SFUIDA                         Ident-Nr geprüft am
     C                   EVAL      QPZAEM      = SFZAEP                         abw. Zahlungsempfäng
     C                   EVAL      QPMAEM      = *BLANK                         Mahnempfänger
     C                   EVAL      QPVTR       = *BLANK                         Vertreter
     C                   EVAL      QPEZEM      = *BLANK                         Abw. Einzugsempfänge
     C                   EVAL      QPKVZL      = *ZERO                          Kreditziel in Monate
     C                   EVAL      QPILN       = SFILNN                         Internationale Lokat
     C                   EVAL      QPIBAN      = *BLANK                         International Bank A
     C                   EVAL      QPEUJT      = *BLANK                         Euro ab Datum
     C                   EVAL      QPSMKT      = FLSKSL                         Sammelkonto-Schlüsse
     C                   EVAL      QPBKLD      = FLBKLD                         Land der Bankverbind
     C                   EVAL      QPBLZ       = FLBLZL                         Bankleitzahl
     C                   EVAL      QPBKKO      = FLBKTO                         Bankkonto-Nr
     C                   EVAL      QPBKNR      = *BLANK                         Banknummer
     C                   EVAL      QPAVSL      = *BLANK                         AZV-Vorbesetzungssch
     C                   EVAL      QPEZAR      = *BLANK                         Einzugsart
     C                   EVAL      QPZVSB      = *BLANK                         Sachbearbeiter Zahlu
     C                   EVAL      QPBESB      = FLBESB                         Sachbearbeiter Banke
     C                   EVAL      QPQSTT      = FLSKTG                         Toleranztage Skonto
     C                   EVAL      QPRFKT      = *BLANK                         Referenz-Konto-Nr.
     C                   EVAL      QPVRRK      = *BLANK                         Verrechnung Debitor/
     C                   EVAL      QPZAAR      = FLZAAT                         Zahlungsart
     C                   EVAL      QPZAKZ      = FLZAKZ                         Zahlungs-Kennz.
     C                   EVAL      QPMNKZ      = *BLANK                         Mahn-Kennzeichen
     C                   EVAL      QPMNSB      = *BLANK                         Sachbearbeiter Mahnu
     C                   EVAL      QPMNGR      = *BLANK                         Mahngruppe
     C                   EVAL      QPMVKZ      = *BLANK                         Mahnungen über Verba
     C                   EVAL      QPEVKZ      = *BLANK                         Bankeinzug über Verb
     C                   EVAL      QPZNKZ      = *BLANK                         Zinsrechnung
     C                   EVAL      QPQZTT      = *ZERO                          Zinstoleranztage
     C                   EVAL      QPSB        = FLSABE                         Sachbearbeiter
     C                   EVAL      QPNEBU      = FLNBKZ                         Kennz. Netto buchen
     C                   EVAL      QPMSKZ      = FLMGKZ                         Kz. Meldung bei Buch
     C                   EVAL      QPMSSL      = FLMGTX                         Schlüssel für Meldun
     C                   EVAL      QPMIJP      = FLMIBP                         bebuchen ab BuPer
     C                   EVAL      QPMXJP      = FLMABP                         bebuchen bis BuPer
     C                   EVAL      QPVWZB      = *BLANK                         Verwendungszweck-Sch
     C                   EVAL      QPVWZZ      = *BLANK                         Verwendungszweck-Sch
     C                   EVAL      QPQDPZ      = FLDKPZ                         Delkredere-Prozentsa
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
     C                   MOVEL     'TRLFSC'      PGMNAM                         INITIALISIEREN
     C                   MOVE      *ON           *IN90                          SUBFILE
     C*
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'                                         WINDOW
     C                   OTHER
     C                   WRITE     ISCHLFCT
     C                   ENDSL
     C*
     C                   MOVE      *OFF          *IN90
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'                                         WINDOW
     C                   OTHER
     C                   WRITE     ISCHLFCT
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
     C/COPY QCPYSRC,CHLFKR
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRUE
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,VINFO
     O**************************************************************************
     O***  E N D E   D E S   P R O G R A M M S                               ***
     O**************************************************************************
