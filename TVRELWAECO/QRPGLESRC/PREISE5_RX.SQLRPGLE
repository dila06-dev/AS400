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
      * 177 (nur AUD), 176 (nur Rubel) mit rei für currency
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      * insert into tvrelwaeco/E_PREIS
      * SELECT zoned(01, 2, 0) #PRS010, char((substr(gruppe, 1, 3) concat
      * 'XXX'), 6) #PRS020, char('000', 3) #prs030, ITEM #prs040, zoned(
      * PVKNETTO, 9, 2) #prs050,
      *   zoned(substr(char(fromdat), 7, 2), 6, 0 ) *10000 +
      *   (zoned(substr(char(fromdat), 5, 2), 6, 0 )*100) +
      *   (zoned(substr(char(fromdat), 3, 2), 6, 0 )*1    ) #prs070,
      * char(' ', 15) #prs080, zoned(0 , 6, 0) #prs120, zoned(0, 6, 0)
      * #gebucht, ' ' #MODUS, char('CURRENCY no Hause Preis 2017', 50)
      * #version, zoned(0,9, 2)#PRS050_A,zoned(0, 6, 0) #PRS070_A,char(' ',
      * 15) #PRS080_A, zoned(0, 6, 0) #prs120_a FROM TVRELWAECO/PPKGUPDOUT
      * WHERE gruppe ='175' and H5 =current date and #TEILCHECK='J'
      * 18678 Zeilen in E_PREIS in TVRELWAECO eingefügt.
      *
      *
      *
      *
      *
      *
      *ics ==> 173   Übernahme Kalkulation auch in 174 und 175 aus 173
      *exec sql
      * insert into tvrelwaeco/E_PREIS
      * SELECT zoned(1, 2, 0) #PRS010, char('174XXX', 6) #PRS020,char('000',
      *  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
      * zoned(substr(char(current date -001 day), 1, 2)  concat
      * substr(char(current date -001 day), 4, 2)  concat
      * substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
      *                                             char(' ', 15) #prs080,
      * zoned(substr(char(current date +100 day), 1, 2)  concat
      * substr(char(current date +100 day), 4, 2)  concat
      * substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
      * zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
      * char(('$' concat substr(char(current timestamp), 01, 19)), 50)
      *  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
      * char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
      * FROM prei08
      * WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='173' and
      *       PRBEGR ='PKG' and
      *       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
      *                  'PPKGUPDINR', 'PRKGUPDINR') and
      *       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
      *                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
      *       and (prtstp > (select tstamp -0 minute from preise5_r)
      *                     or prtstp ='2000-12-22-09.21.40.188820')
      *end-exec
      *
      *
      *ics ==> 173   Übernahme Kalkulation auch in 174 und 175 aus 173
      *exec sql
      * insert into tvrelwaeco/E_PREIS
      * SELECT zoned(1, 2, 0) #PRS010, char('175XXX', 6) #PRS020,char('000',
      *  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
      * zoned(substr(char(current date -001 day), 1, 2)  concat
      * substr(char(current date -001 day), 4, 2)  concat
      * substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
      *                                             char(' ', 15) #prs080,
      * zoned(substr(char(current date +100 day), 1, 2)  concat
      * substr(char(current date +100 day), 4, 2)  concat
      * substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
      * zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
      * char(('$' concat substr(char(current timestamp), 01, 19)), 50)
      *  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
      * char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
      * FROM prei08
      * WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='173' and
      *       PRBEGR ='PKG' and
      *       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
      *                  'PPKGUPDINR', 'PRKGUPDINR') and
      *       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
      *                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
      *       and (prtstp > (select tstamp -0 minute from preise5_r)
      *                     or prtstp ='2000-12-22-09.21.40.188820')
      *end-exec
      *

      *  (PRFIRM ='01' and PRUSER ='GANG' and PRJDAT=20181220 and
      *   PRKDLG <> ' ' and PRWACD ='EUR' and PRPROG='PPKGUPDINR')
      *
      *
      *
      *
      *
      *
      *****************************************************************

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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     c                   exsr      sr1000
     C                   EXSR      RETURN

     C**************************************************************************
     C*Katalogdaten
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
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

     C*ics ==> 073        -01-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char(' 73XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='073' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec

     C*ics ==> 173        -02-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('173XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='173' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec


     C*ics ==> 273        -03-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('273XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='273' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec


     C*ics ==> 373        -04-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('373XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='373' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec


     C*ics ==> 174        -05-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('174XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='174' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec


     C*ics ==> 175        -06-
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('175XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='175' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec


     C*ics ==> 176   Übernahme Kalkulation nur für Rubel (RUB)
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('176XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='176' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec
     c
     C*ics ==> 177   Übernahme Kalkulation nur für AustrDollar (AUD)
     c/exec sql
     c+ insert into tvrelwaeco/E_PREIS
     c+ SELECT zoned(1, 2, 0) #PRS010, char('177XXX', 6) #PRS020,char('000',
     c+  3) #PRS030, PRTENR #PRS040, zoned(PREZPR, 9, 2) #PRS050,
     c+ zoned(substr(char(current date -001 day), 1, 2)  concat
     c+ substr(char(current date -001 day), 4, 2)  concat
     c+ substr(char(current date -001 day), 7, 2), 6, 0)   #PRS070,
     c+                                             char(' ', 15) #prs080,
     c+ zoned(substr(char(current date +100 day), 1, 2)  concat
     c+ substr(char(current date +100 day), 4, 2)  concat
     c+ substr(char(current date +100 day), 7, 2), 6, 0) #PRS120,
     c+ zoned(0, 6, 0) #GEBUCHT, char('#', 1) #modus,
     c+ char(('$' concat substr(char(current timestamp), 01, 19)), 50)
     c+  #version, zoned(0, 9, 2) #PRS050_A, zoned(0, 6, 0) #PRS070_A,
     c+ char(' ', 15)   #PRS080_A,  zoned(0, 6, 0) #PRS120_A
     c+ FROM prei08
     c+ WHERE PRWACD ='EUR' and PRFIRM ='01' and PRKDLG ='177' and
     c+       PRBEGR ='PKG' and
     c+       PRPROG in ('TRPREIST', 'TRTEILST', 'TRKVKKST',
     c+                  'PPKGUPDINR', 'PRKGUPDINR') and
     c+       PRUSER in ('GOERIES', 'MERSMANN', 'GANG   ', 'KLAFFKE',
     c+                  'KLAUS  ' , 'HAUSE  ', 'CAIRO  ', 'OSTENDORF')
     c+       and  prtstp =  '2018-12-20-12.38.09.513165'
     c+
     c/end-exec
     c
     c                   exsr      sr7500

     C     ##1000        ENDSR

     C**************************************************************************
     C*update der Steuerdatei Funktion date
     C*-------------------------------------------------------------------------
     C*
     C     sr7500        BEGSR
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

     C*Ableitung nach Auftragseingang            PRTSTP
     c/exec sql
     c+ update PREISE5_R set tstamp =
     c+ (SELECT current timestamp -02 minute tstamp FROM qsys2/qsqptabl)
     c***** (SELECT max(PRTSTP) FROM prei08 where prfirm='01')
     c*****+ (update preise5_r set tstamp=tstamp-60 minute)
     c/end-exec
     c
     C     ##7500        ENDSR

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
     C                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR
     C*
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

     C**************************************************************************
