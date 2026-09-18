     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Drucken Picklisten
     H**************************************************************************
     H*  Copyright 2002 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 08.07.2010 Projekt 6231
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 10.12.2010 Projekt 6990  Umstellung Versand
     H*  Änderung: PH 14.12.2010 Projekt 6990. Selektion nach Kunden-Gruppe
     H*  Änderung: ZG 10.05.2011 Projekt 7238 Beistellung
     H*  Änderung: ZG 20.08.2012 Projket 8700 Erweiterung des Formates WAO01201
     H*            um 3 zusätzliche Felder für die Eingabe der Versandbedingungen.
     H*  Änderung: ZG 20.08.2012 Projket 8700 Erweiterung des Formates WAO01201
     H*  Änderung: ZG 05.12.2012 DOMETIC Projekt 8762
     H*            Trennung des Picklistendrucks nach Kunden - Änderung W1SORT
     H*  Änderung: ZG 16.05.2014 Projket 10278 Erweiterung der Selection
     H*            um 4 zusätzliche Felder BBKM-Komm-Nr.
     H*  Änderung: ZG 16.05.2014 Projket 10273 Erweiterung der Selection
     H*            um die VSBD-Gruppe.
     H*  Änderung: ZG 19.05.2014 Projket 10272 Erweiterung der Selection
     H*            um die VSBD-Gruppe.
     H*  Änderung: ZG 11.07.2014 Anruf Herr Schneider - Löschen WKFENR in der PRBBKM
     H**************************************************************************
     F*
     F*  Dieses Programm druckt die Liste LBAK.
     F*  Die Vorauswahl wurde mit dem Programm WAO012 getroffen.
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
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BBKM          E DS                  INZ
     D KYBBKM        E DS                  INZ
     D*
     D BBUP          E DS                  INZ
     D KYBBUP        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
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
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D AFKM          E DS                  INZ
     D KYAFKM        E DS                  INZ
     D*
     D LBPB          E DS                  INZ
     D KYLBPB        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTREND       E DS
     D RTTREND       E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D EXFIRM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXLBPC        E DS                  INZ
     D RTLBPC        E DS                  INZ
     D*
     D EXLBVS        E DS                  INZ
     D RTLBVS        E DS                  INZ
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
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
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C                   EXSR      KEYLBAK
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   SELECT
     C     KYLBAKDANA    WHENEQ    'BBKM'
     C                   EXSR      OBBKM
     C                   EXSR      UXOPENBBKM
     C                   EXSR      UXWRTEBBKM
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   EXSR      OLBAK
     C                   EXSR      UXOPEN
     C                   EXSR      UXWRTE
     C                   EXSR      UXREAD
     C                   ENDSL
     C*-------------------------------------------------------------------------
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
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYBUFI                         BBUP
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYLFFI                         LIEF
     C                   MOVEL(P)  DAFIRM        KYLBAPFIRM
     C                   MOVEL(P)  DAFIRM        KYLBAKFIRM
     C                   MOVEL(P)  DAFIRM        KYAMFI                         AFKM
     C                   MOVEL(P)  DAFIRM        KYBBKMFIRM                     BBKM
     C                   MOVEL(P)  DAFIRM        KYLBPBFIRM                     LBPB
     C                   MOVEL(P)  DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXTREND                                                ***
     C**************************************************************************
     C     UEBTREND      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDKEYB    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXTRNDDANA
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C*
     C                   MOVEA(P)  KOM(01)       EXTRNDSTAT
     C                   MOVEA(P)  KOM(03)       EXTRNDKDNR
     C                   MOVEA(P)  KOM(13)       EXTRNDAFAT
     C                   MOVEA(P)  KOM(16)       EXTRNDVSBD
     C                   MOVEA(P)  KOM(19)       EXTRNDPOLD
     C                   MOVEA(P)  KOM(22)       DUC008
     C                   Z-ADD     DUN080        EXTRNDLFTE
     C                   MOVEA(P)  KOM(30)       EXTRNDLANR
     C                   MOVEA(P)  KOM(33)       EXTRNDLPBE
     C                   MOVEA(P)  KOM(41)       DUC008
     C                   Z-ADD     DUN080        EXTRNDKMTE
     C                   MOVEA(P)  KOM(49)       EXTRNDKDGR
     C                   MOVEA(P)  KOM(53)       EXTRNDVSB2
     C                   MOVEA(P)  KOM(56)       EXTRNDVSB3
     C                   MOVEA(P)  KOM(59)       EXTRNDVSB4
     C*
     C                   MONITOR
     C                   MOVEA(P)  KOM(62)       DUC004
     C                   EVAL      EXTRNDKMJ1 = %INT(DUC004)
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      EXTRNDKMJ1 = *ZERO
     C                   ENDMON
     C                   MOVEA(P)  KOM(66)       EXTRNDKMN1
     C                   MONITOR
     C                   MOVEA(P)  KOM(72)       DUC004
     C                   EVAL      EXTRNDKMJ2 = %INT(DUC004)
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      EXTRNDKMJ2 = *ZERO
     C                   ENDMON
     C                   MOVEA(P)  KOM(76)       EXTRNDKMN2
     C                   MONITOR
     C                   MOVEA(P)  KOM(82)       DUC004
     C                   EVAL      EXTRNDKMJ3 = %INT(DUC004)
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      EXTRNDKMJ3 = *ZERO
     C                   ENDMON
     C                   MOVEA(P)  KOM(86)       EXTRNDKMN3
     C                   MONITOR
     C                   MOVEA(P)  KOM(92)       DUC004
     C                   EVAL      EXTRNDKMJ4 = %INT(DUC004)
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      EXTRNDKMJ4 = *ZERO
     C                   ENDMON
     C                   MOVEA(P)  KOM(96)       EXTRNDKMN4
     C*
     C                   MOVEA(P)  KOM(102)      EXTRNDVBGR
     C                   MOVEA(P)  KOM(105)      EXTRNDLGBE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKIKOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG LBAK                                                ***
     C**************************************************************************
     C     KEYLBAK       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDANA    KYLBAKDANA
     C                   MOVEL(P)  EXTRNDSTAT    KYLBAKSTAT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN OB
     C                   MOVEL     'POLD'        KYTATC                         POSTALISCHES
     C                   MOVEL     'POLD'        KYTAPA                         LAND
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL     TAPCDE        WKTRPAPOLD
     C                   ELSE
     C                   MOVEL     'D'           WKTRPAPOLD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR LBAKC1                                             ***
     C**************************************************************************
     C     OLBAK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBAKC1 CURSOR FOR SELECT * FROM LBAK
     C+ WHERE LBAKFIRM = :DAFIRM AND
     C+ LBAKDANA= :KYLBAKDANA AND
     C+ LBAKSTAT= :KYLBAKSTAT
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBAKC1
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
     C                   EVAL      EXUX01INAM = 'WAO013'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 30 + %LEN(LBAK)                 MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 30                              MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Bearbeitung '
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
     C+ FETCH NEXT FROM LBAKC1 INTO :LBAK
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EXSR      PRLBAK                                       Prüfen LBAK
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   Z-ADD     LBAKJAHR      DUN040
     C                   EVAL      WKSORT = LBAKDANA+DUC004+LBAKNMKR+LBAKKDNR
     C*--------------------------------------------------------
     C                   EVAL      EXUX01IDTA = WKSORT   + LBAK
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*----------------------------------------------------------
     C                   MOVEL(P)  LBAKDANA      KYLBAKDANA
     C                   Z-ADD     LBAKJAHR      KYLBAKJAHR
     C                   MOVEL(P)  LBAKNMKR      KYLBAKNMKR
     C                   MOVEA     '01CU    '    CHI                            NUR LESEN
     C                   EXSR      CHLBAK
     C*
     C                   SELECT
     C     LBAKSTAT      WHENEQ    '00'
     C                   MOVEL(P)  '01'          LBAKSTAT
     C     LBAKSTAT      WHENNE    '05'
     C                   MOVEL(P)  '06'          LBAKSTAT
     C                   ENDSL
     C*
     C                   SELECT
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHLBAK
     C                   ENDSL
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRLBAK        Prüfen LBAK                                         ***
     C**************************************************************************
     C     PRLBAK        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     LBAKDANA      WHENEQ    'AFKM'
     C     LBAKDANA      OREQ      'SKOM'
     C                   Z-ADD     LBAKJAHR      KYAMJH
     C                   MOVEL     LBAKNMKR      KYAMKM
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFKM
     C                   MOVEL(P)  AMPOLD        SFPOLD
     C*
     C     LBAKDANA      WHENEQ    'BGFS'
     C                   MOVEL(P)  'ADUMM '      #CPGST
     C                   EXSR      MOLBAK
     C                   EVAL      LBAKKDNR= %SUBST(RTTRNDDATE: 1: 5)
     C                   EVAL      SFPOLD  = %SUBST(RTTRNDDATE: 31: 3)
     C                   EVAL      SFVSAT  = %SUBST(RTTRNDDATE: 64: 2)
     C                   EVAL      SFLFTE  = %SUBST(RTTRNDDATE: 66: 8)
     C*
     C                   OTHER
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     KYLBAKSTAT    WHENEQ    '00'
     C     LBAKDANA      ANDEQ     'AFKM'
     C     AMKMAT        ANDNE     *BLANK
     C     AMKMAT        ANDNE     'K'
     C     AMKMAT        ANDNE     'M'
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     LBAKKDNR      IFNE      EXTRNDKDNR
     C     EXTRNDKDNR    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDKDGR    IFNE      *BLANK
     C                   MOVEL(P)  LBAKKDNR      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C     KDKDGR        IFNE      EXTRNDKDGR
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDVBGR    IFNE      *BLANK                                       prüfen VSBD-Gruppe
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL(P)  LBAKVSBD      EXTRNDKEYB
     C                   MOVEL(P)  'ERGWGR'      EXTRNDPGST
     C                   CALL      'TRWAOR   '                          99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C                   EVAL      WAORVBGR = %SUBST(RTTRNDDATE:10:3)
     C     EXTRNDVBGR    IFNE      WAORVBGR
     C     RTTRNDFENR    ORNE      '0000'
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXTRNDVSBD    WHENNE    *BLANK                                       prüfen VSBD
     C     EXTRNDVSBD    ANDEQ     LBAKVSBD
     C*
     C     EXTRNDVSB2    WHENNE    *BLANK                                       prüfen VSBD
     C     EXTRNDVSB2    ANDEQ     LBAKVSBD
     C*
     C     EXTRNDVSB3    WHENNE    *BLANK                                       prüfen VSBD
     C     EXTRNDVSB3    ANDEQ     LBAKVSBD
     C*
     C     EXTRNDVSB4    WHENNE    *BLANK                                       prüfen VSBD
     C     EXTRNDVSB4    ANDEQ     LBAKVSBD
     C*
     C     EXTRNDVSBD    WHENNE    *BLANK                                       prüfen VSBD
     C     EXTRNDVSB2    ORNE      *BLANK                                       prüfen VSBD
     C     EXTRNDVSB3    ORNE      *BLANK                                       prüfen VSBD
     C     EXTRNDVSB4    ORNE      *BLANK                                       prüfen VSBD
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     AMKMDA        IFGT      EXTRNDKMTE
     C     AMKMDA        ANDNE     *ZERO
     C     EXTRNDKMTE    ANDNE     *ZERO
     C     LBAKDANA      ANDEQ     'AFKM '
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C     AMKMDA        IFGT      EXTRNDKMTE
     C     AMKMDA        ANDNE     *ZERO
     C     EXTRNDKMTE    ANDNE     *ZERO
     C     LBAKDANA      ANDEQ     'SKOM '
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*
     C     LBAKBUDA      IFGT      EXTRNDKMTE
     C     LBAKBUDA      ANDNE     *ZERO
     C     EXTRNDKMTE    ANDNE     *ZERO
     C     LBAKDANA      ANDEQ     'BGFS '
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     EXTRNDPOLD    WHENEQ    WKTRPAPOLD
     C                   SELECT
     C                   WHEN      SFPOLD = *BLANK
     C                   WHEN      %TRIM(SFPOLD)<>%TRIM(WKTRPAPOLD)
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDSL
     C     EXTRNDPOLD    WHENNE    *BLANK
     C                   IF        %TRIM(SFPOLD)<>%TRIM(EXTRNDPOLD)
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C     EXTRNDAFAT    IFNE      *BLANK
     C     LBAKDANA      ANDEQ     'AFKM '
     C                   IF        AMAFAT<>EXTRNDAFAT
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXTRNDAFAT    IFNE      *BLANK
     C     LBAKDANA      ANDEQ     'BGFS '
     C                   IF        %TRIM(SFVSAT)<>%TRIM(EXTRNDAFAT)
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDLFTE    IFNE      *ZERO
     C     SFLFTE        ANDNE     *BLANK
     C     LBAKDANA      ANDEQ     'BGFS '
     C*
     C                   CLEAR                   EXDATE
     C                   EVAL      DUC006=%SUBST(SFLFTE:1:2)+%SUBST(SFLFTE:4:2)+
     C                             %SUBST(SFLFTE:7:2)
     C                   MOVEL     DUC006        DUC008
     C                   MOVE      DADJHT        DUC008
     C                   MOVE      DUN080        EXDATEDATV
     C                   MOVEL(P)  'TTMMJJJH'    EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DUN080
     C*
     C                   IF        DUN080 > EXTRNDLFTE
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXTRNDLFTE    IFNE      *ZERO
     C     AMLFTE        ANDNE     *ZERO
     C     LBAKDANA      ANDEQ     'AFKM '
     C                   IF        AMLFTE > EXTRNDLFTE
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*
     C     EXTRNDLFTE    IFNE      *ZERO
     C     AMLFTE        ANDNE     *ZERO
     C     LBAKDANA      ANDEQ     'SKOM '
     C                   IF        AMLFTE > EXTRNDLFTE
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EXTRNDLANR    IFNE      *BLANK
     C*
     C                   EXSR      PRLBAP
     C*
     C                   SELECT
     C     EXTRNDLPBE    WHENEQ    WKLBAPLPBE
     C     EXTRNDLPBE    ANDEQ     *BLANK
     C*    ohne bereich
     C     EXTRNDLPBE    WHENNE    *BLANK
     C     WKLBAPLANR    ANDEQ     EXTRNDLANR
     C     WKLBAPLPBE    ANDEQ     EXTRNDLPBE
     C*    ausgewählte Bereich
     C                   OTHER
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRUEFEN LBAP                                                      ***
     C**************************************************************************
     C     PRLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        WKLBAPLANR
     C                   MOVEL     *BLANK        WKLBAPLPBE
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LBAKSTAT      KYLBAPSTAT
     C                   MOVEL(P)  LBAKDANA      KYLBAPDANA
     C                   Z-ADD     LBAKJAHR      KYLBAPJAHR
     C                   MOVEL(P)  LBAKNMKR      KYLBAPNMKR
     C                   MOVE      *LOVAL        KYLBAPPOSI
     C                   MOVEA     '04+     '    CHI
     C                   EXSR      CHLBAP
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*--------------------------------------------------------
     C     LBAPFIRM      IFGT      KYLBAPFIRM
     C     LBAPSTAT      ORGT      KYLBAPSTAT
     C     LBAPDANA      ORGT      KYLBAPDANA
     C     LBAPJAHR      ORGT      KYLBAPJAHR
     C     LBAPNMKR      ORGT      KYLBAPNMKR
     C                   MOVE      *ZERO         WKFENR
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBAPLPBE      IFNE      *BLANK
     C                   MOVEL(P)  LBAPLANR      WKLBAPLANR
     C                   MOVEL(P)  LBAPLPBE      WKLBAPLPBE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '04R     '    CHI
     C                   EXSR      CHLBAP
     C                   MOVE      *ZERO         WKFENR
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MODWAOLBAK    Prüfen WAO1                                         ***
     C**************************************************************************
     C     MOLBAK        BEGSR
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
     C                   MOVEA     LBAKDANA      KOM(01)
     C                   Z-ADD     LBAKJAHR      DUN040
     C                   MOVEA     DUC004        KOM(11)
     C                   MOVEA     LBAKNMKR      KOM(15)
     C                   MOVEA     KOM           EXTRNDKEYB
     C*
     C                   MOVEL(P)  LBAK          EXTRNDDATE
     C*
     C                   MOVEL(P)  #CPGST        EXTRNDPGST
     C*
     C                   CALL      'MOLBAK   '                          99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTTRNDFENR    WKFENR
     C*
     C                   MOVEL(P)  RTTRNDRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXTRNDDANA    LBAKDANA
     C                   MOVE      *ZERO         LBAKJAHR
     C                   MOVE      *BLANK        LBAKNMKR
     C                   MOVEL(P)  'GNBGFS'      #CPGST
     C                   IF        KYLBAKSTAT='05' OR  KYLBAKDANA='SKOM'
     C                   MOVEL(P)  'G2BGFS'      #CPGST
     C                   ENDIF
     C                   EXSR      TRLBAP
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*--------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      LBAK = %SUBST(EXUX01IDTA: 31: %LEN(LBAK))
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBAKDANA      KYLBAKDANA
     C                   Z-ADD     LBAKJAHR      KYLBAKJAHR
     C                   MOVEL(P)  LBAKNMKR      KYLBAKNMKR
     C                   MOVEA     '01C     '    CHI                            NUR LESEN
     C                   EXSR      CHLBAK
     C                   IF        LBAKSTAT=KYLBAKSTAT
     C                   MOVEL(P)  'U1LBAK'      #CPGST
     C                   EXSR      TRLBAP
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSIITON                                                  ***
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
     C                   MOVEA(P)  EXTRNDLANR    KOM(72)
     C                   MOVEA(P)  EXTRNDLPBE    KOM(75)
     C                   MOVEA(P)  EXTRNDLGBE    KOM(157)
     C                   MOVEA(P)  EXTRNDVBGR    KOM(201)
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*
     C                   CALL      'TRLBAP'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE ENDE DER LISTE                                            ***
     C**************************************************************************
     C     ENDE          BEGSR
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
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIKOP
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSORT          +29
     C     *LIKE         DEFINE    WKC001        W1SORT          +99
     C     *LIKE         DEFINE    WKC001        W1LPBE                         PPL-KZ
     C     *LIKE         DEFINE    WKC001        W2LPBE                         PPL-KZ
     C     *LIKE         DEFINE    WKC001        WKLBRS
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
     C     *LIKE         DEFINE    KYLBAKDANA    UFLBAKDANA
     C     *LIKE         DEFINE    KYLBAKDANA    OFLBAKDANA
     C     *LIKE         DEFINE    KYLBAKSTAT    UFLBAKSTAT
     C     *LIKE         DEFINE    KYLBAKSTAT    OFLBAKSTAT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAKSTAT      EXTRNDSTAT
     C     *LIKE         DEFINE    LBAKKDNR      EXTRNDKDNR
     C     *LIKE         DEFINE    DUC003        EXTRNDAFAT
     C     *LIKE         DEFINE    LBAKVSBD      EXTRNDVSBD
     C     *LIKE         DEFINE    LBAKVSBD      EXTRNDVSB2
     C     *LIKE         DEFINE    LBAKVSBD      EXTRNDVSB3
     C     *LIKE         DEFINE    LBAKVSBD      EXTRNDVSB4
     C     *LIKE         DEFINE    DUC003        EXTRNDPOLD
     C     *LIKE         DEFINE    DUN080        EXTRNDLFTE
     C     *LIKE         DEFINE    DUN080        EXTRNDKMTE
     C     *LIKE         DEFINE    DUC003        EXTRNDLANR
     C     *LIKE         DEFINE    DUC008        EXTRNDLPBE
     C     *LIKE         DEFINE    DUC003        WKTRPAPOLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUC003        SFPOLD
     C     *LIKE         DEFINE    DUC008        SFLFTE
     C     *LIKE         DEFINE    DUC002        SFVSAT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYLBAKDANA    EXTRNDDANA
     C     *LIKE         DEFINE    KYLBAKSTAT    EXTRNDSTAT
     C     *LIKE         DEFINE    LBAPLANR      WKLBAPLANR
     C     *LIKE         DEFINE    LBAPLPBE      WKLBAPLPBE
     C     *LIKE         DEFINE    KDKDGR        EXTRNDKDGR
     C     *LIKE         DEFINE    LBPBLPBE      WKLBPBLPBE
     C     *LIKE         DEFINE    BUKMPO        WKKMPO
     C     *LIKE         DEFINE    DUN060        WKANZLPOSI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPKMJJ      EXTRNDKMJ1
     C     *LIKE         DEFINE    LBAPKMNR      EXTRNDKMN1
     C     *LIKE         DEFINE    LBAPKMJJ      EXTRNDKMJ2
     C     *LIKE         DEFINE    LBAPKMNR      EXTRNDKMN2
     C     *LIKE         DEFINE    LBAPKMJJ      EXTRNDKMJ3
     C     *LIKE         DEFINE    LBAPKMNR      EXTRNDKMN3
     C     *LIKE         DEFINE    LBAPKMJJ      EXTRNDKMJ4
     C     *LIKE         DEFINE    LBAPKMNR      EXTRNDKMN4
     C     *LIKE         DEFINE    LBAKVSBD      EXTRNDVBGR
     C     *LIKE         DEFINE    LBAKVSBD      WAORVBGR
     C     *LIKE         DEFINE    DUC003        EXTRNDLGBE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR BBMKC1                                             ***
     C**************************************************************************
     C     OBBKM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE BBKMC1 CURSOR FOR SELECT * FROM BBKM
     C+ WHERE BBKMFIRM = :DAFIRM AND
     C+ BBKMSTAT =  :KYLBAKSTAT
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN BBKMC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXOPENBBKM    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1 '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG =  100+900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG =  100                            MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                         '
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS2  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS2                  '
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXWRTEBBKM    BEGSR
     C*
     C                   MOVE      *BLANK        KYLBRSDANA                     ERSTER SATZ
     C                   MOVE      *ZERO         KYLBRSJAHR
     C                   MOVE      *BLANK        KYLBRSNMKR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C*----------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM BBKMC1 INTO :BBKM
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRBBKM                                       Prüfen LBAK
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  LFBSVB        LBAKVSBD
     C                   MOVEL(P)  *OFF          WKLBRS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYBBUP
     C                   MOVE      DAFIRM        KYBUFI                         SCHLÜSSEL
     C                   MOVE      BBKMKMJJ      KYBUKJ
     C                   MOVE      BBKMKMNR      KYBUKN
     C                   Z-ADD     *ZERO         KYBUKP
     C                   MOVE      *ZERO         WKKMPO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHBBUP
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BUFIRM        IFNE      KYBUFI
     C     BUKMJJ        ORGT      KYBUKJ
     C     BUKMNR        ORGT      KYBUKN
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C     BUBSST        IFGE      '80'
     C     BURMMG        ORGE      BUGSMG
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     BBKMKMAT      IFEQ      '2'                                          SUMARISCH
     C     BUKMPO        IFEQ      WKKMPO                                       GLEICHE KOM-POS
     C     WKKMPO        ANDNE     *ZERO                                        ÜBERLESEN
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     BUKMPO        WKKMPO
     C*----------------------------------------------------------
     C     BBKMKMJJ      IFNE      KYBBKMKMJJ
     C     BBKMKMNR      ORNE      KYBBKMKMNR
     C                   CLEAR                   EXLBVS
     C                   CLEAR                   RTLBVS
     C                   MOVEL     'ELORT '      EXLBVSPGST
     C                   MOVEL(P)  BBKMLFNR      EXLBVSKDNR
     C                   MOVEL(P)  *BLANK        EXLBVSVSNR
     C                   MOVEL(P)  'BBKM'        EXLBVSDANA
     C                   Z-ADD     BBKMKMJJ      EXLBVSJAHR
     C                   MOVEL(P)  BBKMKMNR      EXLBVSNMKR
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C     RTLBVSFENR    IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     BBKMKMJJ      KYBBKMKMJJ
     C                   MOVEL(P)  BBKMKMNR      KYBBKMKMNR
     C                   MOVEA     '01CU    '    CHI                            NUR LESEN
     C                   EXSR      CHBBKM
     C                   MOVEL(P)  '21'          BBKMSTAT
     C                   MOVEL(P)  DAJNAM        BBKMJNAM
     C                   MOVEL(P)  WKCHPN        BBKMPROG
     C                   MOVEL(P)  WKCHPL        BBKMBIBL
     C                   MOVEL(P)  DAUSER        BBKMUSER
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        BBKMJZEI
     C                   MOVE      WKTDAT        BBKMJDAT
     C                   SELECT
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHBBKM
     C                   ENDSL
     C                   MOVEL     RTLBVSLANR    LBAPULAN
     C                   MOVEL     RTLBVSLORT    LBAPULOR
     C                   Z-ADD     *ZERO         WKANZLPOSI
     C                   MOVE      *LOVAL        W1LPBE                         Bereich
     C                   MOVE      *LOVAL        W2LPBE                         Paralle-Pickliste
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     BUKOTE        KYTENR                         ZUGRIFF
     C                   MOVEL     *BLANK        KYTEEZ                         IDENTNUMMER
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   ADD       1             WKANZLPOSI
     C                   EXSR      E4LBRS
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '05R     '    CHI
     C                   EXSR      CHBBUP
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      WKLBRS =*OFF
     C* Platz im 002 löschen
     C                   CLEAR                   EXLBVS
     C                   MOVEL(P)  '4    '       EXLBVSPGST
     C                   MOVE      RTLBVSTSTP    EXLBVSTSTP
     C                   CALL      'TRLBVS'
     C                   PARM                    EXLBVS
     C                   PARM                    RTLBVS
     C* status zurück
     C                   Z-ADD     BBKMKMJJ      KYBBKMKMJJ
     C                   MOVEL(P)  BBKMKMNR      KYBBKMKMNR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBKM
     C                   MOVEL(P)  '20'          BBKMSTAT
     C                   SELECT
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHBBKM
     C                   ENDSL
     C*
     C                   WHEN      WKLBRS =*ON  AND W2LPBE=*HIVAL
     C                   Z-ADD     BBKMKMJJ      KYBBKMKMJJ
     C                   MOVEL(P)  BBKMKMNR      KYBBKMKMNR
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBKM
     C                   MOVEL(P)  '22'          BBKMSTAT
     C                   SELECT
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI                            SATZ UPDATEN
     C                   EXSR      CHBBKM
     C                   ENDSL
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     'GNBGFS'      #CPGST
     C                   EXSR      TRLBPC
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXCLOSLBPC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  CLOSE  USERINDEX                                                  ***
     C**************************************************************************
     C     EXUXCLOSLBPC  BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS2  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS2                  '
     C                   EXSR      EXUXCLOS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI LBPC                                                 ***
     C**************************************************************************
     C     TRLBPC        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBPC
     C                   CLEAR                   RTLBPC
     C                   MOVEL(P)  #CPGST        EXLBPCPGST
     C*
     C                   CALL      'TRLBPC'
     C                   PARM                    EXLBPC
     C                   PARM                    RTLBPC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLBPCRTCD    #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRBBKM        Prüfen LBAK                                         ***
     C**************************************************************************
     C     PRBBKM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C     EXTRNDKMN1    IFNE      *BLANK
     C     EXTRNDKMN2    ORNE      *BLANK
     C     EXTRNDKMN3    ORNE      *BLANK
     C     EXTRNDKMN4    ORNE      *BLANK
     C*
     C                   SELECT
     C     BBKMKMJJ      WHENEQ    EXTRNDKMJ1
     C     BBKMKMNR      ANDEQ     EXTRNDKMN1
     C                   LEAVESR
     C     BBKMKMJJ      WHENEQ    EXTRNDKMJ2
     C     BBKMKMNR      ANDEQ     EXTRNDKMN2
     C                   LEAVESR
     C     BBKMKMJJ      WHENEQ    EXTRNDKMJ3
     C     BBKMKMNR      ANDEQ     EXTRNDKMN3
     C                   LEAVESR
     C     BBKMKMJJ      WHENEQ    EXTRNDKMJ4
     C     BBKMKMNR      ANDEQ     EXTRNDKMN4
     C                   LEAVESR
     C                   OTHER
     C                   MOVEL     '0031'        WKFENR
     C                   LEAVESR
     C                   ENDSL
     C*
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BBKMKMTE      IFGT      EXTRNDKMTE
     C     EXTRNDKMTE    ANDNE     *ZERO
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BBKMLFNR      IFNE      EXTRNDKDNR
     C     EXTRNDKDNR    ANDNE     *BLANK
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     BBKMLFNR      KYLFNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLIEF
     C*-------------------------------------------------------------------------
     C     EXTRNDVSBD    IFNE      *BLANK                                       prüfen VSBD
     C     EXTRNDVSBD    ANDNE     LFBSVB
     C                   MOVE      '0031'        WKFENR
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*** ERMITTLEN LBRS-SATZ  für Pickliste                                 ***
     C**************************************************************************
     C     E4LBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BBUP'        KYLBRSAFDN                     ERSTER SATZ
     C                   Z-ADD     BUBEJJ        KYLBRSAFJJ
     C                   MOVEL(P)  BUBENR        KYLBRSAFNR
     C                   Z-ADD     BUBEPO        KYLBRSAFPO
     C                   Z-ADD     BUUPOS        KYLBRSAFUP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BBKM'        KYLBRSDANA                     ERSTER SATZ
     C                   Z-ADD     BUKMJJ        KYLBRSJAHR
     C                   MOVEL(P)  BUKMNR        KYLBRSNMKR
     C                   Z-ADD     BUKMPO        KYLBRSPOSI
     C                   MOVE      *LOVAL        KYLBRSTMST
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBRS
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     LBRSFIRM      IFGT      KYLBRSFIRM
     C     LBRSDANA      ORGT      KYLBRSDANA
     C     LBRSJAHR      ORGT      KYLBRSJAHR
     C     LBRSNMKR      ORGT      KYLBRSNMKR
     C     LBRSPOSI      ORGT      KYLBRSPOSI
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSDANA      IFEQ      'BBKM'
     C     LBRSAFDN      ANDEQ     'BBUP'
     C*
     C     LBRSAFDN      IFNE      KYLBRSAFDN
     C     LBRSAFJJ      ORNE      KYLBRSAFJJ
     C     LBRSAFNR      ORNE      KYLBRSAFNR
     C     LBRSAFPO      ORNE      KYLBRSAFPO
     C     LBRSAFUP      ORNE      KYLBRSAFUP
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBRSSTAT      IFGE      '90'
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     *BLANK        WKLBPBLPBE
     C                   EXSR      PRLBPB
     C                   SELECT
     C     W1LPBE        WHENEQ    *LOVAL
     C     WKLBPBLPBE    ANDEQ     *BLANK
     C                   MOVE      *BLANK        W1LPBE
     C     W1LPBE        WHENEQ    *LOVAL
     C     WKLBPBLPBE    ANDNE     *BLANK
     C                   MOVE      *ON           W1LPBE                         PPL
     C     W1LPBE        WHENEQ    *BLANK
     C     WKLBPBLPBE    ANDEQ     *BLANK
     C                   OTHER
     C                   MOVE      *ON           W1LPBE                         PPL
     C                   ENDSL
     C*
     C                   SELECT
     C     W2LPBE        WHENEQ    *LOVAL
     C                   MOVEL     WKLBPBLPBE    W2LPBE
     C     W2LPBE        WHENEQ    WKLBPBLPBE
     C                   OTHER
     C                   MOVEL     *HIVAL        W2LPBE                         PPL
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVEL     *BLANK        DUC010
     C                   Z-ADD     LBRSJAHR      DUN040
     C                   Z-ADD     LBRSPOSI      DUN050
     C                   Z-ADD     LBRSTMST      DUN260
     C     999999        SUB       WKANZLPOSI    DUN060
     C                   EVAL      W1SORT = LBRSBSLA+LBRSLANR+ DUC010 +
     C                             LBAKVSBD + DUC006 + DUC004 + LBRSNMKR
     C                             + WKLBPBLPBE
     C                             + DUC005 + DUC026 + LBAPULAN+LBAPULOR
     C                             + W1LPBE
     C*
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS1  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS1                  '
     C                   EVAL      EXUX01IDTA = W1SORT   + LBRS
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         DUN060
     C                   EVAL      W1SORT = LBRSBSLA+LBRSLANR+DUC010+
     C                             LBAKVSBD + DUC004 + LBRSNMKR
     C                             + WKLBPBLPBE
     C                             + DUC006+DUC005+DUC026+LBAPULAN+LBAPULOR
     C                             + W1LPBE
     C*
     C                   CLEAR                   EXUX01PARM
     C                   EVAL      EXUX01INAM = 'LBRS2  '
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'LBRS2                  '
     C                   EVAL      EXUX01IDTA = W1SORT   + LBRS
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*
     C                   MOVEL(P)  *ON           WKLBRS
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PRÜFEN, OB DIE PLÄTZE ZU DEM LAGERBEREICH  ZUGEORDNET SIND        ***
     C**************************************************************************
     C     PRLBPB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     TELORT        WHENNE    *BLANK
     C                   MOVEL(P)  LBRSLANR      KYLBPBLANR
     C                   MOVEL(P)  TELORT        KYLBPBLPBE
     C                   MOVEL(P)  LBRSLORT      KYLBPBLORT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPB
     C     CHI(5)        IFEQ      'J'
     C                   MOVEL     LBPBLPBE      WKLBPBLPBE
     C                   ENDIF
     C                   OTHER
     C                   MOVEL(P)  LBRSLANR      KYLBPBLANR
     C                   MOVEL(P)  LBRSLORT      KYLBPBLORT
     C                   MOVEL(P)  *LOVAL        KYLBPBLPBE
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBPB
     C     CHI(5)        IFEQ      'J'
     C     LBPBFIRM      ANDEQ     KYLBPBFIRM
     C     LBPBLANR      ANDEQ     KYLBPBLANR
     C     LBPBLORT      ANDEQ     KYLBPBLORT
     C                   MOVEL     LBPBLPBE      WKLBPBLPBE
     C                   ENDIF
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFKM
     C/COPY QCPYSRC,CHBBKM
     C/COPY QCPYSRC,CHBBUP
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHLBAK
     C/COPY QCPYSRC,CHLBAP
     C/COPY QCPYSRC,CHLBPB
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHLIEF
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
