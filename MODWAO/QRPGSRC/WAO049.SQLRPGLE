     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Drucken Umlagerungsvorschlag-Liste
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: ZG 04.09.2012 Projekt 8477
     H*  -----------------------------------------------------------------------
     H*  Änderung: ZG 09.04.2013 Projket 8477 Übernahme-KZ für LBLB-Auslagerung
     H**************************************************************************
     F*
     F*  Dieses Programm druckt die Umlagerungsvorschlag-Liste.
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
     FWAO049DR  O    E             PRINTER OFLIND(*IN98)
     F                                     INFDS(TRSPOL)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D LAN             S                   DIM(999)  ASCEND LIKE(LBBSLANR)
     D LAG             S                   DIM(999) ASCEND LIKE(I1LBBS)
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D CHST          E DS                  INZ
     D KYCHST        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D LBBS          E DS                  INZ
     D KYLBBS        E DS                  INZ
     D*
     D LBPL          E DS                  INZ
     D KYLBPL        E DS                  INZ
     D*
     D LBPM          E DS                  INZ
     D KYLBPM        E DS                  INZ
     D*
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D LBST          E DS                  INZ
     D KYLBST        E DS                  INZ
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
     D EXTR02        E DS                  INZ
     D EXTREND       E DS
     D EX4000          DS          4000
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D EXFIRM        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D RTLBAP        E DS                  INZ
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
     D*
     D I1LBBS          DS                  INZ
     D  D1VEDA                             LIKE(CHSTVEDA) INZ
     D  D1BSLA                             LIKE(LBBSBSLA) INZ
     D  D1LANR                             LIKE(LBBSLANR) INZ
     D  D1LORT                             LIKE(LBBSLORT) INZ
     D  D1CHAR                             LIKE(LBBSCHAR) INZ
     D  D1GEBI                             LIKE(LBBSGEBI) INZ
     D  D1FUMG                             LIKE(LBBSFUMG) INZ
     D  D1MEIN                             LIKE(LBBSMEIN) INZ
     D  D1QUMM                             LIKE(LBBSQUMM) INZ
     D  D1VFMG                             LIKE(LBBSLAGB) INZ
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
     C                   EXSR      UEBTRND
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
     C                   EXSR      KEYLBRS
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      OLBRS
     C*-------------------------------------------------------------------------
     C                   EXSR      UXOPEN
     C*-------------------------------------------------------------------------
     C                   EXSR      UXWRTE
     C*--------------------------------------------------------
     C                   EXSR      AUSWAHL
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
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYCHSTFIRM                     CHST
     C                   MOVEL(P)  DAFIRM        KYLBBSFIRM                     LBBS
     C                   MOVEL(P)  DAFIRM        KYLBRSFIRM                     LBRS
     C                   MOVEL(P)  DAFIRM        KYLTFI
     C                   MOVEL(P)  DAFIRM        KYLLFI                         LBPL
     C                   MOVEL(P)  DAFIRM        KYTEFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYLBPMFIRM                     LBPM
     C     WKSTMF        IFNE      *BLANK
     C                   MOVEL     WKSTMF        KYLBRSFIRM                     LBRS
     C                   MOVEL     WKSTMF        KYLTFI                         LBST
     C                   MOVEL     WKSTMF        KYLLFI                         LBPL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME EXTREND                                                ***
     C**************************************************************************
     C     UEBTRND       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDPRKZ    KOM
     C                   MOVEA     KOM(01)       EXTRNDLBAK
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  EXTRNDDATE    KOM
     C                   MOVEA     KOM(01)       EXTRNDLANR
     C*
     C                   MONITOR
     C                   EVAL      EXTRNDKMTE  = %INT(%SUBST(EXTRNDDATE:4:8))
     C                   ON-ERROR                *PROGRAM
     C                   EVAL      EXTRNDKMTE  = *ZERO
     C                   ENDMON
     C*
     C                   MOVEA     KOM(12)       EXTRNDLAKZ
     C*
     C                   MOVEA     KOM(13)       EXTRNDULAN
     C                   MOVEA     KOM(16)       EXTRNDULOR
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
     C                   CLEAR                   EX4000
     C                   MOVEA     *BLANK        KOM
     C                   MOVEA     WKTRPALBPL    KOM(13)
     C                   MOVEL     *ON           KOM(53)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'ELBSD '      #CPGST
     C                   CALL      'TRLBSD'
     C                   PARM                    EXTR02
     C                   PARM                    EX4000
     C                   MOVEA     EX4000        LAN
     C*-------------------------------------------------------------------------
     C                   IF        EXTRNDLANR = *BLANK
     C                   MOVEL(P)  LAN(01)       PTLA01
     C                   MOVEL(P)  LAN(02)       PTLA02
     C                   MOVEL(P)  LAN(03)       PTLA03
     C                   MOVEL(P)  LAN(04)       PTLA04
     C                   MOVEL(P)  LAN(05)       PTLA05
     C                   MOVEL(P)  LAN(07)       PTLA07
     C                   MOVEL(P)  LAN(08)       PTLA08
     C                   MOVEL(P)  LAN(09)       PTLA09
     C                   MOVEL(P)  LAN(10)       PTLA10
     C                   MOVEL(P)  LAN(11)       PTLA11
     C                   MOVEL(P)  LAN(12)       PTLA12
     C                   MOVEL(P)  LAN(13)       PTLA13
     C                   MOVEL(P)  LAN(14)       PTLA14
     C                   MOVEL(P)  LAN(15)       PTLA15
     C                   MOVEL(P)  LAN(17)       PTLA17
     C                   MOVEL(P)  LAN(18)       PTLA18
     C                   MOVEL(P)  LAN(19)       PTLA19
     C                   MOVEL(P)  LAN(20)       PTLA20
     C                   ELSE
     C                   MOVEL(P)  EXTRNDLANR    PTLA01
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG LBRS                                                ***
     C**************************************************************************
     C     KEYLBRS       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  *BLANK        KYLBRSSTAT
     C                   MOVEL(P)  '00'          KYLBAPSTAT
     C                   MOVEL(P)  '20'          KYAPST
     C                   MOVE      EXTRNDKMTE    KYAPKT
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRLBAP'      KYTATA
     C                   MOVEL(P)  'LBPC'        KYTATC
     C                   MOVEL(P)  'LGBE'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALBPL                     lagerbereich Picklis
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO049'      KYTATA
     C                   MOVEL(P)  'DEFAULT'     KYTATC
     C                   MOVEL(P)  'MBGP'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C*
     C                   MOVEL     TAPCDE        DUC010
     C                   TESTN                   DUC010               97        PRÜFUNG
     C     *IN(97)       IFNE      *ON                                          AUF
     C                   Z-ADD     999999999     WKTRPAMBGP
     C                   ELSE
     C                   Z-ADD     DUN100        WKTRPAMBGP
     C                   ENDIF
     C*----
     C                   MOVEL(P)  'TREND'       KYTATA
     C                   MOVEL(P)  'BSLA'        KYTATC
     C                   MOVEL(P)  'BSLA'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPABSLA
     C     WKTRPABSLA    IFNE      *ON
     C                   MOVEL     *OFF          WKTRPABSLA
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL     'LANR'        KYTATC                         STAMMFIRMA
     C                   MOVEL     'FIRM'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKSTMF
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
     C                   MOVEL(P)  'WAO049'      KYTPTA
     C                   MOVEL(P)  'WAO049'      KYTPTC
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
     C                   MOVEL(P)  KON(13)       KON013
     C                   MOVEL(P)  KON(14)       KON014
     C                   MOVEL(P)  KON(15)       KON015
     C                   MOVEL(P)  KON(16)       KON016
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR LBAPC1                                             ***
     C**************************************************************************
     C     OLBRS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBRSC1 CURSOR FOR
     C+ SELECT LBRSTENR, SUM(LBRSRSMG), COUNT(*)  FROM LBRS
     C+ WHERE LBRSFIRM = :DAFIRM AND LBRSSTAT<'90' AND
     C* (LBRSLANR= :PTLA01 OR LBRSLANR= :PTLA02 OR LBRSLANR= :PTLA03)
     C+ (LBRSAFDN='AFPO ' OR LBRSAFDN='AFUP ' ) AND
     C+ (LBRSKDKZ='R ' OR LBRSKDKZ='T') AND
     C+ (EXISTS(SELECT APKMTE FROM AFPO
     C+ WHERE APFIRM = LBRSFIRM AND APKMTE>=:KYAPKT AND
     C+ APAFST<:KYAPST AND APFIRM = LBRSFIRM AND LBRSDANA=' ' AND
     C+ LBRSJAHR = 0  AND LBRSNMKR=' ' AND
     C+ LBRSPOSI = 0  AND LBRSAFDN='AFPO ' AND
     C+ LBRSAFJJ = APAFJJ AND LBRSAFNR=APAFNR AND
     C+ LBRSAFPO = APAFPO AND LBRSAFUP=0) OR
     C+ EXISTS(SELECT APKMTE FROM AFPO
     C+ WHERE APFIRM = LBRSFIRM AND APKMTE>=:KYAPKT AND
     C+ APAFST<:KYAPST AND APFIRM = LBRSFIRM AND LBRSDANA=' ' AND
     C+ LBRSJAHR = 0  AND LBRSNMKR=' ' AND
     C+ LBRSPOSI = 0  AND LBRSAFDN='AFUP ' AND
     C+ LBRSAFJJ = APAFJJ AND LBRSAFNR=APAFNR AND
     C+ LBRSAFPO = APAFPO AND LBRSAFUP>0) OR
     C+ EXISTS(SELECT LBAPSTAT from LBAP WHERE
     C+ LBAPFIRM = LBRSFIRM AND LBAPDANA=LBRSDANA AND
     C+ LBAPKMJJ = LBRSJAHR AND LBAPKMNR=LBRSNMKR AND
     C+ LBAPKMPO = LBRSPOSI  AND LBAPSTAT=:KYLBAPSTAT AND
     C+ :EXTRNDLBAK='1') )
     C+ GROUP BY LBRSTENR
     C+ ORDER BY LBRSTENR
     C+ FOR FETCH ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBRSC1
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
     C                   EVAL      EXUX01INAM = 'WAO049'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100+ 900                        MAX 100 +  900 !!
     C                   EVAL      EXUX01KYLG = 100                             MAX 100
     C                   EVAL      EXUX01ITXT = 'Sortierung Druck WAO049'
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
     C+ FETCH NEXT FROM LBRSC1 INTO :WKTENR, :WKRSMG, :WKANZP
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*----------------------------------------------------------
     C                   MOVEL     TETENR        KYLTTE
     C                   MOVEL     TEEZNR        KYLTEZ
     C                   MOVEL     LAN(01)       KYLTLA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBST
     C                   IF        LTMBGP = *ZERO
     C                   Z-ADD     WKTRPAMBGP    LTMBGP
     C                   ENDIF
     C*----------------------------------------------------------
     C                   IF        WKRSMG < LTMBGP
     C                   ITER
     C                   ENDIF
     C*----------------------------------------------------------
     C                   EVAL      WKSORT = WKTENR
     C                   Z-ADD     WKRSMG        DUN134
     C*--------------------------------------------------------
     C                   EVAL      EXUX01IDTA = WKSORT   + DUC013
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
     C                   EVAL      WKTENR=%SUBST(EXUX01IDTA: 1: 15)
     C                   EVAL      DUC013=%SUBST(EXUX01IDTA: 101: 13)
     C                   Z-ADD     DUN134        WKRSMG
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
     C***  AUSGABE AUSWAHL                                                   ***
     C**************************************************************************
     C     AUSWAHL       BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C                   WRITE     EXDRK2
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
     C                   Z-ADD     WKANZP        PTPOSI
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTENR        KYTENR                         ERMITTELN
     C                   MOVE      *BLANK        KYTEEZ                         DATEN AUS
     C                   MOVEA     '01C     '    CHI                            IDENTSTAMM
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     WKTENR        PTTENR
     C                   MOVEL     TETBZ1        PTTBZ1
     C                   MOVEL     TETBZ2        PTTBZ2
     C                   Z-ADD     WKRSMG        PTRSMG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WKTENR        KYLBPMTENR
     C                   MOVEL(P)  *LOVAL        KYLBPMVPMI                     ERM.
     C                   MOVEA     '01+     '    CHI
     C                   EXSR      CHLBPM
     C     WKFENR        IFNE      *ZERO
     C     KYLBPMFIRM    ORNE      KYLBPMFIRM
     C     KYLBPMTENR    ORNE      KYLBPMTENR
     C                   Z-ADD     *ZERO         LBPMAZME
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     2             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR10
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKZEZA
     C                   EXSR      DRLBBS                                       LAGERBESTÄNDE
     C*-------------------------------------------------------------------------
     C                   SELECT
     C                   WHEN      I2=*ZERO
     C                   WRITE     EXLEER
     C                   WRITE     EXDR12
     C                   WRITE     EXDR12
     C                   WHEN      I2=1
     C                   WRITE     EXLEER
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN UND DRUCKEN BESTÄNDE                                    ***
     C**************************************************************************
     C     DRLBBS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      INFLG                                        INIT LAG
     C                   MOVE      *ZERO         I1
     C                   Z-ADD     1             I2
     C*
     C     LAN(I2)       DOWNE     *BLANK
     C                   EXSR      ELBBS
     C                   ADD       1             I2
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   SORTA     LAG                                          SORTIERUNG
     C*----------------------------------------------------------
     C                   Z-ADD     *ZERO         I2
     C                   Z-ADD     *ZERO         I1
     C*
     C     I1            DOWLT     999
     C                   ADD       1             I1
     C                   MOVEL     LAG(I1)       I1LBBS
     C*
     C     D1LANR        IFEQ      *BLANK
     C     D1VFMG        ORLE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   MOVEL(P)  D1LANR        PTLANR                             DRUCKEN BESTÄNDE
     C                   MOVEL(P)  D1LORT        PTLORT
     C                   MOVEL(P)  D1CHAR        PTCHAR
     C                   MOVEL(P)  D1GEBI        PTGEBI
     C                   Z-ADD     D1FUMG        PTFUMG
     C                   Z-ADD     D1VFMG        PTLAGB
     C*
     C                   CLEAR                   EXDATE
     C                   Z-ADD     D1VEDA        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   MOVEL     RTDATEDATE    PTDALZ
     C*
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR11
     C                   WRITE     EXDR12
     C                   MOVE      *BLANK        PTTBZ2
     C                   ADD       1             I2
     C*
     C     EXTRNDLAKZ    IFEQ      DAJNKZ
     C     WKRSMG        ANDGT     *ZERO
     C*
     C                   IF        D1VFMG > WKRSMG
     C                   Z-ADD     WKRSMG        WKMENG
     C                   ELSE
     C                   Z-ADD     D1VFMG        WKMENG
     C                   ENDIF
     C                   EXSR      TRLBAP
     C                   SUB       WKMENG        WKRSMG
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GERNERIEREN AUSLAGERUNGSAUFTRAG - POSITION                        ***
     C**************************************************************************
     C     TRLBAP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA(P)  'LBLB'        KOM(01)
     C                   Z-ADD     WKJAHR        DUN040
     C                   MOVEA(P)  DUC004        KOM(11)
     C                   MOVEA(P)  WKNMKR        KOM(15)
     C                   Z-ADD     WKPOSI        DUN040
     C                   MOVEA(P)  DUC004        KOM(21)
     C                   MOVEA(P)  EXTRNDULAN    KOM(26)
     C                   MOVEA(P)  WKTENR        KOM(57)
     C                   MOVEA(P)  PTLANR        KOM(72)
     C                   MOVEA(P)  PTLORT        KOM(75)
     C                   Z-ADD     WKMENG        DUN134
     C                   MOVEA(P)  DUC013        KOM(83)
     C                   MOVEA(P)  '          '  KOM(122)                       charge
     C                   MOVEA(P)  '   '         KOM(157)
     C                   MOVEA(P)  EXTRNDULOR    KOM(192)
     C                   MOVEA     KOM           #CKOMM
     C                   MOVEL(P)  'GLBAP '      #CPGST
     C                   MOVEL(P)  'GNLBLB'      #CPGST
     C                   CALL      'TRLBAP'
     C                   PARM                    EXTR02
     C                   PARM                    RTLBAP
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       WKDANA
     C                   MOVEA     KOM(11)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFEQ      *ON
     C                   Z-ADD     DUN040        WKJAHR
     C                   ELSE
     C                   Z-ADD     *ZERO         WKJAHR
     C                   ENDIF
     C                   MOVEA     KOM(15)       WKNMKR
     C                   MOVEA     KOM(21)       DUC004
     C                   TESTN                   DUC004               97
     C     *IN97         IFEQ      *ON
     C                   Z-ADD     DUN040        WKPOSI
     C                   ELSE
     C                   Z-ADD     *ZERO         WKPOSI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-INFLG      INITIALISIEREN FELDGRUPPEN                          ***
     C**************************************************************************
     C     INFLG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   I1LBBS
     C                   Z-ADD     *ZERO         I1
     C*-------------------------------------------------------------------------
     C     1             DO        999                                          INITIALISIEREN
     C*                                                                         FELDGRUPPE
     C                   ADD       1             I1
     C                   MOVE      I1LBBS        LAG(I1)
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ELBBS      ERMITTELN VERFÜGBARER LAGERBESTAND                  ***
     C**************************************************************************
     C     ELBBS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKFENR
     C                   CLEAR                   I1LBBS
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYLBBS
     C                   MOVEL     DAFIRM        KYLBBSFIRM
     C                   MOVEL     WKTENR        KYLBBSTENR
     C                   MOVEL     LAN(I2)       KYLBBSLANR
     C                   MOVEL     *LOVAL        KYLBBSBSLA
     C                   MOVEL     *LOVAL        KYLBBSBSTY
     C                   MOVEL     *LOVAL        KYLBBSWKNR
     C                   MOVEL     *LOVAL        KYLBBSKDNR
     C                   MOVEL     *LOVAL        KYLBBSLFNR
     C                   MOVEL     *LOVAL        KYLBBSFBNR
     C                   MOVEL     *LOVAL        KYLBBSGEBI
     C                   MOVEL     *LOVAL        KYLBBSCONT
     C                   MOVEL     *LOVAL        KYLBBSBHNR
     C                   MOVEL     *LOVAL        KYLBBSLORT
     C                   MOVEL     *LOVAL        KYLBBSCHAR
     C                   MOVEL     *LOVAL        KYLBBSFUMG
     C                   MOVEL     *LOVAL        KYLBBSMEIN
     C                   MOVEL     *LOVAL        KYLBBSQUMM
     C                   MOVEA     '02+     '    CHI
     C                   EXSR      CHLBBS
     C*-------------------------------------------------------------------------
     C     CHI(05)       DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     LBBSFIRM      IFNE      KYLBBSFIRM
     C     LBBSTENR      ORNE      KYLBBSTENR
     C     LBBSLANR      ORNE      KYLBBSLANR
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   DO
     C*----------------------------------------------------------
     C     LBBSSPKZ      IFEQ      DAJNKZ
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     LBBSLANR      KYLLLA                         PRÜFEN LAGER-
     C     WKTRPABSLA    IFEQ      *ON                                          PLATZ
     C                   MOVEL     LBBSBSLA      KYLLLA
     C                   ENDIF
     C                   MOVEL     LBBSLORT      KYLLLO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBPL
     C*
     C     LLSPKZ        IFEQ      DAJNKZ
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------
     C                   MOVEL(P)  LBBSBSLA      D1BSLA
     C                   MOVEL(P)  LBBSLANR      D1LANR
     C                   MOVEL(P)  LBBSLORT      D1LORT
     C                   MOVEL(P)  LBBSCHAR      D1CHAR
     C                   MOVEL(P)  LBBSGEBI      D1GEBI
     C                   Z-ADD     LBBSFUMG      D1FUMG
     C                   MOVEL(P)  LBBSMEIN      D1MEIN
     C                   MOVEL(P)  LBBSQUMM      D1QUMM
     C*----------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL(P)  LBBSFIRM      EXRSFIRM
     C                   MOVEL(P)  LBBSLANR      EXRSLANR
     C                   MOVEL(P)  LBBSBSLA      EXRSBSLA
     C                   MOVEL(P)  LBBSTENR      EXRSTENR
     C                   MOVEL(P)  LBBSBSTY      EXRSBSTY
     C                   MOVEL(P)  LBBSWKNR      EXRSWKNR
     C                   MOVEL(P)  LBBSKDNR      EXRSKDNR
     C                   MOVEL(P)  LBBSLFNR      EXRSLFNR
     C                   MOVEL(P)  LBBSFBNR      EXRSFBNR
     C                   MOVEL(P)  LBBSGEBI      EXRSGEBI
     C                   MOVEL(P)  LBBSCONT      EXRSCONT
     C                   MOVEL(P)  LBBSBHNR      EXRSBHNR
     C                   MOVEL(P)  LBBSLORT      EXRSLORT
     C                   MOVEL(P)  LBBSCHAR      EXRSCHAR
     C                   Z-ADD     LBBSFUMG      EXRSFUMG
     C                   MOVEL(P)  LBBSMEIN      EXRSMEIN
     C                   MOVEL(P)  LBBSQUMM      EXRSQUMM
     C                   MOVE      'ELBRS '      #CPGST
     C                   MOVE      *BLANK        #CKOMM
     C                   CALL      'TRLBRS'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*--------------------------------------------------------
     C     LBBSLAGB      SUB       RTRSRMMG      D1VFMG                         VERFÜGBARER-BESTAND
     C*----------------------------------------------------------
     C     D1VFMG        IFLE      *ZERO
     C                   Z-ADD     *ZERO         D1VFMG
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     LBBSCHAR      IFNE      *BLANK
     C                   MOVE      LBBSCHAR      KYCHSTCHAR
     C                   MOVE      LBBSTENR      KYCHSTTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHCHST
     C                   Z-ADD     CHSTVEDA      D1VEDA
     C                   ELSE
     C                   Z-ADD     LBBSDALZ      D1VEDA
     C                   ENDIF
     C*----------------------------------------------------------
     C     I1            IFLT      999
     C                   ADD(H)    1             I1
     C                   MOVEL     I1LBBS        LAG(I1)
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '02R     '    CHI
     C                   EXSR      CHLBBS
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
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
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   Z-ADD     2             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR13
     C*-------------------------------------------------------------------------
     C                   DO        99            I1
     C     LAN(I1)       IFNE      *BLANK
     C                   MOVEL     LAN(I1)       UFLBPLLANR
     C                   MOVE      *LOVAL        UFLBPLZGFK
     C                   MOVE      30            OFLBPLZGFK
     C                   EXSR      DRLBPL
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   WRITE     EXSTR3
     C                   WRITE     EXLEER
     C                   WRITE     EXLEER
     C                   WRITE     EXENDE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SQL-ÖFFNEN LBPL MIT LBBS   FREIE PLÄTZE                           ***
     C**************************************************************************
     C     OLBPL2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBPLC2 CURSOR
     C+ FOR SELECT
     C+     LBPL.LLLANR, LBPL.LLLORT
     C+ FROM LBPL  WHERE
     C+   LBPL.LLFIRM =  :DAFIRM  AND
     C+   LBPL.LLLANR =  :UFLBPLLANR  AND
     C+   LBPL.LLSPKZ =  ' '      AND
     C+   (LBPL.LLZGFK BETWEEN :UFLBPLZGFK AND :OFLBPLZGFK) AND NOT
     C+   EXISTS( SELECT LBBSLAGB FROM LBBS WHERE
     C+   LBBS.LBBSFIRM = LBPL.LLFIRM  AND
     C+   LBBS.LBBSLANR = LBPL.LLLANR  AND
     C+   LBBS.LBBSLORT = LBPL.LLLORT)
     C+ ORDER BY
     C+     LBPL.LLLANR,
     C+     LBPL.LLLORT
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN LBPLC2
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE POSIITON                                                  ***
     C**************************************************************************
     C     DRLBPL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      OLBPL2
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C                   Z-ADD     *ZERO         PTPOSI
     C*-------------------------------------------------------------------------
     C                   DOW       SQLCOD= *ZERO
     C*----------------------------------------------------------
     C/EXEC SQL
     C+ FETCH NEXT FROM LBPLC2 INTO :PTLANR, :PTLORT
     C/END-EXEC
     C*----------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C     PTPOSI        ORGT      10
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     1             WKZEZA
     C                   EXSR      ZEILZA
     C                   WRITE     EXDR14
     C                   ADD       1             PTPOSI
     C*----------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE LBPLC2
     C/END-EXEC
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
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKIKOP
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSORT          +99
     C     *LIKE         DEFINE    WKC001        WKTRPALBPL       +2
     C     *LIKE         DEFINE    WKC001        WKTRPABSLA
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKZEZA          + 2
     C     *LIKE         DEFINE    WKN010        WKANZP          + 4
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN100        WKTRPAMBGP                       Melde-Bestand
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    D1CHAR        PTCHAR
     C     *LIKE         DEFINE    D1GEBI        PTGEBI
     C     *LIKE         DEFINE    D1FUMG        PTFUMG
     C     *LIKE         DEFINE    LBBSLAGB      WKRSMG
     C     *LIKE         DEFINE    LBBSTENR      WKTENR
     C     *LIKE         DEFINE    DAFIRM        WKSTMF
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LLZGFK        UFLBPLZGFK
     C     *LIKE         DEFINE    LLZGFK        OFLBPLZGFK
     C     *LIKE         DEFINE    LLLANR        UFLBPLLANR
     C*
     C     *LIKE         DEFINE    LLLANR        EXTRNDLANR
     C     *LIKE         DEFINE    APKMTE        EXTRNDKMTE
     C     *LIKE         DEFINE    WKC001        EXTRNDLBAK
     C     *LIKE         DEFINE    WKC001        EXTRNDLAKZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPDANA      WKDANA
     C     *LIKE         DEFINE    LBAPJAHR      WKJAHR
     C     *LIKE         DEFINE    LBAPNMKR      WKNMKR
     C     *LIKE         DEFINE    LBAPPOSI      WKPOSI
     C     *LIKE         DEFINE    LBAPLANR      WKLANR
     C     *LIKE         DEFINE    LBAPLORT      WKLORT
     C     *LIKE         DEFINE    LBAPBWMG      WKMENG
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBAPLORT      EXTRNDULAN
     C     *LIKE         DEFINE    LBAPLANR      EXTRNDULOR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHCHST
     C/COPY QCPYSRC,CHLBBS
     C/COPY QCPYSRC,CHLBST
     C/COPY QCPYSRC,CHLBPL
     C/COPY QCPYSRC,CHLBPM
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,EXUX04
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,TRDATE
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
