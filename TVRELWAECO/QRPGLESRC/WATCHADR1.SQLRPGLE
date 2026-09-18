
      //************************************************************************
      //
      //      Programmname       ....
      //      Erstellt  am       ....
      //      Erstellt von       Dometic Waeco
      //
      */      Beschreibung
      //
      // update fadr01 b set b.ADR0_LAND =
      // (select a.ADR0_LAND from #fadr01 a where
      // (substr(Char(tstamp), 1, 13)= '2017-07-21-05' or
      //  substr(Char(tstamp), 1, 13)= '2017-07-21-06')  and
      //      a.ADR0_FIRMA = b.ADR0_FIRMA and
      //      a.ADR0_ADRNR = b.ADR0_ADRNR and
      //            b.ADR0_LAND  <> 'DE' )
      // where exists
      // (select a.ADR0_LAND from #fadr01 a where
      // (substr(Char(tstamp), 1, 13)= '2017-07-21-05' or
      //  substr(Char(tstamp), 1, 13)= '2017-07-21-06')  and
      //      a.ADR0_FIRMA = b.ADR0_FIRMA and
      //      a.ADR0_ADRNR = b.ADR0_ADRNR and
      //            b.ADR0_LAND  <> 'DE' )
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

     fkund01    if   e           k DISK

      // ...
     ffadr01    uf   e           k disk    RENAME(ADSATZ:PHY01R)
      //                                   prefix('$')
      // ...
     f#fadr01   uf a e           k disk    RENAME(#fadr01:PHY02R)
      //                                   prefix('$')

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

       // ______________________________________________________________________
       //           Abgleich
     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
     d                                     Qualified

     d fadr01_k      E DS                  ExtName(fadr01:*key)
     d                                     Qualified
     d fadr01_i      E DS                  ExtName(fadr01:*input)
     d                                     Qualified
     d fadr01_o      E DS                  ExtName(fadr01:*output)
     d                                     Qualified
     d #fadr01_i     E DS                  ExtName(#fadr01:*input)
     d                                     Qualified
     d #fadr01_o     E DS                  ExtName(#fadr01:*output)
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
     D change          s              1a   inz

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

       eval status ='Start Aufbau für WATCHADR1 eingeleitet    ';
       exsr      SR_log;

       //************************************************************
       //Protokolldaten

          read kund01 kund_i;
          dow not %eof(kund01);
             IF kund_i.kdfirm = '61';
       //       kund_i.kdkdnr = '197979 ';
       //       kund_i.kdkdnr = '001248 ';
             endif;
             IF kund_i.kdfirm = '08'   and
                kund_i.kdkdnr = '6165919';
                kund_i.kdkdnr = '6165919';
             endif;
             if kund_i.KDKDST <> '90';
                select;
                when kund_i.kdfirm = '01';
                     exsr schilling;
                when kund_i.kdfirm = '08'        and
                     kund_i.kdkdnr =  '######';
                     exsr schilling;
                when kund_i.kdfirm = '52'        and
                     kund_i.kdkdnr =  '######';
                     exsr schilling;
                when kund_i.kdfirm = '55';
                     exsr schilling;
                when kund_i.kdfirm = '61'        and
                     kund_i.kdkdnr =  '######';
                     exsr schilling;
                other;
       //            crmoutput_o.ENTITY     = 'ERROR';
                endsl;
             endif;
             read kund01 kund_i;
          enddo;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //break and restart reaction cases
       //-----------------------------------------------------------------------

       begsr schilling;

          fadr01_k.ADADNR       = '100000000';
          fadr01_k.ADKTKR       = '1';
          select;
          when kund_i.kdfirm = '01';
               fadr01_k.ADFA     =   51;
               %subst(fadr01_k.ADADNR:2:6)  = %subst(kund_i.KDKDNR:1:6);
          when kund_i.kdfirm = '08';
               fadr01_k.ADFA     =   08;
               %subst(fadr01_k.ADADNR:2:7)  = %subst(kund_i.KDKDNR:1:7);
          when kund_i.kdfirm = '52';
               fadr01_k.ADFA     =   52;
               %subst(fadr01_k.ADADNR:2:7)  = %subst(kund_i.KDKDNR:1:7);
          when kund_i.kdfirm = '55';
               fadr01_k.ADFA     =   55;
               %subst(fadr01_k.ADADNR:2:5)  = %subst(kund_i.KDKDNR:1:5);
          when kund_i.kdfirm = '61';
               fadr01_k.ADFA     =   61;
               %subst(fadr01_k.ADADNR:2:6)  = %subst(kund_i.KDKDNR:1:6);
          other;
               fadr01_k.ADFA    =   *zero;
          endsl;

          change = '0';
          chain %kds(fadr01_k:3) fadr01  fadr01_I;
          if %found(fadr01);
             if fadr01_i.ADNAM1                <> kund_i.kdnam1 or
                fadr01_i.ADNAM2                <> kund_i.kdnam2 or
                fadr01_i.ADNAM3                <> kund_i.kdnam3 or
                fadr01_i.ADSTR                 <> kund_i.kdstra or
                fadr01_i.ADTEL                 <> kund_i.kdtlnr or
       // *no!! fadr01_i.ADLAND                <> kund_i.kdpold or
                fadr01_i.ADPF                  <> kund_i.kdpofa or
                fadr01_i.ADADSU                <> kund_i.KDMCBG or
                fadr01_i.ADFAX                 <> kund_i.kdtfnr;
                change = '1';
             endif;
             if  kund_i.kdpold = 'GB ' and
                (%subst(fadr01_i.ADPLOR: 1: 7)  <> kund_i.kdpolz or
                 %subst(fadr01_i.ADPLOR: 8: 30) <> kund_i.KDWORT);
                change = '1';
             endif;
             if  kund_i.kdpold = 'NL ' and
                (%subst(fadr01_i.ADPLOR: 1: 8)  <> kund_i.kdpolz or
                 %subst(fadr01_i.ADPLOR: 9: 30) <> kund_i.KDWORT);
                change = '1';
             endif;
             if  kund_i.kdpold <> 'GB ' and kund_i.kdpold <> 'NL ' and
                (%subst(fadr01_i.ADPLOR: 1: 6)  <> kund_i.kdpolz or
                 %subst(fadr01_i.ADPLOR: 7: 30) <> kund_i.KDWORT);
                change = '1';
             endif;
             if  kund_i.kdpold =  'DE ' and
       //        %subst(kund_i.KDKDNR:1:6) = '001039' and
                (%subst(fadr01_i.ADPLOR: 1: 6)  <> kund_i.kdpolz or
                 %subst(fadr01_i.ADPLOR: 7: 30) <> kund_i.KDWORT);
                change = '1';
             endif;

             if change = '1';
       //      Protokollierung Altsatz
                clear  #fadr01_o;
                #fadr01_o = fadr01_i;
                #fadr01_o.tstamp = %timestamp();
                write  phy02R #fadr01_o;

                fadr01_i.ADNAM1                =  kund_i.kdnam1;
                fadr01_i.ADNAM2                =  kund_i.kdnam2;
                fadr01_i.ADNAM3                =  kund_i.kdnam3;
                fadr01_i.ADSTR                 =  kund_i.kdstra;
                fadr01_i.ADTEL                 =  kund_i.kdtlnr;
       // *no ! fadr01_i.ADLAND                =  kund_i.kdpold;
                fadr01_i.ADPF                  =  kund_i.kdpofa;
                if  kund_i.kdpold = 'GB ';
                   %subst(fadr01_i.ADPLOR: 1: 7)  =  kund_i.kdpolz;
                   %subst(fadr01_i.ADPLOR: 8: 30) =  kund_i.KDWORT;
                endif;
                if  kund_i.kdpold = 'NL ';
                   %subst(fadr01_i.ADPLOR: 1: 8)  =  kund_i.kdpolz;
                   %subst(fadr01_i.ADPLOR: 9: 30) =  kund_i.KDWORT;
                endif;
                if  kund_i.kdpold <> 'GB ' and kund_i.kdpold <> 'NL ' and
                   %subst(fadr01_i.ADPLOR: 1: 6)  =  kund_i.kdpolz;
                   %subst(fadr01_i.ADPLOR: 7: 30) =  kund_i.KDWORT;
                endif;
                if  kund_i.kdpold =  'DE ';
       //          %subst(kund_i.KDKDNR:1:6) = '001039';
                   %subst(fadr01_i.ADPLOR: 1: 6)  =  kund_i.kdpolz;
                   %subst(fadr01_i.ADPLOR: 7: 30) =  kund_i.KDWORT;
                endif;

                fadr01_i.ADADSU                =  kund_i.KDMCBG;
                fadr01_i.ADFAX                 =  kund_i.kdtfnr;

                fadr01_i.ADAEUS      =        §§§USR;
                fadr01_i.ADAEJT      =        %char(%date():*iso0);
                fadr01_i.ADAETM      =        %char(%time():*iso0) + '00';
                fadr01_o   = fadr01_i;
       //       if  §§§USR = '    ';
                   update phy01R   fadr01_o;
                   eval status =*blank;
                   eval status =kund_i.KDKDNR           + ' ' +
                                %TrimR(fadr01_i.ADNAM1) + ' ' +
                                %TrimR(fadr01_i.ADNAM2) + ' ' +
                                %TrimR(fadr01_i.ADNAM3) + ' ' +
                                %TrimR(fadr01_i.ADSTR ) + ' ' +
                                %TrimR(fadr01_i.ADTEL ) + ' ' +
                                %TrimR(fadr01_i.ADLAND) + ' ' +
                                %TrimR(fadr01_i.ADPF)   + ' ' +
                                %TrimR(%subst(fadr01_i.ADPLOR: 1: 6)) + ' ' +
                                %TrimR(%subst(fadr01_i.ADPLOR: 7: 20));
                   exsr      SR_log;
       //       endif;
             endif;
             unlock      fadr01;
          else;
       //    crmoutput_o.CCLINE   =  *zero;
             unlock      fadr01;
          endif;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr #protokoll;

       exec sql
         insert into tvrelwaeco/#FADR01
         SELECT ADR0_STAT, ADR0_LOCKSTAT, ADR0_FIRMA, ADR0_ADRNR,
         ADR0_KTOKRS, ADR0_ANREDE, ADR0_NAME1, ADR0_NAME2, ADR0_NAME3,
         ADR0_POSTFACH, ADR0_POSTFACHPLZ, ADR0_STRASSE, ADR0_PLZORT,
         ADR0_LAND, ADR0_PLZ, ADR0_SPRACHE, ADR0_MATCH, ADR0_MATCH2,
         ADR0_TELEFON, ADR0_TELEX, ADR0_TELEFAX, ADR0_BTX, ADR0_INTERNET,
         ADR0_EMAILNR0001, ADR0_EMAILNR0002, ADR0_ADRTITEL, ADR0_AENDUSER,
         ADR0_AENDWSID, ADR0_AENDJJMT, ADR0_AENDTIME, ADR0_AENDART,
         ADR0_EMAILKZ, ADR0_VARFELD0001, ADR0_VARFELD0002, ADR0_VARFELD0003,
         ADR0_VARFELD0004, ADR0_VARFELD0005, ADFIL1 , current timestamp
         tstamp FROM fadr01 WHERE ADR0_FIRMA ='55' and ADR0_KTOKRS ='1' and
         ADR0_ADRNR ='118777000';

       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'WATCHADR_'        +
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
           'RMVLNK OBJLNK(''/Lager/Rhenania/WATCHADR_*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/WATCHADR_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/WATCHADR_*';
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
