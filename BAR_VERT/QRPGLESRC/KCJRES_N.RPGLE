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
     F*  KCJ - Roherloes anpassen                                *
     F*                                                          *
     F************************************************************
     fsbgkcj00  up   e             disk
     fsbgarb00  if   e           k disk

     dlager            s                   like(arb020)

     c*  Schlüsselliste für SBGARB00
     c     arbkey        klist
     c                   kfld                    kcj010
     c                   kfld                    lager
     c                   kfld                    kcj030
     c                   kfld                    kcj040

     c                   IF        kcj050=2009 and
     c                             (kcj040='7 903 902' or  kcj040='7 903 903' or
     c                             kcj040='7 893 581' or  kcj040='4442700206')

     c     arbkey        chain     ARB00R1
     c                   if        %found(sbgarb00)

     c                   eval      KCJ430 = KCJ190-(KCJ070*arb220)              Januar
     c                   eval      KCJ440 = KCJ200-(KCJ080*arb220)              Februar
     c                   eval      KCJ450 = KCJ210-(KCJ090*arb220)              Märzar
     c                   eval      KCJ460 = KCJ220-(KCJ100*arb220)              Aprilr
     c                   eval      KCJ470 = KCJ230-(KCJ110*arb220)              Maiuar
     c                   eval      KCJ480 = KCJ240-(KCJ120*arb220)              Juniar
     c                   eval      KCJ490 = KCJ250-(KCJ130*arb220)              Juliar
     c                   eval      KCJ500 = KCJ260-(KCJ140*arb220)              August
     c                   eval      KCJ510 = KCJ270-(KCJ150*arb220)              September
     c                   eval      KCJ520 = KCJ280-(KCJ160*arb220)              Oktober
     c                   eval      KCJ530 = KCJ290-(KCJ170*arb220)              November
     c                   eval      KCJ540 = KCJ300-(KCJ180*arb220)              Dezember

     c                   update    kcj00R1

     c                   endif

     c                   endif

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   eval      lager='001'
     C                   ENDSR
