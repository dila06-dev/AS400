      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Order über FTP prüfen und anpassen
      *               
      * Dezember 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fEDC_ORDERRuf   e             disk
     F                                     RENAME(EDC_ORDERR:phy02r)
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
     C     *ENTRY        PLIST
     C                   PARM                    rt                1
     C                   PARM                    $au3020           5 0
     C                   PARM                    $au3090           8
      *-------------------------------------------------------------------------
     C                   exsr      sr2000
     C                   open      EDC_ORDERR
     C*                  exsr      sr3000
     C                   close     EDC_ORDERR
     C*                  exsr      sr4000
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Zuordnung
     C*into: qtemp/EDC_ORDERR
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/EDC_ORDERR
     c+ SELECT DISTINCT * FROM WAECOEDI/waeedihp, sbgau300,
     c+ WAECOEDI/waeedilp, sbgau500
     c+ where    AU3020 = :$au3020 and substr(AU3090, 1, 8) = :$au3090
     c+          and edih030=au3020 and substr(AU3090, 1, 8) =
     c+          substr(EDIH080, 1, 8) and edih010 = EDIL010 and
     c+          edih040 = EDIL040 and AU3020 = au5020 and AU3030 = au5030
     c+          and (EDIL050 =   1 and AU5060 = 5   or
     c+               EDIL050 =   2 and AU5060 = 7   or
     c+               EDIL050 =   3 and AU5060 = 9   or
     c+               EDIL050 =   4 and AU5060 = 11  or
     c+               EDIL050 =   5 and AU5060 = 13  or
     c+               EDIL050 =   6 and AU5060 = 15  or
     c+               EDIL050 =   7 and AU5060 = 17  )
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      EDC_ORDERR                             95
     C   95              LEAVE

     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*Ableitungen generieren
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#KP0101'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#KP0101'     OUTFIL           10
     C                   PARM      'GANG'        LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md

     C     ##4000        ENDSR
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
