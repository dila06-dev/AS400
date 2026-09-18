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
      * SELECT RPMUPLDTE, RPMFOO, RPMUPLENT, RPMCOO, RPMSKU, RPMSC,
      * RPMPRCQTY, RPMPRCUNT, RPMCOM, RPMSTK3, RPMWHG, RPMGUEVON,
      * RPMGUEBIS, RPMBRAND, RPMREPORT, RPMTMP, ULAND, lIEFERANT1,
      * LIEFERANT2 , artnr, artsku, artbezfra, char(' ', 035) lief1,
      * char(' ', 035) lief2 FROM TVRELWAECO/RPMIIUPLOD ,
      * bar_kalk/kalk_file WHERE RPMFOO ='DE411' and (RPMSKU = artsku or
      * RPMSKU = artsku or RPMSKU = artbezfra) and version='$$EL_PS_DB'
      * Datei RPMIICHECK in TVRELWAECO wurde ersetzt.
      * and artsku not in (select RPMSKU from tvrelwaeco/RPMII)
      *
      * update        RPMIICHECK   set lief1 =
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant1 and lffirm='01')
      * where exists
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant1 and lffirm='01')
      *
      * update        RPMIICHECK   set lief2 =
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant2 and lffirm='01')
      * where exists
      * (sELECT lfnam1 from lief  where
      *      LFLFNR  = lieferant2 and lffirm='01')
      *
      * update        RPMIICHECK
      * set lieferant2 =' ' where lieferant1=lieferant2
      * 1489 Zeilen in RPMIICHECK in TVRELWAECO aktualisiert.
      * update        RPMIICHECK
      * set lief2      =' ' where lief1     =lief2
      * 1489 Zeilen in RPMIICHECK in TVRELWAECO aktualisiert.
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)

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

     C*                 sr1000 inaktiv set 17.01.2014
     c                   exsr      sr2000
     c                   exsr      sr3000
     C*                 Achtung für Budget Daten einfach SR2000 und
     C*                             sr3000 auf Kommentar setzten und
     C*                             normler run über call RPMIINEWC
     C*                             vorher muss controlling den
     C*                             letzten Bedgetlauf machen, da
     C*                             beide die selbe Datei verwenden
     C*                             und den 5000 aktivieren
     c*                  exsr      sr5000
     c                   exsr      return

     C**************************************************************************
     C*Definition: Filterung aller Artikel
     C*            - mit Absatz/Umsatz <> 0 aus lfd Jahr + Vorjahr
     C*            - einem STK3 Wert > 0 ...,
     C*            - Bestandteil der factory datei ist (RPMII_F)
     C*              -----------------------
     C*
     C*  ( die in dieser Datei zum ersten mal auflaufen und
     C*    Kunden der Group sind (Verzeichnis)
     C*    artsku not in (select RPMSKU from tvrelwaeco/RPMII where
     C*                   rpmsc = :Distribut)                       )
     C**************************************************************************
     C*Definition: - wie oben jedoch
     C*            - nicht Bestandteil der factory datei ist (RPMII_F)
     C*              -----
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c****** jetzt für jede Kombination WAECO als factory/KUNDE
     c****** Gang/Göries 23.04.2013
     c******             movel     'DE411'       #kunde           10

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artnr,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c**    and statnr not in
     c**        ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     C**   *** Achtung  statnr < '799'                                       */
     c+     and statnr < '799'  and  artnr <> '8887100008'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c**    and statnr not in
     c**        ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     C**   *** Achtung  statnr < '799'  and  artnr <> '8887100008'           */
     c+     and statnr < '799' and  artnr <> '8887100008'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ artnr, artsku, substr(artbezfra, 1, 15),
     c+ current timestamp
     c+ from bar_kalk/kalk_file, gang/CODEKUNDEs where
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0
     c+     and COSTPRS_AR > 0
     c**    and statnr not in
     c**        ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant2 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))
     c+     and
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 <>' ' ))
     C**   *** Achtung  statnr < '799'                                       */
     c+     and statnr < '799'  and  artnr <> '8887100008'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec


     C     ##2000        ENDSR

     C**************************************************************************
     C*Definition: - wie oben jedoch
     C*            - nicht Bestandteil der factory datei ist (RPMII_F)
     C*              -----
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##3000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*
     C*Kennung für neue sku als overwrite
     c*/exec sql
     c*+ update  tvrelwaeco/RPMIIUPLOD set  RPMREPORT =
     c*+ substr(RPMREPORT, 1, 19) concat '$'  where  $ARTNR in
     c*+ (select TEOSTENR   from teos  where
     c*+  teosklcd='SKU ' and TEOSFIRM in ('01','51')  and TEOSMM01 <> ' ')
     c*/end-exec

     C*neue sku als overwrite
     c*/exec sql
     c*+ update  tvrelwaeco/RPMIIUPLOD set  RPMSKU =
     c*+ (select TEOSMM01   from teos
     c*+  where $ARTNR=TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c*+       ('01','51')  and TEOSMM01 <> ' ' )
     c*+ where exists
     c*+ (select TEOSMM01   from teos
     c*+  where $ARTNR=TEOSTENR and teosklcd='SKU ' and TEOSFIRM in
     c*+       ('01','51')  and TEOSMM01 <> ' ' )
     c*/end-exec

     C     ##3000        ENDSR

     C**************************************************************************
     C*Definition: - wie oben jedoch
     C*            - nicht Bestandteil der factory datei ist (RPMII_F)
     C*            B U D G E T - D A T E N  aus  tvrelwaeco/RPMKALKUL
     C* + anschließend manipulation
     C*update              tvrelwaeco/RPMIIuplod set RPMSTK3 =3828
     C*                                          WHERE RPMSKU ='8887100007'
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##5000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c****** jetzt für jede Kombination WAECO als factory/KUNDE
     c****** Gang/Göries 23.04.2013
     c******             movel     'DE411'       #kunde           10

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15),
     c+ current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+         ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     C**   *** Achtung  statnr < '799'                                       */
     c+     and statnr < '799'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15),
     c+ current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+     ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant1 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))   or
     c+          artz1 ='KON'                             or
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 = ' ' ))
     C**   *** Achtung  statnr < '799'                                       */
     c+     and statnr < '799'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMIIuplod
     c+ SELECT distinct
     c+        char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , WAOFVEUR,
     c*** ==>   + char(:#kunde,  10),   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ char(code ,  10)  ,   dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(ST3_KALK  *100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2015' concat '0101', 8) ab,
     c+ char(   '2015' concat '1231', 8) bis,
     c+ char('Waeco     ', 20) Brand, char('          ', 20) comment,
     c+ WAOFVEUR, artsku, substr(artsku, 1, 15),
     c+ current timestamp
     c+ from tvrelwaeco/RPMKALKUL, gang/CODEKUNDEs where WAOFKAJJ =2015 and
     c+     ST3_KALK   > 0  and ARTSTATUS ='01' and anldat <> 0
     c+     and statnr not in
     c+         ('190','199','290','299','399','490','491','499')
     c+     and ((lieferant2 in (select LFLFNR from lief01
     c+          WHERE LFFIRM ='01' and lflfat<>'000'))
     c+     and
     c+          (LIEFERANT1  = ' ' and LIEFERANT2 <>' ' ))
     C**   *** Achtung  statnr < '799'                                       */
     c+     and statnr < '799'
     c****+     and artsku    not in ( select RPMSKU from RPMII_F )
     c****+     and artbezfra not in ( select RPMSKU from RPMII_F )
     C**   *** Achtung mit Hauptartikel umsatz abfragen                      */
     c****+     and artnr   in ( select artnr  from absatzb3  where
     c****+         aptenr= artnr and
     c***+         substr(char(jahr), 1, 4)>char(year(current date -2 year))
     c****+         and APKDNR in ( select distinct kunde from CODEKUNDEs ))
     c/end-exec


     C     ##5000        ENDSR

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
