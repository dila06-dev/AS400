     h  option(*SRCSTMT:*NoDebugIO)
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
      * SELECT ARTNR, ARTBEZ, ARTGRP, STATNR, ABC, LIEFERANT1, LIEFERANT2
      * ,artsku,artbezfra,e1 ,e2,e3, char(' ', 10) extern, ARTZ3 status,
      * char(' ', 50) supplier1, char(' ', 50) supplier2               FROM
      * bar_kalk/kalk_file WHERE version='$$EL_PS_DB'
      * Datei ANTONV in TVRELWAECO wurde erstellt.
      *
      * update antonV   set
      * extern='intern' where
      * ( (lieferant1 in (select LFLFNR from lief01
      *    WHERE LFFIRM='01' and lflfat<>'000' and LIEFERANT1 <>' '))  or
      *   (lieferant2 in (select LFLFNR from lief01
      *    WHERE LFFIRM='01' and lflfat<>'000' and LIEFERANT2 <>' '
      *    and LIEFERANT1 =' '                                     ))  or
      *   (LIEFERANT1 =' ' and LIEFERANT2 =' '  )                   )
      * 34787 Zeilen in ANTONV in TVRELWAECO aktualisiert.
      * update antonv set supplier1=
      *  (select LFNAM1 from lief01 where lieferant1=LFLFNR
      *                                   and lffirm='01')
      *   where exists
      *   (select LFNAM1 from lief01 where lieferant1=LFLFNR
      *                                    and lffirm='01')
      *  update antonv set supplier2=
      *   (select LFNAM1 from lief01 where lieferant2=LFLFNR
      *                                    and lffirm='01')
      *    where exists
      *    (select LFNAM1 from lief01 where lieferant2=LFLFNR
      *                                     and lffirm='01')
      *
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      *
      * Achtung ÄNDERUNG 11.11.2013
      *
      *
      *********************************************************************************

     fRPM_CONTR uf   e             disk
     f                                     RENAME(RPM_CONTR:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN

     fwaof01    uf   e           k disk

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
     D Wrk             DS                  Qualified inz
     D Var1                         200A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C*    *ENTRY        PLIST
     C*                  PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     c
     c     waofkey       klist
     c                   kfld                    WAOFFIRM
     c                   kfld                    WAOFKAJJ
     c                   kfld                    WAOFKANR
     c                   kfld                    SKU
     c
     c                   exsr      sr2000
     c                   exsr      sr3000
     C                   open      RPM_CONTR
     C                   DO        *HIVAL
     C
     C                   READ      RPM_CONTR                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c     waofkey       chain     waof1
     c                   IF        %found(waof01)
     c                   eval      CALCDATE  = %char(WAOFJDAT)
     c                   update    phy01r
     c                   else
     c                   endif
     c                   endif
     C
     C                   enddo
     C                   close     RPM_CONTR
b
     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/RPM_CONTR';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
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
     c+ insert into RPM_CONTR
     c+ SELECT char('DE411 ', 8) entity,WAOFVEUR sku,decimal(ST3_KALK*1,
     c+ 13, 2) actualcost, char('EUR', 5) currency, char ('1', 6 )
     c+ priceunit, char('00000000', 8) calcdate,
     c+            char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload,WAOFFIRM,WAOFBERE,WAOFKAJJ,WAOFKANR
     c+                              FROM tvrelwaeco/RPMKALKUL
     c+ where  statnr<'799' and WAOFVEUR<>'8887100008' and
     c+                         artstatus<>'90' and
     c+ ( (lieferant1 in (select LFLFNR from lief01
     c+    WHERE LFFIRM='01' and lflfat<>'000' and LIEFERANT1 <>' '))  or
     c+   (lieferant2 in (select LFLFNR from lief01
     c+    WHERE LFFIRM='01' and lflfat<>'000' and LIEFERANT2 <>' '
     c+    and LIEFERANT1 =' '                                     ))  or
     c+   (LIEFERANT1 =' ' and LIEFERANT2 =' '  )                   )
     c+ and WAOFKAJJ =year(current date)
     c/end-exec

     C     ##3000        ENDSR

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
