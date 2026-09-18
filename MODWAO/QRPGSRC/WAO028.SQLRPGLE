     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Drucken Liste Plan-Statistik
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 14.05.2011 Projekt 7375
     H*  -----------------------------------------------------------------------
/*  ÄH*  Änderung: MB Datum      Referenz
     H*
     H**************************************************************************
     F*
     F*  Dieses Programm druckt die Liste TVAM.
     F*  Die Vorauswahl wurde mit dem Programm TR$$01 getroffen.
     F*
     F*  Die folgenden Codes werden bei der Steuerung des Benutzerindex verwendet:
     F*  Funktionscode EXUX01FNCD
     F*  OPEN             = 01
     F*  WRITE            = 02
     F*  READ-FIRST       = 03
     F*  READ-NEXT        = 04
     F*  READ-BY-KEY      = 05
     F*  REMOVE-KEY       = 06
     F*  CLOSE            = 09
     F*
     F*  Returncode EXUX01RTCD
     F*  ALLES-OK         = 00
     F*  END-OF-TABLE     = 01
     F*  KEY-EXISTS       = 21
     F*  KEY-NOT-FOUND    = 22
     F*  ENTRY-ERROR      = 91
     F*  REMOVE-ERROR     = 94
     F*  DELETE-ERROR     = 95
     F*  CREATE-ERROR     = 96
     F*  INPUT-FALSCH     = 97
     F*  FCD0-FALSCH      = 98
     F*  CALL-FEHLER      = 99
     F*
     F*  Zum Schreiben von Daten.
     F*  Aktion beim Schreiben mit einem existierenden Schlüssel
     F*  Modus 1 erzeugt RCD0 = 01 bei bestehendem Satz
     F*  Einfügemodus EXUX01IMDE
     F*  REPLACE          = 2
     F*  NO-REPLACE       = 3
     F*
     F**************************************************************************
     F*
     F*  Umsatz-Abgleich pro Vertriebsbereich (KUND.KDKSTC Stelle-1) und
     F*  Produkt-Gruppe (TEIL.TEPRGR)
     F*
     F*  Zwischen-Summe pro Produkt-Bereich (TEIL.TEPRGR Stelle-1)
     F*
     F*  Gesamt-Summe Mandant Waeco
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO028DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SFLKSTC         S                   DIM(9) INZ LIKE(WKKSTC)              VERTRIEBSBEREICH
     D*
     D SFLMON          S                   DIM(9) INZ LIKE(PTMON)
     D SFLKUM          S                   DIM(9) INZ LIKE(PTKUM)
     D*
     D SFLMON1         S                   DIM(9) INZ LIKE(VMWTST)              PRODUKTGRUPPE
     D SFLKUM1         S                   DIM(9) INZ LIKE(VMWTST)
     D*
     D SFLMON2         S                   DIM(9) INZ LIKE(VMWTST)              PRODUKTBEREICH
     D SFLKUM2         S                   DIM(9) INZ LIKE(VMWTST)
     D*
     D SFLMON3         S                   DIM(9) INZ LIKE(VMWTST)              COMPANY
     D SFLKUM3         S                   DIM(9) INZ LIKE(VMWTST)
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TVAM          E DS                  INZ
     D KYTVAM        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D EXFIRM        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
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
     C                   PARM                    EXTR02
     C*
     C                   EXSR      UEBTR02
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
     C                   EXSR      KEYTVAM
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OTVAM
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPEN
     C*-------------------------------------------------------------------------
     C                   EXSR      UXWRTE
     C*--------------------------------------------------------
     C                   EXSR      UXREAD
     C                   EXSR      ENDE
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOS
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
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM
     C                   MOVEL(P)  DAFIRM        KYKDFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXTR02                                                 ***
     C**************************************************************************
     C     UEBTR02       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(1)        DUC004
     C                   Z-ADD     DUN040        KYVMJH
     C                   MOVEA(P)  KOM(5)        DUC002
     C                   Z-ADD     DUN020        KYVMMO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Füllen Ausgabe-Felder
     C*-------------------------------------------------------------------------
     C                   Z-ADD     KYVMJH        PTJHJJ
     C                   Z-ADD     KYVMMO        PTMONA
     C*-------------------------------------------------------------------------
     C* Füllen Feldgruppe
     C*-------------------------------------------------------------------------
     C                   EXSR      ETRTPKSTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  SFLKSTC(1)    PTKST1
     C                   MOVEL(P)  SFLKSTC(2)    PTKST2
     C                   MOVEL(P)  SFLKSTC(3)    PTKST3
     C                   MOVEL(P)  SFLKSTC(4)    PTKST4
     C                   MOVEL(P)  SFLKSTC(5)    PTKST5
     C                   MOVEL(P)  SFLKSTC(6)    PTKST6
     C                   MOVEL(P)  SFLKSTC(7)    PTKST7
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C*--------------------------------------------------------
     C                   MOVEA     KON(01)       W99(62)
     C                   MOVEA(P)  W99(01)       PTKOPF
     C*-------------------------------------------------------------------------
     C                   MOVE      *DATE         PTDATE
     C                   TIME                    PTTIME
     C                   Z-ADD     1             PTSEIT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIKOP
     C*                  Z-ADD     *ZERO         PTPOSI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG TVAM                                                ***
     C**************************************************************************
     C     KEYTVAM       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN VERTRIEBSBEREICH AUS TABELLE "KSTC"                     ***
     C**************************************************************************
     C     ETRTPKSTC     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         I0
     C                   MOVE      *BLANK        SFLKSTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'KSTC'        KYTPTA
     C                   MOVE      *LOVAL        KYTPTC
     C*--------------------------------------------------------
     C                   MOVEL(P)  'KSTC'        OFTPTA
     C*--------------------------------------------------------
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     TPFIRM        ANDEQ     KYTPFI
     C     TPSPCD        ANDEQ     KYTPSP
     C     TPTART        ANDEQ     OFTPTA
     C*--------------------------------------------------------
     C     I0            IFLT      99
     C     TPTFLG        ANDEQ     *ZERO
     C                   SELECT
     C                   WHEN      I0          = 0
     C                   ADD       1             I0
     C                   MOVEL(P)  TPTCDE        SFLKSTC(I0)
     C                   WHEN      %SUBST(TPTCDE:1:1) <> SFLKSTC(I0)
     C                   ADD       1             I0
     C                   MOVEL(P)  TPTCDE        SFLKSTC(I0)
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01R     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO028'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'BEGR'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C     TAPCDE        IFNE      *BLANK
     C                   MOVEL(P)  TAPCDE        KYVMBG
     C                   ELSE
     C                   MOVEL(P)  'ST2'         KYVMBG
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
     C                   MOVEL(P)  'WAO028'      KYTPTA
     C                   MOVEL(P)  'WAO028'      KYTPTC
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
     C                   MOVEL(P)  KON(10)       KON010
     C                   MOVEL(P)  KON(11)       KON011
     C                   MOVEL(P)  KON(12)       KON012
     C                   MOVEL(P)  KON(13)       KON013
     C                   MOVEL(P)  KON(14)       KON014
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
     C                   MOVEL(P)  KON(26)       KON026
     C                   MOVEL(P)  KON(27)       KON027
     C                   MOVEL(P)  KON(28)       KON028
     C                   MOVEL(P)  KON(29)       KON029
     C                   MOVEL(P)  KON(30)       KON030
     C                   MOVEL(P)  KON(31)       KON031
     C                   MOVEL(P)  KON(32)       KON032
     C                   MOVEL(P)  KON(33)       KON033
     C                   MOVEL(P)  KON(34)       KON034
     C                   MOVEL(P)  KON(35)       KON035
     C                   MOVEL(P)  KON(36)       KON036
     C                   MOVEL(P)  KON(37)       KON037
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR TVAMC1                                             ***
     C**************************************************************************
     C     OTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TVAMC1 CURSOR FOR SELECT * FROM TVAM
     C+ WHERE TVAM.VMFIRM = :DAFIRM AND
     C+       TVAM.VMBEGR = :KYVMBG AND
     C+       TVAM.VMJHJJ = :KYVMJH AND
     C+       TVAM.VMMONA <= :KYVMMO
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN TVAMC1
     C/END-EXEC
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
     C                   EVAL      EXUX01INAM = 'WAO028'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100 + 298
     C                   EVAL      EXUX01KYLG = 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Druck WAO028'
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
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C*----------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM TVAMC1 INTO :TVAM
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C* Vertriebsbereich aus Kunden-Stamm
     C*----------------------------------------------------------
     C     VMKDNR        IFNE      KDKDNR
     C                   MOVEL(P)  VMKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*----------------------------------------------------------
     C     VMPRGR        IFEQ      *BLANK
     C     KDKSTC        OREQ      *BLANK
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EVAL      WKSORT     = VMPRGR + KDKSTC + VMKDNR
     C                                          + %CHAR(VMJHJJ) + %CHAR(VMMONA)
     C*--------------------------------------------------------
     C                   EVAL      EXUX01IDTA = WKSORT + TVAM
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      WKKSTC     = %SUBST(EXUX01IDTA: 5: 1)
     C*
     C                   EVAL      TVAM       = %SUBST(EXUX01IDTA: 101: 298)
     C*--------------------------------------------------------
     C     WKIKOP        IFEQ      *OFF
     C                   EXSR      DRKOPF
     C                   MOVE      *ON           WKIKOP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      DRPOSI
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     DRKOPF        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR1
     C                   WRITE     EXDRK1
     C                   WRITE     EXSTR2
     C                   WRITE     EXLEER
     C                   WRITE     EXSTR3
     C                   WRITE     EXDRP1
     C                   WRITE     EXSTR3
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSIITON                                                  ***
     C**************************************************************************
     C     DRPOSI        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*                  ADD       1             PTPOSI
     C*-------------------------------------------------------------------------
     C* Druck-Ausgabe
     C*-------------------------------------------------------------------------
     C                   IF        VMPRGR     <> PTPRGR
     C*--------------------------------------------------------
     C* Produktgruppe
     C*--------------------------------------------------------
     C                   IF        PTPRGR     <> *BLANK
     C                   Z-ADD(H)  SFLMON1       SFLMON
     C                   Z-ADD     SFLMON(1)     PTMON1
     C                   Z-ADD     SFLMON(2)     PTMON2
     C                   Z-ADD     SFLMON(3)     PTMON3
     C                   Z-ADD     SFLMON(4)     PTMON4
     C                   Z-ADD     SFLMON(5)     PTMON5
     C                   Z-ADD     SFLMON(6)     PTMON6
     C                   Z-ADD     SFLMON(7)     PTMON7
     C                   XFOOT     SFLMON        PTMON
     C*
     C                   Z-ADD(H)  SFLKUM1       SFLKUM
     C                   Z-ADD     SFLKUM(1)     PTKUM1
     C                   Z-ADD     SFLKUM(2)     PTKUM2
     C                   Z-ADD     SFLKUM(3)     PTKUM3
     C                   Z-ADD     SFLKUM(4)     PTKUM4
     C                   Z-ADD     SFLKUM(5)     PTKUM5
     C                   Z-ADD     SFLKUM(6)     PTKUM6
     C                   Z-ADD     SFLKUM(7)     PTKUM7
     C                   XFOOT     SFLKUM        PTKUM
     C*
     C                   Z-ADD     *ZERO         SFLMON1
     C                   Z-ADD     *ZERO         SFLKUM1
     C*
     C* Produktbereich
     C*
     C                   ADD       SFLMON        SFLMON2
     C                   ADD       SFLKUM        SFLKUM2
     C*
     C* Gesamt WAECO
     C*
     C                   ADD       SFLMON        SFLMON3
     C                   ADD       SFLKUM        SFLKUM3
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C*--------------------------------------------------------
     C* Produktbereich
     C*--------------------------------------------------------
     C                   IF        %SUBST(VMPRGR:1:1)
     C                             <> %SUBST(PTPRGR:1:1)
     C                   EVAL      PTPRGR      = %SUBST(PTPRGR:1:1)
     C                   EVAL      TXPRGR      = *BLANK
     C*
     C                   Z-ADD     SFLMON2(1)    PTMON1
     C                   Z-ADD     SFLMON2(2)    PTMON2
     C                   Z-ADD     SFLMON2(3)    PTMON3
     C                   Z-ADD     SFLMON2(4)    PTMON4
     C                   Z-ADD     SFLMON2(5)    PTMON5
     C                   Z-ADD     SFLMON2(6)    PTMON6
     C                   Z-ADD     SFLMON2(7)    PTMON7
     C                   XFOOT     SFLMON2       PTMON
     C*
     C                   Z-ADD     SFLKUM2(2)    PTKUM2
     C                   Z-ADD     SFLKUM2(3)    PTKUM3
     C                   Z-ADD     SFLKUM2(4)    PTKUM4
     C                   Z-ADD     SFLKUM2(5)    PTKUM5
     C                   Z-ADD     SFLKUM2(6)    PTKUM6
     C                   Z-ADD     SFLKUM2(7)    PTKUM7
     C                   XFOOT     SFLKUM2       PTKUM
     C*
     C                   Z-ADD     *ZERO         SFLMON2
     C                   Z-ADD     *ZERO         SFLKUM2
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C                   WRITE     EXLEER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  VMPRGR        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTCDE        PTPRGR
     C                   MOVEL(P)  TPTTXT        TXPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Vertriebsbereich
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I1
     C     WKKSTC        LOOKUP    SFLKSTC(I1)                            99
     C*
     C     *IN99         IFEQ      *OFF
     C                   LEAVESR
     C                   ENDIF
     C*--------------------------------------------------------
     C     VMMONA        IFEQ      KYVMMO
     C                   ADD       VMWTST        SFLMON1(I1)
     C                   ENDIF
     C                   ADD       VMWTST        SFLKUM1(I1)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE ENDE DER LISTE                                            ***
     C**************************************************************************
     C     ENDE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Druck-Ausgabe
     C*-------------------------------------------------------------------------
     C                   IF        PTPRGR     <> *BLANK
     C*--------------------------------------------------------
     C* Produktgruppe
     C*--------------------------------------------------------
     C                   Z-ADD(H)  SFLMON1       SFLMON
     C                   Z-ADD     SFLMON(1)     PTMON1
     C                   Z-ADD     SFLMON(2)     PTMON2
     C                   Z-ADD     SFLMON(3)     PTMON3
     C                   Z-ADD     SFLMON(4)     PTMON4
     C                   Z-ADD     SFLMON(5)     PTMON5
     C                   Z-ADD     SFLMON(6)     PTMON6
     C                   Z-ADD     SFLMON(7)     PTMON7
     C                   XFOOT     SFLMON        PTMON
     C*
     C                   Z-ADD(H)  SFLKUM1       SFLKUM
     C                   Z-ADD     SFLKUM(1)     PTKUM1
     C                   Z-ADD     SFLKUM(2)     PTKUM2
     C                   Z-ADD     SFLKUM(3)     PTKUM3
     C                   Z-ADD     SFLKUM(4)     PTKUM4
     C                   Z-ADD     SFLKUM(5)     PTKUM5
     C                   Z-ADD     SFLKUM(6)     PTKUM6
     C                   Z-ADD     SFLKUM(7)     PTKUM7
     C                   XFOOT     SFLKUM        PTKUM
     C*
     C                   Z-ADD     *ZERO         SFLMON1
     C                   Z-ADD     *ZERO         SFLKUM1
     C*
     C* Produktbereich
     C*
     C                   ADD       SFLMON        SFLMON2
     C                   ADD       SFLKUM        SFLKUM2
     C*
     C* Gesamt WAECO
     C*
     C                   ADD       SFLMON        SFLMON3
     C                   ADD       SFLKUM        SFLKUM3
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C*--------------------------------------------------------
     C* Produktbereich
     C*--------------------------------------------------------
     C                   EVAL      PTPRGR      = %SUBST(PTPRGR:1:1)
     C                   EVAL      TXPRGR      = *BLANK
     C*
     C                   Z-ADD     SFLMON2(1)    PTMON1
     C                   Z-ADD     SFLMON2(2)    PTMON2
     C                   Z-ADD     SFLMON2(3)    PTMON3
     C                   Z-ADD     SFLMON2(4)    PTMON4
     C                   Z-ADD     SFLMON2(5)    PTMON5
     C                   Z-ADD     SFLMON2(6)    PTMON6
     C                   Z-ADD     SFLMON2(7)    PTMON7
     C                   XFOOT     SFLMON2       PTMON
     C*
     C                   Z-ADD     SFLKUM2(2)    PTKUM2
     C                   Z-ADD     SFLKUM2(3)    PTKUM3
     C                   Z-ADD     SFLKUM2(4)    PTKUM4
     C                   Z-ADD     SFLKUM2(5)    PTKUM5
     C                   Z-ADD     SFLKUM2(6)    PTKUM6
     C                   Z-ADD     SFLKUM2(7)    PTKUM7
     C                   XFOOT     SFLKUM2       PTKUM
     C*
     C                   Z-ADD     *ZERO         SFLMON2
     C                   Z-ADD     *ZERO         SFLKUM2
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C                   WRITE     EXLEER
     C*--------------------------------------------------------
     C* Gesamt WAECO
     C*--------------------------------------------------------
     C                   EVAL      PTPRGR      = *BLANK
     C                   EVAL      TXPRGR      = %TRIM(KON029)
     C*
     C                   Z-ADD     SFLMON3(1)    PTMON1
     C                   Z-ADD     SFLMON3(2)    PTMON2
     C                   Z-ADD     SFLMON3(3)    PTMON3
     C                   Z-ADD     SFLMON3(4)    PTMON4
     C                   Z-ADD     SFLMON3(5)    PTMON5
     C                   Z-ADD     SFLMON3(6)    PTMON6
     C                   Z-ADD     SFLMON3(7)    PTMON7
     C                   XFOOT     SFLMON3       PTMON
     C*
     C                   Z-ADD     SFLKUM3(2)    PTKUM2
     C                   Z-ADD     SFLKUM3(3)    PTKUM3
     C                   Z-ADD     SFLKUM3(4)    PTKUM4
     C                   Z-ADD     SFLKUM3(5)    PTKUM5
     C                   Z-ADD     SFLKUM3(6)    PTKUM6
     C                   Z-ADD     SFLKUM3(7)    PTKUM7
     C                   XFOOT     SFLKUM3       PTKUM
     C*
     C                   Z-ADD     *ZERO         SFLMON3
     C                   Z-ADD     *ZERO         SFLKUM3
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C                   WRITE     EXLEER
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXLEER
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
     C                   EXSR      DRKOPF
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIKOP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKKSTC
     C     *LIKE         DEFINE    WKC001        WKSORT          +99
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKZEZA          + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTVAM
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
