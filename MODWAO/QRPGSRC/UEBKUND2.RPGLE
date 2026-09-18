     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2010')
     H**************************************************************************
     H/TITLE Übernahme Kunden-Stamm Nachlesen alte Kunden
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 01.02.2011 Nachlesen alte Kunden
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm übernimmt die Kunden-Stamm Daten.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FSBGKDS00  IF   E             DISK
     FKD_FEHL   IT   F   18        DISK
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D VKGBKDGR        S              8    DIM(999) INZ                         VKGB/KDGR
     D VTNR            S             10    DIM(999) INZ                         VETRETER
     D W30             S              1    DIM(30)
     D WKLN            S                   DIM(999) LIKE(LNLDNR)
     D WKLI            S                   DIM(999) LIKE(LNLISO)
     D WKLP            S                   DIM(999) LIKE(LNAMKZ)
     D WKLG            S                   DIM(999) LIKE(LNLDGR)
     D WKLW            S                   DIM(999) LIKE(LNWUKZ)
     D WKVT            S              2  0 DIM(5)
     D STHS            S              3    DIM(32) CTDATA PERRCD(1)
     D*
     D KD_ALT          S              6    DIM(1500) FROMFILE(KD_FEHL)          ALTE KUNDEN
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D KDVS          E DS                  INZ
     D KYKDVS        E DS                  INZ
     D*
     D KUEG          E DS                  INZ
     D KYKUEG        E DS                  INZ
     D*
     D KDZR          E DS                  INZ
     D KYKDZR        E DS                  INZ
     D*
     D KDAP          E DS                  INZ
     D KYKDAP        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D VEZU          E DS                  INZ
     D KYVEZU        E DS                  INZ
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
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
     C                   IF        WKI000     <> *ON
     C                   EXSR      ANFANG
     C                   EXSR      ELAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VKUND
     C*-------------------------------------------------------------------------
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYK2FI                         KDAP
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYVSFI                         KDVS
     C                   MOVEL(P)  DAFIRM        KYKDZRFIRM                     KDZR
     C                   MOVEL(P)  DAFIRM        KYKEFI                         KUEG
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTRMUFIRM                     TRMU
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYVZFI                         VEZU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   Z-ADD     20100101      WKGADA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN DATEI LAND                                                  ***
     C**************************************************************************
     C     ELAND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             I0
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01L     '    CHI                            LESEN FÜR
     C                   MOVE      *BLANK        KYLNNR
     C                   EXSR      CHLAND                                       UPDATE
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DO        *HIVAL
     C                   MOVEA     '01R     '    CHI                            LESEN FÜR
     C                   EXSR      CHLAND                                       UPDATE
     C*
     C     WKFENR        IFNE      *ZERO
     C     I0            OREQ      999
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ADD       1             I0
     C                   MOVEL(P)  LNLDNR        WKLN(I0)
     C                   MOVEL(P)  LNLISO        WKLI(I0)
     C                   MOVEL(P)  LNAMKZ        WKLP(I0)
     C                   MOVEL(P)  LNLDGR        WKLG(I0)
     C                   MOVEL(P)  LNWUKZ        WKLW(I0)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVEL     *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C* STRASSE SPLITTEN?: STRASSE / HAUSNR
     C                   MOVE      *OFF          WKSTRASPLI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DATEI VERARBEITUNG KUND                                           ***
     C**************************************************************************
     C     VKUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C     *INLR         DOWEQ     *OFF
     C                   READ      SBGKDS00                             9899
     C*
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*
     C* NUR FIRMA 01
     C*
     C     KDS010        IFNE      01
     C                   ITER
     C                   ENDIF
     C*
     C                   EXSR      EKUND
     C*
     C                   IF        WKIUPD      = *OFF
     C                   ITER
     C                   ENDIF
     C*
     C                   EXSR      UKUND
     C                   MOVE      *BLANK        KYVSNR
     C*
     C     KDS110        IFNE      KDS060
     C     KDS110        ANDNE     *BLANK
     C     KDS120        ORNE      KDS070
     C     KDS120        ANDNE     *BLANK
     C     KDS130        ORNE      KDS080
     C     KDS130        ANDNE     *ZERO
     C     KDS140        ORNE      KDS090
     C     KDS140        ANDNE     *BLANK
     C                   EXSR      UKDVS
     C                   ENDIF
     C*
     C                   EXSR      UKUEG
     C                   EXSR      UKDZR
     C                   EXSR      UKDAP
     C                   EXSR      UKDEW
     C*
     C     KDS590        IFNE      *ZERO
     C     KDS600        ORNE      *ZERO
     C     KDS610        ORNE      *ZERO
     C     KDS620        ORNE      *ZERO
     C     KDS630        ORNE      *ZERO
     C                   EXSR      UVEZU
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN FELDER FÜR UPDATE                                     ***
     C**************************************************************************
     C     EKUND         BEGSR
     C*
     C                   EVAL      WKIUPD      = *ON
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTAT      = '90'                           NICHT AKTIV
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDS020        WKKDNR
     C                   Z-ADD     6             WKKDLN
     C                   EXSR      UMS_KDNR
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKDNR        DUC006
     C                   Z-ADD     1             I4
     C     DUC006        LOOKUP    KD_ALT(I4)                             99
     C*
     C                   IF        *IN99       = *OFF
     C                   EVAL      WKIUPD      = *OFF
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   EVAL      *IN99       = *OFF
     C*--------------------------------------------------------
     C                   MOVEL(P)  WKKDNR        KUNDKDNR
     C*--------------------------------------------------------
     C     KDS190        IFNE      *ZERO                                        KUNDENNR
     C                   MOVEL(P)  KDS190        WKKDNR                         HAUPTGESCHÄFT ->
     C                   Z-ADD     6             WKKDLN                         KONDITIONSKUNDEN-NR
     C                   EXSR      UMS_KDNR
     C                   MOVEL(P)  WKKDNR        KUNDKOKD
     C                   ELSE
     C                   MOVE      *BLANK        KUNDKOKD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     KDS290        WHENEQ    1
     C                   MOVEL     'D'           KUNDSPCD                       SPRACHCODE
     C     KDS290        WHENEQ    2
     C                   MOVEL     'E'           KUNDSPCD
     C     KDS290        WHENEQ    3
     C                   MOVEL     'F'           KUNDSPCD
     C     KDS290        WHENEQ    4
     C                   MOVEL     'I'           KUNDSPCD
     C     KDS290        WHENEQ    5
     C                   MOVEL     'N'           KUNDSPCD
     C                   OTHER
     C                   MOVEL     'D'           KUNDSPCD
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EVAL      KUNDPOLD    = %TRIM(KDS070)                  POSTAL.LAND
     C*
     C                   IF        KUNDPOLD    = *BLANK
     C                   EVAL      KUNDPOLD    = 'DE'
     C                   ENDIF
     C*--------------------------------------------------------
     C     KDS080        IFEQ      *ZERO
     C                   MOVE      *BLANK        KUNDPOLZ                       PLZ
     C                   ELSE
     C                   MOVEL(P)  KDS080        KUNDPOLZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     KDS340        IFNE      *ZERO
     C                   MOVEL(P)  KDS340        WKKDNR                         KUNDENNR. RECHNUNG
     C                   Z-ADD     6             WKKDLN
     C                   EXSR      UMS_KDNR
     C                   MOVEL(P)  WKKDNR        KUNDRAKD
     C                   ELSE
     C                   MOVE      *BLANK        KUNDRAKD
     C                   ENDIF
     C*--------------------------------------------------------
     C     KDS360        IFNE      *ZERO
     C                   MOVEL(P)  KDS360        WKKDNR                         KUNDENNR. DEBITOR
     C                   Z-ADD     6             WKKDLN
     C                   EXSR      UMS_KDNR
     C                   MOVEL(P)  WKKDNR        KUNDDBKD
     C                   ELSE
     C                   MOVE      *BLANK        KUNDDBKD
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  KUNDPOLD      WKPOLD                         POSTALISCHES LAND IN
     C                   MOVE      *BLANK        WKLAND                         LÄNDERNUMMER
     C                   EXSR      POLD_LAND                                    UMSETZEN
     C                   MOVEL(P)  WKPOLD        KUNDPOLD
     C                   MOVEL(P)  WKLAND        KUNDLAND
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      KDS160      = 99
     C                   MOVEL(P)  'EUR'         KUNDWACD
     C                   WHEN      KDS160      = 09
     C                   MOVEL(P)  'USD'         KUNDWACD
     C                   WHEN      KDS160      = 20
     C                   MOVEL(P)  'PLN'         KUNDWACD
     C                   ENDSL
     C*--------------------------------------------------------
     C                   SELECT
     C     KDS810        WHENEQ    50
     C                   MOVEL     'V'           KUNDABMA                       ABSATZMARKT
     C     KUNDPOLD      WHENEQ    'DE'
     C                   MOVEL     'I'           KUNDABMA
     C     WKLDGR        WHENEQ    '0001'
     C                   MOVEL     'G'           KUNDABMA
     C                   OTHER
     C                   MOVEL     'E'           KUNDABMA
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDS030        WKNAM1                         KURZNAMEN AUFBAUEN
     C                   MOVEL(P)  KDS090        WKWORT
     C                   MOVE      *BLANK        WKKNAM
     C                   EXSR      BAUE_KDKNAM
     C                   MOVEL(P)  WKKNAM        KUNDKNAM
     C*--------------------------------------------------------
     C     WKSTRASPLI    IFEQ      *ON                                          STRASSE (SPLITTEN IN
     C                   MOVEL(P)  KDS060        WKC030                         STR./HAUSNR. BEI
     C                   MOVEL     *BLANK        WKSTRA                         LAND D,A,CH)
     C                   MOVEL     *BLANK        WKHSNR
     C                   EXSR      STRA_HSNR
     C                   MOVEL(P)  WKSTRA        KUNDSTRA
     C                   MOVEL(P)  WKHSNR        KUNDHSNR
     C                   ELSE
     C                   MOVEL(P)  KDS060        KUNDSTRA
     C                   MOVEL(P)  *BLANK        KUNDHSNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        KDS670     <> *ZERO
     C                   Z-ADD     KDS670        WKACAB                         ANZAHL AB
     C                   ELSE
     C                   Z-ADD     1             WKACAB
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      DUC013      = KDS040
     C                   TESTN                   DUC013               97
     C*
     C                   IF        *IN97       = *ON
     C                   EVAL      WKILNR      = DUC013
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KUND                                                 ***
     C**************************************************************************
     C     UKUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KUNDKDNR      KYKDNR
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKUND                                       UPDATE
     C*-------------------------------------------------------------------------
     C     CHI(6)        IFEQ      *ON
     C                   EXSR      ETRMUKUND
     C                   MOVEL(P)  KUNDKDNR      KDKDNR
     C                   MOVE      *ON           CHI(6)
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  KDS030        KDNAM1                         NAME1
     C                   MOVEL(P)  KDS040        KDNAM2                         NAME2
     C                   MOVEL(P)  KDS050        KDNAM3                         FILIALE -> NAME 3
     C                   EVAL      KDSTRA      = KUNDSTRA                       STRASSE
     C                   EVAL      KDHSNR      = KUNDHSNR                       HAUSNUMMER
     C                   EVAL      KDPOLD      = KUNDPOLD                       POSTAL.LAND
     C                   EVAL      KDPOLZ      = KUNDPOLZ                       PLZ
     C                   MOVEL(P)  KDS090        KDWORT                         ORT
     C                   MOVEL(P)  KDS100        KDMCBG                         MATCHCODE
     C                   Z-ADD     KDS170        DUN030                         VERSANDBEDINGUNG
     C                   MOVEL(P)  DUC003        KDVSBD
     C                   Z-ADD     KDS180        DUN030                         FREIVERMERK ->
     C                   MOVEL(P)  DUC003        KDLIBD                         LIEFERBEDINGUNG
     C                   EVAL      KDKOKD      = KUNDKOKD                       KDNR KONDITION
     C                   Z-ADD     KDS200        DUN030
     C                   MOVEL(P)  DUC003        KDKDGR                         KUNDENGRUPPE
     C                   Z-ADD     KDS210        DUN030                         BRANCHE ->
     C                   MOVEL(P)  DUC003        KDNIGB                         NIELSENGEBIET
     C                   MOVEL(P)  KDS240        KDLIFN                         LFNR BEIM KUNDEN
     C                   MOVEL(P)  KDS270        KDTLNR                         TELEFON
     C                   MOVEL(P)  KDS275        KDTFNR                         TELEFAX
     C                   MOVEL(P)  KDS580        KDKSTC                         ABSATZGRUPPE
     C                   EVAL      KDSPCD      = KUNDSPCD                       SPRACHCODE
     C                   EVAL      KDRAKD      = KUNDRAKD                       KUNDENNR. RECHNUNG
     C                   EVAL      KDDBKD      = KUNDDBKD                       KUNDENNR. DEBITOR
     C*
     C     KDS390        IFEQ      *ZERO
     C                   MOVEL(P)  '1'           KDBNKZ                         BONITÄT
     C                   ELSE
     C                   MOVEL(P)  KDS390        KDBNKZ
     C                   ENDIF
     C*
     C     KDS490        IFNE      '0'
     C                   MOVEL(P)  KDS490        KDSARG                         SA-RG-HD
     C                   ELSE
     C                   MOVE      *BLANK        KDSARG
     C                   ENDIF
     C*
     C                   MOVEL(P)  KDS550        KDZABD                         ZAHLUNGSBEDINGUNG
     C                   Z-ADD     WKACAB        KDACAB                         ANZAHL AB
     C                   Z-ADD     KDS680        KDACFK                         ANZAHL RE
     C                   Z-ADD     KDS690        KDACLS                         ANZAHL LS
     C                   MOVEL(P)  KDS774        KDKNLA                         KONSILAGER
     C                   MOVEL(P)  KDS810        KDWUST                         STEUERART
     C                   MOVEL(P)  DAJNKZ        KDMWST
     C                   EVAL      KDLAND      = KUNDLAND                       LANDNUMMER
     C                   EVAL      KDKNAM      = KUNDKNAM                       KURZNAME
     C                   MOVEL(P)  WKSTAT        KDKDST                         STATUS
     C                   EVAL      KDABMA      = KUNDABMA                       ABSATZMARKT
     C                   EVAL      KDWACD      = KUNDWACD                       WÄHRUNGSCODE
     C     KDS400        MULT      1000          KDKLSU                         KREDITLIMIT
     C*
     C                   IF        KDKNLA     <> *BLANK
     C                   EVAL      KDKSKZ      = DAJNKZ                         KONSIKUNDE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KDJNAM
     C                   MOVEL(P)  WKCHPN        KDPROG
     C                   MOVEL(P)  WKCHPL        KDBIBL
     C                   MOVEL(P)  WKUSER        KDUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KDJZEI
     C                   MOVE      WKTDAT        KDJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKUND                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKUND
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KDVS                                                 ***
     C**************************************************************************
     C     UKDVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYVSKD
     C                   MOVEL(P)  '001'         KYVSNR
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKDVS                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     KDS120        WHENNE    *BLANK                                       LAND LIEFERADRESSE
     C                   MOVEL(P)  KDS120        VSPOLD
     C                   OTHER
     C                   MOVEL(P)  KDPOLD        VSPOLD
     C                   ENDSL
     C*
     C                   MOVEL(P)  VSPOLD        WKPOLD
     C                   MOVE      *BLANK        WKLAND
     C                   EXSR      POLD_LAND
     C                   MOVEL(P)  WKPOLD        VSPOLD
     C                   MOVEL(P)  WKLAND        VSLAND
     C*
     C     KDS130        IFNE      *ZERO
     C                   MOVEL(P)  KDS130        VSPOLZ                         PLZ LIEFERADRESSE
     C                   ELSE
     C                   MOVEL(P)  KDPOLZ        VSPOLZ
     C                   ENDIF
     C*
     C* STRASSE (SPLITTEN IN STR./HAUSNR. abhängig von WKSTRASPLI)
     C*
     C     KDS110        IFNE      *BLANK
     C*
     C     WKSTRASPLI    IFEQ      *ON
     C                   MOVEL(P)  KDS110        WKC030
     C                   MOVEL     *BLANK        WKSTRA
     C                   MOVEL     *BLANK        WKHSNR
     C                   EXSR      STRA_HSNR
     C                   MOVEL(P)  WKSTRA        VSSTRA
     C                   MOVEL(P)  WKHSNR        VSHSNR
     C                   ELSE
     C                   MOVEL(P)  KDS110        VSSTRA
     C                   MOVEL(P)  *BLANK        VSHSNR
     C                   ENDIF
     C*
     C                   ELSE
     C                   MOVEL(P)  KDSTRA        VSSTRA
     C                   MOVEL(P)  KDHSNR        VSHSNR
     C                   ENDIF
     C*
     C     KDS140        IFNE      *BLANK
     C                   MOVEL(P)  KDS140        VSWORT                         ORT LIEFERADRESSE
     C                   ELSE
     C                   MOVEL(P)  KDWORT        VSWORT
     C                   ENDIF
     C*
     C                   MOVEL(P)  '01'          VSVSST                         STATUS
     C                   MOVEL(P)  KDNAM1        VSNAM1                         NAME 1
     C                   MOVEL(P)  KDNAM2        VSNAM2                         NAME 2
     C                   MOVEL(P)  KDNAM3        VSNAM3                         FILIALE -> NAME 3
     C                   MOVEL(P)  KDMCBG        VSMCBG                         MATCHCODE
     C                   MOVEL(P)  KDKNAM        VSKNAM                         KURZNAME
     C                   MOVEL(P)  KDTLNR        VSTLNR                         TELEFON
     C                   MOVEL(P)  KDTXNR        VSTXNR                         ANSPRECHPARTNER
     C                   MOVEL(P)  KDTFNR        VSTFNR                         TELEFAX
     C                   MOVEL(P)  KDLAND        VSLAND                         LAND
     C                   MOVEL(P)  KDABMA        VSABMA                         ABSATZMARKT
     C                   MOVEL(P)  KDSPCD        VSSPCD                         SPRACHCODE
     C                   MOVEL(P)  KDMWST        VSMWST                         MWST-CODE
     C                   MOVEL(P)  KDVSBD        VSVSBD                         VERSANDBED.
     C                   MOVEL(P)  KDLIBD        VSLIBD                         LIEFERBED.
     C                   MOVEL(P)  KDVPEI        VSVPEI                         VERP-BED.
     C                   MOVEL(P)  KDVKGB        VSVKGB                         VK-GEBIET
     C                   MOVEL(P)  KDLANR        VSLANR                         LAGERNR
     C                   MOVEL(P)  WKILNR        VSEDIL                         ILN
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        VSJNAM
     C                   MOVEL(P)  WKCHPN        VSPROG
     C                   MOVEL(P)  WKCHPL        VSBIBL
     C                   MOVEL(P)  WKUSER        VSUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        VSJZEI
     C                   MOVE      WKTDAT        VSJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKDVS                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKDVS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KUEG                                                 ***
     C**************************************************************************
     C     UKUEG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKEKD
     C                   MOVEL(P)  WKLAND        KYKELD
     C                   MOVEL(P)  KYVSNR        KYKEVS
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKUEG                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDS150        KEUSTI                         EXPRESS-STATION
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KEJNAM
     C                   MOVEL(P)  WKCHPN        KEPROG
     C                   MOVEL(P)  WKCHPL        KEBIBL
     C                   MOVEL(P)  WKUSER        KEUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KEJZEI
     C                   MOVE      WKTDAT        KEJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C     KEUSTI        ANDEQ     *BLANK
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKUEG
     C                   LEAVESR
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKUEG                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKUEG
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   IF        KYKEVS     <> '001'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKEKD
     C                   MOVEL(P)  WKLAND        KYKELD
     C                   MOVE      *BLANK        KYKEVS
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHKUEG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KEJNAM
     C                   MOVEL(P)  WKCHPN        KEPROG
     C                   MOVEL(P)  WKCHPL        KEBIBL
     C                   MOVEL(P)  WKUSER        KEUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KEJZEI
     C                   MOVE      WKTDAT        KEJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C     KEUSTI        ANDEQ     KDS150
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKUEG
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEL(P)  KDS150        KEUSTI
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKUEG                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKUEG
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KDZR                                                 ***
     C**************************************************************************
     C     UKDZR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKDZRKDNR
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKDZR                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   IF        KDS220     <> 000
     C                   MOVEL(P)  KDS220        KDZRVBKD                       VERBANDNR
     C                   ENDIF
     C*
     C                   IF        KDS230     <> '0000000'
     C                   MOVEL(P)  KDS230        KDZRMIKD                       MITGLIEDSNR VERBAND
     C                   ENDIF
     C*
     C     KDS320        IFNE      *ZERO
     C                   MOVEL(P)  KDS320        WKKDNR                         KUNDEN-NR
     C                   Z-ADD     6             WKKDLN                         AUFTR.-BEST.
     C                   EXSR      UMS_KDNR
     C                   MOVEL(P)  WKKDNR        KDZRABKD
     C                   ELSE
     C                   MOVE      *BLANK        KDZRABKD
     C                   ENDIF
     C*
     C                   SELECT
     C                   WHEN      KDKDGR      = '018'         AND
     C                             KDDBKD      = '006449'
     C                   EVAL      KDZRZRKD    = '045011'
     C                   WHEN      KDKDGR      = '018'         AND
     C                             KDDBKD      = '045011'
     C                   EVAL      KDZRZRKD    = '045011'
     C                   WHEN      KDKDGR      = '018'         AND
     C                             KDDBKD      = '092452'
     C                   EVAL      KDZRZRKD    = '045011'
     C                   WHEN      KDKDGR      = '018'         AND
     C                             KDDBKD      = '095893'
     C                   EVAL      KDZRZRKD    = '045011'
     C                   WHEN      KDKDGR      = '025'         AND
     C                             KDDBKD      = '009788'
     C                   EVAL      KDZRZRKD    = '009788'
     C                   WHEN      KDKDGR      = '016'         AND
     C                             KDDBKD      = '097299'
     C                   EVAL      KDZRZRKD    = '097299'
     C                   WHEN      KDKDGR      = '014'         AND
     C                             KDDBKD      = '097293'
     C                   EVAL      KDZRZRKD    = '097293'
     C                   WHEN      KDKDGR      = '026'         AND
     C                             KDDBKD      = '097299'
     C                   EVAL      KDZRZRKD    = '097299'
     C                   WHEN      KDKOKD      = '002377'      AND
     C                             KDDBKD      = '091522'
     C                   EVAL      KDZRZRKD    = '091522'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KDZRJNAM
     C                   MOVEL(P)  WKCHPN        KDZRPROG
     C                   MOVEL(P)  WKCHPL        KDZRBIBL
     C                   MOVEL(P)  WKUSER        KDZRUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KDZRJZEI
     C                   MOVE      WKTDAT        KDZRJDAT
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON                                          NICHT SCHREIBEN
     C     KDZRVBKD      ANDEQ     *BLANK                                       WENN KEIN INHALT
     C     KDZRABKD      ANDEQ     *BLANK
     C     KDZRMIKD      ANDEQ     *BLANK
     C     KDZRZRKD      ANDEQ     *BLANK
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHKDZR
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKDZR                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKDZR
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KDAP                                                 ***
     C**************************************************************************
     C     UKDAP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             I0
     C*
     C     KDS250        IFNE      *BLANK                                       GESCHÄFTSFÜHRER
     C                   ADD       1             I0
     C                   MOVEL(P)  'GL'          KYK2AR
     C                   MOVEL(P)  KDKDNR        KYK2NR
     C                   MOVEL(P)  KYVSNR        KYK2LF
     C                   MOVEL(P)  KDMCBG        KYK2MC
     C                   Z-ADD     I0            KYK2RG
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKDAP                                       UPDATE
     C*-------------------------------------------------------------------------
     C     1             SUBST     KDS250:1      WKC001
      *
     C     WKC001        IFEQ      'F'
     C                   MOVEL(P)  '1'           K2ANCD
     C                   ELSE
     C                   MOVEL(P)  '2'           K2ANCD
     C                   ENDIF
     C*
     C                   SUBST(P)  KDS250:3      K2NAM1
     C                   EXSR      REST_KDAP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        K2JNAM
     C                   MOVEL(P)  WKCHPN        K2PROG
     C                   MOVEL(P)  WKCHPL        K2BIBL
     C                   MOVEL(P)  WKUSER        K2USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        K2JZEI
     C                   MOVE      WKTDAT        K2JDAT
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKDAP                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKDAP
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KDS260        IFNE      *BLANK                                       EINKÄUFER
     C                   ADD       1             I0
     C                   MOVEL(P)  'EK'          KYK2AR
     C                   MOVEL(P)  KDKDNR        KYK2NR
     C                   MOVEL(P)  KYVSNR        KYK2LF
     C                   MOVEL(P)  KDMCBG        KYK2MC
     C                   Z-ADD     I0            KYK2RG
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKDAP                                       UPDATE
     C*-------------------------------------------------------------------------
     C     1             SUBST     KDS260:1      WKC001
      *
     C     WKC001        IFEQ      'F'
     C                   MOVEL(P)  '1'           K2ANCD
     C                   ELSE
     C                   MOVEL(P)  '2'           K2ANCD
     C                   ENDIF
      *
     C                   SUBST(P)  KDS260:3      K2NAM1
     C                   EXSR      REST_KDAP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        K2JNAM
     C                   MOVEL(P)  WKCHPN        K2PROG
     C                   MOVEL(P)  WKCHPL        K2BIBL
     C                   MOVEL(P)  WKUSER        K2USER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        K2JZEI
     C                   MOVE      WKTDAT        K2JDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKDAP                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKDAP
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI KDEW                                                 ***
     C**************************************************************************
     C     UKDEW         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDKDNR        KYKDEWKDNR
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHKDEW                                       UPDATE
     C*--------------------------------------------------------
     C     CHI(6)        IFEQ      *ON
     C                   EXSR      ETRMUKDEW
     C                   MOVEL(P)  KDKDNR        KDEWKDNR
     C                   MOVE      *ON           CHI(6)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDS280        KDEWKDKR                       LANDKREIS ->
     C*                                                                         KUNDENKREIS
     C     KDS640        IFEQ      '1'
     C     KDS640        OREQ      '0'                                          DRUCKEN BRUTTOPREIS
     C                   MOVEL     KDS640        KDEWBLKZ                       AUF LIEFERSCHEIN
     C                   ELSE
     C                   MOVEL     '0'           KDEWBLKZ
     C                   ENDIF
     C*
     C     KDS779        IFNE      *ZERO                                        BOVIS-KUNDENGRUPPE
     C                   MOVEL     KDS779        WKC003
     C     1             SUBST(P)  WKC003:3      KDEWBVKG
     C                   ELSE
     C                   MOVE      *BLANK        KDEWBVKG
     C                   ENDIF
     C*
     C                   Z-ADD     KDS760        WKN040                         KOSTENSTELLE
     C     WKN040        IFNE      *ZERO                                        RECHTSBÜNDIG
     C                   MOVEL(P)  WKN040        KDEWKSST
     C                   ELSE
     C                   MOVE      *BLANK        KDEWKSST
     C                   ENDIF
     C*
     C     KDS330        IFEQ      *BLANK                                       GEBIETSSCHUTZ
     C                   MOVEL     '0'           KDEWGSKZ
     C                   ELSE
     C                   MOVEL     '1'           KDEWGSKZ
     C                   ENDIF
     C*
     C                   IF        KDS210      = 65
     C                   EVAL      KDEWDAGB    = *ON
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        KDEWJNAM
     C                   MOVEL(P)  WKCHPN        KDEWPROG
     C                   MOVEL(P)  WKCHPL        KDEWBIBL
     C                   MOVEL(P)  WKUSER        KDEWUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        KDEWJZEI
     C                   MOVE      WKTDAT        KDEWJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHKDEW                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHKDEW
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI VEZU                                                 ***
     C**************************************************************************
     C     UVEZU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             I0
     C*
     C     KDS590        IFNE      *ZERO
     C                   ADD       1             I0
     C                   Z-ADD     KDS590        WKVT(I0)
     C                   ENDIF
     C*
     C     KDS600        IFNE      *ZERO
     C                   ADD       1             I0
     C                   Z-ADD     KDS600        WKVT(I0)
     C                   ENDIF
     C*
     C     KDS610        IFNE      *ZERO
     C                   ADD       1             I0
     C                   Z-ADD     KDS610        WKVT(I0)
     C                   ENDIF
     C*
     C     KDS620        IFNE      *ZERO
     C                   ADD       1             I0
     C                   Z-ADD     KDS620        WKVT(I0)
     C                   ENDIF
     C*
     C     KDS630        IFNE      *ZERO
     C                   ADD       1             I0
     C                   Z-ADD     KDS630        WKVT(I0)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'VE3'         KYVZBG
     C                   MOVEL(P)  KDKDNR        KYVZKL
     C                   Z-ADD     WKGADA        KYVZDA
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHVEZU                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKVT(1)       VZVTN1                         VERTRETER 1 (+ GGF.
     C*                                                                         2 - 5)
     C     WKVT(2)       IFNE      *ZERO
     C                   MOVEL(P)  WKVT(2)       VZVTN2
     C                   ELSE
     C                   MOVE      *BLANK        VZVTN2
     C                   ENDIF
     C*
     C     WKVT(3)       IFNE      *ZERO
     C                   MOVEL(P)  WKVT(3)       VZVTN3
     C                   ELSE
     C                   MOVE      *BLANK        VZVTN3
     C                   ENDIF
     C*
     C     WKVT(4)       IFNE      *ZERO
     C                   MOVEL(P)  WKVT(4)       VZVTN4
     C                   ELSE
     C                   MOVE      *BLANK        VZVTN4
     C                   ENDIF
     C*
     C     WKVT(5)       IFNE      *ZERO
     C                   MOVEL(P)  WKVT(5)       VZVTN5
     C                   ELSE
     C                   MOVE      *BLANK        VZVTN5
     C                   ENDIF
     C*
     C                   MOVEL(P)  DAJNAM        VZJNAM
     C                   MOVEL(P)  WKCHPN        VZPROG
     C                   MOVEL(P)  WKCHPL        VZBIBL
     C                   MOVEL(P)  WKUSER        VZUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        VZJZEI
     C                   MOVE      WKTDAT        VZJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C     VZVTN1        ANDEQ     *BLANK
     C                   MOVEA     '01F     '    CHI
     C                   EXSR      CHVEZU
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI                            SATZ HINZU-
     C                   EXSR      CHVEZU                                       FÜGEN
     C*--------------------------------------------------------
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHVEZU
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILCK
     C     *LIKE         DEFINE    WKC001        WKIUPD
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKC003          + 2
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKC015          +14
     C     *LIKE         DEFINE    WKC001        WKC030          +29
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKSTRASPLI
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        I3              + 2
     C     *LIKE         DEFINE    WKN010        I4              + 3
     C     *LIKE         DEFINE    WKN010        WKKDLN          + 1
     C     *LIKE         DEFINE    WKN010        WKN040          + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DSJNAM        WKJNAM
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSPROG        WKPROG
     C     *LIKE         DEFINE    DSBIBL        WKBIBL
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KDKDST        WKSTAT
     C     *LIKE         DEFINE    KDKDNR        WKKDNR
     C     *LIKE         DEFINE    KDKDNR        WKNULL
     C     *LIKE         DEFINE    KDPOLD        WKPOLD
     C     *LIKE         DEFINE    KDLAND        WKLAND
     C     *LIKE         DEFINE    KDNAM1        WKNAM1
     C     *LIKE         DEFINE    KDWORT        WKWORT
     C     *LIKE         DEFINE    KDKNAM        WKKNAM
     C     *LIKE         DEFINE    KDSTRA        WKSTRA
     C     *LIKE         DEFINE    KDHSNR        WKHSNR
     C     *LIKE         DEFINE    KDACAB        WKACAB
     C*
     C     *LIKE         DEFINE    KDKDNR        KUNDKDNR
     C     *LIKE         DEFINE    KDDBKD        KUNDDBKD
     C     *LIKE         DEFINE    KDKOKD        KUNDKOKD
     C     *LIKE         DEFINE    KDRAKD        KUNDRAKD
     C     *LIKE         DEFINE    KDPOLD        KUNDPOLD
     C     *LIKE         DEFINE    KDPOLZ        KUNDPOLZ
     C     *LIKE         DEFINE    KDSPCD        KUNDSPCD
     C     *LIKE         DEFINE    KDLAND        KUNDLAND
     C     *LIKE         DEFINE    KDKNAM        KUNDKNAM
     C     *LIKE         DEFINE    KDABMA        KUNDABMA
     C     *LIKE         DEFINE    KDWACD        KUNDWACD
     C     *LIKE         DEFINE    KDSTRA        KUNDSTRA
     C     *LIKE         DEFINE    KDHSNR        KUNDHSNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    VSEDIL        WKILNR
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    LNLDGR        WKLDGR
     C     *LIKE         DEFINE    LNLISO        WKLISO
     C     *LIKE         DEFINE    LNWUKZ        WKWUKZ
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    VZVTN1        WKVTN1
     C     *LIKE         DEFINE    VZGADA        WKGADA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMUKUND     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KUND'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'KUND'        EXDATAFILE
     C                   MOVEL(P)  TRMUDATA      EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    KUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS MUSTERDATEI                                   ***
     C**************************************************************************
     C     ETRMUKDEW     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KDEW'        KYTRMUDANA
     C                   MOVE      *BLANK        KYTRMUKEY1
     C                   MOVE      *BLANK        KYTRMUKEY2
     C                   MOVE      *BLANK        KYTRMUKEY3
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRMU
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   CLEAR                   EXDATA
     C                   MOVEL(P)  'KDEW'        EXDATAFILE
     C                   MOVEL(P)  TRMUDATA      EXDATADATA
     C                   CALL      'INZDATASTR'
     C                   PARM                    EXDATA
     C                   PARM                    RTDATA
     C*
     C                   MOVEL(P)  RTDATADATA    KDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LANDNUMMER UND ECHTES POSTAL. LAND AUS POSTAL. LAND INP ***
     C**************************************************************************
     C     POLD_LAND     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      %TRIM(WKPOLD)='A'           OR
     C                             %TRIM(WKPOLD)='AT'
     C                   MOVEL(P)  '038'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='B'           OR
     C                             %TRIM(WKPOLD)='BE'
     C                   MOVEL(P)  '017'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='BG'
     C                   MOVEL(P)  '068'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='CH'
     C                   MOVEL(P)  '039'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='CZ'
     C                   MOVEL(P)  '061'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='D'           OR
     C                             %TRIM(WKPOLD)='DE'
     C                   MOVEL(P)  '004'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='DK'
     C                   MOVEL(P)  '008'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='E'           OR
     C                             %TRIM(WKPOLD)='ES'
     C                   MOVEL(P)  '011'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='EE'          OR
     C                             %TRIM(WKPOLD)='EST'
     C                   MOVEL(P)  '053'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='F'           OR
     C                             %TRIM(WKPOLD)='FR'
     C                   MOVEL(P)  '001'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='FI'          OR
     C                             %TRIM(WKPOLD)='FIN'
     C                   MOVEL(P)  '032'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='GB'
     C                   MOVEL(P)  '006'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='GR'
     C                   MOVEL(P)  '009'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='HU'
     C                   MOVEL(P)  '064'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='IL'
     C                   MOVEL(P)  '624'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='IE'          OR
     C                             %TRIM(WKPOLD)='IRL'
     C                   MOVEL(P)  '007'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='IS'
     C                   MOVEL(P)  '024'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='I'           OR
     C                             %TRIM(WKPOLD)='IT'
     C                   MOVEL(P)  '005'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='J'           OR
     C                             %TRIM(WKPOLD)='JP'
     C                   MOVEL(P)  '732'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='LI'
     C                   MOVEL(P)  '037'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='LT'
     C                   MOVEL(P)  '055'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='L'           OR
     C                             %TRIM(WKPOLD)='LU'
     C                   MOVEL(P)  '018'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='LV'
     C                   MOVEL(P)  '054'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='NL'
     C                   MOVEL(P)  '003'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='N'           OR
     C                             %TRIM(WKPOLD)='NO'
     C                   MOVEL(P)  '028'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='PL'
     C                   MOVEL(P)  '060'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='P'           OR
     C                             %TRIM(WKPOLD)='PT'
     C                   MOVEL(P)  '010'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='RO'
     C                   MOVEL(P)  '066'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='S'           OR
     C                             %TRIM(WKPOLD)='SE'
     C                   MOVEL(P)  '030'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='SI'          OR
     C                             %TRIM(WKPOLD)='SLO'
     C                   MOVEL(P)  '091'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='SK'
     C                   MOVEL(P)  '063'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='TR'
     C                   MOVEL(P)  '052'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='US'          OR
     C                             %TRIM(WKPOLD)='USA'
     C                   MOVEL(P)  '400'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='H'           OR
     C                             %TRIM(WKPOLD)='HUN'
     C                   MOVEL(P)  '064'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='VAE'         OR
     C                             %TRIM(WKPOLD)='UAE'
     C                   MOVEL(P)  '647'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='PRC'         OR
     C                             %TRIM(WKPOLD)='VR'
     C                   MOVEL(P)  '720'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='MEX'
     C                   MOVEL(P)  '412'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='IND'
     C                   MOVEL(P)  '664'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='ROK'
     C                   MOVEL(P)  '728'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='SGP'
     C                   MOVEL(P)  '706'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='EAU'
     C                   MOVEL(P)  '350'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='ROC'
     C                   MOVEL(P)  '736'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='MAL'
     C                   MOVEL(P)  '701'         WKLAND
     C                   WHEN      %TRIM(WKPOLD)='M'
     C                   MOVEL(P)  '046'         WKLAND
     C                   WHEN      WKLAND      = *BLANK
     C                   EXSR      ERLAND
     C                   ENDSL
     C*
     C     WKLAND        IFNE      *BLANK
     C                   MOVE      *BLANK        WKPOLD
     C                   MOVE      *BLANK        WKLDGR
     C                   MOVE      *BLANK        WKLISO
     C                   EXSR      LIES_LAND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBAUEN KUNDENKURZNAMEN AUS KUNDENNAME 1 UND ORT                 ***
     C**************************************************************************
     C     BAUE_KDKNAM   BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             I0
     C     ' '           CHECKR    WKWORT        I0                             URSPR.-LÄNGE ORT
     C     I0            IFLT      15
     C     30            SUB       I0            I1                             KURZE LÄNGE ORT
     C                   SUB       1             I1
     C                   ELSE
     C                   Z-ADD     0             I0
     C     ' '           CHECK     WKWORT        I0
     C     I0            IFLT      15
     C     30            SUB       I0            I1                             KURZE LÄNGE ORT
     C                   SUB       1             I1
     C                   ELSE
     C                   Z-ADD     15            I0
     C                   Z-ADD     15            I1
     C                   ENDIF
     C                   ENDIF
     C*
     C     I1            IFLE      0
     C                   MOVEL(P)  WKNAM1        WKKNAM
     C                   CAT       WKWORT:1      WKKNAM
     C                   ELSE
     C     I1            SUBST(P)  WKNAM1:1      WKKNAM
     C                   CAT       WKWORT:1      WKKNAM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SPLITTEN STRASSE IN STRASSE UND HAUSNUMMER                        ***
     C**************************************************************************
     C     STRA_HSNR     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C     WKLAND        LOOKUP    STHS(I0)                               91
     C     *IN91         IFEQ      *OFF
     C                   MOVEL(P)  WKC030        WKSTRA
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     WKC030        W30
     C     ' '           CHECKR    WKC030        I0
     C                   ADD       1             I0
     C                   Z-ADD     0             I1
     C                   Z-ADD     0             I2
     C                   Z-ADD     0             I3
     C*
     C     I0            DOWGT     1
     C*
     C                   SUB       1             I0
     C*
     C* LETZTE BELEGTE POS.
     C*
     C     W30(I0)       IFNE      *BLANK
     C     I1            ANDEQ     *ZERO
     C                   Z-ADD     I0            I1
     C                   ITER
     C                   ENDIF
     C*
     C* ERSTE NUMERISCH BELEGTE POS.
     C*
     C     W30(I0)       IFGE      '0'
     C     W30(I0)       ANDLE     '9'
     C     I3            ANDLT     10
     C                   Z-ADD     I0            I2
     C                   ITER
     C                   ENDIF
     C*
     C     W30(I0)       IFLT      '0'
     C                   ADD       1             I3
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C* BEREICH ERSTE NUM. BELEGTE - LETZTE BELEGTE POS.
     C* = LÄNGE HAUSNUMMER
     C*
     C     I2            SUB       1             I0
     C     I0            IFGT      1
     C     I0            SUBST(P)  WKC030:1      WKSTRA
     C                   SUBST(P)  WKC030:I2     WKHSNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LAND-INFO ÜBER LANDCODE ISO ERMITTELN                             ***
     C**************************************************************************
     C     ERLAND        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKPOLD      = %TRIM(WKPOLD)
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C     WKPOLD        LOOKUP    WKLP(I0)                               91
     C     *IN91         IFEQ      *ON
     C                   MOVEL     WKLG(I0)      WKLDGR
     C                   MOVEL     WKLN(I0)      WKLAND
     C                   MOVEL     WKLI(I0)      WKLISO
     C                   MOVEL     WKLW(I0)      WKWUKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LAND-INFO AUS PROGRAMM-ARRAY LESEN                                ***
     C**************************************************************************
     C     LIES_LAND     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C     WKLAND        LOOKUP    WKLN(I0)                               91
     C     *IN91         IFEQ      *ON
     C                   MOVEL     WKLG(I0)      WKLDGR
     C                   MOVEL     WKLI(I0)      WKLISO
     C                   MOVEL     WKLP(I0)      WKPOLD
     C                   MOVEL     WKLW(I0)      WKWUKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FELDER KDAP AUS KUND BZW. KDVS FÜLLEN                             ***
     C**************************************************************************
     C     REST_KDAP     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* STATUS
     C*
     C                   MOVEL(P)  '01'          K2VSST
     C*
     C* NAME 2
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDNAM1        K2NAM2
     C                   ELSE
     C                   MOVEL(P)  VSNAM1        K2NAM2
     C                   ENDIF
     C*
     C* FILIALE -> NAME 3
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDNAM2        K2NAM3
     C                   ELSE
     C                   MOVEL(P)  VSNAM2        K2NAM3
     C                   ENDIF
     C*
     C* MATCHCODE
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDMCBG        K2MCBG
     C                   ELSE
     C                   MOVEL(P)  VSMCBG        K2MCBG
     C                   ENDIF
     C*
     C* KURZNAME
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDKNAM        K2KNAM
     C                   ELSE
     C                   MOVEL(P)  VSKNAM        K2KNAM
     C                   ENDIF
     C*
     C* STRASSE
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDSTRA        K2STRA
     C                   ELSE
     C                   MOVEL(P)  VSSTRA        K2STRA
     C                   ENDIF
     C*
     C* HAUSNR
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDHSNR        K2HSNR
     C                   ELSE
     C                   MOVEL(P)  VSHSNR        K2HSNR
     C                   ENDIF
     C*
     C* POSTAL. LAND
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDPOLD        K2POLD
     C                   ELSE
     C                   MOVEL(P)  VSPOLD        K2POLD
     C                   ENDIF
     C*
     C* PLZ
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDPOLZ        K2POLZ
     C                   ELSE
     C                   MOVEL(P)  VSPOLZ        K2POLZ
     C                   ENDIF
     C*
     C* ORT
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDWORT        K2WORT
     C                   ELSE
     C                   MOVEL(P)  VSWORT        K2WORT
     C                   ENDIF
     C*
     C* TELEFON
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDTLNR        K2TLNR
     C                   ELSE
     C                   MOVEL(P)  VSTLNR        K2TLNR
     C                   ENDIF
     C*
     C* ANSPRECHPARTNER
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDTXNR        K2TXNR
     C                   ELSE
     C                   MOVEL(P)  VSTXNR        K2TXNR
     C                   ENDIF
     C*
     C* TELEFAX
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDTFNR        K2TFNR
     C                   ELSE
     C                   MOVEL(P)  VSTFNR        K2TFNR
     C                   ENDIF
     C*
     C* LAND
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDLAND        K2LAND
     C                   ELSE
     C                   MOVEL(P)  VSLAND        K2LAND
     C                   ENDIF
     C*
     C* SPRACHCODE
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDSPCD        K2SPCD
     C                   ELSE
     C                   MOVEL(P)  VSSPCD        K2SPCD
     C                   ENDIF
     C*
     C* MWST-CODE
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDMWST        VSMWST
     C                   ELSE
     C                   MOVEL(P)  VSMWST        VSMWST
     C                   ENDIF
     C*
     C* VERSANDBED.
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDVSBD        VSVSBD
     C                   ELSE
     C                   MOVEL(P)  VSVSBD        VSVSBD
     C                   ENDIF
     C*
     C* LIEFERBED.
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDLIBD        VSLIBD
     C                   ELSE
     C                   MOVEL(P)  VSVSBD        VSVSBD
     C                   ENDIF
     C*
     C* VERP-BED.
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDVPEI        VSVPEI
     C                   ELSE
     C                   MOVEL(P)  VSVPEI        VSVPEI
     C                   ENDIF
     C*
     C* VK-GEBIET
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDVKGB        VSVKGB
     C                   ELSE
     C                   MOVEL(P)  VSVKGB        VSVKGB
     C                   ENDIF
     C*
     C* LAGERNR
     C*
     C     KYVSNR        IFEQ      *BLANK
     C                   MOVEL(P)  KDLANR        VSLANR
     C                   ELSE
     C                   MOVEL(P)  VSLANR        VSLANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KUNDENNUMMER MIT FÜHRENDEN NULLEN AUFFÜLLEN                       ***
     C**************************************************************************
     C     UMS_KDNR      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* I0 = ECHTE LÄNGE VON WKKDNR
     C*
     C                   MOVE      *ALL'0'       WKNULL
     C     ' '           CHECKR    WKKDNR        I0
     C*
     C* WENN GEWÜNSCHTE LÄNGE KDNR > 0
     C*  UND ECHTE      LÄNGE KDNR > 0
     C*  UND ECHTE      LÄNGE KDNR < GEWÜNSCHTE LÄNGE
     C*
     C     WKKDLN        IFGT      0
     C     I0            ANDGT     0
     C     I0            ANDLT     WKKDLN
     C*
     C* I0 = ANZAHL NULLEN ZUM AUFFÜLLEN
     C* WKNULL = ZEROS ENTSPR. I0
     C* WKKDNR = WKNULL + KDNR AUS AUFRUF
     C*
     C     WKKDLN        SUB       I0            I0
     C     I0            SUBST(P)  WKNULL:1      WKNULL
     C     WKNULL        CAT(P)    WKKDNR:0      WKKDNR
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHKDVS
     C/COPY QCPYSRC,CHKUEG
     C/COPY QCPYSRC,CHKDZR
     C/COPY QCPYSRC,CHKDAP
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHVEZU
     C/COPY QCPYSRC,CHTRMU
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDATE
     O*****************************************************************
     O*       E N D E  DES PROGRAMMS
     O*****************************************************************
**  STHS : LÄNDER FÜR TRENNUNG STRASSE-HAUSNUMMER (HS-NR RECHTS)
003  NIEDERLANDE
004  DEUTSCHLAND
005  ITALIEN
008  DÄNEMARK
010  PORTUGAL
011  SPANIEN
017  BELGIEN
024  ISLAND
028  NORWEGEN
030  SCHWEDEN
032  FINNLAND
038  ÖSTERREICH
039  SCHWEIZ
053  ESTLAND
054  LETTLAND
055  LITAUEN
060  POLEN
061  TSCHECHIEN
064  UNGARN
063  SLOWAKIEN
091  SLOWENIEN
---
---
---
---
---
---
---
---
---
---
---
