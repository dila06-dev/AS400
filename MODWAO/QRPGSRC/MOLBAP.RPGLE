     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen bei Rückmledung AFPO/LBAP
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 22.06.2010 WAECO    Projekt 6231
     H*  --------------------------------------------------------------
     H*
     F**************************************************************************
     F*/
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*  für die Datei LBAP/AFPO bei der Rückledung
     F*/
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D LAN             S                   DIM(100) LIKE(LBBSLANR)              FERTIGWAREN LÄGER
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D LBBS          E DS                  INZ
     D KYLBBS        E DS                  INZ
     D*
     D LBLZ          E DS                  INZ
     D KYLBLZ        E DS                  INZ
     D*
     D LBPB          E DS                  INZ
     D KYLBPB        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
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
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D/COPY QCPYSRC,EXUX01
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
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
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'ERLORT'
     C                   EXSR      ERMLAN
     C                   EXSR      ERLORT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PRLBRS'
     C                   EXSR      PRLBRS
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UXLBAP'                                     ERMITTELN
     C                   EXSR      UXLBAP                                       BENUTZERINDEX
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
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM                     LBAP
     C                   MOVEL     DAFIRM        KYLBBSFIRM                     LBBS
     C                   MOVEL     DAFIRM        KYLBPBFIRM                     LBPB
     C                   MOVEL     DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL     DAFIRM        KYLZFI                         LBLZ
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYTPFI                         TRTP
     C                   MOVEL     DASPCD        KYTPSP
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
     C                   MOVEA(P)  KOM(01)       KYLBAPDANA
     C                   MOVEA     KOM(11)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        KYLBAPJAHR
     C                   MOVEA(P)  KOM(15)       KYLBAPNMKR
     C*
     C                   MOVEA(P)  KOM(21)       DUC005
     C                   TESTN                   DUC005               99
     C     *IN99         IFEQ      *ON
     C                   Z-ADD     DUN050        KYLBAPPOSI
     C                   ELSE
     C                   Z-ADD     *ZERO         KYLBAPPOSI
     C                   ENDIF
     C*
     C*
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
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERLORT     PRÜFEN IDENT-NR                                     ***
     C**************************************************************************
     C     ERLORT        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYLBAPDANA    OFLBAPDANA
     C                   MOVEL(P)  KYLBAPJAHR    OFLBAPJAHR
     C                   MOVEL(P)  KYLBAPNMKR    OFLBAPNMKR
     C                   MOVEL(P)  KYLBAPPOSI    OFLBAPPOSI
     C     KYLBAPPOSI    IFEQ      *ZERO
     C                   MOVE      *HIVAL        OFLBAPPOSI
     C                   ENDIF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBAP
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBAPFIRM      IFGT      KYLBAPFIRM
     C     LBAPDANA      ORGT      OFLBAPDANA
     C     LBAPJAHR      ORGT      OFLBAPJAHR
     C     LBAPNMKR      ORGT      OFLBAPNMKR
     C     LBAPPOSI      ORGT      OFLBAPPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBAPTENR      KYTENR                         PRÜFEN
     C                   MOVEL     *BLANK        KYTEEZ                         IDENTNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C     1             DO        100           I2
     C*
     C                   IF        LAN(I2)>*BLANK
     C                   MOVE      LAN(I2)       TELANR
     C                   EXSR      ELBBS02
     C                   IF        WKLBPBLPBE<>*BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   IF        WKLBPBLPBE<>*BLANK
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHLBAP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKFENR        RTTRNDFENR
     C                   MOVEL     W$PA03        RTTRNDPA03
     C                   MOVEL     W$PA05        RTTRNDPA05
     C                   MOVEL     W$PA06        RTTRNDPA06
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ELBBS02    ERMITTELN LAGERBESTAND PRO TENR                     ***
     C**************************************************************************
     C     ELBBS02       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYLBBS
     C                   MOVE      DAFIRM        KYLBBSFIRM
     C     WKSTMF        IFNE      *BLANK
     C                   MOVEL     WKSTMF        KYLBBSFIRM                     LBBS
     C                   ENDIF
     C                   MOVEL     TETENR        KYLBBSTENR
     C                   MOVEL     TELANR        KYLBBSLANR
     C*-------------------------------------------------------------------------
     C                   MOVEA     '02+     '    CHI                            LESEN
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBBSFIRM      IFNE      KYLBBSFIRM                                   VERGLEICHEN
     C     LBBSTENR      ORNE      KYLBBSTENR                                   OBERGRENZE
     C     LBBSLANR      ORNE      KYLBBSLANR                                   OBERGRENZE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBBSLANR      KYLBPBLANR
     C                   MOVEL(P)  LBBSLORT      KYLBPBLORT
     C                   MOVEL(P)  *LOVAL        KYLBPBLPBE
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPB
     C     CHI(5)        IFEQ      'J'
     C     LBPBFIRM      ANDEQ     KYLBPBFIRM
     C     LBPBLANR      ANDEQ     KYLBPBLANR
     C     LBPBLORT      ANDEQ     KYLBPBLORT
     C                   MOVEL     LBPBLPBE      WKLBPBLPBE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI                            LESEN
     C                   EXSR      CHLBBS                                       NÄCHSTER SATZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ERMLAN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTRPALGBE    KYLZLB
     C                   MOVEL     *LOVAL        KYLZRF
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBLZ
     C*--------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     LZFIRM        ANDEQ     KYLZFI
     C     LZLGBE        ANDEQ     KYLZLB
     C     I2            ANDLT     100
     C*--------------------------------------------------------
     C                   ADD       1             I2
     C                   MOVEL     LZLANR        LAN(I2)
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHLBLZ
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen LBRS                                                       ***
     C**************************************************************************
     C     PRLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDATE    LBAP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DSRSMG
     C                   Z-ADD     *ZERO         DSRSMG9911
     C                   Z-ADD     *ZERO         WKTMST9911
     C                   EXSR      E2LBRS
     C*-------------------------------------------------------------------------
     C     DSRSMG        IFNE      DSRSMG9911
     C     DSRSMG9911    ANDNE     *ZERO
     C                   MOVEL(P)  '001'         DSLANR
     C                   MOVEL(P)  '9911'        DSLORT
     C                   EXSR      TRLBB2
     C                   Z-ADD     WKLAGB        WKLAGB9911
     C                   Z-ADD     WKRESL        WKRESL9911                     LAGERRESERVERIERUNG
     C*
     C                   MOVEL(P)  '001'         DSLANR
     C                   MOVE      *BLANK        DSLORT
     C                   EXSR      TRLBB2
     C*
     C                   SELECT
     C                   WHEN      (WKLAGB-WKLAGB9911-WKRESL)>DSRSMG9911
     C* 9911 ganz reservieren
     C                   Z-ADD     WKTMST9911    KYLBRSTMST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C                   EVAL      LBRSRSMG=LBRSRSMG+WKLAGB9911-WKRESL9911
     C                   SELECT
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDSL
     C*
     C                   MOVE      *BLANK        DSLORT
     C                   Z-ADD     DSRSMG9911    DSBWMG
     C                   EXSR      TRLBRS
     C*
     C                   Z-ADD     WKTMST9911    KYLBRSTMST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C                   SELECT
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDSL
     C*
     C                   WHEN      (WKLAGB9911-WKRESL9911)>(DSRSMG-DSRSMG9911)
     C                   EXSR      D2LBRS
     C                   MOVEL(P)  '9911'        DSLORT
     C                   Z-ADD     LBAPBWMG      DSBWMG
     C                   EXSR      TRLBRS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PLATZBESTAND FÜR IDENTNUMMER                            ***
     C**************************************************************************
     C     TRLBB2        BEGSR
     C*
     C                   Z-ADD     *ZERO         WKLAGB
     C                   Z-ADD     *ZERO         WKRESL                         LAGERRESERVERIERUNG
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        KOM
     C                   MOVEL     *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVEL     *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVEL     *ON           KOM(3)                         ERM.LAGERRESERV.
     C                   MOVEL     *OFF          KOM(4)                         ERM.DIST RESERV.
     C*
     C                   MOVEA     LBAPTENR      KOM(10)                        IDENTNUMMER
     C     WKTRPABSLA    IFEQ      *ON
     C                   MOVEA     LBAPLANR      KOM(102)                       BESTANDSLAGER
     C                   ELSE
     C                   MOVEA     LBAPLANR      KOM(25)
     C                   ENDIF
     C*
     C                   MOVEA     DSLORT        KOM(63)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD(H)  DUN134        WKLAGB
     C                   MOVEA     KOM(92)       DUC013
     C                   Z-ADD     DUN134        WKRESL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** ERMITTLEN LBRS-SATZ                                                ***
     C**************************************************************************
     C     E2LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      LBAPDANA      KYLBRSDANA                     ERSTER SATZ
     C                   MOVE      LBAPJAHR      KYLBRSJAHR
     C                   MOVE      LBAPNMKR      KYLBRSNMKR
     C                   Z-ADD     LBAPPOSI      KYLBRSPOSI
     C                   MOVE      *LOVAL        KYLBRSTMST
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBRSFIRM      IFGT      KYLBRSFIRM
     C     LBRSDANA      ORGT      KYLBRSDANA
     C     LBRSJAHR      ORGT      KYLBRSJAHR
     C     LBRSNMKR      ORGT      KYLBRSNMKR
     C     LBRSPOSI      ORGT      KYLBRSPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSSTAT      IFLT      '90'                                           Pickliste
     C*
     C                   ADD       LBRSRSMG      DSRSMG
     C     LBRSLANR      IFEQ      '001'                                          Pickliste
     C     LBRSLORT      ANDEQ     '9911 '                                        Pickliste
     C                   ADD       LBRSRSMG      DSRSMG9911
     C                   Z-ADD     LBRSTMST      WKTMST9911
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** Löschen   LBRS-SATZ                                                ***
     C**************************************************************************
     C     D2LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      LBAPDANA      KYLBRSDANA                     ERSTER SATZ
     C                   MOVE      LBAPJAHR      KYLBRSJAHR
     C                   MOVE      LBAPNMKR      KYLBRSNMKR
     C                   Z-ADD     LBAPPOSI      KYLBRSPOSI
     C                   MOVE      *LOVAL        KYLBRSTMST
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBRSFIRM      IFGT      KYLBRSFIRM
     C     LBRSDANA      ORGT      KYLBRSDANA
     C     LBRSJAHR      ORGT      KYLBRSJAHR
     C     LBRSNMKR      ORGT      KYLBRSNMKR
     C     LBRSPOSI      ORGT      KYLBRSPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSSTAT      IFLT      '90'                                           Pickliste
     C     LBRSLANR      ANDEQ     '001'
     C*
     C                   Z-ADD     LBRSTMST      KYLBRSTMST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C                   SELECT
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01D     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDSL
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERSTELLEN LAGERRESERVIERUNGEN LBRS                                ***
     C**************************************************************************
     C     TRLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBRS
     C                   CLEAR                   EXLBRS
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     WKTRPALGBE    KOM(01)
     C                   MOVEL     *OFF          KOM(29)
     C                   MOVEL     *ON           KOM(38)
     C                   MOVEL     *OFF          KOM(39)
     C     LBAPDANA      IFEQ      'BGFS'
     C     PCPGST        ANDEQ     'GNBGFS'
     C                   MOVEA     '97'          KOM(78)
     C                   ENDIF
     C     LBAPDANA      IFEQ      'BGFS'
     C     PCPGST        ANDEQ     'PRLBRS'
     C                   MOVEA     LBAPLPBE      KOM(118)
     C                   ENDIF
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        EXRSFIRM
     C                   MOVEL     LBAPDANA      EXRSDANA
     C                   Z-ADD     LBAPJAHR      EXRSJAHR
     C                   MOVEL     LBAPNMKR      EXRSNMKR
     C                   Z-ADD     LBAPPOSI      EXRSPOSI
     C                   MOVEL     LBAPKDNR      EXRSKDNR
     C                   MOVEL     DSLANR        EXRSLANR
     C                   MOVEL     LBAPTENR      EXRSTENR
     C                   MOVEL(P)  DSLORT        EXRSLORT
     C                   Z-ADD     DSBWMG        EXRSRSMG
     C*-------------------------------------------------------------------------
     C     WKTRPALGBE    IFEQ      *BLANK                                       LAGERBEREICH
     C                   MOVEL     'RLBRS'       #CPGST
     C                   ELSE
     C                   MOVEL     'RLGBE'       #CPGST
     C                   ENDIF
     C*
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C     WKDANA        IFEQ      'BGFS'
     C     PCPGST        ANDEQ     'GNBGFS'
     C                   Z-ADD     *ZERO         DSRSMG
     C                   EXSR      E2LBRS
     C     LBAPBWMG      SUB       DSRSMG        DSBWMG
     C     DSBWMG        IFGT      *ZERO
     C                   EXSR      TRLBRSWAO
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** Zweiter Reservierungsdurchlauf WAECO                               ***
     C**************************************************************************
     C     TRLBRSWAO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     WKTRPALGBE    KOM(01)
     C                   MOVEL     *OFF          KOM(29)
     C                   MOVEL     *ON           KOM(38)
     C                   MOVEL     *OFF          KOM(39)
     C                   MOVEA     '98'          KOM(78)
     C     LBAPDANA      IFEQ      'BGFS'
     C     PCPGST        ANDEQ     'PRLBRS'
     C                   MOVEA     LBAPLPBE      KOM(118)
     C                   ENDIF
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     *BLANK        #CPGST
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTLBRS
     C                   CLEAR                   EXLBRS
     C                   MOVEL     DAFIRM        EXRSFIRM
     C                   MOVEL     LBAPDANA      EXRSDANA
     C                   Z-ADD     LBAPJAHR      EXRSJAHR
     C                   MOVEL     LBAPNMKR      EXRSNMKR
     C                   Z-ADD     LBAPPOSI      EXRSPOSI
     C                   MOVEL     LBAPKDNR      EXRSKDNR
     C                   MOVEL     DSLANR        EXRSLANR
     C                   MOVEL(P)  DSLORT        EXRSLORT
     C                   MOVEL     LBAPTENR      EXRSTENR
     C                   Z-ADD     DSBWMG        EXRSRSMG
     C*
     C                   MOVEL     'RLGBE'       #CPGST
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN BENUTZERIDEX                                            ***
     C**************************************************************************
     C     UXLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'TRLBAP'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 18 + 303                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 18                              MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung LBAP für Ladeliste'
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYLBAPJAHR    KYLBAPKMJJ
     C                   MOVEL     KYLBAPNMKR    KYLBAPKMNR
     C                   Z-ADD     KYLBAPPOSI    KYLBAPKMPO
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHLBAP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBAPFIRM      IFGT      KYLBAPFIRM
     C     LBAPKMJJ      ORGT      KYLBAPKMJJ
     C     LBAPKMNR      ORGT      KYLBAPKMNR
     C     LBAPKMPO      ORGT      KYLBAPKMPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBAPDANA      IFEQ      'BGFS'
     C                   Z-ADD     LBAPJAHR      DUN040
     C                   Z-ADD     LBAPPOSI      DUN050
     C*
     C                   MOVEL(P)  'SKOM'        KYLBAPDANA
     C                   Z-ADD     LBAPJAHR      KYLBAPJAHR
     C                   MOVEL     LBAPNMKR      KYLBAPNMKR
     C                   Z-ADD     LBAPPOSI      KYLBAPPOSI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBAP
     C*
     C                   EVAL      WKSORT = DUC004 + LBAPNMKR +'   '+DUC005
     C                   EVAL      EXUX01IDTA = WKSORT   + LBAP
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '05R     '    CHI
     C                   EXSR      CHLBAP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  WKPROG        RTTRNDPROG
     C                   MOVEL(P)  WKDANA        RTTRNDDANA
     C                   MOVEL(P)  WKFFLD        RTTRNDFFLD
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
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
     C                   MOVE      DAFIRM        KYTAFI                         TRPA
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'LANR'        KYTATC                         STAMMFIRMA
     C                   MOVEL     'FIRM'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKSTMF
     C*
     C     WKSTMF        IFNE      *BLANK
     C                   MOVEL     WKSTMF        KYTAFI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBAP'      KYTATA                         ERMITTELN OB
     C                   MOVEL(P)  'LGRS'        KYTATC                         LAGERRBEREICHSRES.
     C                   MOVEL(P)  'LGBE'        KYTAPA                         ERFOLGEN SOLL
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALGBE
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TREND'       KYTATA                         OB BESTANDSLAGER
     C                   MOVEL     'BSLA  '      KYTATC                         AKTIV IST.
     C                   MOVEL     'BSLA  '      KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPABSLA
     C     WKTRPABSLA    IFNE      *ON
     C                   MOVE      *OFF          WKTRPABSLA
     C                   ENDIF
     C*-------------------------------------------------------------------------
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
     C     *LIKE         DEFINE    WKC001        WKTRPALGBE      + 2            LAGERBEREICH
     C     *LIKE         DEFINE    WKC001        WKTRPABSLA                     BESTANDSLAGER
     C     *LIKE         DEFINE    WKC001        WKSORT          +17            Sortierung
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
     C     *LIKE         DEFINE    RTTRNDPA03    W$PA03
     C     *LIKE         DEFINE    RTTRNDPA04    W$PA04
     C     *LIKE         DEFINE    RTTRNDPA05    W$PA05
     C     *LIKE         DEFINE    RTTRNDPA06    W$PA06
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKSTMF
     C     *LIKE         DEFINE    LBAPDANA      OFLBAPDANA
     C     *LIKE         DEFINE    LBAPJAHR      OFLBAPJAHR
     C     *LIKE         DEFINE    LBAPNMKR      OFLBAPNMKR
     C     *LIKE         DEFINE    LBAPPOSI      OFLBAPPOSI
     C     *LIKE         DEFINE    TELORT        WKLBPBLPBE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBRSTMST      WKTMST9911
     C     *LIKE         DEFINE    LBRSRSMG      DSRSMG
     C     *LIKE         DEFINE    LBRSRSMG      DSRSMG9911
     C     *LIKE         DEFINE    LBRSRSMG      DSBWMG
     C     *LIKE         DEFINE    LBRSLANR      DSLANR
     C     *LIKE         DEFINE    LBRSLORT      DSLORT
     C     *LIKE         DEFINE    DUN134        WKLAGB
     C     *LIKE         DEFINE    DUN134        WKLAGB9911
     C     *LIKE         DEFINE    DUN134        WKRESL
     C     *LIKE         DEFINE    DUN134        WKRESL9911
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHLBBS
     C/COPY QCPYSRC,CHLBLZ
     C/COPY QCPYSRC,CHLBPB
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXUX04
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                           *
     O**************************************************************************
