     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  KALKSCHZ_I übertragen                                   *
     F************************************************************
     H ALWNULL(*USRCTL)

     fkalkschz_iip   e             disk    Prefix('X') Rename(kalkschz_i:KF0)
     fkalkschzu uf a e           k disk

     dyJAHR            s                   like(JAHR)
     dyWSTATNR         s                   like(WINSTATNR)
     dyDSTATNR         s                   like(DOMSTATNR)

     c*  Schlüsselliste für SBGFAN00
     c     kzukey        klist
     c                   kfld                    yJAHR
     c                   kfld                    yWSTATNR
     c                   kfld                    yDSTATNR

     c                   z-add     XJAHR         yJAHR
     c                   movel     XWSTATNR      yWSTATNR
     c                   movel     XDSTATNR      yDSTATNR
     c     kzukey        chain     KALKSZUF1
     c                   if        %found(KALKSCHZU)

     c                   z-add     XJAHR         JAHR
     c                   movel     XWSTATNR      WINSTATNR
     c                   movel     XDSTATNR      DOMSTATNR
     c                   movel     XBESCH00001   BESCHREIB1
     c                   movel     XBESCH00002   BESCHREIB2
      /Free
       if %Nullind(XBESCH00002);
          %Nullind(XBESCH00002) = *off;
          XBESCH00002 = *Blanks;
       endif;
      /End-Free
     c                   z-add     XKALKSCHEMA   KALKSCHEMA
     c                   movel     XVERAN00001   VERANTWORT
     c                   movel     XDWKZ         WDKZ

     c                   update    KALKSZUF1

     c                   else

     c                   z-add     *zeros        JAHR
     c                   movel     *blanks       WINSTATNR
     c                   movel     *blanks       DOMSTATNR
     c                   movel     *blanks       BESCHREIB1
     c                   movel     *blanks       BESCHREIB2
     c                   z-add     *zeros        KALKSCHEMA
     c                   movel     *blanks       VERANTWORT
     c                   movel     *blanks       WDKZ
     c                   z-add     XJAHR         JAHR
     c                   movel     XWSTATNR      WINSTATNR
     c                   movel     XDSTATNR      DOMSTATNR
     c                   movel     XBESCH00001   BESCHREIB1
     c                   movel     XBESCH00002   BESCHREIB2
      /Free
       if %Nullind(XBESCH00002);
          %Nullind(XBESCH00002) = *off;
          XBESCH00002 = *Blanks;
       endif;
      /End-Free
     c                   z-add     XKALKSCHEMA   KALKSCHEMA
     c                   movel     XVERAN00001   VERANTWORT
     c                   movel     XDWKZ         WDKZ

     c                   write     KALKSZUF1

     c                   endif

     C* --------------------------------------------------
     C     *inzsr        BEGSR

     C                   ENDSR
