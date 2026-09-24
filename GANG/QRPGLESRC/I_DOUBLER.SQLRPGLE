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
     fARTNR_KALKif   e           k disk    prefix('Z')
     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
      *                                                                     ----
     f#edchchk  uf   e             disk
     F                                     RENAME(#edchchk:phy01r)
     F                                     USROPN
     f#edclchk  uf   e             disk
     F                                     RENAME(#edclchk:phy02r)
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

     c*  Schlüsselliste für KSchemata
     c     keyschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    KSCHEMA

     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    PR_GROUP

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    SUPPLIER
     c                   kfld                    MODEL_NO
     C*
     C                   exsr      sr2000
     C                   exsr      sr2100
     C*check auf header
     C                   open      #edchchk
     C                   exsr      sr3000
     C                   close     #edchchk
     C*check auf line
     C                   open      #edclchk
     C                   exsr      sr3500
     C                   close     #edclchk
     C
     C                   exsr      sr4000
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*check auf header
     C*into: gang/#edchchk
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/#edchchk
     c+ SELECT EDIH010, EDIH020, EDIH030, EDIH040, EDIH050, EDIH060,
     c+ EDIH070, EDIH080, EDIH090, EDIH100, EDIH210, EDIH220, EDIH230,
     c+ EDIH240, EDIH250, EDIH260, EDIH270, EDIH280, EDIH290, EDIH300,
     c+ EDIH310, EDIH320, EDIH330, EDIH340, EDIH350, EDIH360, EDIH370,
     c+ EDIH380, count(*) p FROM WAECOEDI/waeedih WHERE EDIH390 = 0 GROUP
     c+ BY EDIH010, EDIH020, EDIH030, EDIH040, EDIH050, EDIH060, EDIH070,
     c+ EDIH080, EDIH090, EDIH100, EDIH210, EDIH220, EDIH230, EDIH240,
     c+ EDIH250, EDIH260, EDIH270, EDIH280, EDIH290, EDIH300, EDIH310,
     c+ EDIH320, EDIH330, EDIH340, EDIH350, EDIH360, EDIH370, EDIH380
     c+ HAVING count(*) > 1
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*check auf lines
     C*into: gang/#edclchk
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2100
     c/end-exec
     c/exec sql
     c+ insert into gang/#edclchk
     c+ SELECT EDIL010, EDIL020, EDIL030, EDIL040, EDIL050, EDIL060,
     c+ EDIL070, EDIL210, EDIL220, EDIL230, EDIL240, edil250, EDIL250,
     c+ EDIL300, EDIL310, count(*) p FROM WAECOEDI/waeedil WHERE EDIL320 =
     c+ 0 GROUP BY EDIL010, EDIL020, EDIL030, EDIL040, EDIL050, EDIL060,
     c+ EDIL070, EDIL210, EDIL220, EDIL230, EDIL240, edil250, EDIL250,
     c+ EDIL300, EDIL310 HAVING count(*) > 1
     c/end-exec
     C*
     C     ##2100        ENDSR
     C*
     C**************************************************************************
     C*header-check
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #edchchk                               95
     C   95              LEAVE
     C                   movel     EDIL220       #edil220
     C                   eval      EDIL220  = %subst(#edil2202:03:01)
     C                   update    phy01r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*line-check
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #edclchk                               95
     C   95              LEAVE
     C*
     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR
     C*

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
