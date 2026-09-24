     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * vorher SIEVONEWR anpassen datumsabfrage
      *
      *
      * SELECT INUMBE, decimal(sum(QTY), 09, 0) qty,
      *         decimal(sum(ACPAID/100), 10, 2) ACPAID,
      *         CURREN, SUPNAM, SUPCOU, ARTNR FROM tvrelwaeco/SIEVO_VL2
      * WHERE REPYEA ='2014' GROUP BY INUMBE, IDESCR,CURREN ,SUPNAM,
      * SUPCOU, artnr
      *
      *
      * SELECT SCHWARZER.INUMBE, SCHWARZER.QTY , SCHWARZER.ACPAID,
      * decimal(((SCHWARZER.ACPAID / SCHWARZER.qty)*100), 10, 3) average ,
      * SCHWARZER.CURREN, SCHWARZER.SUPNAM, ARTBEZ, SCHWARZER.SUPCOU,
      * ARTGRP, SCHWARZER.ARTNR, KALK_FILE.STATNR, ABC, ULAND, LIEFERANT1,
      * LIEFERANT2, ZOLLNR, WACDVK, WACDEK, WEKPR, WAKURS, EKPR, stk_lcp ,
      * E1, TSTAMP FROM schwarzer, bar_kalk/Kalk_file WHERE SCHWARZER.ARTNR
      * = KALK_FILE.ARTNR and version='$$EL_PS_DB' and KALK_FILE.ARTNR
      * ='9102000022' ORDER BY KALK_FILE.ARTNR
      *
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fschwarzer2up   e           k disk    RENAME(schwarzer2:phy01r)
     f#PREIL5   if   e           k disk    RENAME(prei1:phy05r)

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   setoff                                       70
     c  n70              exsr      sr9999
     c                   seton                                        70
     c*********          if        artnr= '9102000022'
     c                   exsr      sr7002
     C                   update    phy01r
     C*********          endif

     C**************************************************************************
     C* SR7001: aktueller Einkaufspreis
     C*-------------------------------------------------------------------------
     C*
     C     SR7002        BEGSR
     C*
     c     key7002       klist
     c                   kfld                    PRFIRM
     c                   kfld                    PRBEGR
     c                   kfld                    PRKDLI
     c                   kfld                    PRTENR
     c****               kfld                    PRWACD
     c****               kfld                    PRGADA
     c****               kfld                    PRKDLG

     c                   movel     '01'          PRFIRM
     c                   movel     'LP1'         PRBEGR
     c                   movel     artnr         PRTENR
     c                   clear                   PRWACD
     c                   movel     lieferant1    PRKDLI
     c                   clear                   PRWACD
     c                   clear                   PRGADA
     c                   clear                   PRKDLG

     C     KEY7002       SETLL     #PREIL5                            92
     C     *IN92         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      #PREIL5                                92
     C     *IN92         IFEQ      '1'
     c     PRFIRM        orne      '01'
     c     PRBEGR        orne      'LP1'
     c     PRTENR        orne      artnr
     c     PRKDLI        orne      lieferant1
     C                   leave
     C                   else
     c                   if        ( PRGADA < xp or PRGADA = xp ) and
     c                             ( PRGBDA > xp or PRGBDA = xp
     c                               or  PRGBDA = 0 )
     C
     c                   z-add     1             faktor            5 0
     c                   if        prpdvk='1'
     c                   z-add     1             faktor
     c                   endif                                                  prpdvk=1
     c                   if        prpdvk='2'
     c                   z-add     10            faktor
     c                   endif                                                  prpdvk=2
     c                   if        prpdvk='3'
     c                   z-add     100           faktor
     c                   endif                                                  prpdvk=3
     c                   if        prpdvk='4'
     c                   z-add     1000          faktor
     c                   endif                                                  prpdvk=4
     c                   if        prpdvk='5'
     c                   z-add     10000         faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='6'
     c                   z-add     100000        faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='7'
     c                   z-add     5             faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='8'
     c                   z-add     25            faktor
     c                   endif                                                  prpdvk=5
     c                   if        prpdvk='9'
     c                   z-add     500           faktor
     c                   endif                                                  prpdvk=5
     C                   eval      WEKPR   =      PREZPR/faktor
     c                   eval      WACDEK  =      PRWACD
     C                   endif
     C                   endif
     C
     C                   enddo
     C                   endif

     C*
     C     ##7002        ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   clear                   xp                8 0
     C                   eval      xp=(pjahr*10000)+(pmonat*100)+ptag
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
