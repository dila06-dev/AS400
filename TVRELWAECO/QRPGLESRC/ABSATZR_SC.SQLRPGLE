     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :insert into tvrelwaeco/statistik   JJ==>OK
      * ==>          :insert into tvrelwaeco/ABSATZ      JJjjmmtt    RKREDA
      * ==>          :insert into tvrelwaeco/ABSATZa1    2011        sel003
      * ==>          :insert into tvrelwaeco/ABSATZa2    JJ==>OK
      * ==>          :insert into tvrelwaeco/ABSATZB     JJjjmmtt    RKREDA
      * ==>          :insert into tvrelwaeco/ABSATZB2    no ==> RPMII
      * ==>          :insert into tvrelwaeco/ABSATZB3    jhjj
      * ==>          :insert into tvrelwaeco/ABSATZB4    jhjj
      * ==>          :insert into tvrelwaeco/ABSATZc     no
      * ==>          :insert into tvrelwaeco/statistik2  2011
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fabsatz#   uf   e             disk
     f                                     RENAME(absatz#:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fabsatzb#  uf   e             disk
     f                                     RENAME(absatzb#:phy02r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fwaeh01    if   e           k disk
     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Aufbau aller Sätze mit Status erledigt (Positionen auf 90)
     c/exec sql
     c+ insert into tvrelwaeco/statistik#
     c+ SELECT * FROM afko, afpo, afrp, afrk WHERE
     c+ AKFIRM=apFIRM and AKAFJJ=apAFJJ and AKAFNN=apAFNN and
     c+ RPFIRM=aPFIRM and RPAFJJ=aPAFJJ and RPAFNR=aPAFNR and RPAFPO=aPAFPO
     c+ and
     c+ RKFIRM=RpFIRM and RKRGJJ=RpRGJJ and RKRGNR=RpRGNR and RKLIJJ=RpLIJJ
     c+ and
     c+ RKLINR=RpLINR
     c+            and apAFST = '90' and (APFIRM = '61' or AKWKNR ='004')
     c****         and apAFST = '90' and APFIRM in ('08','52','55','61')
     c/end-exec

     C*Korrketur auf Menge, hier dürfen keine Mengen in die Statistik
     c/exec sql
     c+ update statistik# set APGLMG = apglmg * 0
     c+ where APAFAT In ('  ', '05', '70')
     c/end-exec


     C*Korrketur auf Menge, negative Mengen für Statistik
     c/exec sql
     c+ update statistik# set APGLMG = apglmg * -1
     c+ where APAFAT In ('50', '71', '72', '99', '14', '82')
     c/end-exec

     C*Korrketur Fehlmengenauslieferung
     c/exec sql
     c+ update statistik# set apglmg =
     c+ (SELECT                 alglmg  FROM aflp WHERE apafnr=
     c+ alafnr and aptenr= altenr and apafjj= ALAFJJ and apafpo=ALAFPO and
     c+ rplijj=allijj and rplinr=ALLINR and rplipo=ALLIPO and rprgjj=ALRGJJ
     c+ and rprgnr = ALRGNR and apglmg<>alglmg and apglmg >0 and alglmg >0
     c+ and aflp.alfirm in ('08','52', '55', '61'))
     c+ where exists
     c+ (SELECT                 alglmg  FROM aflp WHERE apafnr=
     c+ alafnr and aptenr= altenr and apafjj= ALAFJJ and apafpo=ALAFPO and
     c+ rplijj=allijj and rplinr=ALLINR and rplipo=ALLIPO and rprgjj=ALRGJJ
     c+ and rprgnr = ALRGNR and apglmg<>alglmg and apglmg >0 and alglmg >0
     c+ and aflp.alfirm in ('08','52', '55', '61'))
     c/end-exec

      *#####################################################################
      *1. Ableitung ==> tvrelwaeco/ABSATZ
      *#####################################################################
     C*mit Filter ohne Divisor = 0, keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZ#
     c+ SELECT akfirm, APAFAT,RKREDA,RKWACD, APTENR ,APGLMG , RPNESU, RPBRSU,
     c+ RPERG1, RPERG2, RPERG3, RPERG4, RKERG1 z1, RKERG2 z2, RKERG3
     c+ z3,rKERG4 z4, RKMWS1, RKWAWT,
     c+ dec((RKERG1*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11, 2)
     c+ za1, dec((RKERG2*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11,
     c+ 2) za2 , dec((RKERG3*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za4,
     c+ zoned(00000000, 8, 0) wagada, zoned(00000000, 11, 6) wakurs
     c+ FROM statistik#
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) <> 0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec

     C*mit Filter mit Divisor = 0 ( mathematisch /1 )
     C*                           keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZ#
     c+ SELECT akfirm, APAFAT,RKREDA,RKWACD, APTENR ,APGLMG , RPNESU, RPBRSU,
     c+ RPERG1, RPERG2, RPERG3, RPERG4, RKERG1 z1, RKERG2 z2, RKERG3
     c+ z3,rKERG4 z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/1), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/1), 11, 2) za2, dec((RKERG3*RPBRSU/1), 11, 2)
     c+ za3, dec((RKERG4*RPBRSU/1), 11, 2) za4,
     c+ zoned(00000000, 8, 0) wagada, zoned(00000000, 11, 6) wakurs
     c+ FROM statistik#
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) =  0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec

     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c
     C                   open      absatz#
     C                   DO        *HIVAL
     C                   READ      absatz#                                95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        andne     'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      wagada    =   wagada
     c                   eval      wakurs    =   wakuvk
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C                   close     absatz#

     C*Ableitung tvrelwaeco/ABSATZa1 aus tvrelwaeco/ABSATZ
     C*GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4)  J a h r e s w e r t
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZa1#
     c+ SELECT AKFIRM, APAFAT,APTENR, substr(RKREDA, 1, 4),
     c+ dec(sum(APGLMG*1     ), 13, 2) APGLMG,
     c+ dec(sum(RPNESU*WAKURS), 13, 2) RPNESU,
     c+ dec(sum(RPBRSU*WAKURS), 13, 2) RPBRSU,
     c+ dec(sum(RPERG1*WAKURS), 13, 2) RPERG1,
     c+ dec(sum(RPERG2*WAKURS), 13, 2) RPERG2,
     c+ dec(sum(RPERG3*WAKURS), 13, 2) RPERG3,
     c+ dec(sum(RPERG4*WAKURS), 13, 2) RPERG4,
     c+ dec(sum(ZA1*WAKURS), 13, 2) ZA1,
     c+ dec(sum(ZA2*WAKURS), 13, 2) ZA2,
     c+ dec(sum(ZA3*WAKURS), 13, 2) ZA3,
     c+ dec(sum(ZA4*WAKURS), 13, 2) ZA4
     c+ FROM absatz#
     c+ GROUP BY akfirm, APAFAT,APTENR, substr(RKREDA, 1, 4)
     c/end-exec

     C*Ableitung tvrelwaeco/ABSATZa1 aus tvrelwaeco/ABSATZ
     C*GROUP BY APAFAT,APTENR, substr(RKREDA, 1, 4)  M o n a t s w e r t e
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZa2#
     c+ SELECT akfirm,APAFAT,APTENR, substr(RKREDA, 1, 4) JJJJ,
     c+        substr(RKREDA, 5, 2) MM,
     c+ dec(sum(APGLMG*1     ), 13, 2) APGLMG,
     c+ dec(sum(RPNESU*WAKURS), 13, 2) RPNESU,
     c+ dec(sum(RPBRSU*WAKURS), 13, 2) RPBRSU,
     c+ dec(sum(RPERG1*WAKURS), 13, 2) RPERG1,
     c+ dec(sum(RPERG2*WAKURS), 13, 2) RPERG2,
     c+ dec(sum(RPERG3*WAKURS), 13, 2) RPERG3,
     c+ dec(sum(RPERG4*WAKURS), 13, 2) RPERG4,
     c+ dec(sum(ZA1*WAKURS), 13, 2) ZA1,
     c+ dec(sum(ZA2*WAKURS), 13, 2) ZA2,
     c+ dec(sum(ZA3*WAKURS), 13, 2) ZA3,
     c+ dec(sum(ZA4*WAKURS), 13, 2) ZA4
     c+ FROM absatz#
     c+ GROUP BY akfirm,
     c+          APAFAT,APTENR, substr(RKREDA, 1, 4), substr(RKREDA, 5, 2)
     c/end-exec

      *#####################################################################
      *#####################################################################
      *2. Ableitung ==> tvrelwaeco/ABSATZB
      *#####################################################################
     C*mit Filter ohne Divisor = 0, keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB#
     c+ SELECT akfirm,APAFAT,RKREDA,RKWACD,APTENR,APGLMG,RPNESU,RPBRSU,
     c+ RPERG1,RPERG2,RPERG3,RPERG4,RKERG1 z1, RKERG2 z2, RKERG3 z3,rKERG4
     c+ z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)), 11, 2)
     c+ za2 , dec((RKERG3*RPBRSU/(RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4)),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(RKWAWT-RKERG1-RKERG2-
     c+ RKERG3-RKERG4)), 11, 2) za4, zoned(00000000, 8, 0) wagada,
     c+ zoned(00000000, 11, 6) wakurs,akprio,AKVSBD,AKLIBD,RKZABD,RKVALT,
     c+ rkvada,APKDNR,APSTKD,apWACD,APKDGR,APVTN1,APVTN2,APVTN3,APKOKZ,
     c+ APKSTC,APSPTE,APKURS,APPRGR,APLANR,APTBZ1,APTBZ2,char(' ', 60) st,
     c+ dec(rrn(statistik#), 16, 0) RRN, current timestamp ts,
     c+ dec(0, 13, 2) JanA,dec(0, 13, 2) FEBA,dec(0, 13, 2) MAEA,
     c+ dec(0, 13, 2) APRA,dec(0, 13, 2) MaiA,dec(0, 13, 2) junA,
     c+ dec(0, 13, 2) JulA,dec(0, 13, 2) augA,dec(0, 13, 2) sepA,
     c+ dec(0, 13, 2) oktA,dec(0, 13, 2) novA,dec(0, 13, 2) dezA,
     c+ dec(0, 13, 2) Janu,dec(0, 13, 2) FEBu,dec(0, 13, 2) MAEu,
     c+ dec(0, 13, 2) APRu,dec(0, 13, 2) Maiu,dec(0, 13, 2) junu,
     c+ dec(0, 13, 2) Julu,dec(0, 13, 2) augu,dec(0, 13, 2) sepu,
     c+ dec(0, 13, 2) oktu,dec(0, 13, 2) novu,dec(0, 13, 2) dezu
     c+ FROM statistik#
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) <> 0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec

     C*mit Filter mit Divisor = 0 ( mathematisch /1 )
     C*                           keine Gruppierung nur Filter
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB#
     c+ SELECT akfirm,APAFAT,RKREDA,RKWACD,APTENR,APGLMG,RPNESU,RPBRSU,
     c+ RPERG1,RPERG2,RPERG3,RPERG4,RKERG1 z1, RKERG2 z2, RKERG3 z3,rKERG4
     c+ z4, RKMWS1, RKWAWT, dec((RKERG1*RPBRSU/(1
     c+              )), 11, 2) za1,
     c+ dec((RKERG2*RPBRSU/(1                                  )), 11, 2)
     c+ za2 , dec((RKERG3*RPBRSU/(1                                  )),
     c+ 11, 2) za3, dec((RKERG4*RPBRSU/(1
     c+              )), 11, 2) za4, zoned(00000000, 8, 0) wagada,
     c+ zoned(00000000, 11, 6) wakurs,akprio,AKVSBD,AKLIBD,RKZABD,RKVALT,
     c+ rkvada,APKDNR,APSTKD,apWACD,APKDGR,APVTN1,APVTN2,APVTN3,APKOKZ,
     c+ APKSTC,APSPTE,APKURS,APPRGR,APLANR,APTBZ1,APTBZ2,char(' ', 60) st,
     c+ dec(rrn(statistik#), 16, 0) RRN, current timestamp ts,
     c+ dec(0, 13, 2) JanA,dec(0, 13, 2) FEBA,dec(0, 13, 2) MAEA,
     c+ dec(0, 13, 2) APRA,dec(0, 13, 2) MaiA,dec(0, 13, 2) junA,
     c+ dec(0, 13, 2) JulA,dec(0, 13, 2) augA,dec(0, 13, 2) sepA,
     c+ dec(0, 13, 2) oktA,dec(0, 13, 2) novA,dec(0, 13, 2) dezA,
     c+ dec(0, 13, 2) Janu,dec(0, 13, 2) FEBu,dec(0, 13, 2) MAEu,
     c+ dec(0, 13, 2) APRu,dec(0, 13, 2) Maiu,dec(0, 13, 2) junu,
     c+ dec(0, 13, 2) Julu,dec(0, 13, 2) augu,dec(0, 13, 2) sepu,
     c+ dec(0, 13, 2) oktu,dec(0, 13, 2) novu,dec(0, 13, 2) dezu
     c+ FROM statistik#
     c+ where (RKWAWT-RKERG1-RKERG2- RKERG3-RKERG4) =  0
     c+ and   APAFAT not in ('30', '31', '41', '77', '88', '99',
     c+                     '10', '11', '14', '15', '  ', '17', '18', '20')
     c/end-exec
     C
     C                   open      absatzb#
     C                   DO        *HIVAL
     C                   READ      absatzb#                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C     KEY001        SETgt     WAEH01                             95
     C     *IN95         IFEQ      '0'
     C     RKWACD        andne     'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             wakurs
     C                   leave
     C                   else
     c                   eval      wagada    =   wagada
     c                   eval      wakurs    =   wakuvk
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C                   endif
     C
     c                   endif
     c                   exsr      sr8000
     c                   update    phy02r
     c                   enddo
     C                   close     absatzb#
     C
     C*
     C*                           Gruppierung  tvrelwaeco/ABSATZB2
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB2#
     c+ SELECT akfirm, APTENR,APTBZ1,APKDNR,
     c+        char(substr(APKSTC, 1, 1), 1) kgr, APPRGR,
     c+ dec(sum(JANA), 13, 2) jana, dec(sum(febA), 13, 2) feba,
     c+ dec(sum(maeA), 13, 2) maea, dec(sum(aprA), 13, 2) apra,
     c+ dec(sum(maiA), 13, 2) maia, dec(sum(junA), 13, 2) juna,
     c+ dec(sum(julA), 13, 2) jula, dec(sum(augA), 13, 2) auga,
     c+ dec(sum(sepA), 13, 2) sepa, dec(sum(oktA), 13, 2) okta,
     c+ dec(sum(novA), 13, 2) nova, dec(sum(dezA), 13, 2) deza,
     c+ dec(sum(janU), 13, 2) janU, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeU), 13, 2) maeU, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiU), 13, 2) maiU, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julU), 13, 2) julU, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepU), 13, 2) sepU, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novU), 13, 2) novU, dec(sum(dezu), 13, 2) dezu,
     c+ current timestamp ts, dec(count(*), 10) anzahl
     c+ FROM absatzb#
     c+ GROUP BY akfirm,APTENR,APTBZ1,APKDNR,
     c+          char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*
     C*             ohne kunde    Gruppierung  tvrelwaeco/ABSATZc
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZc#
     c+ SELECT akfirm, APTENR,APTBZ1,APPRGR,
     c+ dec(sum(JANA), 13, 0) jana, dec(sum(feba),
     c+ 13, 0) feba, dec(sum(MAEA), 13, 0) MAEA, dec(sum(APRA), 13, 0)
     c+ APRA, dec(sum(MAIA), 13, 0) MAIA, dec(sum(JUNA), 13, 0) JUNA,
     c+ dec(sum(JUlA), 13, 0) JUlA, dec(sum(auga), 13, 0) auga,
     c+ dec(sum(sepa), 13, 0) sepa, dec(sum(okta), 13, 0) okta,
     c+ dec(sum(nova), 13, 0) nova, dec(sum(deza), 13, 0) deza,
     c+ dec(sum(JANu), 13, 2) janu, dec(sum(febu), 13, 2) febu,
     c+ dec(sum(maeu), 13, 2) maeu, dec(sum(apru), 13, 2) apru,
     c+ dec(sum(maiu), 13, 2) maiu, dec(sum(junu), 13, 2) junu,
     c+ dec(sum(julu), 13, 2) julu, dec(sum(augu), 13, 2) augu,
     c+ dec(sum(sepu), 13, 2) sepu, dec(sum(oktu), 13, 2) oktu,
     c+ dec(sum(novu), 13, 2) novu, dec(sum(dezu), 13, 2) dezu,
     c+ dec(sum(anzahl), 13, 0) anzahl, ts FROM absatzb2# GROUP BY
     c+ akfirm,APTENR,APTBZ1,APPRGR,ts
     c/end-exec
     C*
     C*  _____________________________________________________
     C
     C*                           Gruppierung  tvrelwaeco/ABSATZB3
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB3#
     c+ SELECT akfirm,APTENR,APTBZ1,APKDNR, substr(char(RKREDA) , 1, 4) jahr,
     c+ char(substr(APKSTC, 1, 1), 1) kgr, APPRGR, dec(sum(JANA), 13, 2)
     c+ jana, dec(sum(febA), 13, 2) feba, dec(sum(maeA), 13, 2) maea,
     c+ dec(sum(aprA), 13, 2) apra, dec(sum(maiA), 13, 2) maia,
     c+ dec(sum(junA), 13, 2) juna, dec(sum(julA), 13, 2) jula,
     c+ dec(sum(augA), 13, 2) auga, dec(sum(sepA), 13, 2) sepa,
     c+ dec(sum(oktA), 13, 2) okta, dec(sum(novA), 13, 2) nova,
     c+ dec(sum(dezA), 13, 2) deza, dec(sum(janU), 13, 2) janU,
     c+ dec(sum(febu), 13, 2) febu, dec(sum(maeU), 13, 2) maeU,
     c+ dec(sum(apru), 13, 2) apru, dec(sum(maiU), 13, 2) maiU,
     c+ dec(sum(junu), 13, 2) junu, dec(sum(julU), 13, 2) julU,
     c+ dec(sum(augu), 13, 2) augu, dec(sum(sepU), 13, 2) sepU,
     c+ dec(sum(oktu), 13, 2) oktu, dec(sum(novU), 13, 2) novU,
     c+ dec(sum(dezu), 13, 2) dezu, current timestamp ts, dec(count(*), 10)
     c+ anzahl FROM absatzb# GROUP BY akfirm,APTENR,APTBZ1,APKDNR,
     c+ substr(char(RKREDA), 1, 4) ,char(substr(APKSTC, 1, 1), 1) , APPRGR
     c/end-exec
     C
     C*                           Gruppierung  tvrelwaeco/ABSATZB4
     c/exec sql
     c+ insert into tvrelwaeco/ABSATZB4#
     c+ SELECT akfirm,apkdnr,aptenr,jahr,        dec(
     c+ sum(jana+feba+MAEA+apra+maia+juna+jula+auga+sepa+okta+nova+ deza ),
     c+ 13, 2) qu, dec(
     c+ sum(janu+febu+MAEu+apru+maiu+junu+julu+augu+sepu+oktu+novu+ dezu ),
     c+ 13, 2) to FROM absatzb3#          GROUP BY akfirm,apkdnr,aptenr,jahr
     c/end-exec
     C
     C*
     C
     C     ##1000        ENDSR

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR

     C                   movel     rkreda        #rkreda           8
     C                   select
     C                   when      %subst(#RKREDA: 5: 2) = '01'
     c                   eval      JANA = JANA + (APGLMG)
     c                   eval      JANU = JANU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '02'
     c                   eval      FEBA = FEBA + (APGLMG)
     c                   eval      FEBU = FEBU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '03'
     c                   eval      MAEA = MAEA + (APGLMG)
     c                   eval      MAEU = MAEU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '04'
     c                   eval      APRA = APRA + (APGLMG)
     c                   eval      APRU = APRU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '05'
     c                   eval      MAIA = MAIA + (APGLMG)
     c                   eval      MAIU = MAIU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '06'
     c                   eval      JUNA = JUNA + (APGLMG)
     c                   eval      JUNU = JUNU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '07'
     c                   eval      JULA = JULA + (APGLMG)
     c                   eval      JULU = JULU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '08'
     c                   eval      AUGA = AUGA + (APGLMG)
     c                   eval      AUGU = AUGU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '09'
     c                   eval      SEPA = SEPA + (APGLMG)
     c                   eval      SEPU = SEPU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '10'
     c                   eval      OKTA = OKTA + (APGLMG)
     c                   eval      OKTU = OKTU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '11'
     c                   eval      NOVA = NOVA + (APGLMG)
     c                   eval      NOVU = NOVU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     C                   when      %subst(#RKREDA: 5: 2) = '12'
     c                   eval      DEZA = DEZA + (APGLMG)
     c                   eval      DEZU = DEZU +
     c                             ((RPNESU+RPERG1+RPERG2+RPERG3+RPERG4
     c                               +ZA1+ZA2+ZA3+ZA4                  )
     c                             * WAKURS )
     c                   other
     c                   endsl

     C     ##8000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
