      * PROGRAMMNAME.: .....
      * FUNKTION.....: Interface EASYPRINT
      *
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
     D pUser           s             10
     D pWrkStn         s             10
     D*************************************************************************
     C     *Entry        Plist
     C                   Parm                    pUser
     C                   Parm                    pWrkStn
     C                   Parm                    pLanr             5 0
     D*************************************************************************
     C
     C                   clear                   #_LAUFNR          5 0
     C                   clear                   #_FIRMA           5 0
     C                   clear                   #_LFDNR           7 0
     C                   clear                   #_POS             5 0
     C                   clear                   #_KTO             9
     C                   clear                   #_OPNR           10 0
     C                   clear                   #_OPUNR           2 0
     C*                  z-add     852           pLanr
     D*************************************************************************
     C
     C                   exsr      sr2000
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C* into:
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ SELECT
     c+ ZV_LAUFNR, ZV_FIRMA, ZV_LFDNR, ZV_POS, ZV_KTO, ZV_OPNR, ZV_OPUNR
     c+ into
     c+ :#_LAUFNR, :#_FIRMA, :#_LFDNR, :#_POS, :#_KTO, :#_OPNR, :#_OPUNR
     c+ FROM ibssc/zvpos
     c+ WHERE ZV_LAUFNR = :planr
     c/end-exec
     C*
     C                   eval      %subst(dokument:1:04) = '/NR='
     C                   movel     #_LAUFNR      ##_laufnr         5
     C                   eval      %subst(dokument:05:05) = ##_laufnr
     C                   eval      %subst(dokument:10:05) = ' /FA='
     C                   move      #_FIRMA       ##_firma          3
     C                   eval      %subst(dokument:15:03) = ##_firma
     C                   call      'DOKUMENT_C'
     C                   parm                    DOKUMENT        132
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
