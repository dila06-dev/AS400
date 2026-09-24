      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Auswertungen Herr Petersson
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#rech     uf   e             disk
     F                                     RENAME(#rech:phy02r)
     F                                     USROPN
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------

     C*
     C                   open      #rech
     C                   exsr      sr3000
     C                   close     #rech
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Berechnungen
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #rech                                  95
     C   95              LEAVE
     C*
     C                   clear                   t1
     C                   clear                   t2
     C                   clear                   t3
     C                   clear                   t4
     C                   clear                   t5
     C                   clear                   t6
     C*
     C                   clear                   x                 2
     C                   clear                   y                 2
     C                   clear                   z                 2
     C*
     C                   clear                   j                 2 0
     C                   clear                   m                 2 0
     C                   clear                   t                 2 0
     C                   clear                   jx                2 0
     C                   clear                   mx                2 0
     C                   clear                   tx                2 0
     C*
     C                   setoff                                       30
     C                   movel     FAK3310#      liefer            6
     C                   eval      x=%subst(FAK3310#:01:02)
     C                   eval      y=%subst(FAK3310#:03:02)
     C                   eval      z=%subst(FAK3310#:05:02)
     C                   If        (x = '09' or  x = '10') and
     C                             (y > '00' and y < '13') and
     C                             (z > '00' and z < '32')
     C                   movel     x             j
     C                   movel     y             m
     C                   movel     z             t
     C                   else
     C                   seton                                        30
     C                   endif
     C                   movel     FAK3110#      kw                6
     C                   eval      x=%subst(FAK3110#:01:02)
     C                   eval      y=%subst(FAK3110#:03:02)
     C                   eval      z=%subst(FAK3110#:05:02)
     C                   If        (x = '09' or  x = '10') and
     C                             (y > '00' and y < '13') and
     C                             (z > '00' and z < '32')
     C                   movel     x             jx
     C                   movel     y             mx
     C                   movel     z             tx
     C                   else
     C                   seton                                        30
     C                   endif
     C*
     C  n30              eval      t1 = (j *365) + (m *30) + (t)
     C  n30              eval      t2 = (jx*365) + (mx*30) + (tx)
     C*
     C*                  Kundenwunschtermin nicht eingehalten t3
     C                   if        t1 > t2
     C                   eval      t3   = 1
     C                   endif
     C*                  Kundenwunschtermin = Liefertermin    t4
     C                   if        t1 = t2
     C                   eval      t4   = 1
     C                   endif
     C*                  vorzeitige Lieferung                 t5
     C                   if        t1 < t2
     C                   eval      t5   = 1
     C                   endif
     C*                  tage                                 t6
     C                   eval      t6 = t1-t2
     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR

     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   z-add     1             p01               1 0
     C                   if        pmonat > 1
     C                   z-add     1             p02               1 0
     C                   endif
     C                   if        pmonat > 2
     C                   z-add     1             p03               1 0
     C                   endif
     C                   if        pmonat > 3
     C                   z-add     1             p04               1 0
     C                   endif
     C                   if        pmonat > 4
     C                   z-add     1             p05               1 0
     C                   endif
     C                   if        pmonat > 5
     C                   z-add     1             p06               1 0
     C                   endif
     C                   if        pmonat > 6
     C                   z-add     1             p07               1 0
     C                   endif
     C                   if        pmonat > 7
     C                   z-add     1             p08               1 0
     C                   endif
     C                   if        pmonat > 8
     C                   z-add     1             p09               1 0
     C                   endif
     C                   if        pmonat > 9
     C                   z-add     1             p10               1 0
     C                   endif
     C                   if        pmonat > 10
     C                   z-add     1             p11               1 0
     C                   endif
     C                   if        pmonat > 11
     C                   z-add     1             p12               1 0
     C                   endif
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
