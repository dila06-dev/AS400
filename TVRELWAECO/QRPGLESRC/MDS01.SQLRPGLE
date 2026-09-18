
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //
      //
      //
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

      // Lieferscheinkopf
     fmds_01    uf   e           k disk    RENAME(mds_01:PHY01R)
     f                                     prefix('$')
     f                                     USROPN
     fteil01    if   e           k DISK


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

     d mds_01_k      E DS                  ExtName(mds_01:*key)
     d                                     Qualified
     d mds_01_i      E DS                  ExtName(mds_01:*input)
     d                                     Qualified
     d mds_01_o      E DS                  ExtName(mds_01:*output)
     d                                     Qualified

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
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
     D output          s              1a   inz


     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
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

       eval status ='Start Aufbau für MDS01     eingeleitet    ';
       exsr      SR_log;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/MDS_01)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/MDS_01)                ';
               exsr      SR_log;
         endmon;

       //************************************************************
       //insert
       exec sql
          insert into MDS_01
          SELECT DISTINCT
          ENTITY, ITEM, ORIGINAL, DESCRIP, APPRGR, REPLACED1,REPLACED2,
          REPLACED3, REPLACED4, REPLACED5, REPLACED6, char(' ', 1)
          local, char(' ', 10) sup, char(' ', 40) supname ,
          zoned(0, 9, 4) length, zoned(0, 9, 4) width,
          zoned(0, 9, 4) height, zoned(0, 9, 4) gross,
          zoned(0, 9, 4) net,char(' ', 15) customs,
          char(' ', 3) landorg,  char(' ', 13) ean,
          zoned(0, 11, 4) lancosp,
          zoned(0, 04, 0) parts, char('0', 1) in_bom,
          char('  ', 3) stat, current timestamp tstamp
          FROM checkout3
          WHERE APPRGR <> '990';


       exec sql
          insert into mds_01
          SELECT DISTINCT
          'DE411 'ENTITY , WAOFVEUR,char(' ', 15) ORIGINAL,
           ARTBEZ  DESCRIP, artgrp APPRGR, E1,E2,
          E3, E4, E5, E6, char(' ', 1)
          local, char(' ', 10) sup, char(' ', 40) supname ,
          zoned(0, 9, 4) length, zoned(0, 9, 4) width,
          zoned(0, 9, 4) height, zoned(0, 9, 4) gross,
          zoned(0, 9, 4) net,char(' ', 15) customs,
          char(' ', 3) landorg,  char(' ', 13) ean,
          zoned(0, 11, 4) lancosp,
          zoned(0, 04, 0) parts, char('0', 1) in_bom,
          char('  ', 3) stat, current timestamp tstamp
          FROM RPMKALKUL where waofveur not in (
           select item from mds_01);

       //************************************************************
       exec sql
          update mds_01    set parts      =
          (select count(*)      FROM bar_kalk/SLAZS
           where item     = SLAZTENR group by  SLAZTENR )
          where exists
          (select  count(*)     FROM bar_kalk/SLAZS
           where item     = SLAZTENR group by  SLAZTENR );

       exec sql
          update mds_01    set in_bom     = '1'
           where item in (select SLAZKOTE from bar_kalk/SLAZS);

       //************************************************************
       exec sql
          update  tvrelwaeco/MDS_01     a set a.DESCRIP =
          (select b.teTBZ1 from teil01 b where
                  tefirm='08' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'BE111')
          where exists
          (select b.teTBZ1 from teil01 b where
                  tefirm='08' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'BE111');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.DESCRIP =
          (select b.teTBZ1 from teil01 b where
                  tefirm='52' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'NL411')
          where exists
          (select b.teTBZ1 from teil01 b where
                  tefirm='52' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'NL411');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.DESCRIP =
          (select b.teTBZ1 from teil01 b where
                  tefirm='55' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'CH412')
          where exists
          (select b.teTBZ1 from teil01 b where
                  tefirm='55' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'CH412');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.DESCRIP =
          (select b.teTBZ1 from teil01 b where
                  tefirm='61' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'AT411')
          where exists
          (select b.teTBZ1 from teil01 b where
                  tefirm='61' and a.item=b.tetenr and descrip=' '
                  and ENTITY = 'AT411');
       //************************************************************

       exec sql
          update  tvrelwaeco/MDS_01     a set a.sup =
          (select b.TESTLF from teil01 b where
                  tefirm='08' and a.item=b.tetenr
                  and ENTITY = 'BE111')
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='08' and a.item=b.tetenr
                  and ENTITY = 'BE111');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.sup =
          (select b.TESTLF from teil01 b where
                  tefirm='52' and a.item=b.tetenr
                  and ENTITY = 'NL411')
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='52' and a.item=b.tetenr
                  and ENTITY = 'NL411');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.sup =
          (select b.TESTLF from teil01 b where
                  tefirm='55' and a.item=b.tetenr
                  and ENTITY = 'CH412')
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='55' and a.item=b.tetenr
                  and ENTITY = 'CH412');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.sup =
          (select b.TESTLF from teil01 b where
                  tefirm='01' and a.item=b.tetenr
                  and ENTITY = 'DE411')
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='01' and a.item=b.tetenr
                  and ENTITY = 'DE411');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.sup =
          (select b.TESTLF from teil01 b where
                  tefirm='61' and a.item=b.tetenr
                  and ENTITY = 'AT411')
          where exists
          (select b.TESTLF from teil01 b where
                  tefirm='61' and a.item=b.tetenr
                  and ENTITY = 'AT411');

       //************************************************************

       exec sql
          update  tvrelwaeco/MDS_01     a set a.local = '1'
          where ENTITY='BE111' and
          sup in (select LFLFNR from lief01 b where
                  lffirm='08' and lflfat<>'000'  );

       exec sql
          update  tvrelwaeco/MDS_01     a set a.supname =
          (select b.LFNAM1 from lief01 b where
                  lffirm='08' and a.sup=b.LFLFNR
                  and ENTITY = 'BE111')
          where exists
          (select b.LFNAM1 from lief01 b where
                  lffirm='08' and a.sup=b.LFLFNR
                  and ENTITY = 'BE111');


       exec sql
          update  tvrelwaeco/MDS_01     a set a.local = '1'
          where ENTITY='NL411' and
          sup in (select LFLFNR from lief01 b where
                  lffirm='52' and lflfat<>'000'  );

       exec sql
          update  tvrelwaeco/MDS_01     a set a.supname =
          (select b.LFNAM1 from lief01 b where
                  lffirm='52' and a.sup=b.LFLFNR
                  and ENTITY = 'NL411')
          where exists
          (select b.LFNAM1 from lief01 b where
                  lffirm='52' and a.sup=b.LFLFNR
                  and ENTITY = 'NL411');


       exec sql
          update  tvrelwaeco/MDS_01     a set a.local = '1'
          where ENTITY='CH412' and
          sup in (select LFLFNR from lief01 b where
                  lffirm='55' and lflfat<>'000'  );

       exec sql
          update  tvrelwaeco/MDS_01     a set a.supname =
          (select b.LFNAM1 from lief01 b where
                  lffirm='55' and a.sup=b.LFLFNR
                  and ENTITY = 'CH412')
          where exists
          (select b.LFNAM1 from lief01 b where
                  lffirm='55' and a.sup=b.LFLFNR
                  and ENTITY = 'CH412');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.local = '1'
          where ENTITY='DE411' and
          sup in (select LFLFNR from lief01 b where
                  lffirm='01' and lflfat<>'000'  );

       exec sql
          update  tvrelwaeco/MDS_01     a set a.supname =
          (select b.LFNAM1 from lief01 b where
                  lffirm='01' and a.sup=b.LFLFNR
                  and ENTITY = 'DE411')
          where exists
          (select b.LFNAM1 from lief01 b where
                  lffirm='01' and a.sup=b.LFLFNR
                  and ENTITY = 'DE411');

       exec sql
          update  tvrelwaeco/MDS_01     a set a.local = '1'
          where ENTITY='AT411' and
          sup in (select LFLFNR from lief01 b where
                  lffirm='61' and lflfat<>'000'  );

       exec sql
          update  tvrelwaeco/MDS_01     a set a.supname =
          (select b.LFNAM1 from lief01 b where
                  lffirm='61' and a.sup=b.LFLFNR
                  and ENTITY = 'AT411')
          where exists
          (select b.LFNAM1 from lief01 b where
                  lffirm='61' and a.sup=b.LFLFNR
                  and ENTITY = 'AT411');

       //************************************************************

       //Protokolldaten
       open  MDS_01;

       read mds_01   mds_01_i;
       dow not %eof(mds_01);
             MDS_01_o  = MDS_01_i;
             §search              = ';';
             §string              = mds_01_O.SUPNAME;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             mds_01_O.SUPNAME     = §string;
             §search              = ',';
             §string              = mds_01_O.SUPNAME;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             mds_01_O.SUPNAME     = §string;
             §search              = '"';
             §string              = mds_01_O.SUPNAME;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             mds_01_O.SUPNAME     = §string;
             §search              = '`';
             §string              = mds_01_O.SUPNAME;
             §replace             = ' ';
             §pos                 = 0 ;
             exsr      scanstr;
             mds_01_O.SUPNAME     = §string;
       //teil
             select;
             when mds_01_O.ENTITY = 'DE411' ;
                  teil_k.tefirm    =  '01';
             when mds_01_O.ENTITY = 'BE111' ;
                  teil_k.tefirm    =  '08';
             when mds_01_O.ENTITY = 'NL411' ;
                  teil_k.tefirm    =  '52';
             when mds_01_O.ENTITY = 'CH412' ;
                  teil_k.tefirm    =  '55';
             when mds_01_O.ENTITY = 'AT411' ;
                  teil_k.tefirm    =  '61';
             other;
             endsl;
             teil_k.tetenr    =   mds_01_O.item;
             chain %kds(teil_k:2) teil01 teil_I;
             if %found(teil01);
                mds_01_O.LENGTH = teil_i.TELANG;
                mds_01_O.WIDTH  = teil_i.TEBREI;
                mds_01_O.HEIGHT = teil_i.TEHOHE;
                mds_01_O.GROSS  = teil_i.tegwbr;
                mds_01_O.NET    = teil_i.tegwnt;
                mds_01_O.customs= teil_i.TEZOTN;
                mds_01_O.landorg= teil_i.teurld;
                mds_01_O.ean    = teil_i.TEEANR;
                mds_01_O.stat   = 'ON';
                if teil_i.TETEST >'89';
                   mds_01_O.stat   = 'OFF';
                endif;
                mds_01_O.lancosp= teil_i.TESTPR * 0;
             endif;
          update phy01r   mds_01_o;
       //,,,
          read MDS_01   mds_01_i;
       enddo;

       close MDS_01;


       output = '0';
       if output = '1';
          exsr SR_output;
       endif;


       eval status ='Ende Aufbau für MDS01      eingeleitet    ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //%scan Zeichen(§search) ersetzten durch(§replace) in string(§string)
       //-----------------------------------------------------------------------

       begsr scanstr;

             §pos = %scan(§search: §string);
             dow §pos > 0;
                §string = %replace(§replace: §string: §pos: %len(§search));
                if (§pos+%len(§replace) > %len(§string));
                   §pos = 0;
                else;
                   §pos = %scan(§search: §string: §pos+%len(§replace));
                endif;
             enddo;

       endsr;
       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'WATCHLFS_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'WATCHJOBS';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Rhenania/WATCHLFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/WATCHLFS_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/WATCHLFS_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'WATCHJOBS';

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
          status='Error by CVTDBF object WATCHLFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/WATCHLFS)      ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/WATCHLFS)     ';
       endmon;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/IT/WATCHLFS*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /IR/WATCHLFS_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /IT/WATCHLFS_*';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'WATCHJOBS';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/IT/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object WATCHLFS                  ';
          exsr      SR_log;
       endmon;
       eval p_outfil =  'WATCHJOBS';

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
