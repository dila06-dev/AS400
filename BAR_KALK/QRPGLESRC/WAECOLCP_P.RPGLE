     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*                                                          *
     F* update waecolcp b set b.lcp050        =                  *
     F* (select a.wekpr from bar_kalk/kalk_file a                *
     F*         where b.lcp030= a.artnr and                      *
     F*               a."VERSION"='MO20091123')                  *
     F* where exists                                             *
     F* (select a.wekpr from bar_kalk/kalk_file a                *
     F*         where b.lcp030= a.artnr and                      *
     F*               a."VERSION"='MO20091123')                  *
     F*  and LCP040 = 2010                                       *
     F* 16516 Zeilen in WAECOLCP in QS36F aktualisiert.          *
     F************************************************************
     F* PROGRAMMFUNKTION:                                        *
     F************************************************************

     fkalk_file1up   e             disk
     fwaecolcp  uf a e           k disk
     fsystempf  if   e           k disk

     DDate             S               D   DATFMT(*ISO)

     I*-------------------------------------------------bot---------------------
     IKALK_F1
     I              status                      §status
     I
     I*-------------------------------------------------bot---------------------
     I*-------------------------------------------------------------------------
     c*  Schlüsselliste für waecolcp
     c     artkey        klist
     c                   kfld                    LCP010
     c                   kfld                    LiefNr
     c                   kfld                    ArtNr
     c                   kfld                    Jahr

     C*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #version         10
     C                   PARM                    rtncode           1
     C                   PARM                    modus             1

     C* --------------------------------------------------

     c                   z-add     1             lcp010
     c                   movel     anldat        p                 4
     c                   if        #version= version  and
     c                             stk_lcp > *zero and p > '2008'
     c***                          stk_lcp > *zero and p > '1000'
     c                   setoff                                       33
     c     artkey        chain     waecolcp
     c***                if        status   = *blank
     c                   exsr      sr9500
     C                   if        not %found(waecolcp)
     c                   if        modus = 'W' or  modus = 'B'
     c                   movel     'W'           buchung
     c                   write     LCP00R1
     c                   seton                                        33
     c                   endif
     c                   ELSE
     c                   movel     'U'           buchung
     c                   if        modus = 'U' or  modus = 'B'
     c                   update    LCP00R1
     c                   seton                                        33
     c                   endif
     c***                write     LCP00R1
     C                   ENDIF
     c                   movel     udate         xudate            6
     c                   eval      %subst(buchung: 2: 6) = xudate
     c   33              update    KALK_F1
     c***                endif
     c                   endif

     C**************************************************************************
     C* SR3050: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR3500        BEGSR
     C*
     C     KEY3500       KLIST
     C                   KFLD                    $key1
     C                   KFLD                    $key2
     C                   KFLD                    $key3
     C*
     c     KEY3500       chain     systempf
     c                   IF        %found(systempf)
     c*
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##3050        ENDSR
     C*
     C**************************************************************************
     C* SR9500: update auf waecolcp
     C*-------------------------------------------------------------------------
     C     SR9500        BEGSR
     C*
     C                   clear                   $key1
     C                   clear                   $key2
     C                   clear                   $key3
     C                   z-add     *zero         LCP280                         Firma
     C                   movel     jahr          $key1
     C                   movel     'LCP280'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr3500
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp280
     c                   ENDIF                                                  %found(WAECOLCP)
      *
     C                   z-add     *zero         LCP300                         Firma
     C                   movel     jahr          $key1
     C                   movel     'LCP300'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr3500
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp300
     c                   ENDIF                                                  %found(WAECOLCP)
      *
     C                   z-add     *zero         LCP270                         Firma
     C                   movel     jahr          $key1
     C                   movel     'LCP270'      $key2
     C                   movel     '      '      $key3
     C                   exsr      sr3500
     c                   IF        %found(systempf)
     c                   z-add     $P4           lcp270
     c                   ENDIF                                                  %found(WAECOLCP)
      *
     C*
     C                   TIME                    Date
     C                   z-add     001           LCP010                         Firma
     C                   movel     LiefNr        LCP020                         Firma
     C                   movel     ArtNr         LCP030                         Firma
     C                   z-add     jahr          LCP040                         Firma
     C*********          z-add     2011          LCP040                         Firma
     C                   eval      LCP050=((ekpr-beistell)*kwakurs)             Firma
     C*********          z-add     wekpr         LCP050                         Firma
     C                   movel     wacdek        LCP060                         Firma
     C                   z-add     kwakurs       LCP070                         Firma
     C                   eval      LCP080= (ekpr-beistell)                      Firma
     C*********          z-add     ekpr          LCP080                         Firma
     C                   z-add     fracht        LCP090                         Firma
     C                   z-add     zoll          LCP100                         Firma
     C                   z-add     versicheru    LCP110                         Firma
     C                   z-add     beistell      LCP120                         Firma
     C                   z-add     entwicklun    LCP130                         Firma
     C*                                                                         Firma
     C                   eval      lcp140 = ( LCP080 + LCP090 + LCP100 +        Firma
     C                                        LCP110 + LCP120 + LCP130 )        Firma
     C                   clear                   LCP150                         Firma
      *
      *
     C                   if        ARTZ1   = 'EIPROD'                           Firma
     C                   eval      lcp160 = lcp140 + (LCP270 * CWSTCK2) +       Firma
     C                                      (LCP270 * CWSTCK2)*LCP280/100       Firma
     C                   endif                                                  Firma
      *
      *                  ... sollte dann Handelsware sein
     C                   if        ARTZ1   = '      '                           Firma
     C                   z-add     lcp140        LCP160                         Firma
     C                   endif                                                  Firma
     C* abweichungen     z-add     stk_lcp       LCP170                         Firma
     C* cent-bereich     z-add     stk_lcp       LCP170                         Firma
     C                   z-add     lcp160        LCP170                         Firma
     C                   z-add     kschema       LCP180                         Firma
     C                   z-add     *zero         LCP190                         Firma
      *
     C                   eval      LCP200  =lcp160+(LCP140 * LCP300/100)        Firma
     C                   z-add     *zero         LCP210                         Firma
     C                   eval      lcp220  =     LCP200                         Firma
      *
     C                   eval      lcp230  =(LCP270 * CWSTCK2)                  Firma
     C                   movel     statnr        LCP240                         Firma
     C                   movel     artgrp        LCP250                         Firma
     C* siehe oben                               LCP270                         Firma
     C                   z-add     CWSTCK2       LCP260                         Firma
     C* siehe oben                               LCP280                         Firma
     C                   eval      LCP290 = (LCP270 * CWSTCK2)*LCP280/100       Firma
     C* siehe oben                               LCP300                         Firma
     C                   eval      LCP310  = (LCP140 * LCP300/100)              Firma
     C                   z-add     *zero         LCP320                         Firma
     C                   z-add     *zero         LCP330                         Firma
     C                   z-add     0             LCP340                         Firma
     C                   if        ARTZ1   = 'EIPROD'                           Firma
     C                   z-add     1             LCP340                         Firma
     C                   endif                                                  Firma
     C                   movel     *blank        LCP900                         Firma
     C                   movel     date          LCP980                         Firma
     C                   movel     '1'           LCP990                         Firma
     C*
     C     ##9500        ENDSR

     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     C                   ENDSR

