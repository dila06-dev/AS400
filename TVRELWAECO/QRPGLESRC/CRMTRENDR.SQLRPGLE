
      //************************************************************************
      //
      //      Programmname       EDCPurch   WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://
      //      http://
      //      http://
      // URL: http://
      //
      // Username: _____________
      // Passwort: _____________
      //
      // create index tvrelwaeco/crmoutputl on
      //              tvrelwaeco/crmoutput
      //              (ENTITY, KDKDNR#)
      // create index tvrelwaeco/crmnotesl  on
      //              tvrelwaeco/crmnotes
      //              (ENTITY, KDKDNR#)
      //
      //
      // Jörg Jansen
      // Senior Consultant
      // mob.: +49 160   96 92 8176 (bevorzugt)
      // tel.: +49 2506 30 37 130
      // fax: +49 2506 30 37 100
      // e-mail: Joerg.Jansen@ConSense-Consulting.de
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
     h datfmt(*ISO)
     h datedit(*DMY.)
     h decedit('0,')
     h langid('DE')
     h timfmt(*HMS:)
     h option(*SRCSTMT:*NoDebugIO)
     h dftactgrp(*no) actgrp(*caller)
     h copyright('IT Dometic 2017')
     h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // Orderkopf und Positionen
     fcrmnotesl uf a e           k disk    RENAME(crmnotes:phy01r)
     f                                     USROPN
     F                                     INFDS(DSF1)
     fkund01    if   e           k DISK
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d CRMTRENDr       PR
       //Übergabe position  p_adat=20170509
     d p_von                         10a
     d p_bis                         10a
     d p_adat                         8s 0
     d p_entity                      10a
     d p_position                          dim(0100)
     d                                     likeds(p_array1)
     d p_Message                     80a
     d p_cc                           1

     d CRMTRENDr       PI
       //Übergabe items
     d p_von                         10a
     d p_bis                         10a
     d p_adat                         8s 0
     d p_entity                      10a
     d p_position                          dim(0100)
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

     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0

     D MD#2            S              1    DIM(512)
     D ATR             S              1    DIM(63)
     D ATTS            S              1    DIM(1)
     D ATTK            S              1    DIM(1)
     D ATTO            S              1    DIM(1)
     D KEY             S              2    DIM(24)
     D FKTTST          S              1    DIM(6)

     d CRMoutput_I   E DS                  ExtName(crmnotesl :*input)
     d                                     Qualified
     d CRMoutput_o   E DS                  ExtName(crmnotesl :*output)
     d                                     Qualified
     d CRMoutput_k   E DS                  ExtName(crmnotesl :*key)
     d                                     Qualified
     d kund_k        E DS                  ExtName(kund01:*key)
     d                                     Qualified
     d kund_i        E DS                  ExtName(kund01:*input)
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

     d curr_dat        s              8s 0 inz
     D w_ja            s              1a   inz
     D w_rrn           s              5  0 inz
     D status          s            132A   inz
       //currently mobicool
     D p_supplier      s             10A   inz ('90363     ')
     D p_email         s            132A   inz ('manfred.gang@dometic.com')
     D headerdone      s              1a   inz
     D error1          s              1a   inz
       // D UsaDate         s               d   DatFmt(*USA) Inz(d'07/04/2008')
       // D EurDate         s               d   DatFmt(*EUR) Inz(d'25122000')
     D IsoDate         s               d   DatFmt(*ISO) Inz(d'2008-10-31')

       //Übergabe Datenstruktur Position
      // d p_Array1      e ds                  qualified dim(0100)
      //          per sql erstellt        extname(CRMTREND:*input)

     d p_Array1        ds                  qualified dim(0100)
     d                                     export
     D ENTITY                        10a   inz
     D KDKDNR#                       10a   inz
     D KDNAM1#                       30a   inz
     D KDNAM2#                       30a   inz
     D KDNAM3#                       30a   inz
     D KDSTRA#                       30a   inz
     D KDPOLD#                        3a   inz
     D KDPOLZ#                       10a   inz
     D KDWORT#                       30a   inz
     D KDPOFA#                       10a   inz
     D KDKNAM#                       30a   inz
     D KDHINW#                       30a   inz
     D KDLANR#                        3a   inz
     D KDTLNR#                       20a   inz
     D VZVTN1#                       10a   inz
     D VTNAM1#                       30a   inz
     D VZVTN2#                       10a   inz
     D VTNAM2#                       30a   inz
     D VZVTN3#                       10a   inz
     D VTNAM3#                       30a   inz
     D VZVTN4#                       10a   inz
     D VTNAM4#                       30a   inz
     D VZVTN5#                       10a   inz
     D VTNAM5#                       30a   inz
     D VSNAM1#                       30a   inz
     D VSNAM2#                       30a   inz
     D VSNAM3#                       30a   inz
     D VSSTRA#                       30a   inz
     D VSPOLD#                        3a   inz
     D VSPOLZ#                       10a   inz
     D VSWORT#                       30a   inz
     D VSTLNR#                       20a   inz
     D VSTXNR#                       30a   inz
     D KDKDGR#                        5a   inz
     D KDKDGRS                       30a   inz
     D KDKSTC#                        5a   inz
     D KDKSTCS                       30a   inz
     D KDVSBD#                        5a   inz
     D KDVSBDS                       30a   inz
     D KDLIBD#                        5a   inz
     D KDLIBDS                       30a   inz
     D KDZABD#                        5a   inz
     D KDZABDS                       30a   inz
     D KDGRON#                       20a   inz
     D KDNIGB#                        8a   inz
     D KDNIGBDES                     30a   inz
     D DIVISION                       8a   inz
     D DIVISIONS                     40a   inz
     D RPMGROUP                       2a   inz
     D RPMDESC                       30a   inz
     D TURNOVER                      12s02 inz
     D CURRENCY                       6a   inz
     D TURNOVERE                     12s02 inz
     D CCLINE                        12s02 inz
     D OPORDER                       12s02 inz
     D RECEIVABLE                    12s02 inz
     D DUEAMOUNT                     12s02 inz
     D KDKDB1#                        1a   inz
     D KDBWBEZ1                      30a   inz
     D KDBWWERT1                     11s02 inz
     D KDKDB2#                        1a   inz
     D KDBWBEZ2                      30a   inz
     D KDBWWERT2                     11s02 inz
     D KDKDB3#                        1a   inz
     D KDBWBEZ3                      30a   inz
     D KDBWWERT3                     11s02 inz
      //D #INFO                         64a   inz
      //D H1                            10    inz
      //D H2                              d   inz
      //D H3                              z   inz
      //D H5                              d   inz
      //D H6                              z   inz

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

       p_cc       = '0';
       //übergabe enthält Information ASN

       eval status ='Start WebService CRMTRENDR: ' +
                                      p_von        + ' ' +
                                      p_bis        + ' ' +
                               %char( p_adat )     + ' ' +
                                      p_entity;
       exsr      SR_log;
       p_cc      = '1';

       //liblist
       MONITOR;
          Wrk.var1 =
              'ADDLIBLE LIB(LOTUS) POSITION(*LAST) ';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
             error1 ='0';
          on-error;
             status='error ADDLIBLE LIB(LOTUS) POSITION(*LAST)        ';
             exsr      SR_log;
             error1 ='1';
       endmon;

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

       open  kund01;
       open  crmnotesl ;
       w_rrn = 1;

       clear p_Array1;
       clear p_position;

       crmoutput_k.ENTITY     =  p_entity;
       crmoutput_k.KDKDNR#    =  p_von;
       setll %kds(crmoutput_k:2) crmnotesl ;
       reade %kds(crmoutput_k:1) crmnotesl  crmoutput_i;
       dow not %eof(crmnotesl ) and
                  //  read crmnotesl  crmoutput_i;
                  //  dow not %eof(crmnotesl ) and
       //maxwert
          w_rrn < 0101;
          w_ja = '0';
          if p_entity = crmoutput_i.ENTITY;
             w_ja = '1';
          endif;
          if w_ja = '1' and p_von <> *Blank;
             if ( crmoutput_i.KDKDNR# > p_von  or
                  crmoutput_i.KDKDNR# = p_von);
             else;
                 w_ja = '0';
             endif;
          endif;
          if w_ja = '1' and p_bis <> *Blank;
             if ( crmoutput_i.KDKDNR# < p_bis  or
                  crmoutput_i.KDKDNR# = p_bis);
             else;
                 w_ja = '0';
             endif;
          endif;
          curr_dat  = %dec(%char((crmoutput_i.H5):*iso0):8:0);
          if w_ja = '1' and p_adat <> *zero and
                        (curr_dat  > p_adat or curr_dat  = p_adat ) ;
       //         status='ja    ' + crmoutput_i.KDKDNR# + ' ' + %char(p_adat) +
       //                                                 ' ' + %char(curr_dat);
       //         exsr      SR_log;
          else;
       //         status='nein  ' + crmoutput_i.KDKDNR# + ' ' + %char(p_adat) +
       //                                                 ' ' + %char(curr_dat);
       //         exsr      SR_log;
             w_ja = '0';
          endif;
          if w_ja  = '1';
       //update
       //    if F1RRN > 8950;
                exsr srline;
                p_Message = 'Notes Custerm forCRM generated: ' +
                             %char(w_rrn) + ' records ' +%char(f1rrn) +
                             ' ' + crmoutput_i.KDKDNR# + ' '
                                 + crmoutput_i.KDNAM1#;
                eval status = p_Message;
                exsr      SR_log;
                p_cc      = '0';
                w_rrn=w_rrn + 1;
                crmoutput_o    =  crmoutput_i;
                crmoutput_o.h1 =  '1'    ;
                crmoutput_o.h5 =  %date();
                crmoutput_o.h6 =  %timestamp();
                update PHY01R    crmoutput_o;
                clear            crmoutput_o;
                if w_rrn     > 099;
                   p_cc      = '2';
                endif;
       //    endif;
          endif;
          read crmnotesl  crmoutput_i;
       // if F1RRN > 8950;
       //    w_rrn=w_rrn + 100;
       // endif;
          if  crmoutput_i.KDKDNR# > p_bis;
             w_rrn=w_rrn + 101;
          endif;
       enddo;

       close kund01;
       close crmnotesl ;

       eval status ='Ende WebService CrmOutput eingeleitet     ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //header
       //-----------------------------------------------------------------------

       begsr srheader;
         clear p_Array1;
         clear p_position;
       endsr;

       //-----------------------------------------------------------------------
       //line
       //-----------------------------------------------------------------------

       begsr srline;

       //    status='srline' + %char(w_rrn);
       //    exsr      SR_log;
       P_Array1(w_RRN).ENTITY     = crmoutput_i.ENTITY   ;
       P_Array1(w_RRN).KDKDNR#    = crmoutput_i.KDKDNR#  ;
       P_Array1(w_RRN).KDNAM1#    = crmoutput_i.KDNAM1#  ;
       P_Array1(w_RRN).KDNAM2#    = crmoutput_i.KDNAM2#  ;
       P_Array1(w_RRN).KDNAM3#    = crmoutput_i.KDNAM3#  ;
       P_Array1(w_RRN).KDSTRA#    = crmoutput_i.KDSTRA#  ;
       P_Array1(w_RRN).KDPOLD#    = crmoutput_i.KDPOLD#  ;
       P_Array1(w_RRN).KDPOLZ#    = crmoutput_i.KDPOLZ#  ;
       P_Array1(w_RRN).KDWORT#    = crmoutput_i.KDWORT#  ;
       P_Array1(w_RRN).KDPOFA#    = crmoutput_i.KDPOFA#  ;
       P_Array1(w_RRN).KDKNAM#    = crmoutput_i.KDKNAM#  ;
       P_Array1(w_RRN).KDHINW#    = crmoutput_i.KDHINW#  ;
       P_Array1(w_RRN).KDLANR#    = crmoutput_i.KDLANR#  ;
       P_Array1(w_RRN).KDTLNR#    = crmoutput_i.KDTLNR#  ;
       P_Array1(w_RRN).VZVTN1#    = crmoutput_i.VZVTN1#  ;
       P_Array1(w_RRN).VTNAM1#    = crmoutput_i.VTNAM1#  ;
       P_Array1(w_RRN).VZVTN2#    = crmoutput_i.VZVTN2#  ;
       P_Array1(w_RRN).VTNAM2#    = crmoutput_i.VTNAM2#  ;
       P_Array1(w_RRN).VZVTN3#    = crmoutput_i.VZVTN3#  ;
       P_Array1(w_RRN).VTNAM3#    = crmoutput_i.VTNAM3#  ;
       P_Array1(w_RRN).VZVTN4#    = crmoutput_i.VZVTN4#  ;
       P_Array1(w_RRN).VTNAM4#    = crmoutput_i.VTNAM4#  ;
       P_Array1(w_RRN).VZVTN5#    = crmoutput_i.VZVTN5#  ;
       P_Array1(w_RRN).VTNAM5#    = crmoutput_i.VTNAM5#  ;
       P_Array1(w_RRN).VSNAM1#    = crmoutput_i.VSNAM1#  ;
       P_Array1(w_RRN).VSNAM2#    = crmoutput_i.VSNAM2#  ;
       P_Array1(w_RRN).VSNAM3#    = crmoutput_i.VSNAM3#  ;
       P_Array1(w_RRN).VSSTRA#    = crmoutput_i.VSSTRA#  ;
       P_Array1(w_RRN).VSPOLD#    = crmoutput_i.VSPOLD#  ;
       P_Array1(w_RRN).VSPOLZ#    = crmoutput_i.VSPOLZ#  ;
       P_Array1(w_RRN).VSWORT#    = crmoutput_i.VSWORT#  ;
       P_Array1(w_RRN).VSTLNR#    = crmoutput_i.VSTLNR#  ;
       P_Array1(w_RRN).VSTXNR#    = crmoutput_i.VSTXNR#  ;
       P_Array1(w_RRN).KDKDGR#    = crmoutput_i.KDKDGR#  ;
       P_Array1(w_RRN).KDKDGRS    = crmoutput_i.KDKDGRS  ;
       P_Array1(w_RRN).KDKSTC#    = crmoutput_i.KDKSTC#  ;
       P_Array1(w_RRN).KDKSTCS    = crmoutput_i.KDKSTCS  ;
       P_Array1(w_RRN).KDVSBD#    = crmoutput_i.KDVSBD#  ;
       P_Array1(w_RRN).KDVSBDS    = crmoutput_i.KDVSBDS  ;
       P_Array1(w_RRN).KDLIBD#    = crmoutput_i.KDLIBD#  ;
       P_Array1(w_RRN).KDLIBDS    = crmoutput_i.KDLIBDS  ;
       P_Array1(w_RRN).KDZABD#    = crmoutput_i.KDZABD#  ;
       P_Array1(w_RRN).KDZABDS    = crmoutput_i.KDZABDS  ;
       P_Array1(w_RRN).KDGRON#    = crmoutput_i.KDGRON#  ;
       P_Array1(w_RRN).KDNIGB#    = crmoutput_i.KDNIGB#  ;
       P_Array1(w_RRN).KDNIGBDES  = crmoutput_i.KDNIGBDES;
       P_Array1(w_RRN).DIVISION   = crmoutput_i.DIVISION ;
       P_Array1(w_RRN).DIVISIONS  = crmoutput_i.DIVISIONS;
       P_Array1(w_RRN).RPMGROUP   = crmoutput_i.RPMGROUP ;
       P_Array1(w_RRN).RPMDESC    = crmoutput_i.RPMDESC  ;
       P_Array1(w_RRN).TURNOVER   = crmoutput_i.TURNOVER ;
       P_Array1(w_RRN).CURRENCY   = crmoutput_i.CURRENCY ;
       P_Array1(w_RRN).TURNOVERE  = crmoutput_i.TURNOVERE;
       P_Array1(w_RRN).CCLINE     = crmoutput_i.CCLINE   ;
       P_Array1(w_RRN).OPORDER    = crmoutput_i.OPORDER  ;
       P_Array1(w_RRN).RECEIVABLE = crmoutput_i.RECEIVABLE;
       P_Array1(w_RRN).DUEAMOUNT  = crmoutput_i.DUEAMOUNT;
       P_Array1(w_RRN).KDKDB1#    = crmoutput_i.KDKDB1#  ;
       P_Array1(w_RRN).KDBWBEZ1   = crmoutput_i.KDBWBEZ1 ;
       P_Array1(w_RRN).KDBWWERT1  = crmoutput_i.KDBWWERT1;
       P_Array1(w_RRN).KDKDB2#    = crmoutput_i.KDKDB2#  ;
       P_Array1(w_RRN).KDBWBEZ2   = crmoutput_i.KDBWBEZ2 ;
       P_Array1(w_RRN).KDBWWERT2  = crmoutput_i.KDBWWERT2;
       P_Array1(w_RRN).KDKDB3#    = crmoutput_i.KDKDB3#  ;
       P_Array1(w_RRN).KDBWBEZ3   = crmoutput_i.KDBWBEZ3 ;
       P_Array1(w_RRN).KDBWWERT3  = crmoutput_i.KDBWWERT3;
       // P_Array1(w_RRN).#INFO      = crmoutput_i.#INFO    ;
       // P_Array1(w_RRN).H1         = crmoutput_i.H1       ;
       // P_Array1(w_RRN).H2         = crmoutput_i.H2       ;
       // P_Array1(w_RRN).H3         = crmoutput_i.H3       ;
       // P_Array1(w_RRN).H5         = crmoutput_i.H5       ;
       // P_Array1(w_RRN).H6         = crmoutput_i.H6       ;
       p_position(w_rrn)          = p_Array1(w_rrn)      ;
       endsr;

       //-----------------------------------------------------------------------
       //Kunde noch da?
       //-----------------------------------------------------------------------

       begsr srcust;

             if headerdone    <> '*';
       //kund01
                kund_k.kdFIRM = '01';
                kund_k.kdkdnr = p_supplier;
                chain %kds(kund_k:1) kund01 kund_I;
                if %found(kund01);
                   exsr srheader;
                else;
                   p_Message = 'Client unknown in setting for this option';
       //          leave;
                endif;
                headerdone  ='*';
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
