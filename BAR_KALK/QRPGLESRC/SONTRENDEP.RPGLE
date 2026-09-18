     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Vertreter 4 in Kundenstamm anpassen für Branche 63      *
     F************************************************************
     fsbgart17  up   e           k disk
     fTRENDEKPLFif a e           k disk

     dtenr             s                   like(PRTENR)


     c     art030        chain     TRENDEKP
     c                   if        not %found(TRENDEKPLF)


     c                   movel     *blanks       prwacd
     c                   movel     art340        PRWACD
     c                   if        prwacd='99' or prwacd='00'
     c                   movel     'EUR'         PRWACD
     c                   endif
     c                   if        prwacd='03'
     c                   movel     'JPY'         PRWACD
     c                   endif
     c                   if        prwacd='05'
     c                   movel     'DKK'         PRWACD
     c                   endif
     c                   if        prwacd='08'
     c                   movel     'GBP'         PRWACD
     c                   endif
     c                   if        prwacd='09'
     c                   movel     'USD'         PRWACD
     c                   endif
     c                   if        prwacd='10'
     c                   movel     'NOK'         PRWACD
     c                   endif
     c                   if        prwacd='11'
     c                   movel     'CAD'         PRWACD
     c                   endif
     c                   if        prwacd='12'
     c                   movel     'CHF'         PRWACD
     c                   endif
     c                   if        prwacd='13'
     c                   movel     'HKD'         PRWACD
     c                   endif
     c                   if        prwacd='17'
     c                   movel     'SEK'         PRWACD
     c                   endif
     c                   if        prwacd='18'
     c                   movel     'AUD'         PRWACD
     c                   endif
     c                   if        prwacd='19'
     c                   movel     'NTD'         PRWACD
     c                   endif
     c                   if        prwacd='20'
     c                   movel     'PLN'         PRWACD
     c                   endif

     c                   movel     art030        PRTENR
     c                   movel     *blanks       prkdli
     c                   eval      prkdli = '90' + art020
     c                   movel     *blanks       PRGADA
     c                   movel     *blanks       PRGBDA
     c                   z-add     1             PRMIBT
     c                   movel     art330        PREZPR

     c                   write     TRENDEKP

     c                   endif                                                  kds210 = 63

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   movel     'XYZ3454354'  tenr
     C                   ENDSR
