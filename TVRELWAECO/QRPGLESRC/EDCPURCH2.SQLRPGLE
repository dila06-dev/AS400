
      //************************************************************************
      //
      //      Programmname       EDCPurch2  WebService
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

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------

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

     D error1          s              1a   inz
     D error2          s              1a   inz
     D error3          s              1a   inz

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

       //übergabe enthält Information ASN

       eval status ='Start WebService EDCPurchasing2 eingeleitet   ';
       exsr      SR_log;

       error1 ='0';
       error2 ='0';
       error3 ='0';

       //call trend
       exsr srTRBBSCST;

       eval status ='Ende WebService EDCPurchasing2 eingeleitet ';
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

       //*-------------------------------------------------------------------------
       //*#TRBBSCST call  bbsc kopieren
       //*CALL AUF TREND AUFTRÄGE GENERIEREN
       //*FILE AKTUALISIEREN MIT TREND DATEN
       //*-------------------------------------------------------------------------
       //
       begsr srTRBBSCST;
       //für Web

           status = *blank;
           MONITOR;
           Wrk.var1 =
               'CPYF FROMFILE(TVRELWAECO/BBSCWEB) '  +
               'TOFILE(TVPF/BBSC) MBROPT(*ADD)';
             cmd = %TrimR(Wrk.Var1);
             l      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
           on-error;
              status='error in CPYF FROMFILE(BBSCWeb) to Trend)';
              exsr      SR_log;
              error3  = '1';
           endmon;

        if Error3 = '0';
           eval status ='Start callP TRBBSCST                      ';
           exsr      SR_log;
           callP TRBBSCST();
           eval status ='Ende  callP TRBBSCST                      ';
           exsr      SR_log;
        endif;

        MONITOR;
        Wrk.var1 =
            'CPYF FROMFILE(TVRELWAECO/BBSCWEB) ' +
            'TOFILE(TVRELWAECO/BBSC_INPUT) MBROPT(*ADD)';
          cmd = %TrimR(Wrk.Var1);
          l      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
        on-error;
           status='error in CPYF FROMFILE(QTEMP/BBSC_INPUT))';
           exsr      SR_log;
        endmon;

        MONITOR;
        Wrk.var1 =
            'CLRPFM(TVRELWAECO/BBSCWEB)' +
          cmd = %TrimR(Wrk.Var1);
          l      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
        on-error;
           status='error in CLRPFM(TVRELWAECO/BBSCWEB))';
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
