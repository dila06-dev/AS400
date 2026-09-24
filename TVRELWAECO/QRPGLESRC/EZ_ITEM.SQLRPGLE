
      //************************************************************************
      //
      //      Programmname       ET_item
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       Items  Österreich updates
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //************************************************************************
      // Übersetzungshinweise:
      //
      //
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
     h dftactgrp(*NO) actgrp(*CALLER)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     f$teil$$   if   e           k DISK    RENAME($teil01:log01R)
     f                                     usropn
     f
     f$teew$$   if   e           k DISK    RENAME($teew01:log02R)
     f                                     usropn
     f
     f$tebb$$   if   e           k DISK    RENAME($tebb01:log03R)
     f                                     usropn
     f
     f$teuf$$   if   e           k DISK    RENAME($teuf01:log04R)
     f                                     usropn
     f
     f$teos$$   if   e           k DISK    RENAME($teos01:log05R)
     f                                     usropn
     f
     f$teal$$   if   e           k DISK    RENAME($teal01:log06R)
     f                                     usropn
     f
     f$tevp$$   if   e           k DISK    RENAME($tevp01:log07R)
     f                                     usropn
     f
     fteil01    uf a e           k DISK
     f
     fteew01    uf a e           k DISK
     f
     ftebb01    uf a e           k DISK
     f
     fteuf01    uf a e           k DISK
     f
     fteos01    uf a e           k DISK
     f
     fteal01    uf a e           k DISK
     f
     ftevp01    uf a e           k DISK
     f

      /eject
      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------

      // System-Datenstruktur

      // dsSystem       sds
      //  aThisProgramm          1     10
      //  aThisWorkStn         244    253
      //  aThisUser            254    263
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
       // qmhsndpm
       // ______________________________________________________________________
     D QMHSNDPM        PR                  ExtPgm('QMHSNDPM')
     D   MessageID                    7A   Const
     D   QualMsgF                    20A   Const
     D   MsgData                    256A   Const
     D   MsgDtaLen                   10I 0 Const
     D   MsgType                     10A   Const
     D   CallStkEnt                  10A   Const
     D   CallStkCnt                  10I 0 Const
     D   MessageKey                   4A
     D   ErrorCode                    1A

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
       // deliverya genereiren der itemserv (wird im Call bereits initialisiert)
       // ______________________________________________________________________
     D DELIVERYRA      PR                  ExtPgm('DELIVERYRA')
     D p_customer                    10a

       //           TEIL
     d teil_k        E DS                  ExtName(teil01:*key)
     d                                     Qualified

     d teil_i        E DS                  ExtName(teil01:*input)
     d                                     Qualified

     d teil_o20      E DS                  ExtName(teil01:*output)
     d                                     Qualified

     d $teil$$_k     E DS                  ExtName($teil$$:*key)
     d                                     Qualified

     d $teil$$_i     E DS                  ExtName($teil$$:*input)
     d                                     Qualified

       //           TEEW
     d teew_k        E DS                  ExtName(teew01:*key)
     d                                     Qualified

     d teew_i        E DS                  ExtName(teew01:*input)
     d                                     Qualified

     d teew_o20      E DS                  ExtName(teew01:*output)
     d                                     Qualified

     d $teew$$_k     E DS                  ExtName($teew$$:*key)
     d                                     Qualified

     d $teew$$_i     E DS                  ExtName($teew$$:*input)
     d                                     Qualified

       //           TEBB
     d tebb_k        E DS                  ExtName(tebb01:*key)
     d                                     Qualified

     d tebb_i        E DS                  ExtName(tebb01:*input)
     d                                     Qualified

     d tebb_o20      E DS                  ExtName(tebb01:*output)
     d                                     Qualified

     d $tebb$$_k     E DS                  ExtName($tebb$$:*key)
     d                                     Qualified

     d $tebb$$_i     E DS                  ExtName($tebb$$:*input)
     d                                     Qualified

       //           TEUF
     d teuf_k        E DS                  ExtName(teuf01:*key)
     d                                     Qualified

     d teuf_i        E DS                  ExtName(teuf01:*input)
     d                                     Qualified

     d teuf_o20      E DS                  ExtName(teuf01:*output)
     d                                     Qualified

     d $teuf$$_k     E DS                  ExtName($teuf$$:*key)
     d                                     Qualified

     d $teuf$$_i     E DS                  ExtName($teuf$$:*input)
     d                                     Qualified

       //           TEOS
     d teos_k        E DS                  ExtName(teos01:*key)
     d                                     Qualified

     d teos_i        E DS                  ExtName(teos01:*input)
     d                                     Qualified

     d teos_o20      E DS                  ExtName(teos01:*output)
     d                                     Qualified

     d $teos$$_k     E DS                  ExtName($teos$$:*key)
     d                                     Qualified

     d $teos$$_i     E DS                  ExtName($teos$$:*input)
     d                                     Qualified

       //           TEAL
     d teal_k        E DS                  ExtName(teal01:*key)
     d                                     Qualified

     d teal_i        E DS                  ExtName(teal01:*input)
     d                                     Qualified

     d teal_o20      E DS                  ExtName(teal01:*output)
     d                                     Qualified

     d $teal$$_k     E DS                  ExtName($teal$$:*key)
     d                                     Qualified

     d $teal$$_i     E DS                  ExtName($teal$$:*input)
     d                                     Qualified


       //           TEVP
     d tevp_k        E DS                  ExtName(tevp01:*key)
     d                                     Qualified

     d tevp_i        E DS                  ExtName(tevp01:*input)
     d                                     Qualified

     d tevp_o20      E DS                  ExtName(tevp01:*output)
     d                                     Qualified

     d $tevp$$_k     E DS                  ExtName($tevp$$:*key)
     d                                     Qualified

     d $tevp$$_i     E DS                  ExtName($tevp$$:*input)
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

     D p_customer      s             10a   inz

      // qmhsndpm
      // ______________________________________________________________________
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz



      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D err_msg         s              1a   inz
     D #call           s              1a   inz
     D §ICS_2          s             12s 4 inz
     D §tetenr         s             15a   inz
     D §records        s              9s 0 inz
     D p_inFIL         s             24a

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0


      // Überschreibungen
      // ______________________________________________________________________
      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='Start EZ_item   EZITEL ermitteln          ';
       exsr      SR_log;

       exsr  srinit;

       err_msg   = '0';
       if err_msg   = '0';

       //________________________________
       //Firma 20 teil
          open $teil$$;
          read $teil$$ $teil$$_i;
          dow not %eof($teil$$);
             teil_k.tefirm  =  '20';
             teil_k.tetenr  =  $teil$$_i.tetenr;
             chain %kds(teil_k:2) teil01 teil_I;
             if %found(teil01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             exec sql
                     whenever not found CONTINUE;
             exec sql
                     WHENEVER SQLWARNING CONTINUE;
             exec sql
                     WHENEVER SQLERROR  CONTINUE;
             §ICS_2 = *zero;
             §tetenr= $teil$$_i.tetenr;
             exec sql
                 select ICS_2  into :§ICS_2
                 from itemserv where item = :§tetenr;

             if $teil$$_i.tetenr <>'xxxxxxxx    ';
                clear              teil_o20;
       //      Originale, nicht verändern bzw. Korrektur auf Standard
                if #call = 'W';
       //          $teil$$_i.TELFNR  = '000999    ';
                   clear  $teil$$_i.TELFNR;
                   $teil$$_i.TESTLF  = '000999    ';
       //          if $teil$$_i.TEPRGR  = '349';
       //             $teil$$_i.TELFNR  = '330266    ';
       //             $teil$$_i.TESTLF  = '330266    ';
       //          endif;
                   $teil$$_i.TELANR  = 'A01';
                   $teil$$_i.TEWBKT  = '845000    ';
                   $teil$$_i.TEINHP  = *blank;
                   $teil$$_i.TEGNPA  = *blank;
                   $teil$$_i.TETART  = '2';
                   $teil$$_i.TEWEMT  = '0';
                   $teil$$_i.TEBESL  = '1';
                   $teil$$_i.TEPRGR  = *blank;
       //         14.11.2015 der stk ist der lp1 bzw. ics aus Gruppe 173
       //         Hause 13.11.2015
                   $teil$$_i.TESTPR  = §ICS_2;
                else;
                   $teil$$_i.TELFNR  = TEIL_I.TELFNR;
                   $teil$$_i.TESTLF  = TEIL_I.TESTLF;
                   $teil$$_i.TELANR  = TEIL_I.TELANR;
       //          if $teil$$_i.TEPRGR  = '349';
       //             $teil$$_i.TELFNR  = '330266    ';
       //             $teil$$_i.TESTLF  = '330266    ';
       //          endif;
                   $teil$$_i.TEWBKT  = TEIL_I.TEWBKT;
                   $teil$$_i.TEINHP  = TEIL_I.TEINHP;
                   $teil$$_i.TEGNPA  = TEIL_I.TEGNPA;
                   $teil$$_i.TETART  = TEIL_I.TETART;
                   $teil$$_i.TEWEMT  = TEIL_I.TEWEMT;
                   $teil$$_i.TEBESL  = TEIL_I.TEBESL;
                   $teil$$_i.TEPRGR  = TEIL_I.TEPRGR;
       //         14.11.2015 der stk ist der lp1 bzw. ics aus Gruppe 173
       //         Hause 13.11.2015
                   $teil$$_i.TESTPR  = §ICS_2;
                endif;
                teil_o20         =  $teil$$_i;
                teil_o20.tefirm  = '20';
                if       teil_o20 =  teil_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       teil_o20.TEJNAM  = §§§job;
       //       teil_o20.TEJDAT  = %dec(%char(%date():*iso0):8:0);
       //       teil_o20.TEJZEI  = %dec(%char(%time():*iso0):6:0);
       //       teil_o20.TEUSER  = §§§usr;
       //       teil_o20.TEPROG  = §§§pgm;
                monitor;
                   if #call = 'W';
                      write  teil1      teil_o20;
                      eval status ='Teil write ' + teil_o20.tetenr;
                      exsr      SR_log;
                   else;
                      if #call = 'U';
                         update teil1      teil_o20;
                         eval status ='Teil update ' + teil_o20.tetenr;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im Teilestamm
             endif;
          read $teil$$ $teil$$_i;
          enddo;
          close $teil$$;

       //________________________________
       //Firma 20 teew
          open $teew$$;
          read $teew$$ $teew$$_i;
          dow not %eof($teew$$);
             teew_k.TEEWFIRM=  '20';
             teew_k.TEEWTENR=  $teew$$_i.TEEWTENR;
             chain %kds(teew_k:2) teew01 teew_I;
             if %found(teew01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $teew$$_i.TEEWTENR <>'xxxxxxxx    ';
                clear               teew_o20;
                teew_o20         =  $teew$$_i;
                teew_o20.TEEWFIRM= '20';
                if       teew_o20 =  teew_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       teew_o20.TEEWJNAM= §§§job;
       //       teew_o20.TEEWJDAT= %dec(%char(%date():*iso0):8:0);
       //       teew_o20.TEEWJZEI= %dec(%char(%time():*iso0):6:0);
       //       teew_o20.TEEWUSER= §§§usr;
       //       teew_o20.TEEWPROG= §§§pgm;
                monitor;
                   if #call = 'W';
                      write  teew1      teew_o20;
                      eval status ='Teew write ' + teew_o20.TEEWTENR;
                      exsr      SR_log;
                   else;
                      if #call = 'U';
                         update teew1      teew_o20;
                         eval status ='Teew update ' + teew_o20.TEEWTENR;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im teew stamm
             endif;
          read $teew$$ $teew$$_i;
          enddo;
          close $teew$$;

       //________________________________
       //Firma 20 tebb
          open $tebb$$;
          read $tebb$$ $tebb$$_i;
          dow not %eof($tebb$$);
             tebb_k.tebbFIRM=  '20';
             tebb_k.tebbTENR=  $tebb$$_i.tebbTENR;
             tebb_k.tebbAENR=  $tebb$$_i.tebbAENR;
             tebb_k.tebbABTL=  $tebb$$_i.tebbABTL;
             chain %kds(tebb_k:4) tebb01 tebb_I;
             if %found(tebb01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $tebb$$_i.tebbTENR <>'xxxxxxxx    ';
                clear               tebb_o20;
                tebb_o20         =  $tebb$$_i;
                tebb_o20.tebbFIRM= '20';
                if       tebb_o20 =  tebb_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
                if       ( tebb_o20.TEBBABTL = 'AV1' or
                           tebb_o20.TEBBABTL = 'EK1' or
                           tebb_o20.TEBBABTL = 'VKM') and
                         #call = 'W';
       //               Ausnahmen, die nicht generiert werden
                         #call = *blank;
                endif;
       //       tebb_o20.tebbJNAM= §§§job;
       //       tebb_o20.tebbJDAT= %dec(%char(%date():*iso0):8:0);
       //       tebb_o20.tebbJZEI= %dec(%char(%time():*iso0):6:0);
       //       tebb_o20.tebbUSER= §§§usr;
       //       tebb_o20.tebbPROG= §§§pgm;
                monitor;
                   if #call = 'W';
                      write  tebb1      tebb_o20;
                      eval status ='Tebb write ' + tebb_o20.TEbbTENR;
                      exsr      SR_log;
                   else;
                      if #call = 'U';
                         update tebb1      tebb_o20;
                         eval status ='Tebb update ' + tebb_o20.TEbbTENR
                                         + ' ' + %char(tebb_o20.tebbAENR)
                                               + ' ' + tebb_o20.tebbABTL;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im tebb stamm
             endif;
          read $tebb$$ $tebb$$_i;
          enddo;
          close $tebb$$;

       //________________________________
       //Firma 20 teuf
          open $teuf$$;
          read $teuf$$ $teuf$$_i;
          dow not %eof($teuf$$);
             teuf_k.tufirm  =  '20';
             teuf_k.tutenr  =  $teuf$$_i.tutenr;
             teuf_k.tumein  =  $teuf$$_i.tumein;
             chain %kds(teuf_k:3) teuf01 teuf_I;
             if %found(teuf01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $teuf$$_i.tutenr <>'xxxxxxxx    ';
                clear              teuf_o20;
                teuf_o20         =  $teuf$$_i;
                teuf_o20.tufirm  = '20';
                if       teuf_o20 =  teuf_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       teuf_o20.tuJNAM  = §§§job;
       //       teuf_o20.tuJDAT  = %dec(%char(%date():*iso0):8:0);
       //       teuf_o20.tuJZEI  = %dec(%char(%time():*iso0):6:0);
       //       teuf_o20.tuUSER  = §§§usr;
       //       teuf_o20.tuPROG  = §§§pgm;
                monitor;
                   if #call = 'W';
                      write  teuf1      teuf_o20;
                      eval status ='Teuf write ' + teuf_o20.TUTENR;
                      exsr      SR_log;
                   else;
                      if #call = 'U';
                         update teuf1      teuf_o20;
                         eval status ='Teuf update ' + teuf_o20.TUTENR
                                               + ' ' + teuf_o20.tumein;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im teufestamm
             endif;
          read $teuf$$ $teuf$$_i;
          enddo;
          close $teuf$$;

       //________________________________
       //Firma 20 teos
          open $teos$$;
          read $teos$$ $teos$$_i;
          dow not %eof($teos$$);
             teos_k.teosFIRM=  '20';
             teos_k.teosKLCD=  $teos$$_i.teosKLCD;
             teos_k.teosTENR=  $teos$$_i.teosTENR;
             chain %kds(teos_k:3) teos01 teos_I;
             if %found(teos01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $teos$$_i.teosTENR <>'xxxxxxxx    ';
                clear               teos_o20;
                teos_o20         =  $teos$$_i;
                teos_o20.teosFIRM= '20';
                if       teos_o20 =  teos_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       teos_o20.teosJNAM= §§§job;
       //       teos_o20.teosJDAT= %dec(%char(%date():*iso0):8:0);
       //       teos_o20.teosJZEI= %dec(%char(%time():*iso0):6:0);
       //       teos_o20.teosUSER= §§§usr;
       //       teos_o20.teosPROG= §§§pgm;
                monitor;
                   if #call = 'W';
                      write  teos1      teos_o20;
                         eval status ='Teos write ' + teos_o20.TEOSTENR;
                         exsr      SR_log;
                   else;
                      if #call = 'U';
                         update teos1      teos_o20;
                         eval status ='Teos update ' + teos_o20.TEOSTENR;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im teos stamm
             endif;
          read $teos$$ $teos$$_i;
          enddo;
          close $teos$$;


       //________________________________
       //Firma 20 teal
          open $teal$$;
          read $teal$$ $teal$$_i;
          dow not %eof($teal$$);
             teal_k.tlFIRM=  '20';
             teal_k.tlTENR=  $teal$$_i.tlTENR;
             chain %kds(teal_k:2) teal01 teal_I;
             if %found(teal01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $teal$$_i.tlTENR <>'xxxxxxxx    ';
                clear               teal_o20;
                teal_o20         =  $teal$$_i;
                teal_o20.tlFIRM= '20';
                if       teal_o20 =  teal_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       teal_o20.tlJNAM= §§§job;
       //       teal_o20.tlJDAT= %dec(%char(%date():*iso0):8:0);
       //       teal_o20.tlJZEI= %dec(%char(%time():*iso0):6:0);
       //       teal_o20.tlUSER= §§§usr;
       //       teal_o20.tlPROG= §§§pgm;
                monitor;
                   if #call = 'W';
                      write  teal1      teal_o20;
                         eval status ='Teal write ' + teal_o20.tlTENR;
                         exsr      SR_log;
                   else;
                      if #call = 'U';
                         update teal1      teal_o20;
                         eval status ='Teal update ' + Teal_o20.tlTENR;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im teal stamm
             endif;
          read $teal$$ $teal$$_i;
          enddo;
          close $teal$$;


       //________________________________
       //Firma 20 tevp
          open $tevp$$;
          read $tevp$$ $tevp$$_i;
          dow not %eof($tevp$$);
             tevp_k.tevpFIRM=  '20';
             tevp_k.tevpTENR=  $tevp$$_i.tevpTENR;
             chain %kds(tevp_k:2) tevp01 tevp_I;
             if %found(tevp01);
                #call = 'U';
             else;
                #call = 'W';
             endif;

             if $tevp$$_i.tevpTENR <>'xxxxxxxx    ';
                clear               tevp_o20;
                tevp_o20         =  $tevp$$_i;
                tevp_o20.tevpFIRM= '20';
                if       tevp_o20 =  tevp_I and
                         #call = 'U';
       //               nur bei Änderungen
                         #call = *blank;
                endif;
       //       tevp_o20.tevpJNAM= §§§job;
       //       tevp_o20.tevpJDAT= %dec(%char(%date():*iso0):8:0);
       //       tevp_o20.tevpJZEI= %dec(%char(%time():*iso0):6:0);
       //       tevp_o20.tevpUSER= §§§usr;
       //       tevp_o20.tevpPROG= §§§pgm;
                monitor;
                   if #call = 'W';
                      write  tevp1      tevp_o20;
                         eval status ='tevp write ' + tevp_o20.tevpTENR;
                         exsr      SR_log;
                   else;
                      if #call = 'U';
                         update tevp1      tevp_o20;
                         eval status ='tevp update ' + tevp_o20.tevpTENR;
                         exsr      SR_log;
                      endif;
                   endif;
                   on-error;
       //         file: QCPFMSG
                   select;
                   when §§§MSG = 'MCH1210';
                   other;
                   endsl;
                endmon;
             else;
       //   fehlt im tevp stamm
             endif;
          read $tevp$$ $tevp$$_i;
          enddo;
          close $tevp$$;

       endif;

       // report
       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(tvrelwaeco/EZ_item)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(tvrelwaeco/EZ_item)       ';
       on-error;
          status='Error by clrpfm object (tvrelwaeco/EZ_item)      ';
       endmon;

       exec sql
         insert into tvrelwaeco/EZ_item
         SELECT char ('Artikelanlage', 15) Meldung,
                substr(jobdesc, 32, 15) , TETBZ1, CTSTAMP FROM
         job_run, teil01
         WHERE ctstamp > current timestamp -01 hour  and
               PGM ='EZ_ITEM' and JOBDESC like '%Teil write%' and
               substr(jobdesc, 32, 15) = tetenr and tefirm = '20';

       §records=*zero;
       exec sql
         select count(*) into :§records
                FROM   tvrelwaeco/EZ_item ;

       if §records <> *zero;
          exsr SR_output;
       endif;

       // ______________________________________________________________________

       eval status ='Ende EZ_items  EZITEL ermitteln         ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei KPIF
       //-----------------------------------------------------------------------

       begsr srinit;

       err_msg   = '1';

       mydate = %date();
       days   = %subdt( %date(): *days );
       months = %subdt( %date(): *months );
       years  = %subdt( %date(): *years );
       eofyear= years*10000+12*100+31;

       exec sql
         delete from itemserv;

       //Ezitel Kunde
       p_customer = '098848';
       if p_customer = '098848';
           callP DELIVERYRA(p_customer);
       endif;

       exec sql
       //delete  FROM itemserv WHERE prodgroup= 'x_x';
         delete  from itemserv WHERE item in
                 ( select tetenr from teil01
                          where tefirm='01' and tengkz <>'E');

       //           TEIL
       exec sql
         delete from tvrelwaeco/$TEIL01;

       exec sql
         insert into tvrelwaeco/$TEIL01
         SELECT * FROM teil01 WHERE TEFIRM ='01' and
                  tetenr in (select item from itemserv);

       exec sql
         create index  $teil$$  on   $TEIL01
         (tefirm, tetenr);

       //           TEEW
       exec sql
         delete from tvrelwaeco/$TEEW01;

       exec sql
         insert into tvrelwaeco/$TEEW01
         SELECT * FROM TEEW01 WHERE  TEEWFIRM ='01' and
                  TEEWTENR in (select item from itemserv);

       exec sql
         create index  $teew$$  on   $TEEW01
         (TEEWFIRM, TEEWTENR);

       //           TEBB
       exec sql
         delete from tvrelwaeco/$TEBB01;

       exec sql
         insert into tvrelwaeco/$TEBB01
         SELECT * FROM TEBB01 WHERE  TEBBFIRM ='01' and
                  TEBBTENR in (select item from itemserv);

       exec sql
         create index  $tebb$$  on   $TEBB01
         (TEBBFIRM, TEBBTENR, TEBBAENR, TEBBABTL);

       //           TEUF
       exec sql
         delete from tvrelwaeco/$TEUF01;

       exec sql
         insert into tvrelwaeco/$TEUF01
         SELECT * FROM TEUF01 WHERE  TUFIRM   ='01' and
                  TUTENR  in (select item from itemserv);

       exec sql
         create index  $teuf$$  on   $TEuf01
         (TUFIRM, TUTENR, TUMEIN);

       //           TEOS
       exec sql
         delete from tvrelwaeco/$TEOS01;

       exec sql
         insert into tvrelwaeco/$TEOS01
         SELECT * FROM TEOS01 WHERE  TEOSFIRM   ='01' and
                  TEOSTENR  in (select item from itemserv);

       exec sql
         create index  $teos$$  on   $TEos01
         (TEOSFIRM, TEOSKLCD, TEOSTENR);

       //           TEAL
       exec sql
         delete from tvrelwaeco/$TEAL01;

       exec sql
         insert into tvrelwaeco/$TEAL01
         SELECT * FROM TEAL01 WHERE  TLFIRM ='01' and
                  TLTENR in (select item from itemserv);

       exec sql
         create index  $teAL$$  on   $TEAL01
         (TLFIRM, TLTENR);
       err_msg   = '0';

       //           TEVP
       exec sql
         delete from tvrelwaeco/$TEVP01;

       exec sql
         insert into tvrelwaeco/$TEVP01
         SELECT * FROM TEVP01 WHERE  tevpFIRM ='01' and
                tevpTENR in (select item from itemserv);

       exec sql
         create index  $teVP$$  on   $TEVP01
         (tevpFIRM, tevpTENR);
       err_msg   = '0';

       //sql handling
         exec sql
                  whenever not found goto endsr;
         exec sql
                  WHENEVER SQLWARNING goto endsr;
         exec sql
                  WHENEVER SQLERROR  goto endsr;

       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'EZ_ITEM'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'AVAILABLE';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/LAGER/EZ_ITEM*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed EZ_ITEM*               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object EZ_ITEM*                  ';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'EZ_ITEM  ';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/LAGER/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object EZ_ITEM                   ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'EZ_ITEM  ';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/ez_item)       ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/ez_item)      ';
       endmon;


       //...
       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) '  +
           'TOFILE(*LIBL/QPQXPRTF) DEV(PRT55) '  +
           'FORMTYPE(''EZ_ITEM'') OVRSCOPE(*JOB)';
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
       eval p_outfil  =  'EZ_ITEM  ';

       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
           ''' '' '' '' '' '')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by DUMMY512                        ';
          exsr      SR_log;
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


