     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*             Schnittstelle                                *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#PAKE40670up   e             disk    RENAME(#PAKE40670:PHY01R)
     fPAKE40670 if a e             disk    RENAME(PAKE40670R:PHY02R)
     f                                     USROPN
     faflp04    if   e           k disk
     fafko01    if   e           k disk
     fafpo01    if   e           k disk
     fifap02    if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     D*-------------------------------------------------------------------------
       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a


      // dummy512
      //------------------------------------------------------------------------
      // p_md            s            001a   inz
      //                                     dim(256)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz
     D p_inFIL         s             24a   inz


      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

     Dstatus2          s            132A   inz
     Dstring_file      s             60A   inz
     Dsuffix           s             06A   inz
     Dtransfer         s             30A   inz
     Derr_msg          s              1a   inz
     D§records         s              9s 0 inz

     I/COPY ##E
     I/COPY ##I001
     D
     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------

     c****               exsr      file_out
      * :status92 Sonderfall, Lieferscheindaten lagen noch nicht vor,
      * :         daher auf restart gesetzt, Übergabe war noch nicht soweit!
     c                   if        (status = '  ' or status='92')
     c                   eval      status = '  '

     C     *DTAARA       DEFINE                  $PAKE40670       10 0
     C  n25*lock         IN        $PAKE40670
     C  n25              eval      $PAKE40670 = $PAKE40670 + 1
     C  n25              out       $PAKE40670
     c                   seton                                        25
     C                   setoff                                       47
     c                   exsr      sr1000
     C                   if        *in91='0' and
     C                             *in92='0' and
     C                             *in93='0' and
     C                             *in94='0'
     C**********                   *in95='0'
     c                   exsr      sr2000
     C                   endif
     c                   eval      status = '10'
     c   95              eval      status = '95'
     c   94              eval      status = '94'
     c   93              eval      status = '93'
     c   92              eval      status = '92'
     c   91              eval      status = '91'
     c                   eval      #cc = $PAKE40670
     c                   update    phy01r

     c                   endif

     clr                 close     PAKE40670
     clr                 exsr      file_out

     clr                 eval      status2='Ende  SC40670_RR Daten ermitteln'
     clr                 exsr      SR_log
     C*lr                 out       unique_ff

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)  über aflp04  PKANR1  K012018288118
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_aflp    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c                   kfld                    ALKMPO
      /Free
         monitor;
         *in91 ='0';
         if %dec(%subst(PKANR1:03:04):4:0) <> *zero;
         endif;
         on-error *all;
         // nicht numerisch
                  *in91 ='1';
         endmon;
      /End-Free
     c                   if        *in91 = '0'
     C                   eval      ALFIRM  = '01'
     C                   eval      ALKMJJ  = %dec(%subst(PKANR1:04:04):4:0)
     C                   eval      ALKMNR  = %subst(PKANR1:08:06)
     C                   move      PKANRP        ALKMPO
      * :Lieferscheinpositionen -1-
     c     keysr_aflp    chain     AFLP04                             92
     c   92              clear                   AFLP1
     C*
      * :Kopfdaten Auftrag      -2-
     c     keysr_afko    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR

     c                   if        *in92 = '0'
     c     keysr_afko    chain     afko01                             93
     c   92              clear                   afko1
     c   93              clear                   afko1
     c
     C*
      * :lesen bezug Afpo       -3-
     c     keysr_afpo    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_afpo    chain     afpo01                             94
     c   92              clear                   afpo1
     c   93              clear                   afpo1
     c   94              clear                   afpo1
     C*
      * :lesen bezug Interface ifap -4-
     c     keysr_ifap    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_ifap    chain     ifap02                             95
     c   92              clear                   ifap1
     c   93              clear                   ifap1
     c   94              clear                   ifap1
     c   95              clear                   ifap1
     c   95              clear                   IFAPIFPO
     C*
     C                   endif
     C                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     C*
      * :in jedem Fall lt. Trend
     C                   eval      ARRIVALID = %char(PKAPN)
     c                   eval      CUSTOMER  = PKKDNR
     c  n95              eval      LINENUM   = IFAPIFPO
     c   95              eval      LINENUM   = ALAFPO
     c                   eval      PURCHID   = AKMAAF
     c                   eval      ITEMID    = PKIDEN
     c                   eval      QTY       = PKPMEN
     c
     c                   write     phy02r
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     c                   eval      status2='Start SC40670_RR Daten ermitteln'
     c                   exsr      SR_log
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C*    *DTAARA       DEFINE                  unique_ff        10 0
     C*    *lock         IN        unique_ff
     C
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     C
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

       //DOMDATV7  TSTDATV7   PKVENR
     c/exec sql
     c+ insert into tvrelwaeco/#PAKE40670
     c+ SELECT pkAPN, PKANR1, PKANRP, PKANRU, PKKDNR,
     c+        PKIDEN, PKEAN,
     c+        dec(sum(PKPMEN), 13, 3) PKPMEN,
     c+        dec(sum(PKSMEN), 13, 3) PKSMEN,
     c+        dec(sum(PKEGEW), 13, 3) PKEGEW,
     c+        PKPKNR , PKVENR, dec(0, 10)
     c+        #cc, char('  ', 2) status, current date
     c+        #date, current timestamp #tstamp
     c+        FROM DOMDATV7/ppaket
     c+ where  PKKDNR = '040670' and  PKANRP <> '0' and
     c+        pkAPN  not in (select pkAPN from
     c+                       tvrelwaeco/#PAKE40670)
     c+ group  by pkAPN, PKANR1, PKANRP, PKANRU, PKKDNR,
     c+           PKIDEN, PKEAN, PKPKNR, PKVENR
     c+ order  by PKVENR
     c/end-exec

      /FREE

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
             'CPYF FROMFILE(TVRELWAECO/PAKE40670) '       +
             'TOFILE(TVRELWAECO/PAKE40670S) MBROPT(*ADD)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status2='Error by CPYF FROMFILE PAKE40670';
               exsr      SR_log;
         endmon;

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/PAKE40670)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status2='Error by CLRPFM object PAKE40670';
               exsr      SR_log;
         endmon;

     c                   open      PAKE40670

     C                   ENDSR

       //-----------------------------------------------------------------------
       //output
       //CRTPF FILE(TVRELWAECO/PAKE40670E) RCDLEN(256) TEXT('output PAKE40670')
       //APPEND /QSYS.LIB/TVRELWAECO.LIB/CONFIRMOUT.FILE/CONFIRMOUT.MBR CONFIRM.TXT
       //
       //-----------------------------------------------------------------------

       begsr file_out;

         §records=*zero;
         exec sql
           select count(*) into :§records
                  from  TVRELWAECO/PAKE40670;

         if §records <> *zero;

            eval  transfer =  'PAKE40670E'                          +
                              '-'                                   +
                              %char(%dec(%char(%date():*iso0):8:0)) +
                              '.csv';

            clear     Wrk.var1;
            clear     status;

       //  OVRDBF FILE INPUT
            MONITOR;
            Wrk.var1 =
                   'OVRDBF FILE(INPUT) TOFILE(TVRELWAECO/FTP) ' +
                   'MBR(SC40670CMD)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE INPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

            clear     Wrk.var1;
            clear     status;

       //  OVRDBF FILE OUTPUT
            MONITOR;
            Wrk.var1 =
                'OVRDBF FILE(OUTPUT) TOFILE(TVRELWAECO/FTP) ' +
                'MBR(SC40670LOG)';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error OVRDBF FILE OUTPUT TOFILE(TVRELWAECO/FTP)';
                  exsr      SR_log;
            endmon;

       //  Info in Outfile timestamp SELECT current timestamp,current date
            clear p_md;
            eval p_msg     =  '#DC0010';
            eval p_msgf    =  *blank;
            eval p_print   =  *blank;
            eval p_outfil  =  'OUTPUT    ';
            eval p_lib     =  'TVRELWAECO';
            eval p_repadd  =  '*ADD';

            callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                           p_outfil: p_lib:    p_repadd);

            eval p_outfil  =  'PAKE40670';
       //  >> 1) PAKE40670  nach  PAKE40670E
            MONITOR;
            Wrk.var1 =
                 'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
                 'TOFILE(TVRELWAECO/PAKE40670E) '+
                 'MBROPT(*REPLACE) STRDLM(''"'') '+
                 'RMVBLANK(*BOTH) FLDDLM('';'') DECPNT(*COMMA) ';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  status='error CPYTOIMPF FROMFILE '  +
                       p_outfil;
               //Aufbereitung für Export  Abbruch
                  exsr      SR_log;
            endmon;


            eval p_outfil  =  'PAKE40670E'    +
                               suffix;
            clear  string_file;
            eval   string_file = 'APPEND '    +
                                 'PAKE40670E' +
                                 '.file '     +
                                 transfer;

            exec sql
              update input set SRCDTA = :string_file
              where  substr(srcdta, 1, 07) = 'APPEND ';

            clear     Wrk.var1;
            clear     status;
            err_msg = ' ';

       //  FTP-Befehl    193.84.54.10
       //  FTP-Befehl    'FTP RMTSYS(''DOMETIC-GROUP.COM'')';
            MONITOR;
               Wrk.var1 =
                   'FTP RMTSYS(''ftp.dometic-group.com'')';
               cmd = %TrimR(Wrk.Var1);
               L      = %Len(Cmd);
               QCMDEXC(cmd: %len(cmd));
               on-error;
                  err_msg = '1';
            endmon;

            if err_msg = '1';
               status='error ftp.dometic-group.com'    +
                                                  'RPMC'         +
                                                  %trimr(suffix) + ' ' +
                                                  transfer;
               exsr      SR_log;
            else;
               status='transfer successful '    +
                                                  'RPMC'         +
                                                  %trimr(suffix) + ' ' +
                                                  transfer;
               exsr      SR_log;
            endif;
         endif;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

     C     sr_log        BEGSR

      /FREE
         clear p_md;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status2;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status2;

      /End-FREE

     c                   clear                   status2
     C
     C     #sr_log       ENDSR

