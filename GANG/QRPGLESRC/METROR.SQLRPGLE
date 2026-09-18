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
     f#hb0500   uf   e             disk
     F                                     RENAME(#hb0500:phy02r)
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
     C                   exsr      sr2000
     C                   exsr      sr2010
     C                   exsr      sr2020
     C                   open      #hb0500
     C                   exsr      sr3000
     C                   close     #hb0500
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*op-aufbau, alle metrokunden
     C*into: gang/#HB0500
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/#HB0500
     c+ SELECT
     c+ OPK0_KTO,OPK0_OPNR,OPK0_OPUNR,OPK0_LFDBUCHNR,OPK0_LFDBUCHPOS,
     c+ OPK0_OPSTAT,OPK0_BELEGJJMT,OPK0_BUPJJM,OPK0_GEGENKTO,
     c+ OPK0_URDM,OPK0_SHKZ,OPK0_DM,OPK0_KST
     c+ FROM FOPPK00
     c+ WHERE OPK0_KTO in  (149206000, 149687000, 149688000, 140305000,
     c+                     140306000, 140307000, 140308000, 140308000,
     c+                     148732000, 186495000, 187076000, 192380000,
     c+                     120160000, 109202000, 102150000, 110670000,
     c+                     118940000, 140285000, 178078000, 188908000,
     c+                     192390000, 106704000, 111894000)
     c+                     and OPK0_OPSTAT <> 7
     c+                     and OPK0_FIRMA=51
     c+                     and OPK0_BELEGARTREF='RA '
     c+                     and OPK0_GEGENKTO = 310810000
     c+                     and OPK0_URDM > 0,00
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*op-aufbau, nicht in Übertragungsdatei, jedoch im rechnungslauf
     C*-------------------------------------------------------------------------
     C*
     C     sr2010        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2010
     c/end-exec
     c/exec sql
     c+ update #hb0500
     c+ set OPKS  = substr(opks, 1, 4) concat '????'
     c+ WHERE substr(digits(OPK0_OPNR), 5, 6) not in
     c+ ( select substr(MAIKEY, 01, 6) FROM edifact/stddat
     c+   where PRTNUM = 'METRO_RECHNUNG')
     c+ and substr(digits(OPK0_OPNR), 5, 6) in
     c+ ( select substr(SBGNMON, 251, 6)
     c+ from SBGNMON
     c+ where substr( SBGNMON, 14, 2) <>'14')
     c/end-exec
     C*
     C     ##2010        ENDSR
     C*
     C**************************************************************************
     C*op-aufbau, in Übertragungsdatei und im rechnungslauf
     C*-------------------------------------------------------------------------
     C*
     C     sr2020        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2020
     c/end-exec
     c/exec sql
     c+ update #hb0500
     c+ set OPKS  = substr(opks, 1, 4) concat 'OK! '
     c+ WHERE substr(digits(OPK0_OPNR), 5, 6) in
     c+ ( select substr(MAIKEY, 01, 6) FROM edifact/stddat
     c+   where PRTNUM = 'METRO_RECHNUNG')
     c+ and substr(digits(OPK0_OPNR), 5, 6) in
     c+ ( select substr(SBGNMON, 251, 6)
     c+ from SBGNMON
     c+ where substr( SBGNMON, 14, 2) <>'14')
     c/end-exec
     C*
     C     ##2020        ENDSR
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #hb0500                                95
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
