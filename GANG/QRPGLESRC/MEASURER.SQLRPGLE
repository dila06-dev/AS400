      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fmeasure   ip   e             disk
     F                                     RENAME(measure:phy01r)
     F*                                    USROPN
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
     C                   exsr      sr3000
     C
     C*
     C***                exsr      return
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*

     C     ';':' '       xlate     f1            f1
     C     ';':' '       xlate     f2            f2
     C                   eval      f2 = %trimr(f2)
     C     ';':' '       xlate     f3            f3
     C     ';':' '       xlate     f4            f4
     C     ';':' '       xlate     f5            f5
     C     ';':' '       xlate     f6            f6
     C     ';':' '       xlate     f7            f7
     C     ';':' '       xlate     f8            f8
     C     ';':' '       xlate     f9            f9
     C     ';':' '       xlate     f10           f10
     C     ';':' '       xlate     f11           f11
     C     ';':' '       xlate     f12           f12
     C     ';':' '       xlate     f13           f13
     C     ';':' '       xlate     f14           f14
     C     ';':' '       xlate     f15           f15
     C     ';':' '       xlate     f16           f16

     c                   movel     f2            v                20
     c                   exsr      sr3500

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte
     C*-------------------------------------------------------------------------
     C*
     C     sr3500        BEGSR

     C                   clear                   l                 3 0
     C                   clear                   r                 3 0
     C                   clear                   f                20
     C                   eval      l=%len(%trimr(v))
     C                   eval      r = (20 - l +1) -4
     c                   eval      %subst(f:r:l) = %subst(v:01:l)
     c                   move      '0000'        f
     c     ' ':'0'       xlate     f             f
     c     '.':'0'       xlate     f             f
     c                   move      f             f_num            20 5
     c                   z-add     f_num         f_num_a          15 0
     c                   z-add     f_num         f_num_b          05 5
     c                   eval      f_num = (f_num_a /10 + f_num_b)

     C     ##3500        ENDSR

     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C                   clear                   $kds020          25
     C                   clear                   $kds030          25
     C                   clear                   $kds060          25
     C                   clear                   $kds080           5
     C                   clear                   $kds090          25
     C                   clear                   $kds070           3

     c/exec sql
     c+ whenever not found goto ##4500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##4500
     c/end-exec

     c/exec sql
     C+ select  kds020,
     C+         kds030,
     C+         kds060,
     C+         kds080,
     C+         kds090,
     C+         kds070
     C+ into    :$kds020,
     C+         :$kds030,
     C+         :$kds060,
     C+         :$kds080,
     C+         :$kds090,
     C+         :$kds070
     C+ FROM    sbgkds00
     C+ WHERE   kds230                = 5000
     c/end-exec
     C*

     C     ##4500        ENDSR

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
