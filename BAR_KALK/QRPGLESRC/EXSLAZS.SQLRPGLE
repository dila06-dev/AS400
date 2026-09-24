     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE Erstellen Schnittstellendatei für Stücklistenanzeige
     H**************************************************************************
     H*  Copyright 2000 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  ----------------------------------------------------------------------
     H*  Erstellt: MG 12.04.2001
     H*  ----------------------------------------------------------------------
     H*  Änderung: RE 04.03.2002 FEYCO Hotline 10635
     H*            bei aktivem Lack-Parameter (TREDN/LACK/LACK) wird die Basismenge
     H*            als Menge zur Berechnung der Bedarfsmenge übernommen und nicht
     H*            1
     H*  Änderung: RE 25.06.2002 BSUCH Projekt 1363
     H*            Struktur-Auflösung mit Berechnung des Bedarf-Termines und Reserv.
     H*            Datum und Prüfung auf den Dispositiven Bestand
     H*  Änderung: ZG 11.07.2002 JOMA einbauen SV in EXSLAZ (Struktur-Verwendung)
     H*  Änderung: ZG 19.07.2002 Ermiiteln Einsatzmenge per 1
     H*  Änderung: RE 28.08.2002 BUSCH
     H*            Bei Auflösung mit Bestandsprüfung (SB/BB) werden nur die Positions
     H*            varianten *BLANK bzw die 1.gelesene Variante berücksichtigt
     H*  Änderung: RE 09.10.2002 BUSCH
     H*            Löschen Vorlauf-Zeiten
     H*  Änderung: RE 21.10.2002 BUSCH BUS013
     H*            Azeige Struktur Identverwendung nur unterste Stufen
     H*            Anzeige-Art 'SE'
     H*  Änderung: RE 28.03.2003 BUSCH
     H*            Korrektur Verfügb. Berechnung
     H*  Änderung: RE 31.03.2003 FAWU Hotline 12805
     H*            Update Variante Kopf in SLAZ
     H*  Änderung: RE 10.06.2003 SCHRAMM Hotline 76
     H*            keine Ermittlung des Verfügbaren Bestandes, wenn ohne Bestands-
     H*            prüfung (Laufzeit)
     H*  Änderung: RE 09.12.2003 Standard
     H*            Aneige-Art MB Baukasten Mengen-Anzeige
     H*            Aneige-Art MS Struktur Mengen-Anzeige
     H*            Aneige-Art TR Baukasten Ident-Verwendung ohne Stüli-Art
     H*  Änderung: RE 16.03.2004 BUSCH KL 1529
     H*            Übergabe Gülit-Datum und Perioden-Art
     H*  Änderung: MG 22.04.2004 Übernahme Zeichnungs-Nr aus dem Zeichnungs-Stamm
     H*            bei aktivem Parameter TREND/TEZE/TEZE
     H*  Änderung: RE 27.04.2004 MAURER
     H*            WKFENR = *ZERO in Routine ESLBZ
     H*  Änderung: RE 21.05.2004 BUSCH Projekt 2813
     H*            Bei Auflösung mit Bestandsprüfung wird nur mit der Fehl-Menge
     H*            weiter gerechnet
     H*  Änderung: RE 04.11.2004 BUSCH Projekt 2813
     H*            Bei Bestandsprüfung wird nur mit der Fehl-Menge
     H*            weiter gerechnet
     H**************************************************************************
     F*/
     F*/ Dieses Programm erstellt eine Schnittstellendatei für die
     F*/ Stücklistenanzeige.
     F*/
     F*/ Folgende Parameter werden bei Aufruf übergeben:
     F*/ #KOMSLAT Stücklisten-Art
     F*/ #KOMTENR Ident-Nr
     F*/ #KOMAZAR Anzeige-Art (Struktur, Baukasten, Teileverwendung)
     F*/ #KOMJNUM Jobnummer
     F*/ #KOMVARK Variante Kopf
     F*/ #KOMMENG Menge
     F*/
     F**************************************************************************
     F***     DATEIBESCHREIBUNG   BILDSCHIRMDATEI  -WORKSTN-                 ***
     F**************************************************************************
     FSLAZS     UF A E           K DISK    USROPN
     F*
     D**************************************************************************
     D***  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SLAT            S                   DIM(99)        LIKE(SPSLAT)
     D TENR            S                   DIM(99)        LIKE(SPTENR)
     D VARK            S                   DIM(99)        LIKE(SPVARK)
     D BGTE            S                   DIM(99)        LIKE(SPBGTE)
     D HPOS            S                   DIM(99)        LIKE(SPHPOS)
     D VARP            S                   DIM(99)        LIKE(SPVARI)
     D KOTE            S                   DIM(99)        LIKE(SPKOTE)
     D GADA            S                   DIM(99)        LIKE(SPGADA)
     D MENG            S                   DIM(99)        LIKE(DUN219)
     D MEN1            S                   DIM(99)        LIKE(DUN219)
     D BETE            S                   DIM(99)        LIKE(SPGADA)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D SLBZ          E DS                  INZ
     D KYSLBZ        E DS                  INZ
     D*
     D SLKO          E DS                  INZ
     D KYSLKO        E DS                  INZ
     D*
     D SLPO          E DS                  INZ
     D KYSLPO        E DS                  INZ
     D*
     D SLSS          E DS                  INZ
     D KYSLSS        E DS                  INZ
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
     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXGEWI        E DS                  INZ
     D RTGEWI        E DS                  INZ
     D*
     D EXTEZE        E DS                  INZ
     D RTTEZE        E DS                  INZ
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
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    #KOMSLAT
     C                   PARM                    #KOMTENR
     C                   PARM                    #KOMAZAR
     C                   PARM                    #KOMJNUM
     C                   PARM                    #KOMVARK
     C                   PARM                    #KOMMENG
     C                   PARM                    #KOMBETE
     C                   PARM                    #KOMGADA
     C                   PARM                    #KOMPEAR
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #KOMAZAR      WHENEQ    'BK'                                         BAUKASTEN
     C     #KOMAZAR      OREQ      'MB'                                         MENGE BAUKASTEN
     C                   EXSR      VSLPO
     C*
     C     #KOMAZAR      WHENEQ    'SB'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'BB'
     C                   MOVEL(P)  #KOMTENR      SPKOTE
     C                   Z-ADD     #KOMMENG      WKMENG
     C                   Z-ADD     #KOMBETE      #CDATN
     C                   EXSR      EVFBE
     C*
     C     WKVFBE        IFLT      WKMENG
     C     WKMENG        SUB       WKVFBE        WKFEMG
     C     WKMENG        SUB       WKVFBE        WKKOMFEMG
     C     WKFEMG        IFLT      *ZERO
     C                   MULT      -1            WKFEMG
     C                   MULT      -1            WKKOMFEMG
     C                   ENDIF
     C*
     C                   EXSR      EBETE
     C                   EXSR      UTENR
     C*
     C                   MOVEL     WKPRST        WKBETE
     C                   EXSR      VSLPO
     C                   ENDIF
     C*
     C     #KOMAZAR      WHENEQ    'ST'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'MS'                                         MENGE STRUKTUR
     C                   EXSR      VSLPO
     C     #KOMAZAR      WHENEQ    'TR'
     C                   EXSR      SLPO10
     C     #KOMAZAR      WHENEQ    'TV'                                         TEILEVERWENDUNG
     C                   EXSR      VKOTE
     C     #KOMAZAR      WHENEQ    'SV'                                         TEILEVERWENDUNG
     C     #KOMAZAR      OREQ      'SE'                                         TEILEVERWENDUNG
     C                   EXSR      SLPO04                                       STRUKTUR
     C                   ENDSL
     C*--------------------------------------------------------
     C                   CLOSE     SLAZs                                        SCHLIEßEN
     C                   MOVE      *OFF          WKOPEN
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
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN                         DATUMFELDER
     C                   Z-ADD     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYSBFI                         SLBZ
     C                   MOVEL(P)  DAFIRM        KYSKFI                         SLKO
     C                   MOVEL(P)  DAFIRM        KYSPFI                         SLPO
     C                   MOVEL(P)  DAFIRM        KYSLFI                         SLSS
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL     DAFIRM        KYZTFI                         ZTDI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     #KOMGADA      WKGADA
     C*
     C     WKGADA        IFEQ      *ZERO
     C                   Z-ADD     *DATE         #CDATV
     C                   MOVEL(P)  '*EUR'        #CFMTV
     C                   MOVEL(P)  '*ISO'        #CFMTN
     C                   EXSR      TRDAUM
     C                   Z-ADD     #CDATN        WKGADA                         GÜLTIG AB
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     #KOMPEAR      WKPEAR
     C*
     C     WKPEAR        IFEQ      *BLANK
     C                   MOVEL     'SQ'          WKPEAR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     #KOMBETE      WKBETE
     C*-------------------------------------------------------------------------
     C     WKOPEN        IFNE      *ON                                          ÖFFNEN
     C                   OPEN      SLAZs                                98      DATEI
     C                   MOVE      *ON           WKOPEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      DSLAZ                                        LÖSCHEN DER SLAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  #KOMSLAT      SLAZSLAT
     C                   MOVEL(P)  #KOMTENR      SLAZTENR
     C                   MOVEL(P)  #KOMAZAR      SLAZAZAR
     C*--------------------------------------------------------
     C                   MOVEL(P)  #KOMSLAT      KYSLAT                         ERMITTELN
     C                   MOVEA     '01C     '    CHI                            STÜCKLISTEN-ART
     C                   EXSR      CHSLSS                                       BEZEICHNUNG
     C                   MOVEL(P)  SLSBEZ        SLAZTXSLAT
     C*--------------------------------------------------------
     C                   SELECT
     C     #KOMAZAR      WHENEQ    'BK'                                         BAUKASTEN ODER
     C     #KOMAZAR      OREQ      'MB'                                         MENGE BAUKASTEN
     C     #KOMAZAR      OREQ      'ST'                                         STRUKTUR-ANZEIGE
     C     #KOMAZAR      OREQ      'MS'                                         MENGE STRUKTUR
     C     #KOMAZAR      OREQ      'SB'                                         STRUKTUR-ANZEIGE
     C     #KOMAZAR      OREQ      'BB'
     C                   MOVEL(P)  #KOMSLAT      KYSKAT                         STÜCKLISTEN-
     C                   MOVEL(P)  #KOMTENR      KYSKTE                         KOPF LESEN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSLKO
     C     SLTPKO        IFEQ      DAJNKZ
     C     SKTBZ1        OREQ      *BLANK
     C                   MOVEL(P)  SKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TETBZ1        SKTBZ1
     C                   MOVEL(P)  TETBZ2        SKTBZ2
     C                   ENDIF
     C                   MOVEL(P)  SKTBZ1        SLAZTBZ1
     C                   MOVEL(P)  SKTBZ2        SLAZTBZ2
     C*
     C     #KOMAZAR      WHENEQ    'TV'                                         TEILEVERWENDUNG
     C                   MOVEL(P)  #KOMTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TETBZ1        SLAZTBZ1
     C                   MOVEL(P)  TETBZ2        SLAZTBZ2
     C                   ENDSL
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SLAZLLNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  INITIALISIEREN FELDGRUPPEN                                        ***
     C**************************************************************************
     C     INITFLG       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SLAT
     C                   CLEAR                   TENR
     C                   CLEAR                   VARK
     C                   CLEAR                   BGTE
     C                   CLEAR                   HPOS
     C                   CLEAR                   VARP
     C                   CLEAR                   KOTE
     C                   CLEAR                   GADA
     C                   CLEAR                   MENG
     C                   CLEAR                   BETE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-DSLAZ      LÖSCHEN DER SLAZ-SÄTZE PRO JOBNUMMER                ***
     C**************************************************************************
     C     DSLAZ         BEGSR
     C*
     C*-------------------------------------------------------------------
     C/EXEC SQL
     C+ DELETE FROM SLAZ
     C+ WHERE SLAZJNUM = :#KOMJNUM
     C/END-EXEC
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VSLPO      VERARBEITEN REZEPTUR                                ***
     C**************************************************************************
     C     VSLPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      INITFLG                                      INITIALISIEREN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I1                             AUFSETZBAUGRUPPE
     C                   MOVEL(P)  #KOMSLAT      KYSPAT
     C                   MOVEL(P)  #KOMTENR      KYSPTE
     C                   MOVEl(P)  #KOMVARK      KYSPVK
     C                   MOVEL(P)  #KOMTENR      KYSPBT
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   MOVE      *LOVAL        KYSPKT
     C                   Z-ADD     *LOVAL        KYSPDA
     C                   MOVEA     '07L     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     I1            DOWGE     1
     C*-------------------------------------------------------------------------
     C                   MOVEA     '07R     '    CHI                            ERSTES LESEN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     SPFIRM        IFNE      KYSPFI
     C     SPSLAT        ORNE      KYSPAT
     C     SPTENR        ORNE      KYSPTE
     C     SPVARK        ORNE      KYSPVK
     C     SPBGTE        ORNE      KYSPBT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     SPSLST        IFGE      '90'                                         GESPERRT BEI
     C                   ITER                                                   STATUS
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'SQ'                                         STATUS QUO
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C*
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        IFLT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'AD'                                         AB DATUM
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        ANDLT     WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'BD'                                         BIS DATUM
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EMENG                                        ERM.MENGE
     C                   EXSR      ESLBZ                                        ERM.BEZEICHNUNG
     C*
     C     #KOMAZAR      IFEQ      'SB'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'BB'
     C                   EXSR      EBETE
     C                   EXSR      EVFBE                                        ERM.DISPO-BESTAND
     C                   ENDIF
     C*--------------------------------------------------------
     C     #KOMAZAR      IFNE      'BB'
     C     #KOMAZAR      ANDNE     'SB'
     C     #KOMAZAR      OREQ      'BB'
     C     TETART        ANDNE     'P'
     C     #KOMAZAR      OREQ      'SB'
     C     TETART        ANDNE     'P'
     C                   EXSR      USLAZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     #KOMAZAR      IFEQ      'ST'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'MS'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'SB'                                         STRUKTUR
     C     WKVFBE        ANDLT     WKMENG
     C*
     C     WKMENG        SUB       WKVFBE        WKFEMG
     C     WKFEMG        IFLE      *ZERO
     C                   MULT      -1            WKFEMG
     C                   ENDIF
     C*
     C     I1            IFGE      99                                           AUFLÖSUNGSSTUFE
     C                   MOVE      '4791'        WKFENR                         > 99
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      VSLST                                        STRUKTURAUFLÖSUNG
     C*
     C     WKFENR        IFNE      *ZERO                                        INDEXFEHLER
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '07R     '    CHI                            LESEN
     C                   EXSR      CHSLPO                                       NÄCHSTER SATZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SUB(H)    1             I1                             ZURÜCKSETZEN
     C*
     C     I1            IFGT      *ZERO                                        AUF ÜBERGEORDNETE
     C                   MOVEL(P)  SLAT(I1)      KYSPAT                         BAUGRUPPE
     C                   MOVEL(P)  TENR(I1)      KYSPTE
     C                   MOVEL(P)  VARK(I1)      KYSPVK
     C                   MOVEL(P)  BGTE(I1)      KYSPBT
     C                   Z-ADD     HPOS(I1)      KYSPHP
     C                   MOVEL(P)  VARP(I1)      KYSPVA
     C                   MOVEL(P)  KOTE(I1)      KYSPKT
     C                   Z-ADD     GADA(I1)      KYSPDA
     C                   Z-ADD     BETE(I1)      WKBETE
     C                   Z-ADD     MENG(I1)      WKFEMG
     C                   MOVEA     '07G     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PSLSV      VERARBEITEN STÜCKLISTENSTRUKTUR                     ***
     C**************************************************************************
     C     PSLSV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     SLPO          D§SLPO
     C                   MOVEL     KYSLPO        K§SLPO
     C                   MOVEL     *ON           WKSLPO
     C*-------------------------------------------------------------------
     C                   MOVE      SPBGTE        KYSPKT                         PRÜFEN OB
     C                   MOVE      *BLANK        KYSPBT                         BAUGRUPPE ALS
     C                   MOVE      *ZERO         KYSPDA                         KOMPONENT
     C                   MOVE      *ZERO         KYSPHP                         DEFINIERT IST
     C                   MOVE      *BLANK        KYSPVK
     C                   MOVE      *BLANK        KYSPVA
     C                   MOVE      *BLANK        KYSPTE
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHSLPO
     C*
     C     SPFIRM        IFNE      KYSPFI
     C     SPSLAT        ORNE      KYSPAT
     C     SPKOTE        ORNE      KYSPKT
     C     CHI(5)        OREQ      'N'
     C                   MOVEL     *OFF          WKSLPO
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVEL     D§SLPO        SLPO
     C                   MOVEL     K§SLPO        KYSLPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VSLST      VERARBEITEN STÜCKLISTENSTRUKTUR                     ***
     C**************************************************************************
     C     VSLST         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPSLAT        SLAT(I1)                       SPEICHERN
     C                   MOVEL(P)  SPTENR        TENR(I1)                       AKTUELLE
     C                   MOVEL(P)  SPVARK        VARK(I1)                       BAUGRUPPE
     C                   MOVEL(P)  SPBGTE        BGTE(I1)
     C                   Z-ADD     SPHPOS        HPOS(I1)
     C                   MOVEL(P)  SPVARI        VARP(I1)
     C                   MOVEL(P)  SPKOTE        KOTE(I1)
     C                   Z-ADD     SPGADA        GADA(I1)
     C                   Z-ADD     WKMENG        MENG(I1)
     C     #KOMAZAR      IFEQ      'SB'
     C     WKFEMG        ANDGT     *ZERO
     C                   Z-ADD(H)  WKFEMG        MENG(I1)
     C                   ENDIF
     C     #KOMAZAR      IFEQ      'BB'
     C     WKFEMG        ANDGT     *ZERO
     C                   Z-ADD(H)  WKFEMG        MENG(I1)
     C                   ENDIF
     C                   Z-ADD     W1MENG        MEN1(I1)
     C                   Z-ADD     WKBETE        BETE(I1)
     C                   Z-ADD     WKPRST        WKBETE
     C*--------------------------------------------------------
     C                   ADD(H)    1             I1
     C                   MOVEL(P)  SPSLAT        KYSPAT                         SCHLÜSSEL
     C                   MOVEL(P)  SPKOTE        KYSPBT                         FÜR UNTERGEORDNETE
     C                   MOVEL(P)  SPKOTE        KYSPTE
     C                   MOVE      SPVARK        KYSPVK
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   MOVE      *LOVAL        KYSPKT
     C                   Z-ADD     *LOVAL        KYSPDA
     C*--------------------------------------------------------
     C                   MOVEA     '07L     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C                   LEAVE
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-EMENG      ERMITTELN DER STÜCKLISTENMENGE                      ***
     C**************************************************************************
     C     EMENG         BEGSR
     C*
     C                   Z-ADD     *ZERO         WKMENG
     C                   Z-ADD(H)  1             W1BAMG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPSLAT        KYSKAT                         BASISMENGE AUS
     C                   MOVEL(P)  SPBGTE        KYSKTE                         STÜLI-KOPF
     C                   MOVEL(P)  SPVARK        KYSKVA                         NEHMEN
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHSLKO
     C*
     C     SLTPKO        IFEQ      DAJNKZ
     C     SKTBZ1        OREQ      *BLANK
     C                   MOVEL(P)  SKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL(P)  TETBZ1        SKTBZ1
     C                   MOVEL(P)  TETBZ2        SKTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     I1            WHENGT    1                                            MENGE AUS
     C     I1            SUB(H)    1             I2                             ÜBERGEORDNETER
     C                   Z-ADD(H)  MENG(I2)      WKBAMG                         BAUGRUPPE
     C                   Z-ADD(H)  MEN1(I2)      W1BAMG                         BAUGRUPPE
     C*
     C     #KOMAZAR      WHENEQ    'SB'
     C     #KOMAZAR      OREQ      'BB'
     C                   Z-ADD(H)  WKKOMFEMG     WKBAMG                         ÜBERGABE-BEREICH
     C*
     C     #KOMMENG      WHENNE    *ZERO                                        MENGE AUS
     C                   Z-ADD(H)  #KOMMENG      WKBAMG                         ÜBERGABE-BEREICH
     C*
     C     WKTRPALACK    WHENEQ    *ON
     C                   Z-ADD(H)  SKBAMG        WKBAMG
     C*
     C                   OTHER
     C                   Z-ADD(H)  1             WKBAMG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPKOTE        KYTENR                         IDENTSTAMM
     C                   MOVEA     '01C     '    CHI                            LESEN
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TETENR        KYTUTE                         UMRECHNEN DER
     C                   MOVEL(P)  TEMEIN        KYTUME                         KOMPONENTEN-
     C                   Z-ADD(H)  SPMENG        WKV1V2                         EINHEIT IN
     C                   EXSR      VTEUF                                        STAMMEINHEIT
     C                   Z-ADD(H)  WKV1V2        DUN154
     C                   Z-ADD(H)  WKV1V2        W1MENG
     C*-------------------------------------------------------------------------
     C     TETART        IFNE      '6'
     C*
     C     W1BAMG        MULT(H)   DUN154        DUN219                         ERMITTELN DER
     C                   SELECT
     C     SKBAMG        WHENNE    *ZERO
     C                   DIV(H)    SKBAMG        DUN219
     C                   ENDSL
     C                   Z-ADD(H)  DUN219        W1MENG                         GESAMTMENGE
     C     SPWTFL        IFEQ      DAJNKZ                                       WERTFESTLEGUNG IN
     C                   DIV(H)    100           DUN219                         %-ERFASST
     C                   Z-ADD(H)  DUN219        W1MENG
     C                   ENDIF
     C*
     C*
     C     WKBAMG        MULT(H)   DUN154        DUN219                         ERMITTELN DER
     C                   SELECT
     C     SKBAMG        WHENNE    *ZERO                                        BEDARFSMENGE
     C                   DIV(H)    SKBAMG        DUN219
     C                   ENDSL
     C                   Z-ADD(H)  DUN219        DUN154                         GESAMTMENGE
     C*-------------------------------------------------------------------------
     C     SPWTFL        IFEQ      DAJNKZ                                       WERTFESTLEGUNG IN
     C                   DIV(H)    100           DUN219                         %-ERFASST
     C                   Z-ADD(H)  DUN219        DUN154
     C                   ENDIF
     C*
     C     TUANBR        IFNE      DAJNKZ
     C                   ADD       0,49          DUN154
     C                   Z-ADD(H)  DUN154        DUN090
     C                   Z-ADD     DUN090        DUN154
     C*
     C                   ADD       0,49          W1MENG
     C                   Z-ADD(H)  W1MENG        DUN090
     C                   Z-ADD     DUN090        W1MENG
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD(H)  DUN154        WKMENG                         GESAMTMENGE
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXGEWI
     C                   CLEAR                   RTGEWI
     C                   MOVEL     SPKOTE        EXGEWITENR
     C                   Z-ADD     WKMENG        EXGEWIMENG
     C                   MOVEL     TEMEIN        EXGEWIMEIN
     C*
     C                   CALL      'ERGEWI'
     C                   PARM                    EXGEWI
     C                   PARM                    RTGEWI
     C*
     C                   Z-ADD     RTGEWIGWNT    WKGWNT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ESLBZ      ERMITTELN DER STÜCKLISTENBEZEICHNUNG                ***
     C**************************************************************************
     C     ESLBZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPSLAT        KYSBAT                         STÜCKLISTEN
     C                   MOVEL(P)  SPTENR        KYSBTE                         BEZEICHNUNG
     C                   MOVEL(P)  SPBGTE        KYSBBT
     C                   MOVEL(P)  SPKOTE        KYSBKT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSLBZ
     C*
     C     SBTBZ1        IFNE      *BLANK
     C     SBTBZ2        ORNE      *BLANK
     C                   MOVEL(P)  SBTBZ1        TETBZ1
     C                   MOVEL(P)  SBTBZ2        TETBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-EVFBE      VERFÜGBARER DISPOSITIVER BESTAND                    ***
     C**************************************************************************
     C     EVFBE         BEGSR
     C*
     C                   Z-ADD     *ZERO         WKVFBE
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     'V'           KOM(1)                         VETRIEB/PROD-KZ
     C                   MOVEA     SPKOTE        KOM(5)                         IDENTNUMMER
     C                   MOVE      #CDATN        DUN080
     C                   MOVEA     DUC008        KOM(20)                        RESERV.-DATUM
     C                   MOVEA     *BLANK        KOM(28)                        BEGRIFF
     C                   MOVE      *ZERO         DUN040
     C                   MOVEA     DUC004        KOM(31)                        JAHR
     C                   MOVEA     *BLANK        KOM(35)                        NUMMER
     C                   Z-ADD     *ZERO         DUN050
     C                   MOVEA     DUC005        KOM(41)                        POSITION
     C                   Z-ADD     *ZERO         DUN050
     C                   MOVEA     DUC005        KOM(46)                        UNTER-POS.
     C                   MOVE      WKBETE        DUN080
     C                   MOVEA     DUC008        KOM(52)                        BESCHAFFUNGSZEIT
     C                   Z-ADD     WKMENG        DUN112
     C                   MOVEA     DUC011        KOM(60)                        BESTELLTE MENGE
     C                   MOVEL     *ON           KOM(92)                        INHAUSLAGER
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C                   CALL      'TRVFB1'                             99
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(1)        DUC011
     C                   Z-ADD     DUN112        WKVFBE                         VERF.-BESTAND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-EBETE      ERMITTELN BEDARFSTERMIN                             ***
     C**************************************************************************
     C     EBETE         BEGSR
     C*
     C                   MOVEL     *ZERO         WKPRST
     C*-------------------------------------------------------------------------
     C                   MOVEL     SPKOTE        KYTENR                         ERMITTELN
     C                   MOVEL     *BLANK        KYTEEZ                         DER IDENT-
     C                   MOVEA     '01C     '    CHI                            ART
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYTAFI                         ERMITTELN
     C                   MOVEL     'FIRM'        KYTATA                         BRIEFKASTEN-
     C                   MOVEL     'DIBR'        KYTATC                         ART
     C                   MOVEL     TETART        KYTAPA                         PRODUKTION 'PRO'
     C                   MOVEA     '01C     '    CHI                            ODER BESTELLUNG
     C                   EXSR      CHTRPA                                       'BES'
     C                   MOVEL     TAPCDE        DADIBR
     C*
     C                   MOVEL     *BLANK        WKVLAT
     C                   MOVE      *ZERO         WKVLZT
     C*-------------------------------------------------------------------------
     C     DADIBR        IFEQ      '030'                                        EIGENFERTIGUNG
     C                   MOVEL     TEVOA1        WKVLAT                         V-ART (T,M,W) AV
     C                   MOVE      TEVOZ1        WKVLZT                         VORLAUFZEIT   AV
     C                   ENDIF
     C     DADIBR        IFEQ      '040'                                        KAUFTEIL
     C                   MOVEL     TELVA1        WKVLAT                         VORLAUFART    EK
     C                   MOVE      TELVZ1        WKVLZT                         VORLAUFZEIT   EK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     WKVLAT        IFEQ      *BLANK                                       KEINE VL-DATEN
     C     WKVLZT        OREQ      *ZERO                                        IM IDENTSTAMM
     C                   Z-ADD     WKBETE        WKPRST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'T'           KYZTZD                         ZEITFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZU
     C                   EXSR      CHZTDI                                       TAGEN
     C                   Z-ADD     ZTZTFK        WKZTFK
     C     WKZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             WKZTFK
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     WKVLAT        KYZTZD                         ZEIFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZUR
     C                   EXSR      CHZTDI                                       IDENTSTAMM
     C                   Z-ADD     ZTZTFK        W1ZTFK                         VORLAUFZEIT
     C     W1ZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             W1ZTFK
     C                   ENDIF
     C*--------------------------------------------------------
     C     W1ZTFK        DIV       WKZTFK        DUN030                         ERMITTELN DES
     C     DUN030        MULT      WKVLZT        DUN030                         TAGES-VERHÄLTNIS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     WKBETE        EXDATEDATV
     C                   Z-ADD     DUN030        EXDATEWERT
     C                   MOVEL(P)  '001'         EXDATEWKNR
     C                   MOVEL(P)  '-'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    WKPRST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKBETE        IFEQ      *ZERO
     C                   Z-ADD     WKBETE        WKPRST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   LEAVE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VKOTE      VERARBEITEN REZEPTUR                                ***
     C**************************************************************************
     C     VKOTE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  #KOMSLAT      KYSPAT
     C                   MOVEL(P)  #KOMTENR      KYSPKT
     C                   MOVE      *LOVAL        KYSPBT
     C                   MOVE      *LOVAL        KYSPVK
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   Z-ADD     *LOVAL        KYSPDA
     C                   MOVE      *LOVAL        KYSPTE
     C                   MOVEA     '03+     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     SPFIRM        IFNE      KYSPFI
     C     SPSLAT        ORNE      KYSPAT
     C     SPKOTE        ORNE      KYSPKT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     SPSLST        IFGE      '90'                                         GESPERRT BEI
     C                   ITER                                                   STATUS
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'SQ'                                         STATUS QUO
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C*
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        IFLT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'AD'                                         AB DATUM
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        ANDLT     WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'BD'                                         BIS DATUM
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EMENG                                        ERM.MENGE
     C                   EXSR      ESLBZ                                        ERM.BEZEICHNUNG
     C                   EXSR      EBETE
     C                   EXSR      EVFBE                                        ERM.DISPO-BESTAND
     C*--------------------------------------------------------
     C                   EXSR      USLAZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '03R     '    CHI                            LESEN
     C                   EXSR      CHSLPO                                       NÄCHSTER SATZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-SLPO04     TEILVERWENDUNG STRUKTUR                             ***
     C**************************************************************************
     C     SLPO04        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      INITFLG                                      INITIALISIEREN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I1                             AUFSETZBAUGRUPPE
     C                   MOVEL(P)  #KOMSLAT      KYSPAT
     C                   MOVE      *LOVAL        KYSPTE
     C                   MOVE      *BLANK        KYSPVK
     C                   MOVE      *LOVAL        KYSPBT
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   MOVEL(P)  #KOMTENR      KYSPKT
     C                   Z-ADD     *LOVAL        KYSPDA
     C                   MOVEA     '04L     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     I1            DOWGE     1
     C*-------------------------------------------------------------------------
     C                   MOVEA     '04R     '    CHI                            ERSTES LESEN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     SPFIRM        IFNE      KYSPFI
     C     SPSLAT        ORNE      KYSPAT
     C     SPKOTE        ORNE      KYSPKT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     SPSLST        IFGE      '90'                                         GESPERRT BEI
     C                   ITER                                                   STATUS
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'SQ'                                         STATUS QUO
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C*
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        IFLT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'AD'                                         AB DATUM
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        ANDLT     WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'BD'                                         BIS DATUM
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EMENG                                        ERM.MENGE
     C                   EXSR      ESLBZ                                        ERM.BEZEICHNUNG
     C*                  EXSR      EBETE
     C*                  EXSR      EVFBE                                        ERM.DISPO-BESTAND
     C*-------------------------------------------------------------------
     C                   EXSR      PSLSV
     C*--------------------------------------------------------
     C     #KOMAZAR      IFNE      'SE'
     C     #KOMAZAR      OREQ      'SE'
     C     WKSLPO        ANDEQ     *OFF
     C                   EXSR      USLAZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     #KOMAZAR      IFEQ      'SV'                                         STRUKTUR
     C     #KOMAZAR      OREQ      'SE'
     C*
     C     I1            IFGE      99                                           AUFLÖSUNGSSTUFE
     C                   MOVE      '4791'        WKFENR                         > 99
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      VSLSV                                        STRUKTURAUFLÖSUNG
     C*
     C     WKFENR        IFNE      *ZERO                                        INDEXFEHLER
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '04R     '    CHI                            LESEN
     C                   EXSR      CHSLPO                                       NÄCHSTER SATZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SUB(H)    1             I1                             ZURÜCKSETZEN
     C*
     C     I1            IFGT      *ZERO                                        AUF ÜBERGEORDNETE
     C                   MOVEL(P)  SLAT(I1)      KYSPAT                         BAUGRUPPE
     C                   MOVEL(P)  TENR(I1)      KYSPTE
     C                   MOVEL(P)  VARK(I1)      KYSPVK
     C                   MOVEL(P)  BGTE(I1)      KYSPBT
     C                   Z-ADD     HPOS(I1)      KYSPHP
     C                   MOVEL(P)  VARP(I1)      KYSPVA
     C                   MOVEL(P)  KOTE(I1)      KYSPKT
     C                   Z-ADD     GADA(I1)      KYSPDA
     C                   Z-ADD     BETE(I1)      WKBETE
     C                   Z-ADD     MENG(I1)      WKFEMG
     C                   MOVEA     '04G     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-SLPO10     VERARBEITEN REZEPTUR                                ***
     C**************************************************************************
     C     SLPO10        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  #KOMTENR      KYSPKT
     C                   MOVE      *LOVAL        KYSPTE
     C                   MOVE      *LOVAL        KYSPVK
     C                   MOVEL(P)  *LOVAL        KYSPAT
     C                   MOVEA     '10+     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     SPFIRM        IFNE      KYSPFI
     C     SPKOTE        ORNE      KYSPKT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     SPSLST        IFGE      '90'                                         GESPERRT BEI
     C                   ITER                                                   STATUS
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'SQ'                                         STATUS QUO
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C*
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        IFLT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'AD'                                         AB DATUM
     C     SPGBDA        IFNE      *ZERO
     C     SPGBDA        ANDLT     WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKPEAR        IFEQ      'BD'                                         BIS DATUM
     C     SPGADA        IFGT      WKGADA
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EMENG                                        ERM.MENGE
     C                   EXSR      ESLBZ                                        ERM.BEZEICHNUNG
     C                   EXSR      EBETE
     C                   EXSR      EVFBE                                        ERM.DISPO-BESTAND
     C*--------------------------------------------------------
     C                   EXSR      USLAZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI                            LESEN
     C                   EXSR      CHSLPO                                       NÄCHSTER SATZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VSLSV      VERARBEITEN STÜCKLISTENSTRUKTUR                     ***
     C**************************************************************************
     C     VSLSV         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPSLAT        SLAT(I1)                       SPEICHERN
     C                   MOVEL(P)  SPTENR        TENR(I1)                       AKTUELLE
     C                   MOVEL(P)  SPVARK        VARK(I1)                       BAUGRUPPE
     C                   MOVEL(P)  SPBGTE        BGTE(I1)
     C                   Z-ADD     SPHPOS        HPOS(I1)
     C                   MOVEL(P)  SPVARI        VARP(I1)
     C                   MOVEL(P)  SPKOTE        KOTE(I1)
     C                   Z-ADD     SPGADA        GADA(I1)
     C                   Z-ADD     WKMENG        MENG(I1)
     C                   Z-ADD     WKBETE        BETE(I1)
     C                   Z-ADD     WKPRST        WKBETE
     C*--------------------------------------------------------
     C                   ADD(H)    1             I1
     C                   MOVEL(P)  SPSLAT        KYSPAT                         SCHLÜSSEL
     C                   MOVE      *LOVAL        KYSPBT                         FÜR UNTERGEORDNETE
     C                   MOVE      *LOVAL        KYSPTE
     C                   MOVE      *LOVAL        KYSPVK
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   MOVEL(P)  SPBGTE        KYSPKT
     C                   Z-ADD     *LOVAL        KYSPDA
     C                   MOVEA     '03+     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*
     C     CHI(5)        IFNE      'J'
     C     SPFIRM        ORNE      KYSPFI
     C     SPSLAT        ORNE      KYSPAT
     C     SPKOTE        ORNE      KYSPKT
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  SPSLAT        KYSPAT                         SCHLÜSSEL
     C                   MOVE      *LOVAL        KYSPBT                         FÜR UNTERGEORDNETE
     C                   MOVE      *LOVAL        KYSPTE
     C                   MOVEL(P)  SPVARK        KYSPVK
     C                   Z-ADD     *LOVAL        KYSPHP
     C                   MOVE      *LOVAL        KYSPVA
     C                   MOVEL(P)  SPKOTE        KYSPKT
     C                   Z-ADD     *LOVAL        KYSPDA
     C                   MOVEA     '04L     '    CHI                            POSITIONIEREN
     C                   EXSR      CHSLPO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI SLAZ                                                 ***
     C**************************************************************************
     C     USLAZ         BEGSR
     C*
     C                   ADD       1             SLAZLLNR                       LFD. POSITION
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SPFIRM        SLAZFIRM
     C                   MOVEL(P)  #KOMTENR      SLAZTENR
     C*                  MOVEL(P)  SPTENR        SLAZTENR
     C                   MOVEL(P)  SPBGTE        SLAZBGTE
     C                   MOVEL(P)  SKTBZ1        SLAZBBZ1
     C                   MOVEL(P)  SKTBZ2        SLAZBBZ2
     C                   MOVEL(P)  SPVARK        SLAZVARK
     C                   Z-ADD     SPHPOS        SLAZHPOS
     C                   MOVEL(P)  SPVARI        SLAZVARP
     C                   MOVEL(P)  SPKOTE        SLAZKOTE
     C                   Z-ADD     SPGADA        SLAZGADA
     C                   Z-ADD     SPGBDA        SLAZGBDA
     C                   Z-ADD     I1            SLAZVEST
     C                   Z-ADD     WKMENG        SLAZEIMG
     C                   Z-ADD     W1MENG        SLAZEIM1
     C                   Z-ADD     WKMENG        SLAZGSMG
     C                   Z-ADD     SPAUWT        SLAZAUWT
     C                   MOVEL(P)  SPMEIN        SLAZMEIN
     C                   MOVEL(P)  SPAUPZ        SLAZAUPZ
     C                   MOVEL(P)  SPAUDI        SLAZAUDI
     C                   MOVEL(P)  SPAUAP        SLAZAUDI
     C                   MOVEL(P)  SPSLST        SLAZSLST
     C                   MOVEL(P)  SPMAPO        SLAZMAPO
     C                   Z-ADD     SPRLZA        SLAZRLZA
     C                   Z-ADD     WKBETE        SLAZBETE
     C                   Z-ADD     WKPRST        SLAZPRST
     C                   Z-ADD     WKVFBE        SLAZVFBE
     C                   MOVEL     WKVLAT        SLAZVLAT
     C                   Z-ADD     WKVLZT        SLAZVLZT
     C                   Z-ADD     WKGWNT        SLAZGEWI
     C                   MOVEL     TETART        SLAZTART
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA                         ERMITTELN
     C                   MOVEL(P)  SLAZAUDI      KYTPTC                         AUSSCHUSS DIMENSION
     C                   MOVEA     '01C     '    CHI                            (TEXT)
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        SLAZTXAUDI
     C*--------------------------------------------------------
     C     WKTRPATEZE    CASEQ     *ON           EZTEZE                         ERM.ZEICHNUNGS-DATEN
     C                   ENDCS
     C*--------------------------------------------------------
     C                   MOVEL(P)  TETBZ1        SLAZKBZ1
     C                   MOVEL(P)  TETBZ2        SLAZKBZ2
     C                   MOVEL(P)  TEZINR        SLAZZINR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        SLAZJNAM
     C                   MOVEL(P)  #KOMJNUM      SLAZJNUM
     C                   MOVEL(P)  WKCHPN        SLAZPROG
     C                   MOVEL(P)  WKCHPL        SLAZBIBL
     C                   MOVEL(P)  DAUSER        SLAZUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        SLAZJZEI
     C                   MOVE      WKTDAT        SLAZJDAT
     C*-------------------------------------------------------------------------
     C                   WRITE     SLAZ1                                98
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI SLAZ                                                 ***
     C**************************************************************************
     C     UTENR         BEGSR
     C*
     C                   ADD       1             SLAZLLNR                       LFD. POSITION
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  SKFIRM        SLAZFIRM
     C                   MOVEL(P)  #KOMTENR      SLAZTENR
     C*                  MOVEL(P)  SKTENR        SLAZTENR
     C                   MOVEL(P)  SKTENR        SLAZBGTE
     C                   MOVEL(P)  SKTBZ1        SLAZBBZ1
     C                   MOVEL(P)  SKTBZ2        SLAZBBZ2
     C                   Z-ADD     *ZERO         SLAZHPOS
     C                   MOVEL(P)  *BLANK        SLAZVARP
     C                   MOVEL(P)  SKTENR        SLAZKOTE
     C                   Z-ADD     *ZERO         SLAZGADA
     C                   Z-ADD     *ZERO         SLAZGBDA
     C                   Z-ADD     *ZERO         SLAZVEST
     C                   Z-ADD     WKMENG        SLAZEIMG
     C                   Z-ADD     W1MENG        SLAZEIM1
     C                   Z-ADD     *ZERO         SLAZAUWT
     C                   MOVEL(P)  TEMEIN        SLAZMEIN
     C                   MOVEL(P)  *BLANK        SLAZAUPZ
     C                   MOVEL(P)  *BLANK        SLAZAUDI
     C                   MOVEL(P)  *BLANK        SLAZAUDI
     C                   MOVEL(P)  SKSLST        SLAZSLST
     C                   MOVEL(P)  *BLANK        SLAZMAPO
     C                   Z-ADD     SKRLZA        SLAZRLZA
     C                   Z-ADD     WKPRST        SLAZPRST
     C                   Z-ADD     WKBETE        SLAZBETE
     C                   Z-ADD     WKVFBE        SLAZVFBE
     C                   MOVEL     WKVLAT        SLAZVLAT
     C                   Z-ADD     WKVLZT        SLAZVLZT
     C                   Z-ADD     WKGWNT        SLAZGEWI
     C                   MOVEL     TETART        SLAZTART
     C*--------------------------------------------------------
     C                   MOVEL(P)  *BLANK        SLAZKBZ1
     C                   MOVEL(P)  *BLANK        SLAZKBZ2
     C                   MOVEL(P)  *BLANK        SLAZZINR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        SLAZJNAM
     C                   MOVEL(P)  #KOMJNUM      SLAZJNUM
     C                   MOVEL(P)  WKCHPN        SLAZPROG
     C                   MOVEL(P)  WKCHPL        SLAZBIBL
     C                   MOVEL(P)  DAUSER        SLAZUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        SLAZJZEI
     C                   MOVE      WKTDAT        SLAZJDAT
     C*-------------------------------------------------------------------------
     C                   WRITE     SLAZ1                                98
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TREND'       KYTATA                         ERMITTELN
     C                   MOVEL     'LACK'        KYTATC                         LACK
     C                   MOVEL     'LACK'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPALACK
     C     WKTRPALACK    IFNE      *ON
     C                   MOVE      *OFF          WKTRPALACK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ZEICHNUNGS-
     C                   MOVEL(P)  'TEZE'        KYTATC                         VERWALTUNG
     C                   MOVEL(P)  'TEZE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPATEZE
     C*
     C     WKTRPATEZE    IFNE      *ON
     C                   MOVE      *OFF          WKTRPATEZE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'MODBUS'      KYTATC                         BUSCH
     C                   MOVEL     'MODBUS'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODBUS
     C     MODBUS        IFNE      *ON
     C                   MOVE      *OFF          MODBUS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'ZTDI'        KYTATC                         STAMMZEIT-
     C                   MOVEL     'ZTDI'        KYTAPA                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        KYZTSZ                         STAMMZEITBASIS
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKOPEN
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSLPO
     C     *LIKE         DEFINE    WKC001        MODBUS
     C     *LIKE         DEFINE    WKC001        WKTRPALACK
     C     *LIKE         DEFINE    WKC001        WKTRPATEZE
     C     *LIKE         DEFINE    WKC001        DADIBR          + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2            INDEX 0
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         BENUTZER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    SKSLAT        #KOMSLAT
     C     *LIKE         DEFINE    SKTENR        #KOMTENR
     C     *LIKE         DEFINE    WKC001        #KOMAZAR        + 1
     C     *LIKE         DEFINE    WKC001        #KOMJNUM        + 5
     C     *LIKE         DEFINE    SKVARK        #KOMVARK
     C     *LIKE         DEFINE    SKBAMG        #KOMMENG
     C     *LIKE         DEFINE    SPGADA        #KOMBETE
     C     *LIKE         DEFINE    SPGADA        #KOMGADA
     C     *LIKE         DEFINE    WKC001        #KOMPEAR        + 1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DUN219        WKFEMG
     C     *LIKE         DEFINE    DUN219        WKKOMFEMG
     C     *LIKE         DEFINE    DUN219        WKMENG
     C     *LIKE         DEFINE    DUN219        W1MENG
     C     *LIKE         DEFINE    DUN219        WKBAMG
     C     *LIKE         DEFINE    DUN219        W1BAMG
     C     *LIKE         DEFINE    SPGADA        WKGADA
     C     *LIKE         DEFINE    SPGADA        WKBETE
     C     *LIKE         DEFINE    SPGADA        WKPRST
     C     *LIKE         DEFINE    DUN134        WKVFBE
     C     *LIKE         DEFINE    WKC001        WKPEAR          + 1
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    TEVOA1        WKVLAT
     C     *LIKE         DEFINE    TEVOZ1        WKVLZT
     C     *LIKE         DEFINE    ZTZTFK        WKZTFK
     C     *LIKE         DEFINE    ZTZTFK        W1ZTFK
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    SLAZGEWI      WKGWNT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    SLPO          D§SLPO
     C     *LIKE         DEFINE    KYSLPO        K§SLPO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHSLBZ
     C/COPY QCPYSRC,CHSLKO
     C/COPY QCPYSRC,CHSLPO
     C/COPY QCPYSRC,CHSLSS
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHZTDI
     C/COPY QCPYSRC,EZTEZE
     C/COPY QCPYSRC,TRDAUM
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,VTEUF
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
