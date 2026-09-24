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
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*data base three
     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
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

     C*
     C*alle Wareneingänge präpariert
     c/exec sql
     c+ insert into tvrelwaeco/DB_WAE130
     c+ SELECT #LBLBTENR, #LBLBLSTC, #LBLBBWMG, #LBLBBDAT, LSLSTC, LSSBEZ,
     c+ A.#AEFIRM, A.#AEBEJJ, A.#AEBENR, A.#AEBEPO, A.#AEWEJJ, A.#AEWENR ,
     c+ A.#LBLBDAKY, dec(0, 13, 2) STK3, dec(0, 13, 2) preis,char(' ', 2)
     c+ akfirm, zoned(0000, 4, 0) AKAFJJ, char(' ', 6) akAFNR, char(' ',
     c+ 10) akKDNR,dec(0, 13, 2) PRreisst, zoned(0, 11, 2) APNESU,zoned(0,
     c+ 11, 2) APGLMG, dec(0, 15, 0) rrn,char(' ', 10) APKDNR,
     c+ char(' ', 03) APafat,zoned(0, 8, 0) rkreda,char(' ', 03) rkwacd,
     c+ char(' ', 15) aptenr,zoned(0, 11, 2) rpnesu,zoned(0, 11, 2) rpbrsu,
     c+ zoned(0, 11, 2) rperg1,zoned(0, 11, 2) rperg2,
     c+ zoned(0, 11, 2) rperg3,zoned(0, 11, 2) rperg4,zoned(0, 11, 2) z1,
     c+ zoned(0, 11, 2) z2,zoned(0, 11, 2) z3,zoned(0, 11, 2) z4,
     c+ zoned(0, 09, 2) rkmws1,zoned(0, 11, 2) rkwawt,char(' ', 02) kdfirm,
     c+ char(' ', 2) kdkdst,char(' ', 30) kdnam1,char(' ', 03) kdpold,
     c+ char(' ', 03) kdland,char(' ', 01) kdabwa,char(' ', 01) kdvkgb,
     c+ char(' ', 04) kdkdgr,char(' ', 03) kdkstc, char(' ', 01) kdstub,
     c+ char(' ', 03) kdfr03,char(' ', 03) artgrp,char(' ', 03) statnr,
     c+ char(' ', 01) abc,char(' ', 10) LIEFERANT1,char(' ', 15) e1,
     c+ char(' ', 25) #TESAAV,char(' ', 25) #TEDIAV,
     c+ zoned(0, 3, 0) #TEVOZ1 from datenkw/#lblb a, lbss WHERE
     c+ #LBLBLSTC in ('130') and substr(#lBLBTMST, 1, 4) > '2010' and
     c+ LSLSTC = #LBLBLSTC
     c/end-exec

     C*alle Wareneingänge präpariert
     c/exec sql
     c+ insert into tvrelwaeco/DB_WAE130b
     c+ SELECT A.#LBLBTENR, A.#LBLBLSTC, A.#LBLBBWMG, A.#LBLBBDAT,
     c+ A.LSLSTC, A.LSSBEZ, A.#AEFIRM, A.#AEBEJJ, A.#AEBENR, A.#AEBEPO,
     c+ A.#AEWEJJ, A.#AEWENR, A.#LBLBDAKY, A.STK3,dec((b.apnesu/b.apglmg),
     c+ 13, 2) PREIS, b.AKFIRM, b.akafjj, b.AKAFNR, b.AKKDNR,
     c+ dec((b.apnesu/b.apglmg), 13, 2) PRREISST,b.apnesu,b.apglmg,rrn(a),
     c+ b.apkdnr,b.apafat, b.rkreda,
     c+ b.rkwacd,b.aptenr,b.rpnesu,b.rpbrsu,b.rperg1,
     c+ b.rperg2,b.rperg3,b.rperg4,z1,z2,z3,z4,b.rkmws1,b.rkwawt,kdfirm,
     c+ kdkdst, kdnam1,kdpold,kdland,kdabwa,kdvkgb,kdkdgr,kdkstc,kdstub,
     c+ kdfr03,artgrp,statnr,abc,LIEFERANT1,e1,#TESAAV,#TEDIAV,#TEVOZ1
     c+        FROM DB_WAE130 a, statistik b WHERE substr(#LBLBDAKY, 01,
     c+ 4) = b.AKAFJJ and substr(#LBLBDAKY, 05, 6) = b.AKAFNR and
     c+ substr(#LBLBDAKY, 12, 4) = digits(b.APAFPO) and akafat not in
     c+ ('10', '11', '12', '13', '14', '15', '16', '17', '18', '20', '30',
     c+ '31', '04', '41', '44', '70', '88', '89', '02') and b.apglmg <> 0
     c/end-exec

     C*Positionen aufbauen mit Wareneingängen
     c/exec sql
     c+ delete  FROM tvrelwaeco/DB_WAE130
     c+         WHERE RRN(DB_WAE130) in (select sel0023 from
     c+         tvrelwaeco/DB_WAE130b)
     c/end-exec

     C*Positionen aufbauen mit Wareneingängen
     c/exec sql
     c+ insert into tvrelwaeco/DB_WAE130
     c+ select * from tvrelwaeco/DB_WAE130b
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    STK3    =
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select STK_LCP  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    #TESAAV =
     c+ (select #TESAAV  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select #TESAAV  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    #TEDIAV =
     c+ (select #TEDIAV  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select #TEDIAV  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    #TEVOZ1 =
     c+ (select #TEVOZ1  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select #TEVOZ1  from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    artgrp  =
     c+ (select artgrp   from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select artgrp   from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    statnr  =
     c+ (select statnr   from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select statnr   from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    abc     =
     c+ (select abc      from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select abc      from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set  LIEFERANT1=
     c+ (select LIEFERANT1 from bar_kalk/kalk_file where artnr=#LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select LIEFERANT1 from bar_kalk/kalk_file where artnr=#LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    e1      =
     c+ (select e1       from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c+ where exists
     c+ (select e1       from bar_kalk/kalk_file where artnr = #LBLBTENR and
     c+         version = '$$EL_PS_DB')
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    kdfirm  =
     c+ (select kdfirm   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select kdfirm   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDKDST  =
     c+ (select KDKDST   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDKDST   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDNAM1  =
     c+ (select KDNAM1   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDNAM1   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDPOLD  =
     c+ (select KDPOLD   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDPOLD   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDLAND  =
     c+ (select KDLAND   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDLAND   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDLAND  =
     c+ (select KDLAND   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDLAND   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDABWA  =
     c+ (select KDABWA   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDABWA   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDVKGB  =
     c+ (select KDVKGB   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDVKGB   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDKDGR  =
     c+ (select KDKDGR   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDKDGR   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDKSTC  =
     c+ (select KDKSTC   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDKSTC   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDSTUB  =
     c+ (select KDSTUB   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDSTUB   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C*...
     c/exec sql
     c+ update tvrelwaeco/DB_WAE130  set    KDFR03  =
     c+ (select KDFR03   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c+ where exists
     c+ (select KDFR03   from kund01  where AKKDNR= KDKDNR and
     c+                                     kdfirm in ('01', '51'))
     c/end-exec

     C     ##1000        ENDSR

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
     C*alle Bestellungen mit Bestelldatum > current date -007 days
     C*oder offene Bestellungen
     c/exec sql
     c+ insert into tvrelwaeco/PURCHASING
     c+ SELECT * FROM bbek b, bbep a WHERE EKFIRM=epFIRM and EKBEJJ=epbeJJ
     c+ and EKBENR=EpBENR and ( epbejj=2012 and date(substr(char(EkBEDA),
     c+ 1, 4) concat '-' concat substr(char(EkBEDA), 5, 2) concat '-'
     c+ concat substr(char(EkBEDA), 7, 2) ) > current date - 007 day or
     c+ (epbest <> '65'  and
     c+   year(date(substr(char(EkBEDA), 1, 4) concat '-' concat
     c+        substr(char(EkBEDA), 5, 2) concat '-' concat
     c+        substr(char(EkBEDA), 7, 2) )) =year(current date)))
     c+  and ekfirm in ('01', '51') and epfirm in ('01', '51')
     c/end-exec

     C*Positionen aufbauen mit Wareneingängen
     c/exec sql
     c+ insert into tvrelwaeco/PURCHwae
     c+ SELECT * FROM purchasing a, bwae WHERE aeFIRM=epFIRM and
     c+ aeBEJJ=epbeJJ and aeBENR=EpBENR and A.EPBEPO = BWAE.AEBEPO
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
