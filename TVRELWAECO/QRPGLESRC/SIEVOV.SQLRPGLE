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
      **** Änderung der Vorselektion Gude 25.04.2013  (alte Version)         */
      * ((STATNR in ('190','199','290','299','399','490','491', '499')
      *   and version = '$$EL_PS_DB')                                  or
      *  (statnr  >'900'  and      version = '$$EL_PS_DB')             or
      *  (a001 <> 0       and      version = '$$EL_PS_DB')             or
      *  (abc not in ('X','Z') and version = '$$EL_PS_DB')             or
      *  (date (date(substr(char(anldat), 1, 4) concat '-' concat
      *        substr(char(anldat), 5, 2) concat '-' concat
      *        substr(char(anldat), 7, 2) )) > current date -31 days and
      *                            version = '$$EL_PS_DB'))
      *
      *
      *********************************************************************************


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

     C*data base tvrelwaeco/SIEVOII
     c                   exsr      sr2000

     C                   EXSR      RETURN

     C*alle lagerdaten aufbauen für Folgeprozess
     C**************************************************************************
     C*tvrelwaeco/SIEVOII
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
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

     C*----------------------------------------------
     C*alle offenen Bestellungen Lieferantenbewertung
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR1
     c+ SELECT EkLFNR, EpBEJJ, EpBENR , epmeng, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, epbest , dec( (days (date(substr(char(EPBETE), 1, 4) concat
     c+ '-' concat substr(char(EPBETE), 5, 2) concat '-' concat
     c+ substr(char(EPBETE), 7, 2) )) - days(current date) ), 8, 0) differ,
     c+ current timestamp FROM bbek, bbep WHERE EKFIRM=epFIRM and
     c+ EKBEJJ=epbeJJ and EKBENR=EpBENR and epbejj>2011 and epbest < '30'
     c+ and ekfirm in ('01', '51') and epfirm in ('01', '51')
     c/end-exec

     C*abschliessende Analyse
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR2
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, dec(max(differ), 8, 0) maximal , dec(min(differ),
     c+ 8, 0) minimal , dec(count(*), 8, 0) count, current timestamp FROM
     c+ DB_OPTLFR1 GROUP BY EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO,
     c+ EKBEDA, EPBETE, EPBEST ORDER BY EKLFNR, EPBEJJ, EPBENR
     c/end-exec

     C*Abstimmung mit WE's 825
     c/exec sql
     c+ insert into tvrelwaeco/DB_OBT_WAE
     c+ SELECT #LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
     c+        #LBLBLGBS,#AEBEJJ,#AEBENR,#AEBEPO,
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ month(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),
     c+ week(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )),current timestamp tstamp
     c+ FROM datenkw/#lblb WHERE #STORNO<>'J' and  #LBLBLSTC in
     c+   ('825','825','825','825','825','825','000','000','000') and
     c+   #STORNO <> 'J' and
     c+ year(date(substr(char(#LBLBBDAT), 1, 4) concat '-' concat
     c+      substr(char(#LBLBBDAT), 5, 2) concat '-' concat
     c+      substr(char(#LBLBBDAT), 7, 2) )) >year(current date -1 year)
     c/end-exec

     C*abschliessende Analyse mit Zuordnung WE's
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR3
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, MAXIMAL, MINIMAL, "COUNT", SEL0013, #LBLBLSTC,
     c+ #LBLBTENR, #LBLBBDAT, #LBLBBWMG, #LBLBBWME, #LBLBLGBS, #AEBEJJ,
     c+ #AEBENR, #AEBEPO, SEL0010, SEL0011, SEL0012, TSTAMP,
     c+ dec(0, 12, 2) a001, char(' ', 50) Name                 FROM
     c+ DB_OPTLFR2, DB_OBT_WAE WHERE EPBEJJ = #AEBEJJ and EPBENR = #aeBENR
     c+ and EPBEPO = #aeBEPO
     c/end-exec

     C*abschliessende Analyse ohne WE's
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR3
     c+ SELECT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO, EKBEDA,
     c+ EPBETE, EPBEST, MAXIMAL, MINIMAL, "COUNT", SEL0013, ' ' #LBLBLSTC,
     c+ ' ' #LBLBTENR, 0 #LBLBBDAT, 0 #LBLBBWMG, ' ' #LBLBBWME,
     c+ 0  #LBLBLGBS, 0 #AEBEJJ, ' ' #AEBENR, 0  #AEBEPO,
     c+ 0  SEL0010, 0 SEL0011, 0 SEL0012, current timestamp TSTAMP,
     c+ dec(0, 12, 2) a001, char(' ', 50) Name                     FROM
     c+ DB_OPTLFR2    WHERE  epbejj not in ( select #AEBEJJ from DB_OBT_WAE
     c+ where  EPBENR=#aeBENR and  EPBEPO =#aeBEPO)
     c/end-exec


     C     ##2000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
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
     C
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
