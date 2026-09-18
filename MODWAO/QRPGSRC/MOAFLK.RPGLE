     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2013 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 16.02.2013 Projekt 9024 IC-Abwicklung
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 08.07.2016 Projekt 11998 Schnittstelle LFS
     H*
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     F*  Ermitteln LS-Nr aus IC-Abwicklung LS-Zuordnung (BEAL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFLK          E DS                  INZ
     D KYAFLK        E DS                  INZ
     D*
     D IFKM          E DS                  INZ
     D KYIFKM        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D EXAFLK01      E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXBEAL        E DS                  INZ
     D RTBEAL        E DS                  INZ
     D*
     D EXTREND       E DS
     D RTTREND       E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
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
     C***  PROGRAMMSTEUERUNG                                                 ***
     C**************************************************************************
     C                   SELECT
     C*--------------------------------------------------------
     C     EXTRNDPROG    WHENEQ    'TRAB33'
     C                   EXSR      TRAB33
     C*--------------------------------------------------------
     C     EXTRNDPROG    WHENEQ    'XLAFLK00'
     C                   EXSR      XLAFLK00
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C* Füllen Datenstationsarbeitsbereich *LDA
     C*-------------------------------------------------------------------------
     C     EXBEALFIRM    IFNE      DAFIRM
     C     EXBEALFIRM    ANDNE     *BLANK
     C                   MOVEL     EXBEALFIRM    EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEL     EXFIRMFIRM    DAFIRM
     C                   MOVEL     EXFIRMSPCD    DASPCD
     C                   MOVEL     EXFIRMJAKZ    DAJNKZ
     C                   MOVEL     EXFIRMNEKZ    DANEKZ
     C                   OUT       EXTRLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   RETURN
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER EXTREND                         ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*-------------------------------------------------------------------------
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
     C                   MOVEL     EXTRNDDATE    AFLK
     C*-------------------------------------------------------------------------
     C* Ermitteln Drucker aus IF-Briefkasten Auslagerung
     C*-------------------------------------------------------------------------
     C                   MOVEL     KLFIRM        KYIFKMFIRM
     C                   MOVEL     'AFKM'        KYIFKMDANA
     C                   Z-ADD     KLKMJJ        KYIFKMJAHR
     C                   MOVEL     KLKMNR        KYIFKMNMKR
     C                   MOVEA     '03C'         CHI
     C                   EXSR      CHIFKM
     C*-------------------------------------------------------------------------
     C* Ermitteln Bezug-LS-Nr
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXBEAL
     C                   MOVEL     'EBZLI '      EXBEALPGST
     C                   MOVEL     KLFIRM        EXBEALFIRM
     C                   Z-ADD     KLLIJJ        EXBEALLIJJ
     C                   MOVEL     KLLINR        EXBEALLINR
     C*
     C                   CALL      'TRBEAL'
     C                   PARM                    EXBEAL
     C                   PARM                    RTBEAL
     C*-------------------------------------------------------------------------
     C* Füllen Datenstationsarbeitsbereich *LDA
     C*-------------------------------------------------------------------------
     C     RTBEALBZFI    IFNE      DAFIRM
     C     RTBEALBZFI    ANDNE     *BLANK
     C                   MOVEL     RTBEALBZFI    EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEL     EXFIRMFIRM    DAFIRM
     C                   MOVEL     EXFIRMSPCD    DASPCD
     C                   MOVEL     EXFIRMJAKZ    DAJNKZ
     C                   MOVEL     EXFIRMNEKZ    DANEKZ
     C                   OUT       EXTRLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKEN LIEFERSCHEIN                                              ***
     C**************************************************************************
     C     TRAB33        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTBEALBZFI    KYKLFI
     C                   Z-ADD     RTBEALBZLJ    KYKLJH
     C                   MOVEL     RTBEALBZLI    KYKLLI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      DAJNKZ
     C                   MOVEL     KLFIRM        KYAKFI
     C                   Z-ADD     KLAFJJ        KYAKJH
     C                   MOVEL     KLAFNR        KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   CLEAR                   EXAFLK01
     C                   Z-ADD     KLLIJJ        EXKL01LIJ1
     C                   MOVEL(P)  KLLINR        EXKL01LIN1
     C                   MOVEL(P)  AKVELS        EXKL01VEAR
     C                   MOVEL(P)  IFKMDRUC      EXKL01DRUC
     C                   MOVEL(P)  AKAFAT        EXKL01AFAT
     C                   MOVEL(P)  AKWKNR        EXKL01WKNR
     C                   MOVEL(P)  DAJNKZ        EXKL01DANZ
     C                   MOVEL(P)  DAJNKZ        EXKL01SBMJ
     C     EXTRNDPGST    IFEQ      'IFIFKM'
     C                   MOVEL(P)  DANEKZ        EXKL01DANZ
     C                   MOVEL(P)  *OFF          EXKL01DRSD
     C                   MOVEL(P)  DANEKZ        EXKL01SBMJ
     C                   ENDIF
     C*
     C                   CALL      'DRAFLK01'
     C                   PARM                    EXAFLK01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  XML-AUSGABE LIEFERSCHEIN                                          ***
     C**************************************************************************
     C     XLAFLK00      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTBEALBZFI    KYKLFI
     C                   Z-ADD     RTBEALBZLJ    KYKLJH
     C                   MOVEL     RTBEALBZLI    KYKLLI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C                   CLEAR                   EXAFLK01
     C                   Z-ADD     KLLIJJ        EXKL01LIJ1
     C                   MOVEL(P)  KLLINR        EXKL01LIN1
     C                   MOVEL(P)  'V'           EXKL01VEAR
     C*
     C                   CALL      'DRAFLK01  '
     C                   PARM                    EXAFLK01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
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
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHIFKM
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
