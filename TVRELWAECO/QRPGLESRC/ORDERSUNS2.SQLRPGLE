     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
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
      *Status 10 ==> input in Gelüwe contains the order reference from
      *Gelüwe     example:;SVO15/00577/1,0000   OK
      *
      *Status 40 ==> assigned to a production order
      *Gelüwe     example:;SVO15/00577/1,0000   OK
      *
      *Status 50 ==> delivery   contains also the delivery note OK
      *example Dlvnote SZN15/00400  OK
      *
      *Status 90 ==> invoice#  contains the invoice#
      *example Invoice SVF15/00249    OK
      *
      *Status 91 ==> orderline refused (maybe i like to have the reason for
      *(maybe i like to have the reason for it) OK
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
     Dh610x            S            100A

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
     c                   exsr      sr7000
     c                   exsr      sr7500

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


     C*Status ?? orderline refused by special order
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 < '00'
     c+           group by c020, c030)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 < '00'
     c+           group by c020, c030)
     c/end-exec

     C*
     C*
     C*Status 10 in production
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat C070) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='10'
     c+           group by c020, c030, c110)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat C070) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='10'
     c+           group by c020, c030, c110)
     c/end-exec

     C*
     C*Status 40 in production
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='40'
     c+           group by c020, c030, c110)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='40'
     c+           group by c020, c030, c110)
     c/end-exec

     C*
     C*Status 50 in delivered
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='50'
     c+           group by c020, c030, c110)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='50'
     c+           group by c020, c030, c110)
     c/end-exec

     C*Status 50 delivered Anzahl der Positionen und der Menge
     c/exec sql
     c+  update ordersun set ZUSATZ = substr(ZUSATZ, 1, 50) concat
     c+   ( select char(dec(sum(C050), 13, 2)+10000) concat ' ' concat
     c+            char(dec(count(*), 13, 0))        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='50'
     c+           group by c020, c030)
     c+     where exists
     c+   ( select char(dec(sum(C050), 13, 2)+10000) concat ' ' concat
     c+            char(dec(count(*), 13, 0))        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='50'
     c+           group by c020, c030)
     c/end-exec


     C*Status 90 invoiced
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='90'
     c+           group by c020, c030, c110)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat c060) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='90'
     c+           group by c020, c030, c110)
     c/end-exec


     C*Status 90 invoiced Anzahl der Positionen und der Menge
     c/exec sql
     c+  update ordersun set ZUSATZ = substr(ZUSATZ, 1, 50) concat
     c+   ( select char(dec(sum(C050), 13, 2)+10000) concat ' ' concat
     c+            char(dec(count(*), 13, 0))        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='90'
     c+           group by c020, c030)
     c+     where exists
     c+   ( select char(dec(sum(C050), 13, 2)+10000) concat ' ' concat
     c+            char(dec(count(*), 13, 0))        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='90'
     c+           group by c020, c030)
     c/end-exec


     C*Status 91 orderline refused
     c/exec sql
     c+  update ordersun set ZUSATZ =
     c+   ( select max(c110 concat ' ' concat c070) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO and C110 ='91'
     c+           group by c020, c030, c110)
     c+     where exists
     c+   ( select max(c110 concat ' ' concat c070) from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO and C110 ='91'
     c+           group by c020, c030, c110)
     c/end-exec

     C*generell die Auftragsnummervon Geluwe
     c/exec sql
     c+  update ordersun set ZUSATZ = substr(ZUSATZ, 1, 80) concat
     c+   ( select max(c070)                        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR and
     c+           C030 = APAFPO
     c+           group by c020, c030)
     c+     where exists
     c+   ( select max(c070)                        from confirmsun
     c+     where substr(C020, 1, 4)= char(APAFJJ) and
     c+           substr(C020, 5, 6)= APAFNR  and
     c+           C030 = APAFPO
     c+           group by c020, c030)
     c/end-exec



     C*update Status Position aus Trend
     c/exec sql
     c+ update ordersun set apafst =
     c+ (select apafst from afpo where
     c+   ORDERSUN.APFIRM= afpo.APFIRM and ORDERSUN.APAFJJ= afpo.APAFJJ and
     c+   ORDERSUN.APAFNR= afpo.APAFNR and ORDERSUN.APAFPO= afpo.APAFPO and
     c+   ORDERSUN.apafst <> afpo.apafst)
     c+ where exists
     c+ (select apafst from afpo where
     c+   ORDERSUN.APFIRM= afpo.APFIRM and ORDERSUN.APAFJJ= afpo.APAFJJ and
     c+   ORDERSUN.APAFNR= afpo.APAFNR and ORDERSUN.APAFPO= afpo.APAFPO and
     c+   ORDERSUN.apafst <> afpo.apafst)
     c/end-exec



     C*update Status Position aus Trend  hier gelöscht!!!
     c/exec sql
     c+ update ordersun set apafst = 'DL' where
     c+ ordersun.APFIRM not in ( select afpo.APFIRM from afpo where
     c+   ORDERSUN.APFIRM= afpo.APFIRM and ORDERSUN.APAFJJ= afpo.APAFJJ and
     c+   ORDERSUN.APAFNR= afpo.APAFNR and ORDERSUN.APAFPO= afpo.APAFPO)
     c/end-exec


     C     ##6000        ENDSR

     C**************************************************************************
     C*wareneingänge buchen
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


     C*Übergabe der Wareneingäne (testsystem)
     c*bei Status 50 ==> delivery note
     c/exec sql
     c+ insert into tvpf/ifwe
     c+ select  distinct char(' ', 1) IFSCLOCK,  char('GANG#', 10) IFSCJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   IFSCJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)  IFSCJZEI,
     c+         char('GANG ', 10)                IFSCUSER,
     c+         char('ORDERIN_R6', 10)           IFSCPROG,
     c+         char('TVRELWAECO', 10)           IFSCBIBL,
     c+         substr(char(digits(C010)), 6, 2) IFSCFIRM,
     c+         char('001', 3)                   IFWEWKNR,
     c+         char(substr(c060, 01, 20), 20)   IFWEEXBL,
     c+         EUBEJJ IFWEBEJJ, EUBENR IFWEBENR, EUBEPO IFWEBEPO,
     c+         substr(C100, 1, 10)              IFWETENR,
     c+         char('011', 3)                   IFWELANR,
     c+         char(substr(C070, 01, 11), 15)   IFWEBLIN,
     c+         zoned(c050, 11, 2)               IFWEMENG,
     c+         char('S', 1 )                    IFWEMEIN,
     c+         zoned(0, 8, 0)                   IFWEWEDA,
     c+         zoned(0, 6, 0)                   IFWEWEUZ,
     c+         char('00', 2 )                   IFWESTAT,
     c+         char('  ', 4 )                   IFWEFENR,
     c+         char('  ', 10 )                  IFWEFFLD,
     c+         Timestamp(Generate_Unique()) + 2 hour ifwetstp,
     c******    C090                             iBSCTSTP,
     c+         char('GANG ', 10)                IFWEERUS,
     c+         char(' ', 20)                    IFWECHAR,
     c+         char('001', 8)                   IFWELORT,
     c+         char(' ', 1)                     IFWETLKZ,
     c+         zoned(0, 8, 0)                   IFWEVEDA,
     c+         char('92678 ', 10)               IFWELFNR,
     c+         char('  ', 3 )                   IFWEBEAT,
     c+         zoned(0, 8, 0)                   IFWELSDA,
     c+         zoned(0, 4, 0)                   IFWELIJJ,
     c+         char(' ', 6 )                    IFWELINR,
     c+         char(' ', 32 )                   IFWEFREI
     c+    from CONFIRMSUN , bbeu
     c+ where substr(C020, 1, 4) > '0000' and  C010 <> 0 and
     c+      (C090  > (select tstamp -00 days from ORDERSUNS2) or
     c+       C090  > (select tstamp -00 days from ORDERSUNS2) ) and
     c+       EUFIRM='01'                and
     c+       EUAFJJ= substr(C020, 1, 4) and
     c+       EUAFNR= substr(C020, 5, 6) and
     c+       EUAFpo= c030               and
     c+       c110 ='50'                 and
     c+       (substr(C020, 5, 6) in (select apafnr from afpo01  where
     c+        c030 = apafpo and apfirm ='01'      and apafat='58' and
     c+        substr(C020, 1, 4) = apafjj                        ))
     c/end-exec
     C*
     C*Übergabe der TXT                 rpmkak budeget       757646 30  757646 10
     c*bei Status 50 ==> delivery note
     c*/exec sql
     c*+ insert into txbe
     c*+ select  distinct
     c*+ char(' ', 1) TBlock,  char(:§§§job, 10) TPJNAM,
     c*+ zoned(('20')
     c*+ concat  substr(char(current date +0 day), 7, 2)  concat
     c*+ substr(char(current date +0 day), 4, 2)  concat
     c*+ substr(char(current date +0 day), 1, 2), 8, 0)   TPJDAT,
     c*+ zoned(substr(char(current time), 1, 2)  concat
     C*+ substr(char(current time), 4, 2)  concat
     C*+ substr(char(current time), 7, 2), 6, 0)   tpJZEI,
     C*+ char(:§§§usr, 10) tpUSER, char(:§§§pgm, 10) tpPROG,
     C*+ char(:§§§LIB, 10) TPBIBL,
     C*+ substr(char(digits(C010)), 6, 2) TPFIRM,
     C*+ char('AFDA', 10) TBTXAR, substr(C020, 1, 4) TBjhjj,
     C*+ substr(C020, 5, 6) TBafnr,
     C*+                              zoned(0, 4, 0) TBPOSI,
     C*+ zoned(0, 4, 0) TBupos,char('TXKO', 10) tbtcde,
     C*+ char('    ', 15) tba115,char('    ', 15) tba215,
     C*+ char('E', 1) tbspcd,         char('1', 10) tbucde,
     C*+ zoned(0, 3, 0) tblfzn,
     C*+ 'Lieferscheinnummer Belgien: ' concat
     C*+ substr(c060, 01, 20)  tbtext,
     C*+ zoned(0, 9, 2) TBwert,char('R', 1) tbdrk1,
     C*+ char(' ', 1) tbdrk2, char(' ', 1) tbdrk3,
     C*+ char(' ', 1) tbdrk4, char(' ', 1) tbdrk5,
     C*+ char(' ', 20) tbrfin, char(' ', 20) tbfrex
     c*+    from CONFIRMSUN
     c*+ where substr(C020, 1, 4) > '0000' and  C010 <> 0 and
     c*+       C090  > (select tstamp -00 days from ORDERSUNS2)  and
     c*+       substr(char(digits(C010)), 6, 2) ='01'            and
     c*+       c110 ='50'
     c*/end-exec
     C*
     C*Übergabe der TXT
     c*bei Status 50 ==> delivery note
     c/exec sql
     c+ insert into txbe
     c+ select  distinct
     c+ char(' ', 1) TBlock,  char(:§§§job, 10) TPJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   TPJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     C+ substr(char(current time), 4, 2)  concat
     C+ substr(char(current time), 7, 2), 6, 0)   tpJZEI,
     C+ char(:§§§usr, 10) tpUSER, char(:§§§pgm, 10) tpPROG,
     C+ char(:§§§LIB, 10) TPBIBL,
     C+ substr(char(digits(C010)), 6, 2) TPFIRM,
     C+ char('AFDA', 10) TBTXAR, substr(C020, 1, 4) TBjhjj,
     C+ substr(C020, 5, 6) TBafnr,
     C+      zoned(c030, 04, 0) TBPOSI,
     C**                             zoned(0, 4, 0) TBPOSI,
     C+ zoned(0, 4, 0) TBupos,char('TXPO', 10) tbtcde,
     C+ char('    ', 15) tba115,char('    ', 15) tba215,
     C+ char('D', 1) tbspcd,         char('1', 10) tbucde,
     C+ zoned(0, 3, 0) tblfzn,
     C+ 'Lieferscheinnummer Belgien: ' concat
     C+ substr(c060, 01, 20)  tbtext,
     C+ zoned(0, 9, 2) TBwert,char('R', 1) tbdrk1,
     C+ char(' ', 1) tbdrk2, char(' ', 1) tbdrk3,
     C+ char(' ', 1) tbdrk4, char(' ', 1) tbdrk5,
     C+ char(' ', 20) tbrfin, char(' ', 20) tbfrex
     c+    from CONFIRMSUN
     c+ where substr(C020, 1, 4) > '0000' and  C010 <> 0 and
     c+       (C090  > (select tstamp -00 days from ORDERSUNS2) or
     c+        C090  > (select tstamp -00 days from ORDERSUNS2) )
     c+       and substr(char(digits(C010)), 6, 2) ='01'
     c+       and c110 ='50'
     c/end-exec
     C*
     C*
     C*Übergabe der GELUWE_WES
     c/exec sql
     c+ insert into GELUWE_WES
     c+ SELECT IFWEFIRM, IFWEBEJJ, IFWEBENR, IFWEBEPO,
     c+ dec(sum(ifwemeng), 13, 2) xifwemeng
     c+ FROM ifwe01 WHERE IFWESTAT = '00'
     c+ and (IFWELFNR='92678 ' or IFWELFNR='      ')
     c+ and IFWEFIRM in
     c+ ( select EUFIRM from bbeu where ifwebejj = eubejj and ifwebenr =
     c+ eubenr and ifwebepo = eubepo ) GROUP BY IFWEFIRM, IFWEBEJJ,
     c+ IFWEBENR, IFWEBEPO
     c/end-exec
     c*
     c*
     C*Übergabe der GELUWE_WES  bzw. Bereinigung um Sätze
     C*die nicht vollständig erfüllt sind
     c/exec sql
     c+  delete from geluwe_wes where ifwefirm in
     c+  ( select EUFIRM from bbeu where ifwebejj = eubejj and ifwebenr =
     c+  eubenr and ifwebepo = eubepo and EUZOMG<>XIFWEMENG)
     c/end-exec
     c*
     c*
     C*Statusänderung
     c/exec sql
     c+   update ifwe01 a set a.IFWESTAT = '05' where
     c+   a.ifwefirm in (SELECT b.ifwefirm FROM geluwe_wes b WHERE
     c+   a.ifwefirm=b.ifwefirm and
     c+   a.ifwebejj=b.ifwebejj and
     c+   a.ifwebenr=b.ifwebenr ) and IFWESTAT <> '90'
     c/end-exec
     c*
     c*
     C*und sicherung Protokoll
     c/exec sql
     c+  insert into tvrelwaeco/GELUWE_WEP
     c+  SELECT IFWEFIRM, IFWEBEJJ, IFWEBENR, IFWEBEPO, XIFWEMENG,
     c+  current timestamp tstamp FROM geluwe_wes
     c/end-exec
     c*
     C*löschen altsätze
     c/exec sql
     c+  delete  from geluwe_wes
     c/end-exec
     c*
     C     ##7000        ENDSR

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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ update ORDERSUNS2 set tstamp =
     c+ ( SELECT max(C090) FROM confirmsun WHERE C110 ='50')
     c******+ ifwe WHERE IFWEFIRM ='01' and ifweprog='ORDERIN_R6')
     c******+ ifwe WHERE IFWEFIRM ='01' and ifweprog='ORDERIN_R6')
     c******+ (pdate ORDERSUNS2 set tstamp = (SELECT max(C090) FROM confirmsun)
     c******+ (SELECT current timestamp tstamp FROM qsys2/qsqptabl)
     c/end-exec

     C     ##7500        ENDSR

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
