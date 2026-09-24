     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2011')
     H**************************************************************************
     H/TITLE  Ermitteln Wiederverfügbarkeits-Termin
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 13.07.2011 Projekt 7513
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 14.03.2015 Projekt 11583
     H*            Aufruf der Anfangsroutine bei Firmenwechsel (DAFIRM/WKFIRM)
     H*  Änderung: PH 16.02.2026 Case 05947674 "B2B Wiederverfügbarkeit"
     H*            Anpassung der Ermittlungsroutine ERWVTE an den Aufruf NUR mit einer Ident-Nr
     H*            (EXTRNDTENR) und einer Werks-Nr (EXTRNDWKNR - neuer Übergabeparameter) OHNE
     H*            eine KD-Auftrags-Jahr (EXTRNDAFJJ) und OHNE eine KD-Auftrags-Nr (EXTRNDAFNR).
     F**************************************************************************
     F*
     F*  Ermittlung des Wiederverfügbarkeits-Termin
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D AFUP          E DS                  INZ
     D KYAFUP        E DS                  INZ
     D*
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D*
     D BBEU          E DS                  INZ
     D KYBBEU        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D DIST          E DS                  INZ
     D KYDIST        E DS                  INZ
     D*
     D PAUA          E DS                  INZ
     D KYPAUA        E DS                  INZ
     D*
     D PAUK          E DS                  INZ
     D KYPAUK        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEEW          E DS                  INZ
     D KYTEEW        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D ZTDI          E DS                  INZ
     D KYZTDI        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
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
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKFIRM        CASNE     DAFIRM        ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      ERWVTE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RTTRNDWVTE    DUN080
     C                   MOVEA(P)  DUC008        KOM(01)
     C                   MOVEA(P)  KOM           RTTRNDDATE
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        WKFIRM
     C                   RETURN
     C                   SETON                                        LR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  KOM(01)       DUC004
     C                   TESTN                   DUC004               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        EXTRNDAFJJ
     C*
     C                   MOVEA(P)  KOM(05)       EXTRNDAFNR
     C*
     C                   MOVEA(P)  KOM(11)       DUC005
     C                   TESTN                   DUC005               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVE      *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        EXTRNDAFPO
     C                   MOVEA(P)  KOM(16)       EXTRNDTENR
     C*
     C                   MOVEA(P)  KOM(31)       DUC005
     C                   TESTN                   DUC005               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVE      *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        EXTRNDAFUP

     C                   MOVEA(P)  KOM(36)       EXTRNDWKNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   Z-ADD     *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYEPFI                         BBEP
     C                   MOVEL(P)  DAFIRM        KYEUFI                         BBEU
     C                   MOVEL(P)  DAFIRM        KYAEFI                         BWAE
     C                   MOVEL(P)  DAFIRM        KYUAFI                         PAUA
     C                   MOVEL(P)  DAFIRM        KYUKFI                         PAUK
     C                   MOVEL(P)  DAFIRM        KYTEEWFIRM                     TEEW
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYZTFI                         ZTDI
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYAUFI                         AFUP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDAFJJ    KYAKJH
     C                   MOVEL(P)  EXTRNDAFNR    KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERWVTE     ERMITTELN WIEDERVERFPGBSRKEITS-TERMIN               ***
     C**************************************************************************
     C     ERWVTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         RTTRNDWVTE
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C*-------------------------------------------------------------------------
     C                   DO
      /FREE
       IF  EXTRNDAFJJ = *ZERO AND EXTRNDAFNR = *BLANK AND EXTRNDTENR = *BLANK;
         LEAVESR;
       ENDIF;

       IF  EXTRNDAFJJ <> *ZERO AND EXTRNDAFNR <> *BLANK;
      /END-FREE
     C*-------------------------------------------------------------------------
     C     EXTRNDAFUP    IFEQ      *ZERO
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL(P)  DAFIRM        EXRSFIRM
     C                   MOVEL(P)  'AFPO'        EXRSAFDN
     C                   Z-ADD     EXTRNDAFJJ    EXRSAFJJ
     C                   MOVEL(P)  EXTRNDAFNR    EXRSAFNR
     C                   Z-ADD     EXTRNDAFPO    EXRSAFPO
     C*
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     'ERES1 '      #CPGST
     C*
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*
     C     RTRSRMMG      IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDAFUP    IFNE      *ZERO
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL(P)  'AFUP'        EXRSAFDN
     C                   Z-ADD     EXTRNDAFJJ    EXRSAFJJ
     C                   MOVEL(P)  EXTRNDAFNR    EXRSAFNR
     C                   Z-ADD     EXTRNDAFPO    EXRSAFPO
     C                   Z-ADD     EXTRNDAFUP    EXRSAFUP
     C*
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL     'ERES1 '      #CPGST
     C*
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*
     C     RTRSRMMG      IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'V'           KYEUKZ                         SCHLÜSSEL
     C                   Z-ADD     EXTRNDAFJJ    KYEUAJ                         VORBEREITEN
     C                   MOVEL(P)  EXTRNDAFNR    KYEUAF
     C                   Z-ADD     EXTRNDAFPO    KYEUAP
     C                   Z-ADD     *ZERO         KYEUFL
     C     EXTRNDAFUP    IFNE      *ZERO
     C                   Z-ADD     EXTRNDAFUP    KYEUFL
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYEUJH
     C                   MOVEL     *BLANK        KYEUBE
     C                   Z-ADD     *ZERO         KYEUPO
     C                   Z-ADD     *ZERO         KYEUUP
     C                   MOVEA     '02+     '    CHI                            AUFSETZEN
     C                   EXSR      CHBBEU
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C     EUFIRM        ANDEQ     KYEUFI
     C     EUVPKZ        ANDEQ     KYEUKZ
     C     EUAFJJ        ANDEQ     KYEUAJ
     C     EUAFNR        ANDEQ     KYEUAF
     C     EUAFPO        ANDEQ     KYEUAP
     C     EUAGFL        ANDEQ     KYEUFL
     C*
     C     EUGLMG        IFEQ      *ZERO
     C                   Z-ADD     EUBEJJ        KYEPJH
     C                   MOVEL(P)  EUBENR        KYEPBE
     C                   Z-ADD     EUBEPO        KYEPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*
     C                   MOVEL(P)  EPTENR        KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     TEEWLVZA      IFEQ      *BLANK                                       KEINE VL-DATEN
     C     TEEWLVZT      OREQ      *ZERO                                        IN TEEW
     C*                  Z-ADD     EPBETE        RTTRNDWVTE
     C*                  LEAVESR
     C                   ENDIF
     C*
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
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     EPBETE        EXDATEDATV
     C                   Z-ADD     DUN110        EXDATEWERT
     C*                  ADD       WKTRPAVLKO    EXDATEWERT
     C                   MOVEL(P)  AKWKNR        EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    RTTRNDWVTE
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '02R     '    CHI                            AUFSETZEN
     C                   EXSR      CHBBEU
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'V'           KYUAKZ                         SCHLÜSSEL
     C                   Z-ADD     EXTRNDAFJJ    KYUAJJ                         VORBEREITEN
     C                   MOVEL(P)  EXTRNDAFNR    KYUANR
     C                   Z-ADD     EXTRNDAFPO    KYUAPO
     C                   Z-ADD     *ZERO         KYUAUP
     C     EXTRNDAFUP    IFNE      *ZERO
     C                   Z-ADD     EXTRNDAFUP    KYUAUP
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYUAJH
     C                   MOVEL     *BLANK        KYUAPP
     C*
     C                   MOVEA     '02+     '    CHI                            AUFSETZEN
     C                   EXSR      CHPAUA
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C     UAFIRM        ANDEQ     KYUAFI
     C     UAVPKZ        ANDEQ     KYUAKZ
     C     UAAFJJ        ANDEQ     KYUAJJ
     C     UAAFNR        ANDEQ     KYUANR
     C     UAAFPO        ANDEQ     KYUAPO
     C*
     C     UARMMG        IFEQ      *ZERO
     C                   Z-ADD     UAPPJJ        KYUKJH
     C                   MOVEL(P)  UAPPNR        KYUKPP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAUK
     C*
     C                   MOVEL(P)  UKTENR        KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
     C     TEEWLVZA      IFEQ      *BLANK                                       KEINE VL-DATEN
     C     TEEWLVZT      OREQ      *ZERO                                        IN TEEW
     C*                  Z-ADD     UKPREN        RTTRNDWVTE
     C*                  LEAVESR
     C                   ENDIF
     C*
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
     C     W1ZTFK        DIV       WKZTFK        DUN030                         ERMITTELN DES
     C     DUN030        MULT      TEEWLVZT      DUN030                         TAGES-VERHÄLTNI
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     UKPREN        EXDATEDATV
     C                   Z-ADD     DUN030        EXDATEWERT
     C*                  ADD       WKTRPAVLKO    EXDATEWERT
     C                   MOVEL(P)  AKWKNR        EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    RTTRNDWVTE
     C                   ENDIF
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   MOVEA     '02R     '    CHI                            AUFSETZEN
     C                   EXSR      CHPAUA
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDAFJJ    KYAPJH
     C                   MOVEL(P)  EXTRNDAFNR    KYAPAF
     C                   Z-ADD     EXTRNDAFPO    KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C     CHI(05)       IFEQ      'J'
     C                   MOVEL     APTENR        EXTRNDTENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDAFUP    IFNE      *ZERO
     C                   Z-ADD     EXTRNDAFJJ    KYAUJH
     C                   MOVEL(P)  EXTRNDAFNR    KYAUAF
     C                   Z-ADD     EXTRNDAFPO    KYAUPO
     C                   Z-ADD     EXTRNDAFUP    KYAUUP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFUP
     C     CHI(05)       IFEQ      'J'
     C                   MOVEL     AUKOTE        EXTRNDTENR
     C                   ENDIF
     C                   ENDIF
      /FREE
       ELSE;
         IF EXTRNDWKNR <> *BLANK;
           AKWKNR = EXTRNDWKNR;
         ELSE;
           LEAVESR;
         ENDIF;
       ENDIF;
      /END-FREE
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE DISTC1 CURSOR FOR SELECT *
     C+ FROM DIST
     C+ WHERE ITFIRM = :DAFIRM
     C+ AND   ITTENR = :EXTRNDTENR
     C+ AND   ITBEGR IN ('040', '041', '043', '030', '031')
     C+ ORDER BY ITFIRM,ITTENR,ITRSDA,ITRSZT ,ITBEGR DESC ,ITBGJJ,
     C+          ITBGNR, ITBPOS, ITUPOS FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         OPEN DISTC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         FETCH DISTC1 INTO :DIST
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*----------------------------------------------------------
     C                   MOVEL     'ERMMGE'      #CPGST                         ERMITTELN
     C                   EXSR      TRDIMG                                       DIST-MENGE
     C*
     C     WKFENR        IFNE      *ZERO
     C     WKDIMG        ORLE      *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C     ITBEGR        IFEQ      '043'
     C                   Z-ADD     ITBGJJ        KYAEWJ
     C                   MOVEL     ITBGNR        KYAEWE
     C                   MOVEA     '07C     '    CHI                            VORHANDEN
     C                   EXSR      CHBWAE
     C*
     C                   MOVEL     '040'         ITBEGR
     C                   Z-ADD     AEBEJJ        ITBGJJ
     C                   MOVEL     AEBENR        ITBGNR
     C                   Z-ADD     AEBEPO        ITBPOS
     C                   ENDIF
     C*
     C     ITBEGR        IFEQ      '040'
     C     ITBEGR        OREQ      '041'
     C                   Z-ADD     ITBGJJ        KYEPJH
     C                   MOVEL     ITBGNR        KYEPBE
     C                   Z-ADD     ITBPOS        KYEPPO
     C                   MOVEA     '01C     '    CHI                            VORHANDEN
     C                   EXSR      CHBBEP
     C*
     C                   MOVEL     WKTDAT        DUN080
     C     EPBETE        IFGT      DUN080
     C*
     C                   MOVEL(P)  EPTENR        KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
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
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     EPBETE        EXDATEDATV
     C                   Z-ADD     DUN110        EXDATEWERT
     C*                  ADD       WKTRPAVLKO    EXDATEWERT
     C                   MOVEL(P)  AKWKNR        EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    RTTRNDWVTE
     C                   ENDIF
     C/EXEC SQL
     C+         CLOSE DISTC1
     C/END-EXEC
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*
     C     ITBEGR        IFEQ      '030'
     C     ITBEGR        OREQ      '031'
     C                   Z-ADD     ITBGJJ        KYUKJH
     C                   MOVEL(P)  ITBGNR        KYUKPP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAUK
     C*
     C                   MOVEL(P)  UKTENR        KYTEEWTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEEW
     C*
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
     C     W1ZTFK        DIV       WKZTFK        DUN030                         ERMITTELN DES
     C     DUN030        MULT      TEEWLVZT      DUN030                         TAGES-VERHÄLTNI
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     UKPREN        EXDATEDATV
     C                   Z-ADD     DUN030        EXDATEWERT
     C*                  ADD       WKTRPAVLKO    EXDATEWERT
     C                   MOVEL(P)  AKWKNR        EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    RTTRNDWVTE
     C                   ENDIF
     C/EXEC SQL
     C+         CLOSE DISTC1
     C/END-EXEC
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         CLOSE DISTC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDTENR    KYTENR
     C                   MOVEL     *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYTAFI                         ERMITTELN
     C                   MOVEL     'FIRM'        KYTATA                         BRIEFKASTEN-
     C                   MOVEL     'DIBR'        KYTATC                         ART
     C                   MOVEL     TETART        KYTAPA                         PRODUKTION 'PRO'
     C                   MOVEA     '01C     '    CHI                            ODER BESTELLUNG
     C                   EXSR      CHTRPA                                       'BES'
     C*-------------------------------------------------------------------------
     C     TAPCDE        IFEQ      '030'                                        EIGENFERTIGUNG
     C                   MOVEL     TEVOA1        WKVLAT                         V-ART (T,M,W) AV
     C                   MOVE      TEVOZ1        WKVLZT                         VORLAUFZEIT   AV
     C                   ENDIF
     C     TAPCDE        IFEQ      '040'                                        KAUFTEIL
     C                   MOVEL     TELVA1        WKVLAT                         VORLAUFART    EK
     C                   MOVE      TELVZ1        WKVLZT                         VORLAUFZEIT   EK
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKVLAT        IFEQ      *BLANK                                       KEINE VL-DATEN
     C     WKVLZT        OREQ      *ZERO                                        IM IDENTSTAMM
     C                   LEAVESR
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
     C                   ADD       WKTRPAWBTG    DUN030
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        EXDATEDATV
     C                   Z-ADD     DUN030        EXDATEWERT
     C                   MOVEL(P)  AKWKNR        EXDATEWKNR
     C                   MOVEL(P)  WKTRPAPLAT    EXDATEPLAT
     C                   MOVEL(P)  '+'           EXDATEOPCD
     C                   MOVEL(P)  'ERDAWK'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   Z-ADD     RTDATEDATE    RTTRNDWVTE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DISPO-MENGE                                             ***
     C**************************************************************************
     C     TRDIMG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKDIMGBSKZ        1
     C                   Z-ADD     *ZERO         WKDIMG           13 4          OFFENE MENGE
     C                   Z-ADD     *ZERO         WKMENG           13 4
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     'V'           KOM(1)                         KZ SICHT V/P      J/
     C                   MOVEL     *BLANK        #CRTCD
     C                   MOVEA     KOM(1)        #CKOMM
     C*
     C                   CALL      'TRDIMG'                             99
     C                   PARM                    EXTR02
     C                   PARM                    DIST
     C*----------------------------------------------------------
     C     #CRTCD        IFNE      *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*
     C                   MOVEA     KOM(01)       DUC011                         DISPO-MENGE
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN112        WKMENG
     C*
     C                   MOVEA     KOM(84)       DUC011
     C                   TESTN                   DUC011               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC011                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN112        WKDIMG                         OFFENE MENGE
     C*
     C                   MOVEA     KOM(120)      WKDIMGBSKZ                     BESTELL-BESTÄTIGT
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
     C                   MOVEL(P)  'VERTRIEB'    KYTATA                         PLANUNGS-ART
     C                   MOVEL(P)  'PLAT'        KYTATC                         FÜR WERKSKALENDER
     C                   MOVEL(P)  'PMWK'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAPLAT
     C     WKTRPAPLAT    IFEQ      *BLANK
     C                   MOVEL(P)  '001'         WKTRPAPLAT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'ZTDI'        KYTATC                         STAMMZEIT-
     C                   MOVEL(P)  'ZTDI'        KYTAPA                         DIMENSION
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        KYZTSZ                         STAMMZEITBASIS
     C*-------------------------------------------------------------------------
     C                   MOVEL     'TRAB04'      KYTATA                         VORLAUF-
     C                   MOVEL     'WBZT  '      KYTATC                         KORREKTUR
     C                   MOVEL     'VLZT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        DUC003
     C*
     C                   TESTN                   DUC003               98        PRÜFUNG AUF
     C     *IN(98)       IFEQ      *ON                                          NUMERISCHEN
     C                   Z-ADD     DUN030        WKTRPAWBTG        3 0          INHALT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'DIST'        KYTATC                         VORLAUF-KORREKTUR
     C                   MOVEL     'VLZT'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        DUC003
     C                   TESTN                   DUC003               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC003                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN030        WKTRPAVLKO        3 0
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
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKTRPAPLAT      + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    ZTZTFK        WKZTFK
     C     *LIKE         DEFINE    ZTZTFK        W1ZTFK
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EUAFJJ        EXTRNDAFJJ
     C     *LIKE         DEFINE    EUAFNR        EXTRNDAFNR
     C     *LIKE         DEFINE    EUAFPO        EXTRNDAFPO
     C     *LIKE         DEFINE    EUAGFL        EXTRNDAFUP
     C     *LIKE         DEFINE    EPTENR        EXTRNDTENR
     C     *LIKE         DEFINE    AKWKNR        EXTRNDWKNR
     C     *LIKE         DEFINE    EPBETE        RTTRNDWVTE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TELVA1        WKVLAT                         VORLAUFART    EK
     C     *LIKE         DEFINE    TELVZ1        WKVLZT                         VORLAUFZEIT   EK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHAFUP
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBBEU
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHPAUA
     C/COPY QCPYSRC,CHPAUK
     C/COPY QCPYSRC,CHTEEW
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHZTDI
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
