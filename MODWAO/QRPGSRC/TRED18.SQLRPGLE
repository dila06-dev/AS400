     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Übernahme LS EANCOM
     H**************************************************************************
     H*  Copyright 2004 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RE 26.11.2004 RIHA  Projekt 3164
     H*  -----------------------------------------------------------------------
     H*  Änderung: RE 13.01.2005 RIHA
     H*            diverse Korrekturen
     H*  Änderung: RE 19.01.2005 Standard
     H*            Integration AFPE Kunden-Auftrags-Art EDI
     H*  Änderung: GD 05.05.2005 Standard
     H*            Korrektur Zugriff auf TRRIHT Position FIRM 44 statt 42
     H*  Änderung: RE 08.05.2008 RIHA Projekt 5079
     H*  Änderung: RE 05.02.2009 BUSCH Projekt 5623
     H*            Integratrion Datei IFEP Interface Auftrag Position EDI
     H*  Änderung: RE 22.08.2012 DOMETIC PROJEKT 8529
     H*            Erweiterung DESADV für TROST
     H*  Änderung: RE 30.09.2014 DOMETIC PROJEKT 10863
     H*  Änderung: PH 03.11.201t DOMETIC Projekt 11683. Ermitteln Partner-Nr über
     H*            Programmaufruf MOICRG (unter MODWAO)
     H**************************************************************************
     F*
     F*
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
     D IFED          E DS                  INZ
     D KYIFED        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D AFLP          E DS                  INZ
     D KYAFLP        E DS                  INZ
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
     D AFVS          E DS                  INZ
     D KYAFVS        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D DESA          E DS                  INZ
     D KYDESA        E DS                  INZ
     D*
     D EDIN          E DS                  INZ
     D KYEDIN        E DS                  INZ
     D*
     D GBEA          E DS                  INZ
     D KYGBEA        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D KPIF          E DS                  INZ
     D KYKPIF        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
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
     D EXED18        E DS
     D RTED18        E DS
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTXST        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D/COPY QCPYSRC,INHOUSE96A
     D*
     D BYADRE        E DS                  EXTNAME(EXADRE) PREFIX(BY) INZ
     D DPADRE        E DS                  EXTNAME(EXADRE) PREFIX(DP) INZ
     D IVADRE        E DS                  EXTNAME(EXADRE) PREFIX(IV) INZ
     D MPADRE        E DS                  EXTNAME(EXADRE) PREFIX(MP) INZ
     D UDADRE        E DS                  EXTNAME(EXADRE) PREFIX(UD) INZ
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
     C                   PARM                    EXED18
     C                   PARM                    RTED18
     C*
     C                   EXSR      UEBED18
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
     C     EXED18LINR    IFNE      *BLANK
     C                   EXSR      VAFLK01
     C                   ELSE
     C                   EXSR      VAFLK11
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      UED18
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
     C                   MOVEL(P)  DAFIRM        KYKLFI
     C                   MOVEL(P)  DAFIRM        KYALFI
     C                   MOVEL(P)  DAFIRM        KYAPFI
     C                   MOVEL(P)  DAFIRM        KYASFI
     C                   MOVEL(P)  DAFIRM        KYAFEPFIRM
     C                   MOVEL(P)  DAFIRM        KYADFI
     C                   MOVEL(P)  DAFIRM        KYAAFI
     C                   MOVEL(P)  DAFIRM        KYAFPEFIRM
     C                   MOVEL(P)  DAFIRM        KYAVFI
     C                   MOVEL(P)  DAFIRM        KYLFFI
     C                   MOVEL(P)  DAFIRM        KYEDINFIRM
     C                   MOVEL(P)  'EA'          KYEDINEDIF
     C                   MOVEL(P)  'DESADV'      KYEDINNTYP
     C                   MOVE      DAFIRM        KYGBEAFIRM                     GBEA
     C                   MOVEL(P)  DAFIRM        KYKDFI
     C                   MOVEL(P)  DAFIRM        KYKPFI
     C                   MOVEL(P)  DAFIRM        KYSYTPFIRM
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYWRFI
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXED18                                                 ***
     C**************************************************************************
     C     UEBED18       BEGSR
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
     C                   MOVEL     *OFF          WKED18
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  NACHLAUF                                                          ***
     C**************************************************************************
     C     NACHLAUF      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* SCHLIEßEN CHDESA
     C*-------------------------------------------------------------------------
     C                   MOVEA     'LR      '    CHI
     C                   EXSR      CHDESA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTED18
     C                   MOVEL     *ZERO         RTED18FENR
     C     WKED18        IFEQ      *OFF
     C                   MOVEL     '0031'        RTED18FENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18KOPF     ERMITTELN KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED18KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C                   MOVEL(P)  KLKDNR        KYKZKD
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*-------------------------------------------------------------------------
     C                   IF        MODWAO = *ON
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   EVAL      %SUBST(EXTRNDDATE:01) = 'DESADV'
     C                   EVAL      %SUBST(EXTRNDDATE:07) = KZKDNR
     C                   EVAL      EXTRNDPGST = 'ERPRTN'
     C                   CALL      'MOICRG'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C                   EVAL      WKPRTNUM = %SUBST(RTTRNDDATE:01)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *HIVAL        KYDESAKYNR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHDESA
     C     CHI(5)        IFEQ      'J'
     C                   MOVE      DESAKYNR      DUN140
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18KOPF     UPDATE    KOPFDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED18KOPF     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18KMKO     UPDATE    KOPFDATEN PRO KOM-NUMMER                  ***
     C**************************************************************************
     C     UED18KMKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UNB'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*-------------------------------------------------------------------------
     C     EDINKZAK      IFEQ      *ON
     C                   EXSR      EUNB
     C                   MOVEL(P)  UNB           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  UNH           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  BGM           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  ALI           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  MOA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CUX'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECUX
     C                   MOVEL(P)  CUX           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  RFF           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  NAD           WKED18SATZ
     C                   EXSR      WED18
     C*
     C     WKED18SATZ    IFEQ      W1ED18SATZ
     C                   LEAVE
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
     C                   MOVEL(P)  RFF           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ENDIF
     C*
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '02'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     WKED          ED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TOD'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETOD
     C                   MOVEL(P)  TOD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COM'         WKEDINSGMT
     C                   MOVEL(P)  '04'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOM
     C                   MOVEL(P)  COM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TOD'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETOD
     C                   MOVEL(P)  TOD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '05'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TMD'         WKEDINSGMT
     C                   MOVEL(P)  '06'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETMD
     C                   MOVEL(P)  TMD           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  LOC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '07'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'EQD'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EEQD
     C                   MOVEL(P)  EQD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'SEL'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ESEL
     C                   MOVEL(P)  SEL           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'EQA'         WKEDINSGMT
     C                   MOVEL(P)  '08'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EEQA
     C                   MOVEL(P)  EQA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '09'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CPS'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECPS
     C                   MOVEL(P)  CPS           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18KMVS     ERMITTELN PACKSTÜCK PRO KOM-NUMMER                  ***
     C**************************************************************************
     C     EED18KMVS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18KMVS     UPDATE    PACKSTÜCK PRO KOM-NUMMER                  ***
     C**************************************************************************
     C     UED18KMVS     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CPS'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECPS
     C                   MOVEL(P)  CPS           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QVR'         WKEDINSGMT
     C                   MOVEL(P)  '10'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQVR
     C                   MOVEL(P)  QVR           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAC'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAC
     C                   MOVEL(P)  PAC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '11'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '12'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '12'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCI'         WKEDINSGMT
     C                   MOVEL(P)  '13'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCI
     C                   MOVEL(P)  PCI           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '13'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '13'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIR'         WKEDINSGMT
     C                   MOVEL(P)  '14'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIR
     C                   MOVEL(P)  GIR           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DLM'         WKEDINSGMT
     C                   MOVEL(P)  '15'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDLM
     C                   MOVEL(P)  DLM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'COD'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECOD
     C                   MOVEL(P)  COD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCD'         WKEDINSGMT
     C                   MOVEL(P)  '16'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCD
     C                   MOVEL(P)  PCD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18KMPO     UPDATE    POSITIONSDATEN PRO LOM-POSITION           ***
     C**************************************************************************
     C     UED18KMPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LIN'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELIN
     C                   MOVEL(P)  LIN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PIA'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPIA
     C                   MOVEL(P)  PIA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'IMD'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EIMD
     C                   MOVEL(P)  IMD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ALI'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EALI
     C                   MOVEL(P)  ALI           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIR'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIR
     C                   MOVEL(P)  GIR           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DLM'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDLM
     C                   MOVEL(P)  DLM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TDT'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETDT
     C                   MOVEL(P)  TDT           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TMD'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ETMD
     C                   MOVEL(P)  TMD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOA'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMOA
     C                   MOVEL(P)  MOA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PAC'         WKEDINSGMT
     C                   MOVEL(P)  '17'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPAC
     C                   MOVEL(P)  PAC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   Z-ADD     ED            WKED
     C                   EXSR      ERFF
     C                   MOVEL(P)  RFF           WKED18SATZ
     C                   EXSR      WED18
     C*
     C     WKED18SATZ    IFEQ      W1ED18SATZ
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*
     C                   MOVEL(P)  'RFF'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C                   Z-ADD     WKED          ED
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CTA'         WKEDINSGMT
     C                   MOVEL(P)  '18'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECTA
     C                   MOVEL(P)  CTA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*                  MOVEL(P)  'DTM'         WKEDINSGMT
     C*                  MOVEL(P)  '18'          WKEDINEDGR
     C*                  EXSR      EEDIN
     C*
     C*                  Z-ADD     1             ED
     C*    EDINKZAK      DOWEQ     *ON
     C*    EDINANZA      ANDGE     ED
     C*                  EXSR      EDTM
     C*                  MOVEL(P)  DTM           WKED18SATZ
     C*                  EXSR      WED18
     C*                  ADD       1             ED
     C*                  ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DGS'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDGS
     C                   MOVEL(P)  DGS           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FTX'         WKEDINSGMT
     C                   MOVEL(P)  '19'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EFTX
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'LOC'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ELOC
     C                   MOVEL(P)  LOC           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'NAD'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ENAD
     C                   MOVEL(P)  NAD           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DTM'         WKEDINSGMT
     C                   MOVEL(P)  '20'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDTM
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'SGP'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ESGP
     C                   MOVEL(P)  SGP           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '21'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'PCI'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EPCI
     C                   MOVEL(P)  PCI           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEA'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EMEA
     C                   MOVEL(P)  MEA           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'QTY'         WKEDINSGMT
     C                   MOVEL(P)  '22'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EQTY
     C                   MOVEL(P)  QTY           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DLM'         WKEDINSGMT
     C                   MOVEL(P)  '23'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EDLM
     C                   MOVEL(P)  DLM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'HAN'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EHAN
     C                   MOVEL(P)  HAN           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  FTX           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'GIN'         WKEDINSGMT
     C                   MOVEL(P)  '24'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      EGIN
     C                   MOVEL(P)  GIN           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  QVR           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  DTM           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18KMSC     UPDATE ENDEDATEN PRO KOM-NR                         ***
     C**************************************************************************
     C     UED18KMSC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'CNT'         WKEDINSGMT
     C                   MOVEL(P)  '00'          WKEDINEDGR
     C                   EXSR      EEDIN
     C*
     C                   Z-ADD     1             ED
     C     EDINKZAK      DOWEQ     *ON
     C     EDINANZA      ANDGE     ED
     C                   EXSR      ECNT
     C                   MOVEL(P)  CNT           WKED18SATZ
     C                   EXSR      WED18
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
     C                   MOVEL(P)  UNT           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18ENDE     ERMITTELN ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     EED18ENDE     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18ENDE     UPDATE    ENDEDATEN PRO ÜBERTRAGUNG                 ***
     C**************************************************************************
     C     UED18ENDE     BEGSR
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
     C                   MOVEL(P)  UNZ           WKED18SATZ
     C                   EXSR      WED18
     C                   ADD       1             ED
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFLK01       VERARBEITEN RECHNUNGSDATEI                          ***
     C**************************************************************************
     C     VAFLK01       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *ZERO         WKLIJJ
     C                   MOVEL(P)  *BLANK        WKLINR
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *ZERO         WKALZT
     C                   MOVEL(P)  *ZERO         WKAFZT
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKILKD
     C                   MOVEL(P)  *BLANK        WKILSP
     C*
     C                   MOVE      *ZERO         WKANZLPOSI
     C                   MOVE      *ZERO         WKANZLNACH
     C                   MOVE      *ZERO         WKANZLLINR
     C*
     C                   MOVEL     *OFF          WKED18KOPF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFLK
     C                   MOVEL(P)  DAFIRM        KYKLFI
     C                   MOVEL(P)  EXED18LIJJ    KYKLJH
     C                   MOVEL(P)  EXED18LINR    KYKLLI
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     KLFIRM        IFNE      KYKLFI
     C     KLLIJJ        ORNE      KYKLJH
     C     KLLINR        ORNE      KYKLLI
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     KLLDST        IFNE      *BLANK
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAEDIU        IFNE      DAJNKZ
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLAFAT        KYAFPEAFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPE
     C*
     C     AFPEDESL      IFNE      DAJNKZ
     C     AFPEDESL      ANDNE     *BLANK
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAAFED    IFEQ      *ON
     C                   MOVEL(P)  KLAFJJ        KYEKJH
     C                   MOVEL(P)  KLAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAIFED    IFEQ      *ON
     C                   MOVEL(P)  KLFIRM        KYIFEDFIRM
     C                   MOVEL(P)  KLAFJJ        KYIFEDAFJJ
     C                   MOVEL(P)  KLAFNR        KYIFEDAFNR
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHIFED
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKANZLLINR
     C*-------------------------------------------------------------------------
     C     WKLINR        IFEQ      *BLANK
     C                   EXSR      EED18KOPF
     C                   EXSR      UED18KOPF
     C                   MOVEL     *ON           WKED18KOPF
     C                   ENDIF
     C*----------------------------------------------------------
     C     KLLIJJ        IFNE      WKLIJJ
     C     KLLINR        ORNE      WKLINR
     C*
     C     WKLINR        IFNE      *BLANK
     C                   EXSR      EED18LISC
     C                   EXSR      UED18KMSC
     C                   ENDIF
     C*
     C                   MOVEL(P)  KLLIJJ        WKLIJJ
     C                   MOVEL(P)  KLLINR        WKLINR
     C*
     C                   MOVE      *ZERO         WKANZLPOSI
     C*
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *ZERO         WKALZT
     C                   MOVEL(P)  *ZERO         WKAFZT
     C                   MOVEL(P)  *BLANK        WKILNR
     C*
     C                   EXSR      EED18LIKO
     C                   EXSR      UED18KMKO
     C                   ENDIF
     C*----------------------------------------------------------
     C*                  EXSR      VAFVS
     C*----------------------------------------------------------
     C                   EXSR      VAFLP
     C*----------------------------------------------------------
     C                   EXSR      UAFLK
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKLINR        IFNE      *BLANK
     C                   EXSR      EED18LISC
     C                   EXSR      UED18KMSC
     C*
     C                   EXSR      EED18ENDE
     C                   EXSR      UED18ENDE
     C                   MOVEL(P)  *ON           WKED18
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFLK11       VERARBEITEN RECHNUNGSDATEI                          ***
     C**************************************************************************
     C     VAFLK11       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *ZERO         WKLIJJ
     C                   MOVEL(P)  *BLANK        WKLINR
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *ZERO         WKALZT
     C                   MOVEL(P)  *ZERO         WKAFZT
     C                   MOVEL(P)  *BLANK        WKILNR
     C                   MOVEL(P)  *BLANK        WKILKD
     C                   MOVEL(P)  *BLANK        WKILSP
     C*
     C                   MOVE      *ZERO         WKANZLPOSI
     C                   MOVE      *ZERO         WKANZLNACH
     C                   MOVE      *ZERO         WKANZLLINR
     C*
     C                   MOVEL     *OFF          WKED18KOPF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYAFLK
     C                   MOVEL(P)  DAFIRM        KYKLFI
     C                   MOVEL(P)  *BLANK        KYKLDS
     C                   MOVEL(P)  EXED18KDNR    KYKLKD
     C                   MOVEA     '11+     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     KLFIRM        IFNE      KYKLFI
     C     KLLDST        ORNE      KYKLDS
     C     KLKDNR        ORNE      KYKLKD
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXED18VSNR    IFNE      *BLANK
     C*
     C     KLVSNR        IFNE      EXED18VSNR
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXED18LINR    IFNE      *BLANK
     C*
     C     KLLIJJ        IFNE      EXED18LIJJ
     C     KLLINR        ORNE      EXED18LINR
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C     AAEDIU        IFNE      DAJNKZ
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLAFAT        KYAFPEAFAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPE
     C*
     C     AFPEDESL      IFNE      DAJNKZ
     C     AFPEDESL      ANDNE     *BLANK
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAAFED    IFEQ      *ON
     C                   MOVEL(P)  KLAFJJ        KYEKJH
     C                   MOVEL(P)  KLAFNR        KYEKAF
     C                   MOVEA     '10C     '    CHI
     C                   EXSR      CHAFED
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTRPAIFED    IFEQ      *ON
     C                   MOVEL(P)  KLFIRM        KYIFEDFIRM
     C                   MOVEL(P)  KLAFJJ        KYIFEDAFJJ
     C                   MOVEL(P)  KLAFNR        KYIFEDAFNR
     C                   MOVEA     '02C     '    CHI
     C                   EXSR      CHIFED
     C*
     C     CHI(05)       IFEQ      'N'
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFLK
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ADD       1             WKANZLLINR
     C*-------------------------------------------------------------------------
     C     WKLINR        IFEQ      *BLANK
     C                   EXSR      EED18KOPF
     C                   EXSR      UED18KOPF
     C                   MOVEL     *ON           WKED18KOPF
     C                   ENDIF
     C*----------------------------------------------------------
     C     KLLIJJ        IFNE      WKLIJJ
     C     KLLINR        ORNE      WKLINR
     C*
     C     WKLINR        IFNE      *BLANK
     C                   EXSR      EED18LISC
     C                   EXSR      UED18KMSC
     C                   ENDIF
     C*
     C                   MOVEL(P)  KLLIJJ        WKLIJJ
     C                   MOVEL(P)  KLLINR        WKLINR
     C*
     C                   MOVE      *ZERO         WKANZLPOSI
     C*
     C                   MOVEL(P)  *BLANK        WKORNR
     C                   MOVEL(P)  *BLANK        WKLIFN
     C                   MOVEL(P)  *ZERO         WKALZT
     C                   MOVEL(P)  *ZERO         WKAFZT
     C                   MOVEL(P)  *BLANK        WKILNR
     C*
     C                   EXSR      EED18LIKO
     C                   EXSR      UED18KMKO
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      VAFVS
     C*----------------------------------------------------------
     C                   EXSR      VAFLP
     C*----------------------------------------------------------
     C                   EXSR      UAFLK
     C*----------------------------------------------------------
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKLINR        IFNE      *BLANK
     C                   EXSR      EED18LISC
     C                   EXSR      UED18KMSC
     C*
     C                   EXSR      EED18ENDE
     C                   EXSR      UED18ENDE
     C                   MOVEL(P)  *ON           WKED18
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFLP         VERARBEITEN RECHNUNGS-POSIIONEN                     ***
     C**************************************************************************
     C     VAFLP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLLSDA        KYALLD
     C                   MOVEL(P)  KLLIJJ        KYALLJ
     C                   MOVEL(P)  KLLINR        KYALLI
     C                   MOVEL(P)  *ZERO         KYALLP
     C                   MOVEA     '16+     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     ALFIRM        IFNE      KYALFI
     C     ALLSDA        ORNE      KYALLD
     C     ALLIJJ        ORNE      KYALLJ
     C     ALLINR        ORNE      KYALLI
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      EED18LIPO
     C     WKKDNR        IFNE      '007006'
     C     WKKDNR        OREQ      '007006'
     C     TEPRGR        ANDGE     '100'
     C     TEPRGR        ANDLE     '899'
     C                   EXSR      UED18KMPO
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     '16R     '    CHI
     C                   EXSR      CHAFLP
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VAFVS         VERARBEITEN VERSAND-DATEN                           ***
     C**************************************************************************
     C     VAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKAFVSANZA
     C                   MOVEL     *BLANK        WKAFVSTENR
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLKMJJ        KYAVKJ
     C                   MOVEL     KLKMNR        KYAVKM
     C                   MOVEL     *BLANK        KYAVTE
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     AVFIRM        IFNE      KYAVFI
     C     AVKMJJ        ORNE      KYAVKJ
     C     AVKMNR        ORNE      KYAVKM
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKAFVSTENR    IFNE      AVTENR
     C     WKAFVSTENR    ANDNE     *BLANK
     C                   EXSR      EED18KMVS
     C                   EXSR      UED18KMVS
     C                   ENDIF
     C*-----------------------------------------------------------
     C                   ADD       AVANZA        WKAFVSANZA
     C                   MOVEL     AVTENR        WKAFVSTENR
     C*-----------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKAFVSTENR    IFNE      *BLANK
     C                   EXSR      EED18KMVS
     C                   EXSR      UED18KMVS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18LIKO     ERMITTELN KOPFDATEN PRO LS -NUMMER                  ***
     C**************************************************************************
     C     EED18LIKO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLAFJJ        KYAKJH
     C                   MOVEL(P)  KLAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLKDNR        WKKDNR
     C                   MOVEL(P)  KLVSNR        WKVSNR
     C*
     C     MODRIH        IFEQ      *ON
     C                   EXSR      TRRIHQ
     C                   ELSE
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C                   MOVEL(P)  KLKDNR        KYKZKD
     C                   ENDIF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHZKUN
     C*
     C                   MOVEL     KZEDIB        WKILKD
     C                   MOVEL     KZZNRN        WKZNRN
     C     WKZNRN        IFEQ      *BLANK
     C                   MOVEL     KZKDLS        WKZNRN
     C                   ENDIF
     C     WKZNRN        IFEQ      *BLANK
     C                   MOVEL     KZKDNR        WKZNRN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KLKMJJ        KYASJH
     C                   MOVEL     KLKMNR        KYASNR
     C                   MOVEL     'KMNR'        KYASKA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASSPED        KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   MOVEL(P)  LFEDIL        WKILSP
     C     WKILSP        IFEQ      *BLANK
     C                   MOVEL(P)  LFKNAM        WKILSP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLAFJJ        KYEKJH
     C                   MOVEL(P)  KLAFNR        KYEKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFED
     C*
     C                   MOVEL(P)  EKORNR        WKORNR
     C     EKORNR        IFEQ      *BLANK
     C                   MOVEL     AKREF1        WKORNR
     C                   ENDIF
     C                   MOVEL(P)  EKILNR        WKILNR
     C                   MOVEL(P)  EKAFZT        WKAFZT
     C                   MOVEL(P)  EKALZT        WKALZT
     C*-------------------------------------------------------------------------
     C                   EXSR      ERRFFAPI
     C                   MOVEL(P)  WKKDNR        WKAPIKDNR
     C     EXTTTEXT      IFNE      *BLANK
     C                   MOVEL(P)  EXTTTEXT      WKAPIKDNR
     C                   ENDIF
     C*
     C     WKLIFN        IFEQ      *BLANK
     C                   MOVEL(P)  KDLIFN        WKLIFN
     C                   ENDIF
     C     WKILNR        IFEQ      *BLANK
     C                   MOVEL(P)  KZEDIB        WKILNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYKZFI        KYWRFI
     C*
     C                   MOVEL     KYKZFI        KYTAFI                         ERMITTELN WERK
     C                   MOVEL(P)  'TRED18'      KYTATA                         PRO KUNDEN-NR
     C                   MOVEL(P)  'KDNR'        KYTATC
     C                   MOVEL(P)  AKKDNR        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        KYWRNR
     C                   ELSE
     C                   MOVEL     AKWKNR        KYWRNR
     C                   ENDIF
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWERK
     C*
     C                   MOVEL     DAFIRM        KYWRFI
     C                   MOVEL     DAFIRM        KYTAFI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KLLIJJ        KYALLJ
     C                   MOVEL(P)  KLLINR        KYALLI
     C                   MOVEL(P)  *ZERO         KYALLP
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHAFLP
     C*
     C     CHI(05)       IFEQ      'J'
     C     ALFIRM        ANDEQ     KYALFI
     C     ALLIJJ        ANDEQ     KYALLJ
     C     ALLINR        ANDEQ     KYALLI
     C                   MOVEL     ALLSDA        WKLFTE
     C                   ELSE
     C                   MOVEL     KLLSDA        WKLFTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLLINR        W1LINR
     C                   MOVEL     KLLSDA        WKLSDA
     C                   MOVEL     AKAFDA        WKAFDA
     C                   MOVEL     AKREF1        WKREF1
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AKAFJJ        KYADJH
     C                   MOVEL(P)  AKAFNR        KYADAF
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
     C                   Z-ADD     AKAFJJ        KYADJH
     C                   MOVEL(P)  AKAFNR        KYADAF
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
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18LIPO     ERMITTELN POSITIONSDATEN PRO KOM-POSITION           ***
     C**************************************************************************
     C     EED18LIPO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     ALTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     KDKDNR        KYKPKD
     C                   MOVEL     TETENR        KYKPTE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKPIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TETENR        KYGBEATENR
     C                   MOVEL(P)  '1'           KYGBEAGEBI
     C                   MOVE      *LOVAL        KYGBEAEANR
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHGBEA
     C*----------------------------------------------------------
     C     CHI(05)       IFEQ      'N'
     C     GBEAFIRM      ORNE      KYGBEAFIRM
     C     GBEATENR      ORNE      KYGBEATENR
     C     GBEAGEBI      ORNE      KYGBEAGEBI
     C*
     C     MODRIH        IFEQ      *ON
     C                   EVAL      KYGBEATENR= %SUBST(TETENR :1 :5)
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHGBEA
     C                   ENDIF
     C*
     C                   ENDIF
     C*----------------------------------------------------------
     C     CHI(05)       IFEQ      'J'
     C     GBEAFIRM      ANDEQ     KYGBEAFIRM
     C     GBEATENR      ANDEQ     KYGBEATENR
     C     GBEAGEBI      ANDEQ     KYGBEAGEBI
     C                   MOVEL     GBEAEANR      WKEANR
     C                   ELSE
     C                   MOVEL     TEEANR        WKEANR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ALAFJJ        KYAFEPAFJJ
     C                   MOVEL(P)  ALAFNR        KYAFEPAFNR
     C                   MOVEL(P)  ALAFPO        KYAFEPAFPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFEP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ALAFNR        WKAFNR
     C                   Z-ADD     ALAFPO        WKAFPOPOSI
     C                   Z-ADD     ALAFPO        WKAFEPPOSI
     C                   Z-ADD     ALLIPO        WKAFPO
     C     AFEPPOSI      IFNE      *ZERO
     C                   Z-ADD     AFEPPOSI      WKAFPO
     C                   Z-ADD     AFEPPOSI      WKAFEPPOSI
     C                   ENDIF
     C                   Z-ADD     ALGLMG        WKGLMG
     C                   MOVEL(P)  AFEPVPME      WKVPME
     C     AFEPVPMG      IFNE      *ZERO
     C     ALGLMG        DIV       AFEPVPMG      WKGLMG
     C                   ENDIF
     C                   MOVEL     ALTENR        WKTENR
     C                   MOVEL     ALTBZ1        WKTBZ1
     C                   MOVEL     ALTBZ2        WKTBZ2
     C                   MOVEL     AFEPIDEN      WKAFEPIDEN
     C     WKAFEPIDEN    IFEQ      *BLANK
     C                   MOVEL     KPIDEN        WKAFEPIDEN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     MODRIH        IFEQ      *ON
     C                   EXSR      TRRIHT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MEINTRDEDI'  KYSYTPTART
     C                   MOVEL(P)  ALMEIN        KYSYTPTCDE
     C                   Z-ADD     *ZERO         KYSYTPTFLG
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHSYTP
     C     SYTPTTXT      IFNE      *BLANK
     C                   MOVEL     SYTPTTXT      WKMEIN
     C                   ENDIF
     C     AFEPMEIN      IFNE      *BLANK
     C                   MOVEL     AFEPMEIN      WKMEIN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKDPDN
     C*
     C                   MOVEL     KLKMJJ        KYAVKJ
     C                   MOVEL     KLKMNR        KYAVKM
     C                   MOVEL     *BLANK        KYAVTE
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHAFVS
     C*
     C     CHI(5)        IFEQ      'J'
     C     AVFIRM        ANDEQ     KYAVFI
     C     AVKMJJ        ANDEQ     KYAVKJ
     C     AVKMNR        ANDEQ     KYAVKM
     C                   MOVEL     AVDPDN        WKDPDN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  EED18LISC     ERMITTELN ENDEDATEN PRO KOM-NR                      ***
     C**************************************************************************
     C     EED18LISC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKANZLNACH
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
     C                   MOVEL     ALI           W1ED18SATZ
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
     C                   MOVEL     BGM           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     '351'         BGM1001
     C                   MOVEL     W1LINR        BGM1004
     C*
     C                   MOVEL     '9'           BGM1225
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
     C                   MOVEL     CNT           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '2'           CNT6069
     C                   Z-ADD     WKANZLLINR    CNT6066
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT COD
     C**************************************************************************
     C     ECOD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   COD
     C                   MOVEL     COD           W1ED18SATZ
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
     C                   MOVEL     COM           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT CPS
     C**************************************************************************
     C     ECPS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   CPS
     C                   MOVEL     CPS           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     '1  '         CPS7164
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
     C                   MOVEL     CTA           W1ED18SATZ
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
     C                   MOVEL     CUX           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT DGS
     C**************************************************************************
     C     EDGS          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DGS
     C                   MOVEL     DGS           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT DLM
     C**************************************************************************
     C     EDLM          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DLM
     C                   MOVEL     DLM           W1ED18SATZ
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
     C                   MOVEL     DTM           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '00'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL     '137'         DTM2005
     C                   MOVEL     WKLFTE        DUC012
     C                   MOVE      WKALZT        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '203'         DTM2379
     C*
     C     MODRIH        IFEQ      *ON
     C     WKZNRN        ANDEQ     '80270140'
     C     MODWAO        OREQ      *ON
     C                   MOVEL     '137'         DTM2005
     C                   MOVEL(P)  WKLFTE        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '102'         DTM2379
     C                   ENDIF
     C*
     C     ED            WHENEQ    2
     C                   MOVEL     '17 '         DTM2005
     C                   MOVEL     WKLSDA        DUC012
     C                   MOVE      WKAFZT        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '203'         DTM2379
     C*
     C     MODRIH        IFEQ      *ON
     C     WKZNRN        ANDEQ     '80270140'
     C     MODWAO        OREQ      *ON
     C                   MOVEL     '17 '         DTM2005
     C                   MOVEL(P)  WKLSDA        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '102'         DTM2379
     C                   ENDIF
     C*
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '01'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL     WKAFDA        DUC012
     C                   MOVE      WKAFZT        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL(P)  '203'         DTM2379
     C*
     C     MODRIH        IFEQ      *ON
     C     WKZNRN        ANDEQ     '80270140'
     C     MODWAO        OREQ      *ON
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '102'         DTM2379
     C                   ENDIF
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*
     C     WKEDINEDGR    WHENEQ    '18'
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '171'         DTM2005
     C                   MOVEL(P)  WKAFDA        DUC012
     C                   MOVEL     DUC012        DTM2380
     C                   MOVEL     '102'         DTM2379
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C*
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT EQA
     C**************************************************************************
     C     EEQA          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EQA
     C                   MOVEL     EQA           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL     EQD           W1ED18SATZ
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
     C                   MOVEL     FTX           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'ACB'         FTX4451
     C                   MOVEL(P)  WKREF1        FTX4440#1
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
     C                   MOVEL     GIN           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     'BJ'          GIN7405
     C                   MOVEL     WKDPDN        GIN7402#1
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
     C                   MOVEL     GIR           W1ED18SATZ
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
     C                   MOVEL     HAN           W1ED18SATZ
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
     C                   MOVEL     IMD           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTBZ1        IMD7008#1
     C                   MOVEL     WKTBZ2        IMD7008#2
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
     C                   MOVEL     LIN           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKAFPO        LIN1082#1
     C*
     C     WKEANR        IFNE      *BLANK
     C                   MOVEL     WKEANR        LIN7140
     C                   MOVE      'EN '         LIN7143
     C                   ELSE
     C                   MOVEL     WKTENR        LIN7140
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
     C                   CLEAR                   LOC
     C                   MOVEL     LOC           W1ED18SATZ
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
     C                   MOVEL     MEA           W1ED18SATZ
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
     C                   MOVEL     MOA           W1ED18SATZ
     C*-------------------------------------------------------------------------
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
     C                   MOVEL     NAD           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  'BY '         NAD3035
     C                   MOVEL(P)  WKILNR        NAD3039
     C*
     C                   MOVEL(P)  BYEXADNAM1    NAD3036#1
     C                   MOVEL(P)  BYEXADNAM2    NAD3036#2
     C                   MOVEL(P)  BYEXADSTRA    NAD3042#1
     C                   MOVEL(P)  BYEXADWORT    NAD3164
     C                   MOVEL(P)  BYEXADPOLZ    NAD3251
     C                   MOVEL(P)  BYEXADPOLD    NAD3207
     C     ED            WHENEQ    2
     C                   MOVEL(P)  'DP '         NAD3035
     C     WKKDNR        IFNE      '007006'
     C                   MOVEL(P)  WKILKD        NAD3039
     C                   ENDIF
     C*
     C                   MOVEL(P)  DPEXADNAM1    NAD3036#1
     C                   MOVEL(P)  DPEXADNAM2    NAD3036#2
     C                   MOVEL(P)  DPEXADSTRA    NAD3042#1
     C                   MOVEL(P)  DPEXADWORT    NAD3164
     C                   MOVEL(P)  DPEXADPOLZ    NAD3251
     C                   MOVEL(P)  DPEXADPOLD    NAD3207
     C     ED            WHENEQ    3
     C                   MOVEL(P)  'SU '         NAD3035
     C                   MOVEL(P)  WREDIL        NAD3039
     C                   MOVEL(P)  WRNAM1        NAD3036#1
     C                   MOVEL(P)  WRNAM2        NAD3036#2
     C                   MOVEL(P)  WRSTRA        NAD3042#1
     C                   MOVEL(P)  WRWORT        NAD3164
     C                   MOVEL(P)  WRPOLZ        NAD3251
     C                   MOVEL(P)  WRPOLD        NAD3207
     C     KZEDIF        IFEQ      'EE'
     C                   MOVEL(P)  WKLIFN        NAD3039
     C                   ENDIF
     C     ED            WHENEQ    4
     C                   MOVEL(P)  'SF '         NAD3035
     C     ED            WHENEQ    5
     C                   MOVEL(P)  'FW '         NAD3035
     C                   MOVEL(P)  WKILSP        NAD3039
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
     C                   MOVEL     PAC           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '11'
     C                   Z-ADD     WKAFVSANZA    PAC7224
     C                   MOVEL     WKAFVSTENR    PAC7065
     C                   OTHER
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
     C                   MOVEL     PCD           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL     PCI           W1ED18SATZ
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
     C                   MOVEL     PIA           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  WKTENR        PIA7140#1
     C                   MOVEL(P)  'SA '         PIA7143#1
     C     ED            WHENEQ    2
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  WKAFEPIDEN    PIA7140#1
     C                   MOVEL(P)  'BP '         PIA7143#1
     C     ED            WHENEQ    3
     C                   MOVEL(P)  '  1'         PIA4347
     C                   MOVEL(P)  WKEANR        PIA7140#1
     C                   MOVEL(P)  'EN '         PIA7143#1
     C     ED            WHENEQ    4
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
     C                   MOVEL     QTY           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     '12 '         QTY6063
     C                   Z-ADD     WKGLMG        DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL     WKMEIN        QTY6411
     C                   SELECT
     C     ED            WHENEQ    1
     C                   MOVEL(P)  '12'          QTY6063
     C                   Z-ADD     WKGLMG        DUN153
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
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
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
     C                   MOVEL     QVR           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     '12 '         QTY6063
     C                   Z-ADD     WKGLMG        DUN153
     C                   Z-ADD     DUN150        QTY6060
     C                   MOVEL     WKMEIN        QTY6411
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
     C                   MOVEL     RFF           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKEDINEDGR    WHENEQ    '01'
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C     WKEDINEDGR    WHENEQ    '03'
     C                   SELECT
     C     ED            WHENEQ    1                                            BY
     C     WKED          ANDEQ     1
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKAPIKDNR     RFF1154
     C     ED            WHENEQ    1                                            DP
     C     WKED          ANDEQ     2
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKAPIKDNR     RFF1154
     C     ED            WHENEQ    1                                            SU
     C     WKED          ANDEQ     3
     C                   MOVEL(P)  'API'         RFF1153
     C                   MOVEL(P)  WKLIFN        RFF1154
     C                   OTHER
     C                   Z-ADD     EDINANZA      ED
     C                   ENDSL
     C     WKEDINEDGR    WHENEQ    '18'
     C                   SELECT
     C     ED            WHENEQ    1                                            SU
     C                   MOVEL(P)  'VN '         RFF1153
     C                   MOVEL(P)  WKAFNR        RFF1154
     C                   MOVEL(P)  WKAFPOPOSI    RFF1156
     C     ED            WHENEQ    2                                            BY
     C                   MOVEL(P)  'ON '         RFF1153
     C                   MOVEL(P)  WKORNR        RFF1154
     C                   MOVEL(P)  WKAFEPPOSI    RFF1156
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
     C***  SEGMENT SEL
     C**************************************************************************
     C     ESEL          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SEL
     C                   MOVEL     SEL           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT SGP
     C**************************************************************************
     C     ESGP          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SGP
     C                   MOVEL     SGP           W1ED18SATZ
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
     C                   MOVEL     TDT           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EDINANZA      ED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SEGMENT TMD
     C**************************************************************************
     C     ETMD          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   TMD
     C                   MOVEL     TMD           W1ED18SATZ
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
     C                   MOVEL     TOD           W1ED18SATZ
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
     C                   MOVEL     UNB           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     'UNOA    '    UNB0001
     C                   Z-ADD     1             UNB0002
     C*
     C                   MOVEL     WREDIL        UNB0004
     C     KZEDIF        IFEQ      'EE'
     C                   MOVEL     WRUNBN        UNB0004
     C                   ENDIF
     C*
     C                   MOVEL     14            UNB0007#1
     C                   MOVEL     14            UNB0007#2
     C                   MOVEL     WKILKD        UNB0010
     C                   MOVE      WKTDAT        DUN080
     C                   MOVE      DUC008        UNB0017
     C                   TIME                    DUN060
     C                   MOVE      DUC006        UNB0019
     C                   MOVE      *ZERO         UNB0020
     C                   MOVEL     'EANCOM'      UNB0032
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
     C                   MOVEL     UNH           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKILKD        UNH0062                         REF-NUMBER
     C*
     C                   MOVEL     'DESADV'      UNH0065                         TYPE IDENT
     C                   MOVEL     'D'           UNH0052                         TYPE VERSION
     C                   MOVEL     '93A'         UNH0054                         TYPE RELEASE
     C                   MOVEL     'UN      '    UNH0051                         CONTROLING AGENT
     C                   MOVEL     'EAN004  '    UNH0057                         ASS ASSIGNED CODE
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
     C                   MOVEL     UNT           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKANZLPOSI    UNT0074                         KEYELEMENTE
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
     C                   MOVEL     UNZ           W1ED18SATZ
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKANZLNACH    UNZ0036
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
     C***  WED18         SCHREIBEN    ED18                                   ***
     C**************************************************************************
     C     WED18         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ED            DUN010
     C                   EVAL      W1EDINUKEY=%TRIM(WKEDINUKEY)+DUC001
     C*-------------------------------------------------------------------------
     C     WKED18SATZ    IFNE      W1ED18SATZ
     C     DUN140        ADD       1             DUN140
     C*
     C                   CLEAR                   DESA
     C                   MOVEL(P)  DUN140        DESAKYNR
     C                   MOVEL(P)  '0'           DESAFLGS
     C                   MOVEL(P)  '8'           DESASTA1
     C                   MOVEL(P)  W1EDINUKEY    DESASAAR
     C                   EVAL      DESASATZ=WKED18SATZ
     C*
     C                   MOVEL(P)  DUN140        KYDESAKYNR
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHDESA
     C*
     C                   ADD       1             WKANZLPOSI
     C                   ADD       1             WKANZLNACH
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UED18         UDATE STATUS ED18                                   ***
     C**************************************************************************
     C     UED18         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ UPDATE DESA SET DESASTA1 = ' '
     C+ WHERE DESASTA1 = '8'
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UAFLK         UDATE STATUS 50                                     ***
     C**************************************************************************
     C     UAFLK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLLIJJ        KYKLJH
     C                   MOVEL     KLLINR        KYKLLI
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHAFLK
     C*----------------------------------------------------------
     C                   MOVEL     '90'          KLLDST
     C*
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  TRRIHQ KUNDEN-NR                                                  ***
     C**************************************************************************
     C     TRRIHQ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  'ERRIHQ'      EXTRNDPGST
     C                   MOVEA(P)  WKKDNR        KOM(01)
     C                   MOVEA(P)  WKVSNR        KOM(11)
     C                   MOVEA(P)  KOM           EXTRNDKEYB
     C*
     C                   CALL      'TRRIHQ'                             99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  RTTRNDDATE    KOM(01)
     C                   MOVEA(P)  KOM(01)       DUC002
     C*
     C     DUC002        IFNE      *BLANK
     C                   MOVEA(P)  KOM(01)       KYKZFI
     C                   MOVEA(P)  KOM(03)       KYKZKD
     C                   ELSE
     C                   MOVEL(P)  DAFIRM        KYKZFI
     C                   MOVEL(P)  WKKDNR        KYKZKD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  TRRIHT EAN-NR                                                     ***
     C**************************************************************************
     C     TRRIHT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  'EREANR'      EXTRNDPGST
     C                   MOVEA(P)  WRWKNR        KOM(01)
     C                   MOVEA(P)  WKZNRN        KOM(04)
     C                   MOVEA(P)  WKTENR        KOM(14)
     C                   MOVEA(P)  WRFIRM        KOM(44)
     C                   MOVEA(P)  KOM           EXTRNDKEYB
     C*
     C                   CALL      'TRRIHT'
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  RTTRNDDATE    KOM(01)
     C                   MOVEA(P)  KOM(01)       WKEANR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRAUFRTX50   VERZWEIGEN IN TEXTVERWALTUNG                      ***
     C**************************************************************************
     C     ERRFFAPI      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTXST
     C                   MOVEL     'TEXT'        EXTTPGCD
     C                   MOVEL     'TRTX02'      EXTTTCDE
     C                   MOVEL     KLKDNR        EXTTKDLI
     C                   MOVEL     'TRED18'      EXTTPROG
     C                   MOVEL     DASPCD        EXTTSPCD
     C                   MOVEL     'RFFAPI'      EXTTUCDE
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        #CUEBE
     C                   MOVEL     '5     '      #CPGST
     C                   EXSR      TRTX50
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL(P)  'MODRIH'      KYTATC                         FA.RIHA
     C                   MOVEL(P)  'MODRIH'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODRIH            1
     C     MODRIH        IFNE      *ON
     C                   MOVE      *OFF          MODRIH
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERWEITERUNG
     C                   MOVEL(P)  'MODWAO'      KYTATC                         FA.WAECO
     C                   MOVEL(P)  'MODWAO'      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        MODWAO            1
     C     MODWAO        IFNE      *ON
     C                   MOVE      *OFF          MODWAO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRED18'      KYTATA                         PRÜFEN AFED
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'AFED'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAAFED        1
     C     WKTRPAAFED    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAAFED
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRED18'      KYTATA                         PRÜFEN IFED
     C                   MOVEL(P)  'PRUEFEN'     KYTATC
     C                   MOVEL(P)  'IFED'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAIFED        1
     C     WKTRPAIFED    IFNE      *ON
     C                   MOVE      *OFF          WKTRPAIFED
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKED18
     C     *LIKE         DEFINE    WKC001        WKED18KOPF
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
     C     *LIKE         DEFINE    KLLIJJ        WKLIJJ
     C     *LIKE         DEFINE    KLLINR        WKLINR
     C     *LIKE         DEFINE    KLKDNR        WKKDNR
     C     *LIKE         DEFINE    KLKDNR        WKAPIKDNR
     C     *LIKE         DEFINE    KLVSNR        WKVSNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EDINSGMT      WKEDINSGMT
     C     *LIKE         DEFINE    DUC002        WKEDINEDGR
     C     *LIKE         DEFINE    EDINUKEY      WKEDINUKEY
     C     *LIKE         DEFINE    EDINUKEY      W1EDINUKEY
     C     *LIKE         DEFINE    DESASATZ      WKED18SATZ
     C     *LIKE         DEFINE    DESASATZ      W1ED18SATZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN140        WKANZLPOSI
     C     *LIKE         DEFINE    DUN140        WKANZLNACH
     C     *LIKE         DEFINE    DUN140        WKANZLLINR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KZZNRN        WKZNRN
     C     *LIKE         DEFINE    EKORNR        WKORNR
     C     *LIKE         DEFINE    EKILNR        WKILNR
     C     *LIKE         DEFINE    KDLIFN        WKLIFN
     C     *LIKE         DEFINE    GBEAEANR      WKEANR
     C     *LIKE         DEFINE    KZEDIB        WKILKD
     C     *LIKE         DEFINE    KZEDIB        WKILSP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    APAFPO        WKAFPO
     C     *LIKE         DEFINE    APBSMG        WKGLMG
     C     *LIKE         DEFINE    APLFTE        WKLFTE
     C     *LIKE         DEFINE    APLFTE        WKLSDA
     C     *LIKE         DEFINE    APTENR        WKTENR
     C     *LIKE         DEFINE    APTBZ1        WKTBZ1
     C     *LIKE         DEFINE    APTBZ2        WKTBZ2
     C     *LIKE         DEFINE    AKREF1        WKREF1
     C     *LIKE         DEFINE    AKAFDA        WKAFDA
     C     *LIKE         DEFINE    AKAFNR        W1LINR
     C     *LIKE         DEFINE    DUC003        WKMEIN
     C     *LIKE         DEFINE    DUC003        WKVPME
     C     *LIKE         DEFINE    EKALZT        WKALZT
     C     *LIKE         DEFINE    EKAFZT        WKAFZT
     C     *LIKE         DEFINE    AFEPIDEN      WKAFEPIDEN
     C     *LIKE         DEFINE    APAFPO        WKAFEPPOSI
     C     *LIKE         DEFINE    APAFPO        WKAFPOPOSI
     C     *LIKE         DEFINE    APAFPO        WKAFPOPOSI
     C     *LIKE         DEFINE    AKAFNR        WKAFNR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AVTENR        WKAFVSTENR
     C     *LIKE         DEFINE    AVANZA        WKAFVSANZA
     C     *LIKE         DEFINE    AVDPDN        WKDPDN
     C     *LIKE         DEFINE    ED            WKED
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHIFED
     C/COPY QCPYSRC,CHAFED
     C/COPY QCPYSRC,CHAFAD
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFEP
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPE
     C/COPY QCPYSRC,CHAFVS
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHDESA
     C/COPY QCPYSRC,CHEDIN
     C/COPY QCPYSRC,CHGBEA
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHKPIF
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,CHZKUN
     C/COPY QCPYSRC,TRTX50
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
