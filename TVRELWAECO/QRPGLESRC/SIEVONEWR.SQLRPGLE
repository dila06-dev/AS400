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
      * Auswertung für Andreas
      * SELECT SUPNAM, SUPTYP, count(*) FROM sievo_vl2 GROUP BY SUPNAM,
      * SUPTYP
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
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
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     c
     c                   exsr      sr1000
     c                   exsr      sr1050
     c                   exsr      sr1060
     C                   EXSR      RETURN
     c

     C**************************************************************************
     C*changes total
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into tvrelwaeco/sievo_vl
     c+ select  a3.lifnr as lifnr,a3.lfrnam1  as lfrnam1,a3.lfrnam2 as
     c+ lfrnam2,a3.lndkez as lndkez, a3.konnum as konnum ,
     c+ (a1.recbtr*a2.wkur) as recbtr,a1.recbtr as recur,a2.wschl as wschl ,
     c+ (a1.stkmat*a2.wkur) as stkmat, a4.lfdstkfra as lfdstkfra, a4.lfdstk
     c+ as lfdstk , (a1.stkabw*a2.wkur) as stkabw, a1.artnum as
     c+ artnum,a1.recmng as recmng, a1.recenh as recenh, a4.bez2 as
     c+ bez2,a4.bez3 as bez3,a4.krzbez as krzbez,a1.recmng as recmng
     c+ ,a1.recenh as recenh, a4b.hbmw as hbmw , a5.typ as typ,
     c+ a4.lfdstk,a4.lfdstk1,a4.lfdstk2,a4.lfdstk3,a4.prsfak as
     c+ prsfakek,a4.ptprsfak as prsfakpt, a32.bezkonswe as
     c+ bezkonswe,a33.zahbedswe as zahbedswe,a4.prsenh as
     c+ prsenhartnum,a4.ptprsenh as ptprsenh,a4.basenh as basenh,a4.enh2 as
     c+ enh2,a4.enh3 as enh3,a4.fak2 as fak2,a4.fak3 as fak3,a4.efak2 as
     c+ efak2,a4.efak3 as efak3, a4.eeinh2 as eeinh2,
     c+ a4.eeinh3 as eeinh3,a4.gewenh as gewenh,a4.gewfak as gewfak
     c+ ,a531.bstnum as bstnum,a531.prsenh as prsenh,a531.enhlfr as
     c+ enhlfr,a531.faklfr as faklfr,a531.enhstl as enhstl,a531.fakmng as
     c+ fakmng,a531.enhmng as enhmng, a2.bucdat, a2.wkbez
     c+                               from PRODWIN51/Prj627P a1 left outer
     c+ join PRODWIN51/Prj626P a2 on a1.renr = a2.renr left outer join
     c+ PRODWIN51/Prj500p a3 on a3.lifnr = a2.lifnr and a3.hanr=a2.hanr left
     c+  outer join PRODWIN51/Prj582p2 a32 on a3.bezkon = a32.bezkon left
     c+ outer join PRODWIN51/Prj585p2 a33 on a3.zahbed = a33.zahbed left
     c+ outer join PRODWIN51/Prj015p a4 on a4.artnum = a1.artnum left outer
     c+ join PRODWIN51/Prj015p44 a4b on a4b.artnum = a4.artnum left outer
     c+ join PRODWIN51/Prj602P a5 on a5.art = a4.invart left outer join
     c+ PRODWIN51/Prj042p a6 on a6.dspber =
     c+ a4.f20  left outer join PRODWIN51/Prj684p a7 on a7.hbmw = a4b.hbmw
     c+ left outer join PRODWIN51/prj535p a535 on a535.wenr = a1.wenr left
     c+ outer join PRODWIN51/prj531p a531 on a531.bstnum = a535.bstnum and
     c+ a531.bstpos = a535.bstpos
     c+ where a2.fibsta = 1 and  a2.bucdat <> 0 and a535.bucdat <> 0 and
     c+ a5.typ <> 'B' and a1.aftnum = 0 and a1.kststl = 0 and
     c*33+ year(substr(char(a2.bucdat), 1, 4) concat '-' concat
     c*33+      substr(char(a2.bucdat), 5, 2) concat '-' concat
     c*33+      substr(char(a2.bucdat), 7, 2) ) > year(current date -2 year)
     c***+  die nächsten drei wieder sperren
     c***+ date(date(substr(char(a2.bucdat), 1, 4) concat '-' concat
     c***+      substr(char(a2.bucdat), 5, 2) concat '-' concat
     c***+      substr(char(a2.bucdat), 7, 2))) > (current date -365 day)
     c***+  die vier unteren wieder freigeben
     c+         zoned(substr(char(a2.BUCDAT), 1, 4), 4, 0) =
     c+         year(current date -1 month)                  and
     c+         zoned(substr(char(a2.BUCDAT), 5, 2), 2, 0) =
     c+         month(current date -1 month)
     c/end-exec
     c
     C     ##1000        ENDSR

     C**************************************************************************
     C*changes total
     C*-------------------------------------------------------------------------
     C*
     C     sr1050        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1050
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*==> sievo_vl2
     c/exec sql
     c+ insert into tvrelwaeco/SIEVO_VL2
     c+ SELECT char('DE411', 6) DCCODE, char(substr(char(artnum), 1, 11)
     c+ concat '         ', 20) INUMBE , char(' ', 60) IDESCR, char(' ', 5)
     c+ IDCO_, zoned (substr(char(BUCDAT), 1, 4), 4, 0) REPYEA,
     c+ zoned(substr(char(BUCDAT), 5, 2), 2, 0) REPMON, zoned
     c+ ((RECMNG*100), 10, 0) QTY , char((RECENH), 3) unit,
     c+ zoned((RECur*100), 10, 0) ACPAID, char(char(wkbez) concat ' ', 3)
     c+ CURREN , zoned(0, 10, 2) STK, zoned(0, 6, 0) STKPRI, char(LFRNAM1
     c+ concat ' ' concat lfrnam2, 100) SUPNAM, char(' ', 1) SUPTYP
     c+ ,char(' ', 2) SUPCOU, char(' ', 3) DELTER ,zoned(0, 3, 0) PAYTER,
     c+ zoned(0, 3, 1) CASHDI, char(' ', 1) GRPCON,char(' ', 3) PROGRP,
     c+ char(' ', 4) PURCHC,artnum, char(' ', 15) artnr,
     c+ dec((LIFNR), 7, 0) ktohab, char(' ', 100) Pname,
     c+ char(' ', 3) ZBD   FROM SIEVO_VL  a2
     c+ where
     c***+  die nächsten drei wieder sperren
     c***+ date(date(substr(char(a2.bucdat), 1, 4) concat '-' concat
     c***+      substr(char(a2.bucdat), 5, 2) concat '-' concat
     c***+      substr(char(a2.bucdat), 7, 2))) > (current date -365 day)
     c***+  die vier unteren wieder freigeben
     c+         zoned(substr(char(BUCDAT), 1, 4), 4, 0) =
     c+         year(current date -1 month)                  and
     c+         zoned(substr(char(BUCDAT), 5, 2), 2, 0) =
     c+         month(current date -1 month)
     c/end-exec
     c
     C     ##1050        ENDSR

     C**************************************************************************
     C*changes total
     C*-------------------------------------------------------------------------
     C*
     C     sr1060        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1060
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Bezeichnung
     c/exec sql
     c+ update tvrelwaeco/SIEVO_VL2   set idescr     =
     c+ (select max(artbez)     from bar_kalk/kalk_file
     c+   where  substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                             and version='$$EL_PS_DB'
     c+ group by artsku)
     c+         where exists
     c+ (select max(artbez)     from bar_kalk/kalk_file
     c+   where  substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                             and version='$$EL_PS_DB'
     c+  group by artsku)
     c/end-exec
     c
     c
     C*Artnr
     c/exec sql
     c+ update SIEVO_VL2   set artnr      =
     c+ (select max(artnr)     from bar_kalk/kalk_file
     c+  where  substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                              and version='$$EL_PS_DB'
     c+                          group by artsku)
     c+         where exists
     c+ (select max(artnr)     from bar_kalk/kalk_file
     c+  where  substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                              and version='$$EL_PS_DB'
     c+                          group by artsku)
     c/end-exec
     c
     c
     C*artnr als keyfeld
     c/exec sql
     c+ update SIEVO_VL2   set artnr      =
     c+ (select max(artnr)     from bar_kalk/kalk_file
     c+  where substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                      and version='$$EL_PS_DB' group by artsku)
     c+         where exists
     c+ (select max(artnr)     from bar_kalk/kalk_file
     c+  where substr(char(digits(ARTNUM)), 2, 10)   =artsku
     c+                      and version='$$EL_PS_DB' group by artsku)
     c/end-exec
     c
     C*statnr für P_gruppe
     c/exec sql
     c+ update SIEVO_VL2 a set PROGRP     =
     c+ (select max(TEEWPRGR)  from teew b
     c+  where a.artnr=TEEWTENR and TEEWFIRM ='01' group by TEEWPRGR)
     c+         where exists
     c+ (select max(TEEWPRGR)  from teew
     c+  where a.artnr=TEEWTENR and TEEWFIRM ='01' group by TEEWPRGR)
     c/end-exec
     c
     C*IDCO
     c***/exec sql
     c***+ update tvrelwaeco/SIEVO_VL2 a set a.idco_ =
     c***+  (select max(TEOSMM01) from teos
     c***+      where artnr = TEOSTENR  and TEOSKLCD = 'IDCO' and
     c***+            teosfirm in ('01') group by TEOSTENR )
     c***+             where exists
     c***+  (select max(TEOSMM01) from teos
     c***+      where artnr = TEOSTENR  and TEOSKLCD = 'IDCO' and
     c***+            teosfirm in ('01') group by TEOSTENR )
     c***/end-exec

     C*IDCO aus teew
     c/exec sql
     c+ update tvrelwaeco/SIEVO_VL2 a set a.idco_ =
     c+  (select TEEWIDCO      from teew01
     c+      where artnr = TEewTENR  and
     c+            teewfirm in ('01'))
     c+             where exists
     c+  (select TEEWIDCO      from teew01
     c+      where artnr = TEewTENR  and
     c+            teewfirm in ('01'))
     c/end-exec

     C*Unit
     c/exec sql
     c+ update  tvrelwaeco/SIEVO_VL2  set  unit = case
     c+ When unit     = 'K       ' then 'KG      '
     c+ When unit     = 'k       ' then 'KG      '
     c+ When unit     = 'M       ' then 'M       '
     c+ When unit     = 'm       ' then 'M       '
     c+ When unit     = 'ST      ' then 'PCS     '
     c+ When unit     = 'st      ' then 'PCS     '
     c+ When unit     = 'S       ' then 'PCS     '
     c+ When unit     = 's       ' then 'PCS     '
     c+ else unit
     c+ end
     c/end-exec


     C*Typ Lieferant E oder G(Gruppe) hier E
     c/exec sql
     c+ update   tvrelwaeco/sievo_vl2  set  SUPTYP = 'E  ' where
     c+   (substr(digits(KTOHAB), 1, 7) in ( select
     c+   substr(PKT0_KTO, 2, 7) from fpskto where
     c+   substr(PKT0_KTO, 1, 1)='2' and
     c+   PKT0_FIRMA  =51 and PKT0_VERBSAMKTOSL     ='001'  ))
     c/end-exec
     C*Typ Lieferant E oder G(Gruppe) hier G (Rest)
     c/exec sql
     c+ update   tvrelwaeco/sievo_vl2  set  SUPTYP = 'G  ' where
     c+   SUPTYP='   '
     c/end-exec

     C*Zahlungsbedingung
     c/exec sql
     c+ update tvrelwaeco/SIEVO_VL2 a set a.zbd= (select PKT0_ZBD from
     c+ fpskto where substr(digits(KTOHAB), 1, 7)= substr(PKT0_KTO, 2, 7)
     c+ and substr(PKT0_KTO, 1, 1)='2' and PKT0_FIRMA =51) where exists
     c+ (select PKT0_ZBD from fpskto where substr(digits(KTOHAB), 1, 7)=
     c+ substr(PKT0_KTO, 2, 7) and substr(PKT0_KTO, 1, 1)='2' and
     c+ PKT0_FIRMA =51)
     c/end-exec

     C*Land Code
     c/exec sql
     c+ update tvrelwaeco/sievo_vl2 a set pname= substr(pname, 1, 5)
     c+ concat
     c+ (select PKT0_LAND from fpskto where substr(digits(KTOHAB), 1, 7)
     c+ =substr(PKT0_KTO, 2, 7) and substr(PKT0_KTO, 1, 1)='2' and
     c+ PKT0_FIRMA =51) where exists (select PKT0_LAND from fpskto where
     c+ substr(digits(KTOHAB), 1, 7)= substr(PKT0_KTO, 2, 7) and
     c+ substr(PKT0_KTO, 1, 1)='2' and PKT0_FIRMA = 51)
     c/end-exec

     C*ZusatZname
     c/exec sql
     c+ update tvrelwaeco/sievo_vl2 a set pname = substr(pnAME, 01, 10)
     c+ concat
     c+ (select substr(LFPOLD, 1, 2) from lief b where
     c+ substr(digits(KTOHAB), 1, 5) = substr(LFLFNR, 1, 5)) where exists
     c+ (select substr(LFPOLD, 1, 2) from lief b where
     c+ substr(digits(KTOHAB), 1, 5) = substr(LFLFNR, 1, 5))
     c/end-exec
     c
     C*Delter
     c/exec sql
     c+ update  tvrelwaeco/SIEVO_VL2  set  delter = case
     c+ When substr(PNAME, 1, 3) = '002' then  'EXW'
     c+ When substr(PNAME, 1, 3) = '004' then  'EXW'
     c+ When substr(PNAME, 1, 3) = '006' then  'EXW'
     c+ When substr(PNAME, 1, 3) = '012' then  'EXW'
     c+ When substr(PNAME, 1, 3) = '001' then  'CIP'
     c+ When substr(PNAME, 1, 3) = '005' then  'CIF'
     c+ When substr(PNAME, 1, 3) = '007' then  'FOB'
     c+ When substr(PNAME, 1, 3) = '010' then  'FOB'
     c+ When substr(PNAME, 1, 3) = '   ' then  'EXW'
     c+ else delter
     c+ end
     c/end-exec

     C*SUPCOU
     c/exec sql
     c+ update  tvrelwaeco/SIEVO_VL2  set  SUPCOU = case
     c+ When substr(PNAME, 6, 3) = 'ROK' then  'KR'
     c+ When substr(PNAME, 6, 3) = 'USA' then  'US'
     c+ When substr(PNAME, 6, 3) = 'E  ' then  'ES'
     c+ When substr(PNAME, 6, 3) = 'I  ' then  'IT'
     c+ When substr(PNAME, 6, 3) = 'N  ' then  'NO'
     c+ When substr(PNAME, 6, 3) = '   ' then  'DE'
     c+ When substr(PNAME, 6, 3) = 'H  ' then  'HU'
     c+ When substr(PNAME, 6, 3) = 'RC ' then  'TW'
     c+ When substr(PNAME, 6, 3) = 'S  ' then  'SE'
     c+ When substr(PNAME, 6, 3) = 'L  ' then  'LU'
     c+ When substr(PNAME, 6, 3) = 'F  ' then  'FR'
     c+ When substr(PNAME, 6, 3) = 'B  ' then  'BE'
     c+ When substr(PNAME, 6, 3) = 'A  ' then  'AT'
     c+ When substr(PNAME, 6, 3) = 'J  ' then  'JP'
     c+ else substr(PNAME, 6, 2)
     c+ end
     c/end-exec


     C*Korrektur Währung
     c/exec sql
     c+ update tvrelwaeco/sievo_vl2
     c+ set curren='USD' where curren = 'IUS'
     c/end-exec

     C*Korrektur Währung
     c/exec sql
     c+ update sievo_VL2 set payter = zoned(zbd) where zbd <> '  ' and zbd
     c+ <> 'DNE' and zbd <> '003'
     c/end-exec
     c
     C*Korrektur Währung
     c/exec sql
     c+ insert into TVRELWAECO/#ID1999
     c+ SELECT DCCODE, INUMBE, IDESCR, IDCO_, REPYEA, REPMON, QTY, UNIT,
     c+ ACPAID, CURREN, STK, STKPRI, SUPNAM, SUPTYP, SUPCOU, DELTER,
     c+ PAYTER, CASHDI, GRPCON, PROGRP, PURCHC FROM sievo_VL2
     c+ where INUMBE <> '999' and               IDCO_ <> 'ERROR' AND
     c+  month(current date -1 month) =  digits(REPMON) and
     c+  year(current date -1 month) =  digits(REPYEA)
     c+
     c/end-exec
     c

     C     ##1060        ENDSR

     C**************************************************************************
     C*changes selektiv
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##2000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ update confirmcr set tstamp =
     c+ (SELECT current timestamp tstamp FROM qsys2/qsqptabl)
     c/end-exec
     c
     C     ##2000        ENDSR

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

     C     ##9999        ENDSR

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
