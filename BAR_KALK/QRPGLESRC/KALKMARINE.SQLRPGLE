      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Auswertungen Herr Petersson Marineprodukte
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#KA0200   uf   e             disk
     F                                     RENAME(#KA0200:phy02r)
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
     C                   PARM                    version          10
     C*
     C                   exsr      sr2000
     C                   open      #KA0200
     C                   exsr      sr3000
     C                   close     #KA0200
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*op-aufbau, alle Marineprodukte
     C*into: gang/#KA0200
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/#KA0200
     c+ SELECT
     c+ artnr,artbez,artgrp,statnr,abc,kschema,wacdvk,wacdek,wekpr,kwakurs,
     c+ wakurs,ekpr,frachtsatz,fracht,zollsatz,zoll,versicheru,costprs_vj,
     c+ costprs_ar,costprs_aj,costprs_n,stk_lcp,stk_lcpgkz,
     c+ lcp_gkz_w,rz_rabatts,rz_wert, kalkbasis,icss,icns,exss,exns,
     c+ oems,ics,ics_aj,icn,exs,exn,oem, ghnet, ghnets,ghrab,ghrabs,Evp_aj
     c+ ,EVP_n ,evp_a_br, evp_neu1 , evp_neu2 , marge_neu1 , marge_neu2
     c+ ,evp_n_br , Preis_pm , rohs_n,rohs_aj,mibt, vkmenge_vj,vkmenge_aj,
     c+ kcjmng_vj, kcjmng_aj, kcjums_vj,kcjums_aj FROM Kalk_file a WHERE
     c+ ("VERSION" = :version) and (a.artnr in ( select artikel from
     c+ marine where a.jahr=jahr and a.liefnr = liefnr))
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*Integrationen
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #KA0200                                95
     C   95              LEAVE
     C*

     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR
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
