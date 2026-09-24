     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2010')
     H**************************************************************************
     H/TITLE Anzeige Konditionenübersicht per Kunde/Kd-Gr. und Prod.-Gr.
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: RH 01.12.2010 Kunde WAECO Projekt 6963
     H*  -----------------------------------------------------------------------
     H*  Änderung: RH 10.01.2010 Kunde WAECO Projekt 6963
     H*            Produktgruppen nur noch 1 mal aufführen
     H*            Lesen VKNU gemäß Rangfolge in TRPA -> ZUAR/KOND
     H*  Änderung: RE 16.05.2012 Service#: 20120516-00163
     H*  Änderung: GS 07.08.2012 Mail von Hr.Schneider vom 26.07.12. Das Feld "Produktgruppe"
     H*            (DSKONDPRGR) wurde innerhalb der Routine gefüllt statt nur im BILDM1-Format
     H*  Änderung: RE 28.08.2013 Projekt 9822
     H*            Selektion nach Datum
     H*  Änderung: GS 23.02.2022 Projekt 220099 Korrektur/Erweiterung der Routine CHECK_KBST
     H*            sodass immer auf die KBST zugegriffen wird.
     F**************************************************************************
     F*
     F*  Dieses Programm dient zur Matchcode-Anzeige der Datei KOND.
     F*  Dieses Programm übergibt die ausgewählten Daten komplett an das auf-
     F*  rufende Programm.
     F*  Die Parameter werden in dem Feld #CKOMM übergeben.
     F*
     F*  KOM(01) = KYKONDWACD Währung
     F*  KOM(04) = KYKUNDKDNR Kundennr.
     F*  KOM(14) = KYKONDKDGR Kundengruppe
     F*  KOM(18) = KYKONDPRGR Produktgruppe
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO015FM  CF   E             WORKSTN USROPN
     F                                     INDDS(DSINDICATORS)
     F                                     SFILE(WAO015R1:RCDNBR)
     F                                     SFILE(DLWAO0R1:WKRCNO)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRMC
     D*
     D SFLKOND         S                   LIKE(KYKOND) DIM(999) DESCEND
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,MCCURSOR
     D*
     D**************************************************************************
     D***  KONSTANTENDEFINITION                                              ***
     D**************************************************************************
     D WCTRD           C                   CONST('*')
     D WCSQL           C                   CONST('%')
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D KOND          E DS
     D KYKOND        E DS                  INZ
     D UXKOND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D KBST          E DS                  INZ
     D KYKBST        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D WACD          E DS                  INZ
     D KONDLINKS       DS                  LIKEDS(KOND)
     D KONDRECHTS      DS                  LIKEDS(KOND)
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTEXT        E DS                  INZ
     D RTTEXT        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXSBFL        E DS                  INZ
     D RTSBFL        E DS                  INZ
     D*
     D EXKOND        E DS                  INZ
     D RTKOND        E DS                  INZ
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     D*
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D/COPY QCPYSRC,EXUX05
     D*
     D* Begriffe bereits bearbeitet
     D BSAVE           S              3    DIM(9999)
     D*
     D* Produktgruppen bereits verarbeitet
     D PGVERA          S              4    DIM(9999)
     D*
     D* Sortierung + Keybegriff
     D SORTBEGR        S             20    DIM(999)
     D*
     D* LINKS/RECHTS DS FÜR ANZEIGE
     D*
     D DXKOND          DS                  OCCURS(9999) INZ
     D  DXKOBL                 1      3
     D  DXKKTL                 4      4
     D  DXKKYL                 5     14
     D  DXPRGL                15     18
     D  DXPRBL                19     48
     D  DXSTAL                49     59  2
     D  DXRABL                60     67  2
     D  DXRBKL                68     68
     D  DXKOBR               101    103
     D  DXKKTR               104    104
     D  DXKKYR               105    114
     D  DXPRGR               115    118
     D  DXPRBR               119    148
     D  DXSTAR               149    159  2
     D  DXRABR               160    167  2
     D  DXRBKR               168    168
     D*
     D WAO015SI      E DS                  INZ
     D*
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
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
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      EXJOBA
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C**                 EXSR      KOND_LIST
     C                   EXSR      OFFUKT
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*--------------------------------------------------------
     C                   MOVE      C#IN28        *IN28
     C*--------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   MOVE      'M1'          WKIFMT
     C                   ENDIF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C     WKIFMT        DOWNE     '00'
     C*--------------------------------------------------------
     C     WKIOKZ        IFNE      *ON
     C                   OPEN      WAO015FM
     C                   MOVE      *ON           WKIOKZ
     C                   ENDIF
     C*--------------------------------------------------------
     C     WKIFMT        CASEQ     '01'          BILD01
     C     WKIFMT        CASEQ     'M1'          BILDM1
     C                   ENDCS
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     #CRTCD        IFEQ      'N'
     C     #CRTCD        OREQ      '9'
     C                   CLEAR                   KOND
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKIOKZ        IFEQ      *ON
     C     WKIWND        ANDEQ     *ON
     C                   CLOSE     WAO015FM
     C                   MOVE      *OFF          WKIOKZ
     C                   ENDIF
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
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         #CDATN
     C                   Z-ADD     *ZERO         #CDATV
     C                   Z-ADD     *ZERO         #CDAKW
     C                   Z-ADD     *ZERO         #CDAJJ
     C                   Z-ADD     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYKDFI                         TRTP
     C                   MOVEL(P)  DAFIRM        KYKOFI                         TRTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C                   MOVEL(P)  DAUSSP        EXTEXTSPCD                     TEXT
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        EXFIRMFIRM
     C                   EXSR      PRFIRMFIRM
     C                   MOVEA(P)  EXFIRMKNAM    W99(01)
     C                   MOVEA     *BLANK        W99(31)
     C                   MOVEL(P)  EXFIRMWACD    DSKONDWACD
     C*--------------------------------------------------------
     C                   MOVEL(P)  'WAO015'      EXTRDNDANA
     C                   EXSR      RDTRDNTRDN
     C                   MOVEA     EXTRDNTEXT    W99(32)
     C*--------------------------------------------------------
     C                   MOVEA(P)  W99           DSKOPF
     C                   MOVEA(P)  W99(32)       WNKOPF
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'UEB'         EXTEXTMSGA
     C                   MOVEL(P)  'KEIN'        EXTEXTMSGN
     C                   MOVE      'PRUEFE'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C                   MOVEL(P)  RTTEXTTEXT    TXKEIN
     C*-------------------------------------------------------------------------
     C                   MOVE      '01'          WKIFMT
     C                   MOVE      '01'          WKMCKZ
     C                   Z-ADD     *ZERO         WKPAGE
     C*--------------------------------------------------------
     C                   MOVEA     *BLANK        SFLKOND
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#LCK0
     C                   MOVE      *OFF          C#LCK1
     C                   MOVE      C#LCK0        WKIN30
     C                   MOVE      C#LCK1        WKIN31
     C*--------------------------------------------------------
     C                   BITOFF    '01234567'    WKAT01
     C                   BITON     '26'          WKAT01
     C                   BITOFF    '01234567'    WKAT02
     C                   BITON     '25'          WKAT02
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
     C                   MOVE      'F'           WKFEAT
     C                   MOVE      *BLANK        MCF
     C                   MOVE      *OFF          WKIOKZ
     C                   MOVE      *BLANK        BLANKBEGR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO015FM'    EXFLPOFMTN
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  UEBERNAHME KOM-BEREICH                                            ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     #CPGST        IFNE      WKPGST
     C                   MOVEA     *BLANK        SFLKOND
     C                   Z-ADD     *ZERO         RCDNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CMCFG        MCF
     C                   MOVE      #CPGST        WKPGST
     C*-------------------------------------------------------------------------
     C     DATEST        IFEQ      '5'
     C     WKPGST        ANDEQ     *BLANK                                       auf reinen Anzeige-
     C                   MOVE      '5     '      WKPGST                         modus umschalten
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  #CKOMM        KOM
     C*
     C                   MOVEA(P)  KOM(01)       DSKONDWACD
     C                   MOVEA(P)  KOM(04)       DSKUNDKDNR
     C                   MOVEA(P)  KOM(14)       DSKONDKDLG
     C                   MOVEA(P)  KOM(18)       DSKONDPRGR
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     #CUEBE        WHENEQ    *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '0531'        #CUEBE
     C     #CUEBE        WHENEQ    *BLANK
     C                   MOVE      '0012'        #CUEBE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'BNR'         EXTEXTMSGA
     C                   MOVEL(P)  '0029'        EXTEXTMSGN
     C                   MOVE      'ERMBSK'      EXTEXTPGST
     C*
     C                   CALL      'TRTEXT'
     C                   PARM                    EXTEXT
     C                   PARM                    RTTEXT
     C*
     C                   MOVEL(P)  RTTEXTTEXT    DSBT01
     C                   MOVEA(P)  RTTEXTBSKZ    BSK
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKBT24
     C*-------------------------------------------------------------------------
     C                   MOVE      'M1'          WKIFMT
     C                   MOVEA     *BLANK        FMT
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             FM
     C                   MOVE      '00'          FMT(FM)
     C                   MOVE      *OFF          WKIWND
     C*-------------------------------------------------------------------------
     C     WKPGST        IFNE      *BLANK
     C     WKPGST        ANDNE     '5     '
     C                   MOVE      '01'          WKIFMT
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   MOVEL(P)  'ERMDAT'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   MOVEL     RTDATEDATE    WKUDAT
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  LISTE DER RELEVANTEN KONDITIONEN VIA TRTP (VKNU)                  ***
     C***                                   UND KBST (KBPGKZ)                ***
     C**************************************************************************
     C     KOND_LIST     BEGSR
     C*
     C     1             DO        9999          WKANZKOND
     C     WKANZKOND     OCCUR     DXKOND
     C                   CLEAR                   DXKOND
     C                   ENDDO
     C*
     C                   Z-ADD     0             WKANZKOND
     C                   Z-ADD     0             W1ANZKOND
     C                   Z-ADD     0             W2ANZKOND
     C                   MOVE      *BLANK        BSAVE
     C                   MOVE      *BLANK        PGVERA
     C*
     C     1             DO        9999          I3
     C*
     C     SORTBEGR(I3)  IFEQ      *ALL'9'
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      SORTBEGR(I3)  WKC010
     C*
     C                   MOVEL(P)  'VKNU'        KYTPTA
     C                   MOVEL(P)  'VKNU'        OFTPTA
     C     'PVK'         CAT       WKC010:0      KYTPTC
     C     'PVK'         CAT       WKC010:0      OFTPTC
     C                   CAT       '9999999999':0OFTPTC
     C                   MOVE      *LOVAL        KYTPTF
     C                   MOVEA     '00L     '    CHI
     C                   EXSR      CHTRTP
     C*                                                                     ----
     C                   DO        *HIVAL
     C*
     C                   MOVEA     '00R     '    CHI                            LESEN FÜR
     C                   EXSR      CHTRTP                                       UPDATE
     C*
     C     WKFENR        IFGT      *ZERO
     C     TPFIRM        ORNE      KYTPFI
     C     TPSPCD        ORNE      KYTPSP
     C     TPTART        ORNE      OFTPTA
     C     TPTCDE        ORGT      OFTPTC
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVE      *BLANK        WKBEGRLI
     C                   MOVE      *BLANK        WKBEGRRE
     C                   MOVE      *BLANK        WKKKEYLI
     C                   MOVE      *BLANK        WKKKEYRE
     C*
     C     3             SUBST(P)  TPTCDE:4      WKBEGR
     C                   EXSR      CHECK_KBST
     C                   MOVEL     WKBEGR        WKBEGRLI
     C                   MOVEL     WKKKEY        WKKKEYLI
     C
     C     3             SUBST(P)  TPTTXT:1      WKBEGR
     C                   EXSR      CHECK_KBST
     C                   MOVEL     WKBEGR        WKBEGRRE
     C                   MOVEL     WKKKEY        WKKKEYRE
     C*
     C     WKBEGRLI      IFEQ      *BLANK
     C     WKBEGRRE      ANDEQ     *BLANK
     C                   ITER
     C                   ENDIF
     C*
     C                   EXSR      KEYKONDL
     C*
     C                   EXSR      OCKONDL
     C                   EXSR      LIES_KOND
     C                   EXSR      CCKONDL
     C*
     C                   ENDDO
     C*                                                                     ----
     C                   ENDDO
     C*                                                                     ----
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN CURSOR FÜR KONDITIONEN LINKS                               ***
     C**************************************************************************
     C     OCKONDL       BEGSR
     C*
     C/EXEC SQL
     C+  PREPARE SQKONDLI FROM :WKSTMTL
     C/END-EXEC
     C*------------------------------------------
     C/EXEC SQL
     C+ DECLARE KONDLIKY SCROLL CURSOR FOR SQKONDLI
     C/END-EXEC
     C*------------------------------------------
     C/EXEC SQL
     C+ OPEN KONDLIKY
     C/END-EXEC
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN CURSOR FÜR KONDITIONEN RECHTS                              ***
     C**************************************************************************
     C     OCKONDR       BEGSR
     C*
     C/EXEC SQL
     C+  PREPARE SQKONDRE FROM :WKSTMTR
     C/END-EXEC
     C*------------------------------------------
     C/EXEC SQL
     C+ DECLARE KONDREKY SCROLL CURSOR FOR SQKONDRE
     C/END-EXEC
     C*------------------------------------------
     C/EXEC SQL
     C+ OPEN KONDREKY
     C/END-EXEC
     C*
     C                   ENDSR
     C*********************************************************
     C***  CLOSE CURSOR DATEI KONDLIKY
     C*********************************************************
     C     CCKONDL       BEGSR
     C*
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE KONDLIKY
     C/END-EXEC
     C*--------------------------------------------------------
     C                   ENDSR
     C*********************************************************
     C***  CLOSE CURSOR DATEI KONDREKY
     C*********************************************************
     C     CCKONDR       BEGSR
     C*
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE KONDREKY
     C/END-EXEC
     C*--------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  STATEMENT FÜR KEYBEGRIFF LINKS                                    ***
     C**************************************************************************
     C     KEYKONDL      BEGSR
     C*--------------------------------------------------------
     C                   EVAL      WKSTMTL =
     C                             'SELECT * FROM KOND '  +
     C                             'WHERE KOFIRM = ''' + DAFIRM + ''''
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND KOBEGR = ''' + WKBEGRLI + ''''
     C*
     C* Selektion mit Kundennummer + Kundengruppe
     C*
     C                   IF        WKKKEYLI = 'KOKG'
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND (UCASE(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLI) + ''')'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' OR UCASE(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLG) + '''))'
     C*
     C                   ENDIF
     C*
     C                   IF        WKKKEYLI = 'KUKG'
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND (UCASE(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDNR) + ''')'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' OR UCASE(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDLG) + '''))'
     C*
     C                   ENDIF
     C*
     C* Selektion nur mit Kundennummer
     C*
     C                   IF        WKKKEYLI = 'KO'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLI) + ''')'
     C                   ENDIF
     C*
     C                   IF        WKKKEYLI = 'KU'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDNR) + ''')'
     C                   ENDIF
     C*
     C* Selektion nur mit Kundengruppe
     C*
     C                   IF        WKKKEYLI = 'KG'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND (UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLG) + ''')'
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' OR UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDLG) + '''))'
     C                   ENDIF
     C*
     C     DSKONDPRGR    IFNE      *BLANK
     C                   IF        %SCAN(WCTRD:DSKONDPRGR) = *ZERO
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND UCASE(KOPRGR) = ' +
     C                             'UCASE(''' + DSKONDPRGR + ''')'
     C                   ELSE
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND UCASE(KOPRGR) LIKE UCASE(''' +
     C                             %TRIMR(%XLATE(WCTRD:WCSQL:DSKONDPRGR))+''')'
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND (KOGADA = 0 OR KOGADA <= ' +
     C                             %CHAR(WKGADA) +')'
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' AND (KOGBDA = 0 OR KOGBDA >= ' +
     C                             %CHAR(WKGADA) +')'
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' ORDER BY KOFIRM, KOBEGR, KOPRGR'
     C*
     C                   EVAL      WKSTMTL = %TRIM(WKSTMTL) +
     C                             ' FOR FETCH ONLY'
     C*--------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  STATEMENT FÜR KEYBEGRIFF RECHTS                                   ***
     C**************************************************************************
     C     KEYKONDR      BEGSR
     C*--------------------------------------------------------
     C                   EVAL      WKSTMTR =
     C                             'SELECT * FROM KOND '  +
     C                             'WHERE KOFIRM = ''' + DAFIRM + ''''
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND KOBEGR = ''' + WKBEGRRE + ''''
     C*
     C* Selektion mit Kundennummer + Kundengruppe
     C*
     C                   IF        WKKKEYRE = 'KOKG'
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND (UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLI) + ''')'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' OR UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLG) + '''))'
     C*
     C                   ENDIF
     C*
     C                   IF        WKKKEYRE = 'KUKG'
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND (UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDNR) + ''')'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' OR UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDLG) + '''))'
     C*
     C                   ENDIF
     C*
     C* Selektion nur mit Kundennummer
     C*
     C                   IF        WKKKEYRE = 'KO'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLI) + ''')'
     C                   ENDIF
     C*
     C                   IF        WKKKEYRE = 'KU'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND UPPER(KOKDLI) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDNR) + ''')'
     C                   ENDIF
     C*
     C* Selektion nur mit Kundengruppe
     C*
     C                   IF        WKKKEYRE = 'KG'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND (UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKONDKDLG) + ''')'
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' OR UPPER(KOKDLG) = ' +
     C                             'UCASE(''' + %TRIMR(DSKUNDKDLG) + '''))'
     C                   ENDIF
     C*
     C     WKKONDPRGR    IFNE      *BLANK
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND UCASE(KOPRGR) = ' +
     C                             'UCASE(''' + WKKONDPRGR + ''')'
     C                   ENDIF
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND (KOGADA = 0 OR KOGADA <= ' +
     C                             %CHAR(WKGADA) +')'
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' AND (KOGBDA = 0 OR KOGBDA >= ' +
     C                             %CHAR(WKGADA) +')'
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' ORDER BY KOFIRM, KOBEGR, KOPRGR'
     C*
     C                   EVAL      WKSTMTR = %TRIM(WKSTMTR) +
     C                             ' FOR FETCH ONLY'
     C*--------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  LESEN KONDITIONEN UND FÜLLEN MULTI-DS                             ***
     C**************************************************************************
     C     LIES_KOND     BEGSR
     C*                                                                     ----
     C     WKBEGRLI      IFEQ      *BLANK
     C     WKBEGRRE      ANDEQ     *BLANK
     C                   LEAVESR
     C                   ENDIF
     C*                                                                     ----
     C                   CLEAR                   KONDLINKS
     C                   CLEAR                   KONDRECHTS
     C*                                                                     ----
     C                   DO        *HIVAL
     C*                                                                     ----
     C/EXEC SQL
     C+ FETCH NEXT FROM KONDLIKY INTO :KONDLINKS
     C/END-EXEC
     C*                                                                     ----
     C     SQLCOD        IFNE      *ZERO
     C     RCDNBR        OREQ      9999
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*                                                                     ----
     C                   EVAL      KOND = KONDLINKS
     C                   MOVEL     KOPRGR        WKKONDPRGR
     C*                                                                     ----
     C                   SETOFF                                           99
     C                   Z-ADD     1             BI
     C     WKKONDPRGR    LOOKUP    PGVERA(BI)                             99
     C     *IN99         IFEQ      *ON
     C                   ITER
     C                   ENDIF
     C*
     C     BLANKPRGR     LOOKUP    PGVERA(BI)                             99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     WKKONDPRGR    PGVERA(BI)
     C                   ENDIF
     C*
     C*                                                                     ----
     C                   EXSR      KEYKONDR
     C                   EXSR      OCKONDR
     C*                                                                     ----
     C/EXEC SQL
     C+ FETCH NEXT FROM KONDREKY INTO :KONDRECHTS
     C/END-EXEC
     C*                                                                     ----
     C     SQLCOD        IFNE      *ZERO
     C                   CLEAR                   KONDRECHTS
     C                   ENDIF
     C*
     C                   EXSR      CCKONDR
     C*
     C                   ADD       1             WKANZKOND
     C     WKANZKOND     IFGT      9999
     C                   LEAVESR
     C                   ENDIF
     C*                                                                     ----
     C     WKANZKOND     OCCUR     DXKOND
     C*                                                                     ----
     C* ** STAFFELN **                                                      ----
     C*                                                                     ----
     C                   Z-ADD     0             SL
     C                   Z-ADD     0             SR
     C*                                                                     ----
     C* STAFFELN LINKS                                                      ----
     C*                                                                     ----
     C                   EVAL      KOND = KONDLINKS
     C*                                                                     ----
     C     KOBEGR        IFNE      *BLANK
     C     WKKKEYLI      ANDNE     *BLANK
     C*                                                                     ----
     C                   MOVEL     KOBEGR        DXKOBL
     C                   MOVEL     WKKKEYLI      DXKKTL
     C*                                                                     ----
     C                   MOVEL     KOPRGR        DXPRGL
     C*                                                                     ----
     C* SICHERN PRODUKTGRUPPE AUS EINGABE                                   ----
     C*
     C                   MOVEL     DSKONDPRGR    WKKONDPRGR
     C*
     C                   MOVEL     KOPRGR        WKKONDPRGR
     C                   EXSR      PRKONDPRGR
     C                   MOVEL     TXKONDPRGR    DXPRBL
     C*
     C                   Z-ADD     KORABA        DXRABL
     C                   MOVEL     KORBKZ        DXRBKL
     C*
     C                   SELECT
     C     KOMG10        WHENNE    *ZERO
     C                   Z-ADD     10            SL
     C     KOMG09        WHENNE    *ZERO
     C                   Z-ADD     9             SL
     C     KOMG08        WHENNE    *ZERO
     C                   Z-ADD     08            SL
     C     KOMG07        WHENNE    *ZERO
     C                   Z-ADD     07            SL
     C     KOMG06        WHENNE    *ZERO
     C                   Z-ADD     06            SL
     C     KOMG05        WHENNE    *ZERO
     C                   Z-ADD     05            SL
     C     KOMG04        WHENNE    *ZERO
     C                   Z-ADD     04            SL
     C     KOMG03        WHENNE    *ZERO
     C                   Z-ADD     03            SL
     C     KOMG02        WHENNE    *ZERO
     C                   Z-ADD     02            SL
     C     KOMG01        WHENNE    *ZERO
     C                   Z-ADD     01            SL
     C                   ENDSL
     C*                                                                     ----
     C                   ENDIF
     C*                                                                     ----
     C* STAFFELN RECHTS                                                     ----
     C*                                                                     ----
     C                   EVAL      KOND = KONDRECHTS
     C*                                                                     ----
     C*                                                                     ----
     C     KOBEGR        IFNE      *BLANK
     C     WKKKEYRE      ANDNE     *BLANK
     C*                                                                     ----
     C                   MOVEL     KOBEGR        DXKOBR
     C                   MOVEL     WKKKEYRE      DXKKTR
     C*                                                                     ----
     C                   MOVEL     KOPRGR        DXPRGR
     C                   MOVEL     TXKONDPRGR    DXPRBR
     C                   Z-ADD     KORABA        DXRABR
     C                   MOVEL     KORBKZ        DXRBKR
     C*                                                                     ----
     C     DXPRGL        IFEQ      *BLANK
     C     DXPRBL        OREQ      *BLANK
     C                   MOVEL     DXPRGR        DXPRGL
     C                   MOVEL     DXPRBR        DXPRBL
     C                   ENDIF
     C*                                                                     ----
     C                   SELECT
     C     KOMG10        WHENNE    *ZERO
     C                   Z-ADD     10            SR
     C     KOMG09        WHENNE    *ZERO
     C                   Z-ADD     9             SR
     C     KOMG08        WHENNE    *ZERO
     C                   Z-ADD     08            SR
     C     KOMG07        WHENNE    *ZERO
     C                   Z-ADD     07            SR
     C     KOMG06        WHENNE    *ZERO
     C                   Z-ADD     06            SR
     C     KOMG05        WHENNE    *ZERO
     C                   Z-ADD     05            SR
     C     KOMG04        WHENNE    *ZERO
     C                   Z-ADD     04            SR
     C     KOMG03        WHENNE    *ZERO
     C                   Z-ADD     03            SR
     C     KOMG02        WHENNE    *ZERO
     C                   Z-ADD     02            SR
     C     KOMG01        WHENNE    *ZERO
     C                   Z-ADD     01            SR
     C                   ENDSL
     C*                                                                     ----
     C                   ENDIF
     C*                                                                     ----
     C                   Z-ADD     SL            I2
     C     SR            IFGT      SL
     C                   Z-ADD     SR            I2
     C                   ENDIF
     C*
     C                   Z-ADD     0             I1
     C*
     C* ANFANG STAFFELN AUSGEBEN
     C*
     C     I1            DOWLT     I2
     C*
     C                   ADD       1             I1
     C*
     C                   ADD       1             WKANZKOND
     C     WKANZKOND     IFGT      9999
     C                   LEAVESR
     C                   ENDIF
     C*
     C     WKANZKOND     OCCUR     DXKOND
     C*
     C* ANFANG AUSGABE STAFFEL LINKS
     C*
     C     I1            IFLE      SL
     C*
     C                   MOVEL     KONDLINKS     KOND
     C*
     C                   MOVEL     KOPRGR        DXPRGL
     C*
     C                   MOVEL     DSKONDPRGR    WKKONDPRGR
     C                   MOVEL     KOPRGR        WKKONDPRGR
     C                   EXSR      PRKONDPRGR
     C                   MOVEL     TXKONDPRGR    DXPRBL
     C*
     C     KOBEGR        IFNE      *BLANK
     C*
     C                   MOVEL     KOBEGR        DXKOBL
     C                   MOVEL     WKKKEYLI      DXKKTL
     C*
     C                   Z-ADD     KORABA        DXRABL
     C                   MOVEL     KORBKZ        DXRBKL
     C*
     C                   SELECT
     C     I1            WHENEQ    10
     C                   Z-ADD     KOMG10        DXSTAL
     C                   Z-ADD     KORB10        DXRABL
     C                   MOVEL     KOPD10        DXRBKL
     C     I1            WHENEQ    09
     C                   Z-ADD     KOMG09        DXSTAL
     C                   Z-ADD     KORB09        DXRABL
     C                   MOVEL     KOPD09        DXRBKL
     C     I1            WHENEQ    08
     C                   Z-ADD     KOMG08        DXSTAL
     C                   Z-ADD     KORB08        DXRABL
     C                   MOVEL     KOPD08        DXRBKL
     C     I1            WHENEQ    07
     C                   Z-ADD     KOMG07        DXSTAL
     C                   Z-ADD     KORB07        DXRABL
     C                   MOVEL     KOPD07        DXRBKL
     C     I1            WHENEQ    06
     C                   Z-ADD     KOMG06        DXSTAL
     C                   Z-ADD     KORB06        DXRABL
     C                   MOVEL     KOPD06        DXRBKL
     C     I1            WHENEQ    05
     C                   Z-ADD     KOMG05        DXSTAL
     C                   Z-ADD     KORB05        DXRABL
     C                   MOVEL     KOPD05        DXRBKL
     C     I1            WHENEQ    04
     C                   Z-ADD     KOMG04        DXSTAL
     C                   Z-ADD     KORB04        DXRABL
     C                   MOVEL     KOPD04        DXRBKL
     C     I1            WHENEQ    03
     C                   Z-ADD     KOMG03        DXSTAL
     C                   Z-ADD     KORB03        DXRABL
     C                   MOVEL     KOPD03        DXRBKL
     C     I1            WHENEQ    02
     C                   Z-ADD     KOMG02        DXSTAL
     C                   Z-ADD     KORB02        DXRABL
     C                   MOVEL     KOPD02        DXRBKL
     C     I1            WHENEQ    01
     C                   Z-ADD     KOMG01        DXSTAL
     C                   Z-ADD     KORB01        DXRABL
     C                   MOVEL     KOPD01        DXRBKL
     C                   ENDSL
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C* ENDE AUSGABE STAFFEL LINKS
     C*
     C* ANFANG AUSGABE STAFFEL RECHTS
     C*
     C     I1            IFLE      SR
     C*
     C                   MOVEL     KONDRECHTS    KOND
     C*                                                                     ----
     C                   MOVEL     KOPRGR        DXPRGR
     C                   MOVEL     KOPRGR        WKKONDPRGR
     C                   EXSR      PRKONDPRGR
     C                   MOVEL     TXKONDPRGR    DXPRBR
     C*                                                                     ----
     C     KOBEGR        IFNE      *BLANK
     C*                                                                     ----
     C                   MOVEL     KOBEGR        DXKOBR
     C                   MOVEL     WKKKEYRE      DXKKTL
     C*                                                                     ----
     C                   MOVEL     KOPRGR        DXPRGR
     C                   MOVEL     TXKONDPRGR    DXPRBR
     C                   Z-ADD     KORABA        DXRABR
     C                   MOVEL     KORBKZ        DXRBKR
     C*                                                                     ----
     C                   SELECT
     C     I1            WHENEQ    10
     C                   Z-ADD     KOMG10        DXSTAR
     C                   Z-ADD     KORB10        DXRABR
     C                   MOVEL     KOPD10        DXRBKR
     C     I1            WHENEQ    09
     C                   Z-ADD     KOMG09        DXSTAR
     C                   Z-ADD     KORB09        DXRABR
     C                   MOVEL     KOPD09        DXRBKR
     C     I1            WHENEQ    08
     C                   Z-ADD     KOMG08        DXSTAR
     C                   Z-ADD     KORB08        DXRABR
     C                   MOVEL     KOPD08        DXRBKR
     C     I1            WHENEQ    07
     C                   Z-ADD     KOMG07        DXSTAR
     C                   Z-ADD     KORB07        DXRABR
     C                   MOVEL     KOPD07        DXRBKR
     C     I1            WHENEQ    06
     C                   Z-ADD     KOMG06        DXSTAR
     C                   Z-ADD     KORB06        DXRABR
     C                   MOVEL     KOPD06        DXRBKR
     C     I1            WHENEQ    05
     C                   Z-ADD     KOMG05        DXSTAR
     C                   Z-ADD     KORB05        DXRABR
     C                   MOVEL     KOPD05        DXRBKR
     C     I1            WHENEQ    04
     C                   Z-ADD     KOMG04        DXSTAR
     C                   Z-ADD     KORB04        DXRABR
     C                   MOVEL     KOPD04        DXRBKR
     C     I1            WHENEQ    03
     C                   Z-ADD     KOMG03        DXSTAR
     C                   Z-ADD     KORB03        DXRABR
     C                   MOVEL     KOPD03        DXRBKR
     C     I1            WHENEQ    02
     C                   Z-ADD     KOMG02        DXSTAR
     C                   Z-ADD     KORB02        DXRABR
     C                   MOVEL     KOPD02        DXRBKR
     C     I1            WHENEQ    01
     C                   Z-ADD     KOMG01        DXSTAR
     C                   Z-ADD     KORB01        DXRABR
     C                   MOVEL     KOPD01        DXRBKR
     C                   ENDSL
     C*
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     DXPRGL        IFEQ      *BLANK
     C     DXPRBL        OREQ      *BLANK
     C                   MOVEL     DXPRGR        DXPRGL
     C                   MOVEL     DXPRBR        DXPRBL
     C                   ENDIF
     C*
     C                   ENDDO
     C*
     C* ENDE AUSGABE STAFFELN                                               ----
     C*
     C                   ENDDO
     C*
     C* ENDE LESEN LINKS                                                    ----
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILD01                                              ***
     C**************************************************************************
     C     BILD01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      B01DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     '01'
     C                   WRITE     WAO01501
     C                   WRITE     WAO015K1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT05
     C                   MOVE      *ON           FUKT10
     C                   MOVE      *ON           FUKT11
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   MOVE      *ON           FUKT26
     C*--------------------------------------------------------
     C                   SELECT
     C     WKPGST        WHENEQ    '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   WRITE     WAO015B2
     C     WKBT24        WHENEQ    *OFF
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     WAO015B1
     C     WKBT24        WHENEQ    *ON
     C                   MOVE      *ON           FUKT06
     C                   MOVE      *ON           FUKT20
     C                   MOVE      *ON           FUKT24
     C                   WRITE     WAO015B3
     C                   ENDSL
     C*--------------------------------------------------------
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*--------------------------------------------------------
     C                   READ      WAO015K1                             9899
     C*-------------------------------------------------------------------------
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#UPDT        WHENEQ    *ON
     C     FUKT05        ANDEQ     *ON
     C                   MOVEA     *BLANK        SFLKOND
     C***                Z-ADD     0             W2ANZKOND
     C                   MOVE      *OFF          WKSUPD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#BACK        WHENEQ    *ON
     C     FUKT10        ANDEQ     *ON
     C                   EXSR      TRTRDZ
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#VIEW        WHENEQ    *ON
     C     FUKT11        ANDEQ     *ON
     C                   ADD       1             SI
     C*
     C     SI            IFGT      10
     C     FSI(SI)       OREQ      *ZERO
     C                   Z-ADD     1             SI
     C                   ENDIF
     C*
     C                   Z-ADD     FSI(SI)       WKISIC
     C                   EXSR      MCUEB
     C                   EXSR      B01SI
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   MOVE      *ZERO         WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   MOVEA     *BLANK        SFLKOND
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   ITER
     C*--------------------------------------------------------
     C     C#WEIT        WHENEQ    *ON
     C     FUKT24        ANDEQ     *ON
     C*
     C     WKBT24        IFEQ      *OFF
     C                   MOVE      *ON           WKBT24
     C                   ELSE
     C                   MOVE      *OFF          WKBT24
     C                   ENDIF
     C*
     C                   ITER
     C*--------------------------------------------------------
     C     C#PGUP        WHENEQ    *ON
     C     FUKT26        ANDEQ     *ON
     C***                EXSR      BLAET
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C     FUKT10        ANDEQ     *ON
     C                   EXSR      TRTRDZ
     C
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*
     C***                Z-ADD     0             W2ANZKOND
     C                   MOVE      *OFF          WKSUPD
     C*
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   OTHER
     C*--------------------------------------------------------
     C                   EXSR      B01RA
     C                   EXSR      B01SF
     C*
     C     CSRRRN        IFGT      *ZERO
     C                   Z-ADD     CSRRRN        PAGNBR
     C                   ENDIF
     C*
     C                   SELECT
     C     WKFENR        WHENNE    *ZERO
     C     WKSUPD        ANDEQ     *OFF
     C     #CRTCD        OREQ      'N'
     C     WKSUPD        ANDEQ     *OFF
     C                   ITER
     C     WKSUPD        WHENEQ    *OFF
     C                   ITER
     C                   OTHER
     C                   LEAVE
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01RA         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01SF         BEGSR
     C*
     C                   Z-ADD     W1ANZKOND     W2ANZKOND
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT 01                                        ***
     C**************************************************************************
     C     B01DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C     WKUXMCOPEN    IFEQ      *ON
     C                   MOVEL     EXUXMCPARM    EXUX05PARM
     C                   EXSR      EXMCCLOS
     C                   MOVE      *OFF          WKUXMCOPEN
     C                   ENDIF
     C*
     C     WKUXMCOPEN    IFNE      *ON
     C                   EXSR      UXMCOPEN
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#INIT
     C                   WRITE     WAO015K1
     C*
     C                   MOVE      *OFF          C#INIT
     C                   MOVE      *OFF          C#MORE
     C                   MOVE      *OFF          C#NEXT
     C                   Z-ADD     *ZERO         RCDNBR
     C                   Z-ADD     PAGNBR        W2ANZKOND
     C                   Z-ADD     PAGNBR        W1ANZKOND
     C                   Z-ADD     *ZERO         PAGNBR
     C*-------------------------------------------------------------------------
     C     W$RCNO        DOWGT     RCDNBR
     C     W$RCNO        OREQ      *ZERO
     C*
     C                   EXSR      KOND01
     C*
     C                   MOVE      *ON           C#PGUP
     C                   MOVE      *ON           C#MORE
     C*--------------------------------------------------------
     C     C#MORE        IFEQ      *ON
     C     W$RCNO        OREQ      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#PGUP
     C*
     C     W$RCNO        IFGT      *ZERO
     C     W$RCNO        ANDLE     RCDNBR
     C                   Z-ADD     W$RCNO        PAGNBR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      MCUEB
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     B01SI         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*-------------------------------------------------------------------------
     C     EXUXMCRTCD    DOWEQ     *ZERO
     C                   EVAL      EXUXSICHT = EXUXMCIDTA
     C                   EVAL      RCDNBR = EXUXRCNR
     C     RCDNBR        CHAIN     WAO015R1                           97
     C*--------------------------------------------------------
     C     *IN97         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   EXSR      FKONS                                        SICHT IN SFL SUCHEN
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#NEXT
     C*--------------------------------------------------------
     C                   UPDATE    WAO015R1
     C                   MOVE      *OFF          C#NEXT
     C*----------------------------------------------------------
     C                   EXSR      EXMCNEXT
     C                   EVAL      EXUXMCPARM =  EXUX05PARM
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG BILD01                                              ***
     C**************************************************************************
     C     B01PR         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN SUBFILE ZUM FÜLLEN VON KONS BEI F11                         ***
     C**************************************************************************
     C     BDLSI         BEGSR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  STEUERROUTINE BILDM1                                              ***
     C**************************************************************************
     C     BILDM1        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     WKIFMT        IFNE      FMT(FM)
     C                   EXSR      IFMTS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1DS
     C*-------------------------------------------------------------------------
     C     WKIFMT        DOWEQ     'M1'
     C                   EXSR      EFLPO
     C                   WRITE     WAO015W2
     C                   WRITE     WAO015M1
     C                   EXSR      OFFUKT
     C                   MOVE      *ON           FUKT03
     C                   MOVE      *ON           FUKT04
     C                   MOVE      *ON           FUKT12
     C                   MOVE      *ON           FUKT13
     C                   WRITE     W2KONDB1
     C                   MOVE      *ON           WKIWND
     C*
     C     WKFENR        CASNE     *ZERO         AUMSG
     C                   ENDCS
     C*
     C                   MOVE      *OFF          C#WNDW
     C*-------------------------------------------------------------------------
     C                   READ      WAO015M1                             9899
     C*-------------------------------------------------------------------------
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     C#EXIT        WHENEQ    *ON
     C     FUKT03        ANDEQ     *ON
     C                   MOVE      'ENDE  '      #CPGST
     C                   MOVE      *ON           DAFEHL
     C                   MOVE      'N'           #CRTCD
     C                   MOVE      '00'          WKIFMT
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#SELC        WHENEQ    *ON
     C     FUKT04        ANDEQ     *ON
     C                   EXSR      MCAUFR
     C*
     C     WKTRTP        IFEQ      *ON
     C     WKFENR        ORNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*--------------------------------------------------------
     C     C#CANC        WHENEQ    *ON
     C     FUKT12        ANDEQ     *ON
     C                   EXSR      RFMTS
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      'N'           #CRTCD
     C                   LEAVE
     C*--------------------------------------------------------
     C     C#INFO        WHENEQ    *ON
     C     FUKT13        ANDEQ     *ON
     C                   EXSR      VINFO
     C                   MOVE      *ON           C#WNDW
     C                   ITER
     C*--------------------------------------------------------
     C     C#FUKT        WHENNE    *ZERO
     C                   MOVE      '0075'        WKFENR
     C                   ITER
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      BM1PR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      KOND_LIST
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        SFLKOND
     C                   Z-ADD     *ZERO         W$RCNO
     C                   MOVE      '01'          WKIFMT
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN BILDSCHIRMFORMAT M1                                        ***
     C**************************************************************************
     C     BM1DS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      WKIN30        C#LCK0
     C                   MOVE      WKIN31        C#LCK1
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        #CRTCD
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKUNDKDNR'  EXFLPOFLDN
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        DSKUNDKDNR
     C                   MOVE      *BLANK        DSKONDKDLG
     C                   MOVE      *BLANK        DSKONDPRGR
     C*-------------------------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C*
     C                   CLEAR                   EXDATE
     C                   MOVE      WKTDAT        EXDATEDATV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    DSGADA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KUND
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PLAUSIPRÜFUNG FÜR BILDM1                                          ***
     C**************************************************************************
     C     BM1PR         BEGSR
     C*
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKONDWACD
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKUNDKDNR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKONDKDLG
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEL     DSKONDPRGR    WKKONDPRGR
     C                   EXSR      PRKONDPRGR
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   EXSR      PRKONDGADA
     C*
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  FUNKTIONSTASTE 4 BILDM1                                           ***
     C**************************************************************************
     C     MCAUFR        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  FLDNAM        EXFLPOFLDN
     C                   EXSR      EFLPO
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*-------------------------------------------------------------------------
     C     EXFLPOKZIO    WHENEQ    *OFF
     C                   MOVE      '0052'        WKFENR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    *BLANK
     C                   MOVE      '0050'        WKFENR
     C                   MOVEL(P)  'DSKONDWACD'  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKONDWACD'
     C                   EXSR      WAO015WACD
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKUNDKDNR'
     C                   EXSR      WAO015KDNR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKONDKDLG'
     C                   EXSR      WAO015KDLG
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSKONDPRGR'
     C                   EXSR      WAO015PRGR
     C*-------------------------------------------------------------------------
     C     FLDNAM        WHENEQ    'DSGADA    '
     C                   EXSR      WAO015GADA
     C*-------------------------------------------------------------------------
     C                   OTHER
     C                   MOVE      '0050'        WKFENR
     C*-------------------------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE WACD                                                   ***
     C**************************************************************************
     C     WAO015WACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSKONDWACD    KOM(1)
     C                   MOVEL(P)  '0010'        #CUEBE
     C                   MOVEL(P)  'MCKOND'      #CPGST
     C                   EXSR      MCWACD
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL(P)  WCWACD        DSKONDWACD
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDNR                                                   ***
     C**************************************************************************
     C     WAO015KDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     DSKUNDKDNR    KOM(01)
     C                   MOVEL     '0005'        #CUEBE
     C                   EXSR      MCKUND
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL     KDKDNR        DSKUNDKDNR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE KDLG                                                   ***
     C**************************************************************************
     C     WAO015KDLG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     DASPCD        KOM(01)
     C                   MOVEA     'KDGR'        KOM(02)
     C                   MOVEA     DSKONDKDLG    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL     TPTCDE        DSKONDKDLG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     WAO015PRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        KOM
     C                   MOVEA     DASPCD        KOM(01)
     C                   MOVEA     'PRGR'        KOM(02)
     C                   MOVEA     DSKONDPRGR    KOM(12)
     C                   MOVEL     *BLANK        #CPGST
     C                   MOVEL     '0010'        #CUEBE
     C                   EXSR      MCTRTP
     C*
     C     WKTRTP        IFEQ      *OFF
     C     WKFENR        ANDEQ     *ZERO
     C                   MOVEL     *ON           WKTRTP
     C                   MOVEL     TPTCDE        DSKONDPRGR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE WACD                                                   ***
     C**************************************************************************
     C     PRKONDWACD    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKONDWACD'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKONDWACD
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DSKONDWACD    KOM(1)
     C                   EXSR      PRWACDWACD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDLI                                                   ***
     C**************************************************************************
     C     PRKUNDKDNR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKUNDKDNR'  EXFLPOFLDN
     C                   MOVE      *BLANK        DSKONDKDLI
     C                   MOVE      *BLANK        DSKUNDKDLG
     C                   MOVE      *BLANK        DSKUNDKNAM
     C                   MOVE      *BLANK        DSKONDKNAM
     C*-------------------------------------------------------------------------
     C     DSKUNDKDNR    IFNE      *BLANK
     C*
     C                   MOVE      DSKUNDKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C* INFO STAMMKUNDE
     C*
     C                   MOVEL     KDKDNR        DSKUNDKDNR
     C                   MOVEL     KDKNAM        DSKUNDKNAM
     C                   MOVEL     KDKDGR        DSKUNDKDLG
     C*
     C     KDKOKD        IFEQ      *BLANK
     C                   MOVEL     DSKUNDKDNR    DSKONDKDLI
     C                   ELSE
     C*
     C                   MOVEL     KDKOKD        DSKONDKDLI
     C                   MOVE      DSKONDKDLI    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C     WKFENR        IFNE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C* INFO KOND-KUNDE
     C*
     C                   MOVEL     KDKNAM        DSKONDKNAM
     C                   MOVEL     KDKDGR        DSKONDKDLG
     C*
     C     DSKUNDKDLG    IFEQ      *BLANK
     C                   MOVEL     DSKONDKDLG    DSKUNDKDLG
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE KDLG                                                   ***
     C**************************************************************************
     C     PRKONDKDLG    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKONDKDLG'  EXFLPOFLDN
     C                   MOVE      *BLANK        TXKONDKDLG
     C*-------------------------------------------------------------------------
     C     DSKONDKDLI    IFEQ      *BLANK
     C     DSKONDKDLG    ANDEQ     *BLANK
     C     DSKONDKDLI    ORNE      *BLANK
     C     DSKONDKDLG    ANDNE     *BLANK
     C                   MOVEL(P)  'DSKONDKDLI'  EXFLPOFLDN
     C                   MOVE      '0535'        WKFENR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     DSKONDKDLG    IFNE      *BLANK
     C                   MOVEL(P)  'KDGR'        KYTPTA
     C                   MOVEL(P)  DSKONDKDLG    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TPTTXT        TXKONDKDLG
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE PRGR                                                   ***
     C**************************************************************************
     C     PRKONDPRGR    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSKONDPRGR'  EXFLPOFLDN
     C                   MOVEL     *BLANK        TXKONDPRGR
     C*-------------------------------------------------------------------------
     C     WKKONDPRGR    IFNE      *BLANK
     C*-------------------------------------------------------------------------
     C                   IF         %SCAN(WCTRD:WKKONDPRGR) = *ZERO
     C                   MOVEL(P)  'PRGR'        KYTPTA
     C                   MOVEL(P)  WKKONDPRGR    KYTPTC
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRTP
     C*---------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  TPTTXT        TXKONDPRGR
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE GADA                                                   ***
     C**************************************************************************
     C     WAO015GADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSGADA        EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C*
     C     DSGADA        IFEQ      *ZERO
     C                   MOVEL(P)  'POSAKT'      EXDATEPGCD
     C                   ENDIF
     C*
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFEQ      *ZERO
     C     WKTRTP        ANDEQ     *OFF
     C                   Z-ADD     RTDATEDATE    DSGADA
     C                   MOVE      *ON           WKTRTP
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  PR-ROUTINE GADA                                                   ***
     C**************************************************************************
     C     PRKONDGADA    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'DSGADA    '  EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSGADA        EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTN
     C                   MOVE      'TRDAPR'      EXDATEPGST
     C                   EXSR      TRDATE
     C*
     C     WKFENR        IFNE      *ZERO                                        FEHLER
     C                   LEAVESR
     C                   ENDIF
     C*
     C                   Z-ADD     RTDATEDATE    DSGADA
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXDATE
     C                   Z-ADD     DSGADA        EXDATEDATV
     C                   MOVEL(P)  '*EUR'        EXDATEFMTV
     C                   MOVEL(P)  '*ISO'        EXDATEFMTN
     C                   MOVE      'TRDAUM'      EXDATEPGST
     C                   EXSR      TRDATE
     C                   Z-ADD     RTDATEDATE    WKGADA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MC-ROUTINE TRTK                                                   ***
     C**************************************************************************
     C     MCAUFRTRTK    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           C#WNDW
     C                   MOVEL(P)  'SFAUSW'      EXFLPOFLDN
     C*-------------------------------------------------------------------------
     C                   MOVEA(P)  DASPCD        KOM(01)
     C                   MOVEA     'QQQQ'        KOM(02)
     C                   MOVE      *BLANK        #CPGST
     C                   MOVE      '0010'        #CUEBE
     C                   EXSR      MCTRTK
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C**************************************************************************
     C***  BLAETTERROUTINE                                                   ***
     C**************************************************************************
     C     BLAET         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***                EXSR      KOND01
     C*-------------------------------------------------------------------------
     C                   WRITE     WAO015LO
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MATCHCODE ÜBERSCHRIFT ERMITTELN                                   ***
     C**************************************************************************
     C     MCUEB         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCUB'      WKSBFLPGST
     C                   Z-ADD     WKISIC        WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBE
     C                   EXSR      UMUEBE
     C*
     C                   MOVEL(P)  RTSBFLMCUB    DSUEBEJV
     C                   EXSR      UMUEBEJV
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ANZEIGEN DATEI KOND                                               ***
     C**************************************************************************
     C     KOND01        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          C#NDSP
     C                   MOVE      *OFF          WKILER
     C*RE  WKANZKOND     SUB       1             W$PAGE
     C                   Z-ADD     900           W$PAGE
     C                   Z-ADD     1             I0
     C*-------------------------------------------------------------------------
     C                   DOW       I0 <=(W$PAGE +1)
     C     I0            OCCUR     DXKOND                               77
     C*--------------------------------------------------------
     C     RCDNBR        IFEQ      9999
     C     *IN77         OREQ      *ON
     C     DXPRGL        OREQ      *BLANK
     C     DXPRGR        ANDEQ     *BLANK
     C                   MOVEL     '0374'        WKFENR
     C                   MOVE      *ON           C#MORE
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C     I0            IFLE      W$PAGE
     C*
     C                   ADD       1             RCDNBR
     C*
     C                   EXSR      ADUMM
     C*                                                                         ANZEIGE
     C                   EXSR      ERSIC
     C*
     C                   EXSR      FKONS
     C*
     C                   WRITE     WAO015R1
     C                   Z-ADD     W2ANZKOND     KYANZKOND
     C                   EXSR      UXMCWRTE
     C*
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ADD       1             I0
     C                   ADD       1             W2ANZKOND
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   EXSR      ERPAGE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN FÜR ANZEIGEN                                          ***
     C**************************************************************************
     C     ADUMM         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   WAO015SI
     C*
     C     I0            OCCUR     DXKOND
     C*
     C                   MOVEL     DXPRGL        W015SIPRGR
     C                   MOVEL     DXPRBL        W015SIPRGB
     C                   MOVEL     DXKOBL        W015SIBEG1
     C                   Z-ADD     DXRABL        W015SIRAB1
     C                   Z-ADD     DXSTAL        W015SISTA1
     C                   MOVEL     DXRBKL        W015SIRBK1
     C                   MOVEL     DXKOBR        W015SIBEG2
     C                   Z-ADD     DXRABR        W015SIRAB2
     C                   Z-ADD     DXSTAR        W015SISTA2
     C                   MOVEL     DXRBKR        W015SIRBK2
     C*
     C     DSKUNDKDNR    IFNE      *BLANK
     C                   MOVE      DSKUNDKDNR    KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SICHTEN                                                           ***
     C**************************************************************************
     C     ERSIC         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SIC
     C*
     C     SIC           DOWLE     10
     C     FSI(SIC)      ANDNE     *ZERO
     C                   MOVEL     'ERMCUZ'      WKSBFLPGST
     C                   Z-ADD     FSI(SIC)      WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C
     C                   SELECT
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1
     C     SIC           WHENEQ    1
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS1JV
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *OFF
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2
     C     SIC           WHENEQ    2
     C     C#IN28        ANDEQ     *ON
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS2JV
     C     SIC           WHENEQ    3
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS3
     C     SIC           WHENEQ    4
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS4
     C     SIC           WHENEQ    5
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS5
     C     SIC           WHENEQ    6
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS6
     C     SIC           WHENEQ    7
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS7
     C     SIC           WHENEQ    8
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS8
     C     SIC           WHENEQ    9
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS9
     C     SIC           WHENEQ    10
     C                   MOVEL(P)  RTSBFLMCUZ    EXUXS10
     C                   ENDSL
     C*
     C                   ADD       1             SIC
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  FÜLLEN VON KONS MIT DER JEWEILIGEN SICHT                          ***
     C**************************************************************************
     C     FKONS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     SI            WHENEQ    1
     C                   MOVEL     EXUXS1        SFKONS
     C                   MOVEL     EXUXS1JV      SFKONSJV
     C     SI            WHENEQ    2
     C                   MOVEL     EXUXS2        SFKONS
     C                   MOVEL     EXUXS2JV      SFKONSJV
     C     SI            WHENEQ    3
     C                   MOVEL     EXUXS3        SFKONS
     C     SI            WHENEQ    4
     C                   MOVEL     EXUXS4        SFKONS
     C     SI            WHENEQ    5
     C                   MOVEL     EXUXS5        SFKONS
     C     SI            WHENEQ    6
     C                   MOVEL     EXUXS6        SFKONS
     C     SI            WHENEQ    7
     C                   MOVEL     EXUXS7        SFKONS
     C     SI            WHENEQ    8
     C                   MOVEL     EXUXS8        SFKONS
     C     SI            WHENEQ    9
     C                   MOVEL     EXUXS9        SFKONS
     C     SI            WHENEQ    10
     C                   MOVEL     EXUXS10       SFKONS
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN SEITE                                                   ***
     C**************************************************************************
     C     ERPAGE        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     RCDNBR        WHENEQ    *ZERO
     C                   Z-ADD     1             RCDNBR
     C                   Z-ADD     1             PAGNBR
     C                   MOVE      *ON           C#NDSP
     C                   MOVE      *ON           WKILER
     C     C#IN28        IFEQ      *OFF
     C                   MOVEL(P)  TXKEIN        EXUXS1
     C                   MOVEL(P)  TXKEIN        EXUXS2
     C                   MOVEL(P)  TXKEIN        EXUXS3
     C                   MOVEL(P)  TXKEIN        EXUXS4
     C                   MOVEL(P)  TXKEIN        EXUXS5
     C                   MOVEL(P)  TXKEIN        EXUXS6
     C                   MOVEL(P)  TXKEIN        EXUXS7
     C                   MOVEL(P)  TXKEIN        EXUXS8
     C                   MOVEL(P)  TXKEIN        EXUXS9
     C                   MOVEL(P)  TXKEIN        EXUXS10
     C                   MOVEL(P)  TXKEIN        SFKONS
     C                   ELSE
     C                   MOVEL(P)  TXKEIN        EXUXS1JV
     C                   MOVEL(P)  TXKEIN        EXUXS2JV
     C                   MOVEL(P)  TXKEIN        SFKONSJV
     C                   ENDIF
     C                   WRITE     WAO015R1
     C                   EXSR      UXMCWRTE
     C*--------------------------------------------------------
     C     RCDNBR        WHENNE    *ZERO
     C     RCDNBR        SUB       1             PAGNBR
     C                   DIV       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   MULT      W$PAGE        PAGNBR
     C                   SUB       W$PAGE        PAGNBR
     C                   ADD       1             PAGNBR
     C                   Z-ADD     PAGNBR        WKPAGE
     C                   Z-ADD     RCDNBR        WKRENO
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFRUF SUBFILE-ZEILEN-ERMITTLUNG                                  ***
     C**************************************************************************
     C     TRAUFRSBFL    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXSBFL
     C                   MOVEL(P)  'WAO015'      EXSBFLPROG
     C                   MOVEL(P)  'WAO015FM'    EXSBFLFMTN
     C                   MOVEL     WKSBFLPGST    EXSBFLPGST
     C                   MOVEL     WKSBFLISIC    EXSBFLISIC
     C*
     C                   MOVEL(P)  'WAO015SI'    EXSBFLFIL1
     C                   MOVEL(P)  WAO015SI      EXSBFLDAT1
     C*
     C                   MOVEL(P)  'KUND'        EXSBFLFIL2
     C                   MOVEL(P)  KUND          EXSBFLDAT2
     C*
     C                   EXSR      TRSBFL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     'ERMCSI'      WKSBFLPGST
     C                   Z-ADD     *ZERO         WKSBFLISIC
     C                   EXSR      TRAUFRSBFL
     C*
     C                   MOVEA(P)  RTSBFLMCSI    WSI
     C*--------------------------------------------------------
     C                   Z-ADD     *ZERO         SI
     C                   Z-ADD     *ZERO         FSI
     C*--------------------------------------------------------
     C                   DO        10            I1
     C                   TESTN                   WSI(I1)              97
     C*
     C     *IN97         IFEQ      *ON
     C                   ADD       1             SI
     C                   MOVE      WSI(I1)       FSI(SI)
     C                   ENDIF
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             SI
     C                   Z-ADD     FSI(SI)       WKISIC                         SICHT
     C*-------------------------------------------------------------------------
     C                   MOVE      *ALL'9'       SORTBEGR
     C                   Z-ADD     0             I0
     C*
     C                   MOVEL(P)  'ZUAR     '   KYTATA
     C                   MOVEL(P)  'KOND      '  KYTATC
     C                   MOVEL(P)  *LOVAL        KYTAPA
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHTRPA
     C*                                                                     ----
     C                   DO        *HIVAL
     C*
     C                   MOVEA     '01R     '    CHI                            LESEN FÜR
     C                   EXSR      CHTRPA                                       UPDATE
     C*
     C     WKFENR        IFGT      *ZERO
     C     TAFIRM        ORNE      KYTAFI
     C     TATCDE        ORNE      'KOND      '
     C                   LEAVE
     C                   ENDIF
     C*
     C                   ADD       1             I0
     C                   MOVEL     TAPART        SORTBEGR(I0)
     C                   MOVE      TAPCDE        SORTBEGR(I0)
     C*
     C                   ENDDO
     C*                                                                     ----
     C                   SORTA     SORTBEGR
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUSWAHL 10 UND ZUGRIFF AUF TRTRDZ                                 ***
     C**************************************************************************
     C     TRTRDZ        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C                   MOVE      *OFF          WKTRTP
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *OFF          WKTRDZZYKL
     C*-------------------------------------------------------------------------
     C     WKFENR        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTRDN
     C                   MOVEL(P)  *BLANK        EXTRDNAWCD
     C                   MOVEL(P)  'WAO015'      EXTRDNPGNA
     C                   MOVEL(P)  'AUFRUF'      EXTRDNPGST
     C*--------------------------------------------------------
     C*
     C     WKPGST        IFEQ      '5     '
     C     WKPGST        OREQ      'DETAIL'
     C                   MOVEL(P)  'WAO015B2'    EXTRDNPGNA
     C                   ENDIF
     C*
     C                   MOVE      C#FUKT        EXTRDNFUKT
     C*-------------------------------------------------------------------------
     C     WKTRDZZYKL    IFEQ      *OFF
     C                   MOVE      *ON           EXTRDNMCKZ
     C                   MOVE      *ON           WKTRDZZYKL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CALL      'TRTRDZ'
     C                   PARM                    EXTRDN
     C*-------------------------------------------------------------------------
     C     EXTRDNRTCD    IFEQ      'N'
     C     EXTRDNFENR    ORNE      *ZERO
     C                   MOVE      EXTRDNFENR    WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        #CRTCD
     C*
     C     C#FUKT        IFNE      *ZERO
     C     C#BACK        ANDNE     *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXMCOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXMCPARM
     C                   EVAL      EXUXMCINAM = 'MCSBFKOND'
     C                   EVAL      EXUXMCILIB = 'QTEMP'
     C                   EVAL      EXUXMCIATR = 'TREND'
     C                   EVAL      EXUXMCDTLG = 4 + 996
     C                   EVAL      EXUXMCKYLG = 4
     C                   EVAL      EXUXMCITXT = 'Subfile WAO015'
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXMCOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXMCWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY  = DUC004
     C                   EVAL      EXUXRCNR    = RCDNBR
     C                   EVAL      UXANZKOND   = KYANZKOND
     C                   EVAL      EXUXMCIDTA  = EXUXSICHT + UXKOND
     C                   EVAL      EXUXMCIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXMCREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYKOND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C                   EVAL      EXUXMCIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXMCPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXMCIDTA
     C                   EVAL      DUN030      = %LEN(UXKOND)
     C                   EVAL      UXKOND      = %SUBST(EXUXMCIDTA:765:DUN030)
     C                   EVAL      KYANZKOND   = UXANZKOND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LÖSCHEN   USERINDEX                                               ***
     C**************************************************************************
     C     UXMCRMKY      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     RCDNBR        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXMCIKEY = DUC004
     C                   EVAL      EXUXRCNR     = RCDNBR
     C                   EVAL      UXANZKOND   = KYANZKOND
     C                   EVAL      EXUXMCIDTA = EXUXSICHT + UXKOND
     C                   EVAL      EXUXMCIMDE = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCBYKY
     C*
     C                   EVAL      EXUX05PARM =  EXUXMCPARM
     C                   EXSR      EXMCRMKY
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN USERINDEX                                                  ***
     C**************************************************************************
     C     UXDLOPEN      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXUXDLPARM
     C                   EVAL      EXUXDLINAM  = 'DLSBFKOND'
     C                   EVAL      EXUXDLILIB  = 'QTEMP'
     C                   EVAL      EXUXDLIATR  = 'TREND'
     C                   EVAL      EXUXDLDTLG  = 4 + 996
     C                   EVAL      EXUXDLKYLG  = 4
     C                   EVAL      EXUXDLITXT  = 'Subfile DLKOND'
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCOPEN
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ON           WKUXDLOPEN
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN USERINDEX                                               ***
     C**************************************************************************
     C     UXDLWRTE      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***                Z-ADD     WKRCNO        DUN040
     C*-------------------------------------------------------------------------
     C                   EVAL      EXUXDLIKEY  = DUC004
     C                   EVAL      UXANZKOND   = KYANZKOND
     C                   EVAL      EXUXDLIDTA  = EXUXSICHT + UXKOND
     C                   EVAL      EXUXDLIMDE  = EXUX07NORP
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCWRTE
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  LESEN USERINDEX                                                   ***
     C**************************************************************************
     C     UXDLREAD      BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   KYKOND
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKRCNO        DUN040
     C                   EVAL      EXUXDLIKEY  = DUC004
     C*
     C                   EVAL      EXUX05PARM  = EXUXDLPARM
     C                   EXSR      EXMCBYKY
     C                   EVAL      EXUXDLPARM  = EXUX05PARM
     C*
     C                   EVAL      EXUXSICHT   = EXUXDLIDTA
     C                   EVAL      DUN030      = %LEN(UXKOND)
     C                   EVAL      UXKOND      = %SUBST(EXUXDLIDTA:765:DUN030)
     C                   EVAL      KYANZKOND   = UXANZKOND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C***  PRÜFEN KONDITION AUS VKNU GEGEN KEY-BESTÜCKUNG                    ***
     C**************************************************************************
     C*
     C* Für eine relevante Kondition müssen diese Bed. erfüllt sein:
     C* 1. Produktgruppe ist bestückt
     C* 2. Kundennummer oder Kundengruppe ist bestückt
     C* Alle anderen variablen Keyfelder in KOND werden in der Folge
     C* als leer angenommen
     C*
     C     CHECK_KBST    BEGSR
     C*
     C                   MOVEL(P)  'KOND'        KYKBFL
     C                   MOVEL(P)  WKBEGR        KYKBBG
     C*
     C                   MOVE      *BLANK        WKBEGR
     C                   MOVE      *BLANK        WKKKEY
     C*
     C                   SETOFF                                           99
     C                   Z-ADD     1             BI
     C     KYKBBG        LOOKUP    BSAVE(BI)                              99
     C     *IN99         IFEQ      *OFF
     C     BLANKBEGR     LOOKUP    BSAVE(BI)                              99
     C     *IN99         IFEQ      *ON
     C                   MOVEL     KYKBBG        BSAVE(BI)
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKBST
     C*
     C     WKFENR        IFEQ      *ZERO
     C     KBPGKZ        ANDNE     *BLANK
     C*
     C     KBKLKZ        IFEQ      '1'
     C     DSKONDKDLI    ANDNE     *BLANK
     C                   CAT       'KO':0        WKKKEY
     C                   ELSE
     C     KBKLKZ        IFEQ      '2'
     C     DSKUNDKDNR    ANDNE     *BLANK
     C                   CAT       'KU':0        WKKKEY
     C                   ENDIF
     C                   ENDIF
     C*
     C     KBKGKZ        IFEQ      '1'
     C                   CAT       'KG':0        WKKKEY
     C                   ENDIF
     C*
     C                   ENDIF
     C*
     C     WKKKEY        IFNE      *BLANK
     C                   MOVEL     KYKBBG        WKBEGR
     C                   ENDIF
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
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5
     C     *LIKE         DEFINE    WKC001        WKPGST          + 5
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKILER
     C     *LIKE         DEFINE    WKC001        WKAT01
     C     *LIKE         DEFINE    WKC001        WKAT02
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKIWND
     C     *LIKE         DEFINE    WKC001        WKMCKZ          + 1
     C     *LIKE         DEFINE    WKC001        WKBT24
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*
     C     *LIKE         DEFINE    WKC001        WKUXMCOPEN
     C     *LIKE         DEFINE    WKC001        WKUXDLOPEN
     C     *LIKE         DEFINE    WKC001        WKOPENKY
     C     *LIKE         DEFINE    WKC001        WKBEGR          + 2
     C     *LIKE         DEFINE    WKC001        BLANKBEGR       + 2
     C     *LIKE         DEFINE    WKC001        WKBEGRLI        + 2
     C     *LIKE         DEFINE    WKC001        WKBEGRRE        + 2
     C     *LIKE         DEFINE    WKC001        WKKKEY          + 3
     C     *LIKE         DEFINE    WKC001        WKKKEYLI        + 3
     C     *LIKE         DEFINE    WKC001        WKKKEYRE        + 3
     C     *LIKE         DEFINE    WKC001        TXKONDPRGR      +29
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKSUPD
     C     *LIKE         DEFINE    WKC001        WKIDEL
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        TXKEIN          +75
     C     *LIKE         DEFINE    WKC001        WKSTMTL        +999
     C     *LIKE         DEFINE    WKC001        WKSTMTR        +999
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 4
     C     *LIKE         DEFINE    WKN010        WKANZKOND       + 5
     C     *LIKE         DEFINE    WKN010        W1ANZKOND       + 5
     C     *LIKE         DEFINE    WKN010        W2ANZKOND       + 5
     C     *LIKE         DEFINE    WKN010        KYANZKOND       + 5
     C     *LIKE         DEFINE    WKN010        UXANZKOND       + 5
     C     *LIKE         DEFINE    WKN010        I1              + 4
     C     *LIKE         DEFINE    WKN010        I2              + 4
     C     *LIKE         DEFINE    WKN010        I3              + 4
     C     *LIKE         DEFINE    WKN010        SI              + 4
     C     *LIKE         DEFINE    WKN010        SL              + 4
     C     *LIKE         DEFINE    WKN010        SR              + 4
     C     *LIKE         DEFINE    WKN010        BI              + 4
     C     *LIKE         DEFINE    WKN010        WKUDAT          + 7
     C     *LIKE         DEFINE    WKN010        WKGADA          + 7
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKISIC           +1
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C     *LIKE         DEFINE    DAUSER        WKUSER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    PAGNBR        WKPAGE
     C     *LIKE         DEFINE    PAGNBR        W$PAGE
     C     *LIKE         DEFINE    RCDNBR        WKRENO
     C     *LIKE         DEFINE    RCDNBR        W$RCNO
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    KYKOND        WKKOND
     C     *LIKE         DEFINE    EXUXMCPARM    WKUXMCPARM
     C     *LIKE         DEFINE    KYTPTA        OFTPTA
     C     *LIKE         DEFINE    KYTPTC        OFTPTC
     C     *LIKE         DEFINE    KYKOPG        OFKOPG
     C     *LIKE         DEFINE    KYKOPG        WKKONDPRGR
     C     *LIKE         DEFINE    KYKOPG        BLANKPRGR
     C     *LIKE         DEFINE    KYKOKG        DSKUNDKDLG
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    RTKONDFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  AUFBEREITEN DER NACHRICHTEN                                       ***
     C**************************************************************************
     C     AUMSG         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFEAT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        W$PA03          + 9
     C     *LIKE         DEFINE    WKC001        W$PA04          + 9
     C     *LIKE         DEFINE    WKC001        W$PA05          + 9
     C     *LIKE         DEFINE    WKC001        W$PA06          + 9
     C     *LIKE         DEFINE    WKC001        W$PA07          + 9
     C     *LIKE         DEFINE    WKC001        W$PA08          + 9
     C*-------------------------------------------------------------------------
     C                   CALL      'TRFEHLCL'
     C                   PARM                    WKFENR
     C                   PARM                    KEYVAR
     C                   PARM                    DSJNAM
     C                   PARM                    DSUSER
     C                   PARM                    W$PA03
     C                   PARM                    W$PA04
     C                   PARM                    W$PA05
     C                   PARM                    W$PA06
     C                   PARM                    W$PA07
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'WAO015'      PGMNAM
     C                   MOVE      *ON           C#INIT
     C*--------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTKONDW2
     C                   OTHER
     C                   WRITE     WAO015CT
     C                   ENDSL
     C*--------------------------------------------------------
     C                   MOVE      *OFF          C#INIT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C     WKIFMT        WHENEQ    'M1'
     C                   WRITE     CTKONDW2
     C                   OTHER
     C                   WRITE     WAO015CT
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        W$PA03
     C                   MOVE      *BLANK        W$PA04
     C                   MOVE      *BLANK        W$PA05
     C                   MOVE      *BLANK        W$PA06
     C                   MOVE      *BLANK        W$PA07
     C                   MOVE      *BLANK        W$PA08
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHKBST
     C/COPY QCPYSRC,CHKOND
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,MCTRTK
     C/COPY QCPYSRC,MCTRTP
     C/COPY QCPYSRC,MCKUND
     C/COPY QCPYSRC,MCWACD
     C/COPY QCPYSRC,PRFIRMFIRM
     C/COPY QCPYSRC,PRWACDWACD
     C/COPY QCPYSRC,RDTRDNTRDN
     C/COPY QCPYSRC,PRFUKT
     C/COPY QCPYSRC,TRIFMT
     C/COPY QCPYSRC,UMUEBE
     C/COPY QCPYSRC,UMUEBEJV
     C/COPY QCPYSRC,EXFLPO
     C/COPY QCPYSRC,VINFO
     C/COPY QCPYSRC,EXJOBA
     C/COPY QCPYSRC,EXUX08
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,TRSBFL
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
