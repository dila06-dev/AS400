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
     f#qm0003   ip   e             disk    RENAME(#qm0003:phy00r)
      *                                                                     ----
     fsbgarb00  uf   e           k disk
     F                                     RENAME(arb00R1:phy01r)
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

     C     *ENTRY        PLIST
     C                   PARM                    #arb220           902
     C*
     C                   exsr      sr3000
     C*
     C**************************************************************************
     C*update
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c     arbkey        klist
     c                   kfld                    ARB010
     c                   kfld                    ARB020
     c                   kfld                    ARB030
     c                   kfld                    ARB040
     C*
     c     arbKey        chain     sbgarb00
     C*
     c                   IF        %found(SBGARB00)
     C                   z-add     #arb220       arb220
     C                   update    phy01r
     C                   endif
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
