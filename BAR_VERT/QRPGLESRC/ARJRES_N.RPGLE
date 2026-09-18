     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  ARJ - Roherloes anpassen                                *
     F*                                                          *
     F************************************************************
     fsbgarj00  up   e             disk
     fsbgarb00  if   e           k disk

     dlager            s                   like(arb020)

     c*  Schlüsselliste für SBGARB00
     c     arbkey        klist
     c                   kfld                    arj010
     c                   kfld                    lager
     c                   kfld                    arj030
     c                   kfld                    arj050

     c                   IF        arj070=2009 and
     c                             (arj050='7 903 902' or  arj050='7 903 903' or
     c                             arj050='7 893 581' or  arj050='4442700206')

     c     arbkey        chain     ARB00R1
     c                   if        %found(sbgarb00)

     c                   eval      ARJ470 = ARJ210-(ARJ090*arb220)              Januar
     c                   eval      ARJ480 = ARJ220-(ARJ100*arb220)              Februar
     c                   eval      ARJ490 = ARJ230-(ARJ110*arb220)              Märzar
     c                   eval      ARJ500 = ARJ240-(ARJ120*arb220)              Aprilr
     c                   eval      ARJ510 = ARJ250-(ARJ130*arb220)              Maiuar
     c                   eval      ARJ520 = ARJ260-(ARJ140*arb220)              Juniar
     c                   eval      ARJ530 = ARJ270-(ARJ150*arb220)              Juliar
     c                   eval      ARJ540 = ARJ280-(ARJ160*arb220)              August
     c                   eval      ARJ550 = ARJ290-(ARJ170*arb220)              September
     c                   eval      ARJ560 = ARJ300-(ARJ180*arb220)              Oktober
     c                   eval      ARJ570 = ARJ310-(ARJ190*arb220)              November
     c                   eval      ARJ580 = ARJ320-(ARJ200*arb220)              Dezember

     c                   update    arj00R1

     c                   endif

     c                   endif

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   eval      lager='001'
     C                   ENDSR
