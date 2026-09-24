     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE        Lagerkennzahlen
     H********************************************************************
     H*  Copyright 2013 by    trend SWM
     H*                       Verwaltungs GmbH
     H*                       Gundelfingerstr 11
     H*                       D-79108 Freiburg
     H*  --------------------------------------------------------------
     H*  Erstellung: SC 02.05.2013
     H*  --------------------------------------------------------------
     F********************************************************************
     FWAOZ      O  A E             DISK
     F*/
     F********************************************************************
     F***     DATEIBESCHREIBUNG   BILDSCHIRMDATEI  -WORKSTN-           ***
     F********************************************************************
     F*
     D********************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N            ***
     D********************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D KOM             S              1    DIM(220)                             KOMMUNIKATION
     D*
     D********************************************************************
     D***     DATEIEN                                                  ***
     D********************************************************************
     D LBLB          E DS
     D KYLBLB        E DS
     D*
     D TEIL          E DS
     D KYTEIL        E DS
     D*
     D LBVM          E DS
     D KYLBVM        E DS
     D**************************************************************************
     D***     INTERNE DATENSTRUKTUR                                          ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D*
     D********************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                  ***
     D********************************************************************
     D EXTR01        E DS
     D EXTR02        E DS
     D EXTR03        E DS                  INZ
     D EXTR04        E DS
     D********************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                              ***
     D********************************************************************
     D EXTRLD        EUDS
     I*
     C********************************************************************
     C***     R E C H E N B E S T I M M U N G E N                      ***
     C********************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------
     C                   EXSR      ANFANG
     C                   EXSR      VTEIL
     C*
     C                   MOVE      *ON           *INLR
     C********************************************************************
     C* SR VTEIL
     C********************************************************************
     C     VTEIL         BEGSR
     C                   MOVEA     '01L   '      CHI
     C                   EXSR      CHTEIL
     C*
     C     WKFENR        DOWEQ     *ZERO
     C                   MOVEA     '01R   '      CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------
     C     WKFENR        IFNE      *ZERO
     C     TEFIRM        ORNE      KYTEFI
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        KYLBLBBSLA
     C                   MOVE      '001'         KYLBLBLANR
     C                   MOVE      TETENR        KYLBLBTENR
     C                   Z-ADD     20130000      KYLBLBBDAT
     C                   Z-ADD     *ZERO         KYLBLBBZEI
     C                   MOVE      *LOVAL        KYLBLBTMST
     C                   EXSR      VLBLB
     C*-------------------------------------------------------------------
     C                   EXSR      TRLBB2
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        KYLBLBBSLA
     C                   MOVE      '002'         KYLBLBLANR
     C                   MOVE      TETENR        KYLBLBTENR
     C                   Z-ADD     20130000      KYLBLBBDAT
     C                   Z-ADD     *ZERO         KYLBLBBZEI
     C                   MOVE      *LOVAL        KYLBLBTMST
     C                   EXSR      VLBLB
     C*-------------------------------------------------------------------
     C                   EXSR      TRLBB2
     C*-------------------------------------------------------------------
     C     WAOZBDA1      IFEQ      *ZERO
     C     WAOZBDA2      ANDEQ     *ZERO
     C                   ITER
     C                   ENDIF
     C*-------------------------------------------------------------------
     C                   MOVE      TETENR        KYLMTE
     C                   MOVE      *BLANK        KYLMEZ
     C                   MOVE      '001'         KYLMLA
     C                   Z-ADD     2012          KYLMJH
     C                   Z-ADD     01            KYLMMO
     C                   EXSR      VLBVM
     C*-------------------------------------------------------------------
     C                   MOVE      TETENR        KYLMTE
     C                   MOVE      *BLANK        KYLMEZ
     C                   MOVE      '002'         KYLMLA
     C                   Z-ADD     2012          KYLMJH
     C                   Z-ADD     01            KYLMMO
     C                   EXSR      VLBVM
     C*-------------------------------------------------------------------
     C                   EXSR      UWAOZ
     C*-------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN PLATZBESTAND FÜR IDENTNUMMER                            ***
     C**************************************************************************
     C     TRLBB2        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEA     *BLANK        KOM
     C                   MOVEL     *OFF          KOM(1)                         PRÜFUNG-KZ
     C                   MOVEL     *ON           KOM(2)                         ERM.LAGERBESTAND
     C                   MOVEL     *OFF          KOM(4)                         ERM.DIST RESERV.
     C*
     C                   MOVEA     TETENR        KOM(10)                        IDENTNUMMER
     C                   MOVEA     KYLBLBLANR    KOM(25)
     C*
     C                   MOVEA     KOM           #CKOMM
     C                   MOVE      *BLANK        #CPGST
     C*
     C                   CALL      'TRLBB2'
     C                   PARM                    EXTR02
     C*-------------------------------------------------------------------------
     C                   MOVEA     #CKOMM        KOM
     C                   MOVEA     KOM(01)       DUC013
     C     KYLBLBLANR    IFEQ      '001'
     C                   Z-ADD(H)  DUN134        WAOZLAG1
     C                   ENDIF
     C     KYLBLBLANR    IFEQ      '002'
     C                   Z-ADD(H)  DUN134        WAOZLAG2
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C* SR VLBLB
     C********************************************************************
     C     VLBLB         BEGSR
     C*-------------------------------------------------------------------
     C                   MOVEA     '15-     '    CHI                            SETLL+READ
     C                   EXSR      CHLBLB
     C*-------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*----------------------------------------------------
     C     LBLBFIRM      IFNE      KYLBLBFIRM
     C     LBLBLANR      ORNE      KYLBLBLANR
     C     LBLBTENR      ORNE      KYLBLBTENR
     C     LBLBBDAT      ORLT      20120000
     C                   LEAVE
     C                   ENDIF
     C*
     C     LBLBLSTC      IFEQ      '130'
     C     KYLBLBLANR    IFEQ      '001'
     C                   MOVE      LBLBBDAT      WAOZBDA1
     C                   LEAVE
     C                   ENDIF
     C     KYLBLBLANR    IFEQ      '002'
     C                   MOVE      LBLBBDAT      WAOZBDA2
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C*----------------------------------------------------
     C                   MOVEA     '15P     '    CHI                            NÄCHSTER
     C                   EXSR      CHLBLB                                       SATZ
     C*----------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C* SR VLBVM
     C********************************************************************
     C     VLBVM         BEGSR
     C*-------------------------------------------------------------------
     C                   MOVEA     '01+     '    CHI                            SETLL+READ
     C                   EXSR      CHLBVM
     C*-------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*----------------------------------------------------
     C     LMFIRM        IFNE      KYLMFI
     C     LMLANR        ORNE      KYLMLA
     C     LMTENR        ORNE      KYLMTE
     C     LMJHJJ        ORNE      KYLMJH
     C                   LEAVE
     C                   ENDIF
     C*
     C     KYLMLA        IFEQ      '001'
     C                   ADD       LMLAGB        WAOZVBR1
     C                   ENDIF
     C     KYLMLA        IFEQ      '002'
     C                   ADD       LMLAGB        WAOZVBR2
     C                   ENDIF
     C*----------------------------------------------------
     C                   MOVEA     '01R     '    CHI                            NÄCHSTER
     C                   EXSR      CHLBVM                                       SATZ
     C*----------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C* SR UWAOZ
     C********************************************************************
     C     UWAOZ         BEGSR
     C*-------------------------------------------------------------------
     C                   MOVEL     DAFIRM        WAOZFIRM
     C                   MOVEL     TETENR        WAOZTENR
     C                   MOVEL     TETBZ1        WAOZTBZ1
     C                   Z-ADD     TESTPR        WAOZSTPR
     C*
     C                   WRITE     WAOZ1
     C*
     C                   CLEAR                   WAOZ1
     C*-------------------------------------------------------------------
     C                   ENDSR
     C********************************************************************
     C***                                                              ***
     C***  SR-ANFANG       ERÖFFNUNGSZYKLUS                            ***
     C***                                                              ***
     C********************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    LBLBTMST      WKTMST
     C*-------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C*-------------------------------------------------------------------
     C                   MOVEL     *ZERO         #CDATN
     C                   MOVEL     *ZERO         #CDATV
     C                   MOVEL     *ZERO         #CDAKW
     C                   MOVEL     *ZERO         #CDAJJ
     C                   MOVEL     *ZERO         #CMCAZ
     C*-------------------------------------------------------------------
     C                   MOVEL     DAFIRM        KYLBLBFIRM                     LBLB
     C                   MOVEL     DAFIRM        KYTEFI
     C                   MOVEL     DAFIRM        KYLMFI
     C*-------------------------------------------------------------------
     C                   MOVEL     DAPROG        WKCHPN                         PROGR.
     C                   MOVEL     DABIBL        WKCHPL                         BIBL.
     C*-------------------------------------------------------------------
     C                   MOVEL     *BLANK        DAFEHL
     C*-------------------------------------------------------------------
     C*
     C                   ENDSR
     C********************************************************************
     C*       A U F R U F - M O D U L E                                  *
     C********************************************************************
     C/COPY QCPYSRC,CHLBLB
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHLBVM
     O********************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O********************************************************************
