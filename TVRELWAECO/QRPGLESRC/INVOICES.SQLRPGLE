     ******************************************************************
      * Program name.:INVOICES                                                
      * ==>          :..........
      *
      * 22. Mai 2014   GANG, MANFRED (developer)
      *
      *
      * Dometic International Corporation
      *
      * This program will get all assigned customers based on the
      * spreadsheet from GXS definition and takes care for the
      * next process by creating a working file.
      *
      * If one function is outside of job the whole process is still working
      * for all other steps.
      *
      * One environment contains normally more than one company!!!
      *
      * Also necessary environments will be established in case of not
      * existing or changes inside the run. Maybe we have to delete
      * befor running up. (?)
      *
      * This program will run first because it takes all new invoices
      * which we need to take in the flow and let run invoicing
      * process for GXS.
      * There are two possibilities to take invoices in GXS flow.
      * 1.) We got a new customer notified by GXS and GXS put the
      *     customer in the spread sheet.
      *     The run takes automatically.
      *    Maybe we need here an add on to the query to ask for
      *    for invoices up to current date, otherwise we pick up
      *    history. However it's an easy change.
      * 2.) New invoices during the normal process (daily or however)
      *     are inside. The run takes automatically.
      * In both cases the run will take this set-up and preparing for
      * the next step by working file INVOICES depending on the
      * assigned library.
      * This program can run independent, the call will put a sentence
      * in our main log_file.
      *
      *
      * steps: 1.) creating all current and necessary ddm-files,
      *           copy-functions to get sql-support
      *        2.) update workfile library/invoices
      *        3.) creating necessary keys
      *
      * exeptions:
      * In America we use log reports and not the basic ERP-files.
      * einvoiceus/INVOICEhe$ and einvoiceus/INVOICEpo$.
      *
      * to do:
      *      ................
      * ***************************************************************        
      * activity log:...                                                      
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
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C*-------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

     C*-------------------------------------------------------------------------

     C**************************************************************************
     C*Interface_daten
     C*-------------------------------------------------------------------------

     C*working files
     c                   movel     '==> starting'status           50
     c                   exsr      SR_log
     c                   exsr      SR_server
     c                   exsr      SR_cmd
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   clear                   status
     c                   movel     '==> ending  'status           50
     c                   exsr      SR_log

     C                   EXSR      RETURN

     C**************************************************************************
     C*balance
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

     c                   eval      status='insert into einvoice/invoices '+
     c                                    '                    '
     c                   exsr      SR_log
     C*balance INVOICES Emsdetten ERP Trend-System
     c/exec sql
     c+ insert into einvoice/invoices
     c+ SELECT RKFIRM,RKRGJJ,RKRGNR,RKLIJJ,RKLINR,RKKDNR,dec(0, 10) #cc,
     c+ char('  ', 2) status,current date #date,current timestamp #tstamp,
     c+ dec(0, 10) #count,current timestamp updtstamp,
     c+ char(' ', 10) pgm,char(' ', 10) job,char(' ', 10) user,
     c+ char(' ', 128) protokoll
     c+ FROM afrk01 b WHERE RKRGJJ > 2013 and rkreda > 20150000  and
     c+                   RKKDNR in
     c+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  WAECONR    is not null               and
     c+         substr(COMPA00001, 1, 2) = RKFIRM    and
     c+         COMPA00001 is not null  )            and
     c+ b.rkrgnr<>' ' and b.rkrgnr
     c+ not in (select a.rkrgnr from einvoice/invoices a
     c+         where b.rkfirm=a.rkfirm and b.RKRGJJ=a.RKRGJJ and
     c+               b.RKLIJJ=a.RKLIJJ and b.RKLINR=a.RKLINR and
     c+               b.RKKDNR=a.RKKDNR)
     c+ order by RKFIRM,RKRGJJ,RKRGNR,RKLIJJ,RKLINR,RKKDNR
     c/end-exec


     c                   eval      status='insert into einvoicesi/invoise'+
     c                                    's                   '
     c                   exsr      SR_log
     C*balance INVOICES Siegen ERP VS-System
     c/exec sql
     c+ insert into einvoicesi/invoices
     c+ SELECT AVKFA,avkfakj,dec(AVKRENR*1000+AVKAUFTL, 12, 0) renrauftl,
     c+ avkfakj,avkaufn,AVKKDNR, dec(0, 10) #cc, char('  ', 2)
     c+ status,current date #date,current timestamp #tstamp, dec(0, 10)
     c+ #count,current timestamp updtstamp, char(' ', 10) pgm,char(' ', 10)
     c+ job,char(' ', 10) user, char(' ', 128) protokoll FROM
     c+ einvoicesi/$PAVWUMSK WHERE avkfakj > 2013 and avkkdnr in
     c+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  WAECONR    is not null and substr(COMPA00001, 1, 2)
     c***       in('03','04','05','07','08','11','03') and
     c+         in('03')                               and
     c+         COMPA00001 is not null  )  and
     c+ AVKRENR > 0 and AVKFA = 1   and AVKRENR*1000+AVKAUFTL
     c+ not in (select RENRAUFTL from einvoicesi/invoices a
     c+         where  AVKFA =a.AVKFA  and avkfakj=a.avkfakj and
     c+                avkfakj=a.avkfakj01 and AVKAUFN=a.AVKAUFN and
     c+                AVKKDNR=a.AVKKDNR) and
     c+ substr(digits(AVKFAKJ), 1, 4) = year(current date) and
     c*+ substr(digits(AVKFAKM), 1, 2) > month(current date -2 month)
     c+ substr(digits(AVKFAKM), 1, 2) > month(current date -1 month)
     c+ order by AVKFA,avkfakj,dec(AVKRENR*1000+AVKAUFTL, 12, 0)
     c/end-exec

     c**+ ab 11.11.2014 geändert
     c**+ substr(digits(AVKDAT), 5, 4) = year(current date) and
     c**+ substr(digits(AVKDAT), 3, 2) > month(current date -2 month)

     c                   eval      status='insert into einvoicedi/invoise'+
     c                                    's                   '
     c                   exsr      SR_log
     C*balance INVOICES Siegen ERP VS-System    DI
     c/exec sql
     c+ insert into einvoicedi/invoices
     c+ SELECT    AVKFA,avkfakj,dec(AVKRENR*1000+AVKAUFTL, 12, 0) renrauftl,
     c+ avkfakj,avkaufn,AVKKDNR, dec(0, 10) #cc, char('  ', 2)
     c+ status,current date #date,current timestamp #tstamp, dec(0, 10)
     c+ #count,current timestamp updtstamp, char(' ', 10) pgm,char(' ', 10)
     c+ job,char(' ', 10) user, char(' ', 128) protokoll FROM
     c+ einvoicedi/$PAVWUMSK WHERE avkfakj > 2013 and avkkdnr in
     c+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  WAECONR    is not null and substr(COMPA00001, 1, 2)
     c+         in('15','15','15','15','15','15','15') and
     c+         COMPA00001 is not null  )  and
     c+ AVKRENR > 0 and AVKFA = 15  and AVKRENR*1000+AVKAUFTL
     c+ not in (select RENRAUFTL from einvoicedi/invoices a
     c+         where  AVKFA =a.AVKFA  and avkfakj=a.avkfakj and
     c+                avkfakj=a.avkfakj01 and AVKAUFN=a.AVKAUFN and
     c+                AVKKDNR=a.AVKKDNR) and
     c+ substr(digits(AVKFAKJ), 1, 4) = year(current date) and
     c+ substr(digits(AVKFAKM), 1, 2) > month(current date -2 month)
     c+ order by AVKFA,avkfakj,dec(AVKRENR*1000+AVKAUFTL, 12, 0)
     c/end-exec

     c**+ ab 11.11.2014 geändert
     c**+ substr(digits(AVKDAT), 5, 4) = year(current date) and
     c**+ substr(digits(AVKDAT), 3, 2) > month(current date -2 month)


     c                   eval      status='insert into einvoiceus/invoise'+
     c                                    's                   '
     c                   exsr      SR_log
     C*balance INVOICES Amerika Standard
     c/exec sql
     c+ insert into einvoiceus/invoices
     c+ SELECT distinct char('99', 2) RKFIRM,ID ID,CUSTOMID   RKKDNR,
     c+ dec(0, 10) #cc, char('  ', 2) status,current date #date,
     c+ TSTAMPI #tstamp,dec(0, 10) #count,
     c+ current timestamp updtstamp, char(' ', 10) pgm,
     c+ char(' ', 10) job,char(' ', 10) user,char(' ', 128) protokoll
     c+ from einvoiceus/INVOICEhe$
     c+ where   CUSTOMID        in
     c+ (select substr("LogicalID", 1, 8) from einvoice/idnumbers
     c*+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  "LogicalID"  is not null               and
     c+         substr(COMPA00001, 1, 2) = '99'      and
     c+         COMPA00001 is not null  )            and
     c+  id not in (select id     from einvoiceus/invoices a   )
     c+  order by ID,CUSTOMID
     c/end-exec

     c                   eval      status='delete from einvoiceus/INVOICE'+
     c                                    'he$                 '
     c                   exsr      SR_log


     c                   clear                   p_delete          1
     c                   if        p_delete  ='1'
     C*delete from input all transferred sentences from Amerika who are
     C*done by the process (not touched sentences by the process will
     C*be saved in the file until deleted or processed by job)
     C*Soon the spread sheet get an valid entry of a customer all
     C*assigned sentences will be in flow including history.
     c/exec sql
     c+ delete from  einvoiceus/INVOICEhe$
     c+ where CUSTOMID  in
     c+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  "LogicalID"  is not null               and
     c+         substr(COMPA00001, 1, 2) = '99'      and
     c+         COMPA00001 is not null  )            and
     c+  id     in (select id from einvoiceus/invoices a
     c+             where STATUS = '10'     )
     c/end-exec

     c/exec sql
     c+ delete   FROM einvoiceus/INVOICEpo$
     c+ WHERE INVOICEPO$.INVOICEID not in
     c+ (select id from  einvoiceus/iNVOICEhe$
     c+ where INVOICEPO$.TSTAMPI=INVOICEHE$.TSTAMPI )
     c/end-exec

     c                   eval      status='insert into einvoicesm/invoise'+
     c                                    's                   '
     c                   exsr      SR_log
     c                   endif
     c
     C*balance INVOICES SMEV
     c/exec sql
     c+ insert into einvoicesm/invoices
     c+ SELECT distinct char('98', 2) RKFIRM,S§DAFA,S§NUFA,S§COCF,
     c+ dec(0, 10) #cc, char('  ', 2) status,current date #date,
     c+ current timestamp #tstamp, dec(0, 10) #count,
     c+ current timestamp updtstamp, char(' ', 10) pgm,char(' ', 10)
     c+ job,char(' ', 10) user, char(' ', 128) protokoll
     c+ FROM  einvoicesm/$STOMO$6L where S§DAFA > 20140107 and S§COCF in
     c+ (select substr(WAECONR, 1, 8) from einvoice/idnumbers
     c+  where  WAECONR    is not null               and
     c+         substr(COMPA00001, 1, 2) = '98'      and
     c+         COMPA00001 is not null  )  and   S§NUFA not in
     c+ (select S§NUFA    from einvoicesm/invoices a
     c+  where S§NUFA=a.S§NUFA and S§DAFA =a.S§DAFA  and
     c+          RKFIRM =a.RKFIRM)
     c/end-exec


     C     ##1000        ENDSR

     C**************************************************************************
     C*necessary keys
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

     c                   eval      status='create index EINVOICESI/$PAVWU'+
     c                                    'MSKl                '
     c                   exsr      SR_log
     C*Index Siegen environment/selected customer
     c/exec sql
     c+    create index    EINVOICESI/$PAVWUMSKl
     c+           on       EINVOICESI/$PAVWUMSK
     c+    (AVKFA,avkfakj,AVKRENR,AVKAUFTL,avkaufn)
     c/end-exec

     c                   eval      status='create index EINVOICESI/$PAVWU'+
     c                                    'MSPl                '
     c                   exsr      SR_log
     C*Index Siegen environment/selected customer
     c/exec sql
     c+    create index    EINVOICESI/$PAVWUMSPl
     c+           on       EINVOICESI/$PAVWUMSP
     c+    (AVpFA,avpfakj,AVpRENR,AVpAUFTL,avpaufn)
     c/end-exec


     c                   eval      status='create index EINVOICEDI/$PAVWU'+
     c                                    'MSKl                '
     c                   exsr      SR_log
     C*Index Siegen environment/selected customer
     c/exec sql
     c+    create index    EINVOICEDI/$PAVWUMSKl
     c+           on       EINVOICEDI/$PAVWUMSK
     c+    (AVKFA,avkfakj,AVKRENR,AVKAUFTL,avkaufn)
     c/end-exec

     c                   eval      status='create index EINVOICEDI/$PAVWU'+
     c                                    'MSPl                '
     c                   exsr      SR_log
     C*Index Siegen environment/selected customer
     c/exec sql
     c+    create index    EINVOICEDI/$PAVWUMSPl
     c+           on       EINVOICEDI/$PAVWUMSP
     c+    (AVpFA,avpfakj,AVpRENR,AVpAUFTL,avpaufn)
     c/end-exec

     c                   eval      status='create index EINVOICEUS/INVOIC'+
     c                                    'EHl1                '
     c                   exsr      SR_log
     C*Index USA environment/selected customer
     c/exec sql
     c+    create index    einvoiceus/INVOICEHl1
     c+           on       einvoiceus/INVOICEHE$
     c+    (ID)
     c/end-exec

     c                   eval      status='create index EINVOICEUS/INVOIC'+
     c                                    'EPl1                '
     c                   exsr      SR_log
     C*Index USA environment/selected customer
     c/exec sql
     c+    create index    einvoiceus/INVOICEPl1
     c+           on       einvoiceus/INVOICEPO$
     c+    (INVOICEID,INVOICELIN)
     c/end-exec

     c                   eval      status='create index EINVOICEsm/$STOMO'+
     c                                    '$6L                 '
     c                   exsr      SR_log
     C*Index SMEV environment/selected customer                       ngine
     c/exec sql
     c+    create index    einvoicesm/$STOMO$6L
     c+           on       einvoicesm/$STOMO$6L
     c+    (S§DAFA, S§NUFA)
     c/end-exec

     C     ##2000        ENDSR

     C**************************************************************************
     C*server authority parameter fitting and back to original
     C*including all file operations
     C*
     C*-------------------------------------------------------------------------

     C     SR_server     BEGSR
     c                   clear                   Wrk.var1
     c
     c                   eval      status='CALL PGM(EINVOICEUS/SVRAUTE   '+
     c                                    '                    '
     c                   exsr      SR_log
     C*ddm file for Amerika header
      /free
       MONITOR;
       Wrk.var1 =
           'CALL PGM(EINVOICEUS/SVRAUTE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     C     ##_server     ENDSR

     C**************************************************************************
     C*command   LIB
     C*
     C*-------------------------------------------------------------------------

     C     SR_cmd        BEGSR
     c                   clear                   Wrk.var1
     c
     C*ddm file for Amerika header in EINVOICEUS/SVRAUTE
     C*ddm file for Amerika lines  in EINVOICEUS/SVRAUTE
     C*
     C*copy-function to support sql in EINVOICEUS/SVRAUTE
     C*copy-function to support sql in EINVOICEUS/SVRAUTE
     c
     C*____________________________________________________________________
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESM/STOMO$'+
     c                                    '6L)                 '
     c                   exsr      SR_log
     C*ddm file for SMEV Italy
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESM/STOMO$6L) ' +
           'RMTFILE(SMEVMODEUR/STOMO$6L) '  +
           'RMTLOCNAME(''10.35.12.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESM/ANACF0'+
     c                                    '0F)                 '
     c                   exsr      SR_log
     C*ddm file für SMEV Italy
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESM/ANACF00F) ' +
           'RMTFILE(SMEV_DAT/ANACF00F) '  +
           'RMTLOCNAME(''10.35.12.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICESM/ANACF'+
     c                                    '00F)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICESM/ANACF00F) '                        +
           'TOFILE(EINVOICESM/$ANACF00F) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICESM/STOMO'+
     c                                    '$6L)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICESM/STOMO$6L) '                        +
           'TOFILE(EINVOICESM/$STOMO$6L) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free


     C*____________________________________________________________________
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PAVWUM'+
     c                                    'SK)                 '
     c                   exsr      SR_log
     C*ddm file für EL-Systems SI
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PAVWUMSK) ' +
           'RMTFILE(PRODDES01/PAVWUMSK) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PAVWUM'+
     c                                    'SP)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PAVWUMSP) ' +
           'RMTFILE(PRODDES01/PAVWUMSP) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PAVWAT'+
     c                                    'EX)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PAVWATEX) ' +
           'RMTFILE(PRODDES01/PAVWATEX) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PKDNAR'+
     c                                    'TN)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PKDNARTN) ' +
           'RMTFILE(PRODDES01/PKDNARTN) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PARTST'+
     c                                    'A)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PARTSTA) ' +
           'RMTFILE(PRODDES01/PARTSTA) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PKUNAD'+
     c                                    'R)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PKUNADR) ' +
           'RMTFILE(PRODDES01/PKUNADR) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PKUNST'+
     c                                    'A)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PKUNSTA) ' +
           'RMTFILE(PRODDES01/PKUNSTA) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PAVWAT'+
     c                                    'EX)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PAVWATEX) ' +
           'RMTFILE(PRODDES01/PAVWATEX) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICESI/PAVWU'+
     c                                    'MSK)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICESI/PAVWUMSK) '                        +
           'TOFILE(EINVOICESI/$PAVWUMSK) '                              +
           'MBROPT(*REPLACE) '                                          +
           'INCREL((*IF AVKFAKJ *GT 2013))';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free


     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICESI/PAVWU'+
     c                                    'MSP)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICESI/PAVWUMSP) '                        +
           'TOFILE(EINVOICESI/$PAVWUMSP) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICESI/PAVWUM'+
     c                                    'ST)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICESI/PAVWUMST) ' +
           'RMTFILE(PRODDES01/PAVWUMST) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICESI/PAVWU'+
     c                                    'MST)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICESI/PAVWUMST) '                        +
           'TOFILE(EINVOICESI/$PAVWUMST) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     C*____________________________________________________________________
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PAVWUM'+
     c                                    'SK)                 '
     c                   exsr      SR_log
     C*ddm file für EL-Systems DI  PRODDDL15
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PAVWUMSK) ' +
           'RMTFILE(PRODDDL15/PAVWUMSK) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PAVWUM'+
     c                                    'SP)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PAVWUMSP) ' +
           'RMTFILE(PRODDDL15/PAVWUMSP) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PAVWAT'+
     c                                    'EX)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PAVWATEX) ' +
           'RMTFILE(PRODDDL15/PAVWATEX) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PKDNAR'+
     c                                    'TN)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PKDNARTN) ' +
           'RMTFILE(PRODDDL15/PKDNARTN) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PARTST'+
     c                                    'A)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PARTSTA) ' +
           'RMTFILE(PRODDDL15/PARTSTA) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PKUNAD'+
     c                                    'R)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PKUNADR) ' +
           'RMTFILE(PRODDDL15/PKUNADR) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PKUNST'+
     c                                    'A)                  '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PKUNSTA) ' +
           'RMTFILE(PRODDDL15/PKUNSTA) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PAVWAT'+
     c                                    'EX)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PAVWATEX) ' +
           'RMTFILE(PRODDDL15/PAVWATEX) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICEDI/PAVWU'+
     c                                    'MSK)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICEDI/PAVWUMSK) '                        +
           'TOFILE(EINVOICEDI/$PAVWUMSK) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free


     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICEDI/PAVWU'+
     c                                    'MSP)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICEDI/PAVWUMSP) '                        +
           'TOFILE(EINVOICEDI/$PAVWUMSP) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     C
     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CRTDDMF FILE(EINVOICEDI/PAVWUM'+
     c                                    'ST)                 '
     c                   exsr      SR_log
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDDMF FILE(EINVOICEDI/PAVWUMST) ' +
           'RMTFILE(PRODDDL15/PAVWUMST) '  +
           'RMTLOCNAME(''10.20.201.2'' *IP)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free
     C

     c                   clear                   Wrk.var1
     C*
     c                   eval      status='CPYF FROMFILE(EINVOICEDI/PAVWU'+
     c                                    'MST)                '
     c                   exsr      SR_log
     C*copy-function to support sql
      /free
       MONITOR;
       Wrk.var1 =
           'CPYF FROMFILE(EINVOICEDI/PAVWUMST) '                        +
           'TOFILE(EINVOICEDI/$PAVWUMST) '                              +
           'MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free



     C     ##_cmd        ENDSR

     C**************************************************************************
     C*log report
     C*-------------------------------------------------------------------------
     C*
     C     sr_log        BEGSR

     C                   move      'ß$ß'         status
     C                   clear                   md
     C                   movea(p)  'INVOICES  '  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  status        md(033)
     C*                  MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md

     C     ##_log        ENDSR
     C**************************************************************************
     C*time stam
     C*-------------------------------------------------------------------------

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

     C**************************************************************************
     C*.
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
