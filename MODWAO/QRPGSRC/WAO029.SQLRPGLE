     H DECEDIT('0,') DATEDIT(*DMY.)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2002')
     H**************************************************************************
     H/TITLE  Erstellen einer Plan-Statistik
     H**************************************************************************
     H*  Copyright 2011 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 25.05.2011 Projekt 7375
     H*  -----------------------------------------------------------------------
/*  ÄH*  Änderung: MB Datum      Referenz
     H*
     H**************************************************************************
     F*
     F*  Dieses Programm dient zur Übernahme der Umsatz-Statistik in einer
     F*  Datei.
     F*
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
     F*  Ausgabe Monats-Umsatz pro Vertriebsbereich (KUND.KDKSTC),
     F*  Produkt-Gruppe (TEIL.TEPRGR)
     F*
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FUMSATZ    UF A E             DISK
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SFLUMS          S                   DIM(12) INZ LIKE(DUN090)
     D SFLWTST         S                   DIM(12) INZ LIKE(VMWTST)
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
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
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
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM
     C                   MOVEL(P)  DAFIRM        KYKDFI
     C                   MOVEL(P)  DAFIRM        KYTAFI
     C                   MOVEL(P)  DAFIRM        KYVMFI
     C                   MOVEL(P)  'ST2'         KYVMBG
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
     C                   CLEAR                   UMSATZ1
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DELETE FROM UMSATZ WHERE JAHR=:KYVMJH
     C/END-EXEC
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
     C***  ÖFFENEN CURSOR TVAMC1                                             ***
     C**************************************************************************
     C     OTVAM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TVAMC1 CURSOR FOR SELECT * FROM TVAM
     C+ WHERE TVAM.VMFIRM = :KYVMFI AND
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
     C* Vertriebsbereich aus Kunden-Stamm (KUND.KDKSTC)
     C*----------------------------------------------------------
     C     VMKDNR        IFNE      KDKDNR
     C                   MOVEL(P)  VMKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*----------------------------------------------------------
     C* Division aus Kunden-Stamm Erweiterung (KDEW.KDEWKSST)
     C*----------------------------------------------------------
     C     VMKDNR        IFNE      KDEWKDNR
     C                   MOVEL(P)  VMKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C*
     C                   MOVEL(P)  'KOST'        KYTPTA
     C                   MOVEL(P)  KDEWKSST      KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   ENDIF
     C*----------------------------------------------------------
     C*    VMPRGR        IFEQ      *BLANK
     C*    KDKSTC        OREQ      *BLANK
     C*    KDEWKSST      OREQ      *BLANK
     C*                  ITER
     C*                  ENDIF
     C*----------------------------------------------------------
     C                   EVAL      WKSORT     = VMPRGR + KDKSTC
     C                                          + %SUBST(TPTTXT:1:10)+ KDKDNR
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
     C                   EVAL      KDKSTC     = %SUBST(EXUX01IDTA: 5: 3)
     C                   EVAL      KDEWKSST   = %SUBST(EXUX01IDTA: 8: 10)
     C*
     C                   EVAL      TVAM       = %SUBST(EXUX01IDTA: 101: 298)
     C*--------------------------------------------------------
     C                   EXSR      AUSGABE
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE PLAN-STATISTIK                                            ***
     C**************************************************************************
     C     AUSGABE       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Datensatz hinzufügen
     C*-------------------------------------------------------------------------
     C                   IF        KDKSTC     <> AREA2       OR
     C                             VMPRGR     <> PG          OR
     C                             KDEWKSST   <> DIVISION
     C*--------------------------------------------------------
     C                   IF        TOTAL      <> *ZERO
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  PG            KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        BEZ
     C*
     C                   XFOOT     SFLUMS        TOTAL
     C                   Z-ADD     SFLUMS(01)    UMS01
     C                   Z-ADD     SFLUMS(02)    UMS02
     C                   Z-ADD     SFLUMS(03)    UMS03
     C                   Z-ADD     SFLUMS(04)    UMS04
     C                   Z-ADD     SFLUMS(05)    UMS05
     C                   Z-ADD     SFLUMS(06)    UMS06
     C                   Z-ADD     SFLUMS(07)    UMS07
     C                   Z-ADD     SFLUMS(08)    UMS08
     C                   Z-ADD     SFLUMS(09)    UMS09
     C                   Z-ADD     SFLUMS(10)    UMS10
     C                   Z-ADD     SFLUMS(11)    UMS11
     C                   Z-ADD     SFLUMS(12)    UMS12
     C*
     C                   WRITE     UMSATZ1                              98
     C                   ENDIF
     C*--------------------------------------------------------
     C                   CLEAR                   UMSATZ1
     C                   MOVEL     KDKSTC        AREA1
     C                   MOVEL     KDKSTC        AREA2
     C                   MOVEL     VMPRGR        PB
     C                   MOVEL     VMPRGR        PG
     C                   MOVEL     KDEWKSST      DIVISION
     C                   Z-ADD     VMJHJJ        JAHR
     C*
     C                   Z-ADD     *ZERO         SFLWTST
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Füllen Datei-Felder
     C*-------------------------------------------------------------------------
     C                   Z-ADD     VMMONA        I0
     C                   ADD       VMWTST        SFLWTST(I0)
     C                   ADD       VMWTST        TOTAL
     C*
     C                   Z-ADD(H)  SFLWTST       SFLUMS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSGABE ENDE DER LISTE                                            ***
     C**************************************************************************
     C     ENDE          BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   IF        TOTAL      <> *ZERO
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  PG            KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C                   MOVEL(P)  TPTTXT        BEZ
     C*
     C                   XFOOT     SFLUMS        TOTAL
     C                   Z-ADD     SFLUMS(01)    UMS01
     C                   Z-ADD     SFLUMS(02)    UMS02
     C                   Z-ADD     SFLUMS(03)    UMS03
     C                   Z-ADD     SFLUMS(04)    UMS04
     C                   Z-ADD     SFLUMS(05)    UMS05
     C                   Z-ADD     SFLUMS(06)    UMS06
     C                   Z-ADD     SFLUMS(07)    UMS07
     C                   Z-ADD     SFLUMS(08)    UMS08
     C                   Z-ADD     SFLUMS(09)    UMS09
     C                   Z-ADD     SFLUMS(10)    UMS10
     C                   Z-ADD     SFLUMS(11)    UMS11
     C                   Z-ADD     SFLUMS(12)    UMS12
     C*
     C                   WRITE     UMSATZ1                              98
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
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSORT          +99
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
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
