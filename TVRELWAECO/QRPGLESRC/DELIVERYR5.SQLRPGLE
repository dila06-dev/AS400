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
      * Orderdat:  Bestelldatum
      * Entrydat:
      * INPUTDAT:  Eingang der Order
      * Delivdat:  Auslieferungsdatum
      * CUSTOMDAT: Position, Kundenwunsch
      * Delivdatp: Lieferdatum aus Position nach Eingang der Auftragsposition
      * Billdat:   Rechnungsdatum
      * Pickdat:   Kommisionierungsdatum
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

     C*data base daily purchasing
     c                   exsr      sr6000

     C*data base daily backorders
     c*****              exsr      sr7000

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
     c+ insert into tvrelwaeco/packages
     c+ SELECT akafda Date_ordered_EDC,ALMAAF Local_Number,
     c+ zoned( 0, 4, 0) Local_Posit, APKWTE
     c+ Customer_requested_date ,ALTENR,ALTBZ1 Description,APBSMG
     c+ Qty_ordered ,ALGLMG Qty_shipped,ALLSDA Date_shipped_by_EDC, APAFST
     c+ part_shipped ,SEL0021 EDC_order_Number,ASSPED Carrier, aVPAKN
     c+ concat '`' Tracking_number_for_carrier, AVDPDN package_number,
     c+ decimal(AVGWBR, 8, 3) Weight, AVTENR package, akafst
     c+ Status_order,char(' ', 65) text, (ALLIJJ) concat '/' concat ALLINR
     c+ concat '/' concat char(ALLIPO) delivnote ,ALLSDA delivdate FROM
     c+        db_sped_sc,
     c+             afko, afpo WHERE ALAFJJ=akafjj and ALAFNR=AkAFNR and
     c+ ALAFJJ=apafjj and ALAFNR=APAFNR and ALAFPO=APAFPO and AMKDNR =
     c+ :§§amkdnr and akfirm in ('01', '51') and apfirm in ('01', '51')
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/packages set text       =
     c+ (SELECT DISTINCT max(TBTEXT) FROM txbe WHERE
     c+  TBJHJJ = (substr(EDC_ORDER_NUMBER, 1, 4)) and
     c+  TBAFNR = (substr(EDC_ORDER_NUMBER, 6, 6)) and
     c+  TBTCDE = 'TXSP' and TBFIRM in ('01','51') group by TBTEXT)
     c+  where exists
     c+ (SELECT DISTINCT max(TBTEXT) FROM txbe WHERE
     c+  TBJHJJ = (substr(EDC_ORDER_NUMBER, 1, 4)) and
     c+  TBAFNR = (substr(EDC_ORDER_NUMBER, 6, 6)) and
     c+  TBTCDE = 'TXSP' and TBFIRM in ('01','51') group by TBTEXT)
     c/end-exec
     C*

     c/exec sql
     c+ update tvrelwaeco/packages set text       =
     c+ (SELECT '100: fixdate => ' concat digits(WAO8LFTE) FROM wao8 WHERE
     c+  WAO8AFJJ = (substr(EDC_ORDER_NUMBER, 1, 4))  and
     c+  WAO8AFNR = (substr(EDC_ORDER_NUMBER, 6, 6))  and
     c+  WAO8AFPO = (substr(EDC_ORDER_NUMBER, 13, 4)) and
     c+  WAO8FIRM in ('01','51'))
     c+  where exists
     c+ (SELECT '100: fixdate => ' concat digits(WAO8LFTE) FROM wao8 WHERE
     c+  WAO8AFJJ = (substr(EDC_ORDER_NUMBER, 1, 4))  and
     c+  WAO8AFNR = (substr(EDC_ORDER_NUMBER, 6, 6))  and
     c+  WAO8AFPO = (substr(EDC_ORDER_NUMBER, 13, 4)) and
     c+  WAO8FIRM in ('01','51'))
     c/end-exec
     C*

     c/exec sql
     c+ update tvrelwaeco/packages set LOCAL_POSIT=
     c+ (SELECT  IFAPIFPO  FROM ifap WHERE
     c+  IFAPAFJJ = (substr(EDC_ORDER_NUMBER, 1, 4))  and
     c+  IFAPAFNR = (substr(EDC_ORDER_NUMBER, 6, 6))  and
     c+  IFAPAFPO = (substr(EDC_ORDER_NUMBER, 13, 4)) and
     c+  IFAPFIRM in ('01','51'))
     c+  where exists
     c+ (SELECT  IFAPIFPO  FROM ifap WHERE
     c+  IFAPAFJJ = (substr(EDC_ORDER_NUMBER, 1, 4))  and
     c+  IFAPAFNR = (substr(EDC_ORDER_NUMBER, 6, 6))  and
     c+  IFAPAFPO = (substr(EDC_ORDER_NUMBER, 13, 4)) and
     c+  IFAPFIRM in ('01','51'))
     c/end-exec
     C*

     C*
     c/exec sql
     c+ insert into tvrelwaeco/packagesII
     c+ SELECT * FROM tracker WHERE AMKDNR = :§§amkdnr
     c/end-exec

     C     ##6000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr7000        BEGSR
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
     c+ insert into qtemp/backordesc
     c+ SELECT apkdnr, APMAAF from afpo
     c+       WHERE APAFST='17' and apfirm='01' and
     c+             apkdnr in (select SALES# from salescomp) and
     c+ (date(substr(char(APLFTE), 1, 4) concat '-' concat
     c+       substr(char(APLFTE), 5, 2) concat '-' concat
     c+       substr(char(APLFTE), 7, 2))) > current date - 365 day
     c+       GROUP BY APKDNR, APMAAF
     c/end-exec

     c/exec sql
     c+ insert into QTEMP/#DC2580
     c+ SELECT * FROM ifak, ifap, ifad WHERE ifakmaaf in
     c+ (select APMAAF from qtemp/backordesc where apkdnr=ifapkdnr)
     c+ and IFAkIFFI=IFApIFFI
     c+ and IFAKIFNR=IFApIFNR
     c+ and IFAkIFFI=IFAdIFFI
     c+ and IFAKIFNR=IFAdIFNR
     c+ and ifakfirm=ifapfirm
     c+ and ifakfirm=ifadfirm
     c+ and IFAPFIRM in ('01','51')
     c/end-exec
     C*


     C     ##7000        ENDSR

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
