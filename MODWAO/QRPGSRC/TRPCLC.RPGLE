     H DECEDIT('0,') DATEDIT(*DMY.)
     H********************************************************************
     H/TITLE Verbuchen PCLB-Bewegungen in FUTURE II aus BGFS
     F********************************************************************
     F***     DATEIBESCHREIBUNG   BILDSCHIRMDATEI  -WORKSTN-           ***
     F********************************************************************
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
     D*
     D EXLBLB        E DS                  INZ
     D RTLBLB        E DS                  INZ
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
     C                   MOVEL(P)  '01'          KYPCLBSTAT
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
     C                   EXSR      ULBLB
     C*
     C     WKFENR        IFEQ      *ZEROS
     C                   MOVE      *BLANK        PCLBFENR
     C                   MOVEL(P)  '91'          PCLBSTAT
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
     C***  UPDATE DATEI LBLB                                                 ***
     C**************************************************************************
     C     ULBLB         BEGSR
     C*
     C                   MOVEL     *ZEROS        WKFENR
     C*
     C                   DO
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  PCLBTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C     WKFENR        IFNE      *ZEROS
     C                   MOVE      '0001'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C     TEBSKZ        IFNE      DAJNKZ
     C                   MOVE      '0002'        WKFENR
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXLBLB
     C                   MOVEL(P)  'BUCHEN'      EXLBPGST
     C* B-Key aus BGFS anpassen
     C                   SELECT
     C     PCLBBUKZ      WHENEQ    'ZUG'
     C                   MOVEL(P)  '420'         EXLBLSTC
     C     PCLBBUKZ      WHENEQ    'ABG'
     C                   MOVEL(P)  '410'         EXLBLSTC
     C                   OTHER
     C                   MOVEL(P)  PCLBBUKZ      EXLBLSTC
     C                   ENDSL
     C*
     C                   MOVE      *BLANK        EXLBBSLA
     C*
     C**   PCLBLANR      IFEQ      '001'
     C**                 MOVEL(P)  '901'         PCLBLANR
     C**                 ENDIF
     C*
     C                   MOVEL(P)  PCLBLANR      EXLBLANR
     C                   MOVEL(P)  PCLBLORT      EXLBLORT
     C                   MOVEL(P)  PCLBTENR      EXLBTENR
     C                   MOVE      *BLANK        EXLBCHAR
     C                   Z-ADD     PCLBBUMG      EXLBBWMG
     C                   Z-ADD     PCLBBUMG      EXLBSTMG
     C                   MOVEL(P)  TEMEIN        EXLBBWME
     C*--------------------------------------------------------
     C                   Z-ADD     0             EXLBBZEI
     C                   MOVEL     UDATE         #CDATV
     C                   MOVE      DADJHT        #CDATV
     C                   MOVEL     DADFMT        #CFMTV
     C                   MOVEL     'JHJJMMTT'    #CFMTN
     C                   EXSR      TRDAUM
     C                   MOVE      #CDATN        EXLBBDAT
     C*--------------------------------------------------------
     C                   MOVEL(P)  *BLANKS       EXLBBEZ1
     C                   MOVEL(P)  *BLANKS       EXLBBEZ2
     C*--------------------------------------------------------
     C                   MOVEL(P)  'BGFS'        EXLBDANA
     C                   MOVEL(P)  *ZEROS        EXLBDAKY
     C                   MOVEL     PCLBAFJJ      A10
     C                   MOVE      PCLBAFNR      A10              10
     C                   MOVEL     A10           A15              15
     C                   MOVE      PCLBAFPO      A15
     C                   MOVEL     A15           EXLBDAKY
     C     EXLBDAKY      IFEQ      *BLANKS
     C                   MOVEL(P)  *ZEROS        EXLBDAKY
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVE      PCLBAFJJ      WKLBAFJJ          4
     C                   MOVEL(P)  PCLBAFNR      EXLBAFNR
     C                   MOVE      PCLBAFPO      WKLBAFPO          4
     C                   EVAL      EXLBBEZ1 = 'Auftrag:' + ' ' +
     C                                        WKLBAFJJ  + '/' + PCLBAFNR +
     C                                        ' - ' + WKLBAFPO
     C*--------------------------------------------------------
     C                   CALL      'TRLBBS  '
     C                   PARM                    EXLBLB
     C                   PARM                    RTLBLB
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  RTLBFENR      WKFENR
     C                   ENDDO
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
