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
      * 1.) W
      *     c
      *    M
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
     c                   exsr      sr1000
     c                   exsr      SR_pgm01
     c*                  exsr      sr2000
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
     c
     C*balance INVOICES for erp ERP Trend-System
     c/exec sql
     c+ insert into tvrelwaeco/RPM_LOAD
     c+ SELECT RKFIRM,RKRGJJ,RKRGNR,RKLIJJ,RKLINR,RKKDNR,dec(0, 10) #cc,
     c+ char('  ', 2) status,current date #date,current timestamp #tstamp,
     c+ dec(0, 10) #count,current timestamp updtstamp,
     c+ char(' ', 10) pgm,char(' ', 10) job,char(' ', 10) user,
     c+ char(' ', 128) protokoll
     c+ FROM afrk01 WHERE RKRGJJ > 2014 and rkreda > 20150000  and
     c+                                     rkreda < 20160000  and
     c+                      rkkdnr<>'xxxxxx'                  and
     c+ rkrgnr<>' ' and rkrgnr
     c+ not in (select rkrgnr from tvrelwaeco/RPM_LOAD a
     c+         where rkfirm=a.rkfirm and RKRGJJ=a.RKRGJJ and
     c+               RKLIJJ=a.RKLIJJ and RKLINR=a.RKLINR and
     c+               RKKDNR=a.RKKDNR)
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

     c                   eval      status='create index lib       /$PAVWU'+
     c                                    'MSKl                '
     c                   exsr      SR_log
     C*Index Siegen environment/selected customer
     c/exec sql
     c+    create index    lib       /$PAVWUMSKl
     c+           on       lib       /$PAVWUMSK
     c+    (AVKFA,avkfakj,AVKRENR,AVKAUFTL,avkaufn)
     c/end-exec


     C     ##2000        ENDSR

     C**************************************************************************
     C*server authority parameter fitting and back to original
     C*including all file operations
     C*
     C*-------------------------------------------------------------------------

     C     SR_pgm01      BEGSR
     c                   clear                   Wrk.var1
     c
     c                   eval      status='CALL PGM(EINVOICEUS/SVRAUTE   '+
     c                                    '                    '
     c                   exsr      SR_log
     C*ddm file for Amerika header
      /free
       MONITOR;
       Wrk.var1 =
           'CALL PGM(TVRELWAECO/E_____E)';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared                         ';
          exsr      SR_log;
       endmon;
      /End-Free

     C     ##_pgm01      ENDSR

     C**************************************************************************
     C*log report
     C*-------------------------------------------------------------------------
     C*
     C     sr_log        BEGSR

     C                   move      'ß$ß'         status
     C                   clear                   md
     C                   movea(p)  'RPM_LOADR '  md(001)
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
