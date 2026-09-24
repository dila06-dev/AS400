     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Drucken Pickliste gesperrte Lagerbestände
     H**************************************************************************
     H*  Copyright 2007 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 15.10.2007 Projekt 4479
     H*  -----------------------------------------------------------------------
     H**************************************************************************
     F*
     F*  Dieses Programm druckt die Pickliste gesperrte Lagerbestände
     F*  Die Vorauswahl wurde mit dem Programm WAO005 getroffen.
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
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO006DR  O    E             PRINTER OFLIND(*IN98)
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
     D WAO1          E DS                  INZ
     D KYWAO1        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTREND       E DS
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D EXFIRM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
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
     C                   PARM                    EXTREND
     C*
     C                   EXSR      UEBTREND
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
     C                   EXSR      KEYWAO1
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OWAO1
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
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYWAO1FIRM                     WAO1
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C                   MOVEL     DAFIRM        KYTUFI                         TEUF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXTREND                                                ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     EXTRNDKEYB    KOM
     C*
     C                   MOVEL(P)  KOM(11)       DUC004
     C                   TESTN                   DUC004               98        PRÜFUNG
     C     *IN(98)       IFNE      '1'                                          AUF
     C                   MOVE      *ZERO         DUC004                         NUMERISCHEN
     C                   END                                                    INHALT
     C                   Z-ADD     DUN040        EXTRNDLIJJ
     C*
     C                   MOVEL(P)  KOM(15)       EXTRNDLINR
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
     C                   MOVEA     KON(01)       W99(32)
     C                   MOVEA(P)  W99(01)       PTKOPF
     C*-------------------------------------------------------------------------
     C                   MOVE      *DATE         PTDATE
     C                   TIME                    PTTIME
     C                   Z-ADD     1             PTSEIT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIKOP
     C                   Z-ADD     *ZERO         PTPOSI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAO1                                                ***
     C**************************************************************************
     C     KEYWAO1       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXTRNDLIJJ    KYWAO1LIJJ
     C                   MOVEL     EXTRNDLINR    KYWAO1LINR
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        UFWAO1LIJJ
     C                   MOVE      *HIVAL        OFWAO1LIJJ
     C     KYWAO1LIJJ    IFNE      *ZERO
     C                   EVAL      UFWAO1LIJJ =  KYWAO1LIJJ
     C                   EVAL      OFWAO1LIJJ =  KYWAO1LIJJ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *LOVAL        UFWAO1LINR
     C                   MOVE      *HIVAL        OFWAO1LINR
     C     KYWAO1LINR    IFNE      *BLANK
     C                   EVAL      UFWAO1LINR =  KYWAO1LINR
     C                   EVAL      OFWAO1LINR =  KYWAO1LINR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      '05'          UFWAO1UEST
     C                   MOVE      '15'          OFWAO1UEST
     C***                MOVE      '30'          OFWAO1UEST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBAP'      KYTATA                         ERMITTELN OB
     C                   MOVEL(P)  'LGRS'        KYTATC                         LAGERRBEREICHSRES.
     C                   MOVEL(P)  'LGBE'        KYTAPA                         ERFOLGEN SOLL
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALGBE
     C*-------------------------------------------------------------------------
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
     C                   MOVEL(P)  'WAO006'      KYTPTA
     C                   MOVEL(P)  'WAO006'      KYTPTC
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
     C                   MOVEL(P)  KON(07)       KON007
     C                   MOVEL(P)  KON(08)       KON008
     C                   MOVEL(P)  KON(09)       KON009
     C                   MOVEL(P)  KON(10)       KON010
     C                   MOVEL(P)  KON(11)       KON011
     C                   MOVEL(P)  KON(12)       KON012
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAO1C1                                             ***
     C**************************************************************************
     C     OWAO1         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAO1C1 CURSOR FOR SELECT * FROM WAO1
     C+ WHERE WAO1FIRM = :DAFIRM AND
     C+ WAO1LIJJ BETWEEN :UFWAO1LIJJ AND :OFWAO1LIJJ AND
     C+ WAO1LINR BETWEEN :UFWAO1LINR AND :OFWAO1LINR AND
     C+ WAO1UEST BETWEEN :UFWAO1UEST AND :OFWAO1UEST
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAO1C1
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
     C                   EVAL      EXUX01INAM = 'WAO006'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 13                         MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Druck WAO006'
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
     C+ FETCH NEXT FROM WAO1C1 INTO :WAO1
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL(P)  WAO1TENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*----------------------------------------------------------
     C                   Z-ADD     WAO1AFMG      DUN134                         IN IDENT-ME
     C     WAO1MEVS      IFNE      *BLANK
     C     WAO1MEVS      ANDNE     TEMEIN
     C                   MOVEL     WAO1TENR      KYTUTE                         BERECHNEN DER
     C                   MOVEL     WAO1MEVS      KYTUME                         GESAMT MENGE
     C                   Z-ADD     WAO1AFMG      WKV1V2                         IN IDENT-ME
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV1V2        DUN134
     C                   ENDIF
     C*----------------------------------------------------------
     C                   Z-ADD     WAO1RALP      DUN050
     C                   EVAL      EXUX01IKEY = WAO1TENR + %CHAR(WAO1LIJJ) +
     C                                          WAO1LINR + DUC005
     C*
     C                   EVAL      EXUX01IDTA = EXUX01IKEY + DUC013
     C*--------------------------------------------------------
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
     C                   MOVE      *BLANK        WAO1TENR
     C                   MOVE      *BLANK        W1TENR
     C                   MOVE      *ZERO         W1BSMG
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      WAO1TENR = %SUBST(EXUX01IDTA: 1: 15)
     C                   EVAL      DUC013   = %SUBST(EXUX01IDTA: 101: 13)
     C                   Z-ADD     DUN134        WKBSMG
     C*--------------------------------------------------------
     C     WKIKOP        IFEQ      *OFF
     C                   EXSR      DRKOPF
     C                   MOVE      *ON           WKIKOP
     C                   MOVE      WAO1TENR      W1TENR
     C                   MOVE      *ZERO         W1BSMG
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C     WAO1TENR      WHENEQ    W1TENR
     C                   OTHER
     C                   EXSR      DRPOSI
     C                   Z-ADD     *ZERO         W1BSMG
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL(P)  WAO1TENR      W1TENR
     C                   ADD       WKBSMG        W1BSMG
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     W1BSMG        WHENNE    *ZERO
     C                   EXSR      DRPOSI
     C                   Z-ADD     *ZERO         W1BSMG
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE KOPF                                                      ***
     C**************************************************************************
     C     DRKOPF        BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C                   ADD       1             PTPOSI
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  W1TENR        KYTENR                         PRÜFEN
     C                   MOVEL     *BLANK        KYTEEZ                         IDENTNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKLAGB                         LAGERBESTAND
     C                   Z-ADD     *ZERO         WKSPBS                         SPERRBESTAND
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVE      *ON           KOM(1)                         PRÜFUNG-KZ
     C                   MOVE      *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVE      *ON           KOM(3)                         REVERV.BESTAND
     C                   MOVE      *OFF          KOM(4)                         ERM.DIST RESERV.
     C                   MOVE      *OFF          KOM(5)                         BEDARFSPLAN-LAGER
     C                   MOVEA     *BLANK        KOM(6)                         LAGERBEREICH= 'P'
     C                   MOVE      *ON           KOM(7)                         LAGERPLATZSPERRUNG
     C*
     C                   MOVEA     W1TENR        KOM(10)
     C                   MOVEA     *BLANK        KOM(25)                        LAGER
     C                   MOVEA     *BLANK        KOM(28)
     C                   MOVEA     *BLANK        KOM(43)
     C                   MOVEA     *BLANK        KOM(63)
     C                   Z-ADD     *ZERO         DUN114
     C                   MOVEA     DUC011        KOM(86)
     C                   MOVEA     *BLANK        KOM(98)
     C                   MOVEA     WKTRPALGBE    KOM(99)
     C                   MOVEA     *BLANK        KOM(102)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C*
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C                   Z-ADD     DUN134        WKLAGB
     C                   MOVEA     KOM(92)       DUC013
     C                   SUB       DUN134        WKLAGB
     C                   MOVEA     KOM(144)      DUC013
     C                   Z-ADD     DUN134        WKSPBS
     C*-------------------------------------------------------------------------
     C                   IF        W1BSMG>WKLAGB AND WKSPBS<>0
     C*
     C                   MOVEL     TETENR        PTTENR
     C                   MOVEL     TETBZ1        PTTBZ1
     C                   MOVEL     TETBZ2        PTTBZ2
     C                   IF        (W1BSMG-WKLAGB) > WKSPBS
     C                   Z-ADD     WKSPBS        PTLAGB
     C                   ELSE
     C                   EVAL      PTLAGB = W1BSMG-WKLAGB
     C                   ENDIF
     C*
     C                   Z-ADD     2             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C*
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
     C     WKIKOP        IFEQ      *OFF
     C                   EXSR      DRKOPF
     C                   MOVE      *ON           WKIKOP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     4             WKZEZA
     C                   EXSR      ZEILZA
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
     C     *LIKE         DEFINE    WKC001        WKSORT          +29
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
     C     *LIKE         DEFINE    KYWAO1LIJJ    UFWAO1LIJJ
     C     *LIKE         DEFINE    KYWAO1LIJJ    OFWAO1LIJJ
     C     *LIKE         DEFINE    KYWAO1LINR    UFWAO1LINR
     C     *LIKE         DEFINE    KYWAO1LINR    OFWAO1LINR
     C     *LIKE         DEFINE    KYWAO1UEST    UFWAO1UEST
     C     *LIKE         DEFINE    KYWAO1UEST    OFWAO1UEST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO1LIJJ      EXTRNDLIJJ
     C     *LIKE         DEFINE    WAO1LINR      EXTRNDLINR
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAO1TENR      W1TENR
     C     *LIKE         DEFINE    DUN134        WKBSMG
     C     *LIKE         DEFINE    DUN134        W1BSMG
     C     *LIKE         DEFINE    WKC001        WKTRPALGBE      + 2            LAGERBEREICH
     C     *LIKE         DEFINE    DUN134        WKLAGB                         LAGERBESTAND
     C     *LIKE         DEFINE    DUN134        WKSPBS                         SPERRBESTAND
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHWAO1
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,VTEUF
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
