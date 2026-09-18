     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE        Ermitteln der zu Druckenden Rechnungen
     H********************************************************************
     H*  Copyright 1994 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Ziegelhofstraße 210a
     H*                       DE 79110 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellung am: 04.07.1994 durch: Gaire
     H*  --------------------------------------------------------------
     H*  Änderung am: GD 03.02.2003 Änderung Zugriff AFLK
     H*  Änderung: SC 05.12.2003 Anpassung neues TZA
     H*  Änderung: SC 16.12.2003 weitere Anpassung neues TZA
     H*  Änderung: ZG 13.09.2004 Projekt Busch Anpassung der TZA-Aufrufe
     H*  Änderung: SC 18.07.2007 weitere Anpassung neues TZA
/*  ÄH*  Änderung: PH 23.07.2007 Projekt 2582 Integration neuer Print-Server
     H*            Anpassung Druck Rechnung
/*  ÄH*  Änderung: PH 25.07.2007 Projekt 2582 Integration neuer Print-Server
     H*            Anpassung Druck Sammel-Rechnung
/*  ÄH*  Änderung: PH 27.07.2007 Projekt 2582 Integration neuer Print-Server
     H*            Anpassung Aufruf Druck Rechnungen TZA. Aufruf DRTZ41SB
     H*            durch DRAFRK03 ersetzt.
     H*  Änderung  PH 26.04.2009 BUSCH Projekt 5779 Integration Aufruf Sammelrechnung
     H*            TZA für die XML-Ausgabe über den Dokumentengenerator (neuen Printserver)
     H*  Änderung: MG 26.11.2009 Kz. SBMJOB bei Einzelrechnung
     H*  Änderung: ZG 30.11.2009 Kz. Druckwiederholung wurde integriert.
     H*            Burton Service#: 20091125-008
     H*  Änderung: ZG 05.07.2010 Druckwiederholung XML
     H*  Änderung: ZG 12.07.2010 Druckwiederholung XML - Reihenfolge
     H*  Änderung: RE 09.11.2010 VIACOR Service 20101014-010
     H*  Änderung: ZG 27.03.2019
     F********************************************************************
     F*/
     D********************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N            ***
     D********************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D W99             S              1    DIM(99)                              WORK-FELDGRP.
     D*
     D********************************************************************
     D***     DATEIEN                                                  ***
     D********************************************************************
     D TRUE          E DS
     D KYTRUE        E DS
     D*
     D AFPA          E DS
     D KYAFPA        E DS
     D*
     D AFLK          E DS
     D KYAFLK        E DS
     D*
     D AFLP          E DS
     D KYAFLP        E DS
     D*
     D ZLLF          E DS
     D KYZLLF        E DS
     D*
     D AFKO          E DS                  INZ
     D KYAFKO        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D********************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                  ***
     D********************************************************************
     D EXTR01        E DS
     D EXTR02        E DS
     D EXTR05        E DS
     D*
     D EXAFRK01      E DS                  INZ
     D*
     D EXAFRK02      E DS                  INZ
     D E1XLST        E DS
     D E$XLST        E DS                  EXTNAME(E1XLST) PREFIX(E$:2)
     D*
     D EXZLLF01      E DS                  INZ
     D*
     D EXXPRT        E DS                  INZ
     D RTXPRT        E DS                  INZ
     D*
     D********************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                              ***
     D********************************************************************
     D EXTRLD        EUDS
     D  DAVRGJ               201    204  0
     D  DAVRGN               205    210  0
     D*
     D  DABRGJ               211    214  0
     D  DABRGN               215    220  0
     D*
     D  DABEAR               845    845
     D  DACDAT               846    846
     D  DACDNR               847    856
     D  DACDTX               857    886
     D  EXTRLDSPCD          1024   1024
     D*
     D********************************************************************
     D***     INTERNE DATENSTRUKTUR                                    ***
     D********************************************************************
     D INDAST          DS
     D  DUN040                 1      4  0
     D  DUC004                 1      4
     D*
     D  DUN080                11     18  0
     D  DUC008                11     18
     D*
     D  DUN060                21     26  0
     D  DUC006                21     26
     C********************************************************************
     C***     R E C H E N B E S T I M M U N G E N                      ***
     C********************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXTR05
     C                   PARM                    E1XLST
     C*
      /FREE
        E$XLST = E1XLST;
      /END-FREE
     C*
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    DSFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         BENUTZER    /36
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMER
     C     *LIKE         DEFINE    AKAFJJ        WKAFJJ                         FÜR DRUCKERERMITTL.
     C     *LIKE         DEFINE    AKAFNR        WKAFNR
     C*-------------------------------------------------------------------
     C                   EXSR      ANFANG
     C     *INLR         CABEQ     '1'           ENDE
     C********************************************************************
     C***     F O R M A T S T E U E R U N G                           ****
     C********************************************************************
     C     START         TAG
     C*
     C*-------------------------------------------------------------------
     C                   EXSR      VAFLK
     C                   EXSR      VZLLF
     C*-------------------------------------------------------------------
     C     ENDE          TAG
     C*
     C                   MOVE      '1'           *INLR
     C********************************************************************
     C***                                                              ***
     C***  SR-ANFANG    ERÖFFNUNGSZYKLUS                               ***
     C***                                                              ***
     C********************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      '0'           *IN
     C*-------------------------------------------------------------------
     C                   MOVEL     *ZERO         #CDATN                         DATUMSFELDER
     C                   MOVEL     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   MOVEL     *ZERO         #CFMTN
     C                   MOVEL     *ZERO         #CFMTV
     C                   MOVEL     *ZERO         #CDAKW
     C                   MOVEL     *ZERO         #CDAJJ
     C                   MOVEL     *ZERO         #CMCAZ
     C                   MOVEL     *ZERO         DSJDAT
     C                   MOVEL     *ZERO         DSJZEI
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        DSFIRM
     C                   MOVEL     DAFIRM        DSFIRM                         *LDA-FELDER
     C*-------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYKLFI                         AFLK
     C                   MOVEL     DAFIRM        KYALFI                         AFLP
     C                   MOVEL     DAFIRM        KYZLLFFIRM                     ZLLF
     C                   MOVEL     DAFIRM        KYAAFI                         AFPA
     C                   MOVEL     DAFIRM        KYAKFI                         AFKO
     C                   MOVEL     DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C*-------------------------------------------------------------------
     C                   MOVEL     DAPROG        WKCHPN                         PROGR.      /36
     C                   MOVEL     DABIBL        WKCHPL                         BIBL.       /36
     C                   MOVEL     DAUSER        WKUSER
     C*-------------------------------------------------------------------
     C                   MOVEL     *BLANK        DAFEHL
     C                   MOVEL     *BLANK        ##RTCD
     C*-------------------------------------------------------------------
     C                   MOVEL     EXTR05        WKTR04          140
     C                   MOVE      *OFF          WKTRPAPREM        1
     C*-------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN CODE
     C                   MOVEL     'MAIL'        KYTATC                         FÜR MAIL- UND
     C                   MOVEL     'MLDR'        KYTAPA                         DRUCKAUSGABE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL     TAPCDE        WKTRPAMLDR        1
     C*-------------------------------------------------------------------------
     C                   MOVEL     'FIRM'        KYTATA                         ERMITTELN CODE
     C                   MOVEL     'FAX     '    KYTATC                         FÜR FAX- UND
     C                   MOVEL     'FXDR    '    KYTAPA                         DRUCKAUSGABE
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C     CHI(05)       IFEQ      'J'
     C                   MOVEL     TAPCDE        WKTRPAFXDR        1
     C                   ELSE
     C                   MOVEL     *BLANK        WKTRPAFXDR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-VAFLK   ALLE LIEFERUNGEN AB RECHNUNGSNUMMER              ***
     C***                                                              ***
     C********************************************************************
     C     VAFLK         BEGSR
     C*
     C*----------------------------------------------------
     C     *LIKE         DEFINE    KLRGJJ        WKRGJJ
     C     *LIKE         DEFINE    KLRGNR        WKRGNR
     C                   MOVE      *BLANK        WKRGNR
     C                   MOVE      *ZERO         WKRGJJ
     C*-------------------------------------------------------------------
     C                   MOVE      DAFIRM        KYKLFI                         VORBEREITEN
     C                   MOVE      DABRGJ        KYKLRJ                         SCHLÜSSEL-
     C                   MOVE      DABRGN        KYKLRN                         FELDER
     C                   MOVE      *HIVAL        KYKLJH
     C                   MOVE      *HIVAL        KYKLLN
     C*
     C                   MOVEA     '13-     '    CHI
     C                   EXSR      CHAFLK
     C*-------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------
     C     KLFIRM        IFNE      KYKLFI                                       OBERGRENZE
     C     KLRGJJ        ORLT      DAVRGJ                                       ÜBERSCHRITTEN
     C     KLRGNN        ORLT      DAVRGN
     C     KLRGJJ        ANDEQ     DAVRGJ                                       ÜBERSCHRITTEN
     C                   LEAVE
     C                   END
     C*-------------------------------------------------------------------
     C     KLRGJJ        IFNE      *ZERO
     C     KLRGNR        ANDNE     *BLANK
     C*-------------------------------------------------------------------
     C                   MOVEL     KLAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*-------------------------------------------------------------------
     C     KLRGNR        IFNE      WKRGNR
     C     AALGKZ        ANDNE     DAJNKZ
     C     AARECH        ANDEQ     DAJNKZ
     C     KLRGJJ        ORNE      WKRGJJ
     C     AALGKZ        ANDNE     DAJNKZ
     C     AARECH        ANDEQ     DAJNKZ
     C                   Z-ADD     KLRGJJ        WKRGJJ
     C                   MOVEL(P)  KLRGNR        WKRGNR
     C*----------------------------------------------------
     C                   MOVEL     KLFIRM        KYALFI                         ERMITTELN
     C                   MOVEL     KLLIJJ        KYALLJ                         RECHNUNGSDATUM
     C                   MOVEL     KLLINR        KYALLI
     C                   Z-ADD     *ZERO         KYALLP
     C                   MOVEA     '05+     '    CHI
     C                   EXSR      CHAFLP
     C*
     C     ALFIRM        IFEQ      KYALFI                                       OBERGRENZE
     C     ALLIJJ        ANDEQ     KYALLJ
     C     ALLINR        ANDEQ     KYALLI
     C     ALLINR        ANDEQ     KYALLI
     C     ALRGJJ        ANDEQ     WKRGJJ
     C     ALRGNR        ANDEQ     WKRGNR
     C     WKFENR        ANDEQ     *ZERO
     C*
     C     ALSARG        CASEQ     *BLANK        DRUCK                          EINZELRECHNUNG
     C                   ENDCS
     C                   ENDIF
     C*----------------------------------------------------
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVEA     '13P     '    CHI
     C                   EXSR      CHAFLK
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-VZLLF   ALLE LIEFERUNGEN AB RECHNUNGSNUMMER TZA          ***
     C***                                                              ***
     C********************************************************************
     C     VZLLF         BEGSR
     C*
     C                   MOVE      *BLANK        WKRGNR
     C*-------------------------------------------------------------------
     C                   MOVE      DAFIRM        KYZLLFFIRM                     VORBEREITEN
     C                   MOVE      DAVRGJ        KYZLLFRGJJ                     SCHLÜSSEL-
     C                   MOVE      DAVRGN        KYZLLFRGNN                     FELDER
     C                   MOVE      *LOVAL        KYZLLFLIJJ
     C                   MOVE      *LOVAL        KYZLLFLINR
     C                   MOVE      *LOVAL        KYZLLFLIPO
     C*
     C                   MOVEA     '11+     '    CHI
     C                   EXSR      CHZLLF
     C*-------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------
     C     ZLLFFIRM      IFGT      KYKLFI                                       OBERGRENZE
     C     ZLLFRGJJ      ORGT      DABRGJ                                       ÜBERSCHRITTEN
     C     ZLLFRGNN      ORGT      DABRGN
     C                   LEAVE
     C                   END
     C*-------------------------------------------------------------------
     C     ZLLFZLST      IFLE      '39'
     C     ZLLFRGNN      OREQ      *ZERO
     C                   GOTO      VZLLFY
     C                   ENDIF
     C*-------------------------------------------------------------------
     C     ZLLFRGNR      IFNE      WKRGNR
     C                   MOVE      ZLLFRGNR      WKRGNR
     C*----------------------------------------------------
     C     ZLLFSARG      CASEQ     *BLANK        TRTZ43                         EINZELRECHNUNG
     C     ZLLFSARG      CASNE     *BLANK        TRTZ44                         SAMMELRECHNUNG
     C                   ENDCS
     C                   ENDIF
     C*-------------------------------------------------------------------
     C     VZLLFY        TAG
     C*
     C                   MOVEA     '11R     '    CHI
     C                   EXSR      CHZLLF
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-TRAB52  DRUCKEN RECHNUNG PRO LIEFERSCHEIN                ***
     C***                                                              ***
     C********************************************************************
     C     TRAB52        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   CLEAR                   EXAFRK01
     C                   Z-ADD     ALLIJJ        EXRK01LIJ1
     C                   MOVEL(P)  ALLINR        EXRK01LIN1
     C                   Z-ADD     ALRGJJ        EXRK01RGJ1
     C                   MOVEL(P)  ALRGNR        EXRK01RGN1
     C                   Z-ADD     ALREDA        EXRK01REDA
     C                   MOVEL(P)  DANEKZ        EXRK01DANZ
     C                   MOVE      *OFF          EXRK01DRSD                     NUR DRUCKEN
     C                   MOVEL(P)  DANEKZ        EXRK01SBMJ                     NICHT IM BATCH
     C                   MOVEL(P)  *ON           EXRK01DRWD
     C*
     C                   CALL      'DRAFRK01'
     C                   PARM                    EXAFRK01
     C                   PARM                    E1XLST
     C                   PARM                    EXTR05
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-TRAB55  DRUCKEN SAMMELRECHNUNG                           ***
     C***                             E                                ***
     C********************************************************************
     C     TRAB55        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   CLEAR                   EXAFRK02
     C*
     C                   Z-ADD     ALRGJJ        EXRK02RGJJ                     RECHNUNGSJAHR
     C                   MOVEL(P)  ALRGNR        EXRK02RGNR                     RECHNUNGSNUMMER
     C                   Z-ADD     ALREDA        EXRK02RED1                     RECHNUNGSDATUM
     C                   MOVEL(P)  DANEKZ        EXRK02SBKZ
     C*
     C                   MOVE      *OFF          EXRK02DRSD                     NUR DRUCKEN
     C                   MOVEL(P)  DANEKZ        EXRK02DANZ
     C                   MOVEL(P)  DANEKZ        EXRK02SBMJ                     NICHT IM BATCH
     C                   MOVEL(P)  DAJNKZ        EXRK02DRWH
     C                   CALL      'DRAFRK02'
     C                   PARM                    EXAFRK02
     C                   PARM                    E1XLST
     C                   PARM                    EXTR05
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-TRTZ43    DRUCKEN EINZELRECHNUNG  TZA                    ***
     C***                                                              ***
     C********************************************************************
     C     TRTZ43        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   CLEAR                   EXZLLF01
     C                   MOVE      ZLLFRGJJ      DUN040
     C                   MOVE      DUC004        EXZL01RGJJ
     C                   MOVE      ZLLFRGNR      EXZL01RGNR
     C*
     C                   MOVEL(P)  DANEKZ        EXZL01DANZ
     C                   MOVEL(P)  DANEKZ        EXZL01SBMJ
     C                   CALL      'DRAFRK03'
     C                   PARM                    EXZLLF01
     C                   PARM                    E1XLST
     C                   PARM                    WKTR04
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-TRTZ44    AUFRUF DRUCKPROGRAMM SAMMELRECHNUNG TZA        ***
     C***                                                              ***
     C********************************************************************
     C     TRTZ44        BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   CLEAR                   EXZLLF01
     C                   MOVE      ZLLFRGJJ      DUN040
     C                   MOVE      DUC004        EXZL01RGJJ
     C                   MOVE      ZLLFRGNR      EXZL01RGNR
     C*
     C                   MOVEL(P)  DANEKZ        EXZL01DANZ
     C                   MOVEL(P)  DANEKZ        EXZL01SBMJ
     C                   CALL      'DRAFRK04'
     C                   PARM                    EXZLLF01
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-DRUCK   ALLE LIEFERUNGEN MIT STATUS = 35
     C***                                                              ***
     C********************************************************************
     C     DRUCK         BEGSR
     C*
     C*-------------------------------------------------------------------
     C                   Z-ADD     ALAFJJ        WKAFJJ
     C                   MOVEL     ALAFNR        WKAFNR
     C                   EXSR      ERVERG
     C*
     C                   CLEAR                   EXAFRK01
     C                   Z-ADD     ALLIJJ        EXRK01LIJ1
     c                   MOVEL(P)  ALLINR        EXRK01LIN1
     C                   Z-ADD     ALRGJJ        EXRK01RGJ1
     C                   MOVEL     ALRGNR        EXRK01RGN1
     C                   Z-ADD     ALPOJJ        EXRK01POJ1
     C                   MOVEL     ALPONR        EXRK01PON1
     C                   MOVEL     DANEKZ        EXRK01PROB
     C                   MOVEL     WKTRPAPREM    EXRK01PREM
     C                   MOVE      ALREDA        EXRK01REDA
     C                   MOVEL(P)  *ON           EXRK01DRWD
     C                   CALL      'XLAFRK01CL'
     C                   PARM                    EXAFRK01
     C                   PARM                    E1XLST
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-ERVERG                                                        ***
     C**************************************************************************
     C     ERVERG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKAFJJ        KYAKJH
     C                   MOVEL     WKAFNR        KYAKAF                         Erm.
     C                   MOVEA     '01C     '    CHI                            KD-Steuerungs-Code
     C                   EXSR      CHAFKO
     C*
     C     KDKDNR        IFNE      AKRAKD
     C     AKVERG        ANDNE     'D'
     C                   MOVEL(P)  AKRAKD        KYKDNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHKUND
     C                   ENDIF
     C*
     C     AKVERG        IFEQ      WKTRPAMLDR
     C     WKTRPAMLDR    ANDNE     *BLANK
     C                   MOVEL(P)  'M'           AKVERG
     C                   ENDIF
     C     AKVERG        IFEQ      'Y'
     C                   MOVEL(P)  'M'           AKVERG
     C                   ENDIF
     C*
     C                   SELECT
     C     AKVERG        WHENEQ    'M'
     C     AKVERG        OREQ      WKTRPAMLDR
     C     WKTRPAMLDR    ANDNE     *BLANK
     C     AKVERG        OREQ      'F'
     C     AKVERG        OREQ      WKTRPAFXDR
     C     WKTRPAFXDR    ANDNE     *BLANK
     C                   MOVEL(P)  AKVERG        DABEAR
     C                   MOVE      'R'           DACDAT
     C                   MOVEL(P)  AKRAKD        DACDNR
     C                   MOVEL(P)  KDKNAM        DACDTX
     C                   MOVEL     KDSPCD        EXTRLDSPCD
     C                   OTHER
     C                   MOVE      *BLANK        DABEAR
     C                   MOVE      *BLANK        DACDAT
     C                   MOVE      *BLANK        DACDNR
     C                   MOVE      *BLANK        DACDTX
     C                   MOVE      *BLANK        EXTRLDSPCD
     C                   ENDSL
     C*
     C                   OUT       EXTRLD
     C*
     C                   SELECT
     C     AKVERG        WHENEQ    'M'
     C     AKVERG        OREQ      WKTRPAMLDR
     C     WKTRPAMLDR    ANDNE     *BLANK
     C     AKVERG        OREQ      'F'
     C     AKVERG        OREQ      WKTRPAFXDR
     C     WKTRPAFXDR    ANDNE     *BLANK
     C                   CLEAR                   E1XLST
     C                   MOVEL     'XLAFRK01'    E1XLSTPGNA
     C                   MOVEL     DANEKZ        E1XLSTDANZ
     C                   MOVEL     AKVERG        E1XLSTVEAR
     C                   MOVEL     AKWKNR        E1XLSTWKNR
     C                   MOVEL     AKAFAT        E1XLSTAFAT
     C                   MOVEL     AKABTL        E1XLSTABTL
     C                   MOVEL     *ON           E1XLSTRLPR
     C                   CALL      'T1XLST'
     C                   PARM                    E1XLST
     C*
     C                   CLEAR                   EXXPRT
     C                   MOVEL     'PRXPRT'      EXXPRTPGST                     NEUANLAGE
     C                   MOVEL     DASPCD        EXXPRTSPCD
     C                   MOVEL     E1XLSTTSTP    EXXPRTTSTP
     C                   MOVEL     'MAILTO  '    EXXPRTUCDE
     C                   CALL      'TRXPRT'
     C                   PARM                    EXXPRT
     C                   PARM                    RTXPRT
     C*
     C                   IN        EXTRLD
     C     DAFEHL        IFEQ      'N'
     C     RTXPRTFENR    ORNE      *ZERO
     C     AKVERG        ANDEQ     'M'
     C     RTXPRTFENR    ORNE      *ZERO
     C     AKVERG        ANDEQ     WKTRPAMLDR
     C     WKTRPAMLDR    ANDNE     *BLANK
      /FREE
        E1XLST = E$XLST;
      /END-FREE
     C                   ENDIF
     C*
     C                   OTHER
      /FREE
        E1XLST = E$XLST;
      /END-FREE
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*       A U F R U F - M O D U L E                                        *
     C**************************************************************************
     C/COPY QCPYSRC,CHAFLK
     C/COPY QCPYSRC,CHAFLP
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHZLLF
     C/COPY QCPYSRC,CHAFKO
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     C********************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O********************************************************************
