     H DECEDIT('0,') DATEDIT(*DMY.) DEBUG(*YES)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE  Drucken Liste LBPC
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 25.10.2003 Weaco Projekt 2502
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 12.05.2005 WAECO Projekt 2984  PICKLISTE 2
     H*  Änderung: ZG 23.12.2008 WAECO Projekt 5467 Paralleliste
     H*  Änderung: ZG 05.10.2010 WAECO Besuch - Seiten pro Zone für X-Positionen
     H*  Änderung: ZG 13.12.2010 WAECO Projekt 6990 - Umstellung Versand
     H*            Integration AFKM
     H*  Änderung: RE 05.01.2011 WAECO Andruck Gewicht
     H*  Änderung: RE 06.01.2011 WAECO Andruck KMNR
     H*  Änderung: ZG 04.03.2011 Projekt 7188 - Druck Texte
     H*  Änderung: ZG 12.05.2011 Projekt 7238 - Beistellung
     H*  Änderung: SZ 05.12.2011 Projekt 7760, Druck Texte mit TCDE = 'TXVS'
     H*  Änderung: PH 13.01.2012 DOMETIC Projekt 8161. Andruck der Kopf-Stammtexte auf der
     H*            KD-Af-Pos-Ebene analog Kom-Schein
     H*  Änderung: ZG 19.03.2012 DOMETIC Projekt 7958 Andruck Hinweis auf Fixtermin
     H*  Änderung: ZG 23.03.2012 DOMETIC telefonat mit Frau Hinken - Korrektur
     H*            Seitenvorschub bei der Ausgabe der Stammtexte. (Vorschub berechnen)
     H*  Änderung: ZG 21.11.2013 DOMETIC Projekt 9803 Druck des Kundenprodukttextes
     H*  Änderung: ZG 28.11.2013 DOMETIC Projekt 10005 Druck des Artikel-Textes
     H*  Änderung: ZG 16.05.2014 DOMETIC Projekt 10273 Druck mehreren VSBD im Kopf
     H*  Änderung: ZG 23.05.2014 DOMETIC Projekt 10206 Druck der neuen Seite pro Lager
     H*  Änderung: ZG 10.07.2015 DOMETIC Projekt 11466 Druck PTSORT
     H**************************************************************************
     F*
     F*  Dieses Programm druckt die Pickliste .
     F*  Die Vorauswahl wurde mit dem Programm TRLBPC getroffen.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FDRLB09DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D VSBD            S                   DIM(50) INZ LIKE(LBAKVSBD)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D LBPC          E DS                  INZ
     D KYLBPC        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D CHST          E DS                  INZ
     D KYCHST        E DS                  INZ
     D*
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D LBAK          E DS                  INZ
     D KYLBAK        E DS                  INZ
     D*
     D WAO7          E DS                  INZ
     D KYWAO7        E DS                  INZ
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D TXBE          E DS                  INZ
     D KYTXBE        E DS                  INZ
     D*
     D TXST          E DS                  INZ
     D KYTXST        E DS                  INZ
     D*
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
     D*
     D BBUP          E DS                  INZ
     D KYBBUP        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS
     D EXLB09        E DS
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D EXFIRM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXGEWI        E DS                  INZ
     D RTGEWI        E DS                  INZ
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
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
     D**************************************************************************
     D***  DATENSTRUKTUR ANGABEN SPOOLDATEI                                  ***
     D**************************************************************************
     D/COPY QCPYSRC,TRSPOL
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXLB09
     C                   PARM                    EXTR04
     C*
     C                   EXSR      UEBLB09
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        IFNE      *ON
     C                   EXSR      ANFANG
     C                   EXSR      ETRPA
     C                   EXSR      ERMKO
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C     EXLB09PGST    WHENEQ    'DRWAO1'
     C                   EXSR      UXOPENWAO1
     C                   EXSR      UXWRTEWAO1
     C                   EXSR      UXREADWAO1
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      UXOPEN
     C                   EXSR      UXWRTE
     C                   EXSR      UXREAD
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  EXPSDSPROC    PTPROG
     C                   MOVEL(P)  EXPSDSBIBL    PTBIBL
     C                   MOVEL(P)  EXPSDSUSER    PTUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYAKFI                         AFKO
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYLBPCFIRM
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM
     C                   MOVEL(P)  DAFIRM        KYLBAKFIRM
     C                   MOVEL(P)  DAFIRM        KYLLFI
     C                   MOVEL(P)  DAFIRM        KYLDFI
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYCHSTFIRM
     C                   MOVEL(P)  DAFIRM        KYWAO1FIRM
     C                   MOVEL(P)  DAFIRM        KYWAO7FIRM
     C                   MOVEL     DAFIRM        KYTBFI                         TXBE
     C                   MOVEL(P)  DAFIRM        KYTTFI                         TXST
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYBBKMFIRM                     BBKM
     C                   MOVEL(P)  DAFIRM        KYBUFI                         BBUP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   BITOFF    '01234567'    WKFARB
     C                   BITON     '247'         WKFARB
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXLB09                                                 ***
     C**************************************************************************
     C     UEBLB09       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXLB09PCJJ    PTPCJJ
     C                   MOVEL(P)  EXLB09PCNR    PTPCNR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   SELECT
     C     EXLB09PGST    WHENEQ    'DRWAO1'
     C                   MOVEA     KON(01)       W99(32)
     C                   MOVEA(P)  W99(01)       PTKOPF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *DATE         PTDATE
     C                   TIME                    PTTIME
     C                   Z-ADD     1             PTSEIT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIKOP
     C                   MOVE      *OFF          WKPPKL
     C                   Z-ADD     *ZERO         PTANZL
     C                   Z-ADD     *ZERO         IA
     C                   MOVEA     *BLANK        VSBD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPEN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'DRLB09'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 58 + %LEN(LBPC)
     C                   EVAL      EXUX01KYLG = 58                              MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Druck DRLB09'
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXWRTE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         IA
     C*
     C     WKTRPAANZL    IFGT      *ZERO
     C
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :IA     FROM LBPC
     C+                       WHERE LBPCFIRM= :KYLBPCFIRM
     C+                       AND   LBPCPCJJ= :EXLB09PCJJ
     C+                       AND   LBPCPCNR= :EXLB09PCNR
     C+                       AND   LBPCSTAT<'50'
     C/END-EXEC
     C                   IF        IA < WKTRPAANZL
     C                   Z-ADD     *ZERO         IA
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXLB09PCJJ    KYLBPCPCJJ
     C                   MOVEL(P)  EXLB09PCNR    KYLBPCPCNR
     C                   MOVEL(P)  *LOVAL        KYLBPCPAKN
     C                   MOVE      *LOVAL        KYLBPCTSTP
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPC
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*--------------------------------------------------------
     C     LBPCFIRM      IFNE      KYLBPCFIRM
     C     LBPCPCJJ      ORNE      KYLBPCPCJJ
     C     LBPCPCNR      ORNE      KYLBPCPCNR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBPCSTAT      IFLT      '50'
     C*--------------------------------------------------------
     C                   MOVEL     LBPCLANR      KYLLLA                         PRÜFEN LAGER-
     C                   MOVEL     LBPCLORT      KYLLLO                         PLATZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C*    999           SUB       LLZGFK        DUN030
     C                   Z-ADD     LLZGFK        DUN030
     C*
     C                   MOVEL(P)  LLPLDF        DUC002                         PLATZDEFINITION
     C*
     C                   MOVE      LBPCTSTP      DUC026
     C*
     C                   MOVEL(P)  *BLANK        DUC001                         PLATZDEFINITION
     C     IA            IFGT      *ZERO
     C                   MOVEL     LBPCLANR      KYWAO7LANR                     PRÜFEN LAGER-
     C                   MOVEL     LBPCLORT      KYWAO7LORT                     PLATZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAO7
     C                   MOVEL(P)  WAO7LPTY      DUC001                         PLATZDEFINITION
     C                   IF        WAO7LPTY=*BLANK
     C                   MOVEL(P)  '9'           DUC001                         PLATZDEFINITION
     C                   ENDIF
     C                   ENDIF
     C*
     C                   SELECT                                                 PLATZDEFINITION
     C     DUC002        WHENEQ    '  '
     C                   MOVEL(P)  '10'          DUC002                         PLATZDEFINITION
     C     DUC002        WHENEQ    '30'
     C                   MOVEL(P)  '10'          DUC002                         PLATZDEFINITION
     C     DUC002        WHENEQ    '98'
     C                   MOVEL(P)  '  '          DUC002                         PLATZDEFINITION
     C                   OTHER
     C                   MOVEL(P)  '10'          DUC002                         PLATZDEFINITION
     C                   ENDSL                                                  PLATZDEFINITION
     C*
     C                   MOVEL     LBPCDANA      KYLBAKDANA
     C                   Z-ADD     LBPCJAHR      KYLBAKJAHR
     C                   MOVEL     LBPCNMKR      KYLBAKNMKR
     C                   MOVEA     '01C     '    CHI                            LESEN LBAK
     C                   EXSR      CHLBAK
     C                   IF        LBAKDANA='AFKM'                                  KOMMISSIONIERUNG
     C                   Z-ADD     LBAKJAHR      KYAMJH
     C                   MOVEL     LBAKNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C                   MOVEL     AMVSBD        LBAKVSBD
     C                   ENDIF
     C                   IF        LBAKDANA='BBKM'                                  KOMMISSIONIERUNG
     C                   Z-ADD     LBAKJAHR      KYBBKMKMJJ
     C                   MOVEL     LBAKNMKR      KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C                   MOVEL     BBKMLFNR      KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   MOVEL     LFBSVB        LBAKVSBD
     C                   ENDIF
     C*
     C                   IF        LBAKVSBD > *BLANK
     C                   Z-ADD     1             I0
     C     LBAKVSBD      LOOKUP    VSBD(I0)                               99
     C     *IN99         IFNE      *ON
     C                   Z-ADD(H)  1             I0
     C     *BLANK        LOOKUP    VSBD(I0)                               99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     LBAKVSBD      VSBD(I0)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        WKPPKL = *OFF
     C*
     C*
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :I0     FROM LBPC
     C+                       WHERE LBPCFIRM= :LBPCFIRM
     C+                       AND   LBPCDANA= :LBPCDANA
     C+                       AND   LBPCJAHR= :LBPCJAHR
     C+                       AND   LBPCNMKR= :LBPCNMKR
     C+                       AND   LBPCPCJJ= :KYLBPCPCJJ
     C+                       AND   LBPCPCNR<>:KYLBPCPCNR
     C+                       AND   LBPCSTAT<'40'
     C/END-EXEC
     C                   SELECT
     C*                  WHEN      I0 > 0
     C*                  MOVE      *ON           WKPPKL
     C                   WHEN      LBAKTFLG>0
     C                   MOVE      *ON           WKPPKL
     C                   ENDSL
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EVAL      WKSORT = LBPCLANR + DUC001 + DUC002 + DUC003 3+1+2+3
     C                             + LBPCLORT + LBPCTENR + DUC026               8 + 15 +26
     C*--------------------------------------------------------
     C                   EVAL      EXUX01IDTA = WKSORT   + LBPC
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   ADD       1             PTANZL
     C                   EXSR      EXUXWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBPC
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C                   MOVE      *LOVAL        WKWAO7LPTY
     C                   MOVE      *LOVAL        WKLBPCLANR
     C*#------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      LBPC = %SUBST(EXUX01IDTA: 59: %LEN(LBPC))
     C                   EVAL      WAO7LPTY = %SUBST(EXUX01IDTA: 4: 1)
     C                   EVAL      PTSORT = %SUBST(EXUX01IDTA: 1: %LEN(PTSORT))
     C                   EXSR      DRUCK
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKIKOP        IFEQ      *ON
     C                   MOVEL     'TXSC'        WKTCDE
     C                   EXSR      TXBETEXT
     C                   EXSR      ENDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DRUCKKONSTANTE                                          ***
     C**************************************************************************
     C     ERMKO         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYTPFI        OFTPFI
     C     *LIKE         DEFINE    KYTPSP        OFTPSP
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DRLB09'      KYTPTA
     C                   MOVEL(P)  'MODWAO'      KYTPTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  KYTPFI        OFTPFI
     C                   MOVEL(P)  KYTPSP        OFTPSP
     C                   MOVEL(P)  KYTPTA        OFTPTA
     C                   MOVEL(P)  KYTPTC        OFTPTC
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHTRTP
     C*-------------------------------------------------------------------------
     C                   DO        100           I1
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C*--------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     TPFIRM        IFGT      OFTPFI
     C     TPSPCD        ORGT      OFTPSP
     C     TPTART        ORGT      OFTPTA
     C     TPTCDE        ORGT      OFTPTC
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  TPTTXT        KON(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KON(02)       KON002
     C                   MOVEL(P)  KON(03)       KON003
     C                   MOVEL(P)  KON(04)       KON004
     C                   MOVEL(P)  KON(05)       KON005
     C                   MOVEL(P)  KON(06)       KON006
     C                   MOVEL(P)  KON(07)       KON007
     C                   MOVEL(P)  KON(08)       KON008
     C                   MOVEL(P)  KON(09)       KON009
     C                   MOVEL(P)  KON(10)       KON010
     C                   MOVEL(P)  KON(11)       KON011
     C                   MOVEL(P)  KON(12)       KON012
     C*                  MOVEL(P)  KON(13)       KON013
     C*                  MOVEL(P)  KON(14)       KON014
     C                   MOVEL(P)  KON(15)       KON015
     C                   MOVEL(P)  KON(16)       KON016
     C                   MOVEL(P)  KON(17)       KON017
     C                   MOVEL(P)  KON(18)       KON018
     C                   MOVEL(P)  KON(19)       KON019
     C                   MOVEL(P)  KON(20)       KON020
     C                   MOVEL(P)  KON(21)       KON021
     C                   MOVEL(P)  KON(22)       KON022
     C                   MOVEL(P)  KON(23)       KON023
     C                   MOVEL(P)  KON(24)       KON024
     C                   MOVEL(P)  KON(25)       KON025
     C*                  MOVEL(P)  KON(26)       KON026
     C*                  MOVEL(P)  KON(27)       KON027
     C                   MOVEL(P)  KON(28)       KON028
     C                   MOVEL(P)  KON(29)       KON029
     C                   MOVEL(P)  KON(30)       KON030
     C                   MOVEL(P)  KON(31)       KON031
     C                   MOVEL(P)  KON(32)       KON032
     C                   MOVEL(P)  KON(33)       KON033           40
     C                   MOVEL(P)  KON(34)       KON034
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKROUTINE                                                      ***
     C**************************************************************************
     C     DRUCK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     WKIKOP        IFEQ      *OFF
     C     LBPCLANR      ORNE      WKLBPCLANR
     C*
     C                   Z-ADD     LBPCPCJJ      DUN040
     C                   MOVEL     DUC004        PTBRC1
     C                   MOVE      LBPCPCNR      PTBRC1
     C*
     C                   MOVEL     LBPCLANR      KYLDLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBSD
     C                   MOVEL     LDLBZ1        PTLBZ1
     C                   MOVEL     LBPCLANR      PTLANR
     C*
     C                   MOVEL     LBPCDANA      KYLBAKDANA
     C                   Z-ADD     LBPCJAHR      KYLBAKJAHR
     C                   MOVEL     LBPCNMKR      KYLBAKNMKR
     C                   MOVEA     '01C     '    CHI                            LESEN LBAK
     C                   EXSR      CHLBAK
     C*
     C                   IF        LBAKDANA='AFKM'                                  KOMMISSIONIERUNG
     C                   Z-ADD     LBAKJAHR      KYAMJH
     C                   MOVEL     LBAKNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C                   ENDIF
     C*
     C                   IF        LBAKDANA='BBKM'                                  KOMMISSIONIERUNG
     C                   Z-ADD     LBAKJAHR      KYBBKMKMJJ
     C                   MOVEL     LBAKNMKR      KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C                   MOVEL     BBKMLFNR      KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C                   ENDIF
     C*
     C                   SELECT
     C     EXLB09PGST    WHENEQ    'DRWAO1'
     C                   OTHER
     C                   IF        WKPPKL = *ON
     C                   MOVEA     KON(26)       W99(32)
     C                   MOVEA(P)  W99(01)       PTKOPF
     C                   ELSE
     C                   MOVEA     KON(01)       W99(32)
     C                   MOVEA(P)  W99(01)       PTKOPF
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      KOPF
     C                   MOVEL     'TXKO'        WKTCDE
     C                   EXSR      TXBETEXT
     C                   MOVEL(P)  'TXVS'        WKTCDE
     C                   EXSR      TXBETEXT
     C                   EXSR      POSITION
     C                   MOVE      *ON           WKIKOP
     C                   MOVE      WAO7LPTY      WKWAO7LPTY
     C                   MOVE      LBPCLANR      WKLBPCLANR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      ZEILEN
     C*--------------------------------------------------------
     C                   Z-ADD     6             WKZEZA
     C     LBPCCHAR      IFNE      *BLANK
     C                   Z-ADD     1             WKZEZA
     C                   ENDIF
     C     LBPCDANA      IFEQ      'AFKM'
     C                   Z-ADD     *ZERO         WKAFPO                         DRUCKEN
     C                   MOVEL(P)  'TXKO'        WKTCDE                         STAMMTEXTE
     C                   MOVEL     'ZEILZE'      WKPGST
     C                   MOVEL     *BLANK        WKTENR
     C                   MOVEL     *BLANK        WKPRGR
     C                   MOVEL     *BLANK        WKGEBI
     C                   EXSR      DTXST
     C                   ADD       W1ZEIL        WKZEZA
     C                   ENDIF
     C     WAO7LPTY      IFNE      WKWAO7LPTY
     C     IA            ANDGT     *ZERO                                        neue Seite
     C     WKTRPAANZL    ANDGT     *ZERO
     C     WKWAO7LPTY    ANDNE     *LOVAL
     C                   Z-ADD     WKSPUZ        WKZEZA
     C                   ENDIF
     C                   EXSR      ZEILZA
     C*
     C     LBPCDANA      IFNE      'BGF2'
     C                   WRITE     EXDR09
     C                   ENDIF
     C*
     C     LBPCDANA      IFEQ      'AFKM'
     C                   Z-ADD     *ZERO         WKAFPO                         DRUCKEN
     C                   MOVEL(P)  'TXKO'        WKTCDE                         STAMMTEXTE
     C                   MOVEL     *BLANK        WKTENR
     C                   MOVEL     *BLANK        WKPRGR
     C                   MOVEL     *BLANK        WKGEBI
     C                   MOVEL     *BLANK        WKPGST
     C                   EXSR      DTXST
     C                   ENDIF
     C*
     C                   WRITE     EXDR10
     C*
     C     LBPCCHAR      IFNE      *BLANK
     C                   WRITE     EXDR11
     C                   ENDIF
     C*
     C     LBPCDANA      IFEQ      'BGF2'
     C                   WRITE     EXDR13
     C*
     C                   Z-ADD     LBPCPOSI      WKAFPO                         DRUCKEN
     C                   MOVEL     'TXPO'        WKTCDE                         STAMMTEXTE
     C                   MOVEL     LBPCTENR      WKTENR
     C                   MOVEL     TEPRGR        WKPRGR
     C                   MOVEL     *BLANK        WKGEBI
     C                   EXSR      DTXST
     C*
     C                   EXSR      DRWAO1                                       Ausgabe WAO1
     C*
     C*
     C                   ELSE
     C                   WRITE     EXDR12
     C*
     C                   IF        LBPCDANA ='AFKM'
     C                   MOVEL     'AFDA'        KYTBTA                              DRUCKEN DER
     C                   Z-ADD     LBPCAFJJ      KYTBJH                              POSITIONS-
     C                   MOVEL     LBPCAFNR      KYTBNR                              TEXTE
     C                   Z-ADD     LBPCAFPO      KYTBPO
     C                   Z-ADD     *ZERO         KYTBUP
     C                   MOVEL     'TXPO'        KYTBTC
     C                   MOVEL     *OFF          WKAFNR
     C                   EXSR      VTXBE
     C*
     C                   Z-ADD     LBPCAFPO      WKAFPO                         DRUCKEN
     C                   MOVEL     'TXPO'        WKTCDE                         STAMMTEXTE
     C                   MOVEL     LBPCTENR      WKTENR
     C                   MOVEL     APPRGR        WKPRGR
     C                   MOVEL     *BLANK        WKGEBI
     C                   EXSR      DTXST
     C                   ENDIF
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      WAO7LPTY      WKWAO7LPTY
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE WAO1                                                      ***
     C**************************************************************************
     C     DRWAO1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBPCDANA      KYWAO1DANA
     C                   Z-ADD     LBPCJAHR      KYWAO1JAHR
     C                   MOVEL     LBPCNMKR      KYWAO1NMKR
     C                   Z-ADD     LBPCPOSI      KYWAO1POSI
     C                   Z-ADD     *ZERO         KYWAO1LIJJ
     C                   MOVEL     *BLANK        KYWAO1LINR
     C                   Z-ADD     *ZERO         KYWAO1RALP
     C                   MOVEA     '03+     '    CHI                            LESEN AFPO
     C                   EXSR      CHWAO1
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C     WAO1FIRM      IFNE      KYWAO1FIRM
     C     WAO1DANA      ORNE      KYWAO1DANA
     C     WAO1JAHR      ORNE      KYWAO1JAHR
     C     WAO1NMKR      ORNE      KYWAO1NMKR
     C     WAO1POSI      ORNE      KYWAO1POSI
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WAO1LIJJ      PTLIJJ
     C                   MOVE      WAO1LINR      PTLINR
     C                   Z-ADD     WAO1RALP      PTRALP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR14
     C*-------------------------------------------------------------------------
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHWAO1
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     KOPF          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR1
     C                   WRITE     EXDRK1
     C*
     C                   WRITE     EXDRK1VSB1
     C*
     C     1             DO        50            I0
     C*
     C     VSBD(I0)      IFEQ      *BLANK
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL     VSBD(I0)      PTVSBD
     C                   MOVEL     'VSBD'        KYTPTA                         MENGENEINHEIT
     C                   MOVEL     PTVSBD        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        TXVSBD
     C*
     C                   WRITE     EXDRK1VSB2
     C                   ENDDO
     C*
     C                   WRITE     EXLEER
     C*
     C                   WRITE     EXDRK2
     C                   WRITE     EXDRK3
     C                   WRITE     EXSTR2
     C                   WRITE     EXLEER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSITIONSÜBERSCHRIFTEN                                    ***
     C**************************************************************************
     C     POSITION      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXDRP1
     C                   WRITE     EXSTR3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSITIONSZEILEN                                           ***
     C**************************************************************************
     C     ZEILEN        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     LBPCTENR      IFNE      KYTENR
     C                   MOVEL     LBPCTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C                   MOVEL     TETBZ1        PTTBZ1
     C*-------------------------------------------------------------------------
     C                   MOVEL     'MEIN'        KYTPTA                         MENGENEINHEIT
     C                   MOVEL     TEMEIN        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        PTMEIN
     C                   MOVEL     TPTTXT        PTBSME
     C                   MOVEL     TPTTXT        P2MEIN
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBPCDANA      KYLBAPDANA
     C                   Z-ADD     LBPCJAHR      KYLBAPJAHR
     C                   MOVEL     LBPCNMKR      KYLBAPNMKR
     C                   Z-ADD     LBPCPOSI      KYLBAPPOSI
     C                   MOVEA     '01C     '    CHI                            LESEN AFPO
     C                   EXSR      CHLBAP
     C                   Z-ADD     LBAPBWMG      PTBWMG
     C*
     C     LBPCAFDN      IFEQ      'AFUP'
     C                   MOVEL     LBAPTENR      PTBGTE
     C                   MOVEL     LBAPTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL     TETBZ1        PTBGTETBZ1
     C                   MOVEL     TETBZ2        PTBGTETBZ2
     C*
     C                   MOVEL     LBPCTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C                   ELSE
     C                   MOVEL     *BLANK        PTBGTE
     C                   MOVEL     *BLANK        PTBGTETBZ1
     C                   MOVEL     *BLANK        PTBGTETBZ2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     LBPCCHAR      IFNE      *BLANK
     C                   MOVEL     LBPCCHAR      KYCHSTCHAR
     C                   MOVEL     LBPCTENR      KYCHSTTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHCHST
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     CHSTVEDA      EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    PTVEDA
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBPCZULG      PTZULG
     C                   MOVEL     LBPCZULO      PTZULO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBPCLORT      PTLORT
     C*-------------------------------------------------------------------------
     C                   MOVE      LBPCTMST      PTBRC2
     C*-------------------------------------------------------------------------
     C*                  MOVEL     '20'          KYWAO1UEST
     C*                  Z-ADD     LBPCJAHR      KYWAO1LIJJ
     C*                  MOVEL     LBPCNMKR      KYWAO1LINR
     C*                  Z-ADD     LBPCPOSI      KYWAO1RALP
     C*                  MOVEA     '02C     '    CHI                            LESEN AFPO
     C*                  EXSR      CHWAO1
     C*    WKFENR        IFEQ      *ZEROS
     C*                  MOVEL(P)  WAO1FREI      A63              63
     C*                  MOVE      A63           PTWAO1KUND
     C*                  MOVE      WAO1FREI      A35              35
     C*                  MOVEL     A35           PTWAO1ZSAT
     C*                  ELSE
     C*                  MOVE      *BLANKS       PTWAO1KUND
     C*                  MOVE      *BLANKS       PTWAO1ZSAT
     C*                  ENDIF
     C*
     C                   MOVE      *BLANKS       PTWAO1KUND
     C                   MOVE      *ZERO         PTLFTE
     C                   MOVE      *BLANKS       PTFIXT
     C*-------------------------------------------------------------------------
     C                   IF        LBPCDANA ='AFKM'
     C*
     C                   Z-ADD     LBPCJAHR      KYAMJH
     C                   MOVEL     LBPCNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C*
     C                   EVAL      PTWAO1KUND=%TRIMR(AMNAM1)+' '+%TRIMR(AMPOLD)
     C                   EVAL      PTWAO1KUND=%TRIMR(PTWAO1KUND)+' '+
     C                             %TRIMR(AMPOLZ)+' '+%TRIMR(AMWORT)
     C*
     C                   Z-ADD     LBAPAFJJ      KYAKJH
     C                   MOVEL(P)  LBAPAFNR      KYAKAF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKO
     C*
     C                   MOVEL(P)  AKKDNR        KYKDNR                         ERMITTELN
     C                   MOVEA     '01C     '    CHI                            LAND
     C                   EXSR      CHKUND
     C*
     C                   Z-ADD     LBAPAFJJ      KYAPJH
     C                   MOVEL(P)  LBAPAFNR      KYAPAF
     C                   Z-ADD     LBAPAFPO      KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     APLFTE        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    PTLFTE
     C*
     C                   MOVE      *BLANK        PTFIXT
     C*
     C                   IF        APLFTA > *BLANK
     C                   MOVEL(P)  '$$WAOTAGE'   KYTPTA
     C                   MOVEL(P)  APLFTA        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        PTFIXT
     C                   ENDIF
     C*
     C                   MOVEL(P)  APSABE        PTSABE
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   IF        LBPCDANA ='BBKM'                             Beistellung
     C*
     C                   Z-ADD     LBPCJAHR      KYBBKMKMJJ
     C                   MOVEL     LBPCNMKR      KYBBKMKMNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBKM
     C*
     C                   MOVEL     BBKMLFNR      KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*
     C                   EVAL      PTWAO1KUND=%TRIMR(LFNAM1)+' '+%TRIMR(LFPOLD)
     C                   EVAL      PTWAO1KUND=%TRIMR(PTWAO1KUND)+' '+
     C                             %TRIMR(LFPOLZ)+' '+%TRIMR(LFWORT)
     C*
     C                   Z-ADD     LBPCAFJJ      KYBUJH
     C                   MOVEL(P)  LBPCAFNR      KYBUBE
     C                   Z-ADD     LBPCAFPO      KYBUPO
     C                   Z-ADD     LBPCAFUP      KYBUUP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBUP
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     BURSDA        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   IF        RTDATEDATE>0
     C                   Z-ADD     RTDATEDATE    PTLFTE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBPCDANA      KYLBAKDANA
     C                   Z-ADD     LBPCJAHR      KYLBAKJAHR
     C                   MOVEL     LBPCNMKR      KYLBAKNMKR
     C                   MOVEA     '01C     '    CHI                            LESEN LBAK
     C                   EXSR      CHLBAK
     C*
     C/EXEC SQL
     C+ SELECT COUNT(*) INTO :I0     FROM LBPC
     C+                       WHERE LBPCFIRM= :KYLBAPFIRM
     C+                       AND   LBPCDANA= :KYLBAPDANA
     C+                       AND   LBPCJAHR= :KYLBAPJAHR
     C+                       AND   LBPCNMKR= :KYLBAPNMKR
     C+                       AND   LBPCPCJJ= :EXLB09PCJJ
     C+                       AND   LBPCPCNR<>:EXLB09PCNR
     C+                       AND   LBPCSTAT<'40'
     C/END-EXEC
     C*
     C                   MOVE      *BLANKS       PTPPKZ
     C                   IF        I0>0
     C**                 MOVEA     KON(27)       PTPPKZ
     C                   ENDIF
     C                   IF        LBAKTFLG>0
     C                   MOVEA     KON(27)       PTPPKZ
     C                   ENDIF
     C                   IF        BBKMSTAT='22'                                status paralle-PL
     C                   MOVEA     KON(27)       PTPPKZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXGEWI
     C                   MOVEL     LBPCTENR      EXGEWITENR
     C                   Z-ADD     LBPCRSMG      EXGEWIMENG
     C                   MOVEL     TEMEIN        EXGEWIMEIN
     C*
     C                   CALL      'ERGEWI'
     C                   PARM                    EXGEWI
     C                   PARM                    RTGEWI
     C*
     C     RTGEWIGWNT    IFNE      *ZERO
     C                   ADD       RTGEWIGWNT    PTGSBR
     C                   Z-ADD     RTGEWIGWNT    PTGWBR
     C                   ELSE
     C                   ADD       RTGEWIGWBR    PTGSBR
     C                   Z-ADD     RTGEWIGWBR    PTGWBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE ENDE DER LISTE                                            ***
     C**************************************************************************
     C     ENDE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXDR16
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXLEER
     C                   WRITE     EXENDE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ZEILENZÄHLER                                                      ***
     C**************************************************************************
     C     ZEILZA        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        (WKSPAZ + WKZEZA) >= WKSPUZ
     C                   ADD       1             PTSEIT
     C                   SELECT
     C     EXLB09PGST    WHENEQ    'DRWAO1'
     C                   EXSR      KOPF2
     C                   EXSR      POSITION2
     C                   OTHER
     C     WAO7LPTY      IFNE      WKWAO7LPTY
     C     IA            ANDGT     *ZERO                                        neue Seite
     C     WKTRPAANZL    ANDGT     *ZERO
     C     WKWAO7LPTY    ANDNE     *LOVAL
     C                   WRITE     EXSTR4
     C                   ENDIF
     C                   EXSR      KOPF
     C                   EXSR      POSITION
     C                   ENDSL
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
     C                   MOVEL(P)  'MODWAO'      KYTATA
     C                   MOVEL(P)  'DRLB09'      KYTATC
     C                   MOVEL(P)  'ANZLPOSI'    KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        DUC003
     C                   TESTN                   DUC003               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVE      *ZERO         DUC003                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN030        WKTRPAANZL
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
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIKOP
     C     *LIKE         DEFINE    WKC001        WKPAKN                         KZ-Colli
     C     *LIKE         DEFINE    WKC001        WKTRTP                         KZ-Colli
     C     *LIKE         DEFINE    WKC001        WKPPKL
     C     *LIKE         DEFINE    WKC001        WKAFNR
     C     *LIKE         DEFINE    WKC001        WKFARB
     C     *LIKE         DEFINE    WKC001        WKTXBE
     C     *LIKE         DEFINE    WKC001        WKTXST
     C     *LIKE         DEFINE    WKC001        WKTXSC
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSORT          +57
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        IA              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKZEZA          + 2
     C     *LIKE         DEFINE    WKN010        WKZEIL          + 2
     C     *LIKE         DEFINE    WKN010        W1ZEIL          + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN030        WKTRPAANZL
     C     *LIKE         DEFINE    WAO7LPTY      WKWAO7LPTY
     C     *LIKE         DEFINE    LBPCLANR      WKLBPCLANR
     C     *LIKE         DEFINE    KYTBTC        WKTCDE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPBWMG      PTBWMG
     C     *LIKE         DEFINE    TEMEIN        PTBSME           +5
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPTENR      WKTENR
     C     *LIKE         DEFINE    LBAPTENR      WKGEBI
     C     *LIKE         DEFINE    APPRGR        WKPRGR
     C     *LIKE         DEFINE    APAFPO        WKAFPO
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPENWAO1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'DRLB09WAO1'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 55+ 945
     C                   EVAL      EXUX01KYLG = 55                                MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Druck DRLB09-02'
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
     C                   IF        EXLB09PCNR = *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBAPC1 CURSOR FOR SELECT * FROM LBAP
     C+ WHERE LBAPFIRM = :DAFIRM AND
     C+ LBAPKMJJ = :EXLB09PCJJ AND
     C+ LBAPKMNR = :EXLB09PCNR
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBAPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C*----------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM LBAPC1 INTO :LBAP
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBAPDANA      IFEQ      'BGFS'
     C                   MOVEL     'SKOM'        KYLBAPDANA
     C                   Z-ADD     LBAPJAHR      KYLBAPJAHR
     C                   MOVEL     LBAPNMKR      KYLBAPNMKR
     C                   Z-ADD     LBAPPOSI      KYLBAPPOSI
     C                   MOVEA     '01C     '    CHI                            LESEN AFPO
     C                   EXSR      CHLBAP
     C*
     C                   Z-ADD     LBAPJAHR      DUN040
     C                   Z-ADD     LBAPPOSI      DUN050
     C                   EVAL      WKSORT =  LBAPDANA + DUC004 +
     C                             LBAPNMKR + DUC005
     C                   EVAL      EXUX01IDTA = WKSORT   +  LBAP
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE LBAPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREADWAO1    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIKOP
     C                   Z-ADD     *ZERO         PTLIJJ
     C                   MOVEL     *BLANK        PTLINR
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      LBAP = %SUBST(EXUX01IDTA: 56: %LEN(LBAP))
     C                   EXSR      DRUCK2
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     WKIKOP        IFEQ      *ON
     C                   EXSR      ENDE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DRUCKROUTINE                                                      ***
     C**************************************************************************
     C     DRUCK2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIKOP        WHENEQ    *OFF
     C                   Z-ADD     EXLB09PCJJ    DUN040
     C                   MOVEL     DUC004        PTBRC1
     C                   MOVE      EXLB09PCNR    PTBRC1
     C                   MOVEL     *BLANK        PTLBZ1
     C                   MOVEL     *BLANK        PTLANR
     C                   MOVEL     *BLANK        PTVSBD
     C                   MOVEL     *BLANK        TXVSBD
     C                   EXSR      KOPF2
     C                   EXSR      POSITION2
     C                   MOVE      *ON           WKIKOP
     C     PTLIJJ        WHENNE    LBAPKMJJ
     C     PTLINR        ORNE      LBAPKMNR
     C                   ADD       1             PTSEIT
     C                   EXSR      KOPF2
     C                   EXSR      POSITION2
     C                   ENDSL
     C*--------------------------------------------------------
     C                   EXSR      ZEILEN2
     C*--------------------------------------------------------
     C                   Z-ADD     2             WKZEZA
     C                   EXSR      ZEILZA
     C*
     C                   WRITE     EXDR15
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSITIONSZEILEN                                           ***
     C**************************************************************************
     C     ZEILEN2       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*                  MOVEL     LBAPDANA      PTDANA
     C                   Z-ADD     LBAPJAHR      PTLIJJ
     C                   MOVEL     LBAPNMKR      PTLINR
     C                   Z-ADD     LBAPPOSI      PTRALP
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBAPTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   MOVEL     TETBZ1        PTTBZ1
     C*-------------------------------------------------------------------------
     C                   MOVEL     'MEIN'        KYTPTA                         MENGENEINHEIT
     C                   MOVEL     TEMEIN        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL     TPTTXT        PTMEIN
     C                   MOVEL     TPTTXT        PTBSME
     C                   MOVEL     TPTTXT        P2MEIN
     C*-------------------------------------------------------------------------
     C*                  MOVEL     'BGFS'        KYLBAPDANA
     C*                  Z-ADD     WAO1LIJJ      KYLBAPJAHR
     C*                  MOVEL     WAO1LINR      KYLBAPNMKR
     C*                  Z-ADD     WAO1RALP      KYLBAPPOSI
     C*                  MOVEA     '01C     '    CHI                            LESEN AFPO
     C*                  EXSR      CHLBAP
     C                   Z-ADD     LBAPBWMG      PTBWMG
     C*
     C                   Z-ADD     *ZERO         P2RSMG
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        #CKOMM
     C                   MOVEL(P)  'ERESB'       #CPGST
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL     'AFKM'        EXRSDANA
     C                   MOVEL     LBAPJAHR      EXRSJAHR
     C                   MOVEL     LBAPNMKR      EXRSNMKR
     C                   Z-ADD(H)  LBAPPOSI      EXRSPOSI
     C                   CALL      'TRLBRS'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*
     C                   Z-ADD(H)  RTRSRSMG      P2RSMG
     C*-------------------------------------------------------------------------
     C                   MOVEL     LBPCZULG      PTZULG
     C                   MOVEL     LBPCZULO      PTZULO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXGEWI
     C                   MOVEL     LBAPTENR      EXGEWITENR
     C                   Z-ADD     LBAPBWMG      EXGEWIMENG
     C                   MOVEL     TEMEIN        EXGEWIMEIN
     C*
     C                   CALL      'ERGEWI'
     C                   PARM                    EXGEWI
     C                   PARM                    RTGEWI
     C*
     C     RTGEWIGWNT    IFNE      *ZERO
     C                   ADD       RTGEWIGWNT    PTGSBR
     C                   Z-ADD     RTGEWIGWNT    PTGWBR
     C                   ELSE
     C                   ADD       RTGEWIGWBR    PTGSBR
     C                   Z-ADD     RTGEWIGWBR    PTGWBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     KOPF2         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR1
     C                   WRITE     EXDRK4
     C                   WRITE     EXSTR2
     C                   WRITE     EXLEER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSITIONSÜBERSCHRIFTEN                                    ***
     C**************************************************************************
     C     POSITION2     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXDRP2
     C                   WRITE     EXSTR3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     TXBETEXT      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBPCC2 CURSOR FOR SELECT LBPCAFJJ, LBPCAFNR FROM LBPC
     C+ WHERE LBPCFIRM = :KYLBPCFIRM AND
     C+ LBPCPCJJ = :EXLB09PCJJ AND
     C+ LBPCPCNR = :EXLB09PCNR
     C+ GROUP BY LBPCAFJJ, LBPCAFNR
     C+ ORDER BY LBPCAFJJ, LBPCAFNR
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBPCC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C                   MOVE      *OFF          WKTXSC
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C*----------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM LBPCC2 INTO :APAFJJ, :APAFNR
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     APAFJJ        IFEQ      *ZERO
     C     APAFNR        OREQ      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     'AFDA'        KYTBTA
     C                   Z-ADD     APAFJJ        KYTBJH
     C                   MOVEL     APAFNR        KYTBNR
     C                   Z-ADD     *ZERO         KYTBPO
     C                   Z-ADD     *ZERO         KYTBUP
     C                   MOVEL     WKTCDE        KYTBTC
     C                   MOVEL     *OFF          WKAFNR
     C                   EXSR      VTXBE
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE LBPCC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTXBE  VERARBEITEN TEXTE BEWEGUNG-DATEI                           ***
     C**************************************************************************
     C     VTXBE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTXBE
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     TBFIRM        IFNE      KYTBFI
     C     TBTXAR        ORNE      KYTBTA
     C     TBJHJJ        ORNE      KYTBJH
     C     TBAFNR        ORNE      KYTBNR
     C     TBPOSI        ORNE      KYTBPO
     C     TBUPOS        ORNE      KYTBUP
     C     TBTCDE        ORNE      KYTBTC
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     TBLFZN        IFEQ      *ZERO                                        PRÜFEN OB
     C                   MOVEL     *OFF          WKTXBE                         TEXT GEDRUCKT
     C*                                                                         WIRD
     C     TBDRK1        IFEQ      'K'
     C     TBDRK2        OREQ      'K'
     C     TBDRK3        OREQ      'K'
     C     TBDRK4        OREQ      'K'
     C     TBDRK5        OREQ      'K'
     C**   TBDRK6        OREQ      'K'
     C**   TBDRK7        OREQ      'K'
     C**   TBDRK8        OREQ      'K'
     C**   TBDRK9        OREQ      'K'
     C                   MOVE      *ON           WKTXBE
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKTXBE        IFEQ      *ON
     C*--------------------------------------------------------
     C                   SELECT
     C     TBTEXT        WHENEQ    WKFARB                                       VORSCHUB-
     C                   Z-ADD     WKSPUZ        WKZEZA                         STEUERUNG
     C                   EXSR      ZEILZA
     C*--------------------------------------------------------
     C     TBPOSI        WHENEQ    *ZERO                                        DRUCKEN DER
     C*                                                                         KOPF BZW.
     C     TBLFZN        IFEQ      *ZERO                                        SCHLUß-TEXTE
     C     TBTCDE        ANDEQ     'TXSC'
     C     WKTXSC        ANDEQ     *OFF
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXSTR3
     C                   MOVE      *ON           WKTXSC
     C                   ENDIF
     C*                                                                         KOPF BZW.
     C     WKAFNR        IFEQ      *OFF
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDRT01
     C                   MOVE      *ON           WKAFNR
     C                   ENDIF
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDRT02
     C*--------------------------------------------------------
     C     TBPOSI        WHENGT    *ZERO                                        DRUCKEN DER
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDRT03
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTXBE
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DTXST  ERMITTELN/DRUCKEN STAMMTEXTE                               ***
     C**************************************************************************
     C     DTXST         BEGSR
     C*
     C                   MOVEL     *OFF          WKTXST
     C                   MOVE      *ZERO         W1ZEIL
     C*-------------------------------------------------------------------------
     C                   DO        99            I0
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     'TRAB69'      KOM(1)                         PROGRAMM-NAME
     C                   MOVEA     WKTCDE        KOM(11)                        TEXTCODE
     C                   MOVEA     'K'           KOM(21)                        DRUCK-KZ
     C                   Z-ADD     I0            DUN030
     C                   MOVEA     DUC003        KOM(22)
     C                   MOVEA     AKKDNR        KOM(25)                        KUNDENNUMMER
     C                   MOVEA     WKTENR        KOM(35)                        IDENTNUMMER
     C                   MOVEA     AKVSNR        KOM(50)                        ALPHAFELD 1.
     C                   MOVEA     KDLAND        KOM(65)                        ALPHAFELD 2.
     C                   MOVEA     DASPCD        KOM(80)                        SPRACHCODE
     C                   MOVEA     AKWKNR        KOM(91)                        SPRACHCODE
     C                   MOVEA     WKPRGR        KOM(94)                        PRODUKTGRUPPE
     C                   MOVEA     AKLIBD        KOM(98)                        SPRACHCODE
     C                   MOVEA     AKAFAT        KOM(101)                       AUFTRAGSART
     C                   MOVEA     AKPJNR        KOM(106)
     C                   MOVEA     WKGEBI        KOM(137)                       GEBINDE
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'DRTXST'
     C                   PARM                    EXTR02
     C*----------------------------------------------------
     C                   MOVEA     #CKOMM        KOM(1)                         ÜBERTRAGEN
     C                   MOVEA     KOM(1)        KYTTTC                         DATEN AUS
     C                   MOVEA     KOM(11)       KYTTKL                         KOMM-BEREICH
     C                   MOVEA     KOM(21)       KYTTTE
     C                   MOVEA     KOM(36)       KYTTA1
     C                   MOVEA     KOM(51)       KYTTA2
     C                   MOVEA     KOM(66)       KYTTSP
     C                   MOVEA     KOM(67)       KYTTUC
     C                   MOVEA     KOM(77)       DUC004
     C     DUC004        IFNE      *BLANK
     C                   Z-ADD     DUN040        WKZEIL
     C                   ENDIF
     C                   Z-ADD     *ZERO         KYTTDA
     C                   Z-ADD     *ZERO         KYTTZN
     C*----------------------------------------------------
     C     KYTTTC        IFEQ      *BLANK                                       KEINE TEXTE
     C                   LEAVE                                                  GEFUNDEN
     C                   ENDIF
     C*----------------------------------------------------
     C     WKPGST        IFEQ      'ZEILZE'                                     NUR ZEILEN ZEILE
     C                   ADD       WKZEIL        W1ZEIL                         STAMMTEXTE
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------
     C*                                                                         DRUCKEN
     C                   EXSR      VTXST                                        STAMMTEXT
     C*----------------------------------------------------
     C                   ENDDO
     C*---------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VTXST  VERARBEITEN STAMMTEXTE                                     ***
     C**************************************************************************
     C     VTXST         BEGSR
     C*
     C                   MOVEL     *OFF          WKTXSC
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI                            AUFSETZEN
     C                   EXSR      CHTXST                                       DRUCKEN POSITIO
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     TTFIRM        IFGT      KYTTFI                                       URSPRUNGSGRENZE
     C     TTTCDE        ORGT      KYTTTC                                       UNTER,.BZW.
     C     TTKDLI        ORGT      KYTTKL                                       ÜBERSCHRITTEN
     C     TTTENR        ORGT      KYTTTE
     C     TTA115        ORGT      KYTTA1
     C     TTA215        ORGT      KYTTA2
     C     TTSPCD        ORGT      KYTTSP
     C     TTUCDE        ORGT      KYTTUC
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKTXST
     C*--------------------------------------------------------
     C                   SELECT
     C     TTTEXT        WHENEQ    WKFARB                                       VORSCHUB-
     C                   Z-ADD     WKSPUZ        WKZEZA                         STEUERUNG
     C                   EXSR      ZEILZA
     C*
     C*--------------------------------------------------------
     C     WKAFPO        WHENGT    *ZERO                                        DRUCKEN DER
     C     TTLFZN        IFEQ      *ZERO                                        SCHLUß-TEXTE
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXLEER
     C                   ENDIF
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDRT05
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C     TTLFZN        IFEQ      *ZERO                                        SCHLUß-TEXTE
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXLEER
     C                   ENDIF
     C*
     C                   SELECT
     C     WKTXSC        WHENEQ    *OFF
     C                   Z-ADD     WKZEIL        WKZEZA
     C                   EXSR      ZEILZA
     C                   MOVEL     *ON           WKTXSC
     C                   ENDSL
     C*
     C                   WRITE     EXDRT04
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI                            AUFSETZEN
     C                   EXSR      CHTXST                                       DRUCKEN POSITIO
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHBBUP
     C/COPY QCPYSRC,CHCHST
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLBPL
     C/COPY QCPYSRC,CHLBSD
14   C/COPY QCPYSRC,CHLBAK
14   C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBPC
     C/COPY QCPYSRC,CHTXBE
     C/COPY QCPYSRC,CHTXST
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHWAO7
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
