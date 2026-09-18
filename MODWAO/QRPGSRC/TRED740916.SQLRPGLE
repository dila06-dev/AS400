     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Übernahme Rechnungen EDI
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 18.06.2003 HAWA Projekt 2235
     H*  -----------------------------------------------------------------------
     H*  Änderung: SC 05.12.2003 Anpassung neues TZA
     H*  Änderung: RE 05.03.2004 Diverse Anpassungen HAWA
     H*  Änderung: RE 26.03.2004 Diverse Anpassungen HAWA
     H*  Änderung: RE 21.06.2004 PARADIES Hotline 1900
     H*            Ausgabe TAX-Segment, wenn keine MWST
     H*  Änderung: RE 11.11.2004 HAWA Hotline 2616
     H*            Korrektur Wechsel Rechnungs-Nr
     H*  Änderung: RE 11.01.2005 HAWA
     H*            Korrektur Wechsel Rechnungs-Nr
     H*  Änderung: RE 19.01.2005 Standard
     H*            Integration AFPE Kunden-Auftrags-Art EDI
     H*  Änderung: RE 24.05.2005 MÜPRO
     H*            Erweiterung Ausgabe MwSt
     H*  Änderung: ZG 25.01.2006 Standard - AFAD -Hausnummer (NICHT FERTIG !!!!!)
     H*  Änderung: RE 17.05.2006 Müpro Projekt 3638
