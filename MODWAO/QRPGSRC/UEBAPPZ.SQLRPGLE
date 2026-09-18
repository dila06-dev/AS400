     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H**************************************************************************
     H/TITLE Übernahme Absatz-Plan %-Sätze Jahresebene
     F**************************************************************************
     F*
     F*  Dieses Programm übernimmt die Absatz-Plan Erhöhungstabelle aus einer
     F*  EXCEL-Tabelle.
     F*
     F**************************************************************************
     F***  DATEIBESCHREIBUNGEN                                               ***
     F**************************************************************************
     FVERSAND   IF   E             DISK
     F                                     RENAME(VERSAND:VERSAND1)
     F*
     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRBR
     D*
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D APPZ          E DS                  INZ
     D KYAPPZ        E DS                  INZ
     D*
     D KDEW          E DS                  INZ
     D KYKDEW        E DS                  INZ
     D*
     D KUND          E DS                  INZ
     D KYKUND        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXAPPZ        E DS                  INZ
     D RTAPPZ        E DS                  INZ
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
     D  WKTDAT                         D   DATFMT(*ISO) INZ
     D*
     D**************************************************************************
     D***  PROGRAMMSTATUS DATENSTRUKTUR                                      ***
     D**************************************************************************
     D/COPY QCPYSRC,EXPSDS
     D*
     C**************************************************************************
     C***  R E C H E N B E S T I M M U N G E N                               ***
     C**************************************************************************
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
     C**************************************************************************
     C***  P R O G R A M M S T E U E R U N G                                 ***
     C**************************************************************************
     C                   EXSR      VAPPZ
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
     C                   MOVEL(P)  DAFIRM        KYAPPZFIRM                     APPZ
     C                   MOVEL(P)  DAFIRM        KYKDEWFIRM                     KDEW
     C                   MOVEL(P)  DAFIRM        KYKDFI                         KUND
     C                   MOVEL(P)  DAFIRM        KYTAFI                         TRPA
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
     C***  ERMITTELN PARAMETERWERTE                                          ***
     C**************************************************************************
     C     ETRPA         BEGSR
     C*
     C                   MOVEL     *ON           WKTRPA
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  SPEICHERN ERHÜHUNGSTABELLE <- KD-STEUERUNGS-CODE/PRODUKT-GRUPPE   ***
     C**************************************************************************
     C     VAPPZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C*-------------------------------------------------------------------------
     C     *IN(98)       DOWEQ     *OFF
     C     *IN(99)       ANDEQ     *OFF
     C*-------------------------------------------------------------------------
     C                   READ      VERSAND1                             9899
     C*
     C     *IN(98)       IFEQ      *ON
     C     *IN(99)       OREQ      *ON
     C                   LEAVE
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   CLEAR                   EXAPPZ
     C                   EVAL      EXAPPZPRGR  = F3                             Produktgruppe
     C                   EVAL      EXAPPZJAHR  = 2012
     C                   EVAL      EXAPPZPZ01  = F10 * 100
     C                   EVAL      EXAPPZPZ02  = F11 * 100
     C                   EVAL      EXAPPZPZ03  = F12 * 100
     C                   EVAL      EXAPPZPZ04  = F13 * 100
     C                   EVAL      EXAPPZPZ05  = F14 * 100
     C                   EVAL      EXAPPZPZ06  = F15 * 100
     C                   EVAL      EXAPPZPZ07  = F16 * 100
     C                   EVAL      EXAPPZPZ08  = F17 * 100
     C                   EVAL      EXAPPZPZ09  = F18 * 100
     C                   EVAL      EXAPPZPZ10  = F19 * 100
     C                   EVAL      EXAPPZPZ11  = F20 * 100
     C                   EVAL      EXAPPZPZ12  = F21 * 100
     C*--------------------------------------------------------
     C                   EVAL      WKKDEWKSST  = %CHAR(F2)                      Kostenstelle
     C*--------------------------------------------------------
     C                   SELECT
     C                   WHEN      %LEN(%TRIM(F8)) = 1
     C                   EVAL      WKKUNDKSTC  = %SUBST(F8:1:1) + '01'
     C                   WHEN      %LEN(%TRIM(F8)) = 2
     C                   EVAL      WKKUNDKSTC  = %SUBST(F8:1:1) + '0'
     C                                           + %SUBST(F8:2:1)
     C                   OTHER
     C                   ITER
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   EXSR      OKUND
     C                   EXSR      VKUND
     C*-------------------------------------------------------------------------
     C                   MOVE      *OFF          *IN
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  ÖFFENEN CURSOR KUNDC1                                             ***
     C**************************************************************************
     C     OKUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ DECLARE KUNDC1 CURSOR FOR SELECT KDKDNR FROM KUND, KDEW
     C+ WHERE KUND.KDFIRM   = :DAFIRM
     C+ AND   KUND.KDKDST   < '90'
     C+ AND   KUND.KDKSTC   = :WKKUNDKSTC
     C+ AND   KUND.KDFIRM   = KDEW.KDEWFIRM
     C+ AND   KUND.KDKDNR   = KDEW.KDEWKDNR
     C+ AND   KDEW.KDEWKSST = :WKKDEWKSST
     C+ FOR READ ONLY
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ OPEN KUNDC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  VERARBEITEN KUND                                                  ***
     C**************************************************************************
     C     VKUND         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVE      *ZERO         SQLCOD
     C*-------------------------------------------------------------------------
     C     SQLCOD        DOWEQ     *ZERO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+  FETCH KUNDC1 INTO :KDKDNR
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C     SQLCOD        IFEQ      *ZERO
     C                   EVAL      EXAPPZKDNR  = KDKDNR
     C                   EXSR      UAPPZ
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C/EXEC SQL
     C+ CLOSE KUNDC1
     C/END-EXEC
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  UPDATE DATEI APPZ                                                 ***
     C**************************************************************************
     C     UAPPZ         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  EXAPPZKDNR    KYAPPZKDNR
     C                   MOVEL(P)  EXAPPZPRGR    KYAPPZPRGR
     C                   Z-ADD     EXAPPZJAHR    KYAPPZJAHR
     C                   MOVEA     '01CU    '    CHI                            LESEN FÜR
     C                   EXSR      CHAPPZ                                       UPDATE
     C*-------------------------------------------------------------------------
     C                   Z-ADD     EXAPPZPZ01    APPZPZ01
     C                   Z-ADD     EXAPPZPZ02    APPZPZ02
     C                   Z-ADD     EXAPPZPZ03    APPZPZ03
     C                   Z-ADD     EXAPPZPZ04    APPZPZ04
     C                   Z-ADD     EXAPPZPZ05    APPZPZ05
     C                   Z-ADD     EXAPPZPZ06    APPZPZ06
     C                   Z-ADD     EXAPPZPZ07    APPZPZ07
     C                   Z-ADD     EXAPPZPZ08    APPZPZ08
     C                   Z-ADD     EXAPPZPZ09    APPZPZ09
     C                   Z-ADD     EXAPPZPZ10    APPZPZ10
     C                   Z-ADD     EXAPPZPZ11    APPZPZ11
     C                   Z-ADD     EXAPPZPZ12    APPZPZ12
     C*--------------------------------------------------------
     C                   MOVEL(P)  DAJNAM        APPZJNAM
     C                   MOVEL(P)  DAPROG        APPZPROG
     C                   MOVEL(P)  WKCHPL        APPZBIBL
     C                   MOVEL(P)  DAUSER        APPZUSER
     C*--------------------------------------------------------
     C                   TIME                    DUN120
     C                   MOVE      DUN120        DUN060
     C     *JOBRUN       MOVE      DUN060        WKTDAT
     C                   MOVEL     DUN120        APPZJZEI
     C                   MOVE      WKTDAT        APPZJDAT
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *ON
     C                   MOVEA     '01W     '    CHI
     C                   EXSR      CHAPPZ
     C*--------------------------------------------------------
     C     CHI(6)        WHENEQ    *OFF
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHAPPZ
     C*--------------------------------------------------------
     C                   ENDSL
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
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*-------------------------------------------------------------------------
     C***  ...ANHAND DATEI-/DATENSTRUKTURFELDERN                             ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KDEWKSST      WKKDEWKSST
     C     *LIKE         DEFINE    KDKSTC        WKKUNDKSTC
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTAPPZPROG    WKPROG
     C     *LIKE         DEFINE    RTAPPZDANA    WKDANA
     C     *LIKE         DEFINE    RTAPPZFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***  COPY-MODULE                                                       ***
     C**************************************************************************
     C/COPY QCPYSRC,CHAPPZ
     C/COPY QCPYSRC,CHKDEW
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTRPA
     O**************************************************************************
     O***  ENDE DES PROGRAMMS                                                ***
     O**************************************************************************
