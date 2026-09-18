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
     fFAKWAEFRH uf   e             disk
     F                                     RENAME(FAKWAEFRH:phy01r)
     F                                     USROPN
     fFAKWAEFRl uf   e             disk
     F                                     RENAME(FAKWAEFRl:phy02r)
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
     C**************************************************************************
     C*VORLAUFKARTEN ÜBERGABEBEREICHE                                  *********
     C**************************************************************************
     C     *ENTRY        PLIST
     C                   PARM                    §FAK1020          5 0
     C                   PARM                    §FAK3380          6 0
     C*
     C**************************************************************************
     C*
     C*Dateierstellung
     C                   exsr      sr2000
     C                   exsr      sr2005
     C                   exsr      sr2100
     C                   setoff                                       5556
     C*check auf header
     C   55              open      FAKWAEFRH
     C   55              exsr      sr3000
     C   55              close     FAKWAEFRH
     C*check auf line
     C   56              open      FAKWAEFRL
     C   56              exsr      sr3500
     C   56              close     FAKWAEFRL
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*check auf header
     C*into: gang/FAKWAEFRH
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/FAKWAEFRH
     c+ SELECT DISTINCT
     c+ 'INVH','1.00', c.FAK1750,
     c+ '20' concat  substr(digits(c.FAK3380), 5, 2) concat
     c+              substr(digits(c.FAK3380), 3, 2) concat
     c+              substr(digits(c.FAK3380), 1, 2),
     c+ '20' concat  substr(digits(c.FAK3460), 5, 2) concat
     c+              substr(digits(c.FAK3460), 3, 2) concat
     c+              substr(digits(c.FAK3460), 1, 2),
     c+ '20' concat  substr(digits(c.FAK3310), 5, 2) concat
     c+              substr(digits(c.FAK3310), 3, 2) concat
     c+              substr(digits(c.FAK3310), 1, 2),
     c+ 'EUR', '100', '0', '1',
     c+ digits(a.FAK1090), a.FAK1100, a.FAK1110, a.FAK1130, ' ',
     c+ a.FAK1150,a.FAK1160, 'FR', ' ', a.FAK1040 FROM gang/f1 a, gang/f2
     c+ b, gang/f3 c
     c+ WHERE a.FAK1020 = :§FAK1020 and
     c+       c.FAK3380 = :§FAK3380 and
     c+       b.FAK2420 <> 0        and
     c+ (   a.FAK1010 = b.FAK1010
     c+ and a.FAK1750 = b.FAK1750
     c+ and a.FAK1010 = c.FAK1010
     c+ and a.FAK1750 = c.FAK1750
     c+ and b.FAK1030 = a.FAK1030
     c+ and b.FAK1030 = c.FAK1030 )
     c+ order by  c.FAK1750
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*check auf header lesen für weitere Positionen mit original
     C*Rechnungsbezug über Auftrag des Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr2001        BEGSR
     C*
     C                   clear                   §FAK3090         10
     C
     c/exec sql
     c+ whenever not found goto ##2001
     c/end-exec
     c/exec sql
     c+ SELECT distinct
     c+ substr(FAK3090, 1, 10)  into :§FAK3090
     c+ FROM gang/f1 a, gang/f2
     c+ b, gang/f3 c
     c+ WHERE a.FAK1020 = :§FAK1020 and
     c+       c.FAK3380 = :§FAK3380 and
     c+       b.FAK2420 <> 0        and
     c+ (   a.FAK1010 = b.FAK1010
     c+ and a.FAK1750 = b.FAK1750
     c+ and a.FAK1010 = c.FAK1010
     c+ and a.FAK1750 = c.FAK1750
     c+ and b.FAK1030 = a.FAK1030
     c+ and b.FAK1030 = c.FAK1030 )
     c/end-exec
     C*
     C     ##2001        ENDSR
     C*
     C**************************************************************************
     C*check auf header lesen für weitere Positionen mit original
     C*Rechnungsbezug über Auftrag des Kunden
     C*-------------------------------------------------------------------------
     C*
     C     sr2005        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2005
     c/end-exec
     c/exec sql
     c+ insert into gang/FAKWAEFRHc
     c+ SELECT DISTINCT
     c+ 'INVH','1.00', c.FAK1750,
     c+ '20' concat  substr(digits(c.FAK3380), 5, 2) concat
     c+              substr(digits(c.FAK3380), 3, 2) concat
     c+              substr(digits(c.FAK3380), 1, 2),
     c+ '20' concat  substr(digits(c.FAK3460), 5, 2) concat
     c+              substr(digits(c.FAK3460), 3, 2) concat
     c+              substr(digits(c.FAK3460), 1, 2),
     c+ '20' concat  substr(digits(c.FAK3310), 5, 2) concat
     c+              substr(digits(c.FAK3310), 3, 2) concat
     c+              substr(digits(c.FAK3310), 1, 2),
     c+ 'EUR', '100', '0', '1',
     c+ digits(a.FAK1090), a.FAK1100, a.FAK1110, a.FAK1130, ' ',
     c+ a.FAK1150,a.FAK1160, 'FR', ' ', a.FAK1040,
     c+ substr(FAK3090, 1, 10)
     c+ FROM gang/f1 a, gang/f2 b, gang/f3 c
     c+ WHERE a.FAK1020 = :§FAK1020 and
     c+       c.FAK3380 = :§FAK3380 and
     c+       b.FAK2420 <> 0        and
     c+ (   a.FAK1010 = b.FAK1010
     c+ and a.FAK1750 = b.FAK1750
     c+ and a.FAK1010 = c.FAK1010
     c+ and a.FAK1750 = c.FAK1750
     c+ and b.FAK1030 = a.FAK1030
     c+ and b.FAK1030 = c.FAK1030 )
     c+ order by  c.FAK1750
     c/end-exec
     C*
     C     ##2005        ENDSR
     C*
     C**************************************************************************
     C*check auf lines
     C*into: gang/FAKWAEFRL
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2100
     c/end-exec
     c/exec sql
     c+ insert into gang/FAKWAEFRL
     c+ SELECT DISTINCT
     c+ 'INVL', '1.00', b.FAK1750, '0', ' ',
     c+ a.FAK1040,substr(b.FAK3090, 1, 15), '2', a.FAK5090, a.FAK5590,
     c+ a.FAK5320, 1, (a.FAK5320 * 1), a.FAK5370, a.FAK5410,
     c+ a.FAK5370*(a.FAK5410/100), a.FAK5750, 0, a.FAK5750, 0, 0,
     c+ a.FAK5750, a.FAK1020, a.FAK1030 FROM gang/f5 a, gang/f3 b
     c+ WHERE ( a.FAK1020 = :§FAK1020 and b.fak1020 = :§FAK1020) and
     c+       ( a.FAK1750 in ( select INVOICENR from gang/FAKWAEFRH )) and
     c+       (   a.FAK1010 = b.FAK1010
     c+       and a.FAK1750 = b.FAK1750 ) and
     c+       ( substr(FAK3090, 1, 10) in ( select orderc from
     c+          gang/FAKWAEFRHc where INVOICENR = a.fak1750 ) )
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
     C                   READ      FAKWAEFRH                              95
     C   95              LEAVE
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
     C     sr3500        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      FAKWAEFRl                              95
     C   95              LEAVE
     C*
     C                   update    phy02r
     C*
     C                   enddo
     C*
     C     ##3500        ENDSR
     C*
     C**************************************************************************
     C*call auf Folgeprogramme
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C*
     C     ##4500        ENDSR
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
