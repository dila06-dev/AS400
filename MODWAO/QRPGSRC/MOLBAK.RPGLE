     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Verwalten Auslagerung
     H**************************************************************************
     H*  Copyright 2005 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 01.07.2005 Weaco Projekt 2984
     H*  Änderung: ZG 22.06.2010 Weaco Projekt 6231
     H*  Änderung: ZG 13.12.2010 Weaco Projekt 6990 Versand-Umstellung
     H*  Änderung: ZG 20.09.2011 Weaco Projekt 7595 - Erweiterungen der Versand-Anzeige
     H*  -----------------------------------------------------------------------
     H*
     F**************************************************************************
     F*
     F*  Im Programm werden die BGFS-Ls für Sammel-Pickliste rückgemeldet.
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
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D LBAK          E DS                  INZ
     D KYLBAK        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D LBPC          E DS                  INZ
     D KYLBPC        E DS                  INZ
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
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXLBVS        E DS                  INZ
     D RTLBVS        E DS                  INZ
     D*
     D EXSFLBAK      E DS                  INZ
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D/COPY QCPYSRC,EXUX01
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
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C                   SELECT
     C*--------------------------------------------------------
     C     PCPGST        WHENEQ    'LIBGFS'                                     LS-BGFS
     C                   EXSR      UXOPENWAO1
     C                   EXSR      UXWRTEWAO1
     C                   EXSR      UXREADWAO1
     C                   EXSR      EXUXCLOS
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     *BLANK        RTTRNDPRKZ
     C                   MOVEL     *BLANK        RTTRNDKEYB
     C                   MOVEL     *BLANK        RTTRNDDATE
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    'PRVSBD'                                     Pruefen VSBD
     C                   EXSR      PRVSBD
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    'ADUMM '                                     Erm.Felder für die
     C                   EXSR      ADUMM                                        Anzeige
     C*-------------------------------------------------------------------------
     C     PCPGST        WHENEQ    'ERSBFL'
     C                   EXSR      ERSBFL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   RETURN
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXTRNDPGST    PCPGST
     C*
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA(P)  KOM(01)       KYLBAKDANA
     C*
     C                   MOVEA     KOM(11)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        KYLBAKJAHR
     C                   Z-ADD     DUN040        #KOMJAHR
     C*
     C                   MOVEA(P)  KOM(15)       KYLBAKNMKR
     C                   MOVEA(P)  KOM(15)       #KOMNMKR
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C*-------------------------------------------------------------------------
     C*
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
     C                   MOVEL(P)  DAFIRM        WKFIRM                         *LDA-FELDER
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN                         PROGR
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL                         BIBL.
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYWAO1FIRM                     WAO1
     C                   MOVEL     DAFIRM        KYLBAKFIRM                     LBAK
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM                     LBAP
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     PCPGST        WHENEQ    'ADUMM '
     C                   MOVEL     EXTRNDDATE    LBAK
     C     PCPGST        WHENEQ    'ERSBFL'
     C                   MOVEL     EXTRNDDATE    LBAK
     C                   OTHER
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBAK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   CLEAR                   RTTREND
     C                   MOVE      *ZERO         RTTRNDFENR
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPENWAO1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'BGFSLBAK  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 20
     C                   EVAL      EXUX01KYLG = 20                                MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung LS-Auslagerung '
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXWRTEWAO1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYLBAKDANA    KYWAO1DANA
     C                   Z-ADD     KYLBAKJAHR    KYWAO1JAHR
     C                   MOVEL     KYLBAKNMKR    KYWAO1NMKR
     C                   Z-ADD     *ZERO         KYWAO1POSI
     C                   Z-ADD     *ZERO         KYWAO1LIJJ
     C                   MOVEL     *BLANK        KYWAO1LINR
     C                   Z-ADD     *ZERO         KYWAO1RALP
     C                   MOVEA     '03+     '    CHI                            LESEN AFPO
     C                   EXSR      CHWAO1
     C*--------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*--------------------------------------------------------
     C     WAO1FIRM      IFNE      KYWAO1FIRM
     C     WAO1DANA      ORNE      KYWAO1DANA
     C     WAO1JAHR      ORNE      KYWAO1JAHR
     C     WAO1NMKR      ORNE      KYWAO1NMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'BGFS'        KYLBAPDANA
     C                   Z-ADD     WAO1LIJJ      KYLBAPJAHR
     C                   MOVEL     WAO1LINR      KYLBAPNMKR
     C                   Z-ADD     WAO1RALP      KYLBAPPOSI
     C                   MOVEA     '01C     '    CHI                            LESEN AFPO
     C                   EXSR      CHLBAP
     C*--------------------------------------------------------
     C     CHI(5)        IFEQ      'J'
     C     LBAPSTAT      ANDLT     '89'
     C*
     C                   Z-ADD     WAO1LIJJ      DUN040
     C*
     C                   EVAL      WKSORT =  KYLBAPDANA + DUC004 +
     C                             WAO1LINR
     C*
     C                   EVAL      EXUX01IDTA = WKSORT
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHWAO1
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREADWAO1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C*
     C                   EVAL      KYLBAKDANA = %SUBST(EXUX01IDTA:  1: 10)
     C                   EVAL      DUC004     = %SUBST(EXUX01IDTA: 11: 4)
     C                   Z-ADD     DUN040        KYLBAKJAHR
     C                   EVAL      KYLBAKNMKR = %SUBST(EXUX01IDTA: 15: 6)
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBAK
     C*
     C                   EXSR      CLBAK
     C*
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LIEFERSCHEIN FÜR LBAK LADELISTE                                   ***
     C**************************************************************************
     C     CLBAK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*
     C                   MOVEL(P)  'LIBGFS'      #CPGST
     C                   EXSR      TRLBAP
     C                   MOVEL     #CKOMM        WKFENR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      '90'          DSSTAT
     C                   EXSR      U1LBAK
     C*
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C                   MOVEL(P)  'LNMKR '      EXLBVSPGST
     C                   MOVEL     LBAKDANA      EXLBVSDANA
     C                   Z-ADD     LBAKJAHR      EXLBVSJAHR
     C                   MOVEL     LBAKNMKR      EXLBVSNMKR
     C                   MOVEL(P)  LBAKLANR      EXLBVSLANR
     c                   MOVEL(P)  LBAKLORT      EXLBVSLORT
     C                   CALL      'TRLBVS'                             99
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C*
     C     KYLBAKDANA    IFNE      'BGF2      '
     C                   MOVEL(P)  DAFIRM        LSDFIRM           2
     C                   MOVEL(P)  LBAKJAHR      LSDJAHR           4
     C                   MOVEL(P)  LBAKNMKR      LSDAUFT           6
     C                   MOVEL(P)  DAUSER        LSDUSER          10
     C*
     C                   CALL      'SWMLSDCL'                           9899
     C                   PARM                    LSDFIRM
     C                   PARM                    LSDJAHR
     C                   PARM                    LSDAUFT
     C                   PARM                    LSDUSER
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUFEN POSITIONEN LBAP                                          ***
     C**************************************************************************
     C     TRLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  LBAKDANA      KOM(01)
     C                   MOVE      LBAKJAHR      DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA(P)  LBAKNMKR      KOM(15)
     C                   Z-ADD     *ZERO         DUN050
     C                   MOVEA(P)  DUC005        KOM(21)
     C                   MOVEA(P)  LBAKLANR      KOM(26)
     C                   MOVE      #KOMJAHR      DUN040
     C                   MOVEA(P)  DUC004        KOM(144)
     C                   MOVEA(P)  #KOMNMKR      KOM(148)
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'TRLBAP'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE STATUS IM AUSLAGERUNGSKOPF                                 ***
     C**************************************************************************
     C     U1LBAK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHLBAK                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   MOVE      DSSTAT        LBAKSTAT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        LBAKJNAM
     C                   MOVEL(P)  WKCHPN        LBAKPROG
     C                   MOVEL(P)  WKCHPL        LBAKBIBL
     C                   MOVEL(P)  DAUSER        LBAKUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        LBAKJZEI
     C                   MOVE      WKTDAT        LBAKJDAT
     C*--------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHLBAK
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     PRVSBD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        LBAKDANA='AFKM'                                  KOMMISSIONIERUNG
     C                   Z-ADD     LBAKJAHR      KYAMJH
     C                   MOVEL     LBAPNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C                   MOVEL     AMVSBD        LBAKVSBD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'MODWAO'      KYTATA                         ERMITTELN, OB
     C                   MOVEL     'VSBDEXPO'    KYTATC                         VSBD export
     C                   MOVEL     LBAKVSBD      KYTAPA                         IST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL     *ON           RTTRNDPRKZ
     C                   ELSE
     C                   MOVEL     *OFF          RTTRNDPRKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  Erm Felder                                                        ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      KYLBAKDANA = 'BGFS'
     C                   MOVEL(P)  'ADUMM '      #CPGST
     C                   EXSR      MOWAO1
     C                   EVAL      WAO1FREI= %SUBST(RTTRNDDATE: 1: 100)
     C                   OTHER
     C                   MOVE      *BLANK        WAO1FREI
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  KYLBAKDANA    KOM(01)
     C                   MOVE      KYLBAKJAHR    DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA(P)  KYLBAKNMKR    KOM(15)
     C                   Z-ADD     *ZERO         DUN050
     C                   MOVEA(P)  DUC005        KOM(21)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'EGEWI '      #CPGST
     C*
     C                   CALL      'TRLBAP'
     C                   PARM                    EXTR02
     C                   MOVEL     #CKOMM        DUC013
     C                   TESTN                   DUC013               99        PRÜFEN ÜBERGABEWERT
     C     *IN99         IFEQ      *OFF
     C                   MOVE      *ZERO         DUC013
     C                   ENDIF
     C                   Z-ADD(H)  DUN134        DUN094
     C*-------------------------------------------------------------------------
     C                   EVAL       %SUBST(RTTRNDDATE: 1: 100)=WAO1FREI
     C                   EVAL       %SUBST(RTTRNDDATE: 101: 9)=DUC009
     C                   EVAL       %SUBST(RTTRNDDATE: 110: 8)=LBAKLORT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MOWAO1    Update WAO1                                             ***
     C**************************************************************************
     C     MOWAO1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           EXTRNDPRKZ
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           EXTRNDKEYB
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KYLBAKDANA    KOM(57)
     C                   Z-ADD     KYLBAKJAHR    DUN040
     C                   MOVEA     DUC004        KOM(67)
     C                   MOVEA     KYLBAKNMKR    KOM(71)
     C                   MOVEA     LBAKSTAT      KOM(77)
     C                   MOVEA     KOM           EXTRNDDATE
     C*
     C                   MOVEL(P)  #CPGST        EXTRNDPGST
     C*
     C                   CALL      'MOWAO1   '                          99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTTRNDPROG    WKPROG
     C                   MOVEL     RTTRNDDANA    WKDANA
     C                   MOVEL     RTTRNDFFLD    WKFFLD
     C                   MOVEL     RTTRNDFENR    WKFENR
     C                   MOVEL(P)  RTTRNDPA03    W$PA03
     C                   MOVEL(P)  RTTRNDPA04    W$PA04
     C                   MOVEL(P)  RTTRNDPA05    W$PA05
     C                   MOVEL(P)  RTTRNDPA06    W$PA06
     C                   MOVEL(P)  RTTRNDPA07    W$PA07
     C*
     C                   MOVEL(P)  RTTRNDRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MOLBAP    Update LBAP                                             ***
     C**************************************************************************
     C     MOLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           EXTRNDPRKZ
     C*
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KYLBAKNMKR    KOM(01)
     C                   Z-ADD     KYLBAKJAHR    DUN040
     C                   MOVEA     DUC004        KOM(11)
     C                   MOVEA     KYLBAKNMKR    KOM(15)
     C                   Z-ADD     *ZERO         DUN050
     C                   MOVEA     DUC005        KOM(21)
     C                   MOVEA     KOM           EXTRNDKEYB
     C*
     C                   MOVEL(P)  #CPGST        EXTRNDPGST
     C*
     C                   CALL      'MOLBAP   '                          99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTTRNDPROG    WKPROG
     C                   MOVEL     RTTRNDDANA    WKDANA
     C                   MOVEL     RTTRNDFFLD    WKFFLD
     C                   MOVEL     RTTRNDFENR    WKFENR
     C                   MOVEL(P)  RTTRNDPA03    W$PA03
     C                   MOVEL(P)  RTTRNDPA04    W$PA04
     C                   MOVEL(P)  RTTRNDPA05    W$PA05
     C                   MOVEL(P)  RTTRNDPA06    W$PA06
     C                   MOVEL(P)  RTTRNDPA07    W$PA07
     C*
     C                   MOVEL(P)  RTTRNDRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN KUNDEN-Daten                                            ***
     C**************************************************************************
     C     ERSBFL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSFLBAK
     C                   Z-ADD     *ZERO         WKJDAT
     C                   Z-ADD     *ZERO         WKJZEI
     C                   Z-ADD     *ZERO         WKGEWI
     C                   Z-ADD     *ZERO         GSGEWI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBAKDANA      KYLBPCDANA
     C                   Z-ADD     LBAKJAHR      KYLBPCJAHR
     C                   MOVEL(P)  LBAKNMKR      KYLBPCNMKR
     C                   MOVE      *LOVAL        KYLBPCPOSI
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '10+     '    CHI
     C                   EXSR      CHLBPC
     C*
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCDANA      ORNE      KYLBPCDANA
     C     LBPCJAHR      ORNE      KYLBPCJAHR
     C     LBPCNMKR      ORNE      KYLBPCNMKR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   IF        LBPCGEWI=0
     C                   ADD       LBPCRSMG      LBPCGEWI
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       LBPCGEWI      GSGEWI
     C*--------------------------------------------------------
     C                   SELECT
     C     LBPCSTAT      WHENGE    '50'
     C                   ADD       LBPCGEWI      WKGEWI
     C                   ENDSL
     C*--------------------------------------------------------
     C     ##PCNR        IFEQ      *BLANK
     C                   MOVEL     LBPCPCJJ      DUN040
     C                   EVAL      ##PCNR =%CHAR(LBPCPCJJ) + LBPCPCNR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      LBPCUSER = *BLANK
     C*
     C                   WHEN      LBPCJDAT > WKJDAT
     C                   MOVEL(P)  LBPCUSER      ##USER
     C                   Z-ADD     LBPCJDAT      WKJDAT
     C                   Z-ADD     LBPCJZEI      WKJZEI
     C*
     C                   WHEN      LBPCJDAT=WKJDAT AND LBPCJZEI>WKJZEI
     C                   MOVEL(P)  LBPCUSER      ##USER
     C                   Z-ADD     LBPCJDAT      WKJDAT
     C                   Z-ADD     LBPCJZEI      WKJZEI
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEA     '10R     '    CHI
     C                   EXSR      CHLBPC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      GSGEWI=0
     C                   WHEN      GSGEWI>0 AND WKGEWI>0
     C                   EVAL      ##PROZ= (WKGEWI*100/GSGEWI)
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      LBAKTFLG>0
     C                   MOVEL(P)  'PPL'         ##PPKL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*                  MOVEL(P)  'ERLORT'      #CPGST
     C*                  EXSR      MOLBAP
     C*                  EVAL      ##LORT= %SUBST(RTTRNDDATE: 1: 100)
     C*-------------------------------------------------------------------------
     C                   MOVEL     EXSFLBAK      RTTRNDDATE
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
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
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKSORT          +19
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER                         BENUTZER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT                         JOBDATUM
     C     *LIKE         DEFINE    DSJZEI        WKJZEI                         JOBZEIT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    RTTRNDPROG    WKPROG
     C     *LIKE         DEFINE    RTTRNDDANA    WKDANA
     C     *LIKE         DEFINE    RTTRNDFFLD    WKFFLD
     C     *LIKE         DEFINE    RTTRNDPA03    W$PA03
     C     *LIKE         DEFINE    RTTRNDPA04    W$PA04
     C     *LIKE         DEFINE    RTTRNDPA05    W$PA05
     C     *LIKE         DEFINE    RTTRNDPA06    W$PA06
     C     *LIKE         DEFINE    RTTRNDPA07    W$PA07
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAKSTAT      DSSTAT
     C     *LIKE         DEFINE    LBAKLANR      DSLANR
     C     *LIKE         DEFINE    LBAKLORT      DSLORT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAKJAHR      #KOMJAHR
     C     *LIKE         DEFINE    LBAKNMKR      #KOMNMKR
     C     *LIKE         DEFINE    LBPCGEWI      GSGEWI
     C     *LIKE         DEFINE    LBPCGEWI      WKGEWI
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHLBAK
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBPC
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,EXUX04
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
