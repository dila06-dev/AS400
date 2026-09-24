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
     F*  KW in FACTORY__E füllen                                 *
     F*                                                          *
     F************************************************************

     fFACTORY__Eup   E             disk    RENAME(FACTORY__E:FACTORf0)

     D Datefield1      S               D   DATFMT(*DMY)
     D Datefield2      S               D   DATFMT(*DMY)
     D Datefield3      S               D   DATFMT(*DMY)
     D Datefield4      S               D   DATFMT(*DMY)
     D KW              S              6S 0

     *********************************************************************
     P* Procedure name: YearWeekIso
     P* Purpose: Ermitteln Jahr + Kalenderwoche aus Datum
     P* Returns: YYYYKW (6S 0)
     P* Parameter: ParmDate => Datum
     *********************************************************************

     D DsYearWeek      DS
     D YearWeek                       6S 0
     D DsYear                         4S 0 Overlay(YearWeek)
     D DsWeek                         2S 0 Overlay(YearWeek: *NEXT)

     D str_DATUM       S             10A
     D ParmDateStr     S             10A
     D ParmDate        S               D   DATFMT(*EUR)

     c                   movel     fak3100       #fak3100          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak3100
     c                   endif
     c                   movel     fak3120       #fak3120          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak3120
     c                   endif
     c                   movel     fak5480       #fak5480          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak5480
     c                   endif
     c                   movel     fak3310       #fak3310          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak3310
     c                   endif
     c                   movel     fak2320       #fak2320          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak2320
     c                   endif
     c                   movel     fak3380       #fak3380          4
     c                   if        #fak3100 = '3111'
     c                   movel     '3011'        fak3380
     c                   endif

     c                   IF        RECHDAT_KW = 0

     C* Kundenauftragsdatum
     c                   if        FAK3100 <> 0 and FAK3100 <> 999999
     c                   movel     FAK3100       str_datum
     c                   move      FAK3100       datefield1

     c                   exsr      kw_calc

     c                   z-add     kw            KNDADAT_KW
     c                   endif

     C* Kundenliefertermin
     c                   if        FAK3120 <> 0 and FAK3120 <> 999999
     c                   movel     FAK3120       str_datum
     c                   move      FAK3120       datefield2

     c                   exsr      kw_calc

     c                   z-add     kw            LIEFFIX_KW
     c                   endif

     C* Lieferdatum
     c                   if        FAK5480 <> 0 and FAK5480 <> 999999
     c                   movel     FAK5480       str_datum
     c                   move      FAK5480       datefield3

     c                   exsr      kw_calc

     c                   z-add     kw            LIEFDAT_KW
     c                   else

     c                   if        FAK3310 <> 0 and FAK3310 <> 999999
     c                   movel     FAK3310       str_datum
     c                   move      FAK3310       datefield3

     c                   exsr      kw_calc

     c                   z-add     kw            LIEFDAT_KW
     c                   else

     c                   if        FAK2320 <> 0 and FAK2320 <> 999999
     c                   movel     FAK2320       str_datum
     c                   move      FAK2320       datefield3

     c                   exsr      kw_calc

     c                   z-add     kw            LIEFDAT_KW
     c                   endif

     c                   endif

     c                   endif

     C* Rechnungsdatum
     c                   if        FAK3380 <> 0 and FAK3380 <> 999999
     c                   movel     FAK3380       str_datum
     c                   move      FAK3380       datefield4

     c                   exsr      kw_calc

     c                   z-add     kw            RECHDAT_KW
     c                   endif

     C     datefield2    SUBDUR    datefield1    NUM_DAYS1:*D      5 0
     C     datefield3    SUBDUR    datefield2    NUM_DAYS2:*D      5 0
     C     datefield4    SUBDUR    datefield3    NUM_DAYS3:*D      5 0

     c                   z-add     NUM_DAYS1     DIFF_TAGE1
     c                   z-add     NUM_DAYS2     DIFF_TAGE2
     c                   z-add     NUM_DAYS3     DIFF_TAGE3

     c                   update    FACTORf0

     c                   endif
     C* --------------------------------------------------
     C     *inzsr        BEGSR
     C                   ENDSR

     C     KW_calc       BEGSR

     c                   if        %len(%TRIM(str_DATUM)) = 6
     c                   eval      ParmDateStr = %subst(str_DATUM:1:2) + '.' +
     c                                           %subst(str_DATUM:3:2) + '.' +
     c                                           '20' + %subst(str_DATUM:5:2)
     c                   endif

     c                   if        %len(%TRIM(str_DATUM)) = 8
     c                   eval      ParmDateStr = %subst(str_DATUM:3:2) + '.' +
     c                                           %subst(str_DATUM:1:2) + '.' +
     c                                           %subst(str_DATUM:5:4)
     c                   endif

     c                   if        %len(%TRIM(str_DATUM)) = 10
     c                   eval      ParmDateStr = str_DATUM
     c                   endif

     c                   move      ParmDateStr   ParmDate

     C/EXEC SQL Set Option DatFmt = *ISO, TimFmt = *ISO
     C/END-EXEC

     C/EXEC SQL Set :DSWeek = Week_ISO(:ParmDate)
     C/END-EXEC

     C/EXEC SQL
     C+ Set :DSYear = Case When Month(:ParmDate) = 12 and :DsWeek = 1
     C+ Then Year(:ParmDate) + 1
     C+ When Month(:ParmDate) = 1 and :DSWeek >= 52
     C+ Then Year(:ParmDate) - 1
     C+ Else Year(:ParmDate)
     C+ End
     C/END-EXEC

     c                   move      DsYearWeek    KW

     C                   ENDSR

