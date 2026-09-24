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
     F*  Hellmann Adressen Interface füllen                      *
     F*  derzeit nur für Firma 01 (Status??)                     *
     F*  M.Gang 18.09.2009                                       *
     F*  Änderungsprotokoll:                                     *
     F*  ...                                                     *
     F*  ...                                                     *
     F************************************************************

     fSBGKDS00  ip   e             disk
     fHELLADRPF if a e             disk

     DDate             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A

     c                   if        kds010 = 01
     c                   clear                   HELLADRR
     c                   movel     KDS020        H1EMPFAEN
     c                   eval      H1NAME01   = KDS030
     c                   eval      H1NAME02   = KDS040
     c                   if        kds110=*blank
     c                   eval      H1STRASSE  = KDS060
     c                   else
     c                   eval      H1STRASSE  = KDS110
     c                   endif
     c                   if        kds140=*blank
     c                   movel     kds090        H1ORT
     c                   else
     c                   movel     kds140        H1ORT
     c                   endif
     c                   if        kds130 = *zero
     c                   eval      H1PLZ      = %char(KDS080)
     c                   else
     c                   eval      H1PLZ      = %char(KDS130)
     c                   endif
     c                   movel     kds270        H1TELEFON
     c                   movel     kds275        H1TELEFAX
     c                   if        kds100 = *blank
     c                   movel     kds030        H1MATCHC
     c                   else
     c                   movel     kds100        H1MATCHC
     c                   endif
     c*************      movel     X'0d25'       H1_CRLF
     c                   exsr      sr4000

     c                   write     HELLADRR

     c                   endif

     c************************************************************
     c* Kodierung IsoCode Länder (nicht in Datei?)
     c************************************************************

     C     sr4000        begsr

     C                   select
     C
     C                   when      kds070 =*blank or kds070 ='DE '
     C                   movel     'DE '         H1LANDISO
     C                   when      kds070 ='F  ' or kds070 = ' F ' or
     C                             kds070 ='  F' or kds070 = 'FR '
     C                   movel     'FR '         H1LANDISO
     C                   when      kds070 ='G  ' or kds070 = ' G ' or
     C                             kds070 ='  G' or kds070 = 'GB '
     C                   movel     'GB '         H1LANDISO
     C                   other
     C                   movel     *blank        H1LANDISO

     C                   endsl
     C
     C     ##4000        endsr

     C* --------------------------------------------------


     C     *inzsr        BEGSR
     C                   TIME                    Date
     c*                  z-add     1             firma
     C                   ENDSR

