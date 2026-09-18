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
     D*                                                                     ----
     D*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    k                 5
     C                   PARM                    d                 6
     C*
     D*-------------------------------------------------------------------------
     C                   setoff                                       10
     C***                if        *in10  = '0'
     C                   exsr      sr4000
     C                   exsr      sr4050
     C                   exsr      return
     C***                endif
     C*
     C**************************************************************************
     C*Rechnungen Kopf
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##4000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into qs36f/FAKWAE__h
     C+ SELECT 'INVH' LINETYPE,'1.00' VERSION, a.FAK1750 INVOICENR, '20'
     C+ concat substr(digits(fak3380), 5, 2) concat substr(digits(fak3380),
     C+ 3, 2) concat substr(digits(fak3380) , 1, 2) POSTINGDAT, '20' concat
     C+ substr(digits(FAK3460), 5, 2) concat substr(digits(FAK3460), 3, 2)
     C+ concat substr(digits(FAK3460), 1, 2) DUEDAT, '20' concat
     C+ substr(digits(FAK3310), 5, 2) concat substr(digits(FAK3310), 3, 2)
     C+ concat substr(digits(FAK3310), 1, 2) DELIDAT, 'EUR' CURCODE, '100'
     C+ VENDORNR, '0' VATKZ , '1' INVDKZ,digits(a.FAK1090) SHIP1, a.FAK1100
     C+ SHIP2, a.FAK1110 SHIP3, a.FAK1130 SHIP4, ' ' SHIP5, a.FAK1150
     C+ SHIP6, a.FAK1160 SHIP7,'DK' SHIP8,' ' SHIP9, a.FAK1040 aa FROM f1b
     C+ a, f2b b, f3b c WHERE (a.FAK1010 = b.FAK1010 and a.FAK1750 =
     C+ b.FAK1750 and a.FAK1010 = c.FAK1010 and a.FAK1750 = c.FAK1750) and
     C+ digits(a.FAK1020) = :K      and digits(fak3380) = :d
     C*
     c/end-exec
     C*
     C     ##4000        ENDSR
     C*
     C**************************************************************************
     C*Rechnungen Positionen    FAK5370*(FAK5410/100) DISCOUNTA
     C*-------------------------------------------------------------------------
     C*
     C     sr4050        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4050
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     c+ insert into qs36f/FAKWAE__L
     C*
     C+ SELECT 'INVL' LINETYPE ,'1.00' VERSION, b.FAK1750 INVOICENR, '0'
     C+ POSITIONSN, ' ' SHIPNR , a.FAK1040,substr(b.FAK3090, 1, 15)
     C+ ORDERNR, '2' TYPE, FAK5090 ARTNR, FAK5590 ARTBEZ, FAK5320
     C+ QUANTITY1, 1 QUANTITY2 , FAK5320 *1 QUANTITY3, FAK5370 PRICEPC,
     C+ FAK5410 DISCOUNTP , 0,00 DISCOUNTA, FAK5750 LINEA, 0 INVDISA,
     C+ FAK5750 AMOUNT, 0 VATP, 0 VATA, FAK5750 AMOUNTIVAT, a.FAK1020 KDNR,
     C+ a.FAK1030 WANR FROM f5b a, f3b b WHERE a.FAK1010 = b.FAK1010 and
     C+ a.FAK1750=b.FAK1750 and digits(b.FAK1020) = :k      and
     C+ digits(fak3380) = :d
     C*
     c/end-exec
     C*
     C     ##4050        ENDSR
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
     C                   z-add     1             p01               1 0
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
