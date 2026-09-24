      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:date - n
      *               
      * September 2010  GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#dc9999   uf   e             disk
     F                                     RENAME(#dc9999:phy02r)
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

     C     *ENTRY        PLIST
     C                   PARM                    gestern           8
     C                   PARM                    TAG               2 0
     C                   PARM                    MONAT             2 0
     C                   PARM                    JAHR              4 0
     c                   PARM                    WOTAG             2 0

     C                   setoff                                       99
     C                   exsr      sr1000
     C                   open      #dc9999
     C                   exsr      sr2000
     C                   close     #dc9999
     c                   if        WOTAG    = 01
     C                   exsr      sr1500
     C                   open      #dc9999
     C                   exsr      sr2000
     C                   close     #dc9999
     c                   endif
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*funktion
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC9999'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DC9999'     OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md

     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*funktion
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC9998'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DC9999'     OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md

     C     ##1500        ENDSR
     C*
     C**************************************************************************
     C*Funktion
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #dc9999                                95
     C   95              LEAVE
     C*
     C   99              update    phy02r
     C*
     C                   enddo

     C*
     C     ##2000        ENDSR
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
     C                   eval      nxt_jahr = pjahr + 0
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
