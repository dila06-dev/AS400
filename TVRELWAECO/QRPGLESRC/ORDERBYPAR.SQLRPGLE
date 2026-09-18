
      //************************************************************************
      //
      //      Programmname       ORDERWEBR  WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //      CPYFRMIMPF FROMFILE(TVRELWAECO/orderbypa)
      //      TOFILE(TVRELWAECO/orderbypas) MBROPT(*ADD)
      //      FLDDLM(';') DECPNT(*COMMA)
      //      FROMRCD(1) RPLNULLVAL(*FLDDFT)
      // insert into kpif
      // select  char(' ', 1)         kpLOCK,  char('GANG#', 10)   kpJNAM,
      // zoned(('20')
      // concat  substr(char(current date +0 day), 7, 2)  concat
      // substr(char(current date +0 day), 4, 2)  concat
      // substr(char(current date +0 day), 1, 2), 8, 0)   kpJDAT,
      // zoned(substr(char(current time), 1, 2)  concat
      // substr(char(current time), 4, 2)  concat
      // substr(char(current time), 7, 2), 6, 0)   kpJZEI,
      //         char('GANG#', 10)         kpUSER,
      //         char('SQLFKT   ', 10)     kpPROG,
      //         char('TVRELWAECO', 10)    kpBIBL,
      //         char('01', 02)            kpFIRM,
      //         char('005359', 10)        kpKDNR,
      //         char('  ', 03)            kpvsnr,
      //         F2 kptenr, zoned(0       , 8, 0)   kpgada,
      //         char(F1 concat '               ', 30) KPIDEN,
      //         char(F3) kPIBZ1,
      //         char(' ', 30) kPIBZ2,   char(' ', 25) kPZinr,
      //         zoned(0, 11, 3) KPEZPR, char('EUR', 3) KPWACD,
      //         zoned(0, 8, 0) KPlfda,  char('N', 1) kpdrib,
      //         char(' ', 3) kpbspl,    char(' ', 1) kpmpvk,
      //         char(' ', 1) kpmebe,    char(' ', 17) kpaend,
      //         char(' ', 15) kpbknr,   char(' ', 17) kpbkae,
      //         char(' ', 15) kpkpte,   char(' ', 1) kpprkz,
      //         zoned(0, 11, 2) KPabmp, zoned(0, 11, 2) KPabmg,
      //         char(' ', 1) kpwkpz,    char('N', 1) kpdskz,
      //         char(' ', 30) kprfnr,   char(' ', 8) kpchaf,
      //         char(' ', 10) kplfnr,   zoned( 0, 3, 0) kplfkz,
      //         char(' ', 1) kprlfa,    char('N', 1) kpegmd,
      //         char('01', 2) kpstat,    char(' ', 1) kpvwar,
      //         char('0', 1) kpeasc,    char(' ', 202) kpfrex
      // from         orderbypas           a
      // where a.F2     <> ' ' and  a.F1 <> ' ' and
      //       a.F2  not in
      // ( select kptenr from kpif  where  kpkdnr = 005359 and
      // KPFIRM  ='01')
      //
      //
      //
      //
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
     h copyright('IT Dometic 2015')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

     forderbypasIf   e             DISK    RENAME(orderbypas:PHY01R)
     f                                     USROPN
      // Lieferscheinkopf
     forderh    if a e             disk    RENAME(orderhpf:header)
     f                                     USROPN
     forderl    if a e             disk    RENAME(orderlpf:line  )
     f                                     USROPN
     fkund01    if   e           k DISK

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

     d orderbypas_i  E DS                  ExtName(orderbypas:*input)
     d                                     Qualified

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
     d done            s              1a   inz

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

       eval status ='Start ORDERBYPAR eingeleitet ';

       exsr      SR_log;

       //für change
       //  kund01
          kund_k.kdfirm = '01';
          kund_k.kdkdnr = '005359';
          chain %kds(kund_k:2) kund01 kund_I;
          if %found(kund01);
             open  orderbypas;
             read orderbypas  orderbypas_i;
             dow not %eof(orderbypas);
       //      für input
                if done <> '1';
                   exsr srheader;
                   done =  '1';
                endif;
                exsr srline;
                read orderbypas  orderbypas_i;
             enddo;
             close orderbypas;
             customer=0000079;
       //    callP orderr(customer);
          endif;

       eval status ='Ende ORDERBYPAR eingeleitet ';
       exsr      SR_log;

       *inlr = *on;

       //**************************************************************************
       //*header  steuerer 79
       //*-------------------------------------------------------------------------
       //
       begsr srheader;

       open  orderh;
       //*header
       H010      =  'H'     ;
       H020      =  005359;
       H030      =   79     ;
       H040      =  005359;
       H050      =  orderbypas_i.f4;
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
       H170      = orderbypas_i.f4;
       H180      = 'H'      ;
       H190      = *blank   ;
       H200      = 'H'      ;
       H210      = *Blank   ;
       H220      = *Blank   ;
       //         = 'DAP' ==> 27
       //         = 'frei Haus' ==> 01
       H230      = '220'    ;
       H240      = *Blank   ;
       H240      = orderbypas_i.f4;
       H250      = '0'      ;
       H260      = *Blank   ;
       H270      = '0'      ;
       H280      = *blank   ;
       H290      = *blank   ;
       H300      = *Blank   ;
       H300      = *blank  ;
       H310      = *blank   ;

       h310      = *blank;
       %subst(h310:501:10) = kund_i.KDPOLZ;
       if kund_i.KDPOLD = 'DE';
          %subst(h310:417:03) = '220';   //national
       else;
          %subst(h310:417:03) = '220';   //international
       endif;
       H320      = *blank   ;
       H330      = §§§USR   ;
       H330      = 'ORDERBYPAR';
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
       L040      = orderbypas_i.f4;
       L050      = orderbypas_i.f5;
       L060      = %date()          ;
       L070      = *zero            ;
       L080      = orderbypas_i.f2  ;
       L090      = *BLANK           ;
       L100      = orderbypas_i.f7  ;
       L110      = orderbypas_i.f1  ;
       L120      = *Blank           ;
       L130      = *Blank           ;
       L140      = 'N'              ;
       L150      = *Blank           ;
       L160      = 'ORDERBYPAR'     ;
       L170      = *blank           ;
       L180      = %date()          ;
       L190      = %timestamp()     ;
       L200      = %date()          ;
       L210      = *zero            ;
       L220      = *zero            ;
       L230      = *zero            ;
       L240      = '99'             ;
       L240      = '  '             ;
       L250      = 79               ;
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
