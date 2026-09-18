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

     fe_zollnr  up   e             disk    RENAME(e_zollnr:#e_zollnr)
     fSBGART00  uf   e           k disk

     DDate             S               D   DATFMT(*ISO)
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
     c                   update    #e_zollnr
     c                   endif
     c                   endif

     C**************************************************************************
     C* SR9500: update auf Artikeldatei
     C*-------------------------------------------------------------------------
     C     SR9500        BEGSR
     C*
     c                   movel     art220        #prs220a
     c                   movel     #prs220       ART220
     C*
     C     ##9500        ENDSR

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     C*
     C                   ENDSR

