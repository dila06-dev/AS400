     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE  Update Feld "Ertrag" in TVAE
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 23.02.2011
     H*  Änderung: VU 08.06.2012 Projekt 8385
     H*  Änderung: ZG 02.04.2014 Projekt 9917 Berechnung NTSK
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm liest in TVAE die Sätze mit Änderungskennzeichen '900'
     F*  und macht einen Update auf das Feld "Ertrag" mit dem aktuellen Wert aus
     F*  dem Feld "Standardpreis" (* Menge) aus TEIL.
     F*  In einem weiteren Schritt wird der Umsatz in Fremdwährung mit dem ge-
     F*  änderten Kurs aus WAEH in Stammwährung umgerechnet.
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D*
     D KOD             S              3    DIM(4)                               KONDITIONSART
     D KOW             S              9  2 DIM(4)                               KONDITIONSWERT
     D KOP             S              1    DIM(4)                               KONDITION %
     D KPD             S              1    DIM(4)                               KONDITION PDIM
     D KBS             S              3    DIM(4)                               KONDITION BASIS
     D*
     D WER             S             13  6 DIM(4)                               KOND.AFRP
     D ERG             S             21  9 DIM(12)                              ERGEBNIS JE KOND.
     D KUM             S             15  6 DIM(12)                              ERGEBNIS KUMULIERT
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
     D*
     D AFKN          E DS                  INZ
     D KYAFKN        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TVAE          E DS                  INZ
     D KYTVAE        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D EXWAUM        E DS                  INZ
     D RTWAUM        E DS                  INZ
     D*
     D EXGEWI        E DS                  INZ
     D RTGEWI        E DS                  INZ
     D*
     D EXKOSC        E DS                  INZ
     D RTKOSC        E DS                  INZ
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VTVAE
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
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAAFI
     C                   MOVEL(P)  DAFIRM        KYANFI
     C                   MOVEL(P)  DAFIRM        KYALFI
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYSWFI                         TVAE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C                   MOVEL     *ZERO         KYTPTF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*
     C                   MOVEA     KOM(01)       DUC008
     C                   TESTN                   DUC008               97        PRÜFUNG
     C     *IN97         IFEQ      *OFF                                         AUF
     C                   MOVE      *ZERO         DUC008                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN080        WKREDAAB
     C*
     C                   MOVEA     KOM(09)       DUC008
     C                   TESTN                   DUC008               97        PRÜFUNG
     C     *IN97         IFEQ      *OFF                                         AUF
     C                   MOVE      *ZERO         DUC008                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN080        WKREDABI
     C*
     C                   MOVEA     KOM(17)       WKWAEHUM
     C                   MOVEA     KOM(18)       #KOMERTR
     C                   MOVEA     KOM(19)       #KOMNTSK
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEPDEK        WKPDEK
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    SWERTR        WKERTR
     C     *LIKE         DEFINE    SWKURS        WKKURS
     C     *LIKE         DEFINE    SWUMDV        WKUMDS
     C     *LIKE         DEFINE    SWUMSV        WKUMSS
     C     *LIKE         DEFINE    SWUMSV        WKUMSV
     C     *LIKE         DEFINE    SWUMEV        WKUMES
     C     *LIKE         DEFINE    SWUMWV        WKUMWS
     C     *LIKE         DEFINE    SWABDV        WKABDS
     C     *LIKE         DEFINE    SWABSV        WKABSS
     C     *LIKE         DEFINE    SWABEV        WKABES
     C     *LIKE         DEFINE    SWABWV        WKABWS
     C     *LIKE         DEFINE    SWAEDV        WKAEDS
     C     *LIKE         DEFINE    SWAESV        WKAESS
     C     *LIKE         DEFINE    SWAEEV        WKAEES
     C     *LIKE         DEFINE    SWAEWV        WKAEWS
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    SWREDA        WKREDAAB
     C     *LIKE         DEFINE    SWREDA        WKREDABI
     C     *LIKE         DEFINE    WKC001        WKWAEHUM
     C     *LIKE         DEFINE    WKC001        #KOMERTR
     C     *LIKE         DEFINE    WKC001        #KOMNTSK
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I2              + 2            INDEX
     C     *LIKE         DEFINE    WKN010        I3              + 2            INDEX
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ALNESU        D1NESU
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN TVAE                                                  ***
     C**************************************************************************
     C     VTVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYSWAE      = '900'
     C                   EVAL      KYSWRD      = WKREDAAB
     C                   EVAL      KYSWDA      = *ZERO
     C                   EVAL      KYSWTI      = *ZERO
     C                   EVAL      KYSWNU      = *ZERO
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHTVAE
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO         AND
     C                             SWFIRM      = KYSWFI        AND
     C                             SWAEKZ      = KYSWAE        AND
     C                             SWREDA      <= WKREDABI
     C*
     C                   MOVEL(P)  SWTENR        KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     #KOMNTSK      IFEQ      DAJNKZ
     C                   EXSR      VNTSK
     C                   ENDIF
     C*
     C                   Z-ADD     SWERTR        WKERTR
     C     #KOMERTR      IFEQ      DAJNKZ
     C                   EXSR      VERTR
     C                   ENDIF
     C*
     C                   EXSR      VWAUM
     C                   EXSR      UTVAE
     C*--------------------------------------------------------
     C                   MOVEA     '05R     '    CHI
     C                   EXSR      CHTVAE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE TVAE                                                       ***
     C**************************************************************************
     C     UTVAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      KYSWDA      = SWDATE
     C                   EVAL      KYSWTI      = SWTIME
     C                   EVAL      KYSWNU      = SWNUMM
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTVAE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKERTR        SWERTR
     C                   Z-ADD     WKAEWS        SWAEWS
     C                   Z-ADD     WKAEES        SWAEES
     C                   Z-ADD     WKAESS        SWAESS
     C                   Z-ADD     WKAEDS        SWAEDS
     C                   Z-ADD     WKABWS        SWABWS
     C                   Z-ADD     WKABES        SWABES
     C                   Z-ADD     WKABSS        SWABSS
     C                   Z-ADD     WKABDS        SWABDS
     C                   Z-ADD     WKUMWS        SWUMWS
     C                   Z-ADD     WKUMES        SWUMES
     C                   Z-ADD     WKUMSS        SWUMSS
     C                   Z-ADD     WKUMSV        SWUMSV
     C                   Z-ADD     WKUMDS        SWUMDS
     C                   Z-ADD     WKKURS        SWKURS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHTVAE
     C*--------------------------------------------------------
     C                   OTHER
     C                   MOVEA     '01CF    '    CHI
     C                   EXSR      CHTVAE
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BERECHNEN ERTRAG                                                  ***
     C**************************************************************************
     C     VNTSK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         KYANJH
     C                   MOVE      *BLANK        KYANKN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SWAFJJ        KYALJH
     C                   MOVEL     SWAFNR        KYALAF
     C                   Z-ADD     SWAFPO        KYALPO
     C                   MOVE      *LOVAL        KYALKJ
     C                   MOVE      *LOVAL        KYALKN
     C                   MOVE      *LOVAL        KYALKP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFLP
     C*
     C     CHI(5)        DOWEQ     'J'
     C     ALFIRM        ANDEQ     KYALFI
     C     ALAFJJ        ANDEQ     KYALJH
     C     ALAFNR        ANDEQ     KYALAF
     C     ALAFPO        ANDEQ     KYALPO
     C*
     C     ALRGJJ        IFEQ      SWRGJJ
     C     ALRGNR        ANDEQ     SWRGNR
     C                   Z-ADD     ALLIJJ        KYANJH
     C                   MOVEL     ALLINR        KYANKN
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLP
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     ALLIJJ        IFEQ      *ZERO
     C     ALLINR        OREQ      *BLANK
     C     ALAFKZ        ORNE      DAJNKZ                                       SCHLUßKONDITIONEN
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'LINR'        KYANKA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKN
     C*
     C     ANKON1        IFEQ      *BLANK
     C     ANKON2        ANDEQ     *BLANK
     C     ANKON3        ANDEQ     *BLANK
     C     ANKON4        ANDEQ     *BLANK
     C     CHI(05)       OREQ      'N'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     SWAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAPMKZ        IFNE      '-'
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXGEWI
     C                   CLEAR                   RTGEWI
     C                   MOVEL     SWTENR        EXGEWITENR
     C                   Z-ADD     SWUMMS        EXGEWIMENG
     C                   ADD       SWUMNS        EXGEWIMENG
     C     SWUMMS        IFLE      *ZERO
     C                   Z-SUB     SWUMMS        EXGEWIMENG
     C                   SUB       SWUMNS        EXGEWIMENG
     C                   END
     C                   MOVEL     TEMEIN        EXGEWIMEIN
     C                   Z-ADD     ALAFDA        EXGEWIAFDA
     C*
     C                   CALL      'ERGEWI'
     C                   PARM                    EXGEWI
     C                   PARM                    RTGEWI
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SWUMWV        D1NESU
     C     ALAGPR        IFNE      *ZERO
     C                   Z-ADD     ALAGPR        D1NESU
     C                   END
     C*
     C     ALAFKZ        IFEQ      DAJNKZ                                       SCHLUßKONDITIONEN
     C                   EXSR      PAFKN                                        AUF POSITIONS-
     C                   ENDIF                                                  EBENE BERECHNEN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     D1NESU        SWUMSV
     C                   Z-ADD     D1NESU        SWUMSS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-PAFKN     VERARBEITEN DER SCHLUßKONDITIONEN AUF POSI-          ***
     C***               TIONSEBENE                                           ***
     C**************************************************************************
     C     PAFKN         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOD                            INITIALISIEREN
     C                   MOVE      *ZERO         KOW                            FELDGRUPPE
     C                   MOVE      *BLANK        KOP
     C                   MOVE      *BLANK        KPD
     C                   MOVE      *BLANK        KBS
     C                   MOVE      *ZERO         KUM
     C                   MOVE      *ZERO         ERG
     C*
     C                   MOVE      *ZERO         I1                             INDEX
     C                   MOVE      *ZERO         I3
     C*-------------------------------------------------------------------------
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'RECHNUNG'    KYTPTA
     C                   MOVEL     ANKON1        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C     ANKON1        ANDNE     *BLANK
     C                   ADD       1             I1
     C                   MOVEL     ANKON1        KOD(I1)
     C                   Z-ADD     ANKOW1        KOW(I1)
     C                   MOVEL     ANPRZ1        KOP(I1)
     C                   MOVE      *BLANK        KPD(I1)
     C                   MOVEL     ANBAS1        KBS(I1)
     C                   END
     C*--------------------------------------------------------
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'RECHNUNG'    KYTPTA
     C                   MOVEL     ANKON2        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C     ANKON2        ANDNE     *BLANK
     C                   ADD       1             I1
     C                   MOVEL     ANKON2        KOD(I1)
     C                   Z-ADD     ANKOW2        KOW(I1)
     C                   MOVEL     ANPRZ2        KOP(I1)
     C                   MOVE      *BLANK        KPD(I1)
     C                   MOVEL     ANBAS2        KBS(I1)
     C                   END
     C*--------------------------------------------------------
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'RECHNUNG'    KYTPTA
     C                   MOVEL     ANKON3        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C     ANKON3        ANDNE     *BLANK
     C                   ADD       1             I1
     C                   MOVEL     ANKON3        KOD(I1)
     C                   Z-ADD     ANKOW3        KOW(I1)
     C                   MOVEL     ANPRZ3        KOP(I1)
     C                   MOVE      *BLANK        KPD(I1)
     C                   MOVEL     ANBAS3        KBS(I1)
     C                   END
     C*--------------------------------------------------------
     C                   MOVEL     DASPCD        KYTPSP
     C                   MOVEL     'RECHNUNG'    KYTPTA
     C                   MOVEL     ANKON4        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     CHI(5)        IFEQ      'N'
     C     ANKON4        ANDNE     *BLANK
     C                   ADD       1             I1
     C                   MOVEL     ANKON4        KOD(I1)
     C                   Z-ADD     ANKOW4        KOW(I1)
     C                   MOVEL     ANPRZ4        KOP(I1)
     C                   MOVE      *BLANK        KPD(I1)
     C                   MOVEL     ANBAS4        KBS(I1)
     C                   END
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAFKN'       #CPGST
     C                   EXSR      BRKOSC                                       BERECHNEN
     C*
     C                   Z-ADD(H)  RTKOSCERG1    ERG(1)
     C                   Z-ADD(H)  RTKOSCKUM1    KUM(1)
     C*
     C                   Z-ADD(H)  RTKOSCERG2    ERG(2)
     C                   Z-ADD(H)  RTKOSCKUM2    KUM(2)
     C*
     C                   Z-ADD(H)  RTKOSCERG3    ERG(3)
     C                   Z-ADD(H)  RTKOSCKUM3    KUM(3)
     C*
     C                   Z-ADD(H)  RTKOSCERG4    ERG(4)
     C                   Z-ADD(H)  RTKOSCKUM4    KUM(4)
     C*-------------------------------------------------------------------------
     C     AAPMKZ        IFEQ      '-'                                          BEI GUTSCHRIFTEN
     C     D1NESU        ANDLT     *ZERO
     C                   SUB       RTKOSCERG1    D1NESU
     C                   SUB       RTKOSCERG2    D1NESU
     C                   SUB       RTKOSCERG3    D1NESU
     C                   SUB       RTKOSCERG4    D1NESU
     C                   ELSE
     C                   ADD       RTKOSCERG1    D1NESU
     C                   ADD       RTKOSCERG2    D1NESU
     C                   ADD       RTKOSCERG3    D1NESU
     C                   ADD       RTKOSCERG4    D1NESU
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BRKOSC        BERECHEN PREIS / KONDITIONEN                        ***
     C**************************************************************************
     C     BRKOSC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXKOSC
     C                   CLEAR                   RTKOSC
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ANWTNT        EXKOSCRBBA
     C*-------------------------------------------------------------------------
     C                   Z-ADD     D1NESU        EXKOSCWTNT
     C                   Z-ADD     D1NESU        EXKOSCRBBP
     C     AAPMKZ        IFEQ      '-'                                          BEI GUTSCHRIFTEN
     C     D1NESU        ANDLT     *ZERO
     C                   Z-SUB     D1NESU        EXKOSCWTNT
     C                   Z-SUB     D1NESU        EXKOSCRBBP
     C                   END
     C                   Z-ADD     RTGEWIGWBR    EXKOSCGWBR
     C*-------------------------------------------------------------------------
     C                   MOVEL     KOD(1)        EXKOSCKON1
     C                   Z-ADD(H)  KOW(1)        EXKOSCKOW1
     C                   MOVEL     KOP(1)        EXKOSCPRZ1
     C                   MOVEL     KBS(1)        EXKOSCBAS1
     C*
     C                   MOVEL     KOD(2)        EXKOSCKON2
     C                   Z-ADD(H)  KOW(2)        EXKOSCKOW2
     C                   MOVEL     KOP(2)        EXKOSCPRZ2
     C                   MOVEL     KBS(2)        EXKOSCBAS2
     C*
     C                   MOVEL     KOD(3)        EXKOSCKON3
     C                   Z-ADD(H)  KOW(3)        EXKOSCKOW3
     C                   MOVEL     KOP(3)        EXKOSCPRZ3
     C                   MOVEL     KBS(3)        EXKOSCBAS3
     C*
     C                   MOVEL     KOD(4)        EXKOSCKON4
     C                   Z-ADD(H)  KOW(4)        EXKOSCKOW4
     C                   MOVEL     KOP(4)        EXKOSCPRZ4
     C                   MOVEL     KBS(4)        EXKOSCBAS4
     C*--------------------------------------------------------
     C                   MOVEL(P)  #CPGST        EXKOSCPGST
     C                   CALL      'BRKOSC'                             99
     C                   PARM                    EXKOSC
     C                   PARM                    RTKOSC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  BERECHNEN ERTRAG                                                  ***
     C**************************************************************************
     C     VERTR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*                                                                         BESTELLTE MENGE
     C     SWUMMS        ADD       SWUMNS        WKN112                         + NATURALRABATT
     C*-------------------------------------------------------------------------
     C     TEPDEK        IFNE      WKPDEK
     C                   MOVEL(P)  'PDIM'        KYTPTA                         VERKAUF-
     C                   MOVEL(P)  TEPDEK        KYTPTC                         PREISDIMENSION
     C                   MOVEA     '01C     '    CHI                            AUS TEILESTAMM
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TEPDEK        WKPDEK
     C                   ENDIF
     C*
     C     TPTNUM        IFEQ      *ZERO
     C                   Z-ADD     1             TPTNUM
     C                   ENDIF
     C*
     C     TESTPR        MULT      WKN112        WKERTR                         BERECHNEN
     C     WKERTR        DIV       TPTNUM        WKERTR                         ROHERTRAG
     C*-------------------------------------------------------------------------
     C                   EXSR      VRUND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  RUNDUNGSROUTINE                                                   ***
     C**************************************************************************
     C     VRUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        WKERTR      = *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        KOM
     C                   MOVEA     SWWAVK        KOM(1)
     C                   Z-ADD     WKERTR        DUN152
     C                   MOVEA     DUC015        KOM(4)
     C                   MOVEA     KOM           #CKOMM
     C                   EXSR      TRRUND
     C*--------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(4)        DUC015
     C                   Z-ADD     DUN152        WKERTR
     C                   ELSE
     C                   Z-ADD     *ZERO         WKERTR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  WÄHRUNGSUMRECHNUNG                                                ***
     C**************************************************************************
     C     VWAUM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     SWAEWV        WKAEWS
     C                   Z-ADD     SWAEEV        WKAEES
     C                   Z-ADD     SWAESV        WKAESS
     C                   Z-ADD     SWAEDV        WKAEDS
     C                   Z-ADD     SWABWV        WKABWS
     C                   Z-ADD     SWABEV        WKABES
     C                   Z-ADD     SWABSV        WKABSS
     C                   Z-ADD     SWABDV        WKABDS
     C*
     C                   Z-ADD     SWUMWV        WKUMWS
     C                   Z-ADD     SWUMEV        WKUMES
     C                   Z-ADD     SWUMSV        WKUMSS
     C                   Z-ADD     SWUMSV        WKUMSV
     C                   Z-ADD     SWUMDV        WKUMDS
     C                   Z-ADD     SWKURS        WKKURS
     C*
     C                   IF        SWWAST      = SWWAVK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAESV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAESS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWAEDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKAEDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABSV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      SWABSS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWABDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKABDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMWV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMWS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMEV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMES
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMSV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMSS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     SWUMDV        WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMWBTN      WKUMDS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAUM
     C                   MOVEL(P)  SWWAVK        WAUMWACV
     C                   MOVEL(P)  SWWAST        WAUMWACN
     C                   Z-ADD     1             WAUMWBTV
     C                   Z-ADD     SWDATE        WAUMDATE
     C                   MOVE      *ON           WAUMKUKZ                       RUNDEN
     C                   MOVE      'A'           WAUMRTCD                       TVA-BEREICH
     C                   EXSR      TRWAUM
     C*
     C     WAUMFENR      IFEQ      *ZERO
     C                   Z-ADD     WAUMKRS1      WKKURS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFKN
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHTVAE
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,TRRUND
     C/COPY QCPYSRC,TRWAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
