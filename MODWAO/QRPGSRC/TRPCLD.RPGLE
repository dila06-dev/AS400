     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE Verbuchen PCLB-Bewegungen in BGFS
     F********************************************************************
     F***     DATEIBESCHREIBUNG   BILDSCHIRMDATEI  -WORKSTN-           ***
     F********************************************************************
     FTRDZUG    UF A E           K DISK
     F                                     RENAME(PCLB1:PCLB01A)
     D********************************************************************
     D***     T A B E L L E N  U N D  F E L D G R U P P E N            ***
     D********************************************************************
     D CHI             S              1    DIM(8)                               STEUERUNG ZUGRIFF
     D********************************************************************
     D***     DATEIEN                                                  ***
     D********************************************************************
     D TRTK          E DS                  INZ
     D KYTRTK        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D PCLB          E DS                  INZ
     D KYPCLB        E DS                  INZ
     D**************************************************************************
     D***  INTERNE DATENSTRUKTUR                                             ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRIN
     D********************************************************************
     D***     KOMMUNIKATIONSPARAMETER                                  ***
     D********************************************************************
     D EXTR01        E DS
     D EXTR02        E DS
     D EXTR04        E DS
     D********************************************************************
     D***     DATENSTATIONSARBEITSBEREICH                              ***
     D********************************************************************
     D EXTRLD        EUDS
     C********************************************************************
     C***     R E C H E N B E S T I M M U N G E N                      ***
     C********************************************************************
     C     *DTAARA       DEFINE    *LDA          EXTRLD                                   AS400
     C                   IN        EXTRLD                                                 AS400
     C*-------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*-------------------------------------------------------------------
     C     WKTRPA        CASEQ     *BLANK        ETRPA                          ERM.FIRMEN-
     C                   ENDCS                                                  PARAMETER
     C**************************************************************************
     C                   EXSR      ANFANG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  '00'          KYPCLBSTAT
     C                   MOVEA     '02+U    '    CHI
     C                   EXSR      CHPCLB
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C     PCLBSTAT      IFNE      KYPCLBSTAT
     C                   MOVEA     '02F     '    CHI
     C                   EXSR      CHPCLB
     C                   LEAVE
     C                   ENDIF
     C*
     C                   EXSR      UZUG
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVE      *BLANK        PCLBFENR
     C                   MOVEL(P)  '90'          PCLBSTAT
     C                   ELSE
     C                   MOVEL(P)  WKFENR        PCLBFENR
     C                   ENDIF
     C                   MOVEA     '02U     '    CHI
     C                   EXSR      CHPCLB
     C*-------------------------------------------------------------------
     C                   MOVEA     '02RU    '    CHI
     C                   EXSR      CHPCLB
     C*-------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C     ENDE          TAG
     C*
     C                   MOVE      '1'           *INLR
     C**************************************************************************
     C***  SR-ANFANG       ERÖFFNUNGSZYKLUS                                  ***
     C**************************************************************************
     C     ANFANG        BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         #CDATN                         DATUMFELDER
     C                   MOVE      *ZERO         #CDATV                         AUF NULL SETZEN
     C                   MOVE      *ZERO         #CFMTN
     C                   MOVE      *ZERO         #CFMTV
     C                   MOVE      *ZERO         #CDAKW
     C                   MOVE      *ZERO         #CDAJJ
     C                   MOVE      *ZERO         #CMCAZ
     C*-------------------------------------------------------------------------
     C                   MOVE      *BLANK        WKC001            1            INITIALISIEREN
     C                   MOVE      *ZERO         WKN010            1 0          FELDER
     C                   MOVE      *ZERO         WKN090            9 0
     C                   MOVE      *ZERO         WKN154           15 4
     C                   MOVE      *ZERO         WKN219           21 9
     C*-------------------------------------------------------------------
     C                   MOVE      DAFIRM        KYPCLBFIRM                     LBIK
     C                   MOVEL     DAFIRM        KYTEFI                         TEIL
     C*-------------------------------------------------------------------
     C                   MOVE      DAFIRM        KYTKFI                         TRTK
     C                   MOVE      DASPCD        KYTKSP
     C*-------------------------------------------------------------------------
     C                   MOVEL     *BLANK        DAFEHL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI TRDZUG                                               ***
     C**************************************************************************
     C     UZUG          BEGSR
     C*
     C                   MOVEL     *ZEROS        WKFENR
     C*-------------------------------------------------------------------------
     C                   WRITE     PCLB01A
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ERMITTELN DATEN AUS FIRMEN-PARAMETER                              ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVE      *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7            STEUERUNG
     C     *LIKE         DEFINE    WKC001        ##PGST                         PROGRAMMSTATUS
     C     *LIKE         DEFINE    WKC001        ##RTCD                         RETURN-CODE
     C     *LIKE         DEFINE    WKC001        PCPGST          + 5            INT.PROGR.STAT.
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKI000                         IND.ANFANG
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3            FEHLERNUMMER
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKPCLB                         IND.PCLB
     C     *LIKE         DEFINE    WKC001        WKTRPA                         IND.TRPA
     C     *LIKE         DEFINE    WKC001        DSUPKZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I1              + 3            INDEX 1
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DAFIRM        WKFIRM                         FIRMA
     C     *LIKE         DEFINE    DAUSER        WKUSER                         USER
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C*       A U F R U F - M O D U L E                                      ***
     C**************************************************************************
     C/COPY QCPYSRC,CHTRTK
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHPCLB
     C/COPY QCPYSRC,TRDAUM
     O********************************************************************
     O*       E N D E  DES PROGRAMMS                                     *
     O********************************************************************
