
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //
      //      http://edc.dometic.com/outbound/
      //      http://edc.dometic.com/inbound-gates/
      //      http://edc.dometic.com/inbound-ppf/
      // URL: http://edc.dometic.com/en-us/login/
      //
      // Username: edc@dometic.com
      // Passwort: mobileLiving2017
      //
      //
      // Danach erst kommt man auf die verschiedenen Screens:
      //
      // http://edc.dometic.com/en-us/outbound/
      //
      // http://edc.dometic.com/en-us/inbound-gates/
      //
      // http://edc.dometic.com/en-us/inbound-ppf/
      //
      // http://edc.dometic.com/en-us/news/
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
     fEDCDISP   uf   e           k disk
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d EDCDISPLAY      PR
     d p_User                        50a
     d p_Pword                       20a
       //Übergabe Datenstruktur Screen one Order cut off
     d p_descipt1                    80a
     d p_screen1                           dim(13)
     d                                     likeds(p_array1)
     d p_Message1                    80a
       //Übergabe Datenstruktur Screen two Delivery positions Inbound
     d p_descipt2                    80a
     d p_screen2                           dim(13)
     d                                     likeds(p_array2)
     d p_Message2                    80a
       //Übergabe Datenstruktur Screen three Transport positions Inbound
     d p_descipt3                    80a
     d p_screen3                           dim(13)
     d                                     likeds(p_array3)
     d p_Message3                    80a
     d p_cc                           1

     d EDCDISPLAY      PI
     d p_User                        50a
     d p_Pword                       20a
       //Übergabe Datenstruktur Screen one Order cut off
     d p_descipt1                    80a
     d p_screen1                           dim(13)
     d                                     likeds(p_array1)
     d p_Message1                    80a
       //Übergabe Datenstruktur Screen two Delivery positions Inbound
     d p_descipt2                    80a
     d p_screen2                           dim(13)
     d                                     likeds(p_array2)
     d p_Message2                    80a
       //Übergabe Datenstruktur Screen three Transport positions Inbound
     d p_descipt3                    80a
     d p_screen3                           dim(13)
     d                                     likeds(p_array3)
     d p_Message3                    80a
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

     D w_rrn           s              2  0 inz
     D status          s            132A   inz
     D x               s              2  0 inz

       //Übergabe Datenstruktur Screen one Order cut off
     d p_Array1        ds                  qualified dim(13)
     d d_Arg1                        20a   inz                                  Argument
     d d_Soll1                        5s 0 inz                                  Soll
     d d_Ist1                         5s 0 inz                                  Ist
     d d_Delay1                       5s 0 inz                                  Delay
       //Übergabe Datenstruktur Screen two Delivery positions Inbound
     d p_Array2        ds                  qualified dim(13)
     d d_Arg2                        20a   inz                                  Argument
     d d_Soll2                        5s 0 inz                                  Soll
     d d_Ist2                         5s 0 inz                                  Ist
     d d_Delay2                       5s 0 inz                                  Delay
       //Übergabe Datenstruktur Screen three Transport positions Inbound
     d p_Array3        ds                  qualified dim(13)
     d d_Arg3                        20a   inz                                  Argument
     d d_Soll3                        5s 0 inz                                  Soll
     d d_Ist3                         5s 0 inz                                  Ist
     d d_Delay3                       5s 0 inz                                  Delay

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

       eval status ='Start WebService EDCDisplay eingeleitet   ';
       //exsr      SR_log;

       clear     p_screen1;
       clear     p_Message1;
       clear     p_Array1;
       clear     p_screen2;
       clear     p_Message2;
       clear     p_Array2;
       clear     p_screen3;
       clear     p_Array3;
       clear     p_Message3;

       open  EDCDISP;
       x=1;
       read EDCDISP     EDCDISP_i;
       dow not %eof(EDCDISP);
          if (EDCDISP_i.rrn = 0 and  EDCDISP_i.SCREEN=1);
              EDCDISP_i.rrn = x;
              x=x+1;
          endif;
       //für Web
          if (EDCDISP_i.Aktiv='A' or EDCDISP_i.Aktiv='T' ) and
              (EDCDISP_i.rrn) > 0   and
              (EDCDISP_i.rrn) < 14;
              w_rrn=(EDCDISP_i.rrn);
              select;
              when (EDCDISP_i.SCREEN=1) and EDCDISP_i.Aktiv='T';
                 p_descipt1 = 'Screen Layout Outbound' +
                          ' (Dachser / DPD / IT / NL)';
                 P_Array1(w_RRN).d_Arg1    = EDCDISP_i.arg;
                 P_Array1(w_RRN).d_Soll1   = EDCDISP_i.SOLL;
                 P_Array1(w_RRN).d_Ist1    = EDCDISP_i.IST ;
                 P_Array1(w_RRN).d_Delay1  = EDCDISP_i.DELAY;
                 p_Message1                = %char(EDCDISP_i.#timestamp);
       //update
                 EDCDISP_o  = EDCDISP_i;
                 EDCDISP_o.#DATE      = %date();
                 EDCDISP_o.#timestamp = %timestamp();
                 update EDCDISPR  EDCDISP_o;
                 clear            EDCDISP_o;
              when (EDCDISP_i.SCREEN=2);
                 p_descipt2 = 'Screen Layout Inbound ' +
                          ' (gates)';
                 P_Array2(w_RRN).d_Arg2    = EDCDISP_i.arg;
                 P_Array2(w_RRN).d_Soll2   = EDCDISP_i.SOLL;
                 P_Array2(w_RRN).d_Ist2    = EDCDISP_i.IST ;
                 P_Array2(w_RRN).d_Delay2  = EDCDISP_i.DELAY;
                 p_Message2                = %char(EDCDISP_i.#timestamp);
       //update
                 EDCDISP_o  = EDCDISP_i;
                 EDCDISP_o.#DATE      = %date();
                 EDCDISP_o.#timestamp = %timestamp();
                 update EDCDISPR  EDCDISP_o;
                 clear            EDCDISP_o;
              when (EDCDISP_i.SCREEN=3);
                 p_descipt2 = 'Screen Layout Inbound ' +
                          ' (pickup point forklifts)';
                 P_Array3(w_RRN).d_Arg3    = EDCDISP_i.arg;
                 P_Array3(w_RRN).d_Soll3   = EDCDISP_i.SOLL;
                 P_Array3(w_RRN).d_Ist3    = EDCDISP_i.IST ;
                 P_Array3(w_RRN).d_Delay3  = EDCDISP_i.DELAY;
                 p_Message3                = %char(EDCDISP_i.#timestamp);
       //update
                 EDCDISP_o  = EDCDISP_i;
                 EDCDISP_o.#DATE      = %date();
                 EDCDISP_o.#timestamp = %timestamp();
                 update EDCDISPR  EDCDISP_o;
                 clear            EDCDISP_o;
              other;
              endsl;
          endif;
          read EDCDISP  EDCDISP_i;
       enddo;

       p_screen1 =  p_Array1;
       p_screen2 =  p_Array2;
       p_screen3 =  p_Array3;

       close EDCDISP;

       eval status ='Ende WebService EDCDisplay eingeleitet    ';
       //exsr      SR_log;

       *inlr = *on;

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
