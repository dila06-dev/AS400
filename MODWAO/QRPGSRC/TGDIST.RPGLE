     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE dispo beistellung Begriff 023
     H**************************************************************************
     H*  Copyright 2003 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       Bötzinger Straße 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellung: RE 22.05.2015 DOMETIC Service 20150513-014
     H*  -----------------------------------------------------------------------
     F**************************************************************************
     F*/
     F*/
     D**************************************************************************
     D***  T A B E L L E N  U N D  F E L D G R U P P E N                     ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRDR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D DIST          E DS                  INZ
     D KYDIST        E DS                  INZ
     D*
     D PAHS          E DS                  INZ
     D KYPAHS        E DS                  INZ
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D EXPA01          DS          2500
     D   BFILE                 1     10
     D   BEVENT               31     31  0
     D   BTIME                32     32  0
     D   BOFFOLDREC           49     52B 0
     D   BLNGOLDREC           53     56B 0
     D   BOFFNEWREC           65     68B 0
     D   BLNGNEWREC           69     72B 0
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D**************************************************************************
     D***  DATENSTATIONSARBEITSBEREICH                                       ***
     D**************************************************************************
     D EXTRLD        EUDS
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    EXPA01
     C                   PARM                    EXPA02            4
     C                   PARM                    DAINFO           20
     C*
     C                   EXSR      UEBKOM
     C*-------------------------------------------------------------------------
     C     *DTAARA       DEFINE    *LDA          EXTRLD
     C                   IN        EXTRLD
     C*-------------------------------------------------------------------------
     C     WKTRPA        CASEQ     *BLANK        ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C*-------------------------------------------------------------------------
     C     WKI000        CASNE     *ON           ANFANG                         ANFANGROUTINE
     C                   ENDCS
     C*-------------------------------------------------------------------------
     C                   EXSR      VORLAUF                                      VORLAUF
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C     BEGROLD       IFEQ      '023'
     C     BEGRNEW       OREQ      '023'
     C                   EXSR      UPAHS
     C                   EXSR      WPAHS
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  SR-ANFANG       ERÖFFNUNGSZYKLUS                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C                   MOVE      *ON           WKI000
     C*-------------------------------------------------------------------------
     C                   MOVEL     *ZERO         #CDATN                         DATUMSFELDER
     C                   MOVEL     *ZERO         #CDATV                         AUF NULL SETZEN
     C                   MOVEL     *ZERO         #CDAKW
     C                   MOVEL     *ZERO         #CDAJJ
     C                   MOVEL     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------------
     C                   MOVE      DAFIRM        DSFIRM                         *LDA-FELDER
     C                   MOVE      DAPROG        WKCHPN                         PROGR
     C                   MOVE      DABIBL        WKCHPL                         BIBL.
     C                   MOVE      DAUSER        WKUSER
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        DAFEHL
     C                   MOVE      *BLANK        ##RTCD
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
     C                   MOVE      #CPGST        PCPGST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VORLAUF      VORLAUF                                           ***
     C**************************************************************************
     C     VORLAUF       BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EVAL      WKNEWPOSI = BOFFNEWREC + 1
     C                   EVAL      WKNEWLANG = BLNGNEWREC
     C                   EVAL      WKOLDPOSI = BOFFOLDREC + 1
     C                   EVAL      WKOLDLANG = BLNGOLDREC
     C*-------------------------------------------------------------------------
     C     BEVENT        IFEQ      1
     C     BTIME         OREQ      1
     C     BEVENT        ANDNE     2
     C                   EVAL      DIST = %SUBST(EXPA01:WKNEWPOSI:WKNEWLANG)
     C                   ELSE
     C                   EVAL      DIST = %SUBST(EXPA01:WKOLDPOSI:WKOLDLANG)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKOLDPOSI     IFNE      *ZERO
     C                   EVAL      DISTOLD = %SUBST(EXPA01:WKOLDPOSI:WKOLDLANG)
     C                   EVAL      BEGROLD = %SUBST(DISTOLD:58:3)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     WKNEWPOSI     IFNE      *ZERO
     C                   EVAL      DISTNEW = %SUBST(EXPA01:WKNEWPOSI:WKNEWLANG)
     C                   EVAL      BEGRNEW = %SUBST(DISTNEW:58:3)
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPAHS                                                             ***
     C**************************************************************************
     C     UPAHS         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C                   MOVEL     ITFIRM        KYPAHSFIRM
     C                   MOVEL     *BLANK        KYPAHSAPAT
     C                   MOVEL     ITTENR        KYPAHSTENR
     C                   MOVEL     *BLANK        KYPAHSVARK
     C                   MOVEL     'DIST   '     KYPAHSFILE
     C                   MOVEL     *HIVAL        KYPAHSINNR
     C                   MOVEL     *HIVAL        KYPAHSRLZA
     C*
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHPAHS
     C*
     C     CHI(5)        IFEQ      'J'
     C     PAHSFIRM      ANDEQ     KYPAHSFIRM
     C     PAHSINNR      ADD       1             PAHSINNR
     C                   ELSE
     C                   Z-ADD     1             PAHSINNR
     C                   ENDIF
     C*------------------------------------------------------
     C                   CLEAR                   KYPAHS
     C                   MOVEL     ITFIRM        KYPAHSFIRM
     C                   MOVEL     PAHSINNR      KYPAHSINNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAHS
     C*------------------------------------------------------
     C                   MOVEL     'DIST   '     PAHSFILE
     C                   MOVEL     DIST          PAHSDATA
     C*------------------------------------------------------
     C                   MOVEL     DAJNAM        PAHSJNAM
     C                   MOVEL     WKCHPN        PAHSPROG
     C                   MOVEL     WKCHPL        PAHSBIBL
     C                   MOVEL     DAUSER        PAHSUSER
     C                   TIME                    PAHSJZEI
     C*----------------------------------------------------UMSETZEN DATUM
     C                   MOVEL     *DATE         PAHSJDAT
     C                   MOVEL     PAHSJDAT      #CDATV
     C                   MOVEL     '*EUR    '    #CFMTV
     C                   MOVEL     '*ISO    '    #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVE      #CDATN        PAHSJDAT
     C*------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHPAHS
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SCHREIBEN DER PROGRAMME IM LEITWEGSCHRITT                         ***
     C**************************************************************************
     C     WPAHS         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     1             DUN020
     C                   MOVEL     *BLANK        DUC070
     C*
     C                   DO        *HIVAL
     C*
     C                   ADD       1             DUN020
     C                   MOVE      DUC002        PGMIMLWS
     C                   MOVE      *BLANKS       CRTDATE
     C                   MOVE      *BLANKS       CRTUSER
     C*
     C                   CALL      'TRVALI01'
     C*
     C                   PARM                    PGMIMLWS          2
     C                   PARM                    PGMID            10
     C                   PARM                    CRTDATE          13
     C                   PARM                    CRTUSER          10
     C*
     C     PGMID         IFEQ      'QDBUDR'
     C     PGMID         OREQ      'QDBPUT'
     C     PGMID         OREQ      'TGVALI'
     C                   ITER
     C                   ENDIF
     C*
     C     CRTDATE       IFEQ      *BLANKS
     C                   LEAVE
     C                   ENDIF
     C*
     C                   MOVEL(P)  PGMID         DUC001
     C     DUC001        IFEQ      *BLANKS
     C     DUC001        OREQ      'Q'
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EVAL      DUC070 = %TRIM(DUC070) + %TRIM(PGMID) + ';'
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     ITFIRM        KYPAHSFIRM
     C                   MOVEL     *BLANK        KYPAHSAPAT
     C                   MOVEL     ITTENR        KYPAHSTENR
     C                   MOVEL     *BLANK        KYPAHSVARK
     C                   MOVEL     'LEITWDI'     KYPAHSFILE
     C                   MOVEL     *HIVAL        KYPAHSINNR
     C                   MOVEL     *HIVAL        KYPAHSRLZA
     C*
     C                   MOVEA     '02-     '    CHI
     C                   EXSR      CHPAHS
     C*
     C     CHI(5)        IFEQ      'J'
     C     PAHSFIRM      ANDEQ     KYPAHSFIRM
     C     PAHSINNR      ADD       1             PAHSINNR
     C                   ELSE
     C                   Z-ADD     1             PAHSINNR
     C                   ENDIF
     C*------------------------------------------------------
     C                   CLEAR                   KYPAHS
     C                   MOVEL     ITFIRM        KYPAHSFIRM
     C                   MOVEL     PAHSINNR      KYPAHSINNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAHS
     C*------------------------------------------------------
     C                   MOVEL     'LEITWDI'     PAHSFILE
     C                   MOVEL     DUC070        PAHSDATA
     C*------------------------------------------------------
     C                   MOVEL     DAJNAM        PAHSJNAM
     C                   MOVEL     WKCHPN        PAHSPROG
     C                   MOVEL     WKCHPL        PAHSBIBL
     C                   MOVEL     DAUSER        PAHSUSER
     C                   TIME                    PAHSJZEI
     C*----------------------------------------------------UMSETZEN DATUM
     C                   MOVEL     *DATE         PAHSJDAT
     C                   MOVEL     PAHSJDAT      #CDATV
     C                   MOVEL     '*EUR    '    #CFMTV
     C                   MOVEL     '*ISO    '    #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVE      #CDATN        PAHSJDAT
     C*------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHPAHS
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ETRPA  ERMITTELN DATEN AUS FIRMEN-PARAMETER                       ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SR-VLIKE        DEFINITION DER WORKFELDER                         ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5            INT.PROGR.STAT.
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKTRPA                         PARAMETER
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C     *LIKE         DEFINE    WKC001        WKFFLD          + 9
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 2            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        DSFIRM                         FIRMA
     C     *LIKE         DEFINE    DSFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         BENUTZER
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN050        WKNEWPOSI
     C     *LIKE         DEFINE    DUN050        WKNEWLANG
     C     *LIKE         DEFINE    DUN050        WKOLDPOSI
     C     *LIKE         DEFINE    DUN050        WKOLDLANG
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DIST          DISTOLD
     C     *LIKE         DEFINE    DIST          DISTNEW
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    ITBEGR        BEGROLD
     C     *LIKE         DEFINE    ITBEGR        BEGRNEW
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*       A U F R U F - M O D U L E                                        *
     C**************************************************************************
     C/COPY QCPYSRC,CHPAHS
     C/COPY QCPYSRC,TRDAUM
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
