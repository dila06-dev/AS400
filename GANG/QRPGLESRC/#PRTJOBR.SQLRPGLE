      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Printjob aus Java ermitteln
      *               
      * 1.Juli   1010   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#pr1000   up   e             disk
     F                                     RENAME(#pr1000:phy02r)
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
     C**************************************************************************
     C*VORLAUFKARTEN ÜBERGABEBEREICHE                                  *********
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    user             10
     C                   PARM                    job              10
     C                   PARM                    nbr               6

     C*
     c  n50              eval      job  = %subst(QPDSPSBJ:04:10)
     c  n50              eval      user = %subst(QPDSPSBJ:17:10)
     c  n50              eval      nbr  = %subst(QPDSPSBJ:30:06)
     c                   seton                                        50
     C*
     C                   exsr      return
     C*
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
