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
     fTRENDEKPLFup   e           k disk

     dtenr             s                   like(PRTENR)


     c                   if        tenr <> PRTENR

     c                   movel     prtenr        tenr

     c                   z-add     0             prmibt
     c                   update    TRENDEKP

     c                   else

     c                   delete    TRENDEKP

     c                   endif                                                  kds210 = 63

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   movel     'XYZ3454354'  tenr
     C                   ENDSR
