     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ********************************************************************************        
      *                                                                        
      * SELECT TPTCDE,TPTTXT FROM trtp WHERE TPFIRM ='01' and TPTART           
      * ='$$RAB_A' and TPTFLG =0 and TPSPCD ='D'                               
      *                                                                        
      * clrpfm #RAB000                                                         
      * clrpfm rabattgr                                                        
      * clrpfm rabattgr2                                                       
      * clrpfm rabattgr3                                                       
      *                                                                        
      *                                                                        
      * Änderungsprotokoll:...                                                
      *
      *********************************************************************************

     f#RAB000   uf a e             disk

     frabattgrl1if a e           k disk
     f                                        USROPN

     ftrtp01    if a e           k disk

     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     I*-------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying
     C**************************************************************************
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------

     C                   exsr      srvorlauf
     C                   exsr      srtpinit
     C                   seton                                        50

     C                   open      rabattgrl1
     C                   DO        *HIVAL
     C*
     C                   READ      rabattgrl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        KOKDLG  = '0541'
     C                   eval      KOKDLG  = '0541'
     C                   endif
     C*                  KOPRGR, KOKDLG
     c                   if        #KOPRGR <> ' ' and
     c                             #KOPRGR <> KOPRGR
     c                   if        KOPRGR_ <> ' '
     c                   exsr      srwrite
     c                   endif
     c                   exsr      srclear
     c                   endif
     C                   movel     KOPRGR        #KOPRGR           4
     C                   exsr      srlines
     c                   endif
     C                   enddo
     c                   exsr      srwrite
     C                   close     rabattgrl1

     **************      Rabatt
     c                   clear                   #KOPRGR

     C                   open      rabattgrl1
     C                   DO        *HIVAL
     C*
     C                   READ      rabattgrl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C*                  KOPRGR, KOKDLG
     c                   if        #KOPRGR <> ' ' and
     c                             #KOPRGR <> KOPRGR
     c                   if        KOPRGR_ <> ' '
     c                   exsr      srwrite
     c                   endif
     c                   exsr      srclear
     c                   endif
     C                   movel     KOPRGR        #KOPRGR           4
     C                   movel     KORB01        KORABA
     C                   exsr      srlines
     c                   endif
     C                   enddo
     c                   exsr      srwrite
     C                   close     rabattgrl1

     **************      Menge
     c                   clear                   #KOPRGR

     C                   open      rabattgrl1
     C                   DO        *HIVAL
     C*
     C                   READ      rabattgrl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C*                  KOPRGR, KOKDLG
     c                   if        #KOPRGR <> ' ' and
     c                             #KOPRGR <> KOPRGR
     c                   if        KOPRGR_ <> ' '
     c                   eval      KODESCR =
     c                             'Staffelrabattmenge 1 =======>'
     c                   exsr      srwrite
     c                   endif
     c                   exsr      srclear
     c                   endif
     C                   movel     KOPRGR        #KOPRGR           4
     C                   z-add     KOMG01        KORABA
     C                   exsr      srlines
     c                   endif
     C                   enddo
     c                   exsr      srwrite
     C                   close     rabattgrl1

     **************      Rabatt
     c                   clear                   #KOPRGR

     C                   open      rabattgrl1
     C                   DO        *HIVAL
     C*
     C                   READ      rabattgrl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C*                  KOPRGR, KOKDLG
     c                   if        #KOPRGR <> ' ' and
     c                             #KOPRGR <> KOPRGR
     c                   if        KOPRGR_ <> ' '
     c                   exsr      srwrite
     c                   endif
     c                   exsr      srclear
     c                   endif
     C                   movel     KOPRGR        #KOPRGR           4
     C                   movel     KORB02        KORABA
     C                   exsr      srlines
     c                   endif
     C                   enddo
     c                   exsr      srwrite
     C                   close     rabattgrl1


     **************      Menge
     c                   clear                   #KOPRGR

     C                   open      rabattgrl1
     C                   DO        *HIVAL
     C*
     C                   READ      rabattgrl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C*                  KOPRGR, KOKDLG
     c                   if        #KOPRGR <> ' ' and
     c                             #KOPRGR <> KOPRGR
     c                   if        KOPRGR_ <> ' '
     c                   eval      KODESCR =
     c                             'Staffelrabattmenge 2 =======>'
     c                   exsr      srwrite
     c                   endif
     c                   exsr      srclear
     c                   endif
     C                   movel     KOPRGR        #KOPRGR           4
     C                   z-add     KOMG02        KORABA
     C                   exsr      srlines
     c                   endif
     C                   enddo
     c                   exsr      srwrite
     C                   close     rabattgrl1

     C*
     C                   EXSR      RETURN

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srlines       BEGSR
     C*
     c
     C*                 update bestand pflege über call trtrtpst
     c     key001        klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     '$$RAB_A'     TPTART
     c                   movel     KOKDLG        TPTCDE
     c                   clear                   #TPTTXT           3
     c     key001        chain     trtp01                             97
     c   97              clear                   TPTTXT
     c  n97              eval      #TPTTXT = %subst(TPTTXT:1:3)
     c  n97              TESTN                   #TPTTXT              98
     c  n97*IN(98)       IFNE      '1'
     c                   else
     c                   exsr      srselect
     c                   endif
     C*
     C     ##srlines     ENDSR

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srselect      BEGSR
     C*
     c
     C*                 update bestand
     c   50              eval      KOPRGR_=#KOPRGR
     c   50              exsr      srKODESCR
     c  n50              movel     $KOKDLG       KOKDLG
     c  n50              eval      KOPRGR_  ='PG'
     c  n50              eval      KODESCR  ='Bezeichnung'
     c                   select
     c                   when      #TPTTXT='001'
     c   50              eval      KORABA01 = KORABA
     c  n50              eval      KORABA01 = $KOKDLG*1
     c                   when      #TPTTXT='002'
     c   50              eval      KORABA02 = KORABA
     c  n50              eval      KORABA02 = $KOKDLG*1
     c                   when      #TPTTXT='003'
     c   50              eval      KORABA03 = KORABA
     c  n50              eval      KORABA03 = $KOKDLG*1
     c                   when      #TPTTXT='004'
     c   50              eval      KORABA04 = KORABA
     c  n50              eval      KORABA04 = $KOKDLG*1
     c                   when      #TPTTXT='005'
     c   50              eval      KORABA05 = KORABA
     c  n50              eval      KORABA05 = $KOKDLG*1
     c                   when      #TPTTXT='006'
     c   50              eval      KORABA06 = KORABA
     c  n50              eval      KORABA06 = $KOKDLG*1
     c                   when      #TPTTXT='007'
     c   50              eval      KORABA07 = KORABA
     c  n50              eval      KORABA07 = $KOKDLG*1
     c                   when      #TPTTXT='008'
     c   50              eval      KORABA08 = KORABA
     c  n50              eval      KORABA08 = $KOKDLG*1
     c                   when      #TPTTXT='009'
     c   50              eval      KORABA09 = KORABA
     c  n50              eval      KORABA09 = $KOKDLG*1
     c                   when      #TPTTXT='010'
     c   50              eval      KORABA10 = KORABA
     c  n50              eval      KORABA10 = $KOKDLG*1
     c                   when      #TPTTXT='011'
     c   50              eval      KORABA11 = KORABA
     c  n50              eval      KORABA11 = $KOKDLG*1
     c                   when      #TPTTXT='012'
     c   50              eval      KORABA12 = KORABA
     c  n50              eval      KORABA12 = $KOKDLG*1
     c                   when      #TPTTXT='013'
     c   50              eval      KORABA13 = KORABA
     c  n50              eval      KORABA13 = $KOKDLG*1
     c                   when      #TPTTXT='014'
     c   50              eval      KORABA14 = KORABA
     c  n50              eval      KORABA14 = $KOKDLG*1
     c                   when      #TPTTXT='015'
     c   50              eval      KORABA15 = KORABA
     c  n50              eval      KORABA15 = $KOKDLG*1
     c                   when      #TPTTXT='016'
     c   50              eval      KORABA16 = KORABA
     c  n50              eval      KORABA16 = $KOKDLG*1
     c                   when      #TPTTXT='017'
     c   50              eval      KORABA17 = KORABA
     c  n50              eval      KORABA17 = $KOKDLG*1
     c                   when      #TPTTXT='018'
     c   50              eval      KORABA18 = KORABA
     c  n50              eval      KORABA18 = $KOKDLG*1
     c                   when      #TPTTXT='019'
     c   50              eval      KORABA19 = KORABA
     c  n50              eval      KORABA19 = $KOKDLG*1
     c                   when      #TPTTXT='020'
     c   50              eval      KORABA20 = KORABA
     c  n50              eval      KORABA20 = $KOKDLG*1
     c                   when      #TPTTXT='021'
     c   50              eval      KORABA21 = KORABA
     c  n50              eval      KORABA21 = $KOKDLG*1
     c                   when      #TPTTXT='022'
     c   50              eval      KORABA22 = KORABA
     c  n50              eval      KORABA22 = $KOKDLG*1
     c                   when      #TPTTXT='023'
     c   50              eval      KORABA23 = KORABA
     c  n50              eval      KORABA23 = $KOKDLG*1
     c                   when      #TPTTXT='024'
     c   50              eval      KORABA24 = KORABA
     c  n50              eval      KORABA24 = $KOKDLG*1
     c                   when      #TPTTXT='025'
     c   50              eval      KORABA25 = KORABA
     c  n50              eval      KORABA25 = $KOKDLG*1
     c                   when      #TPTTXT='026'
     c   50              eval      KORABA26 = KORABA
     c  n50              eval      KORABA26 = $KOKDLG*1
     c                   when      #TPTTXT='027'
     c   50              eval      KORABA27 = KORABA
     c  n50              eval      KORABA27 = $KOKDLG*1
     c                   when      #TPTTXT='028'
     c   50              eval      KORABA28 = KORABA
     c  n50              eval      KORABA28 = $KOKDLG*1
     c                   when      #TPTTXT='029'
     c   50              eval      KORABA29 = KORABA
     c  n50              eval      KORABA29 = $KOKDLG*1
     c                   when      #TPTTXT='030'
     c   50              eval      KORABA30 = KORABA
     c  n50              eval      KORABA30 = $KOKDLG*1
     c                   when      #TPTTXT='031'
     c   50              eval      KORABA31 = KORABA
     c  n50              eval      KORABA31 = $KOKDLG*1
     c                   when      #TPTTXT='032'
     c   50              eval      KORABA32 = KORABA
     c  n50              eval      KORABA32 = $KOKDLG*1
     c                   when      #TPTTXT='033'
     c   50              eval      KORABA33 = KORABA
     c  n50              eval      KORABA33 = $KOKDLG*1
     c                   when      #TPTTXT='034'
     c   50              eval      KORABA34 = KORABA
     c  n50              eval      KORABA34 = $KOKDLG*1
     c                   when      #TPTTXT='035'
     c   50              eval      KORABA35 = KORABA
     c  n50              eval      KORABA35 = $KOKDLG*1
     c                   when      #TPTTXT='036'
     c   50              eval      KORABA36 = KORABA
     c  n50              eval      KORABA36 = $KOKDLG*1
     c                   when      #TPTTXT='037'
     c   50              eval      KORABA37 = KORABA
     c  n50              eval      KORABA37 = $KOKDLG*1
     c                   when      #TPTTXT='038'
     c   50              eval      KORABA38 = KORABA
     c  n50              eval      KORABA38 = $KOKDLG*1
     c                   when      #TPTTXT='039'
     c   50              eval      KORABA39 = KORABA
     c  n50              eval      KORABA39 = $KOKDLG*1
     c                   when      #TPTTXT='040'
     c   50              eval      KORABA40 = KORABA
     c  n50              eval      KORABA40 = $KOKDLG*1
     c                   when      #TPTTXT='041'
     c   50              eval      KORABA41 = KORABA
     c  n50              eval      KORABA41 = $KOKDLG*1
     c                   when      #TPTTXT='042'
     c   50              eval      KORABA42 = KORABA
     c  n50              eval      KORABA42 = $KOKDLG*1
     c                   when      #TPTTXT='043'
     c   50              eval      KORABA43 = KORABA
     c  n50              eval      KORABA43 = $KOKDLG*1
     c                   when      #TPTTXT='044'
     c   50              eval      KORABA44 = KORABA
     c  n50              eval      KORABA44 = $KOKDLG*1
     c                   when      #TPTTXT='045'
     c   50              eval      KORABA45 = KORABA
     c  n50              eval      KORABA45 = $KOKDLG*1
     c                   when      #TPTTXT='046'
     c   50              eval      KORABA46 = KORABA
     c  n50              eval      KORABA46 = $KOKDLG*1
     c                   when      #TPTTXT='047'
     c   50              eval      KORABA47 = KORABA
     c  n50              eval      KORABA47 = $KOKDLG*1
     c                   when      #TPTTXT='048'
     c   50              eval      KORABA48 = KORABA
     c  n50              eval      KORABA48 = $KOKDLG*1
     c                   when      #TPTTXT='049'
     c   50              eval      KORABA49 = KORABA
     c  n50              eval      KORABA49 = $KOKDLG*1
     c                   when      #TPTTXT='050'
     c   50              eval      KORABA50 = KORABA
     c  n50              eval      KORABA50 = $KOKDLG*1
     c                   when      #TPTTXT='051'
     c   50              eval      KORABA51 = KORABA
     c  n50              eval      KORABA51 = $KOKDLG*1
     c                   when      #TPTTXT='052'
     c   50              eval      KORABA52 = KORABA
     c  n50              eval      KORABA52 = $KOKDLG*1
     c                   when      #TPTTXT='053'
     c   50              eval      KORABA53 = KORABA
     c  n50              eval      KORABA53 = $KOKDLG*1
     c                   when      #TPTTXT='054'
     c   50              eval      KORABA54 = KORABA
     c  n50              eval      KORABA54 = $KOKDLG*1
     c                   when      #TPTTXT='055'
     c   50              eval      KORABA55 = KORABA
     c  n50              eval      KORABA55 = $KOKDLG*1
     c                   when      #TPTTXT='056'
     c   50              eval      KORABA56 = KORABA
     c  n50              eval      KORABA56 = $KOKDLG*1
     c                   when      #TPTTXT='057'
     c   50              eval      KORABA57 = KORABA
     c  n50              eval      KORABA57 = $KOKDLG*1
     c                   when      #TPTTXT='058'
     c   50              eval      KORABA58 = KORABA
     c  n50              eval      KORABA58 = $KOKDLG*1
     c                   when      #TPTTXT='059'
     c   50              eval      KORABA59 = KORABA
     c  n50              eval      KORABA59 = $KOKDLG*1
     c                   when      #TPTTXT='060'
     c   50              eval      KORABA60 = KORABA
     c  n50              eval      KORABA60 = $KOKDLG*1
     c                   when      #TPTTXT='061'
     c   50              eval      KORABA61 = KORABA
     c  n50              eval      KORABA61 = $KOKDLG*1
     c                   when      #TPTTXT='062'
     c   50              eval      KORABA62 = KORABA
     c  n50              eval      KORABA62 = $KOKDLG*1
     c                   when      #TPTTXT='063'
     c   50              eval      KORABA63 = KORABA
     c  n50              eval      KORABA63 = $KOKDLG*1
     c                   when      #TPTTXT='064'
     c   50              eval      KORABA64 = KORABA
     c  n50              eval      KORABA64 = $KOKDLG*1
     c                   when      #TPTTXT='065'
     c   50              eval      KORABA65 = KORABA
     c  n50              eval      KORABA65 = $KOKDLG*1
     c                   when      #TPTTXT='066'
     c   50              eval      KORABA66 = KORABA
     c  n50              eval      KORABA66 = $KOKDLG*1
     c                   when      #TPTTXT='067'
     c   50              eval      KORABA67 = KORABA
     c  n50              eval      KORABA67 = $KOKDLG*1
     c                   when      #TPTTXT='068'
     c   50              eval      KORABA68 = KORABA
     c  n50              eval      KORABA68 = $KOKDLG*1
     c                   when      #TPTTXT='069'
     c   50              eval      KORABA69 = KORABA
     c  n50              eval      KORABA69 = $KOKDLG*1
     c                   when      #TPTTXT='070'
     c   50              eval      KORABA70 = KORABA
     c  n50              eval      KORABA70 = $KOKDLG*1
     c                   when      #TPTTXT='071'
     c   50              eval      KORABA71 = KORABA
     c  n50              eval      KORABA71 = $KOKDLG*1
     c                   when      #TPTTXT='072'
     c   50              eval      KORABA72 = KORABA
     c  n50              eval      KORABA72 = $KOKDLG*1
     c                   when      #TPTTXT='073'
     c   50              eval      KORABA73 = KORABA
     c  n50              eval      KORABA73 = $KOKDLG*1
     c                   when      #TPTTXT='074'
     c   50              eval      KORABA74 = KORABA
     c  n50              eval      KORABA74 = $KOKDLG*1
     c                   when      #TPTTXT='075'
     c   50              eval      KORABA75 = KORABA
     c  n50              eval      KORABA75 = $KOKDLG*1
     c                   when      #TPTTXT='076'
     c   50              eval      KORABA76 = KORABA
     c  n50              eval      KORABA76 = $KOKDLG*1
     c                   when      #TPTTXT='077'
     c   50              eval      KORABA77 = KORABA
     c  n50              eval      KORABA77 = $KOKDLG*1
     c                   when      #TPTTXT='078'
     c   50              eval      KORABA78 = KORABA
     c  n50              eval      KORABA78 = $KOKDLG*1
     c                   when      #TPTTXT='079'
     c   50              eval      KORABA79 = KORABA
     c  n50              eval      KORABA79 = $KOKDLG*1
     c                   when      #TPTTXT='080'
     c   50              eval      KORABA80 = KORABA
     c  n50              eval      KORABA80 = $KOKDLG*1
     c                   other
     c                   endsl
     C*
     C     ##srselect    ENDSR

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srtpinit      BEGSR
     C*
     c
     C*                 update bestand
     c                   z-add     001           $KOKDLG           3 0
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     '$$RAB_A'     TPTART
     c
     C                   DO        *HIVAL
     c
     c                   clear                   TPTCDE
     c                   movel     $KOKDLG       TPTCDE
     c                   clear                   #TPTTXT           3
     c     key001        chain     trtp01                             97
     c   97              clear                   TPTTXT
     c
     c   97              movel     $KOKDLG       TPTCDE
     c   97              eval      TPTCDE  = '0'                +
     c                                       %subst(TPTCDE:1:3)
     c   97key001        chain     trtp01                             97
     c   97              clear                   TPTTXT
     c
     c  n97              eval      #TPTTXT = %subst(TPTTXT:1:3)
     c  n97              TESTN                   #TPTTXT              98
     c  n97*IN(98)       IFNE      '1'
     c                   else
     c                   exsr      srselect
     c                   endif
     c                   eval      $KOKDLG = $KOKDLG + 1
     c                   if        $KOKDLG  > 998
     c                   leave
     c                   endif
     C                   enddo
     c                   write     #RAB000r
     c                   exsr      srclear
     C*
     C     ##tpinits     ENDSR

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srKODESCR     BEGSR
     C*
     C*                 update bestand
     c                   z-add     001           $KOKDLG           3 0
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     'PRGR   '     TPTART
     c
     c                   movel     KOPRGR_       TPTCDE
     c     key001        chain     trtp01                             97
     c   97              clear                   TPTTXT
     c  n97              movel     TPTTXT        KODESCR
     C*
     C     ##KODESCR     ENDSR

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srclear       BEGSR
     C*
     c
     C*                 update bestand
     c                   clear                   KOPRGR_
     c                   clear                   KODESCR
     c                   clear                   KORABA01
     c                   clear                   KORABA02
     c                   clear                   KORABA03
     c                   clear                   KORABA04
     c                   clear                   KORABA05
     c                   clear                   KORABA06
     c                   clear                   KORABA07
     c                   clear                   KORABA08
     c                   clear                   KORABA09
     c                   clear                   KORABA10
     c                   clear                   KORABA11
     c                   clear                   KORABA12
     c                   clear                   KORABA13
     c                   clear                   KORABA14
     c                   clear                   KORABA15
     c                   clear                   KORABA16
     c                   clear                   KORABA17
     c                   clear                   KORABA18
     c                   clear                   KORABA19
     c                   clear                   KORABA20
     c                   clear                   KORABA21
     c                   clear                   KORABA22
     c                   clear                   KORABA23
     c                   clear                   KORABA24
     c                   clear                   KORABA25
     c                   clear                   KORABA26
     c                   clear                   KORABA27
     c                   clear                   KORABA28
     c                   clear                   KORABA29
     c                   clear                   KORABA30
     c                   clear                   KORABA31
     c                   clear                   KORABA32
     c                   clear                   KORABA33
     c                   clear                   KORABA34
     c                   clear                   KORABA35
     c                   clear                   KORABA36
     c                   clear                   KORABA37
     c                   clear                   KORABA38
     c                   clear                   KORABA39
     c                   clear                   KORABA40
     c                   clear                   KORABA41
     c                   clear                   KORABA42
     c                   clear                   KORABA43
     c                   clear                   KORABA44
     c                   clear                   KORABA45
     c                   clear                   KORABA46
     c                   clear                   KORABA47
     c                   clear                   KORABA48
     c                   clear                   KORABA49
     c                   clear                   KORABA50
     c                   clear                   KORABA51
     c                   clear                   KORABA52
     c                   clear                   KORABA53
     c                   clear                   KORABA54
     c                   clear                   KORABA55
     c                   clear                   KORABA56
     c                   clear                   KORABA57
     c                   clear                   KORABA58
     c                   clear                   KORABA59
     c                   clear                   KORABA60
     c                   clear                   KORABA61
     c                   clear                   KORABA62
     c                   clear                   KORABA63
     c                   clear                   KORABA64
     c                   clear                   KORABA65
     c                   clear                   KORABA66
     c                   clear                   KORABA67
     c                   clear                   KORABA68
     c                   clear                   KORABA69
     c                   clear                   KORABA70
     c                   clear                   KORABA71
     c                   clear                   KORABA72
     c                   clear                   KORABA73
     c                   clear                   KORABA74
     c                   clear                   KORABA75
     c                   clear                   KORABA76
     c                   clear                   KORABA77
     c                   clear                   KORABA78
     c                   clear                   KORABA79
     c                   clear                   KORABA80
     C*
     C     ##clear       ENDSR

     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srwrite       BEGSR
     C*
     c
     C*                 update bestand
     c                   if        KORABA01 <> 0 or  KORABA02 <> 0 or
     c                             KORABA03 <> 0 or  KORABA04 <> 0 or
     c                             KORABA05 <> 0 or  KORABA06 <> 0 or
     c                             KORABA07 <> 0 or  KORABA08 <> 0 or
     c                             KORABA09 <> 0 or  KORABA10 <> 0 or
     c                             KORABA11 <> 0 or  KORABA12 <> 0 or
     c                             KORABA13 <> 0 or  KORABA14 <> 0 or
     c                             KORABA15 <> 0 or  KORABA16 <> 0 or
     c                             KORABA17 <> 0 or  KORABA18 <> 0 or
     c                             KORABA19 <> 0 or  KORABA20 <> 0 or
     c                             KORABA21 <> 0 or  KORABA22 <> 0 or
     c                             KORABA23 <> 0 or  KORABA24 <> 0 or
     c                             KORABA25 <> 0 or  KORABA26 <> 0 or
     c                             KORABA27 <> 0 or  KORABA28 <> 0 or
     c                             KORABA29 <> 0 or  KORABA30 <> 0 or
     c                             KORABA31 <> 0 or  KORABA32 <> 0 or
     c                             KORABA33 <> 0 or  KORABA34 <> 0 or
     c                             KORABA35 <> 0 or  KORABA36 <> 0 or
     c                             KORABA37 <> 0 or  KORABA38 <> 0 or
     c                             KORABA39 <> 0 or  KORABA40 <> 0 or
     c                             KORABA41 <> 0 or  KORABA42 <> 0 or
     c                             KORABA43 <> 0 or  KORABA44 <> 0 or
     c                             KORABA45 <> 0 or  KORABA46 <> 0 or
     c                             KORABA47 <> 0 or  KORABA48 <> 0 or
     c                             KORABA49 <> 0 or  KORABA50 <> 0 or
     c                             KORABA51 <> 0 or  KORABA52 <> 0 or
     c                             KORABA53 <> 0 or  KORABA54 <> 0 or
     c                             KORABA55 <> 0 or  KORABA56 <> 0 or
     c                             KORABA57 <> 0 or  KORABA58 <> 0 or
     c                             KORABA59 <> 0 or  KORABA60 <> 0 or
     c                             KORABA61 <> 0 or  KORABA62 <> 0 or
     c                             KORABA63 <> 0 or  KORABA64 <> 0 or
     c                             KORABA65 <> 0 or  KORABA66 <> 0 or
     c                             KORABA67 <> 0 or  KORABA68 <> 0 or
     c                             KORABA69 <> 0 or  KORABA70 <> 0 or
     c                             KORABA71 <> 0 or  KORABA72 <> 0 or
     c                             KORABA73 <> 0 or  KORABA74 <> 0 or
     c                             KORABA75 <> 0 or  KORABA76 <> 0 or
     c                             KORABA77 <> 0 or  KORABA78 <> 0 or
     c                             KORABA79 <> 0 or  KORABA80 <> 0
     c                   write     #RAB000r
     c                   endif
     c***                write     #RAB000r
     C*
     C     ##write       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     srvorlauf     BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     C*alle filtern, eigentlich nur RP5 und RP6 aber da Kunde KOKDLI
     C*auf *blank passt das
     C*A n d r e a
     c*/exec sql
     c*+ insert into tvrelwaeco/RABATTGR
     c*+ SELECT KOBEGR, KOKDLG, KOPRGR, KOWACD, KOGADA, KOGBDA, KORABA,
     c*+ KOMG01, KOMG02, KORB01, KORB02 FROM kond01 WHERE KOKDLI = ' ' and
     c*+ KOBEGR in ('RP1', 'RP2', 'RP3', 'RP4', 'RP5', 'RP6') and kofirm =
     c*+ '01' and (date(substr(char(KOGADA), 1, 4) concat '-' concat
     c*+ substr(char(KOGADA), 5, 2) concat '-' concat substr(char(KOGADA),
     c*+ 7, 2))) < current date
     c*/end-exec

     C*alle filtern, eigentlich nur RP5 und RP6 aber da Kunde KOKDLI
     C*auf *blank passt das
     c/exec sql
     c+ insert into tvrelwaeco/RABATTGR
     c+ SELECT KOBEGR, KOKDLG, KOPRGR, KOWACD, KOGADA, KOGBDA, KORABA,
     c+ KOMG01, KOMG02, KORB01, KORB02, kokdli
     c+            FROM kond01 WHERE (KOKDLI='001245' or
     c+ (KOBEGR in ('RP1', 'RP2', 'RP3', 'RP4', 'RP5', 'RP6')
     c+    and KOKDLI =' '))                                 and kofirm =
     c+ '01' and (date(substr(char(KOGADA), 1, 4) concat '-' concat
     c+ substr(char(KOGADA), 5, 2) concat '-' concat substr(char(KOGADA),
     c+ 7, 2))) < current date
     c+  order by KOBEGR
     c+
     c/end-exec


     C*Datum bei *zero initialisieren mit current date
     c/exec sql
     c+ update    rabattGR  set kogbda =
     c+ zoned(('20') concat
     c+ substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)
     c+ where kogbda =0
     c/end-exec

     C*obsolete löschen
     c/exec sql
     c+ delete  from rabattgr where
     c+          (date(substr(char(KOGBDA), 1, 4) concat '-' concat
     c+ substr(char(KOGBDA), 5, 2) concat '-' concat substr(char(KOGBDA),
     c+ 7, 2))) < current date
     c/end-exec

     C*Ermittlung doppelter Gültigkeiten
     c/exec sql
     c+ insert into tvrelwaeco/RABATTGR2
     c+ SELECT KOBEGR, KOKDLG, KOPRGR, KOWACD, count(*)
     c+ from rabattgr GROUP BY KOBEGR, KOKDLG, KOPRGR, KOWACD
     c+ HAVING count(*) > 1
     c/end-exec

     C*Ermittlung Ablage bei Mehrfachvorkommen der des gültigen Satzes
     c/exec sql
     c+ insert into tvrelwaeco/RABATTGR3
     c+ SELECT max(B.KOBEGR) KOBEGR, max(B.KOKDLG) KOKDLG, max(B.KOPRGR)
     c+ KOPRGR, max(B.KOWACD) KOWACD , max(B.KOGADA) KOGADA , min(B.KOGBDA)
     c+ KOGBDA , max(B.KOKDLG) KOKDLG FROM rabattgr b, rabattgr2 a WHERE
     c+ a.KOBEGR= b.KOBEGR and a.KOKDLG= b.KOKDLG and a.KOPRGR= b.KOPRGR
     c+ and a.KOWACD= b.KOWACD
     c/end-exec

      *für Prüfzwecke
      *SELECT * FROM rabattgr  a
      *WHERE a.KOBEGR in (select b.KOBEGR from rabattgr2 b where
      *a.KOKDLG= b.KOKDLG and a.KOPRGR= b.KOPRGR and a.KOWACD= b.KOWACD)

     C*löschen der nicht relevanten Sätze
     c/exec sql
     c+ delete   FROM rabattgr a WHERE a.KOBEGR in (select b.KOBEGR from
     c+ rabattgr3 b where a.KOKDLG= b.KOKDLG and a.KOPRGR= b.KOPRGR and
     c+ a.KOWACD= b.KOWACD and (a.KOGADA<>b.KOGADA or
     c+ a.KOGBDA<> b.KOGBDA))
     c/end-exec


     C     ##vorlauf     ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     c/exec sql
     c+   create index TVRELWAECO/rabattgrl1
     c+   on TVRELWAECO/rabattgr
     c+   (KOPRGR, KOKDLG)
     c/end-exec

     c/exec sql
     c+   delete from TVRELWAECO/#RAB000
     c/end-exec


     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
      *
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/#RAB000';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/rabattgr';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/rabattgr2';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/rabattgr3';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
