
      //************************************************************************
      //
      //      Programmname       ORDERWEBR  WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://rtx-recall.dometic.com/en/
      //
      //      Achtung: bei der SOAP ist case sensitive
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

      // Lieferscheinkopf
     forderh    if a e             disk    RENAME(orderhpf:header)
     f                                     USROPN
     forderl    if a e             disk    RENAME(orderlpf:line  )
     f                                     USROPN
     fkund01    if   e           k DISK
     f                                     USROPN


      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d ORDERWEBR       PR
     d p_User                        50a
     d p_Pword                       20a
     d p_referenc                    10a
     d p_customer                    10a
     d p_ZipCode                     12a
     d p_Vehicle                     60a
     d p_eMail                       60a
       //
       //Übergabe ohne Referenznummer
     d p_Comp                        30a
     d p_CompCont                    30a
     d p_CompTel                     30a
     d p_Address                     60a
     d p_City                        30a
     d p_Country                      2a
     d p_VatID                       15a
     d p_Bank                        30a
     d p_Iban                        32a
     d p_BIC                         30a
       //
       //Messages and return
     d p_Message                    132a
     d p_cc                           1

     d ORDERWEBR       PI
     d p_User                        50a
     d p_Pword                       20a
     d p_referenc                    10a
     d p_customer                    10a
     d p_ZipCode                     12a
     d p_Vehicle                     60a
     d p_eMail                       60a
       //
       //Übergabe ohne Referenznummer
     d p_Comp                        30a
     d p_CompCont                    30a
     d p_CompTel                     30a
     d p_Address                     60a
     d p_City                        30a
     d p_Country                      2a
     d p_VatID                       15a
     d p_Bank                        30a
     d p_Iban                        32a
     d p_BIC                         30a
       //Messages and return
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

     d EDCDISP_K     E DS                  ExtName(EDCDISP:*key)
     d                                     Qualified
     d EDCDISP_I     E DS                  ExtName(EDCDISP:*input)
     d                                     Qualified
     d EDCDISP_O     E DS                  ExtName(EDCDISP:*output)
     d                                     Qualified

     d KUND_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified

     d KUND_i        E DS                  ExtName(kund01:*input)
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
       // orderr
       // ______________________________________________________________________
     D ORDERR          PR                  ExtPgm('ORDERR')
     D customer                       7s 0

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

       // ______________________________________________________________________
      // orderr
      //------------------------------------------------------------------------
     D customer        s            007s 0 inz

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D error1          s              1A   inz
     D option          s              1A   inz
     d years           s              4s 0
     d ref             s             10a   inz

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

       eval status ='Start WebService ORDERWEBR eingeleitet ' +
                                         p_customer + ' ' + p_ZipCode;
       exsr      SR_log;

       error1 ='0';
       option ='0';
       p_Message  = *blank;
       years      = %subdt( %date(): *years );
       p_referenc = %char(years) + %subst(p_referenc:01:06);

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

       p_cc       = '1';
       //übergabe enthält Information ASN
       if (error1='0' or error1='1') and
          p_customer <> *blank     ;
          open kund01;
       //kund01
          kund_k.kdfirm = '01';
          kund_k.kdkdnr = p_customer;
          chain %kds(kund_k:2) kund01 kund_I;
          if %found(kund01);
             if kund_i.KDPOLZ <> %subst(p_ZipCode:01:10);
                p_Message = 'ZipCode is departing from master data';
             else;
                if p_referenc <> *blank;
                   exsr srheader;
                   exsr srline;
                   p_Message = 'Order accepted and in update for progressing';
                   p_cc       = '0';
                   if option='1';
                      callP orderr(customer);
                   endif;
                else;
                   p_Message = 'Missing necessary transfer information      ';
                   p_cc       = '1';
                endif;
             endif;
          else;
             p_Message = 'Customer unknown in setting for this option';
          endif;
          close kund01;
       else;
          if p_customer  =  *blank and
             p_ZipCode   <> *blank and
             p_Comp      <> *blank and
             p_CompCont  <> *blank and
             p_CompTel   <> *blank and
             p_Address   <> *blank and
             p_City      <> *blank and
             p_Country   <> *blank and
             p_VatID     <> *blank and
             p_Bank      <> *blank and
             p_Iban      <> *blank and
             p_BIC       <> *blank;
             p_customer  = '000005';
             if p_referenc <> *blank;
                exsr srheaderN;
                exsr srlineN;
                p_Message = 'Order accepted and in update for progressing';
                p_cc       = '0';
                if option='1';
                   callP orderr(customer);
                endif;
             else;
                p_Message = 'Missing necessary transfer information      ';
                p_cc       = '1';
             endif;
          else;
             p_Message = 'Missing necessary transfer information      ';
             p_cc       = '1';
          endif;
       endif;

       eval status ='Ende WebService ORDERWEBR eingeleitet ' + p_Message;
       exsr      SR_log;

       *inlr = *on;

       //**************************************************************************
       //*header
       //*-------------------------------------------------------------------------
       //
       begsr srheader;

       open  orderh;
       //*header
       H010      =  'H'     ;
       H020      =  %dec(%subst(p_customer:01:06):6:0)   ;
       H030      =   77     ;
       H040      =  %dec(%subst(p_customer:01:06):6:0)   ;
       H050      =  p_referenc ;
       H060      = %date()  ;
       H070      = %time()  ;
       H080      = *blank   ;
       H090      = *bLank   ;
       H100      =  kund_i.KDNAM1             ;
       H110      =  kund_i.KDNAM2             ;
       H120      =  kund_i.KDNAM3             ;
       H130      =  kund_i.KDSTRA             ;
       H140      =  kund_i.KDPOLD             ;
       H150      =  *zero;
       H160      =  kund_i.KDWORT             ;
       H170      = 'RTX Quality Check 2017 ';
       H180      = 'H'      ;
       H190      = p_Vehicle;
       H200      = 'H'      ;
       H210      = *Blank   ;
       H220      = *Blank   ;
       //         = 'DAP' ==> 27
       //         = 'frei Haus' ==> 01
       H230      = '01'     ;
       H240      = *Blank   ;
       H240      = 'Artikel: 4445900469 ';
       H250      = '0'      ;
       H260      = *Blank   ;
       H270      = '0'      ;
       H280      = *blank   ;
       H290      = *blank   ;
       H300      = *Blank   ;
       H300      = p_eMail ;
       H310      = *blank   ;

       h310      = 'LT##' + %TrimR(p_eMail) + '##';
       %subst(h310:501:10) = kund_i.KDPOLZ;
       if kund_i.KDPOLD = 'DE';
          %subst(h310:417:03) = '113';   //national
       else;
          %subst(h310:417:03) = '003';   //international
       endif;
       H320      = *blank   ;
       H330      = §§§USR   ;
       H330      = 'ORDERWEBR';
       H340      = *blank   ;
       H350      = '99'     ;
       H350      = '  '     ;
       H360      = %date()  ;
       H370      = %timestamp();
       write     header     ;
       close  orderh;

       endsr;

       //**************************************************************************
       //*line
       //*-------------------------------------------------------------------------
       //
       begsr srline;

       open   orderl;
       L010      = 'L'    ;
       L020      = *zero  ;
       L030      = *zero  ;
       L040      = p_referenc ;
       L050      = 1     ;
       L060      = %date()          ;
       L070      = *zero            ;
       L080      = '4445900469'     ;
       L090      = *BLANK           ;
       L100      = 1                ;
       L110      = '4445900469'     ;
       L120      = *Blank           ;
       L130      = *Blank           ;
       L140      = 'N'              ;
       L150      = *Blank           ;
       L160      = 'ORDERWEBR'      ;
       L170      = *blank           ;
       L180      = %date()          ;
       L190      = %timestamp()     ;
       L200      = %date()          ;
       L210      = *zero            ;
       L220      = *zero            ;
       L230      = *zero            ;
       L240      = '99'             ;
       L240      = '  '             ;
       L250      = 77               ;
       L990      = *blank           ;
       write     line               ;
       close  orderl;

       endsr;

       //**************************************************************************
       //*header new customer
       //*-------------------------------------------------------------------------
       //
       begsr srheaderN;

       open  orderh;
       //*header
       H010      =  'H'     ;
       H020      =  %dec(%subst(p_customer:01:06):6:0)   ;
       H030      =   77     ;
       H040      =  %dec(%subst(p_customer:01:06):6:0)   ;
       H050      =  p_referenc ;
       H060      = %date()  ;
       H070      = %time()  ;
       H080      = *blank   ;
       H090      = *bLank   ;
       H100      =  p_Comp                    ;
       H110      =  *Blank                    ;
       H120      =  *Blank                    ;
       H130      =  %subst(p_Address:001:30)  ;
       H130      =  %subst(p_Address:001:30)  ;
       H140      =  p_Country                 ;
       H150      =  *zero;
       H160      =  p_City                    ;
       H170      = 'RTX Quality Check 2017 ';
       H180      = 'H'      ;
       H190      = p_Vehicle;
       H200      = 'H'      ;
       H210      = *Blank   ;
       H220      = *Blank   ;
       //         = 'DAP' ==> 27
       //         = 'frei Haus' ==> 01
       H230      = '01'     ;
       H240      = *Blank   ;
       H240      = 'Artikel: 4445900469 ';
       H250      = '0'      ;
       H260      = *Blank   ;
       H270      = '0'      ;
       H280      = *blank   ;
       H290      = *blank   ;
       H300      = *Blank   ;
       H300      = p_eMail ;
       H310      = *blank   ;
       h310      = 'LT##' + %TrimR(p_eMail) + '##';
       %subst(h310:121:167) = p_VatID    +
                              p_Bank     +
                              p_Iban     +
                              p_BIC      +
                              p_CompCont +
                              p_CompTel;

       %subst(h310:501:10) = p_ZipCode;
       if kund_i.KDPOLD = 'DE';
          %subst(h310:417:03) = '113';   //national
       else;
          %subst(h310:417:03) = '003';   //international
       endif;
       H320      = *blank   ;
       H330      = §§§USR   ;
       H330      = 'ORDERWEBR';
       H340      = *blank   ;
       H350      = '99'     ;
       H350      = '  '     ;
       H360      = %date()  ;
       H370      = %timestamp();
       write     header     ;
       close  orderh;

       endsr;

       //**************************************************************************
       //*line new customer (derzeit kein Unterschied)
       //*-------------------------------------------------------------------------
       //
       begsr srlineN;

       open   orderl;
       L010      = 'L'    ;
       L020      = *zero  ;
       L030      = *zero  ;
       L040      = p_referenc ;
       L050      = 1     ;
       L060      = %date()          ;
       L070      = *zero            ;
       L080      = '4445900469'     ;
       L090      = *BLANK           ;
       L100      = 1                ;
       L110      = '4445900469'     ;
       L120      = *Blank           ;
       L130      = *Blank           ;
       L140      = 'N'              ;
       L150      = *Blank           ;
       L160      = 'ORDERWEBR'      ;
       L170      = *blank           ;
       L180      = %date()          ;
       L190      = %timestamp()     ;
       L200      = %date()          ;
       L210      = *zero            ;
       L220      = *zero            ;
       L230      = *zero            ;
       L240      = '99'             ;
       L240      = '  '             ;
       L250      = 77               ;
       L990      = *blank           ;
       write     line               ;
       close  orderl;

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
