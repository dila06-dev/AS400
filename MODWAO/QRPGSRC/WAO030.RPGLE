     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Etikett Schenker
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 06.06.2011 WAECO, Projekt 7485
     H*  -----------------------------------------------------------------------
     H*  Änderung: VU 10.06.2011 WAECO, Projekt 7485, Zugriffe Routingdateien
     H*  Änderung: SZ 14.06.2011 WAECO, Projekt 7485
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm erstellt das Etikett für Spedition Schenker
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFSP          E DS                  INZ
     D KYAFSP        E DS                  INZ
     D*
     D AFVS          E DS                  INZ
     D KYAFVS        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
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
     D WERK          E DS                  INZ
     D KYWERK        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXW021        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
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
     C                   EXSR      UEBDTA
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C                   EXSR      ANFANG                                       ANFANGSROUTINE
     C                   EXSR      ETRPA                                        PARAMETERWERTE
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VAFSP
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
     C                   Z-ADD     *ZERO         WKN110           11 0
     C                   Z-ADD     *ZERO         WKN112           11 2
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYASFI                         AFSP
     C                   MOVEL(P)  DAFIRM        KYAVFI                         AFVS
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYWAOHFIRM                     WAOH
     C                   MOVEL(P)  DAFIRM        KYWAOIFIRM                     WAOI
     C                   MOVEL(P)  DAFIRM        KYWAOJFIRM                     WAOJ
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        #CDATV
     C                   MOVEL(P)  '*ISO'        #CFMTV
     C                   MOVEL(P)  '*DMY'        #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVEL     #CDATN        WKDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME PARAMETERDATEN                                         ***
     C**************************************************************************
     C     UEBDTA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      DUC004      = %SUBST(EXTRNDKEYB : 1 : 4)
     C                   Z-ADD     DUN040        WKJAHR
     C                   EVAL      WKNUMM      = %SUBST(EXTRNDKEYB : 5 : 6)
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   EVAL      RTTRNDFENR  = '0000'
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIGST                         IND.GESCHÄFTSSTELLE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKTN2          + 1            KETTE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKANZA          + 3            ANZAHL
     C     *LIKE         DEFINE    WKN010        WKANZG          + 5            ANZAHL GESAMT
     C     *LIKE         DEFINE    WKN010        WKDATE          + 5            DATUM
     C     *LIKE         DEFINE    WKN010        WKZUGR          + 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ASJAHR        WKJAHR
     C     *LIKE         DEFINE    ASNUMM        WKNUMM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOIGENR      WKGST1          + 1            Gesch.Stelle 1
     C     *LIKE         DEFINE    WAOIGENR      WKGST2                         Gesch.Stelle 2
     C     *LIKE         DEFINE    WAOITOUR      WKTOUR                         Tour
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WAOJKTNR      WKKTNR
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB1
     C     *LIKE         DEFINE    WAOJHUBN      WKHUB2
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN POSITIONEN AFVS                                         ***
     C**************************************************************************
     C     AAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     0             WKANZG
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAVKJ
     C                   MOVEL(P)  ASNUMM        KYAVKM
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFVS
     C*--------------------------------------------------------
     C                   IF        AVFIRM     <> KYAVFI        OR               OBERGRENZE
     C                             AVKMJJ     <> KYAVKJ        OR               ERREICHT
     C                             AVKMNR     <> KYAVKM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             WKANZG
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN POSITIONEN AFVS                                         ***
     C**************************************************************************
     C     EAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             WKANZA
     C*-------------------------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAVKJ
     C                   MOVEL(P)  ASNUMM        KYAVKM
     C                   Z-ADD     *ZERO         KYAVPO
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHAFVS
     C*-------------------------------------------------------------------------
     C                   DOW       WKFENR      = *ZERO
     C*--------------------------------------------------------
     C                   IF        AVFIRM     <> KYAVFI        OR               OBERGRENZE
     C                             AVKMJJ     <> KYAVKJ        OR               ERREICHT
     C                             AVKMNR     <> KYAVKM
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      DRUCK
     C                   ADD       1             WKANZA
     C*--------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHAFVS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN AFSP                                                  ***
     C**************************************************************************
     C     VAFSP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKJAHR        KYASJH
     C                   MOVEL(P)  WKNUMM        KYASNR
     C                   MOVEL(P)  'KMNR'        KYASKA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFSP
     C*--------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYWRNR                         WERKSADRESS-
     C                   MOVEA     '01C     '    CHI                            DATEI
     C                   EXSR      CHWERK
     C*--------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAMJH
     C                   MOVEL(P)  ASNUMM        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*-------------------------------------------------------------------------
     C                   EXSR      EGSTL
     C                   EXSR      AAFVS
     C                   EXSR      EAFVS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCK ETIKETT                                                     ***
     C**************************************************************************
     C     DRUCK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     81            EXW021FANR
     C                   Z-ADD     0611          EXW021BRIE
     C                   Z-ADD     1             EXW021E1ZE
     C                   Z-ADD     72            EXW021OVFP
     C                   Z-ADD     0             EXW021MITA
     C                   Z-ADD     1             EXW021OVFS
     C                   Z-ADD     1             EXW021ABZE
     C                   Z-ADD     1             EXW021LIDR
     C                   Z-ADD     146           EXW021BREI
     C*--------------------------------------------------------
     C                   EVAL      EXW021F012  = %TRIM(%EDITW(WKDATE :          DATUM
     C                                            '0 .  .  '))
     C                   EVAL      EXW021F032  = %TRIM(WKGST1)                  GESCHÄFTSSTELLE
     C*
     C                   IF        WKGST2     <> *BLANK
     C                   EVAL      EXW021F032  = %TRIM(WKGST2) + '/' +
     C                                           %TRIM(WKGST1)
     C                   ENDIF
     C*
     C                   EVAL      EXW021F042  = %CHAR(WKANZA)                  ANZAHL AUFKL
     C*
     C                   IF        WKKTNR     <> *BLANK
     C                   EVAL      EXW021F043  = '(-' + %TRIM(WKKTNR) + ')'     HUBKETTE
     C                   ENDIF
     C*
     C                   IF        WKKTN2     <> *BLANK
     C                   EVAL      EXW021F043  = '(' + %TRIM(WKKTN2) + ')' +
     C                                           '(-' + %TRIM(WKKTNR) + ')'
     C                   ENDIF
     C*
     C                   EVAL      EXW021F044  = %TRIM(%EDITC(AVGWBR : 'M'))    GEWICHT
     C                   EVAL      EXW021F045  = %TRIM(%EDITC(WKANZG : 'Z'))    ANZ. VON
     C                   EVAL      EXW021SSCC  = AVPAKN                         NVE/SSCC
     C                   EVAL      DUC019      = AVPAKN
     C                   EVAL      EXW021BARC  = DUC019                         NVE BARCODE
     C                   EVAL      EXW021ABFA  = WKTOUR                         NAHVERKEHRSTOUR
     C                   EVAL      EXW021F008  = %TRIM(%EDITC(WKANZA : 'Z'))    LFD.ANZAHL
     C                   EVAL      EXW021F011  = '0' + AVDPDN                   REFERENZ
     C*--------------------------------------------------------
     C* EMPFÄNGER
     C*--------------------------------------------------------
     C                   MOVEL(P)  AMNAM1        EXW021ADR1
     C                   MOVEL(P)  AMNAM2        EXW021ADR2
     C                   MOVEL(P)  AMSTRA        EXW021STRA
     C                   MOVEL(P)  AMPOLD        EXW021POLD
     C                   MOVEL(P)  AMPOLZ        EXW021POLZ
     C                   MOVEL(P)  AMWORT        EXW021WORT
     C*--------------------------------------------------------
     C* ABSENDER: WAECO
     C*--------------------------------------------------------
     C                   MOVEL(P)  WRNAM1        EXW021ABS1
     C                   MOVEL(P)  WRNAM2        EXW021ABS2
     C                   MOVEL(P)  WRSTRA        EXW021ASTR
     C                   MOVEL(P)  WRPOLZ        EXW021APLZ
     C                   MOVEL(P)  WRWORT        EXW021AORT
     C*--------------------------------------------------------
     C                   CALL      'WAO031'
     C                   PARM                    EXW021
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN GESCHÄFTSSTELLEN/TOUR                                   ***
     C**************************************************************************
     C     EGSTL         BEGSR
     C*
     C                   EVAL      WKGST1      = *BLANK
     C                   EVAL      WKGST2      = *BLANK
     C                   EVAL      WKTOUR      = *BLANK
     C                   EVAL      WKHUB1      = *BLANK
     C                   EVAL      WKHUB2      = *BLANK
     C                   EVAL      WKKTNR      = *BLANK
     C                   EVAL      WKKTN2      = *BLANK
     C                   EVAL      WKIGST      = *OFF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOHPOLZ  = AMPOLZ                         PLZ PRÜFEN
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOH
     C*--------------------------------------------------------
     C                   IF        WKFENR     <> *ZERO
     C                   EVAL      WKTOUR      = '950'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOIGENR  = '84'                           Schenker Osnabrück
     C                   EVAL      KYWAOIPOLZ  = AMPOLZ
     C*-------------------------------------------------------------------------
     C     1             DO        3             WKZUGR
     C                   MOVEA     '01-     '    CHI
     C                   EXSR      CHWAOI
     C                   EXSR      ERWAOI
     C*--------------------------------------------------------
     C                   IF        WKIGST      = *ON                            ROUTING BEENDET
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
     C                   EVAL      WKTOUR      = '950'
     C                   EVAL      WKIGST      = *ON
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
     C                   EVAL      WKIGST      = *OFF                           NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKGST1      = WAOITOUR                       3 STELLEN !
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
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
     C                   EVAL      WKIGST      = *OFF                           NOCHMAL ZUGREIFEN
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EXSR      ERWAOJ
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EXSR      ERWAOJ
     C                   EVAL      WKIGST      = *ON
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
     C                   EVAL      WKGST1      = *BLANK                         GEFUNDENE WERTE
     C                   EVAL      WKGST2      = *BLANK                         LÖSCHEN
     C                   EVAL      WKTOUR      = '950'
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '99'
     C     WAOITOUR      ANDLT     '900'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
     C     WAOITOUR      WHENGT    '899'
     C                   EVAL      WKTOUR      = WAOITOUR
     C                   EVAL      WKIGST      = *ON
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
     C                   EVAL      KYWAOJGENR  = '84'
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C                   IF        WKFENR      = *ZERO
     C                   EVAL      WKHUB2      = WAOJHUBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EVAL      KYWAOJGENR  = WKGST1
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOJ
     C*
     C                   IF        WKFENR      = *ZERO
     C                   EVAL      WKKTNR      = WAOJKTNR
     C                   EVAL      WKHUB1      = WAOJHUBN
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKHUB1        WHENEQ    '31'
     C     WKHUB1        OREQ      '81'
     C                   EVAL      WKKTN2      = WKHUB1
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
     O**************************************************************************
     O***  COPYMODULE                                                        ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFSP
     C/COPY QCPYSRC,CHAFVS
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOH
     C/COPY QCPYSRC,CHWAOI
     C/COPY QCPYSRC,CHWAOJ
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,TRDAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
