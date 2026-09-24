
      //************************************************************************
      //
      //      Programmname       ITEMWEBR2  WebService
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
      //  Anmeldung: edc@dometic.com
      //             mobileLiving2017
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
     fteos01    uf a e           k DISK
     f                                     USROPN


      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d ITEMWEBR2       PR
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_item                        15a
     d p_decript                     80a
     d p_notify                      80a
       //class 1 duales System
     d p_c1                           1a
     d p_c1paper                     08s 0
     d p_c1plasti                    08s 0
       //class 2 elektro G
     d p_c2                           1a
     d p_c2weight                    08s 0
     d p_c2categ                      3a
     d p_c2des1                      50a
     d p_c2group                      3a
       //class 3 GRS Batterie V
     d p_c3                           1a
     d p_c3typ                        4a
     d p_c3des1                      10a
     d p_c3des2                      20a
     d p_c3des3                      12a
     d p_c3quanti                    08s 0
     d p_c3weight                    08s 0
       //class 4 transport
     d p_c4                           1a
     d p_c4paper                     08s 0
     d p_c4plasti                    08s 0
     d p_c4wood                      08s 0
       //Messages and return
     d p_load                         1a
     d p_Message                    132a
     d p_cc                           1

     d ITEMWEBR2       PI
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_item                        15a
     d p_decript                     80a
     d p_notify                      80a
       //class 1 duales System
     d p_c1                           1a
     d p_c1paper                     08s 0
     d p_c1plasti                    08s 0
       //class 2 elektro G
     d p_c2                           1a
     d p_c2weight                    08s 0
     d p_c2categ                      3a
     d p_c2des1                      50a
     d p_c2group                      3a
       //class 3 GRS Batterie V
     d p_c3                           1a
     d p_c3typ                        4a
     d p_c3des1                      10a
     d p_c3des2                      20a
     d p_c3des3                      12a
     d p_c3quanti                    08s 0
     d p_c3weight                    08s 0
       //class 4 transport
     d p_c4                           1a
     d p_c4paper                     08s 0
     d p_c4plasti                    08s 0
     d p_c4wood                      08s 0
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

     d teos_k        E DS                  ExtName(teos01:*key)
     d                                     Qualified

     d teos_i        E DS                  ExtName(teos01:*input)
     d                                     Qualified

     d teos_o        E DS                  ExtName(teos01:*output)
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


     D z               s             10  0 inz
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

       eval status ='Start WebService ITEMWEBR2 eingeleitet ' +
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

       eval status ='Ende WebService ITEMWEBR2 eingeleitet ' + p_Item;
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
       if p_load    <> '1';
          p_decript    = *blank;
          p_notify     = *blank;
          // class 1
          p_c1         = *blank;
          p_c1paper    = *zero;
          p_c1plasti   = *zero;
          // class 2
          p_c2         = *blank;
          p_c2weight   = *Zero;
          p_c2categ    = *blank;
          p_c2des1     = *blank;
          p_c2group    = *blank;
          // class 3
          p_c3         = *blank;
          p_c3typ      = *blank;
          p_c3des1     = *blank;
          p_c3des2     = *blank;
          p_c3des3     = *blank;
          p_c3quanti   = *Zero;
          p_c3weight   = *Zero;
          // class 4
          p_c4         = *blank;
          p_c4paper    = *Zero;
          p_c4plasti   = *Zero;
          p_c4wood     = *Zero;
       endif;
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
       //           //***Trend current situation
       //           // Lademittel
                      open lbpm01;
                      LBPM01_k.LBPMFIRM = '01';
                      LBPM01_k.LBPMTENR = P_item;
                      chain %kds(LBPM01_k:2) LBPM01    LBPM01_I;
                      if %found(LBPM01);
                      endif;
                      close lbpm01;
                   else;
                   endif;
                   p_cc       = '0';
                   if p_load    = '1';
                      exsr checkinput;
                   else;
                      exsr sr_read;
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

       begsr checkinput;

             exsr sr_update;
             p_Message = 'Item ' + p_item +
                         ' transmitted for changing, reload screen';
       endsr;

       //-----------------------------------------------------------------------
       //read
       //-----------------------------------------------------------------------

       begsr sr_read;

       //         ==> status kl.Einheit

       //teos01
       //class 1 duales System
       open teos01;
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4000';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
             teos_o            = teos_i;
             p_c1              = %subst(teos_o.TEOSMM01:1:1);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);
             p_c1paper         = %dec(teos_o.TEOSMM02:10:0);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);
             p_c1plasti        = %dec(teos_o.TEOSMM03:10:0);
             eval status ='Teos gelesen ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       else;
             eval status ='Teos fehlt   ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       endif;


       //class 2 elektro G
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4010';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
             teos_o            = teos_i;
             p_c2              = %subst(teos_o.TEOSMM01:1:1);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);
             p_c2weight        = %dec(teos_o.TEOSMM02:10:0);
             p_c2categ         = teos_o.TEOSMM03;
             p_c2group         = teos_o.TEOSMM04;
             eval status ='Teos gelesen ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       else;
             eval status ='Teos fehlt   ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       endif;


       //class 3 GRS Batterie V
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4020';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
             teos_o            = teos_i;
             p_c3              = %subst(teos_o.TEOSMM01:1:1);
             p_c3typ           = teos_o.TEOSMM02;
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);
             p_c3quanti        = %dec(teos_o.TEOSMM03:10:0);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);
             p_c3weight        = %dec(teos_o.TEOSMM04:10:0);
             eval status ='Teos gelesen ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       else;
             eval status ='Teos fehlt   ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       endif;


       //class 4 transport
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4030';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
             teos_o            = teos_i;
             p_c4              = %subst(teos_o.TEOSMM01:1:1);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);
             p_c4paper         = %dec(teos_o.TEOSMM02:10:0);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);
             p_c4plasti        = %dec(teos_o.TEOSMM03:10:0);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);
             p_c4wood          = %dec(teos_o.TEOSMM04:10:0);
             eval status ='Teos gelesen ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       else;
             eval status ='Teos fehlt   ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
       endif;
       unlock teos01;
       close teos01;
       endsr;
       //-----------------------------------------------------------------------
       //update       hier
       //-----------------------------------------------------------------------

       begsr sr_update;

       //         ==> status kl.Einheit

             eval status ='update TEOS in progressing                      ';
             exsr      SR_log;
       //teos01
       //class 1 duales System
       open teos01;
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4000';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
          teos_o         = teos_i;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c1 = 'J' or
             p_c1 = 'N';
             teos_o.TEOSMM01 = p_c1;

             z               =       p_c1paper ;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             z               =       p_c1plasti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             update teos1      teos_o;
             eval status ='Teos update ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       else;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c1 = 'J' or
             p_c1 = 'N';
             teos_o.TEOSFIRM = '01';
             teos_o.TEOSKLCD = '4000';
             teos_o.TEOSTENR = p_item;
             teos_o.TEOSMM01 = p_c1;

             z               =       p_c1paper ;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             z               =       p_c1plasti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             write  teos1      teos_o;
             eval status ='Teos write ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       endif;


       //class 2 elektro G
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4010';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
          teos_o         = teos_i;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c2 = 'J' or
             p_c2 = 'N';
             teos_o.TEOSMM01 = p_c2;

             z               =       p_c2weight;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             teos_o.TEOSMM03 = p_c2categ;
             teos_o.TEOSMM04 = p_c2group;
             update teos1      teos_o;
             eval status ='Teos update ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       else;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c2 = 'J' or
             p_c2 = 'N';
             teos_o.TEOSFIRM = '01';
             teos_o.TEOSKLCD = '4010';
             teos_o.TEOSTENR = p_item;
             teos_o.TEOSMM01 = p_c2;

             z               =       p_c2weight;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             teos_o.TEOSMM03 = p_c2categ;
             teos_o.TEOSMM04 = p_c2group;
             write  teos1      teos_o;
             eval status ='Teos write ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       endif;


       //class 3 GRS Batterie V
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4020';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
          teos_o         = teos_i;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c3 = 'J' or
             p_c3 = 'N';
             teos_o.TEOSMM01 = p_c3;
             teos_o.TEOSMM02 = p_c3typ;

             z               =       p_c3quanti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             z               =       p_c3weight;
             teos_o.TEOSMM04 = (%char(z));
             evalr teos_o.TEOSMM04   = %trimR(teos_o.TEOSMM04);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);

             update teos1      teos_o;
             eval status ='Teos update ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       else;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c3 = 'J' or
             p_c3 = 'N';
             teos_o.TEOSFIRM = '01';
             teos_o.TEOSKLCD = '4020';
             teos_o.TEOSTENR = p_item;
             teos_o.TEOSMM01 = p_c3;
             teos_o.TEOSMM02 = p_c3typ;

             z               =       p_c3quanti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             z               =       p_c3weight;
             teos_o.TEOSMM04 = (%char(z));
             evalr teos_o.TEOSMM04   = %trimR(teos_o.TEOSMM04);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);

             write  teos1      teos_o;
             eval status ='Teos write ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       endif;


       //class 4 transport
       teos_k.TEOSFIRM = '01';
       teos_k.TEOSKLCD = '4030';
       teos_k.TEOSTENR = p_item;
       chain %kds(teos_k:3) teos01 teos_I;
       if %found(teos01);
          teos_o         = teos_i;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c4 = 'J' or
             p_c4 = 'N';
             teos_o.TEOSMM01 = p_c4;

             z               =       p_c4paper ;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             z               =       p_c4plasti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             z               =       p_c4wood  ;
             teos_o.TEOSMM04 = (%char(z));
             evalr teos_o.TEOSMM04   = %trimR(teos_o.TEOSMM04);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);

             update teos1      teos_o;
             eval status ='Teos update ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       else;
          teos_o.teosJNAM= §§§job;
          teos_o.teosJDAT= %dec(%char(%date():*iso0):8:0);
          teos_o.teosJZEI= %dec(%char(%time():*iso0):6:0);
          teos_o.teosUSER= §§§usr;
          teos_o.teosPROG= §§§pgm;
          if p_c4 = 'J' or
             p_c4 = 'N';
             teos_o.TEOSFIRM = '01';
             teos_o.TEOSKLCD = '4030';
             teos_o.TEOSTENR = p_item;
             teos_o.TEOSMM01 = p_c4;

             z               =       p_c4paper ;
             teos_o.TEOSMM02 = (%char(z));
             evalr teos_o.TEOSMM02   = %trimR(teos_o.TEOSMM02);
             teos_o.TEOSMM02   = %xlate(' ':'0': teos_o.TEOSMM02);

             z               =       p_c4plasti;
             teos_o.TEOSMM03 = (%char(z));
             evalr teos_o.TEOSMM03   = %trimR(teos_o.TEOSMM03);
             teos_o.TEOSMM03   = %xlate(' ':'0': teos_o.TEOSMM03);

             z               =       p_c4wood  ;
             teos_o.TEOSMM04 = (%char(z));
             evalr teos_o.TEOSMM04   = %trimR(teos_o.TEOSMM04);
             teos_o.TEOSMM04   = %xlate(' ':'0': teos_o.TEOSMM04);

             write  teos1      teos_o;
             eval status ='Teos write ' + teos_o.TEOSTENR + teos_o.TEOSKLCD;
             exsr      SR_log;
          endif;
       endif;

       close teos01;
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
