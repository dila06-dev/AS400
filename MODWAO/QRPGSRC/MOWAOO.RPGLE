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
     H*  Erstellt: RE 25.01.2012 für Kunde WAECO
     H*  --------------------------------------------------------------
     H*
     F**************************************************************************
     F*/
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*/
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D*
     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ
     D*
     D LGPO          E DS                  INZ
     D KYLGPO        E DS                  INZ
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
     D EXWAOO        E DS                  INZ
     D RTWAOO        E DS                  INZ
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
     C     PCPGST        WHENEQ    '1     '
     C                   EXSR      PRAUFRWAOO
     C     WKFENR        IFEQ      *ZERO
     C                   EXSR      TRAUFRWAOO
     C                   ELSE
     C                   MOVEL(P)  WKFENR        RTTRNDFENR
     C                   ENDIF
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
     C                   MOVEL(P)  DAFIRM        KYLGKOFIRM
     C                   MOVEL(P)  DAFIRM        KYLGPOFIRM
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
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
     C                   MOVEL     EXTRNDPGST    EXWAOOPGST
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C                   MOVEA     KOM(01)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        EXWAOOLGJJ
     C                   MOVEA     KOM(05)       EXWAOOLGNR
     C                   MOVEA     KOM(11)       DUC005
     C                   TESTN                   DUC005               98        PRÜFUNG
     C     *IN(98)       IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        EXWAOOLGPO
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
     C***  PRÜFEN DATEI WAOO                                                 ***
     C**************************************************************************
     C     PRAUFRWAOO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXWAOOLGJJ    KYLGKOLGJJ
     C                   MOVEL(P)  EXWAOOLGNR    KYLGKOLGNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGKO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXWAOOLGJJ    KYLGPOLGJJ
     C                   MOVEL(P)  EXWAOOLGNR    KYLGPOLGNR
     C                   Z-ADD     EXWAOOLGPO    KYLGPOLGPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGPO
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     LGPOISMG      IFLE      *ZERO
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOO                                                 ***
     C**************************************************************************
     C     TRAUFRWAOO    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CALL      'TRWAOO'
     C                   PARM                    EXWAOO
     C                   PARM                    RTWAOO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTWAOOPROG    RTTRNDPROG
     C                   MOVEL(P)  RTWAOODANA    RTTRNDDANA
     C                   MOVEL(P)  RTWAOOFFLD    RTTRNDFFLD
     C                   MOVEL(P)  RTWAOOFENR    RTTRNDFENR
     C                   MOVEL(P)  RTWAOOPA03    RTTRNDPA03
     C                   MOVEL(P)  RTWAOOPA04    RTTRNDPA04
     C                   MOVEL(P)  RTWAOOPA05    RTTRNDPA05
     C                   MOVEL(P)  RTWAOOPA06    RTTRNDPA06
     C                   MOVEL(P)  RTWAOOPA07    RTTRNDPA07
     C*
     C                   MOVEL(P)  RTWAOORTCD    RTTRNDRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
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
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGPO
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O**************************************************************************
