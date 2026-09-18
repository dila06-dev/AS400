     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Preise in Artikelstamm ändern                           *
     F************************************************************

     fa_preis   up   e             disk
     fSBGART00  uf   e           k disk

     I*-------------------------------------------------------------------------
     c*  Schlüsselliste für SBGARB00
     c     artkey        klist
     c                   kfld                    #PRS010
     c                   kfld                    #PRS030
     c                   kfld                    #PRS040

     C* --------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    artikel          15
     C                   PARM                    rtncode           1

     C* --------------------------------------------------
     c     artkey        chain     ART00R1
     c                   if        #GEBUCHT = *zero
     c                   if        artikel = #PRS040 or artikel = *blank
     c                   exsr      sr9500
     c                   if        %found(sbgart00)
     c                   movel     'U'           #modus
     c                   update    ART00R1
     c                   else
     c                   movel     'W'           #modus
     c                   endif
     c                   z-add     udate         #GEBUCHT
     c                   update    a_preisr
     c                   endif
     c                   endif

     C**************************************************************************
     C* SR9500: update auf Artikeldatei
     C*-------------------------------------------------------------------------
     C     SR9500        BEGSR
     C*
     c                   z-add     #prs050       ART310
     c                   movel     #prs070       #ttmmjj           6
     c                   movel     #prs070       #jjmmtt           6
     c                   eval      %subst(#jjmmtt: 1: 2) =
     c                             %subst(#ttmmjj: 5: 2)
     c                   eval      %subst(#jjmmtt: 5: 2) =
     c                             %subst(#ttmmjj: 1: 2)
     c                   movel     #jjmmtt       #prs070
     c                   z-add     #prs070       ART320
     c                   if        #prs070 = *zero and #prs050 <> *zero
     c                   z-add     SBGART00_P    ART320
     c                   endif
     C*
     C     ##9500        ENDSR

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     C*                  Gültigkeitsdatum
     C     *DTAARA       DEFINE                  SBGART00_P        6 0
     C                   IN        SBGART00_P
     C*
     C                   ENDSR

