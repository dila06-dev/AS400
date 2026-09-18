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
      *  exsr      sr6666   *on
      * SELECT ASSPED, ALREDA, ALTENR, ALTBZ1, dec(sum(AVGWBR), 13, 2)
      * bruttogew, dec(sum(Alglmg), 13, 2) quantity, dec(count(*), 13, 2)
      * rate FROM db_sped_sc GROUP BY ASSPED, ALREDA, ALTENR,ALTBZ1
      * Datei MEIER in TVRELWAECO wurde ersetzt.
      *
      *
      *
      *
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
     c*************      exsr      sr6000
     c*************      exsr      sr6500
     C*packages
     c                   exsr      sr6600
     c*                  exsr      sr6666

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C**************************************************************************
     C*beispiel 5 days
     C*SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     C*       AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     C*       AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     C*       concat char(AlAFNR) concat '/' concat
     C*       char(digits(AlAFPO)), 20)
     C*FROM tvrelwaeco/#dp0050
     C*WHERE askmda <> 0 and ((
     C*date(substr(char(askmda), 1, 4) concat '-' concat
     C*substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     C*7, 2) ) = current date - 5 day ) or ( ALLSDA<>ALREDA and
     C*              alreda <> 0 and                              (
     C*date(substr(char(ALREDA), 1, 4) concat '-' concat
     C*substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     C*7, 2) ) = current date - 5 day ))) and substr(amKDNR, 1, 6) in
     C*(select SALES# from SALESCOMP)
     C*-------------------------------------------------------------------------
     C*
     C     sr6600        BEGSR
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
      * Achtung: Lieferschein und Rechnungsdatum können gleich sein
      * ab 22.02.2013
     c*+ 7, 2) ) = current date - 1 day ) or ( ALLSDA<>ALREDA and
     c/exec sql
     c+ insert into tvrelwaeco/db_sped_sc
     c+ SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     c+        AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     c+        AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     c+        concat char(AlAFNR) concat '/' concat
     c+        char(digits(AlAFPO)), 20)
     c+ FROM tvrelwaeco/#dp0050
     c+ WHERE askmda <> 0 and ((
     c+ date(substr(char(askmda), 1, 4) concat '-' concat
     c+ substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     c*+ 7, 2) ) = current date - 1 day ) or ( ALLSDA<>ALREDA and
     c+ 7, 2) ) = current date - 1 day ) or (
     c+               alreda <> 0 and                              (
     c+ date(substr(char(ALREDA), 1, 4) concat '-' concat
     c+ substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     c+ 7, 2) ) = current date - 1 day ))) and substr(amKDNR, 1, 6) in
     c+ (select SALES# from SALESCOMP)
     c/end-exec
     C*
     C*

     C     ##6600        ENDSR


     C**************************************************************************
     C*beispiel 5 days
     C*SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     C*       AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     C*       AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     C*       concat char(AlAFNR) concat '/' concat
     C*       char(digits(AlAFPO)), 20)
     C*FROM tvrelwaeco/#dp0050
     C*WHERE askmda <> 0 and ((
     C*date(substr(char(askmda), 1, 4) concat '-' concat
     C*substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     C*7, 2) ) = current date - 5 day ) or ( ALLSDA<>ALREDA and
     C*              alreda <> 0 and                              (
     C*date(substr(char(ALREDA), 1, 4) concat '-' concat
     C*substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     C*7, 2) ) = current date - 5 day ))) and substr(amKDNR, 1, 6) in
     C*(select SALES# from SALESCOMP)
     C*-------------------------------------------------------------------------
     C*
     C     sr6666        BEGSR
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
      * Achtung: Lieferschein und Rechnungsdatum können gleich sein
      * ab 22.02.2013
     c*+ 7, 2) ) = current date - 1 day ) or ( ALLSDA<>ALREDA and
     c/exec sql
     c+ insert into tvrelwaeco/db_sped_sc
     c+ SELECT AlAFJJ,AlAFNR,AlAFPO,aLLIJJ,ALLINR,allipo,ASSPED,avpakn,
     c+        AVDPDN,AVGWBR,AVTENR,ALMAAF,ALGLMG,ALLSDA,alreda,AMKDNR,
     c+        AMKDNR,ALTENR,ALTBZ1,ALAFDA, char(AlAFJJ concat '/'
     c+        concat char(AlAFNR) concat '/' concat
     c+        char(digits(AlAFPO)), 20)
     c+ FROM tvrelwaeco/#dp0050
     c+ WHERE askmda <> 0 and ((
     c+ year(substr(char(askmda), 1, 4) concat '-' concat
     c+ substr(char(askmda), 5, 2) concat '-' concat substr(char(askmda),
     c+ 7, 2) ) = year(current date)   ) or (
     c+               alreda <> 0 and                              (
     c+ year(substr(char(ALREDA), 1, 4) concat '-' concat
     c+ substr(char(ALREDA), 5, 2) concat '-' concat substr(char(ALREDA),
     c+ 7, 2) ) = year(current date)   )))
     c/end-exec
     C*
     C*

     C     ##6666        ENDSR


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
