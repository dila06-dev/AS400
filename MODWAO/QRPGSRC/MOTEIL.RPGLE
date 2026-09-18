     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 20.05.2011 Projekt 7345
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 17.04.2018 DOMETIC Projekt 13817. Beim Fehlen eines EK-Preises LP1 für den
     H*            Artikel wird dieser zunächst auf den im Parameter MODWAO/KEINLP1/TEST hinter-
     H*            legten Status gesetzt (aktuell '41' = fehlender Einkaufspreis (LP1-Preis))
     H*  Änderung: PH 09.07.2018 DOMETIC Projekt 14114-01. Ist im Identstamm keine Zolltarif-
     H*            nummer eingegeben, wird der Artikelstatus zunächst auf den im Parameter
     H*            MODWAO/KEINEZOTN/TEST hinterlegten Wert gesetzt (aktuell '42' = fehlende
     H*            Zolltarifnummer)
     H*  Änderung: PH 23.11.2020 DOMETIC Projekt 16014-01. Erweiterung der Prüfung aus dem
     H*            Projekt 13817 (s. oben): Für Artikel OHNE Stückliste gilt die bisherige
     H*            Prüfung. Hat der Artikel (Fertigware) eine Stückliste, dann werden gemäß
     H*            "Baukasten" alle Komponenten (SLPO) geprüft; fehlt dabei bei einer
     H*            Komponente ein LP1-Preis, erhält die Fertigware den im Parameter
     H*            MODWAO/KEINLP1/TEST hinterlegten Ident-Status (derzeit 41).
     H*  Änderung: GS 25.05.2021 Projekt 16577 Zusätzliche Prüfung auf Stückliste 300
     H*  Änderung: GS 28.12.2022 Dometic Projekt 220615 Aufruf MOTEIL aus TRTEIL mit dem
     H*            PGST (UTESTZ) Setzen Status "42" falls Zolltarif-Nr. fehlt.
     F**************************************************************************
     F*
     F*  Programm für die Kundenspezifische Prüfungen und Ermittlungen
     F*
     F*  Projekt 7345: Freigabe-Verfahren
     F*                Bei der Bearbeitung durch das Controlling wird der Status
     F*                automatisch auf '81' gesetzt
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SFLBFMT         S                   DIM(99) INZ LIKE(TRPBBFMT)           FORMAT
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D PREI          E DS                  INZ
     D KYPREI        E DS                  INZ

     D SLKO          E DS                  INZ
     D KYSLKO        E DS                  INZ

     D SLPO          E DS                  INZ
     D KYSLPO        E DS                  INZ
     D*
     D TEAF          E DS                  INZ
     D KYTEAF        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEVP          E DS                  INZ
     D KYTEVP        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPB          E DS                  INZ
     D KYTRPB        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
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
     C     PCPGST        WHENEQ    'PTEAF '
     C                   EXSR      PTEAF
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'PTEVP '
     C                   EXSR      PTEVP
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UTEST '
     C                   EXSR      PTEAF
     C                   EXSR      UTEIL
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'UTEVP '
     C                   EXSR      PTEVP
     C                   EXSR      UTEIL
     C*--------------------------------------------------------
     C*    Setzen Status "42" (Zolltarif-Nr fehlt) bei Aufruf aus TRTEIL.
     C     PCPGST        WHENEQ    'UTESTZ'
     C                   MOVEL     '42'          RTTRNDTEST
     C                   EXSR      UTEIL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        WKFIRM
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
     C                   MOVEL(P)  DAFIRM        KYPRFI                         PREI
     C                   EVAL      KYSKFI = DAFIRM                              SLKO
     C                   EVAL      KYSPFI = DAFIRM                              SLPO
     C                   MOVEL(P)  DAFIRM        KYTEAFFIRM                     TEAF
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTEVPFIRM                     TEVP
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTRPBFIRM                     TRPB
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
     C                   EVAL      EXTRNDTENR  = %SUBST(EXTRNDKEYB:1:15)
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
     C***  KUNDENSPEZIFISCHE PRÜFUNG                                         ***
     C**************************************************************************
     C     PTEAF         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        RTTRNDTEST
     C                   EVAL      KYTENR = EXTRNDTENR
     C                   EVAL      CHIDS = '01C'
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   DO        99            I0
     C*-------------------------------------------------------------------------
     C     SFLBFMT(I0)   IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*Prüfung der 100 er Stückliste
     C                   EVAL      WKSKAT = '100'
     C                   EXSR      PRSLKOSLPO
     C                   IF        RTTRNDTEST <> *BLANK
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C*Prüfung der 300 er Stückliste
     C                   EVAL      WKSKAT = '300'
     C                   EXSR      PRSLKOSLPO
     C                   IF        RTTRNDTEST <> *BLANK
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        TEZOTN = *BLANK
     C                   EVAL      RTTRNDTEST = WKKZOTTEST
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  EXTRNDTENR    KYTEAFTENR
     C                   MOVEL(P)  SFLBFMT(I0)   KYTEAFBFMT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEAF
     C                   MOVE      *ZERO         WKFENR
     C*
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL(P)  WKTEABTEST    RTTRNDTEST
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     RTTRNDTEST    IFEQ      *BLANK
     C                   MOVEL(P)  WKTEAFTEST    RTTRNDTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     WKFENR        RTTRNDFENR
     C                   MOVEL     RTTRNDTEST    RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Prüfen ob in der Stückliste für die Komponenten Preise da sind    ***
     C**************************************************************************
     C     PRSLKOSLPO    BEGSR
     C*
     C*--------------------------------------------------------
     C                   EVAL      KYSKAT = WKSKAT
     C                   EVAL      KYSKTE = EXTRNDTENR
     C                   EVAL      KYSKVA = *BLANK
     C                   EVAL      CHIDS = '01+'
     C                   EXSR      CHSLKO
     C                   IF        CHI(5) <> 'J'
     C                             OR SKSLAT <> KYSKAT
     C                             OR SKTENR <> KYSKTE
                         // Der Artikel hat keine Stückliste
     C                   CLEAR                   KYPREI
     C                   EVAL      KYPRFI = DAFIRM
     C                   EVAL      KYPRBG = 'LP1'
     C                   EVAL      KYPRTE = EXTRNDTENR
     C                   EVAL      CHIDS = '02+'
     C                   EXSR      CHPREI
     C                   IF        CHI(5) = 'N'
     C                             OR PRFIRM <> KYPRFI
     C                             OR PRBEGR <> KYPRBG
     C                             OR PRTENR <> KYPRTE
     C                   EVAL      RTTRNDTEST = WKKLP1TEST
     C                   LEAVESR
     C                   ENDIF

     C                   ELSE

                         // Der Artikel hat eine Stückliste
     C                   EVAL      KYSKAT = WKSKAT
     C                   EVAL      KYSKTE = EXTRNDTENR
     C                   EVAL      KYSKVA = *BLANK
     C                   EVAL      CHIDS = '01+'
     C                   EXSR      CHSLKO
     C                   DOW       CHI(5) = 'J'
     C                             AND SKSLAT = KYSKAT
     C                             AND SKTENR = KYSKTE

     C                   EVAL      KYSPAT = SKSLAT
     C                   EVAL      KYSPVK = SKVARK
     C                   EVAL      KYSPTE = SKTENR
     C                   EVAL      KYSPBT = *BLANK
     C                   EVAL      KYSPHP = *ZERO
     C                   EVAL      KYSPVA = *BLANK
     C                   EVAL      KYSPKT = *BLANK
     C                   EVAL      KYSPDA = *ZERO
     C                   EVAL      CHIDS = '01+'
     C                   EXSR      CHSLPO
     C                   DOW       CHI(5) = 'J'
     C                             AND SPSLAT = KYSPAT
     C                             AND SPVARK = KYSPVK
     C                             AND SPTENR = KYSPTE

                         // Eine Komponente hat keinen LP1-Preis
     C                   CLEAR                   KYPREI
     C                   EVAL      KYPRFI = DAFIRM
     C                   EVAL      KYPRBG = 'LP1'
     C                   EVAL      KYPRTE = SPKOTE
     C                   EVAL      CHIDS = '02+'
     C                   EXSR      CHPREI
     C                   IF        CHI(5) = 'N'
     C                             OR PRFIRM <> KYPRFI
     C                             OR PRBEGR <> KYPRBG
     C                             OR PRTENR <> KYPRTE
     C                   EVAL      RTTRNDTEST = WKKLP1TEST
     C                   LEAVESR
     C                   ENDIF

     C                   EVAL      CHIDS = '01R'
     C                   EXSR      CHSLPO
     C                   ENDDO

     C                   EVAL      CHIDS = '01R'
     C                   EXSR      CHSLKO
     C                   ENDDO

     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KUNDENSPEZIFISCHE PRÜFUNG "KATALOGARTIKEL"                        ***
     C**************************************************************************
     C     PTEVP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     TELANG        IFEQ      *ZERO
     C     TEBREI        OREQ      *ZERO
     C     TEHOHE        OREQ      *ZERO
     C     TEGWNT        OREQ      *ZERO
     C     TEGWBR        OREQ      *ZERO
     C     TEVOLU        OREQ      *ZERO
     C                   MOVEL(P)  '84'          RTTRNDTEST
     C                   ELSE
     C                   MOVEL(P)  TETEST        RTTRNDTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDTENR    KYTEVPTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEVP
     C*
     C     TEVPLAMM      IFEQ      *ZERO
     C     TEVPBRMM      OREQ      *ZERO
     C     TEVPHOMM      OREQ      *ZERO
     C     TEVPVOLU      OREQ      *ZERO
     C     TEVPIVPE      OREQ      *ZERO
     C     TEVPSTGW      OREQ      *ZERO
     C                   MOVEL(P)  '84'          RTTRNDTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVEL     WKFENR        RTTRNDFENR
     C                   MOVEL     RTTRNDTEST    RTTRNDDATE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TEIL                                                 ***
     C**************************************************************************
     C     UTEIL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDTENR    KYTENR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTTRNDTEST    TETEST
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        TEJNAM
     C                   MOVEL(P)  DAPROG        TEPROG
     C                   MOVEL(P)  WKCHPL        TEBIBL
     C                   MOVEL(P)  DAUSER        TEUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        TEJZEI
     C                   MOVE      WKTDAT        TEJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   ENDSL
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
     C                   MOVEL(P)  'MOTEIL'      KYTATA
     C                   MOVEL(P)  'TEAB'        KYTATC
     C                   MOVEL(P)  'ABTL'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTEAFABTL
     C*
     C     WKTEAFABTL    IFEQ      *BLANK
     C                   MOVE      *BLANK        WKTEAFABTL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MOTEIL'      KYTATA
     C                   MOVEL(P)  'TEAB'        KYTATC
     C                   MOVEL(P)  'TEST'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTEAFTEST
     C*
     C     WKTEAFTEST    IFEQ      *BLANK
     C                   MOVE      '90'          WKTEAFTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'KEINLP1'     KYTATC
     C                   MOVEL(P)  'TEST'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKKLP1TEST
     C*
     C     WKKLP1TEST    IFEQ      *BLANK
     C                   MOVEL(P)  '41'          WKKLP1TEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'KEINEZOTN'   KYTATC
     C                   MOVEL(P)  'TEST'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKKZOTTEST
     C*
     C     WKKZOTTEST    IFEQ      *BLANK
     C                   MOVEL(P)  '42'          WKKZOTTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEIL'      KYTATA
     C                   MOVEL(P)  'TEAB'        KYTATC
     C                   MOVEL(P)  'TEST'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTEABTEST
     C*
     C     WKTEABTEST    IFEQ      *BLANK
     C                   MOVE      '90'          WKTEABTEST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Programm-Zuordnung Abteilung "Controlling"
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRPBBFMT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PROGRAMM-ZUORDNUNG ABTEILUNG "CONTROLLING"              ***
     C**************************************************************************
     C     ETRPBBFMT     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I0
     C                   MOVE      *BLANK        SFLBFMT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRTEILFM'    KYTRPBBPRG
     C                   MOVEL(P)  WKTEAFABTL    KYTRPBABTL
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHTRPB
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     TRPBBPRG      ANDEQ     KYTRPBBPRG
     C     TRPBBUSR      ANDEQ     KYTRPBBUSR
     C     TRPBWKNR      ANDEQ     KYTRPBWKNR
     C     TRPBABTL      ANDEQ     KYTRPBABTL
     C*--------------------------------------------------------
     C     I0            IFLT      99
     C     TRPBAKKZ      ANDEQ     DAJNKZ
     C     TRPBVWKZ      ANDEQ     DAJNKZ
     C                   ADD       1             I0
     C                   MOVEL(P)  TRPBBFMT      SFLBFMT(I0)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '04R     '    CHI
     C                   EXSR      CHTRPB
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSLPO
     C     *LIKE         DEFINE    WKC001        WKTEABTEST      + 1
     C*
     C     *LIKE         DEFINE    WKC001        WKTEAFABTL      + 2
     C     *LIKE         DEFINE    WKC001        WKTEAFTEST      + 1
     C     *LIKE         DEFINE    WKC001        WKKLP1TEST      + 1
     C     *LIKE         DEFINE    WKC001        WKKZOTTEST      + 1
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
     C     *LIKE         DEFINE    KYTENR        EXTRNDTENR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TETEST        RTTRNDTEST
     C     *LIKE         DEFINE    KYSKAT        WKSKAT
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
     C/COPY QCPYSRC,CHPREI
     C/COPY QCPYSRC,CHSLKO
     C/COPY QCPYSRC,CHSLPO
     C/COPY QCPYSRC,CHTEAF
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEVP
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRPB
     C/COPY QCPYSRC,EXJOBA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
