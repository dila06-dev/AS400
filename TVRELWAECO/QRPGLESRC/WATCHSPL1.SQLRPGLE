
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      // WRKSPLF SELECT(*ALL *ALL *ALL *ALL *ALL QPJOBLOG) JOB(*ALL)
      //      Beschreibung
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(00,000)
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(18,000)   03.09.2019
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(23,000)   08.07.2019
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(22,000)   06.08.2019
      //      dspdtaara diskspace
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(20,000)   20.02.2020
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(18,000)   19.05.2023
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(16,000)   29.07.2025
      //      CHGDTAARA DTAARA(DISKSPACE *ALL) VALUE(15,000)   09.11.2025
      // SELECT * FROM WATCHSPACE
      // WHERE substr(WATCHSPACE, 32, 1) = ',' and
      //       substr(WATCHSPACE, 31, 4) > '0,50'
      // ORDER BY substr(WATCHSPACE, 01, 25),
      //          substr(WATCHSPACE, 62, 02),
      //          substr(WATCHSPACE, 59, 02),
      //          substr(WATCHSPACE, 56, 02)
      //
      // SELECT * FROM WATCHSPACE
      // WHERE substr(WATCHSPACE, 51, 1) = ',' and
      //       substr(WATCHSPACE, 70, 1) = ',' and
      //       substr(WATCHSPACE, 73, 10)= ' '
      // ORDER BY substr(WATCHSPACE, 01, 35), rrn(watchspace)
      // RTVDIRINF DIR('/Lager')
      // Datenbankdateien QAEZD0006O und QAEZD0006D wurden in der Bibliothek QUSRSYS erstellt.
      // EDTF STMF('/trend/echt/edi/in/dsx/')
      // CHGJOB     CCSID(1144)
      //            QAEZD0002O
      //            QAEZD0002D
      // CALL PGM(DUMMY512) PARM(' ' '#AL0005' ' ' 'PRT55' ' ' ' ' ' ')
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************

      //------------------------------------------------------------------------
      //    S T E U E R - B E S T I M M U N G E N
      //------------------------------------------------------------------------
     h datfmt(*EUR)
     h datedit(*DMY.)
     h timfmt(*HMS:)
     h decedit('0,')
     h langid('DE')
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // ...
     fwatchspls uf   e           k disk    RENAME(watchspls:PHY01R)
     f                                     prefix('$')
     f                                     USROPN
     fWATCHSPACEuf   e           k disk    RENAME(WATCHSPACE:PHY02R)
     f                                     prefix('$')
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur



      // System-Datenstruktur
     d DSPGM          SDS
     d  §§§PGM                 1     10
     d  §§§STS                11     15
     d  §§§SEQ                21     28
     d  §§§SR                 29     36
     d  §§§MSG                40     46
     d  §§§LIB                81     90
     d  §§§MTX                91    170
     d  §§§FIL               201    208
     d  §§§FST               209    243
     d  §§§JOB               244    253
     d  §§§USR               254    263
     d  §§§JNO               264    269  0
     d  §§§SDT               276    281  0
     d  §§§STM               282    287  0


     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

     d watchspls_k   E DS                  ExtName(watchspls:*key)
     d                                     Qualified
     d watchspls_i   E DS                  ExtName(watchspls:*input)
     d                                     Qualified
     d watchspls_o   E DS                  ExtName(watchspls:*output)
     d                                     Qualified
     d WATCHSPACE_i  E DS                  ExtName(WATCHSPACE:*input)
     d                                     Qualified
     d WATCHSPACE_o  E DS                  ExtName(WATCHSPACE:*output)
     d                                     Qualified

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------
      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         480A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            520A   varying

     D DISKSPACE       s             06s 3 dtaara

       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
       //p_md                         001a   DIM(256)
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

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D P_INFIL         s             21A   inz
     D §RECORDS        s              7  0 inz
     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz
     D error4          s              1a   inz
     D error5          s              1a   inz
     D Quser           s             10a   inz
     D Qjob            s             10a   inz
     D Qnumber         s              6a   inz
     D link            s             26a   inz
     D Qspool          s             10a   inz
     D qlfdnr          s              4a   inz
     D qoutq           s             10a   inz
     D qinputdat       s             08a   inz
     D qinputdat#      s               d   DATFMT(*ymd)
     D qinputtime      s             08a   inz

     D qinfos          s             21a   inz
     D qinfos2         s             21a   inz
     D qalertdate      s              8a   inz
     D qalertdat#      s               d   DATFMT(*ymd)
     D qalerttime      s              8a   inz
     D qspace          s              5a   inz
     D qspace2         s              5a   inz
     D qspace#         s              4  2 inz
     D qalertmsg       s              8a   inz
     D §pstamp         s               z   inz
     D §datum          S               D   inz
     D §zeit           S               T   inz

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       // exsr      sr_logal;
       eval status ='Start Aufbau für WATCHSPL1  eingeleitet   ';
       exsr      SR_log;

       //for ...
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(GANG) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CRTPF FILE(TVRELWAECO/WATCHSPLS) RCDLEN(200) TEXT(WATCHSPLS)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CRTPF                  ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PRT01)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRT01) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PRT55)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRT55) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PRTLAG06)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRTLAG06) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;


       //for WRKSPLF SELECT(*ALL PRTLAG20)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRTLAG20) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PAPIERKORB)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PAPIERKORB) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PRT04)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRT04) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;


       //for WRKSPLF SELECT(*ALL qprint)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL QPRINT) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       //for WRKSPLF SELECT(*ALL PRTWNL01)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL PRTWNL01) OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;


       //for errorlog  WRKSPLF SELECT(*ALL *ALL *ALL *ALL *ALL QPJOBLOG) JOB(*ALL)
       MONITOR;
       Wrk.var1 =
           'WRKSPLF SELECT(*ALL *ALL *ALL *ALL *ALL QPJOBLOG) JOB(*ALL)' +
           ' OUTPUT(*PRINT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: WRKSPLF                ';
          exsr      SR_log;
       endmon;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(QPRTSPLF) TOFILE(TVRELWAECO/WATCHSPLS) ' +
           'SPLNBR(*LAST) MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CPYSPLF                ';
          exsr      SR_log;
       endmon;

       §records=*zero;
       exec sql
          update WATCHSPLS set
          watchSPLs = substr(WATCHSPLS, 001, 150) concat
          current timestamp where
          substr(WATCHSPLS, 150, 026) = ' ';

       exec sql
          select count(*) into :§records
          from WATCHSPLS
          WHERE WATCHSPLS like '%$#IFBLT%' and
          substr(watchSPLs, 151, 26) > current timestamp - 01 minutes;

       exec sql
          select substr(WATCHSPLS, 04, 10),
                 substr(WATCHSPLS, 17, 10),
                 substr(WATCHSPLS, 29, 06) into :Qjob, :Quser, :Qnumber
          from WATCHSPLS
          WHERE WATCHSPLS like '%$#IFBLT%' and
          substr(watchSPLs, 151, 26) > current timestamp - 01 minutes;

       link = qnumber + '/' + %trimr(quser) + '/' + %trimr(qjob);

       in  *lock *dtaara;
       open  watchSPLs;

       read watchSPLs   watchSPLs_i;
       dow not %eof(watchspls);
       //
          qspool     = %subst(watchspls_i: 002: 10);
          qjob       = %subst(watchspls_i: 108: 10);
          quser      = %subst(watchspls_i: 013: 10);
          qnumber    = %subst(watchspls_i: 119: 06);
          qlfdnr     = %subst(watchspls_i: 103: 04);
          qinputdat  = %subst(watchspls_i: 083: 08);
          qinputtime = %subst(watchspls_i: 092: 08);
          qoutq      = %subst(watchspls_i: 024: 10);
          link = qnumber + '/' + %trimr(quser) + '/' + %trimr(qjob);

          monitor;
             qinputdat#=%date(%subst(qinputdat: 07: 02) + '/' +
                              %subst(qinputdat: 04: 02) + '/' +
                              %subst(qinputdat: 01: 02):*ymd);
          on-error;
               qinputdat#=%date();
          endmon;

          if   qspool = 'QPEZDISK';
            error1 ='0';
          endif;


       // if  ((qinputdat# < %date()-%days(000)
       //for ... attenion alert messages, determine
          if      qspool = 'QPEZDISK' and quser='GANG';
            exsr sr_space;
          endif;

       //for ... attenion alert messages, determine
          if      qspool = 'QPDSPSTS' and quser='GANG';
            exsr sr_space;
          endif;

          if  ((qinputdat# < %date()-%days(002)
               or qspool = 'QPQXPRTF') and quser='GANG'
       //////////////                  and qspool<>'QPEZDISK'
                                       and qspool<>'$#IFBLP'
                                       and qspool<>'$#IFBLT')
               or
              ((qinputdat# < %date()-%days(000)
               or qspool = 'QPDSPAJB') and quser='GANG'
       //////////////                  and qspool<>'QPEZDISK'
                                       and qspool<>'$#IFBLP'
                                       and qspool<>'$#IFBLT')
               or
              ((qinputdat# < %date()-%days(000) or
                qinputdat# = %date()-%days(000))
                                       and quser='GANG'
                                       and qspool='QPEZDISK')
               or
              ((qinputdat# < %date()-%days(000) or
                qinputdat# = %date()-%days(000))
                                       and quser='GANG'
                                       and qspool='QPDSPSTS')
               or
              ((qinputdat# < %date()-%days(000) or
                qinputdat# = %date()-%days(000))
                                       and qoutq='QEZJOBLOG'
                                       and qspool='QPJOBLOG')
               or
              (qinputdat# < %date()-%days(002)
               and qoutq='PRT01')
               or
              (qinputdat# < %date()-%days(070)
               and qoutq='PRT04')
               or
              (qinputdat# < %date()-%days(070)
               and qoutq='QPRINT')
               or
              (qinputdat# < %date()-%days(010)
               and qoutq='PRTLAG06')
               or
              (qinputdat# < %date()-%days(032)
               and qoutq='PRTWNL01')
               or
              (qinputdat# < %date()-%days(065));

       //delete then
              MONITOR;
              Wrk.var1 =
                  'DLTSPLF FILE(' + %trimr(qspool) + ')' +
                  ' JOB(' + %trimr(LINK) +')' + ' SPLNBR(' + %triml(qlfdnr) +
                  ')';
                cmd = %TrimR(Wrk.Var1);
                L      = %Len(Cmd);
                QCMDEXC(cmd: %len(cmd));
                 error1 ='0';
              on-error;
                 error1 ='1';
                 status='error in command appeared: dltsplf                ';
       //        exsr      SR_log;
              endmon;

              watchspls_o   = watchspls_i;
              %subst(watchspls_o: 190: 08) = '*deleted';
              update phy01r   watchspls_o;
          endif;
          read watchspls   watchspls_i;
       enddo;

       close watchspls;

       out *dtaara;

       //alert check
       exsr      SR_alert;
       //alert check ausgabe
       §records=*zero;
       exec sql
          select count(*) into :§records
                          FROM WATCHSPACE WHERE WATCHSPACE like
          '%*alert!!%'and date(substr(watchspace, 160, 10))= current date
             - 0 day;

       if §records > 0;
          exsr      sr_logal;
       endif;

       eval status ='Ende Aufbau für WATCHSPL1  eingeleitet    ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'CUTOFF_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'CUTOFF';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Rhenania/CUTOFF_*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/CUTOFF_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/CUTOFF_*';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'CUTOFF   ';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object CUTOFF                    ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'CUTOFF';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/cutoff)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/cutoff)       ';
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //space watchdog  sr_space inaktiv in spool übernehmen
       //Datei aufbauen
       //-----------------------------------------------------------------------

       begsr sr_space;

       //for ...
       MONITOR;
       Wrk.var1 =
           'CRTPF FILE(TVRELWAECO/WATCHSPACE) RCDLEN(200) TEXT(WATCHSPACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
       // status='error in command appeared: CRTPF                  ';
       // exsr      SR_log;
       endmon;

       //for ...
       //     Wrk.var1 =
       //         'DLTSPLF FILE(' + %trimr(qspool) + ')' +
       //         ' JOB(' + %trimr(LINK) +')' + ' SPLNBR(' + %triml(qlfdnr) +
       //         ')';
       MONITOR;
       Wrk.var1 =
           'CPYSPLF FILE(' + %trimr(qspool) + ') ' +
           'TOFILE(TVRELWAECO/WATCHSPACE) ' +
           ' JOB(' + %trimr(LINK) +')' + ' SPLNBR(' + %triml(qlfdnr) +
           ')' +
           ' MBROPT(*ADD)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          error1 ='0';
       on-error;
          error1 ='1';
          status='error in command appeared: CRTPF                  ';
          exsr      SR_log;
       endmon;

       endsr;

       //-----------------------------------------------------------------------
       //space watchdog  sr_alert ermitteln
       //alert
       //-----------------------------------------------------------------------

       begsr sr_alert;

       open  WATCHSPACE;

       read WATCHSPACE  WATCHSPACE_i;
       dow not %eof(WATCHSPACE);
       //,,,
          qinfos     = %subst(WATCHSPACE_i: 002: 21);
          qinfos2    = %subst(WATCHSPACE_i: 069: 21);
          qalertdate = %subst(WATCHSPACE_i: 047: 08);
          qalerttime = %subst(WATCHSPACE_i: 057: 08);
          qspace     = %subst(WATCHSPACE_i: 048: 05);
          qspace2    = %subst(WATCHSPACE_i: 116: 05);
          qalertmsg  = %subst(WATCHSPACE_i: 190: 08);

          If qinfos  = 'Informationen erfasst';
             monitor;
                qalertdat#=%date(%subst(qalertdate: 07: 02) + '/' +
                                 %subst(qalertdate: 04: 02) + '/' +
                                 %subst(qalertdate: 01: 02):*ymd);
             on-error;
                  qalertdat#=%date();
             endmon;
          endif;

          If qinfos2 = '% System-ASP benutzt ';
             monitor;
                  qalertdat#=%date();
             on-error;
                  qalertdat#=%date();
             endmon;
          endif;

          if       qinfos  = 'Freier Speicherplatz ' ;
             monitor;
               qspace# = %dec(qspace:04:02);
             on-error *all;
                 // nicht numerisch
               qspace# = 1;
             endmon;
          endif;

          if       qinfos2 = '% System-ASP benutzt ';
             monitor;
               qspace# = 100 - %dec(qspace2:04:02);
             on-error *all;
                 // nicht numerisch
               qspace# = 1;
             endmon;
          endif;

          if  (qalertmsg  <> '*alert!!')
          and   qalertdat# > %date()-%days(010);
            if      qinfos  = 'Freier Speicherplatz '
            or      qinfos2 = '% System-ASP benutzt ' ;
       //     if      qspace# < 50,00;
              if      qspace# < DISKSPACE;
                WATCHSPACE_o   = WATCHSPACE_i;

                exec sql
                 select current timestamp, current date, current time
                 into   :§pstamp, :§datum, :§zeit
                 from   qsys2/qsqptabl;

                %subst(WATCHSPACE_o: 190: 08) = '*alert!!';
                %subst(WATCHSPACE_o: 131: 26) =
                                        %char(§pstamp);
                %subst(WATCHSPACE_o: 175: 08) =
                                        %char(qalertdat#);
                %subst(WATCHSPACE_o: 160: 10) =
                                        %char(%date());
                if       qinfos2 = '% System-ASP benutzt ';
                  %subst(WATCHSPACE_o: 40: 14) = '*        ' +
                                                 %char(qspace#);
                endif;
                update phy02r   WATCHSPACE_o;
              endif;
            endif;
          endif;

          read WATCHSPACE  WATCHSPACE_i;
       enddo;

       close WATCHSPACE;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'AT_item   ';
       //  %Subarr(p_md:11:10)  = §§§JOB;
       //  %Subarr(p_md:22:10)  = §§§USR;
       //  %Subarr(p_md:33:132) = status;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       endsr;
       //-----------------------------------------------------------------------
       //log report alert    DLTOVR FILE(QPQXPRTF) LVL(*JOB)
       //-----------------------------------------------------------------------

       begsr sr_logal;

       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
           'PAGESIZE(*N 132) '  +
           'FORMTYPE(''SpaceAlert'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object ' +
                         p_outfil +'csv';
          exsr      SR_log;
       endmon;
         clear p_md;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status;

         eval p_msg     =  '#AL0005';
         eval p_msgf    =  *blank;
         eval p_print   =  'PRT55';
         eval p_outfil  =  ' ';
         eval p_lib     =  ' ';
         eval p_repadd  =  ' ';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       MONITOR;
          Wrk.var1 =
              'DLTOVR FILE(QPQXPRTF) LVL(*JOB)        ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error DLTOVR FILE(QPQXPRTF) LVL(*JOB)           ';
             exsr      SR_log;
       endmon;
       endsr;
