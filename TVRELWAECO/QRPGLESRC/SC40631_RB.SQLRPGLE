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
     f#dc4501   uf   e             disk
     F                                     RENAME(#dc4501:phy02r)
     F                                     USROPN
     fvsbd01    if   e           k disk
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
     c     vsbd01_key    klist
     c                   kfld                    AMFIRM
     c                   kfld                    AMVSBD
     C*
     C                   exsr      sr2000
     C                   open      #dc4501
     C                   DO        *HIVAL
     C                   READ      #dc4501                                95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c     vsbd01_key    chain     vsbd01                             96
     C   96              delete    phy02r
     C  n96              if        AVKDLI  <> VBSPED
     C  n96              delete    phy02r
     C                   endif
     C                   endif
     C                   enddo
     C                   close     #dc4501
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Zusammenführung
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into qtemp/#dc4501
     c+ SELECT * FROM afkm a, afvs b, afsp c, aflp d, #afkm40631 e where
     c+ status = ' ' and e.AMFIRM = a.AMFIRM and e.AMkmjj = a.AMkmjj and
     c+ e.AMKMNR = a.AMKMNR and e.AVDPDN =b.AVDPDN and a.AMKMJJ=AvKMJJ and
     c+ a.AMKMNR=AvKMNR and A.AMFIRM=B.AVFIRM and ASJAHR=a.AMKMJJ AND
     c+ ASNUMM=a.AMKMNR and a.AMKMJJ = ALKMJJ AND a.AMKMNR = ALKMNR
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*Gesamtauswertung aktuelles Jahr (#mg0021)
     C*into: gang/#st0050
     C*-------------------------------------------------------------------------
     C*
     C*
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
