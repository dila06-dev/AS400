     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Übernahme der Produktionsgruppen für Kalkulationsschema *
     F************************************************************

     f#PGRUPPEN ip   e             disk    RENAME(#PGRUPPEN:PRS00RX)
     fpgruppen  uf a e           k disk


     c*  Schlüsselliste für SBGPRS00
     c     key001        klist
     c                   kfld                    jahr
     c                   kfld                    WINSTATNR
     c                   kfld                    DOMSTATNR
     C* --------------------------------------------------

     C                   z-add     #JAHR         JAHR
     C                   movel(p)  #WINSTATNR    WINSTATNR
     C                   movel(p)  #DOMETICKZ    DOMETICKZ

     c     key001        chain     pgruppen
     c                   exsr      sr00001
     C                   if        not %found(pgruppen)
     c                   write     pgruppenr
     c                   ELSE
     c                   update    pgruppenr
     C                   ENDIF


     C* --------------------------------------------------
     C     sr00001       BEGSR

     C                   z-add     ID            ID
     C                   movel(p)  #BESCHREI1    BESCHREI1
     C                   movel(p)  #BESCHREI2    BESCHREI2
     C                   movel(p)  #WINSTATNR    WINSTATNR
     C                   movel(p)  #DOMETICKZ    DOMETICKZ
     C                   movel(p)  #DOMSTATNR    DOMSTATNR
     C                   z-add     #KALKSCHEM    KALKSCHEM
     C                   movel(p)  #KALKARTIK    KALKARTIK
     C                   movel(p)  #VERANTWOR    VERANTWOR
     C                   movel(p)  #WDKZ         WDKZ
     C                   z-add     #JAHR         JAHR
     C                   movel     #KZAI         KZAI

     C     ##sr0001      ENDSR

     C* --------------------------------------------------

     C     *inzsr        BEGSR
     C                   ENDSR

