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

     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0

     Ddatum            S              8  0

     dtenr             s                   like(PRTENR)


     c                   if        PRGBDA<datum and PRGBDA>0

     c                   delete    TRENDEKP

     c                   endif                                                  kds210 = 63

     C* --------------------------------------------------
     C     *inzsr        BEGSR

     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     c                   extrct    date:*D       ptag

     c                   eval      datum = pjahr*10000 + pmonat*100 + ptag

     C                   ENDSR
