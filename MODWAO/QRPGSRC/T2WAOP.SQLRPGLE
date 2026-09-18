     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE  Generieren Absatz/Umsatz-Plan PlanungsKD/Artikel
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: MG 22.07.2011 Projekt 8559
     H*  -----------------------------------------------------------------------
     H*  Änderung: MG 07.09.2012 Projekt 8886,
     H*            Erweiterung der Datei WAOK um das Feld WAOKLDNR "Land-Nr"
/*  ÄH*  Änderung: MG 10.09.2012 Projekt 8886 Neues Selektionsfeld "Plan-Art" (Plan-Basis)
/*  ÄH*  Änderung: MG 02.10.2012 Projekt 8945 Neues Selektionsfeld "Comm.Division"
     H*            Selektion KD-Steuerungscode, Kunden-Gruppe aus Kunden-Stamm
     H*  Änderung: MG 26.11.2012 Projekt 9103  Vereinfachte Möglichkeit der Veränderung %-Sätze
     H*            Erweiterung der Datei WAOM um die Felder WAOMLDNR, WAOMSTKD
     F**************************************************************************
     F*/
     F*/ Dieses Programm generiert Absatz-Plan (WAOP-Sätze) auf Basis
     F*/ Ist-Werte (TVAM-Sätze) bzw. auf Basis Plan-Werte Vorjahr (WAOP-Sätze)
     F*/
     F*/ Die Vorauswahl wurde mit dem Programm T1WAOP getroffen.
     F*/
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D SFLPZ           S                   DIM(12) INZ LIKE(WAOMPZ01)
     D*
     D SFLMG           S                   DIM(12) INZ LIKE(WAOPPLMG)
     D SFLUM           S                   DIM(12) INZ LIKE(WAOPPLUM)
     D SFLER           S                   DIM(12) INZ LIKE(WAOPERTR)
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
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D TVAM          E DS                  INZ
     D KYTVAM        E DS                  INZ
     D*
     D WAOK          E DS                  INZ
     D KYWAOK        E DS                  INZ
     D*
     D WAOM          E DS                  INZ
     D KYWAOM        E DS                  INZ
     D*
     D WAOP          E DS                  INZ
     D KYWAOP        E DS                  INZ
     D WKWAOP        E DS                  EXTNAME(WAOP) PREFIX(WK)
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXWAOP        E DS                  INZ
     D RTWAOP        E DS                  INZ
     D*
     D E1WAOP        E DS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXUX01
     D*
     D  IKEYTVAM                    100
     D   IKEYPLAT                     3    OVERLAY(IKEYTVAM:1)
     D   IKEYWKNR                     3    OVERLAY(IKEYTVAM:4)
     D   IKEYKSTC                     3    OVERLAY(IKEYTVAM:7)
     D   IKEYKDGR                     4    OVERLAY(IKEYTVAM:10)
     D   IKEYKDPL                     4    OVERLAY(IKEYTVAM:14)
     D   IKEYKDNR                    10    OVERLAY(IKEYTVAM:18)
     D   IKEYLDNR                     3    OVERLAY(IKEYTVAM:28)
     D   IKEYTENR                    15    OVERLAY(IKEYTVAM:31)
     D   IKEYJAHR                     4  0 OVERLAY(IKEYTVAM:46)
     D   IKEYMONA                     2  0 OVERLAY(IKEYTVAM:50)
     D   IKEYNUMM                     9  0 OVERLAY(IKEYTVAM:52)
     D*
     D  WKJJMO                        6  0
     D   WKJHJJ                       4  0 OVERLAY(WKJJMO:1)
     D   WKMONA                       2  0 OVERLAY(WKJJMO:5)
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
     C                   PARM                    E1WAOP
     C*
     C                   EXSR      UEBWAOP
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
     C     E1WAOPLOKZ    CASEQ     DAJNKZ        LWAOP
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C* Generieren Plan-Werte <- Plan-Werte Vorjahr
     C*--------------------------------------------------------
     C     E1WAOPDANA    WHENEQ    'WAOP'
     C                   EXSR      KEYWAOP
     C                   EXSR      OWAOP
     C                   EXSR      VWAOP
     C*--------------------------------------------------------
     C* Generieren Plan-Werte <- Ist-Werte
     C*--------------------------------------------------------
     C     E1WAOPDANA    WHENEQ    'TVAM'
     C                   EXSR      UXOPEN
     C*
     C                   EXSR      KEYTVAM
     C                   EXSR      OTVAM
     C                   EXSR      UXWRTE
     C*
     C                   EXSR      UXREAD
     C*
     C                   EXSR      EXUXCLOS
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  ERÖFFNUNGSZYKLUS                                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYVMFI                         TVAM
     C                   MOVEL(P)  DAFIRM        KYWAOKFIRM                     WAOK
     C                   MOVEL(P)  DAFIRM        KYWAOMFIRM                     WAOM
     C                   MOVEL(P)  DAFIRM        KYWAOPFIRM                     WAOP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOMMUNIKATIONSPARAMTER E1WAOP                          ***
     C**************************************************************************
     C     UEBWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
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
     C***  LÖSCHEN SÄTZE DATEI WAOP                                          ***
     C**************************************************************************
     C     LWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Keybestückung WAOP
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'DELETE FROM WAOP '  +
     C                             'WHERE WAOPFIRM = ''' + DAFIRM + ''''
     C*
     C                   IF        E1WAOPPLAT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPPLAT = ''' + E1WAOPPLAT + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPWKNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPWKNR = ''' + E1WAOPWKNR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             ' WHERE  KDEW.KDEWFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KDEW.KDEWKDNR=WAOP.WAOPSTKD '
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKSST = ''' + E1WAOPKSST +''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        E1WAOPKSTC <> *BLANK OR E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOP.WAOPSTKD '
     C                   IF        E1WAOPKSTC <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + E1WAOPKSTC + ''''
     C                   ENDIF
     C                   IF        E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + E1WAOPKDGR + ''''
     C                   ENDIF
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPKDPL <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDPL = ''' + E1WAOPKDPL + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPKDNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDNR = ''' + E1WAOPKDNR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPPRGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TEIL.TEPRGR = ''' + E1WAOPPRGR + ''')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPTENR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPTENR = ''' + E1WAOPTENR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPJAHR = ' + %CHAR(E1WAOPJAHR)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOP   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ EXECUTE SQWAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG WAOP                                                ***
     C**************************************************************************
     C     KEYWAOP       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             'SELECT * FROM WAOP '  +
     C                             'WHERE WAOPFIRM = ''' + DAFIRM + ''''
     C*
     C                   SELECT
     C                   WHEN      E1WAOPVPLA <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPPLAT = ''' + E1WAOPVPLA + ''''
     C                   WHEN      E1WAOPPLAT <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPPLAT = ''' + E1WAOPPLAT + ''''
     C                   ENDSL
     C*
     C                   IF        E1WAOPWKNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPWKNR = ''' + E1WAOPWKNR + ''''
     C                   ENDIF
     C*
     C*
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             ' WHERE  KDEW.KDEWFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KDEW.KDEWKDNR=WAOP.WAOPSTKD '
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKSST = ''' + E1WAOPKSST +''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        E1WAOPKSTC <> *BLANK OR E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=WAOP.WAOPFIRM ' +
     C                             ' AND    KUND.KDKDNR=WAOP.WAOPSTKD '
     C                   IF        E1WAOPKSTC <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + E1WAOPKSTC + ''''
     C                   ENDIF
     C                   IF        E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + E1WAOPKDGR + ''''
     C                   ENDIF
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPKDPL <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDPL = ''' + E1WAOPKDPL + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPKDNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPKDNR = ''' + E1WAOPKDNR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPPRGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = WAOP.WAOPFIRM ' +
     C                             ' AND TEIL.TETENR = WAOP.WAOPTENR ' +
     C                             ' AND TEIL.TEPRGR = ''' + E1WAOPPRGR + ''')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPTENR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPTENR = ''' + E1WAOPTENR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPJAHR <> *ZERO
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND WAOPJAHR BETWEEN ' + %CHAR(E1TVAMVJHJ)+
     C                             ' AND ' + %CHAR(E1TVAMBJHJ)
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR WAOPC1                                             ***
     C**************************************************************************
     C     OWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  PREPARE SQWAOP   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE WAOPC1 SCROLL CURSOR FOR SQWAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN WAOPC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN WAOP                                                  ***
     C**************************************************************************
     C     VWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOP
     C                   MOVEL     DAFIRM        KYWAOPFIRM
     C                   MOVEL     E1WAOPPLAT    KYWAOPPLAT
     C                   MOVEL     E1WAOPWKNR    KYWAOPWKNR
     C                   Z-ADD     E1WAOPJAHR    KYWAOPJAHR
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  FETCH WAOPC1 INTO :WAOP
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*--------------------------------------------------------
     C* Prüfen Kunden-Nr
     C*--------------------------------------------------------
     C     WAOPKDNR      IFNE      KDKDNR
     C     WAOPKDNR      ANDNE     *BLANK
     C                   MOVEL     WAOPKDNR      KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     '99'          KDKDST
     C                   ENDIF
     C                   ENDIF
     C*
     C*    KDKDST        IFGE      '90'
     C*                  ITER
     C*                  ENDIF
     C*--------------------------------------------------------
     C* Prüfen Ident-Nr
     C*--------------------------------------------------------
     C     WAOPTENR      IFNE      TETENR
     C                   MOVEL     WAOPTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVEL     '99'          TETEST
     C                   ENDIF
     C                   ENDIF
     C*
     C*    TETEST        IFGE      '90'
     C*                  ITER
     C*                  ENDIF
     C*--------------------------------------------------------
     C* Speichern Keyfelder
     C*--------------------------------------------------------
     C     WAOPKSTC      IFNE      KYWAOPKSTC
     C     WAOPKDGR      ORNE      KYWAOPKDGR
     C     WAOPKDPL      ORNE      KYWAOPKDPL
     C     WAOPKDNR      ORNE      KYWAOPKDNR
     C     WAOPLDNR      ORNE      KYWAOPLDNR
     C     WAOPTENR      ORNE      KYWAOPTENR
     C     KYWAOPTENR    CASNE     *BLANK        GWAOP
     C                   ENDCS
     C*
     C                   MOVEL     WAOPKSTC      KYWAOPKSTC
     C                   MOVEL     WAOPKDGR      KYWAOPKDGR
     C                   MOVEL     WAOPKDPL      KYWAOPKDPL
     C                   MOVEL     WAOPKDNR      KYWAOPKDNR
     C                   MOVEL     WAOPLDNR      KYWAOPLDNR
     C                   MOVEL     WAOPTENR      KYWAOPTENR
     C                   CLEAR                   WKWAOP
     C                   MOVEL     WAOPSTKD      WKWAOPSTKD
     C                   ENDIF
     C*--------------------------------------------------------
     C* Addieren Absatz/Umsatz
     C*--------------------------------------------------------
     C                   Z-ADD     WAOPMG01      SFLMG(01)
     C                   Z-ADD     WAOPMG02      SFLMG(02)
     C                   Z-ADD     WAOPMG03      SFLMG(03)
     C                   Z-ADD     WAOPMG04      SFLMG(04)
     C                   Z-ADD     WAOPMG05      SFLMG(05)
     C                   Z-ADD     WAOPMG06      SFLMG(06)
     C                   Z-ADD     WAOPMG07      SFLMG(07)
     C                   Z-ADD     WAOPMG08      SFLMG(08)
     C                   Z-ADD     WAOPMG09      SFLMG(09)
     C                   Z-ADD     WAOPMG10      SFLMG(10)
     C                   Z-ADD     WAOPMG11      SFLMG(11)
     C                   Z-ADD     WAOPMG12      SFLMG(12)
     C*
     C                   Z-ADD     WAOPUM01      SFLUM(01)
     C                   Z-ADD     WAOPUM02      SFLUM(02)
     C                   Z-ADD     WAOPUM03      SFLUM(03)
     C                   Z-ADD     WAOPUM04      SFLUM(04)
     C                   Z-ADD     WAOPUM05      SFLUM(05)
     C                   Z-ADD     WAOPUM06      SFLUM(06)
     C                   Z-ADD     WAOPUM07      SFLUM(07)
     C                   Z-ADD     WAOPUM08      SFLUM(08)
     C                   Z-ADD     WAOPUM09      SFLUM(09)
     C                   Z-ADD     WAOPUM10      SFLUM(10)
     C                   Z-ADD     WAOPUM11      SFLUM(11)
     C                   Z-ADD     WAOPUM12      SFLUM(12)
     C*
     C                   SELECT
     C     E1TVAMVJHJ    WHENEQ    E1TVAMBJHJ
     C                   ADD       WAOPPLMG      WKWAOPPLMG
     C                   ADD       WAOPPLUM      WKWAOPPLUM
     C     WAOPJAHR      WHENEQ    E1TVAMVJHJ
     C                   Z-ADD     E1TVAMVMON    I1
     C*
     C     I1            DOWLE     12
     C                   ADD       SFLMG(I1)     WKWAOPPLMG
     C                   ADD       SFLUM(I1)     WKWAOPPLUM
     C                   ADD       1             I1
     C                   ENDDO
     C     WAOPJAHR      WHENEQ    E1TVAMBJHJ
     C                   Z-ADD     1             I1
     C*
     C     I1            DOWLE     E1TVAMBMON
     C                   ADD       SFLMG(I1)     WKWAOPPLMG
     C                   ADD       SFLUM(I1)     WKWAOPPLUM
     C                   ADD       1             I1
     C                   ENDDO
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Generieren WAOP-Sätze
     C*-------------------------------------------------------------------------
     C     KYWAOPTENR    CASNE     *BLANK        GWAOP
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE WAOPC1
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
     C                   EVAL      EXUX01INAM = 'T2WAOP'
     C                   EVAL      EXUX01ILIB = 'QTEMP'
     C                   EVAL      EXUX01IATR = 'TREND'
     C                   EVAL      EXUX01DTLG = 100 + 900
     C                   EVAL      EXUX01KYLG = 100
     C                   EVAL      EXUX01ITXT = 'Absatz/Umsatz-Plan'
     C                   EXSR      EXUXOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  KEYBESTÜCKUNG TVAM                                                ***
     C**************************************************************************
     C     KEYTVAM       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKSTMT =
     C                             ' SELECT * FROM TVAM '  +
     C                             ' WHERE VMFIRM = ''' + DAFIRM + '''' +
     C                             ' AND VMBEGR = ''' + E1TVAMBEGR + '''' +
     C                             ' AND VMAFAT <> ''' + '10' + '''' +
     C                             ' AND VMAFAT <> ''' + '11' + '''' +
     C                             ' AND VMAFAT <> ''' + '12' + '''' +
     C                             ' AND VMAFAT <> ''' + '13' + '''' +
     C                             ' AND VMAFAT <> ''' + '16' + '''' +
     C                             ' AND VMAFAT <> ''' + '17' + '''' +
     C                             ' AND VMAFAT <> ''' + '18' + '''' +
     C                             ' AND VMAFAT <> ''' + '19' + '''' +
     C                             ' AND VMAFAT <> ''' + '20' + '''' +
     C                             ' AND VMAFAT <> ''' + '81' + '''' +
     C                             ' AND VMAFAT <> ''' + '82' + '''' +
     C                             ' AND VMAFAT <> ''' + '83' + ''''
     C*
     C                   IF        E1WAOPWKNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND VMWKNR = ''' + E1WAOPWKNR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDEWKSST FROM KDEW ' +
     C                             ' WHERE  KDEW.KDEWFIRM=TVAM.VMFIRM ' +
     C                             ' AND    KDEW.KDEWKDNR=TVAM.VMKDNR '
     C                   IF        E1WAOPKSST <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KDEW.KDEWKSST = ''' + E1WAOPKSST +''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   IF        E1WAOPKSTC <> *BLANK OR E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT KDKDNR FROM KUND ' +
     C                             ' WHERE  KUND.KDFIRM=TVAM.VMFIRM ' +
     C                             ' AND    KUND.KDKDNR=TVAM.VMKDNR '
     C                   IF        E1WAOPKSTC <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKSTC = ''' + E1WAOPKSTC + ''''
     C                   ENDIF
     C                   IF        E1WAOPKDGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND KUND.KDKDGR = ''' + E1WAOPKDGR + ''''
     C                   ENDIF
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) + ')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPKDNR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND VMKDNR = ''' + E1WAOPKDNR + ''''
     C                   ENDIF
     C*
     C                   IF        E1WAOPPRGR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = TVAM.VMFIRM ' +
     C                             ' AND TEIL.TETENR = TVAM.VMTENR ' +
     C                             ' AND TEIL.TETART <> ''' + 'P' + '''' +
     C                             ' AND TEIL.TEPRGR = ''' + E1WAOPPRGR + ''')'
     C                   ELSE
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND EXISTS(SELECT TEPRGR FROM TEIL '  +
     C                             ' WHERE TEIL.TEFIRM = TVAM.VMFIRM ' +
     C                             ' AND TEIL.TETENR = TVAM.VMTENR ' +
     C                             ' AND TEIL.TETART <> ''' + 'P' + '''' +
     C                             ' AND TEIL.TEPRGR <= ''' + '901' + ''')'
     C                   ENDIF
     C*
     C                   IF        E1WAOPTENR <> *BLANK
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND VMTENR = ''' + E1WAOPTENR + ''''
     C                   ENDIF
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' AND VMJHJJ BETWEEN ' + %CHAR(E1TVAMVJHJ)+
     C                             ' AND ' + %CHAR(E1TVAMBJHJ)
     C*
     C                   EVAL      WKSTMT = %TRIM(WKSTMT) +
     C                             ' FOR FETCH ONLY'
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
     C+  PREPARE SQTVAM   FROM :WKSTMT
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE TVAMC1 SCROLL CURSOR FOR SQTVAM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN TVAMC1
     C/END-EXEC
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
     C                   MOVE      *ZERO         DUN090
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL                                                                 RCDNBR
     C+ FETCH NEXT FROM TVAMC1 INTO :TVAM
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C*-------------------------------------------------------------------------
     C* Absatz/Umsatz
     C*-------------------------------------------------------------------------
     C     VMMGST        IFEQ      *ZERO
     C     VMWTST        ANDEQ     *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Planungskz, Kundenplanung aus Kunden-Stamm Erweiterung
     C*-------------------------------------------------------------------------
     C     KDEWKDNR      IFNE      VMKDNR
     C                   MOVEL     VMKDNR        KYKDEWKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKDEW
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Ermitteln Kundengruppe, Vertriebsbereich aus Kunden-Stamm
     C*-------------------------------------------------------------------------
     C     KDKDNR        IFNE      VMKDNR
     C                   MOVEL     VMKDNR        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Prüfen Selektionsfelder
     C*-------------------------------------------------------------------------
     C     VMJHJJ        IFEQ      E1TVAMVJHJ
     C     VMMONA        ANDLT     E1TVAMVMON
     C*
     C     VMJHJJ        OREQ      E1TVAMBJHJ
     C     VMMONA        ANDGT     E1TVAMBMON
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Füllen Keyfelder
     C*-------------------------------------------------------------------------
     C                   CLEAR                   IKEYTVAM
     C                   MOVEL     E1WAOPPLAT    IKEYPLAT
     C                   MOVEL     E1WAOPWKNR    IKEYWKNR
     C                   SELECT
     C     KDEWPLKZ      WHENEQ    '1'
     C     KDKSTC        ANDNE     *BLANK
     C                   MOVEL     KDKSTC        IKEYKSTC
     C     KDEWPLKZ      WHENEQ    '2'
     C     KDKDGR        ANDNE     *BLANK
     C                   MOVEL     KDKDGR        IKEYKDGR
     C     KDEWPLKZ      WHENEQ    '3'
     C     KDEWKDPL      ANDNE     *BLANK
     C                   MOVEL     KDEWKDPL      IKEYKDPL
     C     KDEWPLKZ      WHENEQ    '4'
     C                   MOVEL     KDKDNR        IKEYKDNR
     C                   ENDSL
     C                   MOVEL     KDLAND        IKEYLDNR
     C                   MOVEL     VMTENR        IKEYTENR
     C                   Z-ADD     VMJHJJ        IKEYJAHR
     C                   Z-ADD     VMMONA        IKEYMONA
     C                   ADD       1             DUN090
     C                   Z-ADD     DUN090        IKEYNUMM
     C*
     C                   EVAL      EXUX01IKEY = IKEYTVAM
     C                   EVAL      EXUX01IDTA = EXUX01IKEY + TVAM
     C                   EVAL      EXUX01IMDE = EXUX03REPL
     C                   EXSR      EXUXWRTE
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE TVAMC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN  USERINDEX                                            ***
     C**************************************************************************
     C     UXREAD        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYWAOP
     C                   MOVEL     DAFIRM        KYWAOPFIRM
     C                   MOVEL     E1WAOPPLAT    KYWAOPPLAT
     C                   MOVEL     E1WAOPWKNR    KYWAOPWKNR
     C                   Z-ADD     E1WAOPJAHR    KYWAOPJAHR
     C*
     C                   CLEAR                   WKWAOP
     C                   Z-ADD     *ZERO         SFLMG
     C                   Z-ADD     *ZERO         SFLUM
     C                   Z-ADD     *ZERO         SFLER
     C*-------------------------------------------------------------------------
     C                   EXSR      EXUXREAD
     C*-------------------------------------------------------------------------
     C     EXUX01RTCD    DOWEQ     *ZERO
     C                   EVAL      IKEYTVAM = EXUX01IKEY
     C                   EVAL      DUN030   = %LEN(TVAM)
     C                   EVAL      TVAM     = %SUBST(EXUX01IDTA: 101: DUN030)
     C*--------------------------------------------------------
     C     IKEYKSTC      IFNE      KYWAOPKSTC
     C     IKEYKDGR      ORNE      KYWAOPKDGR
     C     IKEYKDPL      ORNE      KYWAOPKDPL
     C     IKEYKDNR      ORNE      KYWAOPKDNR
     C     IKEYLDNR      ORNE      KYWAOPLDNR
     C     IKEYTENR      ORNE      KYWAOPTENR
     C     KYWAOPTENR    CASNE     *BLANK        GWAOP
     C                   ENDCS
     C*
     C                   MOVEL     IKEYKSTC      KYWAOPKSTC
     C                   MOVEL     IKEYKDGR      KYWAOPKDGR
     C                   MOVEL     IKEYKDPL      KYWAOPKDPL
     C                   MOVEL     IKEYKDNR      KYWAOPKDNR
     C                   MOVEL     IKEYLDNR      KYWAOPLDNR
     C                   MOVEL     IKEYTENR      KYWAOPTENR
     C                   CLEAR                   WKWAOP
     C                   MOVEL     VMKDNR        WKWAOPSTKD
     C                   Z-ADD     *ZERO         SFLMG
     C                   Z-ADD     *ZERO         SFLUM
     C                   Z-ADD     *ZERO         SFLER
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       VMMGST        WKWAOPPLMG
     C                   ADD       VMMGST        SFLMG(VMMONA)
     C                   ADD       VMWTST        WKWAOPPLUM
     C                   ADD       VMWTST        SFLUM(VMMONA)
     C                   ADD       VMDEBT        WKWAOPERTR
     C                   ADD       VMDEBT        SFLER(VMMONA)
     C*--------------------------------------------------------
     C                   EXSR      EXUXNEXT
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     KYWAOPTENR    CASNE     *BLANK        GWAOP
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  GENERIEREN WAOP-SÄTZE                                             ***
     C**************************************************************************
     C     GWAOP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Produkt-Gruppe aus Ident-Stamm
     C*-------------------------------------------------------------------------
     C     TETENR        IFNE      KYWAOPTENR
     C                   MOVEL     KYWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Berechnen Mengen/Preis-Erhöhung
     C*-------------------------------------------------------------------------
     C     E1WAOPMGPZ    IFEQ      DAJNKZ
     C     E1WAOPPRPZ    OREQ      DAJNKZ
     C*--------------------------------------------------------
     C     WKWAOPPLMG    IFEQ      *ZERO
     C                   Z-ADD     WKWAOPPLUM    WKWAOPPLPR
     C                   ELSE
     C     WKWAOPPLUM    DIV       WKWAOPPLMG    WKWAOPPLPR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL     KYWAOPKSTC    KYWAOKKSTC
     C                   MOVEL     KYWAOPKDGR    KYWAOKKDGR
     C                   MOVEL     KYWAOPKDPL    KYWAOKKDPL
     C                   MOVEL     KYWAOPKDNR    KYWAOKKDNR
     C                   MOVEL     KYWAOPLDNR    KYWAOKLDNR
     C                   MOVEL     TEPRGR        KYWAOKPRGR
     C                   Z-ADD     KYWAOPJAHR    KYWAOKJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOK
     C*
     C* Berechnen Mengen-Erhöhung (Absatz/Umsatz)
     C*
     C     E1WAOPMGPZ    IFEQ      DAJNKZ
     C     WAOKMGPZ      ANDNE     *ZERO
     C     WKWAOPPLMG    MULT      WAOKMGPZ      DUN219
     C     DUN219        DIV       100           DUN219
     C                   ADD       DUN219        WKWAOPPLMG
     C                   ENDIF
     C*
     C* Berechnen Preis-Erhöhung (Umsatz)
     C*
     C     E1WAOPPRPZ    IFEQ      DAJNKZ
     C     WAOKPRPZ      ANDNE     *ZERO
     C     WKWAOPPLPR    MULT      WAOKPRPZ      DUN219
     C     DUN219        DIV       100           DUN219
     C                   ADD       DUN219        WKWAOPPLPR
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Verteilen jahres-Absatz/Umsatz auf Monatsebene
     C*-------------------------------------------------------------------------
     C                   EXSR      EWAOM
     C*-------------------------------------------------------------------------
     C* Anlage WAOP-Satz
     C*-------------------------------------------------------------------------
     C                   EXSR      TRWAOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI WAOP                                                 ***
     C**************************************************************************
     C     TRWAOP        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXWAOP
     C                   MOVEL     *ON           EXWAOPIFKZ
     C                   MOVEL     *BLANK        EXWAOPPGST
     C                   MOVEL     'T2WAOP'      EXWAOPPROG
     C                   MOVEL     KYWAOPPLAT    EXWAOPPLAT
     C                   MOVEL     KYWAOPWKNR    EXWAOPWKNR
     C                   MOVEL     KYWAOPKSTC    EXWAOPKSTC
     C                   MOVEL     KYWAOPKDGR    EXWAOPKDGR
     C                   MOVEL     KYWAOPKDPL    EXWAOPKDPL
     C                   MOVEL     KYWAOPKDNR    EXWAOPKDNR
     C                   MOVEL     KYWAOPLDNR    EXWAOPLDNR
     C                   MOVEL     KYWAOPTENR    EXWAOPTENR
     C                   Z-ADD     KYWAOPJAHR    EXWAOPJAHR
     C*
     C                   Z-ADD     WKWAOPPLMG    EXWAOPPLMG
     C                   Z-ADD     WKWAOPPLUM    EXWAOPPLUM
     C                   Z-ADD     WKWAOPSTPR    EXWAOPSTPR
     C                   MOVEL     WKWAOPPDAV    EXWAOPPDAV
     C                   Z-ADD     WKWAOPERTR    EXWAOPERTR
     C                   Z-ADD     SFLMG(01)     EXWAOPMG01
     C                   Z-ADD     SFLMG(02)     EXWAOPMG02
     C                   Z-ADD     SFLMG(03)     EXWAOPMG03
     C                   Z-ADD     SFLMG(04)     EXWAOPMG04
     C                   Z-ADD     SFLMG(05)     EXWAOPMG05
     C                   Z-ADD     SFLMG(06)     EXWAOPMG06
     C                   Z-ADD     SFLMG(07)     EXWAOPMG07
     C                   Z-ADD     SFLMG(08)     EXWAOPMG08
     C                   Z-ADD     SFLMG(09)     EXWAOPMG09
     C                   Z-ADD     SFLMG(10)     EXWAOPMG10
     C                   Z-ADD     SFLMG(11)     EXWAOPMG11
     C                   Z-ADD     SFLMG(12)     EXWAOPMG12
     C                   Z-ADD     SFLUM(01)     EXWAOPUM01
     C                   Z-ADD     SFLUM(02)     EXWAOPUM02
     C                   Z-ADD     SFLUM(03)     EXWAOPUM03
     C                   Z-ADD     SFLUM(04)     EXWAOPUM04
     C                   Z-ADD     SFLUM(05)     EXWAOPUM05
     C                   Z-ADD     SFLUM(06)     EXWAOPUM06
     C                   Z-ADD     SFLUM(07)     EXWAOPUM07
     C                   Z-ADD     SFLUM(08)     EXWAOPUM08
     C                   Z-ADD     SFLUM(09)     EXWAOPUM09
     C                   Z-ADD     SFLUM(10)     EXWAOPUM10
     C                   Z-ADD     SFLUM(11)     EXWAOPUM11
     C                   Z-ADD     SFLUM(12)     EXWAOPUM12
     C                   Z-ADD     SFLER(01)     EXWAOPER01
     C                   Z-ADD     SFLER(02)     EXWAOPER02
     C                   Z-ADD     SFLER(03)     EXWAOPER03
     C                   Z-ADD     SFLER(04)     EXWAOPER04
     C                   Z-ADD     SFLER(05)     EXWAOPER05
     C                   Z-ADD     SFLER(06)     EXWAOPER06
     C                   Z-ADD     SFLER(07)     EXWAOPER07
     C                   Z-ADD     SFLER(08)     EXWAOPER08
     C                   Z-ADD     SFLER(09)     EXWAOPER09
     C                   Z-ADD     SFLER(10)     EXWAOPER10
     C                   Z-ADD     SFLER(11)     EXWAOPER11
     C                   Z-ADD     SFLER(12)     EXWAOPER12
     C                   MOVEL     WKTRPAWACD    EXWAOPWACD
     C                   MOVEL     WKWAOPSTKD    EXWAOPSTKD
     C*
     C                   CALL      'TRWAOP'
     C                   PARM                    EXWAOP
     C                   PARM                    RTWAOP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS %-SÄTZE                                       ***
     C**************************************************************************
     C     EWAOM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Kopieren Ist-Werte
     C*-------------------------------------------------------------------------
     C     E1WAOPJAHR    IFEQ      E1TVAMVJHJ
     C     E1WAOPJAHR    ANDEQ     E1TVAMBJHJ
     C     E1WAOPDANA    ANDEQ     'TVAM'
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C* Initialisieren Feldgruppen
     C*-------------------------------------------------------------------------
     C                   CLEAR                   SFLPZ
     C                   CLEAR                   SFLMG
     C                   CLEAR                   SFLUM
     C                   CLEAR                   SFLER
     C*-------------------------------------------------------------------------
     C* Ermitteln %-Sätze Jahresebene
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYWAOPKSTC    KYWAOMKSTC
     C                   MOVEL     KYWAOPKDGR    KYWAOMKDGR
     C                   MOVEL     KYWAOPKDPL    KYWAOMKDPL
     C                   MOVEL     KYWAOPKDNR    KYWAOMKDNR
     C                   MOVEL     KYWAOPLDNR    KYWAOMLDNR
     C                   MOVEL     TEPRGR        KYWAOMPRGR
     C                   Z-ADD     KYWAOPJAHR    KYWAOMJAHR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHWAOM
     C*
     C                   Z-ADD     WAOMPZ01      SFLPZ(01)
     C                   Z-ADD     WAOMPZ02      SFLPZ(02)
     C                   Z-ADD     WAOMPZ03      SFLPZ(03)
     C                   Z-ADD     WAOMPZ04      SFLPZ(04)
     C                   Z-ADD     WAOMPZ05      SFLPZ(05)
     C                   Z-ADD     WAOMPZ06      SFLPZ(06)
     C                   Z-ADD     WAOMPZ07      SFLPZ(07)
     C                   Z-ADD     WAOMPZ08      SFLPZ(08)
     C                   Z-ADD     WAOMPZ09      SFLPZ(09)
     C                   Z-ADD     WAOMPZ10      SFLPZ(10)
     C                   Z-ADD     WAOMPZ11      SFLPZ(11)
     C                   Z-ADD     WAOMPZ12      SFLPZ(12)
     C*-------------------------------------------------------------------------
     C* Speichern den Feldgruppen-Index des höchsten %-Satzes
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             I0
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLPZ(I1)     IFGT      SFLPZ(I0)
     C                   Z-ADD     I1            I0
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Verteilen Absatz
     C*-------------------------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLPZ(I1)     IFNE      *ZERO
     C     WKWAOPPLMG    MULT      SFLPZ(I1)     DUN112
     C     DUN112        DIV       100           SFLMG(I1)
     C                   ENDIF
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C* Absatz-Plan ohne Nachkommastellen
     C*-------------------------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFNE      *ZERO
     C                   Z-ADD(H)  SFLMG(I1)     DUN090
     C                   Z-ADD     DUN090        SFLMG(I1)
     C                   ENDIF
     C                   ENDDO
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   Z-ADD(H)  WKWAOPPLMG    DUN090
     C                   Z-ADD     DUN090        WKWAOPPLMG
     C*
     C                   XFOOT     SFLMG         DUN090
     C     WKWAOPPLMG    SUB       DUN090        DUN090
     C                   ADD       DUN090        SFLMG(I0)
     C*-------------------------------------------------------------------------
     C* Berechnen Plan-Preis
     C*-------------------------------------------------------------------------
     C     WKWAOPPLMG    IFEQ      *ZERO
     C                   Z-ADD     WKWAOPPLPR    WKWAOPPLUM
     C                   ELSE
     C     WKWAOPPLMG    MULT      WKWAOPPLPR    WKWAOPPLUM
     C                   ENDIF
     C*
     C     SFLMG         MULT      WKWAOPPLPR    SFLUM
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLUM         DUN112
     C     WKWAOPPLUM    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLUM(I0)
     C*-------------------------------------------------------------------------
     C* Berechnen Rohertrag
     C*-------------------------------------------------------------------------
     C                   Z-ADD     TESTPR        WKWAOPSTPR
     C                   MOVEL(P)  TEPDAV        WKWAOPPDAV
     C*--------------------------------------------------------
     C                   MOVEL(P)  'PDIM'        KYTPTA
     C                   MOVEL(P)  TEPDAV        KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     TPTNUM        IFEQ      *ZERO
     C     WKWAOPSTPR    DIV       WKWAOPPLMG    DUN113
     C                   ELSE
     C     WKWAOPSTPR    DIV       TPTNUM        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     TPTNUM        WHENEQ    *ZERO
     C     WKWAOPPLUM    SUB       WKWAOPSTPR    WKWAOPERTR
     C*--------------------------------------------------------
     C     WKWAOPSTPR    WHENNE    *ZERO
     C     WKWAOPPLMG    MULT      DUN113        WKWAOPERTR
     C     WKWAOPPLUM    SUB       WKWAOPERTR    WKWAOPERTR
     C*--------------------------------------------------------
     C     WKWAOPPLMG    WHENNE    *ZERO
     C     WKWAOPPLUM    SUB       WKWAOPERTR    DUN219
     C     DUN219        DIV       WKWAOPPLMG    DUN113
     C     WKWAOPPLMG    IFLT      *ZERO
     C                   Z-SUB     DUN113        DUN113
     C                   ENDIF
     C*--------------------------------------------------------
     C                   OTHER
     C                   Z-ADD     *ZERO         DUN113
     C                   ENDSL
     C*--------------------------------------------------------
     C     1             DO        12            I1
     C*
     C     SFLMG(I1)     IFNE      *ZERO
     C     SFLMG(I1)     MULT      DUN113        SFLER(I1)
     C     SFLER(I1)     IFLT      *ZERO
     C                   Z-SUB     SFLER(I1)     SFLER(I1)
     C                   ENDIF
     C     SFLUM(I1)     SUB       SFLER(I1)     SFLER(I1)
     C                   ENDIF
     C                   ENDDO
     C*
     C* Die Rundungsdifferenz wird dem höchsten %-Satzes zugerechnet
     C*
     C                   XFOOT     SFLER         DUN112
     C     WKWAOPERTR    SUB       DUN112        DUN112
     C                   ADD       DUN112        SFLER(I0)
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS IDENTSTAMM                                    ***
     C**************************************************************************
     C     ETEIL         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYWAOPTENR    KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  TETENR        KYTUTE
     C                   MOVEL(P)  TEMEIN        KYTUME
     C     TEMEVK        IFNE      *BLANK
     C     TEMEVK        ANDNE     TEMEIN
     C                   MOVEL     TEMEVK        KYTUME
     C                   ENDIF
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEUF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C* Ermitteln Stammwährung
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA
     C                   MOVEL(P)  'WACD'        KYTATC
     C                   MOVEL(P)  'WACD'        KYTAPA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAWACD
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
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPAWACD      + 2
     C     *LIKE         DEFINE    WKC001        WKSTMT         +999
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WAOPSTPR      WKWAOPPLPR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,CHWAOK
     C/COPY QCPYSRC,CHWAOM
     C/COPY QCPYSRC,EXUX04
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
