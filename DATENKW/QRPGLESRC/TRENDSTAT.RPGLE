     H DECEDIT('0,') DATEDIT(*DMY.)
     H OPTION(*SRCSTMT : *NODEBUGIO)
     H* COPYRIGHT('(C) Copyright trend SWM Verwaltung GmbH - 2002')
     H**************************************************************************
     H/TITLE Verwalten Beleg-Position
     H**************************************************************************
     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*                      GANG                                *
     F*                                                          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
     F************************************************************

     f#LBLBL1   uf   e           k disk

     DDate             S               D   DATFMT(*ISO)

     D**************************************************************************
     D***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     D**************************************************************************
     D/COPY QCPYSRC,EXTRTR
     D*
     D KOND            S                   LIKE(BLKOKON1) DIM(4) INZ
     D KOWT            S                   LIKE(BLKOKOW1) DIM(4) INZ
     D*
     D**************************************************************************
     D***  INDICATORS                                                        ***
     D**************************************************************************
     D/COPY QCPYSRC,TRCURSOR
     D*
     C*-------------------------------------------------------------------------
     D**************************************************************************
     D***  DATEIEN                                                           ***
     D**************************************************************************
     D BBEP          E DS                  INZ
     D KYBBEP        E DS                  INZ
     D*
     D BBPA          E DS                  INZ
     D KYBBPA        E DS                  INZ
     D*
     D BBUP          E DS                  INZ
     D KYBBUP        E DS                  INZ
     D*
     D BLKO          E DS                  INZ
     D KYBLKO        E DS                  INZ
     D*
     D BLPO          E DS                  INZ
     D KYBLPO        E DS                  INZ
     D*
     D BLPA          E DS                  INZ
     D KYBLPA        E DS                  INZ
     D*
     D BWAE          E DS                  INZ
     D KYBWAE        E DS                  INZ
     D*
     D BWPM          E DS                  INZ
     D KYBWPM        E DS                  INZ
     D*
     D BZUR          E DS                  INZ
     D KYBZUR        E DS                  INZ
     D*
     D LBSD          E DS                  INZ
     D KYLBSD        E DS                  INZ
     D*
     D LBST          E DS                  INZ
     D KYLBST        E DS                  INZ
     D*
     D LIEF          E DS                  INZ
     D KYLIEF        E DS                  INZ
     D*
     D MWST          E DS                  INZ
     D*
     D TEIL          E DS                  INZ
     D KYTEIL        E DS                  INZ
     D*
     D TEUF          E DS                  INZ
     D KYTEUF        E DS                  INZ
     D*
     D TRMU          E DS                  INZ
     D KYTRMU        E DS                  INZ
     D*
     D TRPA          E DS                  INZ
     D KYTRPA        E DS                  INZ
     D*
     D TRPC          E DS                  INZ
     D*
     D TRTP          E DS                  INZ
     D KYTRTP        E DS                  INZ
     D*
     D ZOTN          E DS                  INZ
     D KYZOTN        E DS                  INZ
     D*
     D**************************************************************************
     D***  KOMMUNIKATIONSPARAMETER                                           ***
     D**************************************************************************
     D EXTR01        E DS                  INZ
     D EXTR02        E DS                  INZ
     D EXTR03        E DS                  INZ
     D*
     D EXFIRM        E DS                  INZ
     D EXFLPO        E DS                  INZ
     D EXTRDN        E DS                  INZ
     D EXTRPC        E DS                  INZ
     D EXTXBE        E DS                  INZ
     D EXWAUM        E DS                  INZ
     D*
     D EXTRPB        E DS                  INZ
     D RTTRPB        E DS                  INZ
     D*
     D EXDATE        E DS                  INZ
     D RTDATE        E DS                  INZ
     D*
     D EXKOND        E DS                  INZ
     D RTKOND        E DS                  INZ
     D*
     D EXBZUR        E DS                  INZ
     D RTBZUR        E DS                  INZ
     D*
     D EXBLPO        E DS
     D RTBLPO        E DS
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
     D**************************************************************************
     D***  WORK-DATENSTRUKTUR  FÜR KOPIERFUNKTION                            ***
     D**************************************************************************
     D D$DAST          DS          2048
     D KYSAVE          DS          1024
     D D$DAST1         DS          2048
     D KYSAVE1         DS          1024
     D*

     C     *ENTRY        PLIST
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1
     C                   PARM                    #AEFIRM
     C                   PARM                    #AEBEJJ
     C                   PARM                    #AEBENR
     C                   PARM                    #AEBEPO

     C* --------------------------------------------------
      *
     c                   exsr      SR1000
     c                   exsr      return

     C**************************************************************************
     C* SR1000: lesen #LBLBL1, um den status auf '80' zu setzen
     C*-------------------------------------------------------------------------
     C*
     C     SR1000        BEGSR
     C*
     c     KEYsr1000     klist
     c                   kfld                    #AEFIRM
     c                   kfld                    #AEBEJJ
     c                   kfld                    #AEBENR
     c                   kfld                    #AEBEPO
     C*
     c     KEYsr1000     chain     #LBLBL1
     C                   if        not %found(#LBLBL1)
     c                   eval      #STATUS      = #STATUSBEP
     c                   eval      #STATUSBEP   = '80'
     c                   update    #LBLBR
     c                   exsr      sr2000
     c                   endif

     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C* SR2000: weitere Routinen
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     C*
     C
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C***  UPDATE DATEI UBBEP                                                ***
     C*                 Bestell-Positionsteil BBEP                            
     C**************************************************************************
     C     UBBEP         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   EXSR      ERBLPOBBEP
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*-------------------------------------------------------------------------
     C                   Z-ADD     BLPOBEJJ      KYEPJH
     C                   MOVEL(P)  BLPOBENR      KYEPBE
     C                   Z-ADD     BLPOBEPO      KYEPPO
     C*-------------------------------------------------------------------------
     C                   MOVEA     '01CU    '    CHI
     C                   EXSR      CHBBEP
     C*-------------------------------------------------------------------------
     C     EPMEIN        IFEQ      TEMEIN
     C                   Z-ADD     WKBLPOBRMG    EPBRMG
     C                   ELSE
     C                   MOVEL     EPTENR        KYTUTE
     C                   MOVEL     EPMEIN        KYTUME
     C                   Z-ADD     WKBLPOBRMG    WKV2V1
     C                   EXSR      VTEUF
     C                   Z-ADD(H)  WKV2V1        EPBRMG
     C                   ENDIF
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '30'
     C     EPBEST        OREQ      '35'
     C     EPBEST        OREQ      '36'
     C                   MOVE      '36'          EPBEST
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '38'
     C     EPBEST        OREQ      '40'
     C     EPBEST        OREQ      '50'
     C     EPBEST        OREQ      '60'
     C*
     C     EPBRMG        IFGE      EPGLMG
     C                   MOVE      '60'          EPBEST
     C                   ELSE
     C                   MOVE      '50'          EPBEST
     C                   ENDIF
     C*--------------------------------------------------------
     C     EPBEST        WHENEQ    '45'
     C*
     C     EPBRMG        IFGE      EPGLMG
     C                   MOVE      '60'          EPBEST
     C                   ENDIF
     C*--------------------------------------------------------
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C                   SELECT
     C*--------------------------------------------------------
     C     CHI(06)       WHENNE    *ON
     C                   MOVEA     '01U     '    CHI
     C                   EXSR      CHBBEP
     C                   ENDSL
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C     ERBLPOBBEP    BEGSR
     C*
     C*-------------------------------------------------------------------------
     C                   Z-ADD     *ZERO         WKBLPOBRMG
     C*-------------------------------------------------------------------------
     C                   MOVEL(P)  KYBLPO        KYSAVE
     C                   MOVEL(P)  BLPO          D$DAST
     C*-------------------------------------------------------------------------
     C**      #          Z-ADD     BLPOBEJJ      KYBLPOBEJJ
     C**      #          MOVEL     BLPOBENR      KYBLPOBENR
     C**      #          Z-ADD     BLPOBEPO      KYBLPOBEPO
     C                   MOVE      *LOVAL        KYBLPOBLJJ
     C                   MOVE      *LOVAL        KYBLPOBLNR
     C                   MOVE      *LOVAL        KYBLPOBLPO
     C                   MOVEA     '03+     '    CHI
     C                   EXSR      CHBLPO
     C*-------------------------------------------------------------------------
     C     CHI(5)        DOWEQ     'J'
     C*--------------------------------------------------------
     C     BLPOFIRM      IFGT      KYBLPOFIRM
     C     BLPOBEJJ      ORGT      KYBLPOBEJJ
     C     BLPOBENR      ORGT      KYBLPOBENR
     C     BLPOBEPO      ORGT      KYBLPOBEPO
     C                   LEAVE
     C                   ENDIF
     C*--------------------------------------------------------
     C                   DO
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLPOTENR      KYTENR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHTEIL
     C*--------------------------------------------------------
     C                   Z-ADD     BLPOBLJJ      KYBLKOBLJJ
     C                   MOVEL(P)  BLPOBLNR      KYBLKOBLNR
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLKO
     C*
     C     BLKOBLJJ      IFNE      EXBLPOBLJJ
     C     BLKOBLNR      ORNE      EXBLPOBLNR
     C     BLKORPST      IFLT      '10'
     C                   ITER
     C                   ENDIF
     C                   ENDIF
     C*--------------------------------------------------------
     C                   MOVEL(P)  BLKOBLGA      KYBLPABLGA
     C                   MOVEA     '01C     '    CHI
     C                   EXSR      CHBLPA
     C*--------------------------------------------------------
     C                   MOVEL     BLPOMEIN      KYTUME
     C                   Z-ADD     BLPOMENG      WKV1V2
     C                   EXSR      VTEUF
     C                   Z-ADD     WKV1V2        WKBLPOMENG
     C*--------------------------------------------------------
     C                   SELECT
     C     BLPABLAT      WHENEQ    'RE '
     C                   ADD       WKBLPOMENG    WKBLPOBRMG
     C     BLPABLAT      WHENEQ    'BA '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C     BLPABLAT      OREQ      'GD '
     C     BLPARTKZ      ANDEQ     DAJNKZ
     C                   SUB       WKBLPOMENG    WKBLPOBRMG
     C                   ENDSL
     C*--------------------------------------------------------
     C                   ENDDO
     C*--------------------------------------------------------
     C                   MOVEA     '03R     '    CHI
     C                   EXSR      CHBLPO
     C*--------------------------------------------------------
     C                   ENDDO
     C*-------------------------------------------------------------------------
     C                   MOVEL     KYSAVE        KYBLPO
     C                   MOVEL     D$DAST        BLPO
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C*
     C**************************************************************************
     C***  DEFINITION DER WORKFELDER...                                      ***
     C**************************************************************************
     C     VLIKE         BEGSR
     C*
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKC001                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKTRPADUP2
     C     *LIKE         DEFINE    WKC001        WKBBUP
     C     *LIKE         DEFINE    TEDUPR        WKBAPR
     C     *LIKE         DEFINE    TEPDAV        WKBAPD
     C     *LIKE         DEFINE    DUN156        WKBUWT
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        ##CHI           + 7
     C     *LIKE         DEFINE    WKC001        ##RTCD
     C     *LIKE         DEFINE    WKC001        ##PGST
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIFMT          + 1
     C     *LIKE         DEFINE    WKC001        WKRTCD
     C     *LIKE         DEFINE    WKC001        WKTRTP
     C     *LIKE         DEFINE    WKC001        WKTRPA
     C     *LIKE         DEFINE    WKC001        WKIOKZ
     C     *LIKE         DEFINE    WKC001        WKI000
     C     *LIKE         DEFINE    WKC001        WKCFMT
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        MODJOM
     C     *LIKE         DEFINE    WKC001        MODMAS
     C     *LIKE         DEFINE    WKC001        MODWAO
     C     *LIKE         DEFINE    WKC001        MODHAW
     C     *LIKE         DEFINE    WKC001        MODEUC
     C     *LIKE         DEFINE    WKC001        WKTRDZZYKL
     C     *LIKE         DEFINE    WKC001        WKTRPAWACD      + 2
     C     *LIKE         DEFINE    WKC001        WKTRPAMWDA      + 9
     C     *LIKE         DEFINE    WKC001        WKTRPASKONTO
     C     *LIKE         DEFINE    WKC001        WKINF1
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKIN30
     C     *LIKE         DEFINE    WKC001        WKIN31
     C     *LIKE         DEFINE    WKC001        WKIN32
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKC001        WKFM04
     C     *LIKE         DEFINE    WKC001        WKBBEP
     C     *LIKE         DEFINE    WKC001        WKFENR          + 3
     C*-------------------------------------------------------------------------
     C***  ...ANHAND WKN...                                                  ***
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        I0              + 2
     C     *LIKE         DEFINE    WKN010        I1              + 2
     C     *LIKE         DEFINE    WKN010        I2              + 2
     C*--------------------------------------------------------
     C     *LIKE         DEFINE    WKN010        WKDATE          + 7
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
     C     *LIKE         DEFINE    BLPO          WKBLPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    KYBLPOBLJJ    OFBLPOBLJJ
     C     *LIKE         DEFINE    KYBLPOBLNR    OFBLPOBLNR
     C     *LIKE         DEFINE    KYBLPOBLPO    OFBLPOBLPO
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOBLPO      DSBLPOBLPO
     C     *LIKE         DEFINE    BLPONESU      DSBLPONESU
     C     *LIKE         DEFINE    BLPOKOW1      DSBLPOKOWT
     C     *LIKE         DEFINE    BLPOBEJJ      DSBLPOBEJJ
     C     *LIKE         DEFINE    BLPOBENR      DSBLPOBENR
     C     *LIKE         DEFINE    BLPOBEPO      DSBLPOBEPO
     C     *LIKE         DEFINE    BLPOWEJJ      DSBLPOWEJJ
     C     *LIKE         DEFINE    BLPOWENR      DSBLPOWENR
     C     *LIKE         DEFINE    BLPOUPOS      DSBLPOUPOS
     C     *LIKE         DEFINE    BLPOZUJJ      DSBLPOZUJJ
     C     *LIKE         DEFINE    BLPOZUNR      DSBLPOZUNR
     C     *LIKE         DEFINE    BLPOZUPO      DSBLPOZUPO
     C*
     C     *LIKE         DEFINE    BLPOBLPO      DSBLPONBLP
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    AEKOW1        WKKOWT
     C     *LIKE         DEFINE    AENESU        WKWERT
     C     *LIKE         DEFINE    AEMENG        WKMENG
     C     *LIKE         DEFINE    AEMEIN        WKMEIN
     C     *LIKE         DEFINE    TEGWNT        WKGWNT
     C*
     C     *LIKE         DEFINE    BLPOPRAR      WKTRPAOHBE
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    RTBLPOPROG    WKPROG
     C     *LIKE         DEFINE    RTBLPODANA    WKDANA
     C     *LIKE         DEFINE    RTBLPOFFLD    WKFFLD
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    DUN134        WKBLPOMENG
     C     *LIKE         DEFINE    DUN219        WKBLPONESU
     C     *LIKE         DEFINE    DUN219        WKBLPOPREI
     C     *LIKE         DEFINE    DUN134        W1BLPOMENG
     C     *LIKE         DEFINE    DUN219        W1BLPONESU
     C     *LIKE         DEFINE    DUN219        W1BLPOPREI
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOMENG      WKBLPOBRMG
     C     *LIKE         DEFINE    BLPOKOW1      WKDIFF
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    TEINPR        WKINPR
     C     *LIKE         DEFINE    DUN052        WKSKPZ
     C*-------------------------------------------------------------------------
     C     *LIKE         DEFINE    BLPOMENG      WKBLMG
     C     *LIKE         DEFINE    BLPOMENG      W1BLMG
     C*-------------------------------------------------------------------------
     C*
     C                   ENDSR
     C**************************************************************************
     C***                                                                    ***
     C**************************************************************************
     C     *inzsr        BEGSR
     C                   MOVE      *BLANK        WKC001            1
     C                   Z-ADD     *ZERO         WKN010            1 0
     C                   Z-ADD     *ZERO         WKN219           21 9
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
     C/COPY QCPYSRC,CHBBEP
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,VTEUF
     C/COPY QCPYSRC,CHBLPA
     C/COPY QCPYSRC,CHBLKO
     C/COPY QCPYSRC,CHBLPO
     C/COPY QCPYSRC,CHTEUF
