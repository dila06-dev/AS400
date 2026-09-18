     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
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
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      * ORDERDAT  ENTRYDAT  INPUTDAT  DELIVDAT  CUSTOMDAT  DELIVDATP  BILLDAT   PICKDAT2
      * 07.01.10  30.12.10  27.01.10  12.08.11  29.01.10   30.12.10   15.08.11  11.08.11
      * 10.02.10  30.12.10  10.02.10  13.09.11  10.02.10   16.09.11   16.09.11  09.09.11
      * 17.02.10  30.12.10  17.02.10  05.01.11  20.12.10   30.12.10   06.01.11  05.01.11
      * 14.03.10  30.12.10  04.03.10  17.08.11  21.09.10   19.08.11   17.08.11  16.08.11
      * 12.03.10  30.12.10  12.03.10  15.08.11  06.05.10   30.12.10   22.08.11  11.08.11
      * 16.03.10  30.12.10  16.03.10  15.08.11  19.03.10   30.12.10   18.08.11  11.08.11
      * 13.04.10  30.12.10  13.04.10  06.01.11  13.04.10   30.12.10   10.01.11  06.01.11
      *
      *
      *********************************************************************************

     f***man       uf   e             disk
     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)
     F***                                     USROPN

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
     Dpos              s             10i 0
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
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C*                  open      man
     C*                  DO        *HIVAL
     C*
     C*                  READ      man                                    95
     C*                  IF        *in95 = '1'
     C*                  leave
     C*                  else
     C*                  movel     man12         artnr
     C*                  exsr      srlines
     c*                  update    phy01r
     c*                  endif
     C
     C*                  enddo
     C*                  close     man
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base three
     c                   exsr      sr6000

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     c/exec sql
     c+ insert into tvrelwaeco/itemsr
     c+ SELECT APTENR,  char(substr(rkreda, 1, 4), 4) jahr,
     c+ dec(sum(APGLMG), 13, 0) Absatz, dec(sum(RPNESU), 13, 0) Umsatz,
     c+ dec(sum(JANA), 13, 0) JAN_A, dec(sum(FEBA), 13, 0) FEB_A,
     c+ dec(sum(MAEA), 13, 0) MAE_A, dec(sum(APRA), 13, 0) APR_A,
     c+ dec(sum(MAIA), 13, 0) MAI_A, dec(sum(JUNA), 13, 0) JUN_A,
     c+ dec(sum(JULA), 13, 0) JUL_A, dec(sum(AUGA), 13, 0) AUG_A,
     c+ dec(sum(SEPA), 13, 0) SEP_A, dec(sum(OKTA), 13, 0) OKT_A,
     c+ dec(sum(NOVA), 13, 0) NOV_A, dec(sum(DEZA), 13, 0) DEZ_A,
     c+ dec(sum(JANu), 13, 2) JAN_u, dec(sum(FEBu), 13, 2) FEB_u,
     c+ dec(sum(MAEu), 13, 2) MAE_u, dec(sum(APRu), 13, 2) APR_u,
     c+ dec(sum(MAIu), 13, 2) MAI_u, dec(sum(JUNu), 13, 2) JUN_u,
     c+ dec(sum(JULu), 13, 2) JUL_u, dec(sum(AUGu), 13, 2) AUG_u,
     c+ dec(sum(SEPu), 13, 2) SEP_u, dec(sum(OKTu), 13, 2) OKT_u,
     c+ dec(sum(NOVu), 13, 2) NOV_u, dec(sum(DEZu), 13, 2) DEZ_u FROM
     c+ absatzb WHERE APTENR in ( select substr(char(items), 1, 15) from
     c+ items) GROUP BY APTENR,char(substr(rkreda, 1, 4), 4)
     c/end-exec

     C*
     c/exec sql
     c+ insert into tvrelwaeco/ITEMSRBGFS
     c+ SELECT FAK5090,
     c+ char(('20' concat substr(digits(fak5480), 5, 2)), 4) jahr,
     c+ char((substr(digits(fak5480), 3, 2)), 2) Monat,
     c+ dec(sum(FAK5320), 13, 2) menge, dec(sum(FAK5550), 13, 2) absatz
     c+ FROM f5
     c+ WHERE FAK5090 in (select substr(char(items), 1, 15) from items)
     c+ GROUP BY FAK5090,
     c+ char(('20' concat  substr(digits(fak5480), 5, 2)), 4),
     c+ char((substr(digits(fak5480), 3, 2)), 2) ORDER BY fak5090 ,
     c+ char(('20' concat  substr(digits(fak5480), 5, 2)), 4),
     c+ char((substr(digits(fak5480), 3, 2)), 2)
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/itemsr
     c+ SELECT FAK5090, JAHR, sum(MENGE), sum(ABSATZ), dec(0, 13, 0),dec(0,
     c+ 13, 0),dec(0, 13, 0), dec(0, 13, 0),dec(0, 13, 0),dec(0, 13, 0),
     c+ dec(0, 13, 0),dec(0, 13, 0),dec(0, 13, 0), dec(0, 13, 0),dec(0, 13,
     c+ 0),dec(0, 13, 0), dec(0, 13, 0),dec(0, 13, 0),dec(0, 13, 0), dec(0,
     c+ 13, 0),dec(0, 13, 0),dec(0, 13, 0), dec(0, 13, 0),dec(0, 13,
     c+ 0),dec(0, 13, 0), dec(0, 13, 0),dec(0, 13, 0),dec(0, 13, 0) FROM
     c+ itemsrbgfs GROUP BY FAK5090, JAHR
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JAN_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='01'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='01'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set FEB_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='02'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='02'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set MAE_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='03'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='03'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set APR_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='04'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='04'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set MAI_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='05'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='05'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JUN_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='06'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='06'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JUL_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='07'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='07'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set AUG_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='08'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='08'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set SEP_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='09'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='09'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set OKT_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='10'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='10'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set NOV_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='11'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='11'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set DEZ_A =
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='12'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(MENGE) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='12'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JAN_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='01'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='01'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set FEB_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='02'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='02'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set MAE_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='03'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='03'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set APR_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='04'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='04'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set MAI_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='05'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='05'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JUN_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='06'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='06'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set JUL_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='07'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='07'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set AUG_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='08'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='08'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set SEP_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='09'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='09'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set OKT_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='10'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='10'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set NOV_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='11'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='11'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/itemsr a set DEZ_U =
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='12'
     c+         group by FAK5090, Jahr, Monat)
     c+ where exists
     c+ (select sum(ABSATZ) from ITEMSRBGFS where
     c+         FAK5090=APTENR and jahr = a.jahr and MONAT='12'
     c+         group by FAK5090, Jahr, Monat)
     c/end-exec

     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
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
     C     sr9999        BEGSR
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
