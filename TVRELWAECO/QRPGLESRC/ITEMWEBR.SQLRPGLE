
      //************************************************************************
      //
      //      Programmname       ITEMWEBR   WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://...
      //       ===> CALL PGM(ITEMWEBR) PARM(GANG cccccccc '4711' 'ean' 0 0 3 4 5 6 LM 1 W 1 2
      //      3 4 5 6 LM 1 FFSD 1 2 3 4 5 6 DD 1 'sdfsdfd' 'j')
      //
      //      BMIDEN, BMEGEW                 in   pbestlo
      //
      //  http://edc.dometic.com/en-us/measure/
      //  Anmeldung: edc@dometic.com               ma@dometic.com
      //             mobileLiving2017              dometicCVX
      //
      //  SELECT * FROM job_run WHERE PGM ='ITEMWEBR'
      //  SELECT * FROM job_run WHERE PGM ='LFS_PUNITS'
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
     h copyright('IT Dometic 2015')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // ...
     fteil01    if   e           k DISK
     f                                     USROPN

     flbpm01    if   e           K DISK
     f                                     USROPN

     fpbfstss   if   e           K DISK
     f                                     USROPN
     f

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d ITEMWEBR        PR
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_item                        15a
     d p_decript                     80a
     d p_notify                      80a
       //class 1
     d p_ean                         15a
     d p_length                      11s 2
     d p_width                       11s 2
     d p_hight                       11s 2
     d p_quant                       11s 2
     d p_grosswei                    11s 4
     d p_netwei                      11s 4
       //Lademittel
     d p_cargo                        3a
     d p_cargoq                      11s 2
       //***LFS current situation
     d pLean                         15a
     d pLlength                      11s 2
     d pLwidth                       11s 2
     d pLhight                       11s 2
     d pLquant                       11s 2
     d pLgrosswei                    11s 4
     d pLnetwei                      11s 4
       //Lademittel
     d pLcargo                        3a
     d pLcargoq                      11s 2
       //***Trend current situation
     d pTean                         15a
     d pTlength                      11s 2
     d pTwidth                       11s 2
     d pThight                       11s 2
     d pTquant                       11s 2
     d pTp_grosswei                  11s 4
     d pTnetwei                      11s 4
       //Lademittel
     d pTcargo                        3a
     d pTcargoq                      11s 2
       //Messages and return
     d p_load                         1a
     d p_Message                    132a
     d p_cc                           1


     d ITEMWEBR        PI
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_item                        15a
     d p_decript                     80a
     d p_notify                      80a
       //class 1
     d p_ean                         15a
     d p_length                      11s 2
     d p_width                       11s 2
     d p_hight                       11s 2
     d p_quant                       11s 2
     d p_grosswei                    11s 4
     d p_netwei                      11s 4
       //Lademittel
     d p_cargo                        3a
     d p_cargoq                      11s 2
       //***LFS current situation
     d pLean                         15a
     d pLlength                      11s 2
     d pLwidth                       11s 2
     d pLhight                       11s 2
     d pLquant                       11s 2
     d pLgrosswei                    11s 4
     d pLnetwei                      11s 4
       //Lademittel
     d pLcargo                        3a
     d pLcargoq                      11s 2
       //***Trend current situation
     d pTean                         15a
     d pTlength                      11s 2
     d pTwidth                       11s 2
     d pThight                       11s 2
     d pTquant                       11s 2
     d pTgrosswei                    11s 4
     d pTnetwei                      11s 4
       //Lademittel
     d pTcargo                        3a
     d pTcargoq                      11s 2
       //Messages and return
     d p_load                         1
     d p_Message                    132a
     d p_cc                           1


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

     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d lbpm01_i      E DS                  ExtName(lbpm01:*input)
     d                                     Qualified

     d lbpm01_k      E DS                  ExtName(lbpm01:*key)
     d                                     Qualified

     d pbfstss_i     E DS                  ExtName(pbfstss:*input)
     d                                     Qualified

     d pbfstss_k     E DS                  ExtName(pbfstss:*key)
     d                                     Qualified

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------
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

       // ______________________________________________________________________
       // QSYGETPH
       // ______________________________________________________________________
     D QSYGETPH        PR                  ExtPgm('QSYGETPH')
     D WkUser                        10A
     D WKPassword                    10A
     D ProfileHandle                 12A
     d QUSEC                        274A
     D PassWordLength                10i 0
     D CCSID                         10i 0
       //
       // ______________________________________________________________________
       // LFS_PUNITS
       // ______________________________________________________________________
     D LFS_PUNITS      PR                  ExtPgm('LFS_PUNITS')
     D WkUser                        10A
       //
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


       // ______________________________________________________________________
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
     D error1          s              1A   inz
     D error2          s              1A   inz
     D option          s              1A   inz
     D $_blank         s            206a   inz

     D WkUser          S             10A   inz('*error ')
     D WKPassword      S             10A   inz('*error ')
     D ProfileHandle   S             12A
     D QUSEC           ds
     d QUSBPRV                 1      4B 0
     D QUSBAVL                 5      8B 0
     d QUSEI                   9     15
     D QUSERVED               16     16
     D ERRC0100               17    274    Varying


     D PassWordLength  S             10i 0 inz(10)
     D CCSID           S             10i 0 inz(37)
     d error           S               n
     d ch_tetenr       S             15a   inz

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

       eval status ='Start WebService ITEMWEBR  eingeleitet ' +
                                         p_item;
       exsr      SR_log;

       exsr sr_checkpw;
       if Error = *ON;
          eval status    = 'Anmeldung wrong:' +  Wkuser + ' ' + WKPassword;
          eval p_Message = 'access failed                                ';
          exsr      SR_log;
       else;
          exsr sr_fkt;
       endif;

       eval status ='Ende WebService ITEMWEBR eingeleitet ' + p_Item;
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //check user
       //-----------------------------------------------------------------------

       begsr sr_checkpw;

       Wkuser     = %subst(p_User:1:10);
       WKPassword = %subst(p_Pword:1:10);
       callP  QSYGETPH(WKUser: WKPassword:      ProfileHandle:
                       QUSEC:  PasswordLength:  CCSID);
       If        QUSBAVL > 0;
          Eval      Error = *ON;
       Endif;

       endsr;

       //-----------------------------------------------------------------------
       //Funktion
       //-----------------------------------------------------------------------

       begsr sr_fkt;

       error1 ='0';
       option ='0';
       p_Message = *blank;

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(TVPF) POSITION(*first)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(TVPF) POSITION(*first)       ';
             p_Message = 'invalid environment found            ';
             exsr      SR_log;
             error1 ='1';
       endmon;
       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(DOMDATV7) POSITION(*last)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error2 ='0';
          on-error;
             status='error ADDLIBLE LIB(DOMDATV7) POSITION(*last)  ';
             p_Message = 'invalid environment found            ';
             exsr      SR_log;
             error2 ='1';
       endmon;
       p_decript    = *blank;
       p_notify     = *blank;
       pTean        = *blank;
       pTlength     = 0;
       pTwidth      = 0;
       pThight      = 0;
       pTquant      = 0;
       pTgrosswei   = 0;
       pTnetwei     = 0;
       pTcargo      = *blank;
       pTcargoq     = 0;

       pLean        = *blank;
       pLlength     = 0;
       pLwidth      = 0;
       pLhight      = 0;
       pLquant      = 0;
       pLgrosswei   = 0;
       pLnetwei     = 0;
       pLcargo      = *blank;
       pLcargoq     = 0;

       p_cc       = '1';
       //übergabe enthält Information ASN
       if (error1='0' or error1='1');
          If p_item <> *blank;
             open teil01;
       //   teil01
             teil_k.tefirm = '01';
             teil_k.tetenr = p_item;
             chain %kds(teil_k:2) teil01 teil_I;
             if %found(teil01);
                open pbfstss;
                pbfstss_k.tzkonz = 'EMS';
                pbfstss_k.tzfirm = 'DWI';
                pbfstss_k.tziden = p_item;
                chain %kds(pbfstss_k:3) pbfstss   pbfstss_I;
                if %found(pbfstss);
       //         pbfstss
                   option = '1';
                   if option = '1';
                      if teil_i.TEERTE <> ' ';
                         p_notify     = 'Ersatzartikel: ' + teil_i.TEERTE;
                      endif;
                      p_decript    = teil_i.tetbz1 + ' ' + teil_i.tetbz2;
       //             ***LFS current situation
                      pLean          =  pbfstss_i.TZEAN;
                      pLlength       =  pbfstss_i.TZVLL/10;
                      pLwidth        =  pbfstss_i.TZVLB/10;
                      pLhight        =  pbfstss_i.TZVLH/10;
                      pLquant        =  1;              // *default
                      pLgrosswei     =  pbfstss_i.TZBRUT;
                      pLnetwei       =  pbfstss_i.TZNETT;
       //             Lademittel
                      pLcargo        =  pbfstss_i.TZLM;
                      pLcargoq       =  pbfstss_i.TZMLM;

       //          // ***Trend current situation
                      pTean          =  teil_i.TEEANR;
                      pTlength       =  teil_i.TELANG*1;
                      pTwidth        =  teil_i.TEBREI*1;
                      pThight        =  teil_i.TEHOHE*1;
                      pTquant        =  1;              // *default
                      pTgrosswei     =  teil_i.tegwbr;
                      pTnetwei       =  teil_i.tegwnt;
       //           // Lademittel
                      open lbpm01;
                      LBPM01_k.LBPMFIRM = '01';
                      LBPM01_k.LBPMTENR = P_item;
                      chain %kds(LBPM01_k:2) LBPM01    LBPM01_I;
                      if %found(LBPM01);
                         pTcargo          = LBPM01_i.LBPMVPMI;
                         pTcargoq         = LBPM01_i.LBPMAZME;
                      endif;
                      close lbpm01;
                   else;
                   endif;
                   p_cc       = '0';
                   if p_load    = '1';
                      exsr checkinput;
                   else;
                      p_Message = 'Data for SKU ' + p_item +
                                  ' in Trend / LFS found! ';
                   endif;
                else;
                   p_Message = 'Itemr ' + p_item +
                               ' unknown in setting for LFS in this option ';
                endif;
                close pbfstss;
             else;
                p_Message = 'Itemr ' + p_item +
                               ' unknown in setting for Trend in this option ';
             endif;
             close teil01;
          else;
             p_Message = 'Missing necessary transfer information      ';
             p_cc       = '1';
          endif;
       endif;

       endsr;

       //-----------------------------------------------------------------------
       //update
       //-----------------------------------------------------------------------

       begsr sr_update;

       //         ==> status kl.Einheit
       exec sql                                                              // class 1
         insert into TVRELWAECO/KHT_PBM                                   // p_ean
         SELECT char(:p_item, 15),char('kl,Einheit', 15),                 // p_length
                zoned((:p_quant), 12, 4), zoned((:p_length), 12, 4),      // p_width
                zoned((:p_width), 12, 4),  zoned((:p_hight), 12, 4),      // p_hight
                zoned(0, 12, 4),                                          // p_quant
                zoned((:p_grosswei), 12, 4), zoned((:p_netwei), 12, 4),   // p_grosswei
                char(:p_ean , 20),                                        // p_netwei
                char(:p_cargo, 10), current  date, current timestamp,     //  Lademittel
                :$_blank concat :Wkuser,                                  // p_cargo
                                 current date, current timestamp FROM     // p_cargoq
                qsys2/qsqptabl;                                           //

       if sqlstate > *zero;
       //liblist
          MONITOR;
             Wrk.var1 =
                 'DSPJOBLOG OUTPUT(*PRINT)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error  DSPJOBLOG OUTPUT(*PRINT)                 ';
                exsr      SR_log;
          endmon;
       endif;

       if p_cargo <> '   ';
          exec sql
            insert into TVRELWAECO/KHT_PBM
            SELECT char(:p_item, 15),char('Palette   ', 15),
                   zoned((:p_cargoq), 12, 4), zoned((0      ), 12, 4),
                   zoned((0      ), 12, 4), zoned((0      ), 12, 4),
                   zoned(0, 12, 4),
                   zoned((:p_grosswei), 12, 4), zoned((:p_netwei), 12, 4),
                   char(:p_ean , 20),
                   char(:p_cargo, 10), current  date, current timestamp,
                   :$_blank concat :Wkuser,
                                    current date, current timestamp FROM
                   qsys2/qsqptabl;
       endif;

       if sqlstate > *zero;
       //liblist
          MONITOR;
             Wrk.var1 =
                 'DSPJOBLOG OUTPUT(*PRINT)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error  DSPJOBLOG OUTPUT(*PRINT)                 ';
                exsr      SR_log;
          endmon;
       endif;

       callP LFS_PUNITS(Wkuser);

       endsr;

       //-----------------------------------------------------------------------
       //log report
                                  //class 1
                                //   d p_ean                         15a
                                //   d p_length   cm                 11s 2
                                //   d p_width    cm                 11s 2
                                //   d p_hight    cm                 11s 2
                                //   d p_quant                       11s 2
                                //   d p_grosswei kg                 11s 4
                                //   d p_netwei   kg                 11s 4
                                  //Lademittel
                                //   d p_cargo    interner Matchcode  3a
                                //   d p_cargoq                      11s 2
       //-----------------------------------------------------------------------

       begsr checkinput;

       if p_length   = pbfstss_i.TZVLL/10  and
          p_length   = teil_i.TELANG*1     and
          p_width    = pbfstss_i.TZVLB/10  and
          p_width    = teil_i.TEBREI*1     and
          p_hight    = pbfstss_i.TZVLH/10  and
          p_hight    = teil_i.TEHOHE*1     and
          p_grosswei = pbfstss_i.TZBRUT    and
          p_grosswei = teil_i.tegwbr       and
          p_netwei   = pbfstss_i.TZNETT    and
          p_netwei   = teil_i.tegwnt;
       endif;

       //         ==> EAN prüfung
       clear ch_tetenr;
       exec sql
          SELECT tetenr  into :ch_tetenr from teil01
          WHERE TEFIRM ='01' and TEEANR = :p_ean
                        and :p_ean <> ' ' and tetenr    <> :p_item;

       if ch_tetenr  <> *blank;
             p_Message = 'Item ' + p_item +
                         ' EAN-Code bereits vergeben in: ' + ch_tetenr;
       //   ==> Achtung Fehlerkennung für nachfolgendeN WebDialog
             p_cc       = '1';
       else;
       select;
       when teil_i.TEPRGR <> '___';
          if p_length   >  600 or
             p_width    >  300 or
             p_hight    >  300 or
             p_grosswei >  200 or
             p_netwei   >  200 or
             p_cargoq   =  000;
             p_Message = 'Item ' + p_item +
                         ' measurements oversized / to large or zero';
          else;
             exsr sr_update;
             p_Message = 'Item ' + p_item +
                         ' transmitted for changing, reload screen';
          endif;
       other;
          p_Message = 'Item ' + p_item +
                      ' no check possible please review p-Group';
       endsl;
       endif;

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
                     %char(§§§JNO)        +
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
