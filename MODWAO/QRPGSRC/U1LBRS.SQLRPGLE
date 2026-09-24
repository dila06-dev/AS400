     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE Buchen LBRS
     H**************************************************************************
     H*  Copyright 2012 by    trend SWM
     H*                       Verwaltung GmbH
     H*                       Gundelfinger Straße 11
     H*                       DE 79108 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellt: ZG 22.03.2012 Projekt 7558
     H*  --------------------------------------------------------------
     H*
     D**************************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N                  ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D**************************************************************************
     D***     DATEIEN                                                        ***
     D**************************************************************************
     D LBRS          E DS                  INZ
     D KYLBRS        E DS                  INZ
     D*
     D AFPA          E DS                  INZ
     D KYAFPA        E DS                  INZ
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D/COPY QCPYSRC,EXTRDA
     D/COPY QCPYSRC,EXTRLB
     D**************************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                        ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR04        E DS                  INZ
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
     D*
     D**************************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                                    ***
     D**************************************************************************
     D EXTRLD        EUDS
     D  WKTDAT         S               D   DATFMT(*ISO) INZ
     C**************************************************************************
     C***     R E C H E N B E S T I M M U N G E N                            ***
     C**************************************************************************
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASEQ     *BLANK        ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C                   EXSR      OLBRS
     C                   EXSR      VLBRS
     C*-------------------------------------------------------------------------
     C                   MOVE      '1'           *INLR
     C*-------------------------------------------------------------------------
     C**************************************************************************
     C***  SR-ANFANG     ERÖFFNUNGSZYKLUS                                    ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        DSFIRM                         *LDA-FELDER
     C                   MOVE      DAPROG        WKCHPN                         PROGR
     C                   MOVE      DABIBL        WKCHPL                         BIBL.
     C                   MOVE      DAUSER        WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        KYAPFI
     C                   MOVE      DAFIRM        KYAAFI
     C                   MOVE      DAFIRM        KYTEFI
     C                   MOVE      DAFIRM        KYLBRSFIRM                     TEIL
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         WKBDAT
     C                   MOVEL     *ZERO         WKBZEI
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-UEBKOM     UEBERNAHME KOM-BEREICH                              ***
     C**************************************************************************
     C     UEBKOM        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFNEN DATEI  LBRS                                                ***
     C**************************************************************************
     C     OLBRS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE LBRSC1 CURSOR FOR
     C+ SELECT * FROM LBRS
     C+ WHERE  LBRSFIRM = :DAFIRM
     C+ AND    LBRSSTAT = '90'
     C+ AND    LBRSRMMG > 0
     C+ AND    LBRSLBTM =0
     C+ AND    LBRSAFDN ='AFPO  '
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+        OPEN LBRSC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN DATEI LBRS                                            ***
     C**************************************************************************
     C     VLBRS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*--------------------------------------------------------
     C/EXEC SQL
     C+ FETCH LBRSC1    INTO :LBRS
     C/END-EXEC
     C*--------------------------------------------------------
     C     SQLCOD        IFNE      *ZERO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  LBRSFIRM      KYAPFI
     C                   Z-ADD     LBRSAFJJ      KYAPJH
     C                   MOVEL(P)  LBRSAFNR      KYAPAF
     C                   Z-ADD     LBRSAFPO      KYAPPO
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPO
     C*
     C                   MOVEL(P)  LBRSFIRM      KYAAFI
     C                   MOVEL(P)  APAFAT        KYAAAT                         AUFTRAGSART
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHAFPA
     C*
     C                   MOVEL(P)  LBRSFIRM      KYTEFI
     C                   MOVEL     LBRSTENR      KYTENR
     C                   MOVE      *BLANK        KYTEEZ
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   EXSR      TRLBLB
     C*-------------------------------------------------------------------------
     C                   ENDDO                                                  SQLCOD DOWEQ *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+         CLOSE LBRSC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-TRLBLB     Storno                                              ***
     C**************************************************************************
     C     TRLBLB        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   CLEAR                   EXLBLB
     C*--------------------------------------------------------
     C                   MOVE      *BLANK        KOM
     C                   MOVEL     'ULBLB '      #CPGST
     C*--------------------------------------------------------
     C                   MOVEL     LBRSFIRM      EXLBFIRM
     C                   MOVEL     LBRSLANR      EXLBLANR
     C                   MOVEL     LBRSTENR      EXLBTENR
     C                   MOVEL     LBRSLORT      EXLBLORT
     C                   MOVEL     LBRSCHAR      EXLBCHAR
     C                   MOVEL     LBRSAFDN      EXLBDANA
     C                   Z-ADD(H)  LBRSAFJJ      EXLBAFJJ
     C                   MOVEL     LBRSAFNR      EXLBAFNR
     C                   Z-ADD(H)  LBRSAFPO      EXLBAFPO
     C                   Z-ADD(H)  LBRSAFUP      EXLBAFUP
     C                   MOVEL     AALSTC        EXLBLSTC
     C*
     C                   Z-ADD(H)  LBRSFUMG      EXLBFUMG
     C                   MOVEL     LBRSBSLA      EXLBBSLA
     C                   MOVEL     LBRSWKNR      EXLBWKNR
     C                   MOVEL     LBRSKDNR      EXLBKDNR
     C                   MOVEL     LBRSLFNR      EXLBLFNR
     C                   MOVEL     LBRSFBNR      EXLBFBNR
     C                   MOVEL     LBRSGEBI      EXLBGEBI
     C                   MOVEL     LBRSCONT      EXLBCONT
     C                   MOVEL     LBRSBHNR      EXLBBHNR
     C                   MOVEL     LBRSQUMM      EXLBQUMM
     C                   Z-ADD(H)  LBRSRMMG      EXLBBWMG
     C                   MOVEL     TEMEIN        EXLBBWME
     C                   MOVEL     DANEKZ        EXLBRSKZ
     C                   MOVEL     DAJNKZ        EXLBLBRS
     C*-------------------------------------------------------------------------
     C     WKBDAT        IFEQ      *ZERO
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        EXLBBDAT
     C                   MOVEL     DUN120        EXLBBZEI
     C                   ELSE
     C                   MOVEL     WKBDAT        EXLBBDAT
     C                   MOVEL     WKBZEI        EXLBBZEI
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVEA     KOM           #CKOMM
     C*-------------------------------------------------------------------------
     C                   CALL      'TRLBLB  '
     C                   PARM                    EXTR02
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C                   MOVEL     RTLBFENR      WKFENR                         FEHLERNUMMER
     C                   MOVEL     RTLBFFLD      WKFFLD                         FEHLERFELD
     C*-------------------------------------------------------------------------
     C     WKFENR        IFEQ      *ZERO
     C                   MOVEL(P)  LBRSFIRM      KYLBRSFIRM
     C                   MOVEL     LBRSTMST      KYLBRSTMST
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHLBRS
     C                   MOVE      RTLBTMST      LBRSLBTM
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHLBRS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDSR
     C**************************************************************************
     C***  SR-ETRPA      ERMITTELN DATEN AUS FIRMEN-PARAMETER                ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VLIKE      DEFINITION DER WORKFELDER...                        ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5            INT.PROGR.STAT.
     C     *LIKE         DEFINE    WKC001        W$PGST          + 5
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1            NÄCHST.BILD
     C     *LIKE         DEFINE    WKC001        WKRTCD                         ALLG.RTCD.
     C     *LIKE         DEFINE    WKC001        WKTRTP                         IN MC-PROGR.
     C     *LIKE         DEFINE    WKC001        WKIOKZ                         OPEN KZ. FORMAT
     C     *LIKE         DEFINE    WKC001        WKTRPA                         FIRMENPARAMETER
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 3            INDEX 1
     C     *LIKE         DEFINE    WKN010        I2              + 3            INDEX 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        DSFIRM                         FIRMA
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         BENUTZER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    LBRSTMST      WKTMST
     C     *LIKE         DEFINE    EXLBBDAT      WKBDAT
     C     *LIKE         DEFINE    EXLBBZEI      WKBZEI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTLBFFLD      WKFFLD                         FEHLERFELD
     C*
     C                   ENDSR
     C**************************************************************************
     C*       A U F R U F - M O D U L E                                        *
     C**************************************************************************
     C/COPY QCPYSRC,CHAFPA
     C/COPY QCPYSRC,CHAFPO
     C/COPY QCPYSRC,CHLBRS
     C/COPY QCPYSRC,CHTEIL
