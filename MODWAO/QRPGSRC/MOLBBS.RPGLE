     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2014 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 14.07.2014 für Kunde WAECO - LBBSLOCK- Update / Prüfung
     H*  --------------------------------------------------------------
     H*  Änderung: SZ 26.04.2016 kundenspezifische Prüfungen aus TRLBBS in
     H*            dieses Programm verschoben.
     H*  Änderung: SZ 25.11.2021 Projekt 17015, Lager 097 und 099 zusätzlich
     H*  Änderung: SZ 30.11.2022 Projekt 17015, Lager 091 zusätzlich
     H*  Änderung: SZ 07.09.2023 Projekt 230445 Dometic, Lagernummer 093
     H*
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D EXLBBSLOCK      DS
     D  EXLOCKLOCK             1      1
     D  EXLOCKPROG            11     21
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***     R E C H E N B E S T I M M U N G E N                            ***
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
     C**************************************************************************
     C***                                                                    ***
     C**************************************************************************
     C                   SELECT
     C     PCPGST        WHENEQ    'LOCK  '
     C     *DTAARA       DEFINE                  EXLBBSLOCK
     C                   IN        EXLBBSLOCK
     C                   MOVE      DAPROG        EXLOCKPROG
     C                   MOVE      '1'           EXLOCKLOCK
     C                   OUT       EXLBBSLOCK
     C*
     C     PCPGST        WHENEQ    'UNLOCK'
     C                   IN        EXLBBSLOCK
     C                   MOVE      DAPROG        EXLOCKPROG
     C                   MOVE      '0'           EXLOCKLOCK
     C                   OUT       EXLBBSLOCK
     C*
     C     PCPGST        WHENEQ    'PRLOCK'
     C                   IN        EXLBBSLOCK
     C*
     C                   IF        EXLOCKLOCK ='0'
     C                   MOVEL     *ZERO         RTTRNDFENR
     C                   ELSE
     C                   MOVEL     '0836'        RTTRNDFENR
     C                   MOVEL     EXLOCKPROG    RTTRNDPA03
     C                   ENDIF
     C     PCPGST        WHENEQ    'SPERRE'
     C                   EXSR      SPERRE
     C                   ENDSL
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
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
     C                   MOVEA     KOM(01)       EXLBBSLANR        3
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
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
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C**************************************************************************
     C     SPERRE        BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      LBLBLANR = %SUBST(EXTRNDDATE:1:3)
     C                   EVAL      LBLBLORT = %SUBST(EXTRNDDATE:4:8)
     C                   EVAL      LBLBLSTC = %SUBST(EXTRNDDATE:12:3)
     C                   EVAL      LBLBSPKZ = %SUBST(EXTRNDDATE:15:1)
     C                   EVAL      LBLBSPGR = %SUBST(EXTRNDDATE:16:2)
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      LBLBLSTC = '957'                             Sperren
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = %SUBST(LBLBLANR:2:2)
     C                   WHEN      LBLBLSTC = '958'                             Entsperren
     C                   EVAL      LBLBSPKZ = *BLANK
     C                   EVAL      LBLBSPGR = *BLANK
     C                   WHEN      LBLBLANR = '091'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '91'
     C                   WHEN      LBLBLANR = '093'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '93'
     C                   WHEN      LBLBLANR = '094'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '94'
     C                   WHEN      LBLBLANR = '095'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '95'
     C                   WHEN      LBLBLANR = '096'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '96'
     C                   WHEN      LBLBLANR = '097'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '97'
     C                   WHEN      LBLBLANR = '099'
     C                   EVAL      LBLBSPKZ = DAJNKZ
     C                   EVAL      LBLBSPGR = '99'
     C                   WHEN      LBLBLANR = '001'
     C                   EVAL      LBLBSPKZ = *BLANK
     C                   EVAL      LBLBSPGR = *BLANK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      RTTRNDDATE = LBLBLANR + LBLBLORT + LBLBLSTC +
     C                             LBLBSPKZ + LBLBSPGR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKTRPA
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
