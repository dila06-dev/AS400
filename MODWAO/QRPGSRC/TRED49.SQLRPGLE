     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Übernahme AB
     H**************************************************************************
     H*  Copyright 2004 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 24.02.2005 HAWA  Projekt 3753
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 13.07.2006 Standard AFAD-Hausnummer
     H*  Änderung: RE 05.02.2009 BUSCH Projekt 5623
     H*            Integratrion Datei IFEP Interface Auftrag Position EDI
     H*  Änderung: RE 17.09.2010 BUSCH Service 20100914-010
     H*            Korrektur Ausgabe MOA-Segment
     H*  Änderung: PH 03.11.201t DOMETIC Projekt 11683. Ermitteln Partner-Nr über
     H*            Programmaufruf MOICRG (unter MODWAO)
     H**************************************************************************
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFAD          E DS                  INZ
     D KYAFAD        E DS                  INZ
     D*
     D AFED          E DS                  INZ
     D KYAFED        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D AFEP          E DS                  INZ
     D KYAFEP        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFPE          E DS                  INZ
     D KYAFPE        E DS                  INZ
     D*
     D ED63          E DS                  INZ
     D KYED63        E DS                  INZ
     D*
     D EDIN          E DS                  INZ
     D KYEDIN        E DS                  INZ
     D*
     D IFED          E DS                  INZ
     D KYIFED        E DS                  INZ
     D*
     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D ZKUN          E DS                  INZ
     D KYZKUN        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D*
     D EXED49        E DS
     D RTED49        E DS
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D/COPY QCPYSRC,INHOUSE96A
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
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
     C                   PARM                    EXED49
     C                   PARM                    RTED49
     C*
     C                   EXSR      UEBED49
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
     C     EXED49AFNR    IFNE      *BLANK
     C                   EXSR      VAFKO01
     C                   ELSE
     C                   EXSR      VAFKO02
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      UED63
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
     C                   MOVEL(P)  DAFIRM        KYEKFI
     C                   MOVEL(P)  DAFIRM        KYADFI
     C                   MOVEL(P)  DAFIRM        KYAKFI
     C                   MOVEL(P)  DAFIRM        KYAPFI
     C                   MOVEL(P)  DAFIRM        KYAFEPFIRM
     C                   MOVEL(P)  DAFIRM        KYAAFI
     C                   MOVEL(P)  DAFIRM        KYAFPEFIRM
     C                   MOVEL(P)  DAFIRM        KYEDINFIRM
     C                   MOVEL(P)  'EE'          KYEDINEDIF
     C                   MOVEL(P)  'ORDRSP'      KYEDINNTYP
     C                   MOVEL(P)  DAFIRM        KYKDFI
     C                   MOVEL(P)  DAFIRM        KYKPFI
     C                   MOVEL(P)  DAFIRM        KYSYTPFIRM
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYWRFI
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXED49                                                 ***
     C**************************************************************************
     C     UEBED49       BEGSR
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
     C                   MOVEL(P)  *OFF          WKED49
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  NACHLAUF                                                          ***
     C**************************************************************************
     C     NACHLAUF      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* SCHLIEßEN CHED63
     C*-------------------------------------------------------------------------
     C                   MOVEA     'LR      '    CHI
     C                   EXSR      CHED63
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTED49
     C                   MOVEL(P)  *ZERO         RTED49FENR
     C     WKED49        IFEQ      *OFF
     C                   MOVEL(P)  '0031'        RTED49FENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFKO01       VERARBEITEN AUFTRAGSDATEI                           ***
     C**************************************************************************
     C     VAFKO01       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKILKD
     C                   MOVE      *ZERO         WKANZLNACH
     C                   MOVE      *ZERO         WKNESU
     C*
     C                   MOVEL(P)  *OFF          WKED49KOPF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFKO
     C                   MOVEL(P)  DAFIRM        KYAKFI
     C                   MOVEL(P)  EXED49AFJJ    KYAKJH
     C                   MOVEL(P)  EXED49AFNR    KYAKAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     AKFIRM        IFNE      KYAKFI
     C     AKAFJJ        ORNE      KYAKJH
     C     AKAFNR        ORNE      KYAKAF
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAEDIU        IFNE      DAJNKZ
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKAFAT        KYAFPEAFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPE
     C*
     C     AFPEORSP      IFNE      DAJNKZ
     C     AFPEORSP      ANDNE     *BLANK
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAAFED    IFEQ      *ON
     C                   MOVEL(P)  AKAFJJ        KYEKJH
     C                   MOVEL(P)  AKAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAIFED    IFEQ      *ON
     C                   MOVEL(P)  AKFIRM        KYIFEDFIRM
     C                   MOVEL(P)  AKAFJJ        KYIFEDAFJJ
     C                   MOVEL(P)  AKAFNR        KYIFEDAFNR
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHIFED
     C*
     C     CHI(05)       IFEQ      'J'
     C     IFEDAPER      ANDNE     DAJNKZ
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRAFPO
     C*
     C     WKAFPO        IFEQ      *OFF
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKED49KOPF    IFEQ      *OFF
     C                   EXSR      EED63KOPF
     C                   EXSR      UED63KOPF
     C                   MOVEL(P)  *ON           WKED49KOPF
     C                   ENDIF
     C*
     C                   EXSR      EED63AFKO
     C                   EXSR      UED63AFKO
     C*
     C                   EXSR      VAFPO
     C*
     C                   EXSR      EED63AFSC
     C                   EXSR      UED63AFSC
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKED49KOPF    IFEQ      *ON
     C                   EXSR      EED63ENDE
     C                   EXSR      UED63ENDE
     C                   MOVEL(P)  *ON           WKED49
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFKO02       VERARBEITEN RECHNUNGSDATEI                          ***
     C**************************************************************************
     C     VAFKO02       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKILKD
     C                   MOVE      *ZERO         WKANZLNACH
     C                   MOVE      *ZERO         WKNESU
     C*
     C                   MOVEL(P)  *OFF          WKED49KOPF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFKO
     C                   MOVEL(P)  DAFIRM        KYAKFI
     C                   MOVEL(P)  EXED49KDNR    KYAKKD
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     AKFIRM        IFNE      KYAKFI
     C     AKKDNR        ORNE      KYAKKD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRAFPO
     C*
     C     WKAFPO        IFEQ      *OFF
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHAFKO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKED49KOPF    IFEQ      *OFF
     C                   EXSR      EED63KOPF
     C                   EXSR      UED63KOPF
     C                   MOVEL(P)  *ON           WKED49KOPF
     C                   ENDIF
     C*
     C                   EXSR      EED63AFKO
     C                   EXSR      UED63AFKO
     C*
     C                   EXSR      VAFPO
     C*
     C                   EXSR      EED63AFSC
     C                   EXSR      UED63AFSC
     C*----------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKED49KOPF    IFEQ      *ON
     C                   EXSR      EED63ENDE
     C                   EXSR      UED63ENDE
     C                   MOVEL(P)  *ON           WKED49
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRAFPO        VERARBEITEN AUFTRAGSPOSITIONEN                      ***
     C**************************************************************************
     C     PRAFPO        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *OFF          WKAFPO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFPO
     C                   MOVEL(P)  AKFIRM        KYAPFI
     C                   MOVEL(P)  AKAFJJ        KYAPJH
     C                   MOVEL(P)  AKAFNR        KYAPAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     APFIRM        IFNE      KYAPFI
     C     APAFJJ        ORNE      KYAPJH
     C     APAFNR        ORNE      KYAPAF
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     APEDST        IFGE      '90'
     C     APEDST        OREQ      *BLANK
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL     *ON           WKAFPO
     C                   LEAVE
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFPO         VERARBEITEN AUFTRAGSPOSITIONEN                      ***
     C**************************************************************************
     C     VAFPO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFPO
     C                   MOVEL(P)  AKFIRM        KYAPFI
     C                   MOVEL(P)  AKAFJJ        KYAPJH
     C                   MOVEL(P)  AKAFNR        KYAPAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     APFIRM        IFNE      KYAPFI
     C     APAFJJ        ORNE      KYAPJH
     C     APAFNR        ORNE      KYAPAF
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     APEDST        IFGE      '90'
     C     APEDST        OREQ      *BLANK
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      EED63AFPO
     C                   EXSR      UED63AFPO
     C*----------------------------------------------------------
     C                   Z-ADD     APAFPO        KYAPPO
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFPO
     C*
     C                   MOVEL     '90'          APEDST
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFPO
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFPO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED63KOPF     ERMITTELN KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED63KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        MODWAO = *ON
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   EVAL      %SUBST(EXTRNDDATE:01) = 'ORDRSP'
     C                   EVAL      %SUBST(EXTRNDDATE:07) = AKKDNR
     C                   EVAL      EXTRNDPGST = 'ERPRTN'
     C                   CALL      'MOICRG'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C                   EVAL      WKPRTNUM = %SUBST(RTTRNDDATE:01)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYED63KYNR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHED63
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  ED63KYNR      DUN140
     C                   MOVEL(P)  ED63KYNR      DUN100
     C                   ENDIF
     C                   Z-ADD     *ZERO         DUN140
     C                   ADD       1             DUN100
     C                   MOVEL     DUN100        DUN140
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKUNH0062
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63KOPF     UPDATE    KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED63KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED63AFKO     ERMITTELN KOPFDATEN PRO AUFTRAG                     ***
     C**************************************************************************
     C     EED63AFKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKUNH0062
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C                   MOVEL     KZEDIB        WKILKD
     C                   MOVEL(P)  KZEDIB        WKZNRN
     C     WKZNRN        IFEQ      *BLANK
     C                   MOVEL(P)  AKKDNR        WKZNRN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKAFJJ        KYEKJH
     C                   MOVEL(P)  AKAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C                   MOVEL(P)  EKORNR        WKORNR
     C     EKORNR        IFEQ      *BLANK
     C                   MOVEL(P)  AKREF1        WKORNR
     C                   ENDIF
     C                   MOVEL(P)  EKILNR        WKILNR
     C                   MOVEL(P)  EKLFBK        WKLIFN
     C     EKILNR        IFNE      *BLANK
     C                   MOVEL(P)  EKILNR        WKILKD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKLIFN        IFEQ      *BLANK
     C                   MOVEL(P)  KDLIFN        WKLIFN
     C                   ENDIF
     C     WKILNR        IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKILNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKWKNR        KYWRNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKAFJJ        KYAPJH
     C                   MOVEL(P)  AKAFNR        KYAPAF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFPO
     C*
     C     CHI(05)       IFEQ      'J'
     C     AKFIRM        ANDEQ     KYAPFI
     C     AKAFJJ        ANDEQ     KYAPJH
     C     AKAFNR        ANDEQ     KYAPAF
     C                   MOVEL(P)  APLFTE        WKLFTE
     C                   ELSE
     C                   MOVEL(P)  *ZERO         WKLFTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        WKNAM1
     C                   MOVEL(P)  *BLANK        WKNAM2
     C                   MOVEL(P)  *BLANK        WKSTRA
     C                   MOVEL(P)  *BLANK        WKWORT
     C                   MOVEL(P)  *BLANK        WKPOLZ
     C                   MOVEL(P)  *BLANK        WKPOLD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH
     C                   MOVEL(P)  AKAFNR        KYADAF
     C                   MOVEL(P)  'ADVS'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C     CHI(5)        IFEQ      'N'
     C                   Z-ADD     AKAFJJ        KYADJH
     C                   MOVEL(P)  AKAFNR        KYADAF
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C                   ENDIF
     C*
     C                   MOVE      ADNAM1        WKNAM1
     C                   MOVE      ADNAM2        WKNAM2
     C                   EVAL      WKSTRA=%TRIM(ADSTRA)+' '+%TRIM(ADHSNR)
     C                   MOVE      ADPOLD        WKPOLD
     C                   MOVE      ADPOLZ        WKPOLZ
     C                   MOVE      ADWORT        WKWORT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        WKBYNAM1
     C                   MOVEL(P)  *BLANK        WKBYNAM2
     C                   MOVEL(P)  *BLANK        WKBYSTRA
     C                   MOVEL(P)  *BLANK        WKBYWORT
     C                   MOVEL(P)  *BLANK        WKBYPOLZ
     C                   MOVEL(P)  *BLANK        WKBYPOLD
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH
     C                   MOVEL(P)  AKAFNR        KYADAF
     C                   MOVEL(P)  'ADAG'        KYADAA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFAD
     C*
     C                   MOVE      ADNAM1        WKBYNAM1
     C                   MOVE      ADNAM2        WKBYNAM2
     C                   EVAL      WKBYSTRA=%TRIM(ADSTRA)+' '+%TRIM(ADHSNR)
     C                   MOVE      ADPOLD        WKBYPOLD
     C                   MOVE      ADPOLZ        WKBYPOLZ
     C                   MOVE      ADWORT        WKBYWORT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63AFKO     UPDATE    KOPFDATEN PRO AUFTRAG                     ***
     C**************************************************************************
     C     UED63AFKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNB'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*-------------------------------------------------------------------------
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EUNB
     C                   MOVEL(P)  UNB           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNH'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNH
     C                   MOVEL(P)  UNH           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  BGM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAI'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAI
     C                   MOVEL(P)  PAI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IMD'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EIMD
     C                   MOVEL(P)  IMD           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '01'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '01'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'AJT'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAJT
     C                   MOVEL(P)  AJT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '03'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '03'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FFI'         WKEDINSGMT
     C                   MOVEL(P)  '03'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFFI
     C                   MOVEL(P)  FFI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DOC'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDOC
     C                   MOVEL(P)  DOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '07'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '07'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '07'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CUX'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECUX
     C                   MOVEL(P)  CUX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
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
     C                   EXSR      EPAT
     C                   MOVEL(P)  PAT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  TOD           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  PAC           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  PCI           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  GIN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'EQD'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EEQD
     C                   MOVEL(P)  EQD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'SCC'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ESCC
     C                   MOVEL(P)  SCC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APR'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAPR
     C                   MOVEL(P)  APR           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RTE'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERTE
     C                   MOVEL(P)  RTE           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED63AFPO     ERMITTELN ENDEDATEN PRO AUFTRAG-POSITION            ***
     C**************************************************************************
     C     EED63AFPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   ADD       APNESU        WKNESU
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  APAFJJ        KYAFEPAFJJ
     C                   MOVEL(P)  APAFNR        KYAFEPAFNR
     C                   MOVEL(P)  APAFPO        KYAFEPAFPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFEP
     C*
     C                   Z-ADD     AFEPPOSI      W1AFPO
     C     W1AFPO        IFEQ      *ZERO
     C                   Z-ADD     APAFPO        W1AFPO
     C                   ENDIF
     C                   MOVEL(P)  AFEPVPME      WKVPME
     C     AFEPVPMG      IFNE      *ZERO
     C     APBSMG        DIV       AFEPVPMG      APBSMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  APTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AKKDNR        KYKPKD
     C                   MOVEL(P)  APTENR        KYKPTE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKPIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  APMEIN        WKMEIN
     C                   MOVEL(P)  APMEPR        WKMEPR
     C*
     C                   MOVEL(P)  'MEINTRDEDI'  KYSYTPTART
     C                   MOVEL(P)  APMEIN        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL(P)  SYTPTTXT      WKMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEPRTRDEDI'  KYSYTPTART
     C                   MOVEL(P)  APMEPR        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKMEPR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  APPDIM        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   Z-ADD     TPTNUM        WKPDIM
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     APKON1        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON1
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     APKON2        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON2
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     APKON3        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON3
     C*-------------------------------------------------------------------------
     C                   MOVEL     'KOND'        KYTPTA
     C                   MOVEL     APKON4        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXKON4
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63AFPO     UPDATE ENDEDATEN PRO AUFTRAG-POSITION               ***
     C**************************************************************************
     C     UED63AFPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LIN'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELIN
     C                   MOVEL(P)  LIN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PIA'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPIA
     C                   MOVEL(P)  PIA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IMD'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EIMD
     C                   MOVEL(P)  IMD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIR'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIR
     C                   MOVEL(P)  GIR           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QVR'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQVR
     C                   MOVEL(P)  QVR           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DOC'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDOC
     C                   MOVEL(P)  DOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAI'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAI
     C                   MOVEL(P)  PAI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '26'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CCI'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECCI
     C                   MOVEL(P)  CCI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CAV'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECAV
     C                   MOVEL(P)  CAV           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '27'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAT'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAT
     C                   MOVEL(P)  PAT           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '28'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'AJT'         WKEDINSGMT
     C                   MOVEL(P)  '29'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAJT
     C                   MOVEL(P)  AJT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '29'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PRI'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPRI
     C                   MOVEL(P)  PRI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CUX'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECUX
     C                   MOVEL(P)  CUX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'APR'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EAPR
     C                   MOVEL(P)  APR           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '30'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAC'         WKEDINSGMT
     C                   MOVEL(P)  '32'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAC
     C                   MOVEL(P)  PAC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '32'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '33'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '33'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCI'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCI
     C                   MOVEL(P)  PCI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
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
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '34'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '35'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '35'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '35'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '36'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '36'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '36'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '37'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '37'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '38'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DOC'         WKEDINSGMT
     C                   MOVEL(P)  '39'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDOC
     C                   MOVEL(P)  DOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '39'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '40'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '40'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED49SATZ
     C                   EXSR      WED49
     C*
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  '42Y'         WKEDINSGMT
     C                   MOVEL(P)  '39'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '42'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '43'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '43'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '44'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '44'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'RTE'         WKEDINSGMT
     C                   MOVEL(P)  '45'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'RNG'         WKEDINSGMT
     C                   MOVEL(P)  '45'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      ERNG
     C                   MOVEL(P)  RNG           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'TAX'         WKEDINSGMT
     C                   MOVEL(P)  '46'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      ETAX
     C                   MOVEL(P)  TAX           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '46'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     ED            WKED
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ENDIF
     C                   Z-ADD     WKED          ED
     C*
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '41'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '47'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '48'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '48'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TOD'         WKEDINSGMT
     C                   MOVEL(P)  '49'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETOD
     C                   MOVEL(P)  TOD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '49'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'EQD'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EEQD
     C                   MOVEL(P)  EQD           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '50'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'SCC'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ESCC
     C                   MOVEL(P)  SCC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '51'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '52'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '52'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RCS'         WKEDINSGMT
     C                   MOVEL(P)  '53'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERCS
     C                   MOVEL(P)  RCS           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '53'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '53'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '53'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'STG'         WKEDINSGMT
     C                   MOVEL(P)  '54'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ESTG
     C                   MOVEL(P)  STG           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '55'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '55'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED63AFSC     ERMITTELN ENDEDATEN PRO AUFTRAG                     ***
     C**************************************************************************
     C     EED63AFSC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63AFSC     UPDATE ENDEDATEN PRO AUFTRAG                        ***
     C**************************************************************************
     C     UED63AFSC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNS'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNS
     C                   MOVEL(P)  UNS           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CNT'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECNT
     C                   MOVEL(P)  CNT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALC'         WKEDINSGMT
     C                   MOVEL(P)  '56'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALC
     C                   MOVEL(P)  ALC           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '56'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '56'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNT'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNT
     C                   MOVEL(P)  UNT           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED63ENDE     ERMITTELN ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED63ENDE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63ENDE     UPDATE    ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED63ENDE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNZ'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EUNZ
     C                   MOVEL(P)  UNZ           WKED49SATZ
     C                   EXSR      WED49
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT AJT
     C**************************************************************************
     C     EAJT          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   AJT
     C                   MOVEL(P)  AJT           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  ALC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '41'
     C                   SELECT
     C     ED            WHENEQ    1
     C     APKON1        ANDNE     *BLANK
     C     APKOW1        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  APKON1        ALC7161
     C                   MOVEL(P)  TXKON1        ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    1
     C     APKON1        ANDNE     *BLANK
     C     APKOW1        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  APKON1        ALC7161
     C                   MOVEL(P)  TXKON1        ALC7160#1
     C                   MOVEL     '1  '         ALC1227
     C     ED            WHENEQ    2
     C     APKON2        ANDNE     *BLANK
     C     APKOW2        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  APKON2        ALC7161
     C                   MOVEL(P)  TXKON2        ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    2
     C     APKON2        ANDNE     *BLANK
     C     APKOW2        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  APKON2        ALC7161
     C                   MOVEL(P)  TXKON2        ALC7160#1
     C                   MOVEL     '2  '         ALC1227
     C     ED            WHENEQ    3
     C     APKON3        ANDNE     *BLANK
     C     APKOW3        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  APKON3        ALC7161
     C                   MOVEL(P)  TXKON3        ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    3
     C     APKON3        ANDNE     *BLANK
     C     APKOW3        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  APKON3        ALC7161
     C                   MOVEL(P)  TXKON3        ALC7160#1
     C                   MOVEL     '3  '         ALC1227
     C     ED            WHENEQ    4
     C     APKON4        ANDNE     *BLANK
     C     APKOW4        ANDLE     *ZERO
     C                   MOVEL(P)  'A'           ALC5463
     C                   MOVEL(P)  APKON4        ALC7161
     C                   MOVEL(P)  TXKON4        ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C     ED            WHENEQ    4
     C     APKON4        ANDNE     *BLANK
     C     APKOW4        ANDGE     *ZERO
     C                   MOVEL(P)  'C'           ALC5463
     C                   MOVEL(P)  APKON4        ALC7161
     C                   MOVEL(P)  TXKON4        ALC7160#1
     C                   MOVEL     '4  '         ALC1227
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT ALI
     C**************************************************************************
     C     EALI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ALI
     C                   MOVEL(P)  ALI           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT APR
     C**************************************************************************
     C     EAPR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   APR
     C                   MOVEL(P)  APR           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  BGM           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '320'         BGM1001
     C                   MOVEL(P)  AKAFNR        BGM1004
     C*
     C                   MOVEL(P)  '9'           BGM1225
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CAV
     C**************************************************************************
     C     ECAV          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CAV
     C                   MOVEL(P)  CAV           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CCI
     C**************************************************************************
     C     ECCI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CCI
     C                   MOVEL(P)  CCI           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   CLEAR                   CNT
     C                   MOVEL(P)  CNT           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  COM           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  CTA           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  CUX           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '2'           CUX6347#1
     C                   MOVEL(P)  AKWACD        CUX6345#1
     C                   MOVEL(P)  '9'           CUX6343#1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT DOC
     C**************************************************************************
     C     EDOC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DOC
     C                   MOVEL(P)  DOC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  DTM           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '8  '         DTM2005
     C                   MOVEL(P)  AKAFDA        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '4  '         DTM2005
     C                   MOVEL(P)  AKBEDA        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '2  '         DTM2005
     C                   MOVEL(P)  WKLFTE        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '01'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  AKAFDA        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '26'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '191'         DTM2005
     C                   MOVEL(P)  APLFTE        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '52'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '17 '         DTM2005
     C                   MOVEL(P)  APLFTE        DUC008
     C                   MOVEL(P)  DUC008        DTM2380
     C                   MOVEL(P)  '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT EQD
     C**************************************************************************
     C     EEQD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EQD
     C                   MOVEL(P)  EQD           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT ERC
     C**************************************************************************
     C     EERC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   ERC
     C                   MOVEL(P)  ERC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT FFI
     C**************************************************************************
     C     EFFI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   FFI
     C                   MOVEL(P)  FFI           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  FTX           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT GIN
     C**************************************************************************
     C     EGIN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   GIN
     C                   MOVEL(P)  GIN           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT GIR
     C**************************************************************************
     C     EGIR          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   GIR
     C                   MOVEL(P)  GIR           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT HAN
     C**************************************************************************
     C     EHAN          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   HAN
     C                   MOVEL(P)  HAN           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  IMD           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'A'           IMD7077
     C                   MOVEL(P)  APTBZ1        IMD7008#1
     C                   MOVEL(P)  APTBZ2        IMD7008#2
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
     C                   MOVEL(P)  LIN           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     W1AFPO        LIN1082#1
     C*
     C                   SELECT
     C     APEDST        WHENEQ    '01'
     C                   MOVEL(P)  '5'           LIN1229
     C     APEDST        WHENEQ    '02'
     C                   MOVEL(P)  '2'           LIN1229
     C     APEDST        WHENEQ    '03'
     C                   MOVEL(P)  '3'           LIN1229
     C                   ENDSL
     C*
     C                   MOVEL(P)  TEEANR        LIN7140
     C                   MOVE      'EN '         LIN7143
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
     C                   CLEAR                   LOC
     C                   MOVEL(P)  LOC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT MEA
     C**************************************************************************
     C     EMEA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   MEA
     C                   MOVEL(P)  MEA           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  MOA           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '26'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '203'         MOA5025
     C                   Z-ADD     APNESU        DUN112
     C                   Z-ADD     DUN110        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '00'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '86 '         MOA5025
     C                   Z-ADD     WKNESU        DUN112
     C                   Z-ADD     DUN110        MOA5004
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  NAD           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'BY '         NAD3035
     C                   MOVEL(P)  WKILNR        NAD3039
     C                   MOVEL(P)  WKBYNAM1      NAD3036#1
     C                   MOVEL(P)  WKBYNAM2      NAD3036#2
     C                   MOVEL(P)  WKBYSTRA      NAD3042#1
     C                   MOVEL(P)  WKBYWORT      NAD3164
     C                   MOVEL(P)  WKBYPOLZ      NAD3251
     C                   MOVEL(P)  WKBYPOLD      NAD3207
     C                   MOVEL(P)  '9'           NAD3055
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'DP '         NAD3035
     C                   MOVEL(P)  WKILKD        NAD3039
     C                   MOVEL(P)  WKNAM1        NAD3036#1
     C                   MOVEL(P)  WKNAM2        NAD3036#2
     C                   MOVEL(P)  WKSTRA        NAD3042#1
     C                   MOVEL(P)  WKWORT        NAD3164
     C                   MOVEL(P)  WKPOLZ        NAD3251
     C                   MOVEL(P)  WKPOLD        NAD3207
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'SU '         NAD3035
     C                   MOVEL(P)  WREDIL        NAD3039
     C                   MOVEL(P)  WRNAM1        NAD3036#1
     C                   MOVEL(P)  WRNAM2        NAD3036#2
     C                   MOVEL(P)  WRSTRA        NAD3042#1
     C                   MOVEL(P)  WRWORT        NAD3164
     C                   MOVEL(P)  WRPOLZ        NAD3251
     C                   MOVEL(P)  WRPOLD        NAD3207
     C                   MOVEL(P)  '9'           NAD3055
     C                   OTHER
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
     C                   CLEAR                   PAC
     C                   MOVEL(P)  PAC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT PAI
     C**************************************************************************
     C     EPAI          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   PAI
     C                   MOVEL(P)  PAI           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  PAT           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  PCD           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '43'
     C                   SELECT
     C     ED            WHENEQ    1
     C     APKON1        ANDNE     *BLANK
     C     APKOW1        ANDLT     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-SUB     APKOW1        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    1
     C     APKON1        ANDNE     *BLANK
     C     APKOW1        ANDGT     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     APKOW1        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    2
     C     APKON2        ANDNE     *BLANK
     C     APKOW2        ANDLT     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-SUB     APKOW2        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    2
     C     APKON2        ANDNE     *BLANK
     C     APKOW2        ANDGT     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     APKOW2        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     APKON3        ANDNE     *BLANK
     C     APKOW3        ANDLT     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-SUB     APKOW3        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    3
     C     APKON3        ANDNE     *BLANK
     C     APKOW3        ANDGT     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     APKOW3        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     APKON4        ANDNE     *BLANK
     C     APKOW4        ANDLT     *ZERO
     C                   MOVEL(P)  '1'           PCD5245
     C                   Z-SUB     APKOW4        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C     ED            WHENEQ    4
     C     APKON4        ANDNE     *BLANK
     C     APKOW4        ANDGT     *ZERO
     C                   MOVEL(P)  '2'           PCD5245
     C                   Z-ADD     APKOW4        DUN102
     C                   MOVEL(P)  DUC010        PCD5482
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
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
     C                   CLEAR                   PCI
     C                   MOVEL(P)  PCI           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  PIA           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TETENR        PIA7140#1
     C                   MOVE      'SA '         PIA7143#1
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KPIDEN        PIA7140#2
     C                   MOVE      'BP '         PIA7143#2
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  PRI           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVE      'NTP'         PRI5125
     C     APBSMG        IFNE      *ZERO
     C     APNESU        DIV(H)    APBSMG        DUN216
     C                   MULT      WKPDIM        DUN216
     C                   ELSE
     C                   Z-ADD     APNESU        DUN216
     C                   ENDIF
     C                   Z-ADD(H)  DUN216        DUN112
     C                   Z-ADD     DUN110        PRI5118
     C                   Z-ADD     WKPDIM        PRI5284
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
     C                   MOVEL(P)  QTY           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '26'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '21'          QTY6063
     C                   Z-ADD     APBSMG        DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  WKMEIN        QTY6411
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '52'          QTY6063
     C                   Z-ADD     AFEPVPMG      DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  WKVPME        QTY6411
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '52'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '12'          QTY6063
     C                   Z-ADD     APBSMG        DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL(P)  WKMEIN        QTY6411
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
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
     C                   CLEAR                   QVR
     C                   MOVEL(P)  QVR           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   CLEAR                   RCS
     C                   MOVEL(P)  RCS           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  RFF           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '01'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'VN '         RFF1153
     C                   MOVEL(P)  AKAFNR        RFF1154
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '31'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'CR '         RFF1153
     C                   MOVEL(P)  APAFPO        RFF1154
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'VN '         RFF1153
     C                   MOVEL(P)  AKAFNR        RFF1154
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C                   OTHER
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
     C                   CLEAR                   RNG
     C                   MOVEL(P)  RNG           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT RTE
     C**************************************************************************
     C     ERTE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTE
     C                   MOVEL(P)  RTE           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT SCC
     C**************************************************************************
     C     ESCC          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SCC
     C                   MOVEL(P)  SCC           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '1'           SCC4017
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT STG
     C**************************************************************************
     C     ESTG          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   STG
     C                   MOVEL(P)  STG           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  TAX           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  TDT           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  TOD           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  UNB           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNOA    '    UNB0001
     C                   Z-ADD     2             UNB0002
     C*
     C                   MOVEL(P)  WREDIL        UNB0004
     C                   MOVEL(P)  14            UNB0007#1
     C*
     C                   MOVEL(P)  WKZNRN        UNB0010
     C                   MOVEL(P)  14            UNB0007#2
     C*
     C                   MOVE      WKTDAT        DUN080
     C                   MOVE      DUC008        UNB0017
     C                   TIME                    DUN060
     C                   MOVE      DUC006        UNB0019
     C                   MOVE      *ZERO         UNB0020
     C*
     C                   IF        MODWAO = *ON
     C                   EVAL      UNB0032 = WKPRTNUM
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  UNH           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKILKD        UNH0062                         REF-NUMBER
     C*
     C                   MOVEL(P)  'ORDRSP'      UNH0065
     C                   MOVEL(P)  'D'           UNH0052
     C                   MOVEL(P)  '96A'         UNH0054
     C                   MOVEL(P)  'UN      '    UNH0051
     C                   MOVEL(P)  'EAN007  '    UNH0057
     C*--------------------------------------------------------------
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
     C                   MOVEL(P)  UNS           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'S'           UNS0081
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL(P)  UNT           W1ED49SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKANZLNACH    UNT0074
     C                   MOVEL(P)  WKUNH0062     UNT0062
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
     C                   MOVEL(P)  UNZ           W1ED49SATZ
     C*-------------------------------------------------------------------------
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
     C***  WED49         SCHREIBEN    ED49                                   ***
     C**************************************************************************
     C     WED49         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ED            DUN010
     C                   EVAL      W1EDINUKEY=%TRIM(WKEDINUKEY)+DUC001
     C*-------------------------------------------------------------------------
     C     WKED49SATZ    IFNE      W1ED49SATZ
     C                   ADD       1             DUN140
     C*
     C                   CLEAR                   ED63
     C                   MOVEL(P)  DUN140        ED63KYNR
     C                   MOVEL(P)  '0'           ED63FLGS
     C                   MOVEL(P)  '8'           ED63STA1
     C                   MOVEL(P)  W1EDINUKEY    ED63SAAR
     C                   MOVEL(P)  WKED49SATZ    ED63SATZ
     C*
     C                   MOVEL(P)  DUN140        KYED63KYNR
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHED63
     C*
     C                   ADD       1             WKANZLNACH
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED63         UDATE STATUS ED49                                   ***
     C**************************************************************************
     C     UED63         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE ED63 SET ED63STA1 = ' '
     C+ WHERE ED63STA1 = '8'
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRED49'      KYTATA                         PRÜFEN AFED
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'AFED'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAAFED        1
     C     WKTRPAAFED    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAAFED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRED49'      KYTATA                         PRÜFEN AFED
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'IFED'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAIFED        1
     C     WKTRPAIFED    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAIFED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL(P)  'MODWAO'      KYTATC                         FIRMA Waeco
     C                   MOVEL(P)  'MODWAO'      KYTAPA
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
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKAFPO
     C     *LIKE         DEFINE    WKC001        WKED49
     C     *LIKE         DEFINE    WKC001        WKED49KOPF
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        WKPRTNUM        +34
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        ED              + 2
     C     *LIKE         DEFINE    WKN010        WKED            + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EDINSGMT      WKEDINSGMT
     C     *LIKE         DEFINE    DUC002        WKEDINEDGR
     C     *LIKE         DEFINE    EDINUKEY      WKEDINUKEY       -2
     C     *LIKE         DEFINE    EDINUKEY      W1EDINUKEY       -2
     C     *LIKE         DEFINE    WKC001        WKED49SATZ    +1023
     C     *LIKE         DEFINE    WKC001        W1ED49SATZ    +1023
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KZEDIB        WKZNRN
     C     *LIKE         DEFINE    EKORNR        WKORNR
     C     *LIKE         DEFINE    EKILNR        WKILNR
     C     *LIKE         DEFINE    KZEDIB        WKILKD
     C     *LIKE         DEFINE    KDLIFN        WKLIFN
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AKAFDA        WKLFTE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ADNAM1        WKNAM1
     C     *LIKE         DEFINE    ADNAM2        WKNAM2
     C     *LIKE         DEFINE    ADSTRA        WKSTRA          +10
     C     *LIKE         DEFINE    ADPOLD        WKPOLD
     C     *LIKE         DEFINE    ADPOLZ        WKPOLZ
     C     *LIKE         DEFINE    ADWORT        WKWORT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ADNAM1        WKBYNAM1
     C     *LIKE         DEFINE    ADNAM2        WKBYNAM2
     C     *LIKE         DEFINE    ADSTRA        WKBYSTRA        +10
     C     *LIKE         DEFINE    ADPOLD        WKBYPOLD
     C     *LIKE         DEFINE    ADPOLZ        WKBYPOLZ
     C     *LIKE         DEFINE    ADWORT        WKBYWORT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TPTNUM        WKPDIM
     C     *LIKE         DEFINE    DUC003        WKVPME
     C     *LIKE         DEFINE    DUC003        WKMEIN
     C     *LIKE         DEFINE    DUC003        WKMEPR
     C     *LIKE         DEFINE    TPTTXT        TXKON1
     C     *LIKE         DEFINE    TPTTXT        TXKON2
     C     *LIKE         DEFINE    TPTTXT        TXKON3
     C     *LIKE         DEFINE    TPTTXT        TXKON4
     C     *LIKE         DEFINE    APNESU        WKNESU
     C     *LIKE         DEFINE    APNESU        W1AFPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN140        WKANZLNACH
     C     *LIKE         DEFINE    DUN140        WKUNH0062
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFED
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFEP
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPE
     C/COPY QCPYSRC,CHED63
     C/COPY QCPYSRC,CHEDIN
     C/COPY QCPYSRC,CHIFED
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHKPIF
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
