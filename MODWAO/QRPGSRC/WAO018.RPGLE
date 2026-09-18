     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2001')
     H**************************************************************************
     H/TITLE  Etikett TNT
     H**************************************************************************
     H*  Copyright 2001 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: SZ 03.01.2011 WAECO
     H*  -----------------------------------------------------------------------
     H*  Änderung:
     H*
     F**************************************************************************
     F*
     F*  Dieses Programm erstellt das Etikett für TNT.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO018DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
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
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D  WKDATE         S               D   DATFMT(*EUR) INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
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
     C                   MOVEL(P)  DAFIRM        KYWRFI                         WERK
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        #CDATV
     C                   MOVEL(P)  '*ISO'        #CFMTV
     C                   MOVEL(P)  '*DMY'        #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVEL     #CDATN        PTDATE
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
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ASJAHR        WKJAHR
     C     *LIKE         DEFINE    ASNUMM        WKNUMM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN POSITIONEN AFVS                                         ***
     C**************************************************************************
     C     EAFVS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         PTGWBR
     C                   Z-ADD     *ZERO         PTANZA
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
     C                   ADD       AVGWBR        PTGWBR
     C                   ADD       AVANZA        PTANZA
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
     C*-------------------------------------------------------------------------
     C                   EXSR      EAFVS
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  ASWKNR        KYWRNR                         WERKSADRESS-
     C                   MOVEA     '01C     '    CHI                            DATEI
     C                   EXSR      CHWERK
     C*
     C                   MOVEL(P)  WRNAM1        PTWERKNAM1
     C                   MOVEL(P)  WRNAM2        PTWERKNAM2
     C                   MOVEL(P)  WRNAM3        PTWERKNAM3
     C                   MOVEL(P)  WRSTRA        PTWERKSTRA
     C                   MOVEL(P)  WRPOLZ        PTWERKPOLZ
     C                   MOVEL(P)  WRWORT        PTWERKWORT
     C*--------------------------------------------------------
     C                   Z-ADD     ASJAHR        KYAMJH
     C                   MOVEL(P)  ASNUMM        KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*
     C                   MOVEL(P)  AMKDNR        PTKDNR
     C                   MOVEL(P)  AMKMNR        PTKMNR
     C                   MOVEL(P)  AMNAM1        PTAFADNAM1
     C                   MOVEL(P)  AMNAM2        PTAFADNAM2
     C                   MOVEL(P)  AMNAM3        PTAFADNAM3
     C                   MOVEL(P)  AMSTRA        PTAFADSTRA
     C                   MOVEL(P)  AMPOLD        PTAFADPOLD
     C                   MOVEL(P)  AMPOLZ        PTAFADPOLZ
     C                   MOVEL(P)  AMWORT        PTAFADWORT
     C*-------------------------------------------------------------------------
     C                   WRITE     EXDR00
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
     C/COPY QCPYSRC,CHWERK
     C/COPY QCPYSRC,TRDAUM
     C*
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
