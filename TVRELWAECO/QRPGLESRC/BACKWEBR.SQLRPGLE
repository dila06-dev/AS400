
      //************************************************************************
      //
      //      Programmname       ITEMWEBR   WebService
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

     fbackorderoif   e           k DISK    RENAME(backordero:phy01r)
     f                                     USROPN

      //------------------------------------------------------------------------
      //    D A T E N S T R U K T U R E N
      //------------------------------------------------------------------------
      // System-Datenstruktur


     d BackWEBR        PR
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_loading                           dim(06)
     d                                     likeds(p_array)
       //Messages and return
     d p_load                         1a
     d p_Message                    132a
     d p_cc                           1


     d BackWEBR        PI
     d p_User                        50a
     d p_Pword                       20a
       //artikel
     d p_loading                           dim(06)
     d                                     likeds(p_array)
       //Messages and return
     d p_load                         1a
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

     d back_k        E DS                  ExtName(backordero:*key)
     d                                     Qualified

     d back_i        E DS                  ExtName(backordero:*input)
     d                                     Qualified

     d back_i        E DS                  ExtName(backordero:*output)
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

       //Übergabe Datenstruktur
     d pFKT            ds                  qualified dim(9999)
     d dITEM                          1A   inz                                  Argument
     d dITEMNAME                     15A   inz                                  Soll
     d dCUSTOMER#                    40A   inz                                  Ist
     d dCUSTOMER                     10A   inz                                  Delay
     d dBACKCURV                     40A   inz
     d dBACKCURP                     12p 2 inz
     d dMAXSTOCK                     12p 0 inz
     d dROOTCAUSE                    12p 2 inz
     d dLIEFERANT                    60A   inz
     d dSUPNAME                      10A   inz
     d dFORECAST                     40A   inz
     d dONSTOCK                      12p 0 inz
     d dARRIVALW1                    12p 2 inz
     d dARRIVALW2                    10p 0 inz
     d dARRIVALW3                    10p 0 inz
     d dARRIVALW4                    10p 0 inz
     d dARRIVALW5                    10p 0 inz
     d dARRIVALW6                    10p 0 inz
     d dDISPONENT                     5A   inz
     d dEINK                          5A   inz
     d dINFO                         60A   inz
     d dTSTAMP                         z   inz
     d dRRN#                         10p 0 inz

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

       eval status ='Start WebService BACKWEBR  eingeleitet ' +
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

       eval status ='Ende WebService BACKWEBR eingeleitet ' + p_Item;
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
       //function
       //-----------------------------------------------------------------------

       begsr sr_fkt;

       open  backordero;

       read backordero  back_i;
       dow not %eof(backordero);
       //für Web
       // if (EDCDISP_i.Aktiv='A') and
              back_o    = back_i;
       //     EDCDISP_o.#DATE      = %date()     ;
       //     EDCDISP_o.#TIMESTAMP = %timestamp();
              update phy01r   EDCDISP_O;
       // endif;
          read backordero back_i;
       enddo;

       close backordero;


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
