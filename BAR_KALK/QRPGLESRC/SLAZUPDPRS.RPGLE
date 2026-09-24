     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Preise in SLAZS füllen                                  *
     F************************************************************
     fslazs     up   e           k disk
     fTRENDEKPLFif   e           k disk
     fTEIL00    if   e           k disk

     dtenr             s                   like(PRTENR)

     c*  Schlüsselliste für teil00
     c     teilkey       klist
     c                   kfld                    slazfirm
     c                   kfld                    SLAZKOTE

     c                   if        slazvest<>1

     c                   delete    slaz1

     c                   else

     c     SLAZKOTE      chain     TRENDEKP
     c                   if        %found(TRENDEKPLF)

     c                   z-add     PREZPR        SLAZGEWI
     c                   movel     PRWACD        SLAZFREX

     c                   update    slaz1

     c                   else

     c     teilkey       chain     TEIL1
     c                   if        %found(TEIL00)

     c                   z-add     TESTPR        SLAZGEWI
     c                   movel     'EUR'         SLAZFREX

     c                   update    slaz1

     c                   ENDIF

     c                   endif
     c                   endif

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     c                   movel     'XYZ3454354'  tenr
     C                   ENDSR
