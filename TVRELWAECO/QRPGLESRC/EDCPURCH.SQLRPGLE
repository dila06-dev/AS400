
      //************************************************************************
      //
      //      Programmname       EDCPurch   WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://  IP: 193.243.145.21
      //      http://
      //      http://  User: mbc_invoices_xml
      // URL: http://  Pw: rUxFe5KGXRZTEf4j
      //
      // Username: _____________
      // Passwort: _____________
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
      //h datfmt(*ISO)
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

      // Orderkopf und Positionen
     forderh    if a e             disk    RENAME(orderhpf:header)
     f                                     USROPN
     forderl    if a e             disk    RENAME(orderlpf:line  )
     f                                     USROPN
     flief01    if   e           k DISK
     f                                     USROPN
     fbbscweb   if a e             DISK    prefix('##')
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d EDCPurch        PR
     d p_Invoice                     30a
     d p_Account                     30a
     d p_date1                       10a
     d p_date2                       10a
     d p_salesId                     20a
     d p_Order                       30a
       //Übergabe items
     d p_position                          dim(99)
     d                                     likeds(p_array1)
     d p_Message                     80a
     d p_cc                           1


     d EDCpurch        PI
     d p_Invoice                     30a
     d p_Account                     30a
     d p_date1                       10a
     d p_date2                       10a
     d p_salesId                     20a
     d p_Order                       30a
       //Übergabe items
     d p_position                          dim(99)
     d                                     likeds(p_array1)
     d p_Message                     80a
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

     d lief_k        E DS                  ExtName(lief01:*key)
     d                                     Qualified

     d lief_i        E DS                  ExtName(lief01:*input)
     d                                     Qualified

     d bbsc_o        E DS                  ExtName(bbscWeb:*output)
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
       // TRBBSCST
       // ______________________________________________________________________
     D TRBBSCST        PR                  ExtPgm('TRBBSCST  ')

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
       //currently mobicool
     D p_supplier      s             10A   inz ('90363     ')
     D p_email         s            132A   inz ('manfred.gang@dometic.com')
     D headerdone      s              1a   inz
     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz
       // D UsaDate         s               d   DatFmt(*USA) Inz(d'07/04/2008')
       // D EurDate         s               d   DatFmt(*EUR) Inz(d'25122000')
     D IsoDateI        s               d   DatFmt(*ISO) Inz(d'2008-10-31')
     D IsoDateII       s               d   DatFmt(*ISO) Inz(d'2008-10-31')

     D ##BBSCFIRM      s              2a
       // D ##BBSCFIRM      s                   like(bbsc_o.BBSCFIRM)
     D ##BBSCLFNR      s             10a
     D ##BBSCABTL      s              3a
     D ##BBSCLANR      s              3a
     D ##BBSCBEAT      s              3a
     D ##BBSCBEAR      s              1a
     D ##BBSCTENR      s             15a
     D ##BBSCMENG      s             11s 2
     D ##BBSCAFJJ      s              4s 0
     D ##BBSCAFNR      s              6a
     d ##BBSCBETE      s              8s 0
     d ##BBSCUEDA      s              8s 0
     d ##BBSCREF1      s             30a
     d ##BBSCREF2      s             30a

       //Übergabe Datenstruktur Position
     d p_Array1        ds                  qualified dim(99)
     d d_item                        25a   inz                                  Item
     d d_sku                         15a   inz                                  SKU
     d d_QTY                         10s 4 inz                                  Quantity
     d d_salePric                    11s 4 inz                                  SalesPrice
     d d_currency                    05a   inz                                  Currency
     d d_amount                      11s 4 inz                                  LineAmount
     d d_descrip                    120a   inz                                  Description

      //------------------------------------------------------------------------
      //    V A R I A B L E N
      //------------------------------------------------------------------------

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E   MyCharDatum = %Char(MyDatum: *EUR);
      //          -----------------
      //************************************************************************

      /FREE

       Exec Sql
        set option commit = *none, datfmt = *iso, timfmt = *iso;

       p_cc       = '0';
       //übergabe enthält Information ASN

       eval status ='Start WebService EDCPurchasing eingeleitet   ';
       exsr      SR_log;
       p_cc      = '1';

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(TVPF) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(TVPF) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

       w_rrn = 1;
       //Datumsangaben korrekt
       monitor;
          IsoDateI =%date((%subst(p_date1:01:04) +
                           %subst(p_date1:06:02) +
                           %subst(p_date1:09:02)):*iso0);
          On-error *all;
             eval p_Message = 'p_date1 ' + p_date1 + ' irregular date ';
             eval status = p_Message;
             exsr      SR_log;
             w_rrn = 99;
       endmon;

       //Datumsangaben korrekt
       monitor;
          IsoDateII=%date((%subst(p_date2:01:04) +
                           %subst(p_date2:06:02) +
                           %subst(p_date2:09:02)):*iso0);
          On-error *all;
             eval p_Message = 'p_date2 ' + p_date2 + ' irregular date ';
             w_rrn = 99;
       endmon;
       error1 ='0';
       error2 ='0';
       error3 ='0';
       open  bbscWeb;
       open  lief01;
       open  orderh;
       open  orderl;

       if   w_rrn < 095;
          p_Array1(w_rrn) = p_position(w_rrn);
       dou  w_rrn < 095 or
            P_Array1(w_RRN).d_sku  <> *blank or
            error2 <> '0';
          if headerdone    <> '*';
       //lief01
             lief_k.LFFIRM = '01';
             lief_k.LFLFNR = p_supplier;
             chain %kds(lief_k:2) lief01 lief_I;
             if %found(lief01);
                exsr srheader;
             else;
                p_Message = 'Supplier unknown in setting for this option';
                leave;
             endif;
             headerdone  ='*';
          endif;
       //update
          p_Array1(w_rrn) = p_position(w_rrn);
          exsr srline;
          exsr srbbsc;
          p_Message = 'Purchasing order generated: ' +
                      %subst(p_invoice:001:010) +
                      ' ' + %char(w_rrn) + ' records';
          p_cc      = '0';
          w_rrn=w_rrn + 1;
          p_Array1(w_rrn) = p_position(w_rrn);
       enddo;
       endif;

       close bbscWeb;
       close lief01;
       close orderh;
       close orderl;

       // exsr  srTRBBSCST;
       //liblist
          MONITOR;
             Wrk.var1 =
          'SBMJOB CMD(CALL PGM(TVRELWAECO/EDCPURCH2)) ' +
                 'JOB(EDCPURCH) JOBD(GANG/GANG) ' +
                 'INLLIBL(QTEMP TMNP MODWAO TEVMF TEVMP TAMF TAMP ' +
                 'TVPF TVPP SEAXCALP MODWAOQRY TRENDMG TVRELWAECO ' +
                 'DOMDTAPRD EDIFACT SASF SAS SFBF SFB SFBA QGPL ' +
                 'GANG)';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
             on-error;
                status='error SBMJOB CMD(CALL PGM(CALL PGM(EDCPURCH2) ';
                exsr      SR_log;
          endmon;

       eval status = p_Message;
       exsr      SR_log;
       eval status ='Ende WebService EDCPurchasing eingeleitet ';
       exsr      SR_log;

       MONITOR;
       Wrk.var1 =
           'DSPJOBLOG OUTPUT(*PRINT) ';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DSPJOBLOG OUTPUT(*PRINT)';
          exsr      SR_log;
       endmon;
       *inlr = *on;

       //**************************************************************************
       //**************************************************************************
       //*header
       //*-------------------------------------------------------------------------
       //
       begsr srheader;

       //*header
       H010      =  'H'     ;
       H020      =  %dec(%subst(p_supplier:01:06):6:0)   ;
       H030      =  90363   ;
       H040      =  %dec(%subst(p_supplier:01:06):6:0)   ;
       H050      =  %subst(p_invoice:001:010);
       H060      =  %date()  ;
       H070      =  %time()  ;
       H080      =  *blank   ;
       H090      =  *bLank   ;
       H100      =  lief_i.lfNAM1             ;
       H110      =  lief_i.lfNAM2             ;
       H120      =  lief_i.lfNAM3             ;
       H130      =  lief_i.lfSTRA             ;
       H140      =  lief_i.lfPOLD             ;
       H150      =  *zero;
       H160      =  lief_i.lfWORT             ;
       H170      = p_salesId;
       H180      = 'H'      ;
       H190      = p_Order  ;
       H200      = 'H'      ;
       H210      = *Blank   ;
       H220      = *Blank   ;
       //         = 'DAP' ==> 27
       //         = 'frei Haus' ==> 01
       H230      = '01'     ;
       H240      = *Blank   ;
       H240      =      (p_date1)  +  ' '  +       (p_date2);
       H250      = '0'      ;
       H260      = *Blank   ;
       H270      = '0'      ;
       H280      = *blank   ;
       H290      = *blank   ;
       H300      = *Blank   ;
       H300      = p_email  ;
       H310      = *blank   ;

       h310      = 'LT##' + %TrimR(p_eMail) + '##';
       %subst(h310:501:10) = lief_i.lfPOLZ;
       if lief_i.lfPOLD = 'DE';
          %subst(h310:417:03) = '113';   //national
       else;
          %subst(h310:417:03) = '003';   //international
       endif;
       H320      = *blank   ;
       H330      = §§§USR   ;
       H330      = 'EDCPURCH ';
       H340      = *blank   ;
       H350      = '99'     ;
       H350      = '  '     ;
       H360      = %date()  ;
       H370      = %timestamp();
       write     header     ;

       endsr;

       //*line new customer (derzeit kein Unterschied)
       //*-------------------------------------------------------------------------
       //
       begsr srline;
       //für Web

       L010      = 'L'    ;
       L020      = *zero  ;
       L030      = *zero  ;
       L040      = p_order    ;
       L050      = w_rrn*10;
       L060      = %date()          ;
       L070      = *zero            ;
       L080      = P_Array1(w_RRN).d_sku;
       L090      = *BLANK           ;
       L100      = P_Array1(w_RRN).d_QTY;
       L110      = P_Array1(w_RRN).d_item;
       L120      = *Blank           ;
       L130      = *Blank           ;
       L140      = 'N'              ;
       L150      = *Blank           ;
       L160      = P_Array1(w_RRN).d_currency;
       L170      = *blank           ;
       L180      = %date()          ;
       L190      = %timestamp()     ;
       L200      = %date()          ;
       L210      = P_Array1(w_RRN).d_amount;
       L220      = *zero            ;
       L230      = *zero            ;
       L240      = '99'             ;
       L240      = '  '             ;
       L250      = 90363            ;
       L990      = P_Array1(w_RRN).d_descrip;
       write     line               ;

       endsr;

       //*line new customer (derzeit kein Unterschied)
       //*-------------------------------------------------------------------------
       //
       begsr srbbsc;
       //für Web

       clear      BBSC_O;
       BBsc_o.BBSCLOCK  = *blank;
       BBsc_o.BBSCJNAM  = 'GANG#';
       BBsc_o.BBSCJDAT  = %dec(%char(%date():*iso0):8:0);
       BBsc_o.BBSCJZEI  = %dec(%char(%time():*iso0):6:0);
       BBsc_o.BBSCUSER  = §§§usr;
       BBsc_o.BBSCPROG  = §§§pgm;
       BBsc_o.BBSCBIBL  = 'TVRELWAECO';
       BBsc_o.BBSCFIRM  = '01';
       BBsc_o.BBSCTSTP  = %timestamp()     ;
       BBsc_o.BBSCBEAT  = *blank;
       BBsc_o.BBSCLFNR  = '90363     ';
       BBsc_o.BBSCWKNR  = '001';
       BBsc_o.BBSCABTL  = *blank;
       BBsc_o.BBSCBEAR  = *blank;
       BBsc_o.BBSCBEDA  =  %dec(%char(%date():*iso0):8:0);
       BBsc_o.BBSCBRKA  = *blank;
       BBsc_o.BBSCLANR  = *Blank;
       BBsc_o.BBSCTENR  = P_Array1(w_RRN).d_sku;
       BBsc_o.BBSCMENG  = P_Array1(w_RRN).d_QTY;
       BBsc_o.BBSCBETE  = %dec(%subst(p_date1:01:04)   +
                               %subst(p_date1:06:02)   +
                               %subst(p_date1:09:02):8:0);
       BBsc_o.BBSCBEJJ  = *zero;
       BBsc_o.BBSCBENR  = *blank;
       BBsc_o.BBSCBEPO  = *zero;
       BBsc_o.BBSCUEDA  = *zero;
       BBsc_o.BBSCUEKZ  = *blank;
       BBsc_o.BBSCBDML  = *blank;
       BBsc_o.BBSCVPKZ  = *blank;
       BBsc_o.BBSCAFJJ  = 2019;
       BBsc_o.BBSCAFNR  = '770005';
       BBsc_o.BBSCARBG  = *Zero;
       BBsc_o.BBSCAGFL  = *Zero;
       BBsc_o.BBSCTMST  = *Zero;
       BBsc_o.BBSCPOAZ  = *Zero;
       BBsc_o.BBSCSABE  = *Blank;
       bbsc_o.BBSCLFTE  = %dec(%subst(p_date2:01:04)   +
                               %subst(p_date2:06:02)   +
                               %subst(p_date2:09:02):8:0);
       BBsc_o.BBSCREF1  = %subst(p_invoice:001:014) +
                          ' '                       +
                          %subst(p_salesId:001:015);
       BBsc_o.BBSCREF2  = p_Order;
       BBsc_o.BBSCEXBL  = *blank;
       BBsc_o.BBSCBLPO  = *Zero;
       BBsc_o.BBSCFREI  = *Blank;
       write     BBSC1      bbsc_o;

       endsr;

       //*-------------------------------------------------------------------------
       //*bbsc
       //*-------------------------------------------------------------------------
       //
       begsr srbbscsql;
       //für Web

       clear   ##BBSCFIRM;
       clear   ##BBSCLFNR;
       clear   ##BBSCABTL;
       clear   ##BBSCLANR;
       clear   ##BBSCBEAT;
       clear   ##BBSCBEAR;
       clear   ##BBSCTENR;
       clear   ##BBSCMENG;
       clear   ##BBSCAFJJ;
       clear   ##BBSCAFNR;
       clear   ##BBSCBETE;
       clear   ##BBSCUEDA;
       clear   ##BBSCREF1;
       clear   ##BBSCREF2;

       bbsc_o.BBSCLFNR='90363     ';

       //*Standardwerte
       ##BBSCLFNR = '90363     ';
       ##BBSCBEAT =  'GANG#'    ;
       ##BBSCABTL    ='EK'      ;
       ##BBSCBEAR    ='D'       ;
       ##BBSCLANR    ='001'     ;
       ##BBSCTENR    =L080      ;
       ##BBSCMENG    =L100      ;
       ##BBSCAFJJ    =*zero     ;
       ##BBSCAFNR    =*blank    ;
       ##BBSCUEDA    = %dec(%subst(p_date1:01:04)   +
                            %subst(p_date1:06:02)   +
                            %subst(p_date1:09:02):8:0);
       ##BBSCREF1    = H050 + ' ';
       ##BBSCREF2    = p_salesId + ' ' + p_Order;

       //*Ableitungen für Übergaben in qtemp
       exec sql
        insert into tvrelwaeco/BBSC_INPUT
        select  char(' ', 1) BBSCLOCK,  char('GANG#', 10) BBSCJNAM,
        zoned(('20')
        concat  substr(char(current date +0 day), 7, 2)  concat
        substr(char(current date +0 day), 4, 2)  concat
        substr(char(current date +0 day), 1, 2), 8, 0)   BBSCJDAT,
        zoned(substr(char(current time), 1, 2)  concat
        substr(char(current time), 4, 2)  concat
        substr(char(current time), 7, 2), 6, 0)  BBSCJZEI,
                'GANG      '                     BBSCUSER,
                char('EDCPURCH  ', 10)           BBSCPROG,
                char('TVRELWAECO', 10)           BBSCBIBL,
                :##BBSCfirm                      BBSCFIRM,
                current timestamp                BBSCTSTP,
                :##BBSCBEAT                      BBSCBEAT,
                :##BBSCLFNR                 BBSCLFNR,
                char('001', 03)                  BBSCWKNR,
                :##BBSCABTL                      BBSCABTL,
                :##BBSCBEAR                      BBSCBEAR,
                zoned(('20')
                concat  substr(char(current date +0 day), 7, 2)  concat
                substr(char(current date +0 day), 4, 2)  concat
                substr(char(current date +0 day), 1, 2), 8, 0)
                                                 BBSCBEDA,
                char(' ', 01)                    BBSCBRKA,
                :##BBSCLANR                      BBSCLANR,
                :##BBSCTENR                      BBSCTENR,
                :##BBSCMENG                      BBSCMENG,
                :##BBSCBETE                      BBSCBETE,
                zoned(0, 04, 0)                  BBSCBEJJ,
                char(' ', 06)                    BBSCBENR,
                zoned(0, 04, 0)                  BBSCBEPO,
                :##BBSCUEDA                      BBSCUEDA,
                char(' ', 01)                    BBSCUEKZ,
                char(' ', 10)                    BBSCBDML,
                char(' ', 01)                    BBSCVPKZ,
                :##BBSCAFJJ                      BBSCAFJJ,
                :##BBSCAFNR                      BBSCAFNR,
                zoned(0, 05, 0)                  BBSCARBG,
                zoned(0, 05, 0)                  BBSCAGFL,
                zoned(0, 26, 0)                  BBSCTMST,
                zoned(0, 03, 0)                  BBSCPOAZ,
                char(' ', 03)                    BBSCSABE,
                zoned(0, 08, 0)                  BBSCLFTE,
                :##BBSCREF1                      BBSCREF1,
                :##BBSCREF2                      BBSCREF2,
                char(' ', 20)                    BBSCEXBL,
                zoned(0, 06, 0)                  BBSCBLPO,
                char(' ', 44)                    BBSCFREI
        from    qsys2/qsqptabl;
       //-----------------------------------------------------------------------
       //log report
       //    If SQLCODE = 0 and SQLWARN0 is blank, execution was successful.
       //    If SQLCODE = 100, no data was found. For example, a FETCH statement returned no data,
       //       because the cursor was positioned after the last row of the result table.
       //    If SQLCODE > 0 and not = 100, execution was successful with a warning.
       //    If SQLCODE = 0 and SQLWARN0 = 'W', execution was successful with a warning.
       //    If SQLCODE < 0, execution was not successful.
       //
       //-----------------------------------------------------------------------

        if SQLCOD <> 0 or SQLWARN(1) ='W';
           eval status ='SQLCOD: '   + %char(sqlcod) +
                        ' SQLWARN: '  + SQLWARN(1);
           exsr      SR_log;
           eval status ='SQLERRMC: '  + SQLERRMC;
           exsr      SR_log;
           eval status ='SQLERM: '  + SQLERM;
           exsr      SR_log;
           MONITOR;
           Wrk.var1 =
               'DSPJOBLOG OUTPUT(*PRINT) ';
             cmd = %TrimR(Wrk.Var1);

             l      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
           on-error;
              status='error in DSPJOBLOG OUTPUT(*PRINT)';
              exsr      SR_log;
           endmon;

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
