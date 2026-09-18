
      //************************************************************************
      //
      //      Programmname       DESADVR
      //      Erstellt  am       08.10.2026
      //      Erstellt von       M.Gang/D.Langlitz
      //
      //      Beschreibung       Meldung an galaxus Bestände
      //
      // ----------------------------------+------------------------------------
      // Geändert am Kürzel Name           ! Anfo-Nr. (Zeile 1) + Beschreibung
      // ----------------------------------+------------------------------------
      //                                   !
      //  tt.mm.jjjj  xx01  .............. !
      //                                   !
      //  maikey='2019611640'  Wert=null!!!!!!
      //
      //  select * from stddat where maikey='2022225271'   16% flasch prüfen
      //  retarus rechnungen
      //************************************************************************
      // Übersetzungshinweise:
      // Restartmöglichkeiten:
      // _____________________
      //
      // beteiligte Dateien
      // __________________
      //
      //------------------------------------------------------------------------
      //------------------------------------------------------------------------
      ///Protokolle:
      ///select * from tvrelwaeco/DESADVR300
      ///
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

     fDESADVR300uf   e           k DISK    usropn
     f                                     RENAME(DESADVR300:PHY01R)
     fDESADVNVE uf   e           k DISK    usropn
     f                                     RENAME(DESADVNVE:PHY02R)

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
       // PDESADV
       // Lieferscheinnummer
       // Paket-ID
       // Versanddatum (YYYYMMDD)
       // Verpackungsnummer (z. B. NVE)
       // Verpackte Menge
       // ______________________________________________________________________
     D PDESADV         PR                  ExtPgm('PDESADV')
     D pLiefNr                       10a
     D pPKIDEN                       15a
     D pDatum                         8a
     D pPKVENR                       14a
     D pPKPMEN                        7p 3
     D pUPDATE                        1S 0

       // define files
       // ______________________________________________________________________
     d DESADVR300_i  e ds                  ExtName(DESADVR300:*input)
     d                                     Qualified

     d DESADVR300_o  E DS                  ExtName(DESADVR300:*output)
     d                                     Qualified

     d DESADVR300_k  E DS                  ExtName(DESADVR300:*key)
     d                                     Qualified

     d DESADVNVE_i   e ds                  ExtName(DESADVNVE:*input)
     d                                     Qualified

     d DESADVNVE_o   e ds                  ExtName(DESADVNVE:*output)
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

      // qmhsndpm
      // ______________________________________________________________________
     D MessageID       s              7A   inz
     D QualMsgF        s             20A   inz
     D MsgData         s            256A   inz
     D MsgDtaLen       s             10I 0 inz
     D MsgType         s             10A   inz

      // PDESADV
      // ______________________________________________________________________
     D pLiefNr         s             35a   inz
     D pPKIDEN         s             35a   inz
     D pDatum          s              8a   inz
     D pPKVENR         s             70a   inz
     D pPKPMEN         s              7p 3 inz
     D pUPDATE         s              1S 0 inz

      // internal
      // ______________________________________________________________________
     D status          s            132A   inz
     D breakpoint      s              1a   inz
     D err_msg         s              1a   inz
     D week            s              1s 0 inz
     d NumSysTime      s              6s 0
     d myDate          s               d

     D suffix          s             06A   inz
     D transfer        s             30A   inz
     D string_file     s             60A   inz
     D years           s              4s 0 inz
     D §ENTRY#         s             11A   inz
     D §rkreda         s              8s 0 inz
     D §rplipo         s              4a   inz
     D §rkkon          s             10a   inz
     D §rpnesu         s             13s 2 inz
     D §§rpnesu        s             13s 2 inz
     D §upload         s            256a   inz
     D §monat          s              2s 0 inz
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §records        s              9s 0 inz
     D §text           s             48a   inz
     D §SNDREC         s              3a   inz
     D §PRTNUM         s             35a   inz
     D §MSGTYP         s              6a   inz
     D §MAIKEY         s             35a   inz
     D §HRCLVL         s              9a   inz
     D §LINNUM         s              6s 0 inz
      //Arbeitsvariablen für Steuerung der Verarbeitung
      //------------------------------------------------------------------
      // Letzte Lieferscheinnummer
     d lastLiefNr      s             10a   inz
      // Letzte Paket-ID
     d lastPKIDEN      s             10a   inz
      // Kennzeichen: erster Satz je Kombination?
     d firstForCombo   s               n   inz(*on)

     IPHY01R
     I              status                      §status
      /eject

      /eject
      //************************************************************************
      //          -----------------
      //          M A I N - L I N E
      //          -----------------
      //************************************************************************

      /FREE
       eval status ='Start FTP Transfer for DESADVR      ';

       exsr      SR_log;

       exsr sr_DESADV;
       open  DESADVR300;
       close DESADVR300;

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

       eval status ='Ende  FTP Transfer for DESADVR      ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************
       //**   Subroutine: PROCESS_DESADV_NVE
       //**   Zweck:
       //**   Liest DESADVNVE-Datei und ruft EDIFACTT.STDDAT_PACK_DESADV auf.
       //**   Wenn sich Lieferscheinnummer oder Paket-ID ändern:
       //**      ? Erster Datensatz: Update (mit Parameter 1)
       //**      ? Weitere Datensätze: Insert (ohne Parameter 1)
       //-----------------------------------------------------------------------
       //    Füllen Felder Zieldatei    F
       //-------------------------------------------------------cc--------------

       begsr srinit;

         clear     Wrk.var1;
         clear     status;
         err_msg = ' ';


       //sql handling
            exec sql
                     whenever not found CONTINUE;;
            exec sql
                     WHENEVER SQLWARNING CONTINUE;
            exec sql
                     WHENEVER SQLERROR  CONTINUE;

       endsr;

       //-----------------------------------------------------------------------
       //    DESADV
       //-------------------------------------------------------cc--------------

       begsr sr_DESADV;

       //Funktion DESADVR300
       //Sätze für zusätzliche NVE's auf Eene der Artikelnummer/Verpckung
       exec sql
          insert into tvrelwaeco/DESADVR300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          dec(substr(WRTDAT, 1, 4), 4, 0) LJahr,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
          WHERE HRCLVL ='100000000' and MSGTYP ='DESADV' and
                ( PRTNUM like 'STAHL_DESADV%' or
                  PRTNUM like 'STAHL_DESADV%') and
                  dec(substr(WRTDAT, 1, 4), 4, 0) > 2024
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/DESADVR300 b
          where a.MSGTYP = b.MSGTYP)
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM,
                   dec(substr(WRTDAT, 1, 4), 4, 0);

       //Ladungsträger

       exec sql
          insert into tvrelwaeco/DESADVnve
         SELECT
             PKIDEN, PKMPKN, PKPKNR,
             SUBSTR(PKVENR, 9, 14) AS PKVENR,
             SUM(p.PKPMEN) AS PKPMEN, pkanrp, AKANR1,
             ALKMJJ, ALKMNR, ALKMPO , ALLIJJ, ALLINR,
             ALLIPO, char('  ', 2) statusNVE,
                     current timestamp as tstamp
         FROM
             DOMDATV7.psaveak a
         JOIN
             DOMDATV7.ppaket p
             ON a.AKFIRM = p.PKFIRM
             AND a.AKAPN = p.PKAPN
         JOIN
             tvpf/aflp01     b
             on a.AKANR1 = 'K01' concat ALKMJJ concat ALKMNR
             and pkanrp = ALKMPO
         WHERE
             ALLIJJ = (select lJahr from tvrelwaeco/DESADVR300
                          where ALFIRM='01' and MAIKEY = ALLINR
                                and status='  ')
             and PKIDEN <> ' '
         GROUP BY
             PKIDEN, PKPKNR, PKMPKN, PKVENR, pkanrp, AKANR1,
             ALKMJJ, ALKMNR, ALKMPO , ALLIJJ, ALLINR, ALLIPO
         ORDEr BY
             tstamp, ALLIJJ, ALLINR, PKIDEN;

       exsr PROCESS_DESADV_NVE;

       exec sql
          update TVRELWAECO/DESADVR300 a set status = '10' where
             ljahr concat MAIKEY =  (select allijj concat ALLINR
                       from tvrelwaeco/DESADVnve
                       fetch first 1 row only            )
                and status= ' ';
       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

       begsr sr_log;

         clear p_md;
       //  %Subarr(p_md:01)  = 'GALAXUSR  ';
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
       //log report
       //-----------------------------------------------------------------------

       begsr PROCESS_DESADV_NVE;
          // --- Datei öffnen ---
          open DESADVNVE;

          // Zum Anfang der Datei positionieren
          setll *start DESADVNVE;

          // Ersten Datensatz lesen
          read DESADVNVE DESADVNVE_i;

          dow not %eof(DESADVNVE);
             //------------------------------------------------------------
             // Prüfen, ob neue Kombination (Lieferscheinnummer + PKIDEN)
             //------------------------------------------------------------
             if DESADVNVE_i.ALLINR    = '499965' and
                DESADVNVE_i.statusNVE = '  ';
                if (DESADVNVE_i.ALLINR <> lastLiefNr) or
                   (%trim(DESADVNVE_i.PKIDEN) <> %trim(lastPKIDEN));

                   // Neue Kombination ? erster Datensatz
                   firstForCombo = *on;
                   lastLiefNr = DESADVNVE_i.ALLINR;
                   lastPKIDEN = %trim(DESADVNVE_i.PKIDEN);

                else;
                   // Gleiche Kombination ? weiterer Datensatz
                   firstForCombo = *off;
                endif;

                // Werte übernehmen
                pDatum = %subst(%char(DESADVNVE_i.TSTAMP) : 1 : 4) + // Jahr
                         %subst(%char(DESADVNVE_i.TSTAMP) : 6 : 2) + // Monat
                         %subst(%char(DESADVNVE_i.TSTAMP) : 9 : 2);  // Tag
                pPKVENR = DESADVNVE_i.PKVENR;
                pPKPMEN = DESADVNVE_i.PKPMEN;
                pLiefNr = DESADVNVE_i.ALLINR;
                pPKIDEN = DESADVNVE_i.PKIDEN;

                if firstForCombo;
                    pUPDATE = 1;
                else;
                    pUPDATE = 0;
                endif;

                exec sql
                  call PDESADV(
                     :pLiefNr,
                     :pPKIDEN,
                     :pDatum,
                     :pPKVENR,
                     :pPKPMEN,
                     :pUPDATE );
                lastLiefNr = pLiefNr;
                // Nächsten Datensatz lesen
             endif;
             read DESADVNVE DESADVNVE_i;
          enddo;

          exec sql
            update EDIFACTT.STDDAT a set a.SCDDAT = 'M '
            WHERE
            a.MAIKEY = :pLiefNr
            and a.WRTDAT = :pDatum
            and a.HRCLVL = '100000000';

          // --- Datei schließen ---
          close DESADVNVE;
       ENDSR;
