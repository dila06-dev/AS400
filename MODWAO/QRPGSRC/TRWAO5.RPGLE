     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H COPYRIGHT('(C) Copyright trend SWM Verwaltungs GmbH - 2010')
     H**************************************************************************
     H/TITLE Umbuchen der aus dem QS-System rückgemeldten WE- bzw. Prod-Bestande bzw.
     H/TITLE Bestände aus dem LG-Zugang WE vom QS-Lager auf das Warenbestandslager
     H**************************************************************************
     H*  Copyright 2010 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellt: PH 11.02.2010 Projekt 5309 für Kunde WAECO
     H*  -----------------------------------------------------------------------
     H*  Änderung: PH 19.10.2011 Projekt 7534 für Kunde DOMETIC. Programmerweiterung
     H*            um die Steuerung für Produktionsartikel
     H*  Änderung: PH 11.01.2013 Projekt 8790 für Kunde DOMETIC. Programmerweiterung
     H*            um die Steuerung für Artikel aus dem Lager-Zugang WE
     H*  Änderung: PH 11.11.2015 DOMETIC Projekt 11427. Integration Erstellen IFBL-Satz
     H*            (Übergabe an LFS) nach erfolgter Lager-Buchung
     F**************************************************************************
     F*  Das Programm liest die Datei WAO4 mit Rückmelde-Daten des QS-Systems PDAP7,
     F*  und bucht die WE- bzw. Prod-Bestände bzw. Bestände aus dem LG-Zugang WE
     F*  vom QS-Lager auf das Warenbestandslager um.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FWAO4      IF A E           K DISK
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D*
     D BBEU          E DS                  INZ
     D KYBBEU        E DS                  INZ

     D IFBL          E DS                  INZ
     D*
     D LBLB          E DS                  INZ
     D KYLBLB        E DS                  INZ

     D LGKO          E DS                  INZ
     D KYLGKO        E DS                  INZ
     D*
     D LGWE          E DS                  INZ
     D KYLGWE        E DS                  INZ
     D*
     D PARK          E DS                  INZ
     D KYPARK        E DS                  INZ
     D*
     D PAUM          E DS                  INZ
     D KYPAUM        E DS                  INZ

     D SYTP          E DS                  INZ
     D KYSYTP        E DS                  INZ
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
     D TRPC          E DS                  INZ
     D KYTRPC        E DS                  INZ
     D*
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D*
     D EXDATA        E DS                  INZ
     D RTDATA        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
     D*
     D EXLBRS        E DS                  INZ
     D RTLBRS        E DS                  INZ
     D*
     D EXTREND       E DS                  INZ
     D RTTREND       E DS                  INZ
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
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASNE     *ON           ETRPA
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF
     C*-------------------------------------------------------------------------
     C                   EXSR      VWAO4
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
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
     C                   MOVEL(P)  DAFIRM        WKFIRM
     C                   MOVEL(P)  EXPSDSPROC    WKCHPN
     C                   MOVEL(P)  EXPSDSBIBL    WKCHPL
     C                   MOVEL(P)  EXPSDSUSER    WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYAEFI                         BWAE
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
     C                   MOVEL(P)  DAFIRM        KYTEFI                         TEIL
     C                   MOVEL(P)  DAFIRM        KYTUFI                         TEUF
     C                   MOVEL(P)  DAFIRM        KYLBLBFIRM                     LBLB
     C                   MOVEL(P)  DAFIRM        KYLGKOFIRM                     LGKO
     C                   MOVEL(P)  DAFIRM        KYLGWEFIRM                     LGWE
     C                   MOVEL(P)  DAFIRM        KYRKFI                         PARK
     C                   MOVEL(P)  DAFIRM        KYUMFI                         PAUM
     C                   MOVEL(P)  DAFIRM        KYEUFI                         BBEU
     C                   MOVEL(P)  DAFIRM        KYEPFI                         BBEP
     C                   MOVEL(P)  DAFIRM        KYAAFI                         AFPA
     C                   MOVEL(P)  DAFIRM        KYAPFI                         AFPO
     C                   MOVEL(P)  DAFIRM        KYSYTPFIRM                     SYTP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  DAFIRM        KYTPFI                         TRTP
     C                   MOVEL(P)  DASPCD        KYTPSP                         TRTP
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VORLAUF                                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN WAO4                                                  ***
     C**************************************************************************
     C     VWAO4         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN98
     C                   MOVE      *OFF          *IN99
     C*-------------------------------------------------------------------------
     C     *IN99         DOWEQ     *OFF
     C                   READ(N)   WAO41                                9899
     C*
     C     *IN98         IFEQ      *ON
     C     *IN99         OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WAO4LFNR      IFEQ      *BLANK
     C                   IF        %SUBST(WAO4WENR: 11: 20) = *BLANK
     C                   EXSR      VPARK
     C                   ELSE
     C                   EXSR      VLGWE
     C                   ENDIF
     C                   ELSE
     C                   EXSR      VBWAE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DER VON PDAP7 ZURÜCKGEMELDETEN PRODUKTIONS-BESTÄNDE   ***
     C**************************************************************************
     C     VPARK         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO4WENR      DUC004
     C                   TESTN                   DUC004               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        WKWEJJ
     C                   EVAL      WKWENR  = %SUBST(WAO4WENR: 5: 6)
     C*
     C                   MOVE      WAO4BENR      DUC004
     C                   TESTN                   DUC004               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        WKPARKUPOS
     C*
     C                   MOVEL(P)  WAO4EZNR      WKTENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKWEJJ        KYRKJH
     C                   MOVEL(P)  WKWENR        KYRKPP
     C                   Z-ADD     WKPARKUPOS    KYRKUP
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPARK
     C*
     C                   MOVE      RKTMST        KYLBLBTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBLB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        KOM
     C*
     C                   MOVEL(P)  'ULBLB '      #CPGST                         ABGANGSBUCHUNG
     C                   MOVEL(P)  'BUCHEN'      EXLBPGST
     C*--------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL(P)  DAFIRM        EXLBFIRM
     C                   MOVEL(P)  WKTRPALSTC    EXLBLSTC
     C                   MOVEL(P)  LBLBLANR      EXLBLANR
     C                   MOVEL(P)  LBLBLORT      EXLBLORT
     C                   MOVEL(P)  LBLBTENR      EXLBTENR
     C                   MOVEL(P)  LBLBCHAR      EXLBCHAR
     C*--------------------------------------------------------
     C                   Z-ADD     WAO4WEMG      EXLBBWMG
     C                   MOVEL(P)  LBLBBWME      EXLBBWME
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        EXLBBZEI
     C                   MOVE      WKTDAT        EXLBBDAT
     C*
     C                   MOVEL(P)  'PARK      '  EXLBDANA
     C                   Z-ADD     WKWEJJ        EXLBAFJJ
     C                   MOVEL(P)  WKWENR        EXLBAFNR
     C                   Z-ADD     WKPARKUPOS    EXLBAFPO
     C                   Z-ADD     *ZERO         EXLBAFUP
     C*
     C                   MOVEL(P)  WKTRPAZULP    EXLBULNR
     C                   MOVEL(P)  WKTRPAZLOP    EXLBUORT
     C*
     C                   MOVEL(P)  DAJNKZ        EXLBRSKZ
     C                   MOVEL(P)  DANEKZ        EXLBLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C     RTLBFENR      IFNE      *ZERO                                        FEHLER
     C     #CPGST        ANDEQ     'ULBLB '                                     INTERAKTIVES
     C*                  MOVE      'BUCHEN'      #CPGST                         BUCHEN
     C*                  CALL      'TRLBLB  '
     C*                  PARM                    EXTR02
     C*                  PARM                    EXLBLB
     C*                  PARM                    RTLBLB
     C                   ENDIF
     C*
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C*
     C                   IF        WKFENR = *ZERO
     C                   EVAL      WKIFBLDANA = 'PARK'
     C                   EVAL      WKIFBLJAHR = RKPPJJ
     C                   EVAL      WKIFBLNMKR = RKPPNR
     C                   EVAL      WKIFBLPOSI = RKUPOS
     C                   EVAL      WKIFBLUPOS = *ZERO
     C                   EVAL      WKIFBLWKNR = RKWKNR
     C                   EXSR      MOIFBL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DER VON PDAP7 ZURÜCKGEMELDETEN LG-ZUGANG WE-BESTÄNDE  ***
     C**************************************************************************
     C     VLGWE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO4WENR      DUC004
     C                   TESTN                   DUC004               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        WKWEJJ
     C                   EVAL      WKWENR = %SUBST(WAO4WENR: 5: 6)
     C                   EVAL      DUC005 = %SUBST(WAO4WENR: 11: 5)
     C                   TESTN                   DUC005               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        WKLGPO
     C                   EVAL      DUC005 = %SUBST(WAO4WENR: 16: 5)
     C                   TESTN                   DUC005               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC005                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN050        WKLGWEUPOS
     C*
     C                   MOVEL(P)  WAO4EZNR      WKTENR
     C*-------------------------------------------------------------------------
     C                   EVAL      KYLGKOLGJJ = WKWEJJ
     C                   EVAL      KYLGKOLGNR = WKWENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGKO
     C*
     C                   Z-ADD     WKWEJJ        KYLGWELGJJ
     C                   MOVEL(P)  WKWENR        KYLGWELGNR
     C                   Z-ADD     WKLGPO        KYLGWELGPO
     C                   Z-ADD     WKLGWEUPOS    KYLGWEUPOS
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLGWE
     C*
     C                   MOVE      LGWELBTM      KYLBLBTMST
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBLB
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        KOM
     C*
     C                   MOVEL(P)  'ULBLB '      #CPGST                         ABGANGSBUCHUNG
     C                   MOVEL(P)  'BUCHEN'      EXLBPGST
     C*--------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL(P)  DAFIRM        EXLBFIRM
     C                   MOVEL(P)  WKTRPALSTC    EXLBLSTC
     C                   MOVEL(P)  LBLBLANR      EXLBLANR
     C                   MOVEL(P)  LBLBLORT      EXLBLORT
     C                   MOVEL(P)  LBLBTENR      EXLBTENR
     C                   MOVEL(P)  LBLBCHAR      EXLBCHAR
     C*--------------------------------------------------------
     C                   Z-ADD     WAO4WEMG      EXLBBWMG
     C                   MOVEL(P)  LBLBBWME      EXLBBWME
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        EXLBBZEI
     C                   MOVE      WKTDAT        EXLBBDAT
     C*
     C                   MOVEL(P)  'LGWE      '  EXLBDANA
     C                   Z-ADD     WKWEJJ        EXLBAFJJ
     C                   MOVEL(P)  WKWENR        EXLBAFNR
     C                   Z-ADD     WKLGPO        EXLBAFPO
     C                   Z-ADD     WKLGWEUPOS    EXLBAFUP
     C*
     C                   MOVEL(P)  WKTRPAZULG    EXLBULNR
     C                   MOVEL(P)  WKTRPAZLOG    EXLBUORT
     C*
     C                   MOVEL(P)  DAJNKZ        EXLBRSKZ
     C                   MOVEL(P)  DANEKZ        EXLBLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C     RTLBFENR      IFNE      *ZERO                                        FEHLER
     C     #CPGST        ANDEQ     'ULBLB '                                     INTERAKTIVES
     C*                  MOVE      'BUCHEN'      #CPGST                         BUCHEN
     C*                  CALL      'TRLBLB  '
     C*                  PARM                    EXTR02
     C*                  PARM                    EXLBLB
     C*                  PARM                    RTLBLB
     C                   ENDIF
     C*
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C*
     C                   IF        WKFENR = *ZERO
     C                   EVAL      WKIFBLDANA = 'LGWE'
     C                   EVAL      WKIFBLJAHR = LGWELGJJ
     C                   EVAL      WKIFBLNMKR = LGWELGNR
     C                   EVAL      WKIFBLPOSI = LGWELGPO
     C                   EVAL      WKIFBLUPOS = LGWEUPOS
     C                   EVAL      WKIFBLWKNR = LGKOWKNR
     C                   EXSR      MOIFBL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DER VON PDAP7 ZURÜCKGEMELDETEN WE-BESTÄNDE            ***
     C**************************************************************************
     C     VBWAE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  WAO4WENR      DUC004
     C                   TESTN                   DUC004               97        PRÜFUNG
     C     *IN97         IFNE      *ON                                          AUF
     C                   MOVEL     *ZERO         DUC004                         NUMERISCHEN
     C                   ENDIF                                                  INHALT
     C                   Z-ADD     DUN040        WKWEJJ
     C                   EVAL      WKWENR  = %SUBST(WAO4WENR: 5: 6)
     C*
     C                   MOVEL(P)  WAO4EZNR      WKTENR
     C*-------------------------------------------------------------------------
     C                   Z-ADD     WKWEJJ        KYAEWJ
     C                   MOVEL(P)  WKWENR        KYAEWE
     C                   MOVEA     '07C     '    CHI
     C                   EXSR      CHBWAE
     C*
     C                   MOVEL(P)  AEBWLA        WKLANR
     C                   MOVEL(P)  AELORT        WKLORT
     C                   MOVEL(P)  AECHAR        WKCHAR
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C                   MOVE      *BLANK        KOM
     C*
     C                   MOVEL(P)  'ULBLB '      #CPGST                         ABGANGSBUCHUNG
     C                   MOVEL(P)  'BUCHEN'      EXLBPGST
     C*--------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL(P)  DAFIRM        EXLBFIRM
     C                   MOVEL(P)  WKTRPALSTC    EXLBLSTC
     C                   MOVEL(P)  WKLANR        EXLBLANR
     C                   MOVEL(P)  WKLORT        EXLBLORT
     C                   MOVEL(P)  WKTENR        EXLBTENR
     C                   MOVEL(P)  WKCHAR        EXLBCHAR
     C*--------------------------------------------------------
     C                   Z-ADD     WAO4WEMG      EXLBBWMG
     C                   MOVEL     AEMEIN        EXLBBWME
     C*
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        EXLBBZEI
     C                   MOVE      WKTDAT        EXLBBDAT
     C*
     C                   MOVEL(P)  'BWAE      '  EXLBDANA
     C                   Z-ADD     WKWEJJ        EXLBAFJJ
     C                   MOVEL(P)  WKWENR        EXLBAFNR
     C                   Z-ADD     *ZERO         EXLBAFPO
     C                   Z-ADD     *ZERO         EXLBAFUP
     C*
     C                   MOVEL(P)  WKTRPAZULA    EXLBULNR
     C                   IF        %SUBST(EXLBTENR:1:3) = '444'
     C                   MOVEL(P)  '400'         EXLBULNR
     C                   ENDIF
     C                   MOVEL(P)  WKTRPAZULO    EXLBUORT
     C*
     C                   MOVEL(P)  DAJNKZ        EXLBRSKZ
     C                   MOVEL(P)  DANEKZ        EXLBLBRS
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C     RTLBFENR      IFNE      *ZERO                                        FEHLER
     C     #CPGST        ANDEQ     'ULBLB '                                     INTERAKTIVES
     C*                  MOVE      'BUCHEN'      #CPGST                         BUCHEN
     C*                  CALL      'TRLBLB  '
     C*                  PARM                    EXTR02
     C*                  PARM                    EXLBLB
     C*                  PARM                    RTLBLB
     C                   ENDIF
     C*
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C*
     C                   IF        WKFENR = *ZERO
     C                   FOR       DO_X = 1 TO 1
     C                   EVAL      KYSYTPTART = 'BWLATRDIFS'                    Von der Übergabe in
     C                   EVAL      KYSYTPTCDE = EXLBULNR                        die LFS-
     C                   EVAL      KYSYTPTFLG = *ZERO                           Schnittstelle
     C                   EVAL      CHIDS = '01C'                                ausgeschlossene
     C                   EXSR      CHSYTP                                       WE-Lager
     C                   IF        CHI(5) = 'J'
     C                   LEAVE
     C                   ENDIF
     C*
     C                   IF        EXLBULNR <> WKLANR
     C                   EVAL      KYSYTPTART = 'VNWLTRDIFS'                    Für die LFS-
     C                   EVAL      KYSYTPTCDE = WKLANR + EXLBULNR               Schnittstelle
     C                   EVAL      KYSYTPTFLG = *ZERO                           relevante
     C                   EVAL      CHIDS = '01C'                                WE-Umbuchungen
     C                   EXSR      CHSYTP
     C                   IF        CHI(5) = 'N'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      WKIFBLDANA = 'BWAE'
     C                   EVAL      WKIFBLJAHR = AEWEJJ
     C                   EVAL      WKIFBLNMKR = AEWENR
     C                   EVAL      WKIFBLPOSI = *ZERO
     C                   EVAL      WKIFBLUPOS = *ZERO
     C                   EVAL      WKIFBLWKNR = AEWKNR
     C                   EXSR      MOIFBL
     C                   ENDFOR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKLANR        IFEQ      '500'
     C     WKLANR        OREQ      '510'
     C     WKTRPAZULA    IFNE      '500'
     C     WKTRPAZULA    ANDNE     '510'
     C                   EXSR      UBBEU
     C                   ENDIF
     C                   ENDIF
     C*
     C                   MOVEL(P)  'L     '      WKPGST
     C                   EXSR      MOBWAEWAO
     C                   MOVEL(P)  'U     '      WKPGST
     C                   EXSR      MOBWAEWAO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MOBWAEWAO  RÜFEN DIST                                             ***
     C**************************************************************************
     C     MOBWAEWAO     BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   CLEAR                   RTTREND
     C                   MOVEL     *ZERO         RTTRNDFENR
     C*
     C                   MOVE      *BLANK        KOM
     C                   Z-ADD     AEWEJJ        DUN040
     C                   MOVEA     DUC004        KOM(01)
     C                   MOVEA     AEWENR        KOM(05)
     C                   MOVEA     KOM(01)       EXTRNDKEYB
     C*
     C                   EVAL       EXTRNDDATE = BWAE + EXLBBEZ1 + EXLBBEZ2
     C                   MOVEL(P)  WKPGST        EXTRNDPGST
     C*
     C                   CALL      'MOBWAE'                             99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-UBBEU     UPDATEN DER AUFTRAGSZUORDNUNG                        ***
     C**************************************************************************
     C     UBBEU         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     AEBEJJ        KYEPJH                         LESEN
     C                   MOVEL(P)  AEBENR        KYEPBE                         BESTELLPOSITION
     C                   Z-ADD     AEBEPO        KYEPPO
     C*
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EPGLMG        W1GLMG                         MENGE
     C                   ADD       EPQSMG        W1GLMG
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EPBEJJ        KYEUJH                         SCHLÜSSEL
     C                   MOVEL(P)  EPBENR        KYEUBE
     C                   Z-ADD     EPBEPO        KYEUPO
     C                   Z-ADD     *LOVAL        KYEUUP
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01L     '    CHI
     C                   EXSR      CHBBEU
     C                   MOVEA     '01RU    '    CHI
     C                   EXSR      CHBBEU
     C*
     C     CHI(5)        DOWEQ     'J'
     C*-------------------------------------------------------------------------
     C     EUFIRM        IFNE      KYEUFI
     C     EUBEJJ        ORNE      KYEUJH
     C     EUBENR        ORNE      KYEUBE
     C     EUBEPO        ORNE      KYEUPO
     C                   MOVEA     '01F     '    CHI                            SATZ FREIGABEN
     C                   EXSR      CHBBEU
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   Z-ADD     EUGLMG        W3GLMG
     C*--------------------------------------------------------
     C     W1GLMG        IFGT      *ZERO
     C*-----------------------------------------
     C     EUZOMG        IFLT      W1GLMG
     C                   Z-ADD     EUZOMG        EUGLMG                         GEL.MENGE
     C                   SUB       EUGLMG        W1GLMG
     C                   ELSE
     C                   Z-ADD     W1GLMG        EUGLMG                         GEL.MENGE
     C                   SUB       EUGLMG        W1GLMG
     C                   END
     C*-----------------------------------------
     C                   ELSE                                                   GEL. MENGE
     C                   Z-ADD     *ZERO         EUGLMG                         LÖSCHEN
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBBEU
     C*--------------------------------------------------------
     C     EUVPKZ        IFEQ      'V'                                          RESERVIERUNG FÜR
     C     EUVPKZ        OREQ      'R'                                          KUNDEAUFTRAG ODER
     C     EUVPKZ        OREQ      'P'                                          PROJEKTAUFTRAG ODER
     C*                                                                         PROD.-AUFTRAG
     C                   SELECT
     C     EUGLMG        WHENGT    *ZERO                                        WEGEN EINLQGERUNG
     C                   EXSR      ERLBRS
     C                   ENDSL
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01RU    '    CHI                            LESEN
     C                   EXSR      CHBBEU                                       NÄCHSTER SATZ
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERLBRS ERSTELLEN RESERVIERUNGEN FÜR AUFTRAG / PROJEKT             ***
     C**************************************************************************
     C     ERLBRS        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EPTENR        KYTUTE                         BERECHNEN
     C                   MOVEL(P)  EPMEIN        KYTUME                         DER MENGEN IM
     C                   Z-ADD     EUGLMG        WKV1V2
     C                   SUB       W3GLMG        WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKGLMG
     C*
     C     WKGLMG        IFLE      *ZERO
     C                   LEAVESR
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   DO
     C*-------------------------------------------------------------------------
     C     EUVPKZ        IFEQ      'V'
     C                   Z-ADD     EUAFJJ        KYAPJH                         PRÜFEN DER
     C                   MOVEL(P)  EUAFNR        KYAPAF                         AUFTRAGSNUMMER
     C                   Z-ADD     EUAFPO        KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*
     C     APAFAT        IFNE      KYAAAT
     C                   MOVEL(P)  APAFAT        KYAAAT
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C                   ENDIF
     C*----------------------------------------------------------
     C     AABSFU        IFNE      DAJNKZ                                       BSTD-FÜHRUNG
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C     APAFST        IFEQ      '80'
     C                   MOVE      '00'          APAFST
     C                   ENDIF
     C*----------------------------------------------------------
     C     APAFST        IFGE      '20'
     C     AAKOMM        ANDEQ     DAJNKZ
     C     APAFST        ORGT      '20'
     C     AAKOMM        ANDNE     DAJNKZ
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL(P)  APTENR        KYTUTE                         BERECHNEN
     C                   MOVEL(P)  APMEIN        KYTUME                         DER MENGEN IM
     C     APBSMG        ADD       APNRMG        WKV1V2
     C                   SUB       APGLMG        WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKTEMG
     C*----------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     EUVPKZ        IFEQ      'P'
     C                   Z-ADD     EUAFJJ        KYUMJH                         PRÜFEN DER
     C                   MOVEL(P)  EUAFNR        KYUMPP                         PROD.-AUFTRAGSNR
     C                   Z-ADD     EUAFPO        KYUMPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAUM
     C*----------------------------------------------------------
     C     UMPPST        IFGE      '40'
     C     UMGSMG        ORGE      UMRMMG
     C     CHI(5)        OREQ      'N'
     C                   LEAVE
     C                   ENDIF
     C*----------------------------------------------------------
     C                   MOVEL(P)  UMKOTE        KYTUTE                         BERECHNEN
     C                   MOVEL(P)  UMMEIN        KYTUME                         DER MENGEN IM
     C                   Z-ADD     UMGSMG        WKV1V2
     C                   SUB       UMRMMG        WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKTEMG
     C*----------------------------------------------------------
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C                   MOVEL(P)  'ERES1 '      #CPGST
     C                   MOVEL(P)  EUFIRM        EXRSFIRM
     C                   SELECT
     C     EUVPKZ        WHENEQ    'V'
     C                   MOVEL(P)  'AFPO'        EXRSAFDN
     C                   Z-ADD     EUAFJJ        EXRSAFJJ
     C                   MOVEL(P)  EUAFNR        EXRSAFNR
     C                   Z-ADD     EUAFPO        EXRSAFPO
     C     EUVPKZ        WHENEQ    'R'
     C                   MOVEL(P)  'PRJP'        EXRSAFDN
     C                   Z-ADD     EUAFJJ        EXRSAFJJ
     C                   MOVEL(P)  EUAFNR        EXRSAFNR
     C                   Z-ADD     EUAFPO        EXRSAFPO
     C     EUVPKZ        WHENEQ    'P'
     C                   MOVEL(P)  'PAUM'        EXRSDANA
     C                   Z-ADD     EUAFJJ        EXRSJAHR
     C                   MOVEL(P)  EUAFNR        EXRSNMKR
     C                   Z-ADD     EUAFPO        EXRSPOSI
     C                   MOVEL(P)  'ERESB '      #CPGST
     C                   ENDSL
     C                   MOVEL(P)  EUTENR        EXRSTENR
     C                   CALL      'TRLBRS'                             99
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*
     C     WKTEMG        SUB       RTRSRMMG      WKTEMG
     C*
     C     WKTEMG        IFLE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*
     C     WKTEMG        IFGT      WKGLMG
     C                   Z-ADD     WKGLMG        WKTEMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEA     KOM           #CKOMM
     C                   CLEAR                   EXLBRS
     C                   CLEAR                   RTLBRS
     C*
     C                   MOVE      WKTMST        EXRSTMST
     C                   Z-ADD     WKTEMG        EXRSRSMG
     C*
     C                   MOVEL(P)  'BBEP'        EXRSDANA
     C                   Z-ADD     EUBEJJ        EXRSJAHR
     C                   MOVEL(P)  EUBENR        EXRSNMKR
     C                   Z-ADD     EUBEPO        EXRSPOSI
     C*
     C                   SELECT
     C     EUVPKZ        WHENEQ    'V'
     C                   MOVEL(P)  'AFPO'        EXRSAFDN
     C                   Z-ADD     EUAFJJ        EXRSAFJJ
     C                   MOVEL(P)  EUAFNR        EXRSAFNR
     C                   Z-ADD     EUAFPO        EXRSAFPO
     C     APAFST        IFEQ      '20'
     C                   MOVEL(P)  'AFKM'        EXRSDANA
     C                   Z-ADD     APKMJJ        EXRSJAHR
     C                   MOVEL(P)  APKMNR        EXRSNMKR
     C                   Z-ADD     APAFPO        EXRSPOSI
     C                   ENDIF
     C     EUVPKZ        WHENEQ    'R'
     C                   MOVEL(P)  'PRJP'        EXRSAFDN
     C                   Z-ADD     EUAFJJ        EXRSAFJJ
     C                   MOVEL(P)  EUAFNR        EXRSAFNR
     C                   Z-ADD     EUAFPO        EXRSAFPO
     C     EUVPKZ        WHENEQ    'P'
     C                   MOVEL(P)  'PAUM'        EXRSDANA
     C                   Z-ADD     EUAFJJ        EXRSJAHR
     C                   MOVEL(P)  EUAFNR        EXRSNMKR
     C                   Z-ADD     EUAFPO        EXRSPOSI
     C                   MOVEL(P)  'PAUM'        EXRSAFDN
     C                   Z-ADD     EUAFJJ        EXRSAFJJ
     C                   MOVEL(P)  EUAFNR        EXRSAFNR
     C                   Z-ADD     EUAFPO        EXRSAFPO
     C                   ENDSL
     C*
     C                   MOVEL(P)  'UPARK'       #CPGST
     C*
     C                   CALL      'TRLBRS'
     C                   PARM                    EXTR02
     C                   PARM                    EXLBRS
     C                   PARM                    RTLBRS
     C*---------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         WKFENR
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  MOIFBL        Erstellen IFBL-Satz für die Übergabe an LFS         ***
     C**************************************************************************
     C     MOIFBL        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXTREND
     C                   EVAL      %SUBST(EXTRNDKEYB:01) = WKIFBLDANA
     C                   EVAL      %SUBST(EXTRNDKEYB:11:04) =
     C                             %EDITC(WKIFBLJAHR:'X')
     C                   EVAL      %SUBST(EXTRNDKEYB:15) = WKIFBLNMKR
     C                   EVAL      %SUBST(EXTRNDKEYB:21:05) =
     C                             %EDITC(WKIFBLPOSI:'X')
     C                   EVAL      %SUBST(EXTRNDKEYB:26:05) =
     C                             %EDITC(WKIFBLUPOS:'X')
     C                   EVAL      %SUBST(EXTRNDDATE:01) = WKIFBLWKNR
     C                   EVAL      EXTRNDPGST = 'GNIFBL'
     C*
     C                   CALL      'MOIFBL'                             99
     C                   PARM                    EXTREND
     C                   PARM                    RTTREND
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'TRWAO5'      KYTATA                         ERMITTELN
     C                   MOVEL(P)  'LSTC'        KYTATC                         LAGER UMBUCHUNGS-
     C                   MOVEL(P)  'UMBUCHUNG'   KYTAPA                         SCHLÜSSEL
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPALSTC
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGER
     C                   MOVEL(P)  'ZULA'        KYTAPA                         (ZUGANGSLAGER)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAZULA
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGER
     C                   MOVEL(P)  'ZULP'        KYTAPA                         (ZUGANGSLAGER)
     C                   MOVEA     '01C     '    CHI                            FÜR PROD-ARTIKEL
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAZULP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGER
     C                   MOVEL(P)  'ZULG'        KYTAPA                         (ZUGANGSLAGER)
     C                   MOVEA     '01C     '    CHI                            FÜR ARTIKEL
     C                   EXSR      CHTRPA                                       AUS LG-ZUGANG WE
     C                   MOVEL(P)  TAPCDE        WKTRPAZULG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGERPLATZS-
     C                   MOVEL(P)  'ZULO'        KYTAPA                         (ZUGANGSLAGER-PLATZ)
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAZULO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGERPLATZS-
     C                   MOVEL(P)  'ZLOP'        KYTAPA                         (ZUGANGSLAGER-PLATZ)
     C                   MOVEA     '01C     '    CHI                            FÜR PROD-ARTIKEL
     C                   EXSR      CHTRPA
     C                   MOVEL(P)  TAPCDE        WKTRPAZLOP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  'FIRM'        KYTATA                         ERMITTELN
     C                   MOVEL(P)  'TRWAO5'      KYTATC                         NACH-LAGERPLATZ
     C                   MOVEL(P)  'ZLOG'        KYTAPA                         (ZUGANGSLAGER-PLATZ)
     C                   MOVEA     '01C     '    CHI                            FÜR ARTIKEL
     C                   EXSR      CHTRPA                                       AUS LG-ZUGANG WE
     C                   MOVEL(P)  TAPCDE        WKTRPAZLOG
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
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKC010          + 9
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C     *LIKE         DEFINE    WKN010        DO_X            + 6
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    DSUSER        WKUSER
     C     *LIKE         DEFINE    DSJDAT        WKJDAT
     C     *LIKE         DEFINE    DSJZEI        WKJZEI
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    EXTR02        SVTR02
     C*
     C     *LIKE         DEFINE    #CPGST        PCPGST
     C     *LIKE         DEFINE    #CPGST        WKPGST
     C     *LIKE         DEFINE    #CRTCD        PCRTCD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AEWEJJ        WKWEJJ
     C     *LIKE         DEFINE    AEWENR        WKWENR
     C     *LIKE         DEFINE    RKUPOS        WKPARKUPOS
     C     *LIKE         DEFINE    LGWELGPO      WKLGPO
     C     *LIKE         DEFINE    LGWEUPOS      WKLGWEUPOS
     C     *LIKE         DEFINE    IFBLDANA      WKIFBLDANA
     C     *LIKE         DEFINE    IFBLJAHR      WKIFBLJAHR
     C     *LIKE         DEFINE    IFBLNMKR      WKIFBLNMKR
     C     *LIKE         DEFINE    IFBLPOSI      WKIFBLPOSI
     C     *LIKE         DEFINE    IFBLUPOS      WKIFBLUPOS
     C     *LIKE         DEFINE    IFBLWKNR      WKIFBLWKNR
     C*
     C     *LIKE         DEFINE    AETENR        WKTENR
     C     *LIKE         DEFINE    AEBWLA        WKLANR
     C     *LIKE         DEFINE    AELORT        WKLORT
     C     *LIKE         DEFINE    AECHAR        WKCHAR
     C*
     C     *LIKE         DEFINE    EXLBTMST      WKTMST
     C     *LIKE         DEFINE    EXLBULNR      WKTRPAZULA
     C     *LIKE         DEFINE    EXLBULNR      WKTRPAZULP
     C     *LIKE         DEFINE    EXLBULNR      WKTRPAZULG
     C     *LIKE         DEFINE    EXLBUORT      WKTRPAZULO
     C     *LIKE         DEFINE    EXLBUORT      WKTRPAZLOP
     C     *LIKE         DEFINE    EXLBUORT      WKTRPAZLOG
     C     *LIKE         DEFINE    EXLBLSTC      WKTRPALSTC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AEBRMG        WKTEMG
     C*
     C     *LIKE         DEFINE    EPMENG        WKGLMG
     C     *LIKE         DEFINE    EPMENG        W1GLMG
     C     *LIKE         DEFINE    EPMENG        W3GLMG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHBWAE
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHBBEU
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHLGKO
     C/COPY QCPYSRC,CHLGWE
     C/COPY QCPYSRC,CHPARK
     C/COPY QCPYSRC,CHPAUM
     C/COPY QCPYSRC,CHSYTP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTEUF
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTRTP
     C/COPY QCPYSRC,PRTRPC
     C/COPY QCPYSRC,TRDATE
     C/COPY QCPYSRC,VTEUF
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
