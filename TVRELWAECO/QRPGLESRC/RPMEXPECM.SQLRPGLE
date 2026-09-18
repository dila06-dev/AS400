
      //************************************************************************
      //
      //      Programmname       AT_PREIS
      //      Erstellt  am       02.11.2015
      //      Erstellt von       M.Gang
      //
      //      Beschreibung       ---
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

     fafkn01    if   e           k DISK
     f                                     RENAME(afkn1:PHY01R)
     fafko01    if   e           k DISK

     fafpo07    if   e           k DISK

     fwaeh01    if   e           k DISK

     fkdew01    if   e           k DISK

     ftrtp00    if   e           k DISK

     fPANfpos2  if   e             disk

     fPANfpos   if   e             disk    RENAME(PANFPOSF:LOG02R)

     fpsaveap   if   e             disk    RENAME(PANFPOSF:LOG03R)

     flbap01    if   e           k DISK

     fafpo01    if   e           k DISK    RENAME(AFPO1:LOG01R)

     faflp01    if   e           k DISK

     fpanfkopl2 if   e           k disk

     fPSAVEAK2L2if   e           k disk    RENAME(PANFKOPF:LOG05R)

     fRPMEXPECM0o  a e             disk    RENAME(RPMSALESR:PHY02R)


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


     d afkn_k        E DS                  ExtName(afkn01:*key)
     d                                     Qualified

     d afkn_i        E DS                  ExtName(afkn01:*input)
     d                                     Qualified

     d afko_k        E DS                  ExtName(afko01:*key)
     d                                     Qualified

     d afko_i        E DS                  ExtName(afko01:*input)
     d                                     Qualified

     d afpo_k        E DS                  ExtName(afpo07:*key)
     d                                     Qualified

     d afpo_i        E DS                  ExtName(afpo07:*input)
     d                                     Qualified

     d waeh_k        E DS                  ExtName(waeh01:*key)
     d                                     Qualified

     d waeh_i        E DS                  ExtName(waeh01:*input)
     d                                     Qualified

     d kdew_k        E DS                  ExtName(kdew01:*key)
     d                                     Qualified

     d kdew_i        E DS                  ExtName(kdew01:*input)
     d                                     Qualified

     d trtp_k        E DS                  ExtName(trtp00:*key)
     d                                     Qualified

     d trtp_i        E DS                  ExtName(trtp00:*input)
     d                                     Qualified

     d Panf01_k      E DS                  ExtName(PANfpos2 :*Key)
     d                                     Qualified

     d Panf01_I      E DS                  ExtName(PANfpos2 :*input)
     d                                     Qualified

     d lbap_k        E DS                  ExtName(lbap01:*key)
     d                                     Qualified

     d lbap_i        E DS                  ExtName(lbap01:*input)
     d                                     Qualified

     d afpo01_k      E DS                  ExtName(afpo01:*key)
     d                                     Qualified

     d afpo01_i      E DS                  ExtName(afpo01:*input)
     d                                     Qualified

     d Panf01__k     E DS                  ExtName(PANfpos:*Key)
     d                                     Qualified

     d Panf01__I     E DS                  ExtName(PANfpos:*input)
     d                                     Qualified

     d PSaveAP__k    E DS                  ExtName(PSaveAP:*Key)
     d                                     Qualified

     d PSaveAP__I    E DS                  ExtName(PSaveAP:*input)
     d                                     Qualified

     d aflp_k        E DS                  ExtName(aflp01:*key)
     d                                     Qualified

     d aflp_i        E DS                  ExtName(aflp01:*input)
     d                                     Qualified

     d Pankop_k      E DS                  ExtName(panfkopl2:*Key)
     d                                     Qualified

     d Pankop_I      E DS                  ExtName(panfkopl2:*input)
     d                                     Qualified

     d Pankops_k     E DS                  ExtName(PSAVEAK2L2:*Key)
     d                                     Qualified

     d Pankops_I     E DS                  ExtName(PSAVEAK2L2:*input)
     d                                     Qualified

     d RPMEXPECM0_o  E DS                  ExtName(RPMEXPECM0:*output)
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
     D ##error         s              1a   inz
     D #call           s              1a   inz
     D #openquan       s             13s 4 inz
     D #division       s             10a   inz
     D #expected       s             13s 4 inz
     D #week_i         s             10i 0 inz
     D #week_a         s             11a   inz
     D #DAYOFWE        s             10i 0 inz
     D #DAYOFWEi       s             10i 0 inz
     D #comp           s              2a   inz

     D suffix          s              6A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     d myDate          s               d
     d days            s              2s 0
     d months          s              2s 0
     d years           s              4s 0
     d eofyear         s              8s 0
     D Laenge          s              8s 0 inz
     D zusatzinfo      s             40a   inz

      // Überschreibungen
      // ______________________________________________________________________
     IPANFPOSF
     I              apfirm                      §apfirm
      // ______________________________________________________________________
     ILOG02R
     I              apfirm                      $apfirm
      // ______________________________________________________________________
     ILOG03R
     I              apfirm                      xapfirm
      // ______________________________________________________________________
     IPANFKOPF
     I              akfirm                      §akfirm
      // ______________________________________________________________________
     ILOG05R
     I              akfirm                      $akfirm
      // ______________________________________________________________________

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************


      /FREE
       eval status ='rpm RPMEXPECM expected sales weekly report';
       exsr      SR_log;

       exsr  srinit;

       if err_msg   = '0' and
          #DAYOFWEi  <> 9;
          #comp='01';
          afpo_k.apfirm  =  #comp;
          dow afpo_k.apfirm = #comp;
       //   afpo Positionen                afkn_i.anwtnt
             setll %kds(afpo_k:1) afpo07;
             reade %kds(afpo_k:1) afpo07  afpo_i;
             dow not %eof(afpo07)               and
               afpo_i.apafst < '81';
                  if afpo_i.APAFNR ='642081' and
                     afpo_i.APTENR =  '9600000461' and
                     afpo_i.APTENR =  '9600000461';
                      afpo_i.APAFNR ='642081';
                  endif;
                  if afpo_i.APPRGR < '900';
                    afko_k.akfirm  =  afpo_i.APFIRM;
                    afko_k.akafjj  =  afpo_i.APAFJJ;
                    afko_k.AKAFNR  =  afpo_i.APAFNR;
                    chain %kds(afko_k:3) afko01 afko_I;
                    if %found(afko01) and
                       afko_i.AKAFST < '90';
                       if afpo_i.apafnr ='667705';
                          #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       endif;
                       #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       if afpo_i.APWACD <> 'EUR';
                          waeh_k.WAFIRM  =  afpo_i.apfirm;
                          waeh_k.WASTWC  =  'EUR';
                          waeh_k.WAWACD  =  afpo_i.APWACD;
                          waeh_k.WAGADA  =  (%dec(%char(%date():*iso0):8:0));
                          setgt %kds(WAEH_k:4) WAEH01;
                          readp waeh01  waeh_i;
                          dow not %eof(WAEH01)                  and
                             waeh_i.WAFIRM = afpo_i.apfirm      and
                             waeh_i.WASTWC = 'EUR'              and
                             waeh_i.WAWACD = afpo_i.APWACD;
                             if afpo_i.APBSMG=0;
                                afpo_i.APBSMG=1;
                             endif;
       //                    #expected = (#openquan*afpo_i.APPREI
                             #expected = (afpo_i.apnesu/afpo_i.APBSMG*
                              #openquan *waeh_i.wakurs);
                             leave;
                          enddo;
                       else;
                       if afpo_i.APBSMG=0;
                          afpo_i.APBSMG=1;
                       endif;
                       #expected = (afpo_i.apnesu/afpo_i.APBSMG*
                        #openquan );
                       endif;
       //kdew
                       kdew_k.kdewfirm =  afpo_i.APFIRM;
                       kdew_k.Kdewkdnr =  afpo_i.APRAKD;
                       chain %kds(kdew_k:2) kdew01 kdew_I;
                       if %found(kdew01);
                          select;
                            when kdew_I.KDEWKSST = '1001    ';
                                #division             = 'RVOEM   ';
                            when kdew_I.KDEWKSST = '1002    ';
                                #division             = 'RVAM    ';
                            when kdew_I.KDEWKSST = '1003    ';
                                #division             = 'RETL    ';
                            when kdew_I.KDEWKSST = '1004    ';
                                #division             = 'LODG    ';
                            when kdew_I.KDEWKSST = '1005    ';
                                #division             = 'CPVOEM  ';
                            when kdew_I.KDEWKSST = '1006    ';
                                #division             = 'CPVAM   ';
                            when kdew_I.KDEWKSST = '1007    ';
                                #division             = 'MAOEM   ';
                            when kdew_I.KDEWKSST = '1008    ';
                                #division             = 'MAAM    ';
                            when kdew_I.KDEWKSST = '1009    ';
                                if afpo_i.APFIRM  ='01'
                                or afpo_i.APFIRM  ='55';
                                   #division             = 'MEDI    ';
                                endif;
                                if afpo_i.APFIRM  ='52';
                                   #division             = 'RETL    ';
                                endif;
                                if afpo_i.APFIRM  ='08';
                                   #division             = 'LODG    ';
                                endif;
                            when kdew_I.KDEWKSST = '1015    ';
                                #division             = 'GROUP   ';
                            when kdew_I.KDEWKSST = '1020    ';
                                #division             = 'OTHER   ';
                            when kdew_I.KDEWKSST = '6050    ';
                                #division             = 'OTHER   ';
                            other;
                                #division             = 'ERROR   ';
                          endsl;
                       endif;
                       clear  RPMEXPECM0_o;
                       RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                       RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                       select;
                          when afpo_i.APFIRM  ='01';
                             RPMEXPECM0_o.ENTITY   = 'DE411';
                          when afpo_i.APFIRM  ='08';
                             RPMEXPECM0_o.ENTITY   = 'BE111';
                          when afpo_i.APFIRM  ='52';
                             RPMEXPECM0_o.ENTITY   = 'NL411';
                          when afpo_i.APFIRM  ='55';
                             RPMEXPECM0_o.ENTITY   = 'CH412';
                          when afpo_i.APFIRM  ='61';
                             RPMEXPECM0_o.ENTITY   = 'AT411';
                          other;
                             RPMEXPECM0_o.ENTITY   = '*erro';
                       endsl;
                       RPMEXPECM0_o.ITEM      = afpo_i.APTENR;
                       RPMEXPECM0_o.ITEMDESC  = afpo_i.APTBZ1;
                       RPMEXPECM0_o.APGLMG    = #openquan;
                       RPMEXPECM0_o.wert      = #expected;
                       RPMEXPECM0_o.RKWACD    = afpo_i.APWACD;
                       RPMEXPECM0_o.APPRGR    = *blank;
                       RPMEXPECM0_o.APAFPO    = afpo_i.APAFPO;
                       RPMEXPECM0_o.APAFST    = afpo_i.APAFST;
                       RPMEXPECM0_o.APLFTE    = afpo_i.APLFTE;
       //             ::....
                       RPMEXPECM0_o.PLANKUNDE = %char(afpo_i.APKMTE);
                       RPMEXPECM0_o.APAFAT    = afpo_i.APAFAT;
                       RPMEXPECM0_o.APUSER    = afpo_i.APUSER;
                       RPMEXPECM0_o.APSABE    = afpo_i.APSABE;
                       RPMEXPECM0_o.APSABEi   = *blank;
       //             sabe Inhalt
                       trtp_k.tpfirm  =  afpo_i.APfirm;
                       trtp_k.TPSPCD  =  'D';
                       trtp_k.TPTART  =  'SABE';
                       trtp_k.TPTCDE  =  afpo_i.APSABE;
                       setll %kds(trtp_k:4) trtp00;
                       reade %kds(trtp_k:4) trtp00  trtp_i;
                       dow not %eof(trtp00)                  and
                          trtp_i.tpfirm = afpo_i.APfirm      and
                          trtp_i.TPSPCD = 'D'                and
                          trtp_i.TPTART = 'SABE'             and
                          trtp_i.TPTCDE = afpo_i.APSABE;
                          if trtp_i.TPTTXT <> *blank and
                             RPMEXPECM0_o.APSABEi = *blank;
                             RPMEXPECM0_o.APSABEi = trtp_i.TPTTXT;
                             leave;
                          endif;
                       enddo;
                       RPMEXPECM0_o.DIVISION  = #division;
                       RPMEXPECM0_o.CUSTOMER# = afpo_i.APRAKD;
                       RPMEXPECM0_o.CUSTOMER  = *blank;
                       RPMEXPECM0_o.RPMGROUP  = *blank;
                       RPMEXPECM0_o.AKFIRM    = afpo_i.APFIRM;
                       RPMEXPECM0_o.AKAFJJ    = afpo_i.APAFJJ;
                       RPMEXPECM0_o.AKAFNR    = afpo_i.APAFNR;
                       RPMEXPECM0_o.h1        = 'upload';
                       RPMEXPECM0_o.h2        = %date();
                       RPMEXPECM0_o.h3        = %timestamp();
                       RPMEXPECM0_o.h5        = %date();
                       RPMEXPECM0_o.h6        = %timestamp();
                       write phy02r     RPMEXPECM0_o;
                       clear  #openquan;
                       clear  #division;
                       clear  #expected;
                    endif;
                 endif;
                 reade %kds(afpo_k:1) afpo07 afpo_i;
             enddo;
             if afpo_k.apfirm  =  '61';
                afpo_k.apfirm  =  *blank;
                #comp          =  'xx';
             endif;
             if afpo_k.apfirm  =  '55';
                afpo_k.apfirm  =  '61';
                #comp          =  '61';
             endif;
             if afpo_k.apfirm  =  '52';
                afpo_k.apfirm  =  '55';
                #comp          =  '55';
             endif;
             if afpo_k.apfirm  =  '08';
                afpo_k.apfirm  =  '52';
                #comp          =  '52';
             endif;
             if afpo_k.apfirm  =  '01';
                afpo_k.apfirm  =  '08';
                #comp          =  '08';
             endif;
          enddo;

       //   errors in LFS
          afpo_k.apfirm  =  '01';
          #comp          =  '01';
          Panf01_i.apanr1 = *blank;
          read PANfpos2 Panf01_i;
          dow not %eof(PANfpos2);
       //   afpo Positionen  aus           panfkop2l1     APANR1
            clear  RPMEXPECM0_o;
            lbap_k.LBAPFIRM = %subst(Panf01_i.APANR1: 2: 2);
            lbap_k.LBAPDANA = 'AFKM';
            lbap_k.LBAPJAHR = %dec(%subst(Panf01_i.APANR1: 4: 4):4:0);
            lbap_k.LBAPNMKR = %subst(Panf01_i.APANR1: 8: 6);
            lbap_k.LBAPPOSI = Panf01_i.APANRP;
            chain %kds(lbap_k:5) lbap01 lbap_I;
            if %found(lbap01);
               afpo01_k.ApFIRM = lbap_i.LBAPFIRM;
               afpo01_k.ApAFJJ = lbap_i.LBAPAFJJ;
               afpo01_k.ApAFNR = lbap_i.LBAPAFNR;
               afpo01_k.ApAFPO = lbap_i.LBAPAFPO;
               chain %kds(afpo01_k:4) afpo01 afpo01_I;
               if %found(afpo01);
                  afpo_I = afpo01_I;
                  exsr srerrorlog;
               else;

                  RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                  RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                  RPMEXPECM0_o.ITEM      = Panf01_i.APiden;
                  RPMEXPECM0_o.ITEMDESC  = Panf01_i.APBEM1;
                  RPMEXPECM0_o.CUSTOMER# = Panf01_i.APKDNR;
                  RPMEXPECM0_o.h4    = 'Fehler in Schnittstelle: ' +
                                        Panf01_i.APFCD             +
                                  %char(Panf01_i.APFTXT)           +
                                        Panf01_i.APEFLD;
                  RPMEXPECM0_o.AKFIRM=%subst(Panf01_i.APANR1: 2: 2);
                  RPMEXPECM0_o.AKAFJJ=%dec(%subst(Panf01_i.APANR1: 4: 4):4:0);
                  RPMEXPECM0_o.AKAFNR=%subst(Panf01_i.APANR1: 8: 6);
                  RPMEXPECM0_o.APAFPO=Panf01_i.APANRP;
                  RPMEXPECM0_o.h2        = %date();
                  RPMEXPECM0_o.h3        = %timestamp();
                  RPMEXPECM0_o.h5        = %date();
                  RPMEXPECM0_o.h6        = %timestamp();
       //         write phy02r     RPMEXPECM0_o;
               endif;
            else;
               RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
               RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
               RPMEXPECM0_o.ITEM      = Panf01_i.APiden;
               RPMEXPECM0_o.ITEMDESC  = Panf01_i.APBEM1;
               RPMEXPECM0_o.CUSTOMER# = Panf01_i.APKDNR;
               RPMEXPECM0_o.h4    = 'Fehler in Schnittstelle: ' +
                                     Panf01_i.APFCD             +
                               %char(Panf01_i.APFTXT)           +
                                     Panf01_i.APEFLD;
               RPMEXPECM0_o.AKFIRM=%subst(Panf01_i.APANR1: 2: 2);
               RPMEXPECM0_o.AKAFJJ=%dec(%subst(Panf01_i.APANR1: 4: 4):4:0);
               RPMEXPECM0_o.AKAFNR=%subst(Panf01_i.APANR1: 8: 6);
               RPMEXPECM0_o.APAFPO=Panf01_i.APANRP;
               RPMEXPECM0_o.h2        = %date();
               RPMEXPECM0_o.h3        = %timestamp();
               RPMEXPECM0_o.h5        = %date();
               RPMEXPECM0_o.h6        = %timestamp();
       //      write phy02r     RPMEXPECM0_o;
            endif;
            read PANfpos2 Panf01_i;
          enddo;
       //
       //   noch offen in LFS Datei 1
       //   noch offen in LFS Datei 1
       //
          afpo_k.apfirm  =  '01';
          #comp          =  '01';
          Panf01__i.apanr1 = *blank;
          read PANfpos  Panf01__i;
          dow not %eof(PANfpos);
            ##error = '0';
       //   afpo Positionen  aus  on-error 00102;
            monitor;
                lbap_k.LBAPJAHR = %dec(%subst(Panf01__i.APANR1: 4: 4):4:0);
            on-error;
                ##error = '1';
                // Fehlerbehandlung: String ist nicht numerisch
            endmon;
            if  ##error = '0';
            clear  RPMEXPECM0_o;
            lbap_k.LBAPFIRM = %subst(Panf01__i.APANR1: 2: 2);
            lbap_k.LBAPDANA = 'AFKM';
            lbap_k.LBAPJAHR = %dec(%subst(Panf01__i.APANR1: 4: 4):4:0);
            lbap_k.LBAPNMKR = %subst(Panf01__i.APANR1: 8: 6);
            lbap_k.LBAPPOSI = Panf01__i.APANRP;
            chain %kds(lbap_k:5) lbap01 lbap_I;
            if %found(lbap01);
               afpo01_k.ApFIRM = lbap_i.LBAPFIRM;
               afpo01_k.ApAFJJ = lbap_i.LBAPAFJJ;
               afpo01_k.ApAFNR = lbap_i.LBAPAFNR;
               afpo01_k.ApAFPO = lbap_i.LBAPAFPO;
               chain %kds(afpo01_k:4) afpo01 afpo01_I;
               if %found(afpo01);
                  afpo_I = afpo01_I;
                  aflp_k.AlFIRM = lbap_i.LBAPFIRM;
                  aflp_k.AlAFJJ = lbap_i.LBAPAFJJ;
                  aflp_k.AlAFNR = lbap_i.LBAPAFNR;
                  aflp_k.AlAFPO = lbap_i.LBAPAFPO;
                  aflp_k.ALKMJJ = %dec(%subst(Panf01__i.APANR1: 4: 4):4:0);
                  aflp_k.ALKMNR = %subst(Panf01__i.APANR1: 8: 6);
                  aflp_k.ALKMPO = Panf01__i.APANRP;
                  chain %kds(aflp_k:7) aflp01 aflp_I;
                  if %found(aflp01);
                     clear zusatzinfo;
                     exsr  srkeys;
                  else;
                     zusatzinfo         = 'AFLP fehlt, noch offen in Trend';
                     exsr  srkeys;
                  endif;
               else;
                  zusatzinfo  = 'AFPO fehlt, noch offen in LFS: ';
                  exsr  srkeys;
               endif;
            else;
               zusatzinfo  = 'lbap fehlt, noch offen in LFS: ';
               exsr  srkeys;
            endif;
            endif;
            read PANfpos Panf01__i;
          enddo;

       //
       //   noch offen in LFS Datei 2
       //   noch offen in LFS Datei 2
       //                                gang
          afpo_k.apfirm  =  '01';
          #comp          =  '01';
          pSaveAP__i.apanr1 = *blank;
          read PsaveAP  pSaveAP__i;
          dow not %eof(PsaveAP);
       //   afpo Positionen  aus
            if (%subst(pSaveAP__i.APANR1: 1: 1) = 'B' or
                %subst(pSaveAP__i.APANR1: 1: 1) = 'K') and
                       pSaveAP__i.APLFDN<>*zero;
            // Dezimalfehler in PSAVEAK2L2
            // Auskommentiert
            //if PankopS_i.AKAPN = 100248188 or
            //   PankopS_i.AKAPN = 100248188 or
            //   PankopS_i.AKAPN = 100259338;
            //   PankopS_i.AKAPN = 100259338;
            //endif;
            ##error = '0';
       //   afpo Positionen  aus  on-error 00102;
            monitor;
                lbap_k.LBAPJAHR = %dec(%subst(pSaveAP__i.APANR1: 4: 4):4:0);
            on-error;
                ##error = '1';
                // Fehlerbehandlung: String ist nicht numerisch
            endmon;
            if  ##error = '0';
            clear  RPMEXPECM0_o;
            lbap_k.LBAPFIRM = %subst(pSaveAP__i.APANR1: 2: 2);
            lbap_k.LBAPDANA = 'AFKM';
            lbap_k.LBAPJAHR = %dec(%subst(pSaveAP__i.APANR1: 4: 4):4:0);
            lbap_k.LBAPNMKR = %subst(pSaveAP__i.APANR1: 8: 6);
            lbap_k.LBAPPOSI = pSaveAP__i.APANRP;
            chain %kds(lbap_k:5) lbap01 lbap_I;
            if %found(lbap01);
               afpo01_k.ApFIRM = lbap_i.LBAPFIRM;
               afpo01_k.ApAFJJ = lbap_i.LBAPAFJJ;
               afpo01_k.ApAFNR = lbap_i.LBAPAFNR;
               afpo01_k.ApAFPO = lbap_i.LBAPAFPO;
               chain %kds(afpo01_k:4) afpo01 afpo01_I;
               if %found(afpo01);
                  afpo_I = afpo01_I;
                  aflp_k.AlFIRM = lbap_i.LBAPFIRM;
                  aflp_k.AlAFJJ = lbap_i.LBAPAFJJ;
                  aflp_k.AlAFNR = lbap_i.LBAPAFNR;
                  aflp_k.AlAFPO = lbap_i.LBAPAFPO;
                  aflp_k.ALKMJJ = %dec(%subst(pSaveAP__i.APANR1: 4: 4):4:0);
                  aflp_k.ALKMNR = %subst(pSaveAP__i.APANR1: 8: 6);
                  aflp_k.ALKMPO = pSaveAP__i.APANRP;
                  chain %kds(aflp_k:7) aflp01 aflp_I;
                  if %found(aflp01);
                     clear zusatzinfo;
                     exsr  srkeys2;
                  else;
                     zusatzinfo         = '2 AFLP fehlt, noch offen in Trend';
                     exsr  srkeys2;
                  endif;
               else;
                  zusatzinfo  = '2 AFPO fehlt, noch offen in LFS: ';
                  exsr  srkeys2;
               endif;
               else;
                  zusatzinfo  = '2 lbap fehlt, noch offen in LFS: ';
                  clear aflp_k;
                  exsr  srkeys2;
               endif;
            endif;
            read PsaveAP pSaveAP__i;
            else;
            read PsaveAP pSaveAP__i;
          endif;
          enddo;

          exsr SR_report;
       endif;

       // ______________________________________________________________________

       eval status ='Ende RPMEXPECM expected sales weekly report';
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
         SELECT char(week_iso(current date )),
                     week_iso(current date ),
                     DAYOFWEEK(current date + 0 days),
                     DAYOFWEEK_ISO(current date + 0 days)
         into        :#week_i, :#week_a, :#DAYOFWE, :#DAYOFWEi
         FROM   gang/systempf;

       exec sql
         delete from RPMEXPECM0 where
                YEAR# = substr(char(year(current date )), 1, 4) and
                WEEK# = substr(char(week_iso(current date )), 1, 2);

       //sql handling
         exec sql
                  whenever not found CONTINUE;
         exec sql
                  WHENEVER SQLWARNING CONTINUE;
         exec sql
                  WHENEVER SQLERROR CONTINUE;

       err_msg   = '0';

       endsr;

       //-----------------------------------------------------------------------
       //in Errorschnittstelle PANfpos2
       //-----------------------------------------------------------------------

       begsr srerrorlog;

                  if afpo_i.APPRGR < '900';
                    afko_k.akfirm  =  afpo_i.APFIRM;
                    afko_k.akafjj  =  afpo_i.APAFJJ;
                    afko_k.AKAFNR  =  afpo_i.APAFNR;
                    chain %kds(afko_k:3) afko01 afko_I;
                    if %found(afko01) and
                       afko_i.AKAFST < '99';
                       if afpo_i.apafnr ='667705';
                          #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       endif;
                       #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       if afpo_i.APWACD <> 'EUR';
                          waeh_k.WAFIRM  =  afpo_i.apfirm;
                          waeh_k.WASTWC  =  'EUR';
                          waeh_k.WAWACD  =  afpo_i.APWACD;
                          waeh_k.WAGADA  =  (%dec(%char(%date():*iso0):8:0));
                          setgt %kds(WAEH_k:4) WAEH01;
                          readp waeh01  waeh_i;
                          dow not %eof(WAEH01)                  and
                             waeh_i.WAFIRM = afpo_i.apfirm      and
                             waeh_i.WASTWC = 'EUR'              and
                             waeh_i.WAWACD = afpo_i.APWACD;
                             #expected =          (#openquan*afpo_i.APPREI
                                         *waeh_i.wakurs);
                             readp waeh01  waeh_i;
                          enddo;
                       else;
                       #expected =             (#openquan*afpo_i.APPREI);
                       endif;
       //kdew
                       kdew_k.kdewfirm =  afpo_i.APFIRM;
                       kdew_k.Kdewkdnr =  afpo_i.APRAKD;
                       chain %kds(kdew_k:2) kdew01 kdew_I;
                       if %found(kdew01);
                          select;
                            when kdew_I.KDEWKSST = '1001    ';
                                #division             = 'RVOEM   ';
                            when kdew_I.KDEWKSST = '1002    ';
                                #division             = 'RVAM    ';
                            when kdew_I.KDEWKSST = '1003    ';
                                #division             = 'RETL    ';
                            when kdew_I.KDEWKSST = '1004    ';
                                #division             = 'LODG    ';
                            when kdew_I.KDEWKSST = '1005    ';
                                #division             = 'CPVOEM  ';
                            when kdew_I.KDEWKSST = '1006    ';
                                #division             = 'CPVAM   ';
                            when kdew_I.KDEWKSST = '1007    ';
                                #division             = 'MAOEM   ';
                            when kdew_I.KDEWKSST = '1008    ';
                                #division             = 'MAAM    ';
                            when kdew_I.KDEWKSST = '1009    ';
                                if afpo_i.APFIRM  ='01'
                                or afpo_i.APFIRM  ='55';
                                   #division             = 'MEDI    ';
                                endif;
                                if afpo_i.APFIRM  ='52';
                                   #division             = 'RETL    ';
                                endif;
                                if afpo_i.APFIRM  ='08';
                                   #division             = 'LODG    ';
                                endif;
                            when kdew_I.KDEWKSST = '1015    ';
                                #division             = 'GROUP   ';
                            when kdew_I.KDEWKSST = '1020    ';
                                #division             = 'OTHER   ';
                            when kdew_I.KDEWKSST = '6050    ';
                                #division             = 'OTHER   ';
                            other;
                                #division             = 'ERROR   ';
                          endsl;
                       endif;
                       clear  RPMEXPECM0_o;
                       RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                       RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                       select;
                          when afpo_i.APFIRM  ='01';
                             RPMEXPECM0_o.ENTITY   = 'DE411';
                          when afpo_i.APFIRM  ='08';
                             RPMEXPECM0_o.ENTITY   = 'BE111';
                          when afpo_i.APFIRM  ='52';
                             RPMEXPECM0_o.ENTITY   = 'NL411';
                          when afpo_i.APFIRM  ='55';
                             RPMEXPECM0_o.ENTITY   = 'CH412';
                          when afpo_i.APFIRM  ='61';
                             RPMEXPECM0_o.ENTITY   = 'AT411';
                          other;
                             RPMEXPECM0_o.ENTITY   = '*erro';
                       endsl;
                       RPMEXPECM0_o.ITEM      = afpo_i.APTENR;
                       RPMEXPECM0_o.ITEMDESC  = afpo_i.APTBZ1;
                       RPMEXPECM0_o.APGLMG    = #openquan;
                       RPMEXPECM0_o.wert      = #expected;
                       RPMEXPECM0_o.RKWACD    = afpo_i.APWACD;
                       RPMEXPECM0_o.APPRGR    = *blank;
                       RPMEXPECM0_o.APAFPO    = afpo_i.APAFPO;
                       RPMEXPECM0_o.APAFST    = afpo_i.APAFST;
                       RPMEXPECM0_o.APLFTE    = afpo_i.APLFTE;
                       RPMEXPECM0_o.APAFAT    = afpo_i.APAFAT;
                       RPMEXPECM0_o.APUSER    = afpo_i.APUSER;
                       RPMEXPECM0_o.APSABE    = afpo_i.APSABE;
                       RPMEXPECM0_o.APSABEi   = *blank;
       //             sabe Inhalt
                       trtp_k.tpfirm  =  afpo_i.APfirm;
                       trtp_k.TPSPCD  =  'D';
                       trtp_k.TPTART  =  'SABE';
                       trtp_k.TPTCDE  =  afpo_i.APSABE;
                       setll %kds(trtp_k:4) trtp00;
                       reade %kds(trtp_k:4) trtp00  trtp_i;
                       dow not %eof(trtp00)                  and
                          trtp_i.tpfirm = afpo_i.APfirm      and
                          trtp_i.TPSPCD = 'D'                and
                          trtp_i.TPTART = 'SABE'             and
                          trtp_i.TPTCDE = afpo_i.APSABE;
                          if trtp_i.TPTTXT <> *blank and
                             RPMEXPECM0_o.APSABEi = *blank;
                             RPMEXPECM0_o.APSABEi = trtp_i.TPTTXT;
                             leave;
                          endif;
                       enddo;
                       RPMEXPECM0_o.DIVISION  = #division;
                       RPMEXPECM0_o.CUSTOMER# = afpo_i.APRAKD;
                       RPMEXPECM0_o.CUSTOMER  = *blank;
                       RPMEXPECM0_o.RPMGROUP  = *blank;
                       RPMEXPECM0_o.AKFIRM    = afpo_i.APFIRM;
                       RPMEXPECM0_o.AKAFJJ    = afpo_i.APAFJJ;
                       RPMEXPECM0_o.AKAFNR    = afpo_i.APAFNR;
                       RPMEXPECM0_o.h1        = 'upload';
                       RPMEXPECM0_o.h2        = %date();
                       RPMEXPECM0_o.h3        = %timestamp();
                       RPMEXPECM0_o.h5        = %date();
                       RPMEXPECM0_o.h6        = %timestamp();
                       RPMEXPECM0_o.h4        = 'Fehler in Schnittstelle: ' +
                                                 Panf01_i.APFCD             +
                                          %char(Panf01_i.APFTXT)           +
                                                 Panf01_i.APEFLD;
       //              write phy02r     RPMEXPECM0_o;
                       clear  #openquan;
                       clear  #division;
                       clear  #expected;
                    endif;
                 endif;


       endsr;

       //-----------------------------------------------------------------------
       //in Rechnung fehlt
       //-----------------------------------------------------------------------

       begsr srkeys;

                      Pankop_k.AKAPN  = Panf01__i.APAPN;
                      chain %kds(Pankop_k:1) panfkopl2  Pankop_i;
                      if %found(panfkopl2);
                         if (aflp_i.ALRGJJ = *zero or aflp_i.ALRGNR=*blank)
                             and Pankop_i.akaps2 > '40';
                            exsr srerrorlo2;
                            RPMEXPECM0_o.h4        = 'Rechnung fehlt: ' +
                                                 %char(Pankop_i.AKAPN)  +
                                              ' ' +  (Pankop_i.akaps2)  +
                                              ' ' + aflp_k +' * '       +
                                         %subst(Panf01__i.APANR1: 2: 2) + ' ' +
                                         %subst(Panf01__i.APANR1: 4: 4) + ' ' +
                                         %subst(Panf01__i.APANR1: 8: 6) + ' ' +
                                         %char(Panf01__i.APANRP) + ' ' +
                                         %subst(Pankop_I.AKRFNR: 12: 4) + ' ' +
                                         %subst(Pankop_I.AKRFNR: 17: 6) + ' ' +
                                         Panf01__i.APiden + ' ' +
                                         Panf01__i.APKDNR + ' ' +
                                         zusatzinfo;
       //                   write phy02r     RPMEXPECM0_o;
                         else;
       //alles ok
                         endif;
                      else;
                        exsr srerrorlo2;
                        RPMEXPECM0_o.h4    = 'Kopfsatz fehlt in LFS  ' +
                                         %subst(Panf01__i.APANR1: 2: 2) + ' ' +
                                         %subst(Panf01__i.APANR1: 4: 4) + ' ' +
                                         %subst(Panf01__i.APANR1: 8: 6) + ' ' +
                                         %char(Panf01__i.APANRP) + ' ' +
                                         Panf01__i.APiden + ' ' +
                                         Panf01__i.APKDNR + ' ' +
                                         zusatzinfo;
       //               write phy02r     RPMEXPECM0_o;
                      endif;
       endsr;

       //-----------------------------------------------------------------------
       //in Rechnung fehlt
       //-----------------------------------------------------------------------

       begsr srkeys2;
                      if zusatzinfo= '2 lbap fehlt, noch offen in LFS: ' or
                         zusatzinfo= '2 AFPO fehlt, noch offen in LFS: ';
                         clear afpo_I;
                         afpo01_k.ApFIRM =%subst(pSaveAP__I.APANR1: 2: 2);
                         afpo01_k.ApAFJJ=
                               %dec(%subst(pSaveAP__i.APANR1: 4: 4):4:0);
                         afpo01_k.ApAFNR =%subst(pSaveAP__I.APANR1: 8: 6);
                         afpo01_k.ApAFPO =pSaveAP__i.APANRP;
                         chain %kds(afpo01_k:4) afpo01 afpo01_I;
                         if %found(afpo01);
                            afpo_I = afpo01_I;
                         endif;
                      endif;
                      PankopS_k.AKKONZ = 'EMS';
                      PankopS_k.AKFIRM = 'DWI';
                      PankopS_k.AKAPN  = pSaveAP__i.APAPN;
                      chain %kds(PankopS_k:3) PSAVEAK2L2  PankopS_I;
                      if %found(PSAVEAK2L2);
                         if (aflp_i.ALRGJJ = *zero or aflp_i.ALRGNR=*blank)
                             and PankopS_i.akaps2 > '40';
                            exsr srerrorlo2;
                            if pSaveAP__I.APPM1 = *zero and
                               pSaveAP__I.APPM2 = *zero;
                               zusatzinfo= '2 Auftrag storniert in LFS: STORNO';
                            endif;
                            RPMEXPECM0_o.h4        = 'Rechnung fehlt: ' +
                                                 %char(PankopS_i.AKAPN)  +
                                              ' ' +  (PankopS_i.akaps2)  +
                                              ' ' + aflp_k +' * '       +
                                         %subst(pSaveAP__I.APANR1: 2: 2) + ' ' +
                                         %subst(pSaveAP__I.APANR1: 4: 4) + ' ' +
                                         %subst(pSaveAP__I.APANR1: 8: 6) + ' ' +
                                         %char(pSaveAP__I.APANRP) + ' ' +
                                         %subst(PankopS_I.AKRFNR: 12: 4) + ' ' +
                                         %subst(PankopS_I.AKRFNR: 17: 6) + ' ' +
                                         pSaveAP__I.APiden + ' ' +
                                         pSaveAP__I.APKDNR + ' ' +
                                         zusatzinfo;
                       RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                       RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                       RPMEXPECM0_o.h2        = %date();
                       RPMEXPECM0_o.h3        = %timestamp();
                       RPMEXPECM0_o.h5        = %date();
                       RPMEXPECM0_o.h6        = %timestamp();
       //                   write phy02r     RPMEXPECM0_o;
                         else;
       //alles ok
                         endif;
                      else;
                        exsr srerrorlo2;
                        RPMEXPECM0_o.h4    = 'Kopfsatz fehlt in LFS  ' +
                                         %subst(pSaveAP__i.APANR1: 2: 2) + ' ' +
                                         %subst(pSaveAP__i.APANR1: 4: 4) + ' ' +
                                         %subst(pSaveAP__i.APANR1: 8: 6) + ' ' +
                                         %char(pSaveAP__I.APANRP) + ' ' +
                                         pSaveAP__I.APiden + ' ' +
                                         pSaveAP__I.APKDNR + ' ' +
                                         zusatzinfo;
                       RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                       RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                       RPMEXPECM0_o.h2        = %date();
                       RPMEXPECM0_o.h3        = %timestamp();
                       RPMEXPECM0_o.h5        = %date();
                       RPMEXPECM0_o.h6        = %timestamp();
       //               write phy02r     RPMEXPECM0_o;
                      endif;
       endsr;

       //-----------------------------------------------------------------------
       //in Rechnung fehlt
       //-----------------------------------------------------------------------

       begsr srerrorlo2;

       ////////// if afpo_i.APPRGR < '900';
                    afko_k.akfirm  =  afpo_i.APFIRM;
                    afko_k.akafjj  =  afpo_i.APAFJJ;
                    afko_k.AKAFNR  =  afpo_i.APAFNR;
                    chain %kds(afko_k:3) afko01 afko_I;
                    if %found(afko01) and
                       afko_i.AKAFST < '99';
                       if afpo_i.apafnr ='667705';
                          #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       endif;
                       #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                       if afpo_i.APWACD <> 'EUR';
                          waeh_k.WAFIRM  =  afpo_i.apfirm;
                          waeh_k.WASTWC  =  'EUR';
                          waeh_k.WAWACD  =  afpo_i.APWACD;
                          waeh_k.WAGADA  =  (%dec(%char(%date():*iso0):8:0));
                          setgt %kds(WAEH_k:4) WAEH01;
                          readp waeh01  waeh_i;
                          dow not %eof(WAEH01)                  and
                             waeh_i.WAFIRM = afpo_i.apfirm      and
                             waeh_i.WASTWC = 'EUR'              and
                             waeh_i.WAWACD = afpo_i.APWACD;
                             #expected =          (#openquan*afpo_i.APPREI
                                         *waeh_i.wakurs);
                             readp waeh01  waeh_i;
                          enddo;
                       else;
                       #expected =             (#openquan*afpo_i.APPREI);
                       endif;
       //kdew
                       kdew_k.kdewfirm =  afpo_i.APFIRM;
                       kdew_k.Kdewkdnr =  afpo_i.APRAKD;
                       chain %kds(kdew_k:2) kdew01 kdew_I;
                       if %found(kdew01);
                          select;
                            when kdew_I.KDEWKSST = '1001    ';
                                #division             = 'RVOEM   ';
                            when kdew_I.KDEWKSST = '1002    ';
                                #division             = 'RVAM    ';
                            when kdew_I.KDEWKSST = '1003    ';
                                #division             = 'RETL    ';
                            when kdew_I.KDEWKSST = '1004    ';
                                #division             = 'LODG    ';
                            when kdew_I.KDEWKSST = '1005    ';
                                #division             = 'CPVOEM  ';
                            when kdew_I.KDEWKSST = '1006    ';
                                #division             = 'CPVAM   ';
                            when kdew_I.KDEWKSST = '1007    ';
                                #division             = 'MAOEM   ';
                            when kdew_I.KDEWKSST = '1008    ';
                                #division             = 'MAAM    ';
                            when kdew_I.KDEWKSST = '1009    ';
                                if afpo_i.APFIRM  ='01'
                                or afpo_i.APFIRM  ='55';
                                   #division             = 'MEDI    ';
                                endif;
                                if afpo_i.APFIRM  ='52';
                                   #division             = 'RETL    ';
                                endif;
                                if afpo_i.APFIRM  ='08';
                                   #division             = 'LODG    ';
                                endif;
                            when kdew_I.KDEWKSST = '1015    ';
                                #division             = 'GROUP   ';
                            when kdew_I.KDEWKSST = '1020    ';
                                #division             = 'OTHER   ';
                            when kdew_I.KDEWKSST = '6050    ';
                                #division             = 'OTHER   ';
                            other;
                                #division             = 'ERROR   ';
                          endsl;
                       endif;
                       clear  RPMEXPECM0_o;
                       RPMEXPECM0_o.YEAR#     = %char(%subdt( %date(): *years));
                       RPMEXPECM0_o.WEEK#     = %subst(#week_a: 1: 2);
                       select;
                          when afpo_i.APFIRM  ='01';
                             RPMEXPECM0_o.ENTITY   = 'DE411';
                          when afpo_i.APFIRM  ='08';
                             RPMEXPECM0_o.ENTITY   = 'BE111';
                          when afpo_i.APFIRM  ='52';
                             RPMEXPECM0_o.ENTITY   = 'NL411';
                          when afpo_i.APFIRM  ='55';
                             RPMEXPECM0_o.ENTITY   = 'CH412';
                          when afpo_i.APFIRM  ='61';
                             RPMEXPECM0_o.ENTITY   = 'AT411';
                          other;
                             RPMEXPECM0_o.ENTITY   = '*erro';
                       endsl;
                       RPMEXPECM0_o.ITEM      = afpo_i.APTENR;
                       RPMEXPECM0_o.ITEMDESC  = afpo_i.APTBZ1;
                       RPMEXPECM0_o.APGLMG    = #openquan;
                       RPMEXPECM0_o.wert      = #expected;
                       RPMEXPECM0_o.RKWACD    = afpo_i.APWACD;
                       RPMEXPECM0_o.APPRGR    = *blank;
                       RPMEXPECM0_o.APAFPO    = afpo_i.APAFPO;
                       RPMEXPECM0_o.APAFST    = afpo_i.APAFST;
                       RPMEXPECM0_o.APLFTE    = afpo_i.APLFTE;
                       RPMEXPECM0_o.APAFAT    = afpo_i.APAFAT;
                       RPMEXPECM0_o.APUSER    = afpo_i.APUSER;
                       RPMEXPECM0_o.APSABE    = afpo_i.APSABE;
                       RPMEXPECM0_o.APSABEi   = *blank;
       //             sabe Inhalt
                       trtp_k.tpfirm  =  afpo_i.APfirm;
                       trtp_k.TPSPCD  =  'D';
                       trtp_k.TPTART  =  'SABE';
                       trtp_k.TPTCDE  =  afpo_i.APSABE;
                       setll %kds(trtp_k:4) trtp00;
                       reade %kds(trtp_k:4) trtp00  trtp_i;
                       dow not %eof(trtp00)                  and
                          trtp_i.tpfirm = afpo_i.APfirm      and
                          trtp_i.TPSPCD = 'D'                and
                          trtp_i.TPTART = 'SABE'             and
                          trtp_i.TPTCDE = afpo_i.APSABE;
                          if trtp_i.TPTTXT <> *blank and
                             RPMEXPECM0_o.APSABEi = *blank;
                             RPMEXPECM0_o.APSABEi = trtp_i.TPTTXT;
                             leave;
                          endif;
                       enddo;
                       RPMEXPECM0_o.DIVISION  = #division;
                       RPMEXPECM0_o.CUSTOMER# = afpo_i.APRAKD;
                       RPMEXPECM0_o.CUSTOMER  = *blank;
                       RPMEXPECM0_o.RPMGROUP  = *blank;
                       RPMEXPECM0_o.AKFIRM    = afpo_i.APFIRM;
                       RPMEXPECM0_o.AKAFJJ    = afpo_i.APAFJJ;
                       RPMEXPECM0_o.AKAFNR    = afpo_i.APAFNR;
                       RPMEXPECM0_o.h1        = 'upload';
                       RPMEXPECM0_o.h2        = %date();
                       RPMEXPECM0_o.h3        = %timestamp();
                       RPMEXPECM0_o.h5        = %date();
                       RPMEXPECM0_o.h6        = %timestamp();
       /////////       RPMEXPECM0_o.h4        = 'Rechnung fehlt: ' +
       /////////                              %char(Pankop_i.AKAPN) +
       /////////                           ' ' +  (Pankop_i.akaps2) +
       /////////                           ' ' + aflp_k;
       /////////       write phy02r     RPMEXPECM0_o;
                       clear  #openquan;
                       clear  #division;
                       clear  #expected;
                    endif;
       ///////// endif;


       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr file_out;



       endsr;

       //-----------------------------------------------------------------------
       //output
       //-----------------------------------------------------------------------

       begsr input_out2;

       if err_msg   = '0';
          afkn_k.anfirm  =  '01';
          setll %kds(afkn_k:1) afkn01;
          reade %kds(afkn_k:1) afkn01  afkn_i;
          dow not %eof(afkn01);
             #openquan      =  *zero;
             #expected      =  *zero;
             afpo_k.apfirm  =  afkn_i.anfirm;
             afpo_k.apafjj  =  afkn_i.ANKOJJ;
             afpo_k.apafnr  =  afkn_i.ANKONR;
       //   afpo Positionen                afkn_i.anwtnt
             setll %kds(afpo_k:3) afpo07;
             reade %kds(afpo_k:3) afpo07  afpo_i;
             dow not %eof(afpo07)               and
               afpo_k.apafjj = afkn_i.ANKOJJ and
               afpo_k.apafnr = afkn_i.ANKONR;
                if  afpo_i.apafst < '90';
                    #openquan = afpo_i.APBSMG - afpo_i.APGLMG;
                    if afpo_i.APWACD <> 'EUR';
                       waeh_k.WAFIRM  =  afkn_i.anfirm;
                       waeh_k.WASTWC  =  'EUR';
                       waeh_k.WAWACD  =  afpo_i.APWACD;
                       waeh_k.WAGADA  =  (%dec(%char(%date():*iso0):8:0));
                       setgt %kds(WAEH_k:4) WAEH01;
                       readp waeh01  waeh_i;
                       dow not %eof(WAEH01)                  and
                          waeh_i.WAFIRM = afkn_i.anfirm      and
                          waeh_i.WASTWC = 'EUR'              and
                          waeh_i.WAWACD = afpo_i.APWACD;
                          #expected = #expected + (#openquan*afpo_i.APPREI
                                      *waeh_i.wakurs);
                          readp waeh01  waeh_i;
                       enddo;
                    else;
                       #expected = #expected + (#openquan*afpo_i.APPREI);
                    endif;
       //kdew
                    kdew_k.kdewfirm =  afpo_i.APFIRM;
                    kdew_k.Kdewkdnr =  afpo_i.APRAKD;
                    chain %kds(kdew_k:2) kdew01 kdew_I;
                    if %found(kdew01);
                       select;
                         when kdew_I.KDEWKSST = '1001    ';
                             #division             = 'RVOEM   ';
                         when kdew_I.KDEWKSST = '1002    ';
                             #division             = 'RVAM    ';
                         when kdew_I.KDEWKSST = '1003    ';
                             #division             = 'RETL    ';
                         when kdew_I.KDEWKSST = '1004    ';
                             #division             = 'LODG    ';
                         when kdew_I.KDEWKSST = '1005    ';
                             #division             = 'CPVOEM  ';
                         when kdew_I.KDEWKSST = '1006    ';
                             #division             = 'CPVAM   ';
                         when kdew_I.KDEWKSST = '1007    ';
                             #division             = 'MAOEM   ';
                         when kdew_I.KDEWKSST = '1008    ';
                             #division             = 'MAAM    ';
                         when kdew_I.KDEWKSST = '1009    ';
                             if RPMEXPECM0_o.ENTITY   = 'DE411'
                             or RPMEXPECM0_o.ENTITY   = 'CH412';
                                #division             = 'MEDI    ';
                             endif;
                             if RPMEXPECM0_o.ENTITY   = 'NL411';
                                #division             = 'RETL    ';
                             endif;
                             if RPMEXPECM0_o.ENTITY   = 'BE111';
                                #division             = 'LODG    ';
                             endif;
                         when kdew_I.KDEWKSST = '1015    ';
                             #division             = 'GROUP   ';
                         when kdew_I.KDEWKSST = '1020    ';
                             #division             = 'OTHER   ';
                         when kdew_I.KDEWKSST = '6050    ';
                             #division             = 'OTHER   ';
                         other;
                             #division             = 'ERROR   ';
                       endsl;
                    endif;
                    clear  RPMEXPECM0_o;
                    RPMEXPECM0_o.YEAR#     = '2015';
                    RPMEXPECM0_o.WEEK#     = '46';
                    RPMEXPECM0_o.ENTITY    = 'DE411';
                    RPMEXPECM0_o.ITEM      = afpo_i.APTENR;
                    RPMEXPECM0_o.ITEMDESC  = afpo_i.APTBZ1;
                    RPMEXPECM0_o.APGLMG    = #openquan;
                    RPMEXPECM0_o.RKWACD    = afpo_i.APWACD;
                    RPMEXPECM0_o.APPRGR    = *blank;
                    RPMEXPECM0_o.DIVISION  = #division;
                    RPMEXPECM0_o.CUSTOMER# = afpo_i.APRAKD;
                    RPMEXPECM0_o.CUSTOMER  = *blank;
                    RPMEXPECM0_o.RPMGROUP  = *blank;
                    RPMEXPECM0_o.AKFIRM    = afpo_i.APFIRM;
                    RPMEXPECM0_o.AKAFJJ    = afpo_i.APAFJJ;
                    RPMEXPECM0_o.AKAFNR    = afpo_i.APAFNR;
                    write phy02r     RPMEXPECM0_o;
                    clear  #openquan;
                    clear  #division;
                    clear  #expected;
                endif;
                reade %kds(afpo_k:2) afpo07 afpo_i;
             enddo;
             reade %kds(afkn_k:1) afkn01 afkn_i;
          enddo;

       endif;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'AT_preis  ';
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
       //reporting
       //-----------------------------------------------------------------------

       begsr SR_report;

       MONITOR;
       Wrk.var1 =
          'RMVLNK    OBJLNK(''/Controlling/KALKULATION/RPMEXPECM0.csv'')' ;
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed RPMEXPECM0             ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object RPMEXPECM0                ';
          exsr      SR_log;
       endmon;

         MONITOR;
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/RPMEXPECM#)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               status='error CLRPFM FILE(TVRELWAECO/RPMEXPECM#)          ';
               exsr      SR_log;
         endmon;


       exec sql
         insert into tvrelwaeco/RPMEXPECM#
         select * from RPMEXPECM0 where
                YEAR# = substr(char(year(current date )), 1, 4) and
                WEEK# = substr(char(week_iso(current date )), 1, 2);

       //sql handling
            exec sql
                     whenever not found CONTINUE;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Controlling/KALKULATION/RPMEXPECM0.csv'') ' +
           'DBFILE(TVRELWAECO/RPMEXPECM#) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done for RPMEXPECM0            ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object RPMEXPECM0                ';
          exsr      SR_log;
       endmon;
               eval p_outfil  =  %TrimR(suffix)+
                                        '_STK3';

       MONITOR;
       Wrk.var1 =
           'OVRPRTF FILE(QPQXPRTF) TOFILE(*LIBL/QPQXPRTF) '  +
           'FORMTYPE(''RPMEXPECM0'') OVRSCOPE(*JOB)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done for RPMEXPECM0           ';
          exsr      SR_log;
       on-error;
          status='Error by OVRPRTF object  RPMEXPECM0     ';
          exsr      SR_log;
       endmon;


       MONITOR;
       Wrk.var1 =
           'CALL  PGM(DUMMY512) PARM('' '' ''#DC0001'' '' '' ''PRT55'' ' +
           ''' '' '' '' '' '')';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='OVRPRTF successful done                          ';
          exsr      SR_log;
       on-error;
          status='Error by DUMMY512                        ';
          exsr      SR_log;
       endmon;


       endsr;


