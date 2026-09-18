     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 17.11.2010 für Kunde WAECO Besuch in Emstetten
     H*  --------------------------------------------------------------
     H*  Änderung: SZ 14.07.2016 keine Spoolausgabe im Batch und User TRDEDI
     H*  Änderung: SZ 25.08.2016 SR PBLIN Prüfung auf doppelte externe Liefer-
     H*            scheinnummer
     H*  Änderung: GS 28.04.2021 Projekt 16579, Erweiterung der Lager-Prüfung von
     H*                          500 und 510 auf 590. (Ware Unterwegs)
     H*  Änderung: HR 14.03.2023 S20230310-006 für Streckenbestellung kein DIST
     H*  Änderung: MG 26.03.2024 Projekt 10722-92 keine Dispositionsdaten
     H*            bei Streckengeschäfte. Steuerung über das Feld BBPA.PARMKA.
     H*  Änderung: GS 19.12.2024 Abstimmung IK/Hr.Axxelson, Zusätzlich Lager 520
     H*                          bei der Lagerprüfung mit aufnehmen.
     F**************************************************************************
     F*/
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*/
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D*
     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ
     D*
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ
     D*
     D DIST          E DS                  INZ
     D*
     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
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
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'U     '
     C                   EXSR      UDIST
     C     PCPGST        WHENEQ    'L     '
     C                   EXSR      LDIST
     C     PCPGST        WHENEQ    'T3BWAE'
     C                   EXSR      T3BWAE
     C     PCPGST        WHENEQ    'UBBEP '
     C                   EXSR      UBBEP
     C     PCPGST        WHENEQ    'PBLIN '
     C                   EXSR      PBLIN
     C*--------------------------------------------------------
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
     C                   MOVEL(P)  DAFIRM        KYEPFI                         BBEP
     C                   MOVEL(P)  DAFIRM        KYAEFI                         BWAE
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM
     C                   MOVEL(P)  DAFIRM        KYPAFI                         BESTELLART
     C                   MOVEL(P)  DAFIRM        KYLBLBFIRM                     LBLB
     C                   MOVEL(P)  DAFIRM        KYZTFI                         ZTDI
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
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        KYAEWJ
     C                   MOVEA(P)  KOM(05)       KYAEWE
     C*
     C                   MOVEA     KOM(11)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        DSBEJJ
     C                   MOVEA(P)  KOM(15)       DSBENR
     C                   MOVEA     KOM(21)       DUC005
     C                   TESTN                   DUC005               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC005                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN050        DSBEPO
     C*-------------------------------------------------------------------------
     C                   EVAL      L1 = %LEN(BWAE)
     C                   MOVEL(P)  EXTRNDDATE    BWAE
     C                   EVAL      EXLBBEZ1=%SUBST(EXTRNDDATE: L1: 30)
     C                   EVAL      EXLBBEZ2=%SUBST(EXTRNDDATE: (L1+30): 30)
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
     C***  SR-UDIST   RESERVIERUNG AUFTRAGSDATEN IN DISPO-DATEI              ***
     C**************************************************************************
     C     UDIST         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AETENR        KYTENR                         DATEN AUS
     C                   MOVE      *BLANK        KYTEEZ                         TEILESTAMM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         DUN110
     C*
     C                   MOVEL(P)  AETENR        KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     TEEWLVZA      IFNE      *BLANK                                       KEINE VL-DATEN
     C     TEEWLVZT      ANDNE     *ZERO                                        IN TEEW
     C                   MOVEL(P)  'T'           KYZTZD                         ZEITFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZU
     C                   EXSR      CHZTDI                                       TAGEN
     C                   Z-ADD     ZTZTFK        WKZTFK
     C     WKZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             WKZTFK
     C                   ENDIF
     C*
     C                   MOVEL(P)  TEEWLVZA      KYZTZD                         ZEIFAKTOR
     C                   MOVEA     '01C     '    CHI                            VERHÄLTNIS ZUR
     C                   EXSR      CHZTDI                                       TEEW-
     C                   Z-ADD     ZTZTFK        W1ZTFK                         VORLAUFZEIT
     C     W1ZTFK        IFEQ      *ZERO
     C                   Z-ADD     1             W1ZTFK
     C                   ENDIF
     C*
     C     W1ZTFK        MULT      TEEWLVZT      DUN180                         ERMITTELN DES
     C     DUN180        DIV       WKZTFK        DUN110                         TAGES-VERHÄLTNI
     C                   MVR                     DUN050
     C     DUN050        IFNE      *ZERO
     C                   ADD       1             DUN110
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AEBEJJ        KYEPJH
     C                   MOVEL     AEBENR        KYEPBE
     C                   Z-ADD     AEBEPO        KYEPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EPBEAT        KYPAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBPA
     C*
     C                   IF        EPBEAT = '59 ' OR EPBEAT = '55 '
     C                             OR EPBEAT = '57 '
     C                   LEAVESR
     C                   ENDIF
     C* Auslieferung KD-Auftrag über den Wareneingang (Streckengeschäft)
     C     PARMKA        IFEQ      DAJNKZ
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     PABEBS        IFEQ      DAJNKZ
     C     TETART        ANDNE     'P'
     C     TEBSKZ        ANDEQ     DAJNKZ
     C*-------------------------------------------------------------------------
     C                   IF        AEBWLA='500' or AEBWLA='510' or AEBWLA='520'
     C                             or AEBWLA='590'
     C*
     C                   CLEAR                   DIST                           INITIALISIERUNG
     C                   MOVEL(P)  DAFIRM        ITFIRM                         SCHLÜSSEL
     C                   MOVEL(P)  '043'         ITBEGR                         SONDERBESTELLUNG
     C                   Z-ADD     AEWEJJ        ITBGJJ
     C                   MOVEL(P)  AEWENR        ITBGNR
     C                   Z-ADD     *ZERO         ITUPOS
     C                   MOVEL(P)  AETENR        ITTENR                         IDENTNUMMER
     C                   MOVEL(P)  EPLANR        ITLANR                         IDENTNUMMER
     C                   MOVEL(P)  AEWKNR        ITWKNR                         WERK
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     EPBETE        EXDATEDATV
     C                   Z-ADD     DUN110        EXDATEWERT
     C*                  Z-ADD     2             EXDATEWERT
     C*                  IF        TEWEMT='1'
     C*                  Z-ADD     3             EXDATEWERT
     C*                  ENDIF
     C                   MOVEL(P)  AEWKNR        EXDATEWKNR
     C                   MOVEL(P)  '001'         EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    ITRSDA
     C                   ELSE
     C                   Z-ADD     EPBETE        ITRSDA
     C                   ENDIF
     C                   MOVEL(P)  'U     '      #CPGST
     C                   EXSR      TRDIST                                       BUCHUNG DIST
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-LDIST   Löschen                                                ***
     C**************************************************************************
     C     LDIST         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AEBEJJ        KYEPJH
     C                   MOVEL     AEBENR        KYEPBE
     C                   Z-ADD     AEBEPO        KYEPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C                   CLEAR                   DIST                           INITIALISIERUNG
     C                   MOVEL(P)  DAFIRM        ITFIRM                         SCHLÜSSEL
     C                   MOVEL(P)  '043'         ITBEGR                         SONDERBESTELLUNG
     C                   Z-ADD     AEWEJJ        ITBGJJ
     C                   MOVEL(P)  AEWENR        ITBGNR
     C                   Z-ADD     *ZERO         ITUPOS
     C                   MOVEL(P)  AETENR        ITTENR                         IDENTNUMMER
     C                   MOVEL(P)  EPLANR        ITLANR                         Lager
     C                   MOVEL(P)  AEWKNR        ITWKNR                         WERK
     C                   MOVEL(P)  'D     '      #CPGST
     C                   EXSR      TRDIST                                       BUCHUNG DIST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-UPWEDA  Updat WEDA                                             ***
     C**************************************************************************
     C     T3BWAE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      AETMST        KYLBLBTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBLB
     C*-------------------------------------------------------------------------
     C     LBLBLANR      IFNE      '500'
     C     LBLBLANR      ANDNE     '510'
     C     LBLBLANR      ANDNE     '520'
     C     LBLBLANR      ANDNE     '590'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '07CU    '    CHI
     C                   EXSR      CHBWAE
     C*-------------------------------------------------------------------------
     C     EXLBBEZ1      IFNE      *BLANKS
     C                   MOVEL(P)  EXLBBEZ1      AEBUT1
     C                   ENDIF
     C     EXLBBEZ2      IFNE      *BLANKS
     C                   MOVEL(P)  EXLBBEZ2      AEBUT2
     C                   ENDIF
     C*-----------------------------------------------------------------
     C     AEBUT2        IFEQ      *BLANKS
     C                   EVAL      AEBUT2 = '---  Umlagerung von ' +
     C                                      LBLBLANR + '  ---'
     C                   ENDIF
     C*-----------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        AEJNAM
     C                   MOVEL(P)  WKCHPN        AEPROG
     C                   MOVEL(P)  WKCHPL        AEBIBL
     C                   MOVEL(P)  DAUSER        AEUSER
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        AEJZEI
     C                   MOVE      WKTDAT        AEJDAT
     C*-------------------------------------------------------------------------
     C                   MOVE      WKTDAT        AEWEDA
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C*
     C     CHI(6)        WHENNE    *ON
     C                   MOVEA     '07U     '    CHI
     C                   EXSR      CHBWAE
     C*
     C                   IF        C#JOBA = '2' AND WKUSER = 'TRDEDI'
     C*                  NICHT DRUCKEN
     C                   ELSE
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     '00'          KOM(1)
     C                   MOVE      AEBEJJ        DUN040
     C                   MOVEA     DUC004        KOM(3)
     C                   MOVEA     AEBENR        KOM(7)
     C                   MOVE      AEBEPO        DUN040
     C                   MOVEA     DUC004        KOM(13)
     C                   MOVE      AEWEJJ        DUN040
     C                   MOVEA     DUC004        KOM(17)
     C                   MOVEA     AEWENR        KOM(21)
     C                   MOVEA     KOM(1)        #CKOMM
     C                   MOVE      'CLOSE '      #CPGST
     C*
     C                   CALL      'TRBA59CL'
     C                   PARM                    #CKOMM
     C                   PARM                    EXTR04
     C                   ENDIF
     C*----------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-UBBEP   UPDATE DIST AUS TRBBEP                                 ***
     C**************************************************************************
     C     UBBEP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSBEJJ        KYAEJH
     C                   MOVEL     DSBENR        KYAEBE
     C                   MOVEL     DSBEPO        KYAEPO
     C                   MOVE      *ZERO         KYAEWJ
     C                   MOVE      *ZERO         KYAEWE
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHBWAE
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     AEFIRM        IFNE      KYAEFI
     C     AEBEJJ        ORNE      KYAEJH
     C     AEBENR        ORNE      KYAEBE
     C     AEBEPO        ORNE      KYAEPO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      LDIST
     C                   EXSR      UDIST
     C*----------------------------------------------------------
     C                   MOVEA     '01R     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHBWAE
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN EXTERNE LIEFERSCHEINNUMMER                                 ***
     C**************************************************************************
     C     PBLIN         BEGSR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYAELI = %SUBST(EXTRNDDATE:1:15)
     C                   EVAL      KYAEWJ = *ZERO
     C                   EVAL      KYAEWN = *ZERO
     C                   MOVEA     '17+     '    CHI
     C                   EXSR      CHBWAE
     C*
     C                   DOW       WKFENR = '0000' AND
     C                             AEFIRM = KYAEFI AND
     C                             AEBLIN = KYAELI
     C*
     C                   IF        AELFNR = %SUBST(EXTRNDDATE:16:10) AND
     C                             AEBEJJ = DSBEJJ AND
     C                             AEBENR = DSBENR AND
     C                             AEBEPO = DSBEPO
     C                   EVAL      RTTRNDFENR = '6002'
     C                   EVAL      RTTRNDFFLD = 'AEBLIN'
     C                   EVAL      RTTRNDPA03 = %EDITC(AEWEJJ:'X')
     C                   EVAL      RTTRNDPA04 = AEWENR
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEA     '17R     '    CHI
     C                   EXSR      CHBWAE
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'ZTDI'        KYTATC                         STAMMZEIT-
     C                   MOVEL(P)  'ZTDI'        KYTAPA                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        KYZTSZ                         STAMMZEITBASIS
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C*
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
     C     *LIKE         DEFINE    WKN010        L1              + 2
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
     C     *LIKE         DEFINE    EPBEJJ        DSBEJJ
     C     *LIKE         DEFINE    EPBENR        DSBENR
     C     *LIKE         DEFINE    EPBEPO        DSBEPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ZTZTFK        WKZTFK
     C     *LIKE         DEFINE    ZTZTFK        W1ZTFK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHBBPA
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHZTDI
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRDIST
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
