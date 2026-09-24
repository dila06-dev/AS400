     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2012')
     H**************************************************************************
     H/TITLE  Modifikationen XML-Ausgabe Etiketten
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 30.10.2012 DOMETIC Projekt 8989
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 19.02.2013 DOMETIC Projekt 8997. Ermittlung und Übergabe an
     H*            die XML-Ausgabesteuerung der Daten für das TNT-Etikett
     H*  Änderung: SZ 25.03.2013 Produkt 'NEX' statt 'NEX07'
     H*
     H**************************************************************************
     F*  Dieses Programm erstellt die XML-Blöcke der Modifikationen zu Etiketten
     F*  Es erhält die XML, sowie Schlüsseldaten aus dem aufrufenden Programm XLAFVS04
     F*  bzw. XLAFVS03 . XML-Blöcke werden direkt im Hauptspeicher hinzugefügt
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D/COPY QCPYSRC,EXXMLDRFL
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D AFVS          E DS
     D*
     D LAND          E DS                  INZ
     D KYLAND        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D WAOB          E DS                  INZ
     D KYWAOB        E DS                  INZ
     D*
     D WAOH          E DS                  INZ
     D KYWAOH        E DS                  INZ
     D*
     D WAOI          E DS                  INZ
     D KYWAOI        E DS                  INZ
     D*
     D WAOJ          E DS                  INZ
     D KYWAOJ        E DS                  INZ
     D*
     D WAOS          E DS                  INZ
     D KYWAOS        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXXMLDRFL     E DS
     D RTXMLDRFL     E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS                  INZ
     D*
     D E1TREND       E DS
     D R1TREND       E DS                  INZ
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
     C                   PARM                    E1TREND
     C                   PARM                    AFVS
     C                   PARM                    EXXMLDRFL
     C*
     C                   EXSR      UEBTREND
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C                   WHEN      EXDRFLBLOC = 'MODWAOHEADER'
     C                   EXSR      XLKOPF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  UEBERNAHME EXTREND                                                ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXDRFLPGNA    WKDRFLPGNA
     C                   Z-ADD     EXDRFLKOPI    WKDRFLKOPI
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
     C                   MOVE      *BLANK        WKC001            1
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYASFI                         AFSP
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYWAOBFIRM                     WAOB
     C                   MOVEL(P)  DAFIRM        KYWAOHFIRM                     WAOH
     C                   MOVEL(P)  DAFIRM        KYWAOIFIRM                     WAOI
     C                   MOVEL(P)  DAFIRM        KYWAOJFIRM                     WAOJ
     C                   MOVEL(P)  DAFIRM        KYWAOSFIRM                     WAOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AVKMJJ        KYASJH
     C                   MOVEL(P)  AVKMNR        KYASNR
     C                   MOVEL(P)  'KMNR'        KYASKA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASSPED        KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AVKMJJ        KYAMJH
     C                   MOVEL(P)  AVKMNR        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     XLKOPF        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     WKDRFLPGNA    WHENEQ    'XLAFVS04'
     C                   MOVEL(P)  AVPAKN        PTBARC
     C                   EXSR      ELGEB
     C                   EXSR      EGSTL
     C*--------------------------------------------------------
     C     WKDRFLPGNA    WHENEQ    'XLAFVS03'
     C                   EVALR     PTTNTPROD = 'NEX'
     C                   EXSR      ERLTN
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EVAL      WKDRFLPGST = 'ADDBLOC'
     C                   EVAL      WKDRFLBLOC = 'MODWAOHEADER'
     C                   EXSR      ERAUFRDRFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN LEITGEBIET                                              ***
     C**************************************************************************
     C     ELGEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKLGEB
     C                   MOVEL     *BLANK        WKFACH
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AMPOLZ        KYWAOBPLZV
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHWAOB
     C*
     C     CHI(5)        IFEQ      'J'
     C     WAOBFIRM      ANDEQ     KYWAOBFIRM
     C     WAOBPLZB      ANDGE     AMPOLZ
     C                   MOVEL(P)  WAOBLGEB      WKLGEB
     C                   MOVEL(P)  WAOBABFA      WKFACH
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN GESCHÄFTSSTELLEN/TOUR                                   ***
     C**************************************************************************
     C     EGSTL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKGST1
     C                   MOVEL     *BLANK        WKGST2
     C                   MOVEL     *BLANK        WKTOUR
     C                   MOVEL     *BLANK        WKHUB1
     C                   MOVEL     *BLANK        WKHUB2
     C                   MOVEL     *BLANK        WKKTNR
     C                   MOVEL     *BLANK        WKKTN2
     C                   MOVEL     *OFF          WKIGST
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AMPOLZ        KYWAOHPOLZ                     PLZ PRÜFEN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOH
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'N'
     C                   MOVEL(P)  '950'         WKTOUR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '84'          KYWAOIGENR                     Schenker Osnabrück
     C                   MOVEL(P)  AMPOLZ        KYWAOIPOLZ
     C*-------------------------------------------------------------------------
     C     1             DO        3             WKZUGR
     C*--------------------------------------------------------
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHWAOI
     C                   EXSR      ERWAOI
     C*--------------------------------------------------------
     C     WKIGST        IFEQ      *ON                                          ROUTING BEENDET
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN ROUTING                                                 ***
     C**************************************************************************
     C     ERWAOI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WAOIPOLZ      IFGT      AMPOLZ
     C     WKFENR        ORNE      *ZERO
     C                   MOVEL(P)  '950'         WKTOUR
     C                   MOVEL     *ON           WKIGST
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKZUGR        CASEQ     1             ERROUTE01
     C     WKZUGR        CASEQ     2             ERROUTE02
     C     WKZUGR        CASEQ     3             ERROUTE03
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  1. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE01     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   EVAL      WKGST1      = %SUBST(WAOITOUR:2:2)
     C                   EVAL      KYWAOIGENR  = %SUBST(WAOITOUR:2:2)
     C                   MOVEL     *OFF          WKIGST                         NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   MOVEL(P)  WAOITOUR      WKGST1                         3 STELLEN !
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   MOVEL     *ON           WKIGST
     C     WAOITOUR      WHENGT    '899'
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   MOVEL     *ON           WKIGST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  2. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE02     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   EVAL      WKGST2      = %SUBST(WAOITOUR:2:2)
     C                   EVAL      KYWAOIGENR  = %SUBST(WAOITOUR:2:2)
     C                   MOVEL     *OFF          WKIGST                         NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   EXSR      ERWAOJ
     C                   MOVEL     *ON           WKIGST
     C     WAOITOUR      WHENGT    '899'
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   EXSR      ERWAOJ
     C                   MOVEL     *ON           WKIGST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  3. Zugriff auf Routingdatei WAOI                                  ***
     C**************************************************************************
     C     ERROUTE03     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WAOITOUR      WHENLT    '100'
     C                   MOVEL     *BLANK        WKGST1                         GEFUNDENE WERTE
     C                   MOVEL     *BLANK        WKGST2                         LÖSCHEN
     C                   MOVEL(P)  '950'         WKTOUR
     C                   MOVEL     *ON           WKIGST
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   MOVEL     *ON           WKIGST
     C     WAOITOUR      WHENGT    '899'
     C                   MOVEL(P)  WAOITOUR      WKTOUR
     C                   MOVEL     *ON           WKIGST
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Zugriff auf HUB-Datei WAOJ                                        ***
     C**************************************************************************
     C     ERWAOJ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '84'          KYWAOJGENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  WAOJHUBN      WKHUB2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKGST1        KYWAOJGENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  WAOJKTNR      WKKTNR
     C                   MOVEL(P)  WAOJHUBN      WKHUB1
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKHUB1        WHENEQ    '31'
     C     WKHUB1        OREQ      '81'
     C                   MOVEL(P)  WKHUB1        WKKTN2
     C     WKHUB1        WHENEQ    *BLANK
     C     WKHUB1        ANDEQ     WKHUB2
     C**                 EVAL                  = '91'                           NUR FÜR BARCODE
     C     WKHUB1        WHENNE    *BLANK
     C     WKHUB1        ANDNE     WKHUB2
     C**                 EVAL                  = '91'                           NUR FÜR BARCODE
     C     WKHUB1        WHENNE    *BLANK
     C     WKHUB1        ANDEQ     WKHUB2
     C**                 EVAL                  = WKHUB1                         NUR FÜR BARCODE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN RELATION                                                ***
     C**************************************************************************
     C     ERLTN         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKRLTN
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  AMLAND        KYLNNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLAND
     C*
     C     CHI(5)        IFEQ      'N'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LNLISO        KYWAOSLISO
     C                   MOVEL(P)  AMPOLZ        KYWAOSPLZV
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHWAOS
     C*
     C     CHI(5)        IFEQ      'J'
     C     WAOSFIRM      ANDEQ     KYWAOSFIRM
     C     WAOSLISO      ANDEQ     KYWAOSLISO
     C     WAOSPLZB      ANDGE     AMPOLZ
     C                   MOVEL(P)  WAOSRLTN      WKRLTN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  XML Erzeugen                                                      ***
     C**************************************************************************
     C     ERAUFRDRFL    BEGSR
     C*-------------------------------------------------------------------------
     C                   EXSR      INIDRFL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKDRFLPGNA    EXDRFLPGNA
     C                   MOVEL     WKDRFLPGST    EXDRFLPGST
     C                   MOVEL     WKDRFLBLOC    EXDRFLBLOC
     C                   MOVEL(P)  DASPCD        EXDRFLSPCD
     C                   Z-ADD     WKDRFLKOPI    EXDRFLKOPI
     C*
     C                   MOVEL(P)  'AFVS'        EXDRFLDANA
     C                   Z-ADD     AVKMJJ        EXDRFLJAHR
     C                   MOVEL(P)  AVKMNR        EXDRFLNMKR
     C                   MOVEL(P)  DAFIRM        EXDRFLFIRM
     C                   MOVEL(P)  ASSPED        EXDRFLKDLI
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*----------------------------------------------------------
     C     EXDRFLBLOC    WHENEQ    'MODWAOHEADER'
     C     1             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##BARC    '  EXDRFLALPF
     C                   MOVEL(P)  PTBARC        EXDRFLALPH
     C     2             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##LGEB    '  EXDRFLALPF
     C                   MOVEL(P)  WKLGEB        EXDRFLALPH
     C     3             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##FACH    '  EXDRFLALPF
     C                   MOVEL(P)  WKFACH        EXDRFLALPH
     C     4             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##REFN    '  EXDRFLALPF
     C                   EVAL      EXDRFLALPH  = '0' + AVDPDN
     C     5             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##GSTL    '  EXDRFLALPF
     C                   EVAL      EXDRFLALPH  = %TRIM(WKGST1)                  GESCHÄFTSSTELLE
     C     WKGST2        IFNE      *BLANK
     C                   EVAL      EXDRFLALPH  = %TRIM(WKGST2) + '/' +
     C                                           %TRIM(WKGST1)
     C                   ENDIF
     C     6             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##KTNR    '  EXDRFLALPF
     C                   MOVEL     *BLANK        EXDRFLALPH
     C     WKKTNR        IFNE      *BLANK
     C                   EVAL      EXDRFLALPH  = '(-' + %TRIM(WKKTNR) + ')'     HUBKETTE
     C                   ENDIF
     C     WKKTN2        IFNE      *BLANK
     C                   EVAL      EXDRFLALPH  = '(' + %TRIM(WKKTN2) + ')' +
     C                                           '(-' + %TRIM(WKKTNR) + ')'
     C                   ENDIF
     C     7             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##TOUR    '  EXDRFLALPF
     C                   MOVEL     WKTOUR        EXDRFLALPH
     C     8             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##TNTPROD '  EXDRFLALPF
     C                   MOVEL     PTTNTPROD     EXDRFLALPH
     C     9             OCCUR     EXXMLALPH
     C                   MOVEL(P)  '##RLTN    '  EXDRFLALPF
     C                   MOVEL     WKRLTN        EXDRFLALPH
     C*----------------------------------------------------------
     C     EXDRFLBLOC    WHENEQ    'MODWAOFOOTER'
     C*----------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      ERDRFL
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        PTBARC          +18
     C     *LIKE         DEFINE    WKC001        PTTNTPROD       +14
     C     *LIKE         DEFINE    WKC001        WKIGST                         IND.GESCHÄFTSSTELLE
     C     *LIKE         DEFINE    WKC001        WKKTN2          + 1            KETTE
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        I3              + 2
     C     *LIKE         DEFINE    WKN010        I4              + 2
     C     *LIKE         DEFINE    WKN010        WKZUGR          + 1
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C     *LIKE         DEFINE    DAPROG        WKPROG
     C     *LIKE         DEFINE    DABIBL        WKBIBL
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        PCPGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD                         RETURNCODE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    EXDRFLPGNA    WKDRFLPGNA
     C     *LIKE         DEFINE    EXDRFLKOPI    WKDRFLKOPI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOBLGEB      WKLGEB
     C     *LIKE         DEFINE    WAOBABFA      WKFACH
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOIGENR      WKGST1          + 1            Gesch.Stelle 1
     C     *LIKE         DEFINE    WAOIGENR      WKGST2                         Gesch.Stelle 2
     C     *LIKE         DEFINE    WAOITOUR      WKTOUR                         Tour
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOJKTNR      WKKTNR
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB1
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB2
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOSRLTN      WKRLTN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHLAND
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOB
     C/COPY QCPYSRC,CHWAOH
     C/COPY QCPYSRC,CHWAOI
     C/COPY QCPYSRC,CHWAOJ
     C/COPY QCPYSRC,CHWAOS
     C/COPY QCPYSRC,ERDRFL
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