/*  EH*  Änderung: RE 21.07.2008 AKZO Projekt 5057
     H*  Änderung: RE 04.05.2009 Felder Rechnungs-Jahr und Nummer hinzugrfügt
     H*  Änderung: PH 24.10.2010 Projekt 3267 Standard. Tabelle 'MWST' entfernt
     H*  Änderung: PH 28.10.2010 Projekt 6498 für Kunde BUSCH/Standard. Feld AFRP.RPBRSU durch
     H*            AFRP.RPNESU ersetzt. Feld AFRP.RPNESU durch neues Feld AFRP.RPNESU (Warenwert)
     H*            ersetzt. Feld AFRP.RPBRSU wird nicht mehr verwendet (Freifeld ab Release 11.0)
     H*  Änderung: RE 30.09.2014 DOMETIC PROJEKT 10863
     H*  Änderung: PH 03.11.201t DOMETIC Projekt 11683. Ermitteln Partner-Nr über
     H*            Programmaufruf MOICRG (unter MODWAO)
     H**************************************************************************
     F*
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D MWC             S              2    DIM(99)
     D MWT             S             13  2 DIM(99)
     D WWT             S             13  2 DIM(99)
     D*
     D KOD             S              3    DIM(99)
     D KOT             S             40    DIM(99)
     D KOW             S             13  2 DIM(99)
     D ERG             S             13  2 DIM(99)
     D*
     D TXT             S             65    DIM(05)
     D*
     D EDIKOD          S              3    DIM(99)
     D EDIKOT          S             40    DIM(99)
     D EDIKOW          S             13  2 DIM(99)
     D EDIERG          S             13  2 DIM(99)
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
     D*
     D AFED          E DS                  INZ
     D KYAFED        E DS                  INZ
     D*
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D AFRL          E DS                  INZ
     D KYAFRL        E DS                  INZ
     D*
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
     D*
     D AFEP          E DS                  INZ
     D KYAFEP        E DS                  INZ
     D*
     D AFRK          E DS                  INZ
     D KYAFRK        E DS                  INZ
     D*
     D AFRP          E DS                  INZ
     D KYAFRP        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFPE          E DS                  INZ
     D KYAFPE        E DS                  INZ
     D*
     D EDIN          E DS                  INZ
     D KYEDIN        E DS                  INZ
     D*
     D ED73          E DS                  INZ
     D KYED73        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D KDVS          E DS                  INZ
     D KYKDVS        E DS                  INZ
     D*
     D KUEG          E DS                  INZ
     D KYKUEG        E DS                  INZ
     D*
     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D KDZR          E DS                  INZ
     D KYKDZR        E DS                  INZ
     D*
     D ZKUN          E DS                  INZ
     D KYZKUN        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TXST          E DS                  INZ
     D KYTXST        E DS                  INZ
     D*
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D ZLLF          E DS                  INZ
     D KYZLLF        E DS                  INZ
     D*
     D ZRAD          E DS                  INZ
     D KYZRAD        E DS                  INZ
     D*
     D ZRKO          E DS                  INZ
     D KYZRKO        E DS                  INZ
     D*
     D ZRPA          E DS                  INZ
     D KYZRPA        E DS                  INZ
     D*
     D ZABD          E DS                  INZ
     D KYZABD        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXED74        E DS
     D RTED74        E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXADRE        E DS                  INZ
     D RTADRE        E DS                  INZ
     D*
     D EXZABD        E DS                  INZ
     D RTZABD        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D/COPY QCPYSRC,INHOUSE96A
     D*
     D BYADRE        E DS                  EXTNAME(EXADRE) PREFIX(BY) INZ
     D DPADRE        E DS                  EXTNAME(EXADRE) PREFIX(DP) INZ
     D IVADRE        E DS                  EXTNAME(EXADRE) PREFIX(IV) INZ
     D MPADRE        E DS                  EXTNAME(EXADRE) PREFIX(MP) INZ
     D UDADRE        E DS                  EXTNAME(EXADRE) PREFIX(UD) INZ
     D*
     D D$TEEW          DS          1024
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
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
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXED74
     C                   PARM                    RTED74
     C*
     C                   EXSR      UEBED74
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXED74RAKD    KYKZKD
     C     EXED74ZRKD    IFNE      *BLANK
     C                   MOVEL(P)  EXED74ZRKD    KYKZKD
     C                   ENDIF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C                   MOVEL(P)  'EA'          KYEDINEDIF
     C*
     C                   EXSR      VAFRK                                        RECHNUNG
     C*-------------------------------------------------------------------------
     C                   EXSR      UED73
     C*-------------------------------------------------------------------------
     C                   EXSR      NACHLAUF
     C*-------------------------------------------------------------------------
     C*
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
     C                   MOVEL(P)  DAFIRM        KYAKFI
     C                   MOVEL(P)  DAFIRM        KYADFI
     C                   MOVEL(P)  DAFIRM        KYEKFI
     C                   MOVEL(P)  DAFIRM        KYKLFI
     C                   MOVEL(P)  DAFIRM        KYALFI
     C                   MOVEL(P)  DAFIRM        KYAFEPFIRM
     C                   MOVEL(P)  DAFIRM        KYRKFI
     C                   MOVEL(P)  DAFIRM        KYRPFI
     C                   MOVEL(P)  DAFIRM        KYAAFI
     C                   MOVEL(P)  DAFIRM        KYAFPEFIRM
     C                   MOVEL(P)  DAFIRM        KYKDZRFIRM
     C                   MOVEL(P)  DAFIRM        KYEDINFIRM
     C                   MOVEL(P)  'EA'          KYEDINEDIF
     C                   MOVEL(P)  'INVOIC'      KYEDINNTYP
     C                   MOVEL(P)  DAFIRM        KYKDFI
     C                   MOVEL(P)  DAFIRM        KYVSFI
     C                   MOVEL(P)  DAFIRM        KYKEFI
     C                   MOVEL(P)  DAFIRM        KYKPFI
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYTTFI
     C                   MOVEL(P)  DAFIRM        KYWRFI
     C                   MOVEL(P)  DAFIRM        KYSYTPFIRM
     C                   MOVEL(P)  DAFIRM        KYZRKOFIRM
     C                   MOVEL(P)  DAFIRM        KYZLLFFIRM
     C                   MOVEL(P)  DAFIRM        KYZRPAFIRM
     C                   MOVEL(P)  DAFIRM        KYZRADFIRM
     C                   MOVEL(P)  DAFIRM        KYZBFI
     C                   MOVEL(P)  DAFIRM        KYAFRLFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXED74                                                 ***
     C**************************************************************************
     C     UEBED74       BEGSR
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
     C                   MOVEL(P)  *OFF          WKED73
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  NACHLAUF                                                          ***
     C**************************************************************************
     C     NACHLAUF      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* SCHLIEßEN CHED73
     C*-------------------------------------------------------------------------
     C                   MOVEA     'LR      '    CHI
     C                   EXSR      CHED73
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTED74
     C                   MOVEL(P)  *ZERO         RTED74FENR
     C     WKED73        IFEQ      *OFF
     C                   MOVEL(P)  '0031'        RTED74FENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFRL         VERARBEITEN RECHNUNGS-LISTE                         ***
     C**************************************************************************
     C     VAFRL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFRK         VERARBEITEN RECHNUNGSDATEI                          ***
     C**************************************************************************
     C     VAFRK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKUNBZ
     C                   Z-ADD     *ZERO         WKUNHZ
     C                   Z-ADD     *ZERO         WKLINZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *ZERO         WKREDA
     C                   MOVEL(P)  *ZERO         WKRGJJ
     C                   MOVEL(P)  *BLANK        WKRGNR
     C                   MOVEL(P)  *ZERO         WKLIJJ
     C                   MOVEL(P)  *BLANK        WKLINR
     C                   MOVEL(P)  *BLANK        WKL2NR
     C                   MOVEL(P)  *ZERO         WKL2DA
     C*
     C                   Z-ADD     *ZERO         WKGSBRSU
     C                   Z-ADD     *ZERO         WKBRSU
     C                   Z-ADD     *ZERO         WKNESU
     C                   Z-ADD     *ZERO         WKSKB1
     C                   Z-ADD     *ZERO         WKWAWT
     C                   Z-ADD     *ZERO         WKKOSC
     C                   Z-ADD     *ZERO         WKMWWT
     C*
     C                   MOVEA(P)  *BLANK        KOD
     C                   MOVEA(P)  *BLANK        KOT
     C                   MOVEA(P)  *ZERO         KOW
     C                   MOVEA(P)  *ZERO         ERG
     C*
     C                   MOVEA(P)  *BLANK        EDIKOD
     C                   MOVEA(P)  *BLANK        EDIKOT
     C                   MOVEA(P)  *ZERO         EDIKOW
     C                   MOVEA(P)  *ZERO         EDIERG
     C*
     C                   MOVE      *BLANK        MWC
     C                   MOVE      *ZERO         MWT
     C                   MOVE      *ZERO         WWT
     C*
     C                   Z-ADD     *ZERO         WKAFDA
     C                   Z-ADD     *ZERO         WKLSDA
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKAFNR
     C                   MOVEL(P)  *BLANK        WKBEAT
     C                   MOVEL(P)  *BLANK        WKUORN
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKREILNR
     C                   MOVEL(P)  *BLANK        WKLSILNR
     C                   MOVEL(P)  *BLANK        WKKDNR
     C                   MOVEL(P)  *BLANK        WKREKDNR
     C                   MOVEL(P)  *BLANK        WKLSKDNR
     C                   MOVEL(P)  *BLANK        WKWRIL
     C                   MOVEL(P)  *BLANK        WKWRUN
     C                   MOVEL(P)  *BLANK        WKSTNR
     C                   MOVEL(P)  *BLANK        WKUSTI
     C                   MOVEL(P)  *BLANK        WKREF1
     C                   MOVEL(P)  *BLANK        WKREF2
     C                   MOVEL(P)  *BLANK        WKLIBD
     C*
     C                   MOVEL     *OFF          WKED73KOPF
     C                   MOVEL     *OFF          WKED73REKO
     C                   MOVEL     *OFF          WKED73LSKO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFRK
     C                   MOVEL(P)  DAFIRM        KYRKFI
     C                   MOVEL(P)  '10'          KYRKS2
     C                   MOVEL(P)  EXED74RAKD    KYRKRK
     C     EXED74ZRKD    IFNE      *BLANK
     C                   MOVEL(P)  *LOVAL        KYRKRK
     C                   ENDIF
     C                   MOVEA     '13+     '    CHI
     C                   EXSR      CHAFRK
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     RKFIRM        IFNE      KYRKFI
     C     RKST02        ORNE      KYRKS2
     C     RKRAKD        ORNE      KYRKRK
     C     EXED74ZRKD    ANDEQ     *BLANK
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     MODWAO        IFEQ      *ON
     C*
     C     EXED74ZRKD    IFNE      *BLANK
     C                   MOVEL(P)  RKKDNR        KYKDZRKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDZR
     C*
     C     KDZRZRKD      IFNE      EXED74ZRKD
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ELSE
     C                   Z-ADD     RKRGJJ        KYAFRLRGJJ
     C                   MOVEL(P)  RKRGNR        KYAFRLRGNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFRL
     C*
     C     AFRLZRKD      IFNE      EXED74ZRKD
     C     AFRLL2NR      ORNE      EXED74L2NR
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXED74RGNR    IFNE      *BLANK
     C     RKRGJJ        IFNE      EXED74RGJJ
     C     RKRGNR        ORNE      EXED74RGNR
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     RKLIJJ        KYKLJH
     C                   MOVEL     RKLINR        KYKLLI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFLK
     C*
     C                   MOVEL     KLAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAEDIU        IFNE      DAJNKZ
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL     KLAFAT        KYAFPEAFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPE
     C*
     C     AFPEINVO      IFNE      DAJNKZ
     C     AFPEINVO      ANDNE     *BLANK
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  KLAFJJ        KYEKJH
     C                   MOVEL(P)  KLAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C     WKTRPAAFED    IFEQ      *ON
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEL(P)  KLAFJJ        KYAKJH
     C                   MOVEL(P)  KLAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKWKNR        KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL     WREDIL        WKWRIL
     C                   MOVEL     WRUNBN        WKWRUN
     C                   MOVEL     WRSTNR        WKSTNR
     C                   MOVEL     WRUSTI        WKUSTI
     C*
     C                   MOVEL     EKBEAT        WKBEAT
     C                   MOVEL     EKUORN        WKUORN
     C*-------------------------------------------------------------------------
     C     WKRGNR        IFEQ      *BLANK
     C                   EXSR      EED73KOPF
     C                   EXSR      UED73KOPF
     C                   MOVEL     *ON           WKED73KOPF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKRGJJ        IFNE      WKRGJJ
     C     RKRGNR        ORNE      WKRGNR
     C*
     C     WKED73REKO    IFEQ      *ON
     C                   EXSR      EED73LSKO
     C                   EXSR      UED73LSKO
     C                   MOVEL     *ON           WKED73LSKO
     C*
     C                   EXSR      VAFRP
     C*
     C                   EXSR      EED73RESC
     C                   EXSR      UED73RESC
     C                   MOVEL     *OFF          WKED73REKO
     C*
     C                   MOVEL(P)  RKREDA        WKREDA
     C                   MOVEL(P)  RKVADA        WKVADA
     C                   MOVEL(P)  RKRGJJ        WKRGJJ
     C                   MOVEL(P)  RKRGNR        WKRGNR
     C                   MOVEL(P)  RKLIJJ        WKLIJJ
     C                   MOVEL(P)  RKLINR        WKLINR
     C                   MOVEL(P)  AFRLL2NR      WKL2NR
     C                   MOVEL(P)  AFRLL2DA      WKL2DA
     C*
     C                   Z-ADD     *ZERO         WKBRSU
     C                   Z-ADD     *ZERO         WKNESU
     C                   Z-ADD     *ZERO         WKSKB1
     C                   Z-ADD     *ZERO         WKWAWT
     C                   Z-ADD     *ZERO         WKKOSC
     C                   Z-ADD     *ZERO         WKMWWT
     C*
     C                   MOVEA(P)  *BLANK        KOD
     C                   MOVEA(P)  *BLANK        KOT
     C                   MOVEA(P)  *ZERO         KOW
     C                   MOVEA(P)  *ZERO         ERG
     C*
     C                   MOVEA(P)  *BLANK        EDIKOD
     C                   MOVEA(P)  *BLANK        EDIKOT
     C                   MOVEA(P)  *ZERO         EDIKOW
     C                   MOVEA(P)  *ZERO         EDIERG
     C                   ENDIF
     C*
     C     WKRGNR        IFNE      *BLANK
     C*
     C     WKED73KOPF    IFEQ      *OFF
     C                   EXSR      EED73KOPF
     C                   EXSR      UED73KOPF
     C                   MOVEL     *ON           WKED73KOPF
     C                   ENDIF
     C*
     C                   EXSR      EED73REKO
     C                   EXSR      UED73REKO
     C                   MOVEL     *ON           WKED73REKO
     C*
     C                   EXSR      EED73LSKO
     C                   EXSR      UED73LSKO
     C                   MOVEL     *ON           WKED73LSKO
     C*
     C                   EXSR      VAFRP
     C*
     C                   EXSR      EED73RESC
     C                   EXSR      UED73RESC
     C                   MOVEL     *OFF          WKED73REKO
     C*
     C                   MOVEL(P)  RKREDA        WKREDA
     C                   MOVEL(P)  RKVADA        WKVADA
     C                   MOVEL(P)  RKRGJJ        WKRGJJ
     C                   MOVEL(P)  RKRGNR        WKRGNR
     C                   MOVEL(P)  RKLIJJ        WKLIJJ
     C                   MOVEL(P)  RKLINR        WKLINR
     C                   MOVEL(P)  AFRLL2NR      WKL2NR
     C                   MOVEL(P)  AFRLL2DA      WKL2DA
     C                   ENDIF
     C*
     C                   Z-ADD     *ZERO         WKBRSU
     C                   Z-ADD     *ZERO         WKNESU
     C                   Z-ADD     *ZERO         WKSKB1
     C                   Z-ADD     *ZERO         WKWAWT
     C                   Z-ADD     *ZERO         WKKOSC
     C                   Z-ADD     *ZERO         WKMWWT
     C*
     C                   MOVEA(P)  *BLANK        KOD
     C                   MOVEA(P)  *BLANK        KOT
     C                   MOVEA(P)  *ZERO         KOW
     C                   MOVEA(P)  *ZERO         ERG
     C*
     C                   MOVEA(P)  *BLANK        EDIKOD
     C                   MOVEA(P)  *BLANK        EDIKOT
     C                   MOVEA(P)  *ZERO         EDIKOW
     C                   MOVEA(P)  *ZERO         EDIERG
     C*
     C                   MOVE      *BLANK        MWC
     C                   MOVE      *ZERO         MWT
     C                   MOVE      *ZERO         WWT
     C*
     C                   Z-ADD     *ZERO         WKAFDA
     C                   Z-ADD     *ZERO         WKLSDA
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKAFNR
     C                   MOVEL(P)  *BLANK        WKBEAT
     C                   MOVEL(P)  *BLANK        WKUORN
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKREILNR
     C                   MOVEL(P)  *BLANK        WKLSILNR
     C                   MOVEL(P)  *BLANK        WKKDNR
     C                   MOVEL(P)  *BLANK        WKREKDNR
     C                   MOVEL(P)  *BLANK        WKLSKDNR
     C                   MOVEL(P)  *BLANK        WKWRIL
     C                   MOVEL(P)  *BLANK        WKWRUN
     C                   MOVEL(P)  *BLANK        WKSTNR
     C                   MOVEL(P)  *BLANK        WKUSTI
     C                   MOVEL(P)  *BLANK        WKREF1
     C                   MOVEL(P)  *BLANK        WKREF2
     C                   MOVEL(P)  *BLANK        WKLIBD
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKLIJJ        IFNE      WKLIJJ
     C     RKLINR        ORNE      WKLINR
     C*
     C     WKLINR        IFNE      *BLANK
     C*
     C     WKED73KOPF    IFEQ      *OFF
     C                   EXSR      EED73KOPF
     C                   EXSR      UED73KOPF
     C                   MOVEL     *ON           WKED73KOPF
     C                   ENDIF
     C*
     C     WKED73REKO    IFEQ      *OFF
     C                   EXSR      EED73REKO
     C                   EXSR      UED73REKO
     C                   MOVEL     *ON           WKED73REKO
     C                   ENDIF
     C*
     C                   EXSR      EED73LSKO
     C                   EXSR      UED73LSKO
     C                   MOVEL     *ON           WKED73LSKO
     C*
     C                   EXSR      VAFRP
     C                   ENDIF
     C*
     C                   Z-ADD     *ZERO         WKAFDA
     C                   Z-ADD     *ZERO         WKLSDA
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKAFNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKREILNR
     C                   MOVEL(P)  *BLANK        WKLSILNR
     C                   MOVEL(P)  *BLANK        WKKDNR
     C                   MOVEL(P)  *BLANK        WKREKDNR
     C                   MOVEL(P)  *BLANK        WKLSKDNR
     C                   MOVEL(P)  *BLANK        WKREF1
     C                   MOVEL(P)  *BLANK        WKREF2
     C                   MOVEL(P)  *BLANK        WKLIBD
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL(P)  RKRGJJ        WKRGJJ
     C                   MOVEL(P)  RKRGNR        WKRGNR
     C                   MOVEL(P)  RKLIJJ        WKLIJJ
     C                   MOVEL(P)  RKLINR        WKLINR
     C                   MOVEL(P)  AFRLL2NR      WKL2NR
     C                   MOVEL(P)  AFRLL2DA      WKL2DA
     C                   MOVEL(P)  RKREDA        WKREDA
     C                   MOVEL(P)  RKVADA        WKVADA
     C                   MOVEL(P)  RKTZAK        WKTZAK
     C                   MOVEL(P)  RKMWC1        WKMWST
     C                   Z-ADD     RKVALT        WKVALT
     C*
     C                   ADD       RKSKB1        WKSKB1
     C*
     C                   ADD       RKBRSU        WKBRSU
     C                   ADD       RKBRSU        WKGSBRSU
     C*
     C                   ADD       RKWAWT        WKWAWT
     C                   ADD       RKWAW2        WKWAWT
     C                   ADD       RKWAW3        WKWAWT
     C*
     C                   ADD       RKNESU        WKNESU
     C                   ADD       RKNES2        WKNESU
     C                   ADD       RKNES3        WKNESU
     C*
     C                   ADD       RKMWS1        WKMWWT
     C                   ADD       RKMWS2        WKMWWT
     C                   ADD       RKMWS3        WKMWWT
     C*
     C                   ADD       RKERG1        WKKOSC
     C                   ADD       RKERG2        WKKOSC
     C                   ADD       RKERG3        WKKOSC
     C                   ADD       RKERG4        WKKOSC
     C                   ADD       RKER21        WKKOSC
     C                   ADD       RKER22        WKKOSC
     C                   ADD       RKER23        WKKOSC
     C                   ADD       RKER24        WKKOSC
     C                   ADD       RKER31        WKKOSC
     C                   ADD       RKER32        WKKOSC
     C                   ADD       RKER33        WKKOSC
     C                   ADD       RKER34        WKKOSC
     C*----------------------------------------------------------
     C     RKMWC1        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKMWC1        LOOKUP    MWC(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    MWC(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKMWC1        MWC(I1)
     C                   ADD       RKMWS1        MWT(I1)
     C                   ADD       RKWAWT        WWT(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKMWC2        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKMWC2        LOOKUP    MWC(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    MWC(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKMWC2        MWC(I1)
     C                   ADD       RKMWS2        MWT(I1)
     C                   ADD       RKWAW2        WWT(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKMWC3        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKMWC3        LOOKUP    MWC(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    MWC(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKMWC3        MWC(I1)
     C                   ADD       RKMWS3        MWT(I1)
     C                   ADD       RKWAW3        WWT(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKKON1        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKKON1        LOOKUP    KOD(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    KOD(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKKON1        KOD(I1)
     C                   ADD       RKERG1        ERG(I1)
     C                   ADD       RKER21        ERG(I1)
     C                   ADD       RKER31        ERG(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKKON2        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKKON2        LOOKUP    KOD(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    KOD(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKKON2        KOD(I1)
     C                   ADD       RKERG2        ERG(I1)
     C                   ADD       RKER22        ERG(I1)
     C                   ADD       RKER32        ERG(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKKON3        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKKON3        LOOKUP    KOD(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    KOD(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKKON3        KOD(I1)
     C                   ADD       RKERG3        ERG(I1)
     C                   ADD       RKER23        ERG(I1)
     C                   ADD       RKER33        ERG(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C     RKKON4        IFNE      *BLANK
     C                   Z-ADD     1             I1
     C     RKKON4        LOOKUP    KOD(I1)                                99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    KOD(I1)                                99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL(P)  RKKON4        KOD(I1)
     C                   ADD       RKERG4        ERG(I1)
     C                   ADD       RKER24        ERG(I1)
     C                   ADD       RKER34        ERG(I1)
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      UAFRK
     C*----------------------------------------------------------
     C                   MOVEA     '13R     '    CHI
     C                   EXSR      CHAFRK
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKRGNR        IFNE      *BLANK
     C*
     C     WKED73REKO    IFEQ      *OFF
     C                   EXSR      EED73REKO
     C                   EXSR      UED73REKO
     C                   ENDIF
     C*
     C                   EXSR      EED73LSKO
     C                   EXSR      UED73LSKO
     C*
     C                   EXSR      VAFRP
     C*
     C                   EXSR      EED73RESC
     C                   EXSR      UED73RESC
     C*
     C                   EXSR      EED73ENDE
     C                   EXSR      UED73ENDE
     C                   MOVEL(P)  *ON           WKED73
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFRP         VERARBEITEN RECHNUNGS-POSIIONEN                     ***
     C**************************************************************************
     C     VAFRP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKRGJJ        KYRPRJ
     C                   MOVEL(P)  WKRGNR        KYRPRN
     C                   MOVEL(P)  WKLIJJ        KYRPLJ
     C                   MOVEL(P)  WKLINR        KYRPLI
     C                   MOVEL(P)  *ZERO         KYRPLP
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFRP
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     RPFIRM        IFNE      KYRPFI
     C     RPRGJJ        ORNE      KYRPRJ
     C     RPRGNR        ORNE      KYRPRN
     C     RPLIJJ        ORNE      KYRPLJ
     C     RPLINR        ORNE      KYRPLI
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      EED73LSPO
     C                   EXSR      UED73LSPO
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFRP
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73KOPF     ERMITTELN KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED73KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     KZZNRN        WKZNRN
     C                   MOVEL     KZEDIB        WKEDIB
     C     EKILNR        IFNE      *BLANK
     C                   MOVEL(P)  EKILNR        WKEDIB
     C                   ENDIF
     C                   MOVEL     KZKDRE        WKKDRE
     C                   MOVEL     KZKDNR        WKKDNR
     C*
     C     EXED74ZRKD    IFEQ      *BLANK
     C     KZKDRE        IFNE      *BLANK
     C                   MOVEL(P)  KZKDRE        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     KZEDIB        IFNE      *BLANK
     C                   MOVEL     KZEDIB        WKEDIB
     C     EKILNR        IFNE      *BLANK
     C                   MOVEL(P)  EKILNR        WKEDIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXED74ZRKD    IFNE      *BLANK
     C     KZZNRN        IFNE      *BLANK
     C                   MOVEL(P)  KZZNRN        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     KZEDIB        IFNE      *BLANK
     C                   MOVEL     KZEDIB        WKEDIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        MODWAO = *ON
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   EVAL      %SUBST(EXTRNDDATE:01) = 'INVOIC'
     C                   EVAL      %SUBST(EXTRNDDATE:07) = KZKDNR
     C                   EVAL      EXTRNDPGST = 'ERPRTN'
     C                   CALL      'MOICRG'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C                   EVAL      WKPRTNUM = %SUBST(RTTRNDDATE:01)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKUNBZ
     C                   Z-ADD     *ZERO         WKLINZ
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNB
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYED73KYNR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHED73
     C     CHI(5)        IFEQ      'J'
     C                   MOVE      ED73KYNR      DUN140
     C                   ENDIF
     C                   ADD       1             DUN140
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73KOPF     UPDATE    KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED73KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNB'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*-------------------------------------------------------------------------
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EUNB
     C                   MOVEL(P)  UNB           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73REKO     ERMITTELN KOPFDATEN PRO RECHNUNG                    ***
     C**************************************************************************
     C     EED73REKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     KZZNRN        WKZNRN
     C                   MOVEL     KZEDIB        WKEDIB
     C     EKILNR        IFNE      *BLANK
     C                   MOVEL(P)  EKILNR        WKEDIB
     C                   ENDIF
     C                   MOVEL     KZKDRE        WKKDRE
     C                   MOVEL     KZKDNR        WKKDNR
     C*
     C     KZKDRE        IFNE      *BLANK
     C                   MOVEL(P)  KZKDRE        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     KZEDIB        IFNE      *BLANK
     C                   MOVEL     KZEDIB        WKEDIB
     C     EKILNR        IFNE      *BLANK
     C                   MOVEL(P)  EKILNR        WKEDIB
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C     WKTZAK        IFNE      *BLANK
     C*----------------------------------------------------------
     C                   MOVEL(P)  WKRGJJ        KYZLLFRGJJ
     C                   MOVEL(P)  WKRGNR        KYZLLFRGNR
     C                   MOVEL(P)  *LOVAL        KYZLLFLIJJ
     C                   MOVEL(P)  *LOVAL        KYZLLFLINR
     C                   MOVEL(P)  *LOVAL        KYZLLFLIPO
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHZLLF
     C*
     C     CHI(05)       IFEQ      'N'
     C     ZLLFFIRM      ORNE      KYZLLFFIRM
     C     ZLLFRGJJ      ORNE      KYZLLFRGJJ
     C     ZLLFRGNR      ORNE      KYZLLFRGNR
     C                   CLEAR                   ZLLF
     C                   ENDIF
     C*
     C                   MOVEL     ALAFAT        KYZRPARAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZRPA
     C                   MOVEL     ZRPAPMKZ      WKPMKZ
     C*
     C                   MOVEL     ZLLFLSDA      WKLSDA
     C                   MOVEL     ZLLFWACD      WKWACD
     C                   MOVEL     ZLLFZABD      WKZABD
     C*----------------------------------------------------------
     C                   ELSE
     C*----------------------------------------------------------
     C                   MOVEL(P)  WKREDA        KYALRD
     C                   MOVEL(P)  WKRGJJ        KYALRJ
     C                   MOVEL(P)  WKRGNR        KYALRN
     C                   MOVEL(P)  *LOVAL        KYALLD
     C                   MOVEL(P)  *LOVAL        KYALLJ
     C                   MOVEL(P)  *LOVAL        KYALLI
     C                   MOVEL(P)  *LOVAL        KYALLP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHAFLP
     C*
     C     CHI(05)       IFEQ      'N'
     C     ALFIRM        ORNE      KYALFI
     C     ALREDA        ORNE      KYALRD
     C     ALRGJJ        ORNE      KYALRJ
     C     ALRGNR        ORNE      KYALRN
     C                   CLEAR                   AFLP
     C                   ENDIF
     C*
     C                   MOVEL     ALAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C                   MOVEL     AAPMKZ        WKPMKZ
     C*
     C                   MOVEL     ALLSDA        WKLSDA
     C                   MOVEL     ALWACD        WKWACD
     C                   MOVEL     ALZABD        WKZABD
     C*
     C                   MOVEL(P)  ALAFJJ        KYAKJH
     C                   MOVEL(P)  ALAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKWKNR        KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C                   MOVEL     WREDIL        WKWRIL
     C                   MOVEL     WRUNBN        WKWRUN
     C                   MOVEL     WRSTNR        WKSTNR
     C                   MOVEL     WRUSTI        WKUSTI
     C*----------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      ERZABD
     C                   EXSR      ERTX02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73REKO     UPDATE    KOPFDATEN PRO RECHNUNG                    ***
     C**************************************************************************
     C     UED73REKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNH'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNH
     C                   MOVEL(P)  UNH           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BGM'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EBGM
     C                   MOVEL(P)  BGM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAI'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EPAI
     C**RE               MOVEL(P)  PAI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EALI
     C**RE               MOVEL(P)  ALI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73LSKO     ERMITTELN KOPFDATEN PRO LIEFERSCHEIN                ***
     C**************************************************************************
     C     EED73LSKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKTZAK        IFNE      *BLANK
     C                   EXSR      EZLLF
     C                   ELSE
     C                   EXSR      EAFLK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73LSKO     UPDATE    KOPFDATEN PRO LIEFERSCHEIN                ***
     C**************************************************************************
     C     UED73LSKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '01'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '01'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '01'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     WKED          ED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ELOC
     C*RE                MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'FII'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EFII
     C**RE               MOVEL(P)  FII           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '03'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '03'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     WKED          ED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DOC'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDOC
     C**RE               MOVEL(P)  DOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CUX'         WKEDINSGMT
     C                   MOVEL(P)  '07'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECUX
     C                   MOVEL(P)  CUX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAT'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      EPAT
     C                   MOVEL(P)  PAT           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'PAI'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EPAI
     C**RE               MOVEL(P)  PAI           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'FII'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EFII
     C**RE               MOVEL(P)  FII           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'PAT'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     WKED          ED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TOD'         WKEDINSGMT
     C                   MOVEL(P)  '12'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETOD
     C                   MOVEL(P)  TOD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '12'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAC'         WKEDINSGMT
     C                   MOVEL(P)  '13'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAC
     C**RE               MOVEL(P)  PAC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '13'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C**RE               MOVEL(P)  MEA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCI'         WKEDINSGMT
     C                   MOVEL(P)  '14'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCI
     C**RE               MOVEL(P)  PCI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '14'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '14'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '14'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C**RE               MOVEL(P)  GIN           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RTE'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERTE
     C**RTE              MOVEL(P)  RTE           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             WKED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'AJT'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAJT
     C**RE               MOVEL(P)  AJT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'INP'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EINP
     C**RE               MOVEL(P)  INP           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNS'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNS
     C                   MOVEL(P)  UNS           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73LSPO     ERMITTELN POSITIONSDATEN PRO LS-POSITION            ***
     C**************************************************************************
     C     EED73LSPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        WKKON1
     C                   MOVEL(P)  *BLANK        TXKON1
     C                   Z-ADD     *ZERO         WKKOW1
     C                   Z-ADD     *ZERO         WKERG1
     C                   MOVEL(P)  *BLANK        WKKON2
     C                   MOVEL(P)  *BLANK        TXKON2
     C                   Z-ADD     *ZERO         WKKOW2
     C                   Z-ADD     *ZERO         WKERG2
     C                   MOVEL(P)  *BLANK        WKKON3
     C                   MOVEL(P)  *BLANK        TXKON3
     C                   Z-ADD     *ZERO         WKKOW3
     C                   Z-ADD     *ZERO         WKERG3
     C                   MOVEL(P)  *BLANK        WKKON4
     C                   MOVEL(P)  *BLANK        TXKON4
     C                   Z-ADD     *ZERO         WKKOW4
     C                   Z-ADD     *ZERO         WKERG4
     C*-------------------------------------------------------------------------
     C     WKTZAK        IFNE      *BLANK
     C                   EXSR      EZLLFPOS
     C                   ELSE
     C                   EXSR      EAFLP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKTZAK        IFNE      *BLANK
     C                   MOVEL     TETBZ1        WKTBZ1
     C                   MOVEL     TETBZ2        WKTBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     MODAZO        IFEQ      *ON
     C                   MOVEL     'T1EANV'      #CPGST
     C                   MOVEA     *BLANK        KOM(01)
     C                   MOVEA     WKTENR        KOM(01)
     C                   EXSR      EZTEEW
     C                   MOVE      *ZERO         WKFENR
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(12)       T1EANV
     C*
     C     T1EANV        IFNE      *BLANK
     C                   MOVEL     T1EANV        TEEANR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KDKDNR        KYKPKD
     C                   MOVEL     TETENR        KYKPTE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKPIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEINTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKMEIN        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEPRTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKMEPR        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKMEPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     WKKON1        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON1
     C*
     C                   MOVEL(P)  'KONDTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKKON1        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKKON1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     WKKON2        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON2
     C*
     C                   MOVEL(P)  'KONDTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKKON2        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKKON2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     WKKON3        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON3
     C*
     C                   MOVEL(P)  'KONDTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKKON3        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKKON3
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     WKKON4        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON4
     C*
     C                   MOVEL(P)  'KONDTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  WKKON4        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKKON4
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UED73LSPO     UPDATE    POSITIONSDATEN PRO LS-POSITION            ***
     C**************************************************************************
     C     UED73LSPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LIN'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELIN
     C                   MOVEL(P)  LIN           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PIA'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPIA
     C                   MOVEL(P)  PIA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IMD'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EIMD
     C                   MOVEL(P)  IMD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C**RE               MOVEL(P)  MEA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C**RE               MOVEL(P)  ALI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIN'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C**RE               MOVEL(P)  GIN           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIR'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIR
     C**RE               MOVEL(P)  GIR           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QVR'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQVR
     C**RE               MOVEL(P)  QVR           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'EQD'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EEQD
     C**RE               MOVEL(P)  EQD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CUX'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECUX
     C                   MOVEL(P)  CUX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAT'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAT
     C                   MOVEL(P)  PAT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRI'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPRI
     C                   MOVEL(P)  PRI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APR'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAPR
     C**RE               MOVEL(P)  APR           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '29'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '29'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '29'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAC'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAC
     C**RE               MOVEL(P)  PAC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C**RE               MOVEL(P)  MEA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCI'         WKEDINSGMT
     C                   MOVEL(P)  '31'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCI
     C**RE               MOVEL(P)  PCI           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '31'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '31'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '31'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C**RE               MOVEL(P)  GIN           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '32'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '32'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '32'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '33'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '33'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '33'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '35'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DOC'         WKEDINSGMT
     C                   MOVEL(P)  '36'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDOC
     C**RE               MOVEL(P)  DOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '36'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '37'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '37'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   ADD       1             WKED
     C                   ADD       1             ED
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EALI
     C*RE                MOVEL(P)  ALI           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '39'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '39'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '40'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '40'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RTE'         WKEDINSGMT
     C                   MOVEL(P)  '42'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERTE
     C**RE               MOVEL(P)  RTE           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '42'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ERNG
     C**RE               MOVEL(P)  RNG           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '43'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '43'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             WKED
     C                   Z-ADD     WKED          ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '44'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '45'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '45'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TOD'         WKEDINSGMT
     C                   MOVEL(P)  '46'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETOD
     C                   MOVEL(P)  TOD           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '46'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C**RE               MOVEL(P)  LOC           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RCS'         WKEDINSGMT
     C                   MOVEL(P)  '47'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERCS
     C**RE               MOVEL(P)  RCS           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '47'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '47'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '47'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73RESC     ERMITTELN ENDEDATEN PRO RECHNUNG                    ***
     C**************************************************************************
     C     EED73RESC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        EDIKOD
     C                   MOVEA     *BLANK        EDIKOT
     C                   MOVEA     *ZERO         EDIERG
     C*-------------------------------------------------------------------------
     C                   DO        4             I1
     C     KOD(I1)       IFNE      *BLANK
     C                   MOVEL(P)  'RBATTRDEAN'  KYSYTPTART
     C                   MOVEL(P)  KOD(I1)       KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      DUC003
     C                   ELSE
     C                   MOVEL     KOD(I1)       DUC003
     C                   ENDIF
     C*
     C                   Z-ADD     1             I2
     C     DUC003        LOOKUP    EDIKOD(I2)                             99
     C*
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    EDIKOD(I2)                             99
     C                   ENDIF
     C*
     C     *IN99         IFEQ      *ON
     C                   MOVEL     'RBAT'        KYTPTA
     C                   MOVEL     KOD(I1)       KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        EDIKOT(I2)
     C*
     C                   MOVEL(P)  DUC003        EDIKOD(I2)
     C                   ADD       ERG(I1)       EDIERG(I2)
     C                   ENDIF
     C*
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73RESC     UPDATE ENDEDATEN PRO RECHNUNG                       ***
     C**************************************************************************
     C     UED73RESC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNS'         WKEDINSGMT
     C                   MOVEL(P)  '25'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNS
     C                   MOVEL(P)  UNS           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CNT'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECNT
     C**RE               MOVEL(P)  CNT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '48'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '49'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '49'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   DO        3             I1
     C     MWC(I1)       IFNE      *BLANK
     C                   MOVEL     MWC(I1)       WKMWC1
     C                   Z-ADD     MWT(I1)       WKMWS1
     C                   Z-ADD     WWT(I1)       WKMWW1
     C*
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             WKED
     C                   ADD       1             ED
     C                   ENDDO
     C*
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED73SATZ
     C                   EXSR      WED73
     C*
     C     WKED73SATZ    IFEQ      W1ED73SATZ
     C                   ADD       1             WKED
     C                   ADD       1             ED
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EALI
     C*RE                MOVEL(P)  ALI           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C     EDINKZAK      IFEQ      *ON
     C                   Z-ADD     WKED          ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED73SATZ
     C                   EXSR      WED73
     C                   ENDIF
     C*
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             WKED
     C                   Z-ADD     WKED          ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED73ENDE     ERMITTELN ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED73ENDE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73ENDE     UPDATE    ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED73ENDE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNT'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNT
     C                   MOVEL(P)  UNT           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNZ'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNZ
     C                   MOVEL(P)  UNZ           WKED73SATZ
     C                   EXSR      WED73
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  WED73         SCHREIBEN    ED73                                   ***
     C**************************************************************************
     C     WED73         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ED            DUN010
     C                   EVAL      W1EDINUKEY=%TRIM(WKEDINUKEY)+DUC001
     C*-------------------------------------------------------------------------
     C     WKED73SATZ    IFNE      W1ED73SATZ
     C                   CLEAR                   ED73
     C                   MOVEL(P)  DUN140        ED73KYNR
     C                   MOVEL(P)  '8'           ED73STA1
     C                   MOVEL(P)  '0'           ED73FLGS
     C                   MOVEL(P)  W1EDINUKEY    ED73SAAR
     C                   MOVEL(P)  WKED73SATZ    ED73SATZ
     C*
     C                   MOVEL(P)  DUN140        KYED73KYNR
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHED73
     C*
     C                   ADD       1             WKUNBZ
     C                   ADD       1             WKUNHZ
     C                   ADD       1             DUN140
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED73         UDATE STATUS ED73                                   ***
     C**************************************************************************
     C     UED73         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE ED73 SET ED73STA1 = ' '
     C+ WHERE ED73STA1 = '8'
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UAFRK         UDATE STATUS 50                                     ***
     C**************************************************************************
     C     UAFRK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RKRGJJ        KYRKRJ
     C                   MOVEL(P)  RKRGNR        KYRKRN
     C                   MOVEL(P)  RKLIJJ        KYRKLJ
     C                   MOVEL(P)  RKLINR        KYRKLI
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFRK
     C*----------------------------------------------------------
     C                   MOVEL(P)  '50'          RKST02
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFRK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT AJT
     C**************************************************************************
     C     EAJT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   AJT
     C**RE               MOVEL(P)  AJT           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT ALC
     C**************************************************************************
     C     EALC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ALC
     C                   MOVEL(P)  ALC           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '15'
     C                   SELECT
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C     EDIKOW(1)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(1)     ALC7161
     C                   MOVEL(P)  EDIKOT(1)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C     EDIKOW(1)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(1)     ALC7161
     C                   MOVEL(P)  EDIKOT(1)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C     EDIKOW(2)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(2)     ALC7161
     C                   MOVEL(P)  EDIKOT(2)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C     EDIKOW(2)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(2)     ALC7161
     C                   MOVEL(P)  EDIKOT(2)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    3
     C     EDIKOD(3)     ANDNE     *BLANK
     C     EDIKOW(3)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(3)     ALC7161
     C                   MOVEL(P)  EDIKOT(3)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    3
     C     EDIKOD(3)     ANDNE     *BLANK
     C     EDIKOW(3)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(3)     ALC7161
     C                   MOVEL(P)  EDIKOT(3)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C     EDIKOW(4)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(4)     ALC7161
     C                   MOVEL(P)  EDIKOT(4)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '4  '         ALC1227
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C     EDIKOW(4)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(4)     ALC7161
     C                   MOVEL(P)  EDIKOT(4)     ALC7160#1
     C                   MOVEL     '2  '         ALC4471
     C                   MOVEL     '4  '         ALC1227
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '38'
     C                   SELECT
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  WKKON1        ALC7161
     C                   MOVEL(P)  TXKON1        ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  WKKON1        ALC7161
     C                   MOVEL(P)  TXKON1        ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  WKKON2        ALC7161
     C                   MOVEL(P)  TXKON2        ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  WKKON2        ALC7161
     C                   MOVEL(P)  TXKON2        ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  WKKON3        ALC7161
     C                   MOVEL(P)  TXKON3        ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  WKKON3        ALC7161
     C                   MOVEL(P)  TXKON3        ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  WKKON4        ALC7161
     C                   MOVEL(P)  TXKON4        ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  WKKON4        ALC7161
     C                   MOVEL(P)  TXKON4        ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '51'
     C                   SELECT
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDEQ     *BLANK
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  'SF'          ALC7161
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C     EDIKOW(1)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(1)     ALC7161
     C                   MOVEL(P)  EDIKOT(1)     ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C     EDIKOW(1)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(1)     ALC7161
     C                   MOVEL(P)  EDIKOT(1)     ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C     EDIKOW(2)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(2)     ALC7161
     C                   MOVEL(P)  EDIKOT(2)     ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C     EDIKOW(2)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(2)     ALC7161
     C                   MOVEL(P)  EDIKOT(2)     ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    3
     C     EDIKOD(3)     ANDNE     *BLANK
     C     EDIKOW(3)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(3)     ALC7161
     C                   MOVEL(P)  EDIKOT(3)     ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    3
     C     EDIKOD(3)     ANDNE     *BLANK
     C     EDIKOW(3)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(3)     ALC7161
     C                   MOVEL(P)  EDIKOT(3)     ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C     EDIKOW(4)     ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  EDIKOD(4)     ALC7161
     C                   MOVEL(P)  EDIKOT(4)     ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C     EDIKOW(4)     ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  EDIKOD(4)     ALC7161
     C                   MOVEL(P)  EDIKOT(4)     ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C*******>******************************************************************
     C***  SEGMENT ALI
     C**************************************************************************
     C     EALI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   ALI
     C**RE               MOVEL(P)  ALI           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '15'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '38'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '51'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT APR
     C**************************************************************************
     C     EAPR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   APR
     C**RE               MOVEL(P)  APR           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT BGM
     C**************************************************************************
     C     EBGM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   BGM
     C                   MOVEL(P)  BGM           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C     WKPMKZ        IFEQ      '+'
     C                   MOVEL(P)  '380'         BGM1001
     C                   ELSE
     C                   MOVEL(P)  '381'         BGM1001
     C                   ENDIF
     C*
     C                   MOVEL(P)  WKRGJJ        DUN040
     C                   MOVEL(P)  *BLANK        DUC010
     C                   EVAL      DUC010=DUC004+WKRGNR
     C                   MOVEL(P)  DUC010        BGM1004
     C*
     C                   MOVEL(P)  '9'           BGM1225
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CNT
     C**************************************************************************
     C     ECNT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   CNT
     C**RE               MOVEL(P)  CNT           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT COM
     C**************************************************************************
     C     ECOM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   COM
     C                   MOVEL(P)  COM           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '05'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '37'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CUX
     C**************************************************************************
     C     ECUX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CUX
     C*                  MOVEL(P)  CUX           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '07'
     C                   MOVEL(P)  '2  '         CUX6347#1
     C                   MOVEL(P)  WKWACD        CUX6345#1
     C                   MOVEL(P)  '4  '         CUX6343#1
     C     WKEDINEDGR    WHENEQ    '26'
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CTA
     C**************************************************************************
     C     ECTA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CTA
     C*                  MOVEL(P)  CTA           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '05'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '37'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT DOC
     C**************************************************************************
     C     EDOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   DOC
     C**RE               MOVEL(P)  DOC           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '04'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '36'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT DTM
     C**************************************************************************
     C     EDTM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DTM
     C                   MOVEL(P)  DTM           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '137'         DTM2005
     C                   MOVEL(P)  WKREDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '35 '         DTM2005
     C                   MOVEL(P)  WKLSDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*----------------------------------------------------------
     C     WKEDINEDGR    WHENEQ    '01'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKLSDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    4
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKL2DA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '03'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '04'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '07'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '08'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '209'         DTM2005
     C                   MOVEL(P)  WKVADA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '12 '         DTM2005
     C                   MOVEL(P)  WKSKDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '140'         DTM2005
     C                   MOVEL(P)  RTZABDNTDA    DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '10'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '11'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '14'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '16'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '22'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '27'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '28'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '29'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKLSDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '31'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '32'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '35'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '36'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '45'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '47'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '49'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT EQD
     C**************************************************************************
     C     EEQD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   EQD
     C**RE               MOVEL(P)  EQD           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT FII
     C**************************************************************************
     C     EFII          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   FII
     C**RE               MOVEL(P)  FII           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '02'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '08'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT FTX
     C**************************************************************************
     C     EFTX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   FTX
     C                   MOVEL(P)  FTX           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   MOVEL(P)  'AAK'         FTX4451
     C                   MOVEL(P)  '1  '         FTX4453
     C                   MOVEL(P)  'DE '         FTX3453
     C                   MOVEL     TXT(1)        FTX4440#1
     C                   MOVEL     TXT(2)        FTX4440#2
     C                   MOVEL     TXT(3)        FTX4440#3
     C                   MOVEL     TXT(4)        FTX4440#4
     C                   MOVEL     TXT(5)        FTX4440#5
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '22'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '23'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '24'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '47'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        TXT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT GIN
     C**************************************************************************
     C     EGIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   GIN
     C**RE               MOVEL(P)  GIN           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '14'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '31'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT GIR
     C**************************************************************************
     C     EGIR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   GIR
     C**RE               MOVEL(P)  GIR           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT IMD
     C**************************************************************************
     C     EIMD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   IMD
     C                   MOVEL(P)  IMD           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'A  '         IMD7077
     C                   MOVEL(P)  WKTBZ1        IMD7008#1
     C                   MOVEL(P)  WKTBZ2        IMD7008#2
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'C  '         IMD7077
     C                   MOVEL(P)  'CU '         IMD7009
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'C  '         IMD7077
     C                   MOVEL(P)  'IN '         IMD7009
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT INP
     C**************************************************************************
     C     EINP          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   INP
     C**RE               MOVEL(P)  INP           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT LIN
     C**************************************************************************
     C     ELIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   LIN
     C                   MOVEL(P)  LIN           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKLINZ
     C                   Z-ADD     WKLIPO        LIN1082#1
     C*
     C     TEEANR        IFNE      *BLANK
     C                   MOVEL     TEEANR        LIN7140
     C                   MOVE      'EN '         LIN7143
     C                   ELSE
     C                   MOVEL     TETENR        LIN7140
     C                   MOVE      'SA '         LIN7143
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT LOC
     C**************************************************************************
     C     ELOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   LOC
     C**RE               MOVEL(P)  LOC           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '02'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '06'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '10'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '12'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '32'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '33'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '34'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '45'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '46'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT MEA
     C**************************************************************************
     C     EMEA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   MEA
     C**RE               MOVEL(P)  MEA           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '13'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '30'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT MOA
     C**************************************************************************
     C     EMOA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   MOA
     C                   MOVEL(P)  MOA           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '06'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '08'
     C                   MOVEL(P)  '21 '         MOA5025
     C                   Z-ADD     *ZERO         DUN180
     C                   Z-ADD     DUN180        MOA5004
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '19'
     C                   SELECT
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  EDIERG(1)     DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  EDIERG(2)     DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    3
     C     EDIKOD(2)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  EDIERG(3)     DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  EDIERG(4)     DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '21'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '26'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '66 '         MOA5025
     C     RPNESU        IFLT      *ZERO
     C                   Z-SUB     RPNESU        DUN182
     C                   ELSE
     C                   Z-ADD     RPNESU        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '203'         MOA5025
     C     RPBRSU        IFLT      *ZERO
     C                   Z-SUB     RPBRSU        DUN182
     C                   ELSE
     C                   Z-ADD     RPBRSU        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '27'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '33'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '41'
     C                   SELECT
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  WKERG1        DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  WKERG2        DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  WKERG3        DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C                   Z-ADD(H)  WKERG4        DUN182
     C     DUN182        IFLE      *ZERO
     C                   MULT      -1            DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '43'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '48'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '86 '         MOA5025
     C                   Z-ADD     WKBRSU        DUN182
     C     WKBRSU        IFLT      *ZERO
     C                   Z-SUB     WKBRSU        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '79 '         MOA5025
     C                   Z-ADD     WKNESU        DUN182
     C     WKNESU        IFLT      *ZERO
     C                   Z-SUB     WKNESU        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '125'         MOA5025
     C                   Z-ADD     WKWAWT        DUN182
     C     WKWAWT        IFLT      *ZERO
     C                   Z-SUB     WKWAWT        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    4
     C                   MOVEL(P)  '129'         MOA5025
     C                   Z-ADD     WKSKB1        DUN182
     C     WKSKB1        IFLT      *ZERO
     C                   Z-SUB     WKSKB1        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    5
     C                   MOVEL(P)  '131'         MOA5025
     C                   Z-ADD     WKKOSC        DUN182
     C     WKKOSC        IFLT      *ZERO
     C                   Z-SUB     WKKOSC        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    6
     C                   MOVEL(P)  '176'         MOA5025
     C                   Z-ADD     WKMWWT        DUN182
     C     WKMWWT        IFLT      *ZERO
     C                   Z-SUB     WKMWWT        DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '50'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVE      '124'         MOA5025
     C                   Z-ADD     WKMWS1        DUN182
     C     WKMWS1        IFLT      *ZERO
     C                   Z-SUB     WKMWS1        DUN182
     C                   ENDIF
     C                   MOVE      DUN182        MOA5004
     C     ED            WHENEQ    2
     C                   MOVE      '125'         MOA5025
     C                   Z-ADD     WKMWW1        DUN182
     C     WKMWW1        IFLT      *ZERO
     C                   Z-SUB     WKMWW1        DUN182
     C                   ENDIF
     C                   MOVE      DUN182        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '51'
     C                   SELECT
     C     ED            WHENEQ    1
     C     EDIKOD(1)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C     EDIERG(1)     IFLE      *ZERO
     C                   Z-SUB     EDIERG(1)     DUN182
     C                   ELSE
     C                   Z-ADD     EDIERG(1)     DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    2
     C     EDIKOD(2)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C     EDIERG(2)     IFLE      *ZERO
     C                   Z-SUB     EDIERG(2)     DUN182
     C                   ELSE
     C                   Z-ADD     EDIERG(2)     DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    3
     C     EDIKOD(3)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C     EDIERG(3)     IFLE      *ZERO
     C                   Z-SUB     EDIERG(3)     DUN182
     C                   ELSE
     C                   Z-ADD     EDIERG(3)     DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C     ED            WHENEQ    4
     C     EDIKOD(4)     ANDNE     *BLANK
     C                   MOVEL(P)  '8'           MOA5025
     C     EDIERG(4)     IFLE      *ZERO
     C                   Z-SUB     EDIERG(4)     DUN182
     C                   ELSE
     C                   Z-ADD     EDIERG(4)     DUN182
     C                   ENDIF
     C                   Z-ADD     DUN180        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT NAD
     C**************************************************************************
     C     ENAD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   NAD
     C                   MOVEL(P)  NAD           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '02'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'SU '         NAD3035
     C                   MOVEL(P)  WKWRIL        NAD3039
     C     KZEDIF        IFEQ      'EE'
     C                   MOVEL(P)  WKLIFN        NAD3039
     C                   ENDIF
     C*
     C                   MOVEL(P)  WRNAM1        NAD3036#1
     C                   MOVEL(P)  WRNAM2        NAD3036#2
     C                   MOVEL(P)  WRSTRA        NAD3042#1
     C                   MOVEL(P)  WRWORT        NAD3164
     C                   MOVEL(P)  WRPOLZ        NAD3251
     C                   MOVEL(P)  WRPOLD        NAD3207
     C*
     C                   MOVEL(P)  WRNAM1        NAD3124#1
     C                   MOVEL(P)  WRSTRA        NAD3124#2
     C                   MOVEL(P)  WRWORT        NAD3124#3
     C                   MOVEL(P)  WRPOLZ        NAD3124#4
     C                   MOVEL(P)  WRPOLD        NAD3124#5
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'BY '         NAD3035
     C                   MOVEL(P)  WKREILNR      NAD3039
     C     MODAZO        IFEQ      *ON
     C                   MOVEL(P)  WKILNR        NAD3039
     C                   ENDIF
     C*
     C                   MOVEL(P)  BYEXADNAM1    NAD3036#1
     C                   MOVEL(P)  BYEXADNAM2    NAD3036#2
     C                   MOVEL(P)  BYEXADSTRA    NAD3042#1
     C                   MOVEL(P)  BYEXADWORT    NAD3164
     C                   MOVEL(P)  BYEXADPOLZ    NAD3251
     C                   MOVEL(P)  BYEXADPOLD    NAD3207
     C*
     C                   MOVEL(P)  BYEXADNAM1    NAD3124#1
     C                   MOVEL(P)  BYEXADSTRA    NAD3124#2
     C                   MOVEL(P)  BYEXADWORT    NAD3124#3
     C                   MOVEL(P)  BYEXADPOLZ    NAD3124#4
     C                   MOVEL(P)  BYEXADPOLD    NAD3124#5
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'DP '         NAD3035
     C                   MOVEL(P)  WKLSILNR      NAD3039
     C*
     C                   MOVEL(P)  DPEXADNAM1    NAD3036#1
     C                   MOVEL(P)  DPEXADNAM2    NAD3036#2
     C                   MOVEL(P)  DPEXADSTRA    NAD3042#1
     C                   MOVEL(P)  DPEXADWORT    NAD3164
     C                   MOVEL(P)  DPEXADPOLZ    NAD3251
     C                   MOVEL(P)  DPEXADPOLD    NAD3207
     C*
     C                   MOVEL(P)  DPEXADNAM1    NAD3124#1
     C                   MOVEL(P)  DPEXADSTRA    NAD3124#2
     C                   MOVEL(P)  DPEXADWORT    NAD3124#3
     C                   MOVEL(P)  DPEXADPOLZ    NAD3124#4
     C                   MOVEL(P)  DPEXADPOLD    NAD3124#5
     C     ED            WHENEQ    4
     C                   MOVEL(P)  'IV '         NAD3035
     C                   MOVEL(P)  WKREILNR      NAD3039
     C*
     C                   MOVEL(P)  IVEXADNAM1    NAD3036#1
     C                   MOVEL(P)  IVEXADNAM2    NAD3036#2
     C                   MOVEL(P)  IVEXADSTRA    NAD3042#1
     C                   MOVEL(P)  IVEXADWORT    NAD3164
     C                   MOVEL(P)  IVEXADPOLZ    NAD3251
     C                   MOVEL(P)  IVEXADPOLD    NAD3207
     C*
     C                   MOVEL(P)  IVEXADNAM1    NAD3124#1
     C                   MOVEL(P)  IVEXADSTRA    NAD3124#2
     C                   MOVEL(P)  IVEXADWORT    NAD3124#3
     C                   MOVEL(P)  IVEXADPOLZ    NAD3124#4
     C                   MOVEL(P)  IVEXADPOLD    NAD3124#5
     C
     C     ED            WHENEQ    5
     C                   MOVEL(P)  'SE '         NAD3035
     C                   MOVEL(P)  WKWRIL        NAD3039
     C     KZEDIF        IFEQ      'EE'
     C                   MOVEL(P)  WKLIFN        NAD3039
     C                   ENDIF
     C*
     C                   MOVEL(P)  WRNAM1        NAD3036#1
     C                   MOVEL(P)  WRNAM2        NAD3036#2
     C                   MOVEL(P)  WRSTRA        NAD3042#1
     C                   MOVEL(P)  WRWORT        NAD3164
     C                   MOVEL(P)  WRPOLZ        NAD3251
     C                   MOVEL(P)  WRPOLD        NAD3207
     C*
     C                   MOVEL(P)  WRNAM1        NAD3124#1
     C                   MOVEL(P)  WRSTRA        NAD3124#2
     C                   MOVEL(P)  WRWORT        NAD3124#3
     C                   MOVEL(P)  WRPOLZ        NAD3124#4
     C                   MOVEL(P)  WRPOLD        NAD3124#5
     C*
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKEDINEDGR    WHENEQ    '34'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PAC
     C**************************************************************************
     C     EPAC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   PAC
     C**RE               MOVEL(P)  PAC           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '13'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '30'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PAI
     C**************************************************************************
     C     EPAI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   PAI
     C**RE               MOVEL(P)  PAI           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '08'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PAT
     C**************************************************************************
     C     EPAT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PAT
     C                   MOVEL(P)  PAT           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '08'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '7  '         PAT4279
     C                   MOVEL(P)  '5  '         PAT2475
     C                   MOVEL(P)  '3  '         PAT2009
     C                   MOVEL(P)  'D  '         PAT2151
     C                   MOVEL(P)  WKVALT        PAT2152
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '22 '         PAT4279
     C                   MOVEL(P)  '5  '         PAT2475
     C                   MOVEL(P)  '3  '         PAT2009
     C                   MOVEL(P)  'D  '         PAT2151
     C                   MOVEL(P)  WKSKOT        PAT2152
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '1  '         PAT4279
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '27'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PCD
     C**************************************************************************
     C     EPCD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PCD
     C                   MOVEL(P)  PCD           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '08'
     C                   SELECT
     C     ED            WHENEQ    1
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '7  '         PCD5245
     C                   Z-ADD     WKSKPZ        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '18'
     C                   SELECT
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW1        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW1        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW2        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    1
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW2        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW3        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW3        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW4        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW4        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '25'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '27'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '40'
     C                   SELECT
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW1        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    1
     C     WKKON1        ANDNE     *BLANK
     C     WKKOW1        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW1        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW2        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    2
     C     WKKON2        ANDNE     *BLANK
     C     WKKOW2        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW2        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW3        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     WKKON3        ANDNE     *BLANK
     C     WKKOW3        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW3        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDGE     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     WKKOW4        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     WKKON4        ANDNE     *BLANK
     C     WKKOW4        ANDLE     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-ADD     WKKOW4        DUN102
     C     DUN102        IFLT      *ZERO
     C                   MULT      -1            DUN102
     C                   ENDIF
     C                   MOVEL(P)  DUC010        PCD5482
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PCI
     C**************************************************************************
     C     EPCI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   PCI
     C**RE               MOVEL(P)  PCI           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '14'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '31'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PIA
     C**************************************************************************
     C     EPIA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PIA
     C                   MOVEL(P)  PIA           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  TETENR        PIA7140#1
     C                   MOVEL(P)  'SA '         PIA7143#1
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  KPIDEN        PIA7140#1
     C                   MOVEL(P)  'BP '         PIA7143#1
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  TEEANR        PIA7140#1
     C                   MOVEL(P)  'EN '         PIA7143#1
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PRI
     C**************************************************************************
     C     EPRI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PRI
     C                   MOVEL(P)  PRI           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVE      'AAA'         PRI5125
     C     WKGLMG        IFNE      *ZERO
     C     RPBRSU        DIV(H)    WKGLMG        DUN216
     C                   MULT      WKPDIM        DUN216
     C                   ELSE
     C                   Z-ADD     RPBRSU        DUN216
     C     RPBRSU        IFLT      *ZERO
     C                   Z-SUB     RPBRSU        DUN216
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD(H)  DUN216        DUN182
     C                   Z-ADD(H)  DUN182        DUN153
     C                   Z-ADD     DUN150        PRI5118
     C                   Z-ADD     WKPDIM        PRI5284
     C                   MOVEL     WKMEPR        PRI6411
     C     ED            WHENEQ    2
     C                   MOVE      'AAF'         PRI5125
     C     WKGLMG        IFNE      *ZERO
     C     RPNESU        DIV(H)    WKGLMG        DUN216
     C                   MULT      WKPDIM        DUN216
     C                   ELSE
     C                   Z-ADD     RPNESU        DUN216
     C     RPNESU        IFLT      *ZERO
     C                   Z-SUB     RPNESU        DUN216
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD(H)  DUN216        DUN182
     C                   Z-ADD(H)  DUN182        DUN153
     C                   Z-ADD     DUN150        PRI5118
     C                   Z-ADD     WKPDIM        PRI5284
     C                   MOVEL     WKMEPR        PRI6411
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT QTY
     C**************************************************************************
     C     EQTY          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   QTY
     C                   MOVEL(P)  QTY           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '17'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   SELECT
     C     ED            WHENEQ    1
     C     RPBRSU        ANDEQ     *ZERO
     C                   MOVEL     '46 '         QTY6063
     C     WKGLMG        ADD       WKNRMG        DUN153
     C     DUN150        IFLT      *ZERO
     C                   MULT      -1            DUN153
     C                   ENDIF
     C                   Z-ADD     DUN153        QTY6060
     C                   MOVEL     WKMEIN        QTY6411
     C     ED            WHENEQ    1
     C     RPBRSU        ANDNE     *ZERO
     C                   MOVEL     '47 '         QTY6063
     C                   Z-ADD     WKGLMG        DUN153
     C     DUN150        IFLT      *ZERO
     C                   MULT      -1            DUN153
     C                   ENDIF
     C                   Z-ADD     DUN153        QTY6060
     C                   MOVEL     WKMEIN        QTY6411
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '32'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '39'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT QVR
     C**************************************************************************
     C     EQVR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   QVR
     C**RE               MOVEL(P)  QVR           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT RCS
     C**************************************************************************
     C     ERCS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   RCS
     C**RE               MOVEL(P)  RCS           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT RFF
     C**************************************************************************
     C     ERFF          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RFF
     C                   MOVEL(P)  RFF           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '01'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'DQ '         RFF1153
     C                   MOVEL(P)  WKLINR        RFF1154
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'VN '         RFF1153
     C                   MOVEL(P)  WKAFNR        RFF1154
     C     ED            WHENEQ    4
     C                   MOVEL(P)  'ABO'         RFF1153
     C                   MOVEL(P)  WKL2NR        RFF1154
     C     ED            WHENEQ    5
     C                   MOVEL(P)  'VR '         RFF1153
     C                   MOVEL(P)  WKLIFN        RFF1154
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '03'
     C                   SELECT
     C     ED            WHENEQ    1                                            SU
     C     WKED          ANDEQ     1
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKLIFN        RFF1154
     C     ED            WHENEQ    1                                            BY
     C     WKED          ANDEQ     2
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKKDNR        RFF1154
     C     ED            WHENEQ    1                                            DP
     C     WKED          ANDEQ     3
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKLSKDNR      RFF1154
     C     ED            WHENEQ    1                                            IV
     C     WKED          ANDEQ     4
     C                   MOVEL(P)  'FC '         RFF1153
     C                   MOVEL(P)  WKIVSTNR      RFF1154
     C     ED            WHENEQ    1                                            SE
     C     WKED          ANDEQ     5
     C                   MOVEL(P)  'FC '         RFF1153
     C                   MOVEL(P)  WKSTNR        RFF1154
     C*
     C     ED            WHENEQ    2                                            SU
     C     WKED          ANDEQ     1
     C                   MOVEL(P)  'VA '         RFF1153
     C                   MOVEL(P)  WKUSTI        RFF1154
     C     ED            WHENEQ    2                                            IV
     C     WKED          ANDEQ     4
     C                   MOVEL(P)  'VA '         RFF1153
     C                   MOVEL(P)  WKIVUSTI      RFF1154
     C     ED            WHENEQ    2                                            SE
     C     WKED          ANDEQ     5
     C                   MOVEL(P)  'VA '         RFF1153
     C                   MOVEL(P)  WKUSTI        RFF1154
     C*
     C     ED            WHENEQ    3                                            SU
     C     WKED          ANDEQ     1
     C                   MOVEL(P)  'FC '         RFF1153
     C                   MOVEL(P)  WKSTNR        RFF1154
     C     ED            WHENEQ    3                                            IV
     C     WKED          ANDEQ     4
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKREKDNR      RFF1154
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*
     C     WKEDINEDGR    WHENEQ    '11'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '14'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '16'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '22'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '29'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'DQ '         RFF1153
     C                   MOVEL(P)  WKLINR        RFF1154
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C                   MOVEL(P)  WKAFEPPOSI    RFF1156
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'VN '         RFF1153
     C                   MOVEL(P)  WKAFNR        RFF1154
     C                   MOVEL(P)  WKAFPOPOSI    RFF1156
     C     ED            WHENEQ    4
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '31'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '35'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '47'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '49'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT RNG
     C**************************************************************************
     C     ERNG          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   RNG
     C**RE               MOVEL(P)  RNG           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '17'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '18'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '19'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '20'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '28'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '39'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '40'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '41'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '42'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT RTE
     C**************************************************************************
     C     ERTE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C**RE               CLEAR                   RTE
     C**RE               MOVEL(P)  RTA           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '20'
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '42'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT TAX
     C**************************************************************************
     C     ETAX          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   TAX
     C                   MOVEL(P)  TAX           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '06'
     C*
     C     WKMWWT        IFEQ      *ZERO
     C                   MOVEL     '1  '         TAX5283
     C                   MOVEL     'FRE'         TAX5153
     C                   MOVEL     '134'         TAX1131#1
     C                   MOVEL     *ZERO         TAX5152
     C                   MOVEL     'E  '         TAX5305
     C                   ENDIF
     C*
     C     WKMWWT        IFNE      *ZERO
     C                   MOVEL     '7  '         TAX5283
     C                   MOVEL     'VAT'         TAX5153
     C*
     C                   MOVEL(P)  WKMWST        DUC002
     C                   Z-ADD     RKREDA        DUN080
     C                   EXSR      TRAUFRMWST
     C                   Z-ADD     TPTNUM        DUN182
     C                   MOVE      DUN182        TAX5278
     C*
     C                   MOVEL     'S  '         TAX5305
     C                   ENDIF
     C*
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '21'
     C                   Z-ADD     EDINANZA      ED
     C*
     C     WKEDINEDGR    WHENEQ    '33'
     C                   MOVE      '7  '         TAX5283
     C                   MOVE      'VAT'         TAX5153
     C*
     C                   MOVEL(P)  RPMWCD        DUC002
     C                   Z-ADD     RKREDA        DUN080
     C                   EXSR      TRAUFRMWST
     C                   Z-ADD     TPTNUM        DUN182
     C                   MOVE      DUN182        TAX5278
     C*
     C                   MOVEL     'S  '         TAX5305
     C                   Z-ADD     EDINANZA      ED
     C*
     C     WKEDINEDGR    WHENEQ    '43'
     C                   MOVE      '7  '         TAX5283
     C                   MOVE      'VAT'         TAX5153
     C*
     C                   MOVEL(P)  RPMWCD        DUC002
     C                   Z-ADD     RKREDA        DUN080
     C                   EXSR      TRAUFRMWST
     C                   Z-ADD     TPTNUM        DUN182
     C                   MOVE      DUN182        TAX5278
     C*
     C                   MOVEL     'S  '         TAX5305
     C                   Z-ADD     EDINANZA      ED
     C*
     C     WKEDINEDGR    WHENEQ    '50'
     C                   MOVE      '7  '         TAX5283
     C                   MOVE      'VAT'         TAX5153
     C*
     C                   MOVEL(P)  WKMWC1        DUC002
     C                   Z-ADD     RKREDA        DUN080
     C                   EXSR      TRAUFRMWST
     C                   Z-ADD     TPTNUM        DUN182
     C                   MOVE      DUN182        TAX5278
     C*
     C                   MOVEL     'S  '         TAX5305
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT TDT
     C**************************************************************************
     C     ETDT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   TDT
     C                   MOVEL(P)  TDT           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '09'
     C                   MOVEL     '20'          TDT8051
     C                   MOVEL     '30'          TDT8067
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '44'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT TOD
     C**************************************************************************
     C     ETOD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   TOD
     C                   MOVEL(P)  TOD           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '12'
     C                   MOVEL     '6  '         TOD4055
     C                   MOVEL     WKLIBD        TOD4053
     C                   MOVEL     TXLIBD#1      TOD4052#1
     C                   MOVEL     TXLIBD#2      TOD4052#2
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '46'
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT UNB
     C**************************************************************************
     C     EUNB          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNB
     C                   MOVEL(P)  UNB           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C                   MOVEL(P)  'TB'          UNB0007#1
     C*
     C                   MOVEL     WKWRIL        UNB0004
     C     KZEDIF        IFEQ      'EE'
     C                   MOVEL     WKWRUN        UNB0004
     C                   ENDIF
     C*
     C                   SELECT
     C     WKEDIB        WHENNE    *BLANK
     C                   MOVEL     WKEDIB        UNB0010
     C     WKZNRN        WHENNE    *BLANK
     C                   MOVEL     WKZNRN        UNB0010                        ZENTRAL-NR
     C                   ENDSL
     C*
     C                   IF        MODWAO = *ON
     C                   EVAL      UNB0032 = WKPRTNUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT UNH
     C**************************************************************************
     C     EUNH          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNH
     C                   MOVEL(P)  UNH           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKZNRN        WHENNE    *BLANK
     C                   MOVEL     WKZNRN        UNH0062
     C     WKKDRE        WHENNE    *BLANK
     C                   MOVEL     WKKDRE        UNH0062
     C     WKKDNR        WHENNE    *BLANK
     C                   MOVEL     WKKDNR        UNH0062
     C                   ENDSL
     C*
     C                   MOVEL     'INVOIC  '    UNH0065
     C                   MOVEL     'D       '    UNH0052
     C                   MOVEL     '96A     '    UNH0054
     C                   MOVEL     'UN      '    UNH0051
     C                   MOVEL     'EAN008  '    UNH0057
     C                   MOVEL     'EA'          UNH0068
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT UNS
     C**************************************************************************
     C     EUNS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNS
     C                   MOVEL(P)  UNS           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '24'
     C                   MOVE      'D'           UNS0081
     C                   Z-ADD     EDINANZA      ED
     C     WKEDINEDGR    WHENEQ    '25'
     C                   MOVE      'S'           UNS0081
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT UNT
     C**************************************************************************
     C     EUNT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNT
     C                   MOVEL(P)  UNT           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKUNHZ
     C                   Z-ADD     WKLINZ        DUN060
     C                   MOVEL(P)  DUC006        UNT0074
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT UNZ
     C**************************************************************************
     C     EUNZ          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   UNZ
     C                   MOVEL(P)  UNZ           W1ED73SATZ
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKUNBZ
     C                   Z-ADD     WKUNBZ        DUN060
     C                   MOVEL(P)  DUC006        UNZ0036
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN EDIN
     C**************************************************************************
     C     EEDIN         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKEDINSGMT    KYEDINSGMT
     C                   MOVEL(P)  WKEDINEDGR    KYEDINEDGR
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHEDIN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EDINUKEY      WKEDINUKEY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LS-KOPFDATEN TZA                                        ***
     C**************************************************************************
     C     EZLLF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKLIJJ        KYZLLFLIJJ
     C                   MOVEL(P)  WKLINR        KYZLLFLINR
     C                   MOVEL(P)  *LOVAL        KYZLLFLIPO
     C                   MOVEA     '06+     '    CHI
     C                   EXSR      CHZLLF
     C*
     C     CHI(05)       IFEQ      'N'
     C     ZLLFFIRM      ORNE      KYZLLFFIRM
     C     ZLLFLIJJ      ORNE      KYZLLFLIJJ
     C     ZLLFLINR      ORNE      KYZLLFLINR
     C                   CLEAR                   ZLLF
     C                   ENDIF
     C*
     C                   MOVEL(P)  ZLLFLSDA      WKLSDA
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ZLLFRAJJ      KYZRADRAJJ                     AUFTRAGGEBER
     C                   MOVEL(P)  ZLLFRANR      KYZRADRANR                     ADRESSE
     C                   MOVEL(P)  'ADAG'        KYZRADAART
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZRAD
     C*
     C                   CLEAR                   BYADRE
     C                   MOVEL     ZRADNAM1      BYEXADNAM1
     C                   MOVEL     ZRADNAM2      BYEXADNAM2
     C                   MOVEL     ZRADNAM3      BYEXADNAM3
     C                   MOVEL     ZRADSTRA      BYEXADSTRA
     C                   MOVEL     ZRADPOLD      BYEXADPOLD
     C                   MOVEL     ZRADPOLZ      BYEXADPOLZ
     C                   MOVEL     ZRADWORT      BYEXADWORT
     C                   MOVEL     ZRADPOFA      BYEXADPOFA
     C                   MOVEL     ZRADPOLN      BYEXADPOLN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ZLLFKDNR      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ZLLFWKNR      KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDLIFN        WKLIFN
     C*
     C                   MOVEL(P)  ZLLFRAKD      KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C                   MOVEL(P)  KZEDIB        WKILNR
     C                   MOVEL(P)  KZEDIB        WKLSILNR
     C                   MOVEL(P)  KZEDIB        WKREILNR
     C                   MOVEL(P)  KZKDNR        WKKDNR
     C                   MOVEL(P)  KZKDNR        WKLSKDNR
     C                   MOVEL(P)  KZKDNR        WKREKDNR
     C*
     C     KZKDRE        IFNE      *BLANK
     C                   MOVEL(P)  KZKDRE        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     KZEDIB        IFNE      *BLANK
     C                   MOVEL     KZEDIB        WKREILNR
     C                   MOVEL(P)  KZKDNR        WKREKDNR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LS-KOPFDATEN TVA                                        ***
     C**************************************************************************
     C     EAFLK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKLIJJ        KYKLJH
     C                   MOVEL(P)  WKLINR        KYKLLI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFLK
     C*
     C                   MOVEL(P)  KLLSDA        WKLSDA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLAFJJ        KYAKJH
     C                   MOVEL(P)  KLAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKAFDA        WKAFDA
     C                   MOVEL(P)  AKREF1        WKREF1
     C                   MOVEL(P)  AKREF2        WKREF2
     C                   MOVEL(P)  AKLIBD        WKLIBD
     C*
     C                   MOVEL     'LIBD'        KYTPTA
     C                   MOVEL     WKLIBD        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXLIBD#1
     C                   MOVEL     'LIBD'        KYTPTA
     C                   MOVEL     WKLIBD        KYTPTC
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXLIBD#2
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH                         AUFTRAGGEBER
     C                   MOVEL(P)  AKAFNR        KYADAF                         ADRESSE
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C                   CLEAR                   BYADRE
     C                   MOVEL     ADNAM1        BYEXADNAM1
     C                   MOVEL     ADNAM2        BYEXADNAM2
     C                   MOVEL     ADNAM3        BYEXADNAM3
     C                   MOVEL     ADSTRA        BYEXADSTRA
     C                   MOVEL     ADPOLD        BYEXADPOLD
     C                   MOVEL     ADPOLZ        BYEXADPOLZ
     C                   MOVEL     ADWORT        BYEXADWORT
     C                   MOVEL     ADPOFA        BYEXADPOFA
     C                   MOVEL     ADPOLN        BYEXADPOLN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH                         AUFTRAGGEBER
     C                   MOVEL(P)  AKAFNR        KYADAF                         ADRESSE
     C                   MOVEL(P)  'ADVS'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*
     C                   CLEAR                   DPADRE
     C                   MOVEL     ADNAM1        DPEXADNAM1
     C                   MOVEL     ADNAM2        DPEXADNAM2
     C                   MOVEL     ADNAM3        DPEXADNAM3
     C                   MOVEL     ADSTRA        DPEXADSTRA
     C                   MOVEL     ADPOLD        DPEXADPOLD
     C                   MOVEL     ADPOLZ        DPEXADPOLZ
     C                   MOVEL     ADWORT        DPEXADWORT
     C                   MOVEL     ADPOFA        DPEXADPOFA
     C                   MOVEL     ADPOLN        DPEXADPOLN
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH                         AUFTRAGGEBER
     C                   MOVEL(P)  AKAFNR        KYADAF                         ADRESSE
     C                   MOVEL(P)  'ADRE'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*
     C                   CLEAR                   IVADRE
     C                   MOVEL     ADNAM1        IVEXADNAM1
     C                   MOVEL     ADNAM2        IVEXADNAM2
     C                   MOVEL     ADNAM3        IVEXADNAM3
     C                   MOVEL     ADSTRA        IVEXADSTRA
     C                   MOVEL     ADPOLD        IVEXADPOLD
     C                   MOVEL     ADPOLZ        IVEXADPOLZ
     C                   MOVEL     ADWORT        IVEXADWORT
     C                   MOVEL     ADPOFA        IVEXADPOFA
     C                   MOVEL     ADPOLN        IVEXADPOLN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   MOVEL(P)  KDSTNR        WKIVSTNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KDLAND        KYKELD
     C                   MOVEL(P)  KDKDNR        KYKEKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUEG
     C                   MOVEL(P)  KEUSTI        WKIVUSTI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYVSKD
     C                   MOVEL(P)  AKVSNR        KYVSNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDVS
     C*
     C                   MOVEL(P)  VSEDIL        WKLSILNR
     C                   MOVEL(P)  VSKDNR        WKLSKDNR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKWKNR        KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKAFJJ        KYEKJH
     C                   MOVEL(P)  AKAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C                   MOVEL(P)  EKBEAT        WKBEAT
     C                   MOVEL(P)  EKUORN        WKUORN
     C                   MOVEL(P)  EKORNR        WKORNR
     C     EKORNR        IFEQ      *BLANK
     C                   MOVEL(P)  AKREF1        WKORNR
     C                   ENDIF
     C                   MOVEL(P)  AKAFNR        WKAFNR
     C*
     C                   MOVEL(P)  EKILNR        WKILNR
     C                   MOVEL(P)  EKILNR        WKREILNR
     C*
     C*RE                MOVEL(P)  EKILNR        WKLSILNR
     C*RE                MOVEL(P)  EKLFBK        WKLIFN
     C*
     C                   MOVEL(P)  AKKDNR        WKKDNR
     C                   MOVEL(P)  AKKDNR        WKREKDNR
     C*
     C     WKLIFN        IFEQ      *BLANK
     C                   MOVEL(P)  KDLIFN        WKLIFN
     C                   ENDIF
     C*
     C                   MOVEL(P)  AKKDNR        KYKDZRKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDZR
     C     KDZRZRKD      IFNE      *BLANK
     C     KDZRMIKD      ANDNE     *BLANK
     C                   MOVEL(P)  KDZRMIKD      WKLIFN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     WKILNR        IFEQ      *BLANK
     C     MODAZO        OREQ      *ON
     C                   MOVEL(P)  KZEDIB        WKILNR
     C                   MOVEL(P)  KZKDNR        WKKDNR
     C*
     C     WKLSILNR      IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKLSILNR
     C                   MOVEL(P)  KZKDNR        WKLSKDNR
     C*
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   DPADRE
     C                   MOVEL     KDNAM1        DPEXADNAM1
     C                   MOVEL     KDNAM2        DPEXADNAM2
     C                   MOVEL     KDNAM3        DPEXADNAM3
     C                   MOVEL     KDSTRA        DPEXADSTRA
     C                   MOVEL     KDPOLD        DPEXADPOLD
     C                   MOVEL     KDPOLZ        DPEXADPOLZ
     C                   MOVEL     KDWORT        DPEXADWORT
     C                   MOVEL     KDPOFA        DPEXADPOFA
     C                   MOVEL     KDPOLN        DPEXADPOLN
     C                   ENDIF
     C*
     C     WKREILNR      IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKREILNR
     C                   MOVEL(P)  KZEDIB        WKREKDNR
     C
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   IVADRE
     C                   MOVEL     KDNAM1        IVEXADNAM1
     C                   MOVEL     KDNAM2        IVEXADNAM2
     C                   MOVEL     KDNAM3        IVEXADNAM3
     C                   MOVEL     KDSTRA        IVEXADSTRA
     C                   MOVEL     KDPOLD        IVEXADPOLD
     C                   MOVEL     KDPOLZ        IVEXADPOLZ
     C                   MOVEL     KDWORT        IVEXADWORT
     C                   MOVEL     KDPOFA        IVEXADPOFA
     C                   MOVEL     KDPOLN        IVEXADPOLN
     C*
     C                   ENDIF
     C                   ENDIF
     C*
     C     WKLSILNR      IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKLSILNR
     C                   MOVEL(P)  KZKDNR        WKLSKDNR
     C*
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   DPADRE
     C                   MOVEL     KDNAM1        DPEXADNAM1
     C                   MOVEL     KDNAM2        DPEXADNAM2
     C                   MOVEL     KDNAM3        DPEXADNAM3
     C                   MOVEL     KDSTRA        DPEXADSTRA
     C                   MOVEL     KDPOLD        DPEXADPOLD
     C                   MOVEL     KDPOLZ        DPEXADPOLZ
     C                   MOVEL     KDWORT        DPEXADWORT
     C                   MOVEL     KDPOFA        DPEXADPOFA
     C                   MOVEL     KDPOLN        DPEXADPOLN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKRAKD        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     WKLSILNR      IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKLSILNR
     C                   MOVEL(P)  KZKDNR        WKLSKDNR
     C*
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   DPADRE
     C                   MOVEL     KDNAM1        DPEXADNAM1
     C                   MOVEL     KDNAM2        DPEXADNAM2
     C                   MOVEL     KDNAM3        DPEXADNAM3
     C                   MOVEL     KDSTRA        DPEXADSTRA
     C                   MOVEL     KDPOLD        DPEXADPOLD
     C                   MOVEL     KDPOLZ        DPEXADPOLZ
     C                   MOVEL     KDWORT        DPEXADWORT
     C                   MOVEL     KDPOFA        DPEXADPOFA
     C                   MOVEL     KDPOLN        DPEXADPOLN
     C                   ENDIF
     C*
     C     KZEDIB        IFNE      *BLANK
     C                   MOVEL(P)  KZEDIB        WKREILNR
     C                   MOVEL(P)  KZKDNR        WKREKDNR
     C
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   IVADRE
     C                   MOVEL     KDNAM1        IVEXADNAM1
     C                   MOVEL     KDNAM2        IVEXADNAM2
     C                   MOVEL     KDNAM3        IVEXADNAM3
     C                   MOVEL     KDSTRA        IVEXADSTRA
     C                   MOVEL     KDPOLD        IVEXADPOLD
     C                   MOVEL     KDPOLZ        IVEXADPOLZ
     C                   MOVEL     KDWORT        IVEXADWORT
     C                   MOVEL     KDPOFA        IVEXADPOFA
     C                   MOVEL     KDPOLN        IVEXADPOLN
     C                   ENDIF
     C*
     C     KZKDRE        IFNE      *BLANK
     C     EXED74ZRKD    ANDEQ     *BLANK
     C                   MOVEL(P)  KZKDRE        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C     KZEDIB        IFNE      *BLANK
     C     MODAZO        ANDEQ     *OFF
     C                   MOVEL     KZEDIB        WKREILNR
     C                   MOVEL     KZKDNR        WKREKDNR
     C
     C                   MOVEL(P)  KZKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   CLEAR                   IVADRE
     C                   MOVEL     KDNAM1        IVEXADNAM1
     C                   MOVEL     KDNAM2        IVEXADNAM2
     C                   MOVEL     KDNAM3        IVEXADNAM3
     C                   MOVEL     KDSTRA        IVEXADSTRA
     C                   MOVEL     KDPOLD        IVEXADPOLD
     C                   MOVEL     KDPOLZ        IVEXADPOLZ
     C                   MOVEL     KDWORT        IVEXADWORT
     C                   MOVEL     KDPOFA        IVEXADPOFA
     C                   MOVEL     KDPOLN        IVEXADPOLN
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKRAKD        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C                   MOVEL(P)  KDSTNR        WKIVSTNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LS-POSITIONSDATEN TZA                                   ***
     C**************************************************************************
     C     EZLLFPOS      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RPLIJJ        KYZLLFLIJJ
     C                   MOVEL(P)  RPLINR        KYZLLFLINR
     C                   MOVEL(P)  RPLIPO        KYZLLFLIPO
     C                   MOVEA     '06C     '    CHI
     C                   EXSR      CHZLLF
     C*
     C                   Z-ADD     ZLLFLIPO      WKAFPOPOSI
     C                   Z-ADD     ZLLFLIPO      WKAFEPPOSI
     C                   Z-ADD     ZLLFLIPO      WKLIPO
     C                   MOVEL     ZLLFPRAR      WKPRAR
     C                   Z-ADD     ZLLFGLMG      WKGLMG
     C                   Z-ADD     *ZERO         WKNRMG
     C                   Z-ADD     ZLLFPREI      WKPREI
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  ZLLFPDIM      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   Z-ADD     1             WKPDIM
     C                   MOVEL(P)  ZLLFMEIN      WKMEIN
     C                   MOVEL(P)  ZLLFMEIN      WKMEPR
     C                   MOVEL(P)  ZLLFTENR      WKTENR
     C*
     C     RPERG1        IFNE      *ZERO
     C                   MOVEL(P)  ZLLFKON1      WKKON1
     C                   MOVEL(P)  *BLANK        TXKON1
     C                   Z-ADD     ZLLFKOW1      WKKOW1
     C                   Z-ADD     RPERG1        WKERG1
     C                   ENDIF
     C     RPERG2        IFNE      *ZERO
     C                   MOVEL(P)  ZLLFKON2      WKKON2
     C                   MOVEL(P)  *BLANK        TXKON2
     C                   Z-ADD     ZLLFKOW2      WKKOW2
     C                   Z-ADD     RPERG2        WKERG2
     C                   ENDIF
     C     RPERG3        IFNE      *ZERO
     C                   MOVEL(P)  ZLLFKON3      WKKON3
     C                   MOVEL(P)  *BLANK        TXKON3
     C                   Z-ADD     ZLLFKOW3      WKKOW3
     C                   Z-ADD     RPERG3        WKERG3
     C                   ENDIF
     C     RPERG4        IFNE      *ZERO
     C                   MOVEL(P)  ZLLFKON4      WKKON4
     C                   MOVEL(P)  *BLANK        TXKON4
     C                   Z-ADD     ZLLFKOW4      WKKOW4
     C                   Z-ADD     RPERG4        WKERG4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LS-POSITIONSDATEN TVA                                   ***
     C**************************************************************************
     C     EAFLP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RPLIJJ        KYALLJ
     C                   MOVEL(P)  RPLINR        KYALLI
     C                   MOVEL(P)  RPLIPO        KYALLP
     C                   MOVEA     '05C     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ALAFJJ        KYAFEPAFJJ
     C                   MOVEL(P)  ALAFNR        KYAFEPAFNR
     C                   MOVEL(P)  ALAFPO        KYAFEPAFPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFEP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ALAFPO        WKAFPOPOSI
     C                   Z-ADD     ALAFPO        WKAFEPPOSI
     C     AFEPPOSI      IFNE      *ZERO
     C                   Z-ADD     AFEPPOSI      WKAFEPPOSI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ALLIPO        WKLIPO
     C     AFEPPOSI      IFNE      *ZERO
     C                   Z-ADD     AFEPPOSI      WKLIPO
     C                   ENDIF
     C                   MOVEL     ALPRAR        WKPRAR
     C                   MOVEL     ALPREI        WKPREI
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  ALPDIM        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   Z-ADD     1             WKPDIM
     C                   Z-ADD     ALGLMG        WKGLMG
     C                   Z-ADD     ALNRMG        WKNRMG
     C                   MOVEL(P)  ALMEIN        WKMEIN
     C                   MOVEL(P)  ALMEIN        WKMEPR
     C                   MOVEL(P)  ALTENR        WKTENR
     C                   MOVEL(P)  ALTBZ1        WKTBZ1
     C                   MOVEL(P)  ALTBZ2        WKTBZ2
     C*
     C     RPERG1        IFNE      *ZERO
     C                   MOVEL(P)  ALKON1        WKKON1
     C                   MOVEL(P)  *BLANK        TXKON1
     C                   Z-ADD     ALKOW1        WKKOW1
     C                   Z-ADD     RPERG1        WKERG1
     C                   ENDIF
     C     RPERG2        IFNE      *ZERO
     C                   MOVEL(P)  ALKON2        WKKON2
     C                   MOVEL(P)  *BLANK        TXKON2
     C                   Z-ADD     ALKOW2        WKKOW2
     C                   Z-ADD     RPERG2        WKERG2
     C                   ENDIF
     C     RPERG3        IFNE      *ZERO
     C                   MOVEL(P)  ALKON3        WKKON3
     C                   MOVEL(P)  *BLANK        TXKON3
     C                   Z-ADD     ALKOW3        WKKOW3
     C                   Z-ADD     RPERG3        WKERG3
     C                   ENDIF
     C     RPERG4        IFNE      *ZERO
     C                   MOVEL(P)  ALKON4        WKKON4
     C                   MOVEL(P)  *BLANK        TXKON4
     C                   Z-ADD     ALKOW4        WKKOW4
     C                   Z-ADD     RPERG4        WKERG4
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN ZAHKLUNGSBEDINGUNG                                      ***
     C**************************************************************************
     C     ERZABD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKSKPZ
     C                   Z-ADD     *ZERO         WKSKDA
     C                   Z-ADD     *ZERO         WKSKOT
     C*-------------------------------------------------------------------------
     C     WKBRSU        IFEQ      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      WKZABD        KYZBZA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZABD
     C*-------------------------------------------------------------------------
     C     WKVADA        IFEQ      *ZERO
     C                   Z-ADD     WKREDA        WKVADA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKVALT        IFEQ      *ZERO
     C                   Z-ADD     ZBNTIN        WKVALT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXZABD
     C                   CLEAR                   RTZABD
     C                   MOVEL     WKZABD        EXZABDZABD
     C                   MOVEL     DASPCD        EXZABDSPCD
     C                   MOVEL     WKWACD        EXZABDWACD
     C                   MOVEL     KDLAND        EXZABDLDNR
     C                   Z-ADD     WKREDA        EXZABDREDA
     C                   Z-ADD     WKVADA        EXZABDVADA
     C                   MOVEL     AAPMKZ        EXZABDPMKZ
     C                   MOVEL     'AFZABD'      EXZABDPGST
     C                   CALL      'ERZABD'
     C                   PARM                    EXZABD
     C                   PARM                    RTZABD
     C*-------------------------------------------------------------------------
     C     ZBPRZ1        IFEQ      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   Z-ADD     ZBPRZ1        WKSKPZ
     C                   Z-ADD     ZBZIT1        WKSKOT
     C*
     C                   MOVEL     WKVADA        #CDATV
     C                   MOVE      *ZERO         #CDATN
     C                   MOVEL     'JHJJMMTT'    #CFMTV
     C                   MOVEL     'JHJJMMTT'    #CFMTN
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     '+'           KOM(1)
     C                   Z-ADD     ZBZIT1        DUN040
     C                   MOVEA     DUC004        KOM(2)
     C                   MOVEA     KOM(1)        #CKOMM
     C                   EXSR      TRERDA
     C                   MOVE      #CDATN        WKSKDA
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRMWST     ERMITELN MWST AUS MWST-DATEI                        ***
     C**************************************************************************
     C     TRAUFRMWST    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DUC002        KOM(01)
     C                   MOVEA     DUC008        KOM(03)
     C                   MOVEA     DASPCD        KOM(11)
     C                   EXSR      TRMWST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERTX02     ERMITELN KUNDEN-TEXT                                ***
     C**************************************************************************
     C     ERTX02        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         I1
     C                   MOVEA(P)  *BLANK        TXT
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRTX02'      KYTTTC
     C                   MOVEL     WKKDNR        KYTTKL
     C                   MOVEL     *BLANK        KYTTTE
     C                   MOVEL     *BLANK        KYTTA1
     C                   MOVEL     *BLANK        KYTTA2
     C                   MOVEL     KDSPCD        KYTTSP
     C                   MOVEL(P)  'RETEXT'      KYTTUC
     C                   MOVE      *ZERO         KYTTDA
     C                   Z-ADD     *ZERO         KYTTZN
     C*-------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTXST
     C*-------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*
     C     TTFIRM        IFGT      KYTTFI
     C     TTTCDE        ORGT      KYTTTC
     C     TTKDLI        ORGT      KYTTKL
     C     TTTENR        ORGT      KYTTTE
     C     TTA115        ORGT      KYTTA1
     C     TTA215        ORGT      KYTTA2
     C     TTSPCD        ORGT      KYTTSP
     C     TTUCDE        ORGT      KYTTUC
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------
     C     TTLFZN        IFEQ      *ZERO
     C                   IF            %TRIM(TTDR01) = 'R'
     C                             OR  %TRIM(TTDR02) = 'R'
     C                             OR  %TRIM(TTDR03) = 'R'
     C                             OR  %TRIM(TTDR04) = 'R'
     C                             OR  %TRIM(TTDR05) = 'R'
     C                             OR  %TRIM(TTDR06) = 'R'
     C                             OR  %TRIM(TTDR07) = 'R'
     C                             OR  %TRIM(TTDR08) = 'R'
     C                             OR  %TRIM(TTDR09) = 'R'
     C                             OR  %TRIM(TTDR10) = 'R'
     C                             OR  %TRIM(TTDR01) = '$'
     C                             OR  %TRIM(TTDR02) = '$'
     C                             OR  %TRIM(TTDR03) = '$'
     C                             OR  %TRIM(TTDR04) = '$'
     C                             OR  %TRIM(TTDR05) = '$'
     C                             OR  %TRIM(TTDR06) = '$'
     C                             OR  %TRIM(TTDR07) = '$'
     C                             OR  %TRIM(TTDR08) = '$'
     C* AUSGABE
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------
     C     TTTEXT        IFNE      *BLANK
     C                   ADD       1             I1
     C                   MOVEL(P)  TTTEXT        TXT(I1)
     C                   ENDIF
     C*
     C     I1            IFGE      5
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTXST
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         STAMMLAND
     C                   MOVEL(P)  'LAND'        KYTATC
     C                   MOVEL(P)  'LAND'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPASTLD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         EIGENE
     C                   MOVEL(P)  'USTI'        KYTATC                         UST-ID-NUMMER
     C                   MOVEL(P)  WKTRPASTLD    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPTXT        WKTRPAUSTI
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'PREI'        KYTATC                         PREISART FÜR
     C                   MOVEL     'PREI'        KYTAPA                         KOSTENLOS
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPAKOLI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRED74'      KYTATA                         PRÜFEN AFED
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'AFED'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAAFED        1
     C     WKTRPAAFED    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAAFED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         PRÜFEN
     C                   MOVEL     'MODAZO'      KYTATC                         OB AKZO-VERSION
     C                   MOVEL     'MODAZO'      KYTAPA                         AKTIV IST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C     TAPCDE        IFEQ      '01'
     C                   MOVEL     *ON           MODAZO
     C                   ELSE
     C                   MOVEL     *OFF          MODAZO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL     'MODWAO'      KYTATC                         FIRMA Waeco
     C                   MOVEL     'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        MODWAO
     C     MODWAO        IFNE      *ON
     C                   MOVEL     *OFF          MODWAO
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        MODAZO
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        WKED73
     C     *LIKE         DEFINE    WKC001        WKED73KOPF
     C     *LIKE         DEFINE    WKC001        WKED73REKO
     C     *LIKE         DEFINE    WKC001        WKED73LSKO
     C     *LIKE         DEFINE    WKC001        WKPRTNUM        +34
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        ED              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RKRGJJ        WKRGJJ
     C     *LIKE         DEFINE    RKRGNR        WKRGNR
     C     *LIKE         DEFINE    RKLIJJ        WKLIJJ
     C     *LIKE         DEFINE    RKLINR        WKLINR
     C     *LIKE         DEFINE    AKAFJJ        WKAFJJ
     C     *LIKE         DEFINE    AKAFNR        WKAFNR
     C*
     C     *LIKE         DEFINE    RKTZAK        WKTZAK
     C     *LIKE         DEFINE    RKWACD        WKWACD
     C     *LIKE         DEFINE    RKREDA        WKREDA
     C     *LIKE         DEFINE    RKVADA        WKVADA
     C     *LIKE         DEFINE    RKVALT        WKVALT
     C     *LIKE         DEFINE    RKVALT        WKSKOT
     C     *LIKE         DEFINE    RKBRSU        WKBRSU
     C     *LIKE         DEFINE    RKNESU        WKNESU
     C     *LIKE         DEFINE    RKSKB1        WKSKB1
     C     *LIKE         DEFINE    RKWAWT        WKWAWT
     C     *LIKE         DEFINE    RKMWS1        WKMWWT
     C     *LIKE         DEFINE    RKMWC1        WKMWST
     C     *LIKE         DEFINE    RKMWS1        WKMWS1
     C     *LIKE         DEFINE    RKWAWT        WKMWW1
     C     *LIKE         DEFINE    RKMWC1        WKMWC1
     C     *LIKE         DEFINE    RKERG1        WKKOSC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKZABD        WKZABD
     C     *LIKE         DEFINE    AKAFDA        WKAFDA
     C     *LIKE         DEFINE    AKREF1        WKREF1
     C     *LIKE         DEFINE    AKREF2        WKREF2
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ALPRAR        WKPRAR
     C     *LIKE         DEFINE    ALLSDA        WKLSDA
     C     *LIKE         DEFINE    ALLIPO        WKLIPO
     C     *LIKE         DEFINE    ALGLMG        WKGLMG
     C     *LIKE         DEFINE    ALNRMG        WKNRMG
     C     *LIKE         DEFINE    ALPREI        WKPREI
     C     *LIKE         DEFINE    TPTNUM        WKPDIM
     C     *LIKE         DEFINE    DUC003        WKMEIN
     C     *LIKE         DEFINE    DUC003        WKMEPR
     C     *LIKE         DEFINE    TPTTXT        TXKON1
     C     *LIKE         DEFINE    TPTTXT        TXKON2
     C     *LIKE         DEFINE    TPTTXT        TXKON3
     C     *LIKE         DEFINE    TPTTXT        TXKON4
     C     *LIKE         DEFINE    TPTTXT        TXLIBD#1
     C     *LIKE         DEFINE    TPTTXT        TXLIBD#2
     C     *LIKE         DEFINE    ALLIBD        WKLIBD
     C     *LIKE         DEFINE    ALKON1        WKKON1
     C     *LIKE         DEFINE    ALKON2        WKKON2
     C     *LIKE         DEFINE    ALKON3        WKKON3
     C     *LIKE         DEFINE    ALKON4        WKKON4
     C     *LIKE         DEFINE    ALKOW1        WKKOW1
     C     *LIKE         DEFINE    ALKOW2        WKKOW2
     C     *LIKE         DEFINE    ALKOW3        WKKOW3
     C     *LIKE         DEFINE    ALKOW4        WKKOW4
     C     *LIKE         DEFINE    ALTENR        WKTENR
     C     *LIKE         DEFINE    ALTBZ1        WKTBZ1
     C     *LIKE         DEFINE    ALTBZ2        WKTBZ2
     C     *LIKE         DEFINE    RPERG1        WKERG1
     C     *LIKE         DEFINE    RPERG2        WKERG2
     C     *LIKE         DEFINE    RPERG3        WKERG3
     C     *LIKE         DEFINE    RPERG4        WKERG4
     C     *LIKE         DEFINE    ALAFPO        WKAFEPPOSI
     C     *LIKE         DEFINE    ALAFPO        WKAFPOPOSI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKVADA        WKSKDA
     C     *LIKE         DEFINE    DUN052        WKSKPZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EKORNR        WKORNR
     C     *LIKE         DEFINE    EKBEAT        WKBEAT
     C     *LIKE         DEFINE    EKUORN        WKUORN
     C     *LIKE         DEFINE    EKILNR        WKILNR
     C     *LIKE         DEFINE    EKILNR        WKREILNR
     C     *LIKE         DEFINE    EKILNR        WKLSILNR
     C     *LIKE         DEFINE    AKKDNR        WKKDNR
     C     *LIKE         DEFINE    AKKDNR        WKREKDNR
     C     *LIKE         DEFINE    AKKDNR        WKLSKDNR
     C     *LIKE         DEFINE    WREDIL        WKWRIL
     C     *LIKE         DEFINE    WRUNBN        WKWRUN
     C     *LIKE         DEFINE    WRSTNR        WKSTNR
     C     *LIKE         DEFINE    WRUSTI        WKUSTI
     C     *LIKE         DEFINE    KDSTNR        WKIVSTNR
     C     *LIKE         DEFINE    KEUSTI        WKIVUSTI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AAPMKZ        WKPMKZ
     C     *LIKE         DEFINE    TEEANR        T1EANV
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KZZNRN        WKZNRN
     C     *LIKE         DEFINE    KZEDIB        WKEDIB
     C     *LIKE         DEFINE    KZKDRE        WKKDRE
     C     *LIKE         DEFINE    KZKDNR        WKKDNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KDLIFN        WKLIFN
     C* ------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN132        WKGSBRSU
     C     *LIKE         DEFINE    DUN060        WKUNHZ
     C     *LIKE         DEFINE    DUN060        WKUNBZ
     C     *LIKE         DEFINE    DUN060        WKLINZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AFRLL2DA      WKL2DA
     C     *LIKE         DEFINE    AFRLL2NR      WKL2NR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KELDNR        WKTRPASTLD
     C     *LIKE         DEFINE    KEUSTI        WKTRPAUSTI
     C     *LIKE         DEFINE    ALPRAR        WKTRPAKOLI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EDINSGMT      WKEDINSGMT
     C     *LIKE         DEFINE    DUC002        WKEDINEDGR
     C     *LIKE         DEFINE    EDINUKEY      WKEDINUKEY
     C     *LIKE         DEFINE    EDINUKEY      W1EDINUKEY
     C     *LIKE         DEFINE    ED73SATZ      WKED73SATZ
     C     *LIKE         DEFINE    ED73SATZ      W1ED73SATZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ED            WKED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFED
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFEP
     C/COPY QCPYSRC,CHAFRK
     C/COPY QCPYSRC,CHAFRL
     C/COPY QCPYSRC,CHAFRP
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPE
     C/COPY QCPYSRC,CHEDIN
     C/COPY QCPYSRC,CHED73
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHKDVS
     C/COPY QCPYSRC,CHKUEG
     C/COPY QCPYSRC,CHKPIF
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,CHKDZR
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTXST
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CHZRKO
     C/COPY QCPYSRC,CHZLLF
     C/COPY QCPYSRC,CHZRPA
     C/COPY QCPYSRC,CHZRAD
     C/COPY QCPYSRC,CHZABD
     C/COPY QCPYSRC,EZTEEW
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRERDA
     C/COPY QCPYSRC,TRMWST
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
