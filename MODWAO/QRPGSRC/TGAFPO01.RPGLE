     H DECEDIT('0,') DATEDIT(*DMY.)
     H**************************************************************************
     H/TITLE Löschen DIST
     H**************************************************************************
     H*  Copyright 2013 by    trend SWM
     H*                       EDV-Verwaltungs GmbH
     H*                       B¦tzinger Stra~e 36
     H*                       D-79111 Freiburg
     H*  -----------------------------------------------------------------------
     H*  Erstellung: ZG 05.03.2013 Service
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
     D*
     D AFPO          E DS                  INZ
     D KYAFPO        E DS                  INZ
     D*
     D PAHS          E DS                  INZ
     D KYPAHS        E DS                  INZ
     D*
     D LBAP          E DS                  INZ
     D KYLBAP        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS
     D*
     D  WKTDAT                         D   DATFMT(*ISO) INZ
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
     C     APAFST        IFEQ      '15'
     C     WKAFST        ANDEQ     '20'
     C*
     C                   MOVEL(P)  APFIRM        KYLBAPFIRM
     C                   MOVEL(P)  'AFKM'        KYLBAPDANA
     C                   Z-ADD     APKMJJ        KYLBAPJAHR
     C                   MOVEL(P)  APKMNR        KYLBAPNMKR
     C                   Z-ADD     APKMPO        KYLBAPPOSI
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHLBAP
     C     LBAPSTAT      IFLT      '90'
     C                   EXSR      UPAHS
     C                   ENDIF
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   MOVE      *ON           *INLR
     C**************************************************************************
     C***  SR-ANFANG       ER\FFNUNGSZYKLUS                                  ***
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
     C                   MOVE      *BLANK        WKAFST            2
     C     WKOLDPOSI     IFNE      *ZERO
     C                   EVAL      AFPO=%SUBST(EXPA01:WKOLDPOSI:WKOLDLANG)
     C                   MOVE      APAFST        WKAFST
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C     BEVENT        IFEQ      1
     C     BTIME         OREQ      1
     C     BEVENT        ANDNE     2
     C                   EVAL      AFPO = %SUBST(EXPA01:WKNEWPOSI:WKNEWLANG)
     C                   ELSE
     C                   EVAL      AFPO = %SUBST(EXPA01:WKOLDPOSI:WKOLDLANG)
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
     C                   MOVEL     APFIRM        KYPAHSFIRM
     C                   MOVEL     *BLANK        KYPAHSAPAT
     C                   MOVEL     *BLANK        KYPAHSTENR
     C                   MOVEL     *BLANK        KYPAHSVARK
     C                   MOVEL(P)  'AFPO'        KYPAHSFILE
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
     C                   MOVEL     APFIRM        KYPAHSFIRM
     C                   MOVEL     PAHSINNR      KYPAHSINNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAHS
     C*------------------------------------------------------
     C                   MOVEL(P)  'AFPO'        PAHSFILE
     C                   MOVEL     AFPO          PAHSDATA
     C*------------------------------------------------------
     C                   MOVEL     DAJNAM        PAHSJNAM
     C                   MOVEL     WKCHPN        PAHSPROG
     C                   MOVEL     WKCHPL        PAHSBIBL
     C                   MOVEL     DAUSER        PAHSUSER
     C                   TIME                    PAHSJZEI
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        PAHSJDAT
     C*------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHPAHS
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        DUC1024
     C                   Z-ADD     1             DUN020
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
     C                   MOVEL(P)  PGMID         DUC001
     C     DUC001        IFEQ      *BLANKS
     C     DUC001        OREQ      '*'
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EVAL      DUC1024 = %TRIM(DUC1024) + '/' + %TRIM(PGMID)
     C*
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     APFIRM        KYPAHSFIRM
     C                   MOVEL     *BLANK        KYPAHSAPAT
     C                   MOVEL     *BLANK        KYPAHSTENR
     C                   MOVEL     *BLANK        KYPAHSVARK
     C                   MOVEL(P)  'LEITW  '     KYPAHSFILE
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
     C                   MOVEL     APFIRM        KYPAHSFIRM
     C                   MOVEL     PAHSINNR      KYPAHSINNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHPAHS
     C*------------------------------------------------------
     C                   MOVEL(P)  'LEITW  '     PAHSFILE
     C                   MOVEL     DUC1024       PAHSDATA
     C*------------------------------------------------------
     C                   MOVEL     DAJNAM        PAHSJNAM
     C                   MOVEL     WKCHPN        PAHSPROG
     C                   MOVEL     WKCHPL        PAHSBIBL
     C                   MOVEL     DAUSER        PAHSUSER
     C                   TIME                    PAHSJZEI
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVE      WKTDAT        PAHSJDAT
     C*------------------------------------------------------
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHPAHS
     C*-------------------------------------------------------------------------
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
     C     *LIKE         DEFINE    DUC002        AFPOAFST
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*       A U F R U F - M O D U L E                                        *
     C**************************************************************************
     C/COPY QCPYSRC,CHPAHS
     C/COPY QCPYSRC,CHLBAP
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
