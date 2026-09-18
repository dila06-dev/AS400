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

     D**************************************************************************
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     I*-------------------------------------------------------------------------

     c*  Schlüsselliste für kalk_file
     c     kalkkey       klist
     c                   kfld                    jahr
     c                   kfld                    LiefNr
     c                   kfld                    ArtNr
     c                   kfld                    version

     C* --------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    version          15
     C                   PARM                    jahr              1

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
     c                   z-add     #prs070       ART320
     c                   if        #prs070 = *zero
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

