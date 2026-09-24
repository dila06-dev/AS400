     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*                      GANG                                *
     F*                      bar_kalk                            *
     F*                      Prodtst88                           *
     F*                                                          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
     F************************************************************

     flbsd      ip   e             disk
     flbpl01    if   e           k disk
     fprj605p   uf a e           k disk
     fprj605p2  uf a e           k disk
     fprj605p3  uf a e           k disk
     ftrtp00    if   e           k disk
     fsystempf  if   e           k disk

     DDate             S               D   DATFMT(*ISO)

     C*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1

     C* --------------------------------------------------
      *
     c                   seton                                        33
     C                   setoff                                       50
     C                   if        LDLANR  = '714'
     C                   clear                   p                 1
     C                   endif
     c                   exsr      SR1000
     c  n50              exsr      SR2000
     c                   setoff                                       33

     C**************************************************************************
     C* SR1000: lesen lbpl01
     C*-------------------------------------------------------------------------
     C*
     C     SR1000        BEGSR
     C*
     C     *LIKE         DEFINE    LLFIRM        #LLFIRM
     C     *LIKE         DEFINE    LLLANR        #LLLANR
     c* einzelne Lagerplätze
     c     sr1000k       klist
     c                   kfld                    #LLFIRM
     c                   kfld                    #LLLANR
     c
     c                   movel     '01'          #LLFIRM
     c                   movel     LDLANR        #LLLANR
     c
     c     sr1000k       setll     lbpl01
     c                   DOU       %eof(lbpl01)
     c     sr1000k       READE     lbpl01
     c                   IF        not %eof(lbpl01) and #LLFIRM = llfirm
     c                                              and #LLLANR = LLLANR

     C                   clear                   PRJ605F
     C                   clear                   PRJ605F2
     c                   movel     LLLORT        lo
     C                   movel     LDFREM        kz2
     c                   movel     'J'           KZB
     C                   eval      %subst(bez: 1: 03)= %subst(LDLANR: 01: 03)
     C                   eval      %subst(bez: 5: 16)= %subst(LDLBZ1: 01: 16)
     C                   movel     '0'           k7
     C                   if        LDQSWE  = 'J'
     C                   movel     '0'           k7
     C                   endif
     C                   seton                                        50

     c     lo            chain     prj605p
     C                   if        not %found(prj605p)
     c                   write     PRJ605F
     c                   ELSE
     c   33              update    PRJ605F
     c                   endif

     c     lo            chain     prj605p2
     C                   if        not %found(prj605p2)
     c                   write     PRJ605F2
     c                   ELSE
     c   33              update    PRJ605F2
     c                   endif

     c                   ENDIF
     C                   ENDDO
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C* SR2000: keine Fachsätze vorhanden
     C*-------------------------------------------------------------------------
     C*
     C     SR2000        BEGSR
     C*
     C                   clear                   PRJ605F
     C                   clear                   PRJ605F2
     c                   movel     '000 #000'    lo
     c                   movel     ldlanr        lo
     C                   movel     LDFREM        kz2
     c                   movel     'J'           KZB
     C                   eval      %subst(bez: 1: 03)= %subst(LDLANR: 01: 03)
     C                   eval      %subst(bez: 5: 16)= %subst(LDLBZ1: 01: 16)
     C                   movel     '0'           k7
     C                   if        LDQSWE  = 'J'
     C                   movel     '0'           k7
     C                   endif

     c     lo            chain     prj605p
     C                   if        not %found(prj605p)
     c                   write     PRJ605F
     c                   ELSE
     c   33              update    PRJ605F
     c                   endif

     c     lo            chain     prj605p2
     C                   if        not %found(prj605p2)
     c                   write     PRJ605F2
     c                   ELSE
     c   33              update    PRJ605F2
     c                   endif

     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* SR5500: lesen trtp00, um zu ermitteln, ob ein Lieferant mit 90733
     C*         gelesen werden muss
     C*
     C*-------------------------------------------------------------------------
     C*
     C     SR5500        BEGSR
     C*
     c     KEY5500       klist
     c                   kfld                    tpfirm
     c                   kfld                    tpspcd
     c                   kfld                    tptart
     c                   kfld                    tptcde
     C*
     c                   clear                   sabe              3
     c***                eval      sabe = %subst(testlf: 03: 3)
     C*
     C                   movel     '01'          tpfirm
     C                   movel     'D'           tpspcd
     C                   movel     'SABE      '  tptart
     C                   clear                   tptcde
     C*  41              movel     #TESAAV       tptcde
     C*
     c     KEY5500       chain     trtp00
     c                   IF        %found(trtp00)
     c                   else
     c                   clear                   TPTTXT
     c                   ENDIF
     C*
     C     ##5500        ENDSR
     C*
     C**************************************************************************
     C* SR9050: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9800        BEGSR
     C*
     C     KEY9800       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c     KEY9800       chain     systempf
     c                   IF        %found(systempf)
     c*
     c                   ENDIF
     C*
     C     ##9800        ENDSR
     C*
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     c                   move      '01'          firma             2
     c                   movel     'LP1'         begr              3
     C                   ENDSR

