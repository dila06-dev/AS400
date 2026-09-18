
      //************************************************************************
      //
      //      Programmname       EDCDISPLAY WebService
      //      Erstellt  am       2017       9105306515
      //      Erstellt von       IT Dometic
      //
      */      Beschreibung
      //      http://edc.dometic.com/outbound/
      //      http://edc.dometic.com/inbound-gates/
      //      http://edc.dometic.com/inbound-ppf/
      //
      //      Username: edc@dometic.com
      //      Passwort: mobileLiving2017
      //      _____________________________________________
      //             x        y
      //      MON   +2 Tage                        Mon + Die
      //      DIE   +2 Tage                        Die + Mit
      //      MIT   +2 Tage                        Mit + Don
      //      DON   +2 Tage                        Don + Fri
      //      FRI   +2 Tage + 2 Tage Wochenende    FRI + Mon
      //      SAM   +2 Tage + 2 Tage Wochenende    Mon + Die
      //      SUN   +2 Tage + 2 Tage Wochenende    Mon + Die
      //
      //      wenn 5 aktueller Tag Die = die+mit+don+fri+sam+son+mon
      //      X=tage
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
      //h PGMINFO(*PCML:*Module)

      //------------------------------------------------------------------------
      //    D A T E I - D E F I N I T I O N E N
      //------------------------------------------------------------------------

      // Lieferscheinkopf
     fEDCDISP   uf   e           k disk    RENAME(EDCDISPR:PHY01R)
     f                                     USROPN

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

     Dweek             s              1s 0
     Dx                s              2s 0
     Dadvance          s              2s 0

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
     D P_INFIL         s             21A   inz
     D §RECORDS        s              7  0 inz

       //Übergabe Datenstruktur Screen one Order cut off
     d p_Array1        ds                  qualified dim(06)
     d d_Arg1                        20a   inz                                  Argument
     d d_Soll1                        5s 0 inz                                  Soll
     d d_Ist1                         5s 0 inz                                  Ist
     d d_Delay1                       5s 0 inz                                  Delay
       //Übergabe Datenstruktur Screen two Delivery positions Inbound
     d p_Array2        ds                  qualified dim(06)
     d d_Arg2                        20a   inz                                  Argument
     d d_Soll2                        5s 0 inz                                  Soll
     d d_Ist2                         5s 0 inz                                  Ist
     d d_Delay2                       5s 0 inz                                  Delay
       //Übergabe Datenstruktur Screen three Transport positions Inbound
     d p_Array3        ds                  qualified dim(06)
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

       eval status ='Start Aufbau für EDCDisplay eingeleitet   ';
       exsr      SR_log;

       exec sql
         select  dec(DAYOFWEEK_iso(current date ), 1, 0)
                 into            :week
                 from   qsys2/qsqptabl;

       exsr  sr_screen1;

       exsr  sr_screen2;

       exsr  sr_screen3;

       open  EDCDISP;

       read EDCDISP     EDCDISP_i;
       dow not %eof(EDCDISP);
       //für Web
          if (EDCDISP_i.Aktiv='A') and
             (EDCDISP_i.rrn) > 0   and
             (EDCDISP_i.rrn) < 7;
              EDCDISP_O = EDCDISP_i;
              EDCDISP_o.#DATE      = %date()     ;
              EDCDISP_o.#TIMESTAMP = %timestamp();
              update phy01r   EDCDISP_O;
          endif;
          read EDCDISP  EDCDISP_i;
       enddo;

       close EDCDISP;

       eval status ='Ende Aufbau für EDCDisplay eingeleitet    ';
       exsr      SR_log;

       *inlr = *on;

       //-----------------------------------------------------------------------
       //Screen 1  http://edc.dometic.com/outbound/
       //-----------------------------------------------------------------------

       begsr sr_screen1;

       //for screen one
       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF(''/Lager/Rhenania/CutOff.csv'') ' +
           'TOMBR(''/QSYS.LIB/TVRELWAECO.LIB/CUTOFFIN.FILE/CUTOFFIN.MBR'') ' +
           ' MBROPT(*REPLACE)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMSTMF FROMSTMF    ';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/CUTOFFIN) ' +
           'TOFILE(TVRELWAECO/CUTOFFOUT) ' +
           'MBROPT(*REPLACE) FLDDLM('';'') ' +
           'DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF FROMFILE    ';
          exsr      SR_log;
       endmon;

       //mögliche Fehler herausnehmen
       exec sql
          delete   FROM TVRELWAECO/CUTOFFout WHERE
          (substr(cutofft, 1, 1) <  '0' or substr(cutofft, 1, 1) > '9' ) or
          (substr(cutofft, 1, 2) <  '0' or substr(cutofft, 1, 2) > '9' ) or
          substr(cutofft, 3, 1) <> ':'                                   or
          (substr(cutofft, 1, 4) <  '0' or substr(cutofft, 1, 3) > '4' ) or
          (substr(cutofft, 1, 5) <  '0' or substr(cutofft, 1, 1) > '5' ) or
          aktivkz <> 'A';


       //datbase new for screen 1
       exec sql
          delete  from edcdisp where screen = 1 and aktiv ='T';
       //datbase new for screen 1 current situation output viewing
       exec sql
          INSERT INTO TVRELWAECO/EDCDISP SELECT DISTINCT zoned(1, 1 ),
          zoned(0, 5 ), char('Abholung: ' concat pickupt, 20) , zoned(0, 5),
          zoned(0, 5), zoned(0, 5), char('T', 1) , current date, current
          timestamp FROM TVRELWAECO/CUTOFFOUT WHERE pickupt <> '*no' ORDER BY
          char('Abholung: ' concat pickupt, 20);
       //datbase new for screen 1 current situation
       exec sql
          INSERT INTO TVRELWAECO/EDCDISP
          SELECT DISTINCT zoned(1, 1 ), zoned(0, 5 ), char('Gesamt:  '
                 , 20) , zoned(0, 5), zoned(0, 5), zoned(0, 5), char('T', 1)
          , current date, current timestamp FROM TVRELWAECO/CUTOFFOUT wHERE
          pickupt <> '*no';


       //hier update der übermittelten Steuerdatei
       //Anpassung wegen Wochenende ohne Samstag
       //hier ohne Samstagsarbeit wokz=2
       select;
         when week = 1;
              advance = 7;
              exsr srbankh1;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 5 and wokz =2;
         when week = 2;
              advance = 6;
              exsr srbankh1;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 4 and wokz =2;
         when week = 3;
              advance = 5;
              exsr srbankh1;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 3 and wokz =2;
         when week = 4;
              advance = 4;
              exsr srbankh1;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 2 and wokz =2;
         when week = 5;
              advance = 3;
              exsr srbankh1;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 1 and wokz =2;
         when week = 6;
         when week = 7;
       endsl;

       //hier update der übermittelten Steuerdatei
       //Anpassung wegen Wochenende Samstagsarbeit
       //hier mit Samstagsarbeit wokz=1
       select;
         when week = 1;
              advance = 7;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 6 and wokz =1;
         when week = 2;
              advance = 6;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 5 and wokz =1;
         when week = 3;
              advance = 5;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 4 and wokz =1;
         when week = 4;
              advance = 4;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 3 and wokz =1;
         when week = 5;
              advance = 3;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 2 and wokz =1;
         when week = 6;
              advance = 2;
              exsr srbankh2;
              exec sql
              update TVRELWAECO/CUTOFFout
              set DAYADV = dayadv + wokz + :x
              where aktivkz =  'A' and dayadv > 1 and wokz =1;
         when week = 7;
       endsl;

       //____________________________________________________________________
       //Ermittlung http://edc.dometic.com/outbound/
       //
       §records=*zero;
       exsr sr_cutoff;
       exsr SR_output;

       //neu 12.09.2017 ****************************************
       //http://edc.dometic.com/outbound/
       //Summe: I S T
       exec sql
         update EDCDISP set ist =
         (select count(*) from TVRELWAECO/cutoff
                 where substr(zustand, 1, 4) = '*Ist' and
                       substr("ARG", 11, 6) = PICKUPT)
          where  screen=1 and AKTIV ='T';


       //kleiner oder gleich cutoff in Bezug auf aktuelle Zeit
       //Summe: D e l a y
       exec sql
         update EDCDISP set delay =
         (select count(*) from TVRELWAECO/cutoff
                 where substr(zustand, 1, 6) = '*Delay' and
                       substr("ARG", 11, 6) = PICKUPT)
          where  screen=1 and AKTIV ='T';

       //kleiner oder gleich pickupt in Bezug auf aktuelle Zeit
       //Summe: S o l l
       exec sql
         update EDCDISP set soll  =
         (select count(*) from TVRELWAECO/cutoff
                 where (substr(zustand, 1, 5) = '*Soll' or
                        substr(zustand, 1, 4) = '*Ist' or
                        substr(zustand, 1, 6) = '*Delay' )
                      and substr("ARG", 11, 6) = PICKUPT)
          where  screen=1 and AKTIV ='T';

       //Gesamtanzeigemodus
       //Summe: I s t   (neu)
       exec sql
         update EDCDISP set ist =
         (select count(*) from TVRELWAECO/cutoff
                 where substr(zustand, 1, 4) = '*Ist' or
                       substr(zustand, 1, 8) = '*IstRest')
          where  screen=1 and AKTIV ='T' and
                       substr("ARG", 1, 8) = 'Gesamt: ';

       exec sql
         update EDCDISP set delay =
         (select count(*) from TVRELWAECO/cutoff
                 where substr(zustand, 1, 6) = '*Delay' )
          where  screen=1 and AKTIV ='T' and
                       substr("ARG", 1, 8) = 'Gesamt: ';

       //kleiner oder gleich pickupt in Bezug auf aktuelle Zeit
       //Summe: S o l l  (neu)
       exec sql
         update EDCDISP set soll  =
         (select count(*) from TVRELWAECO/cutoff
                 where substr(zustand, 1, 5) = '*Soll' or
                       substr(zustand, 1, 4) = '*Ist' or
                       substr(zustand, 1, 6) = '*Delay' or
                       substr(zustand, 1, 8) = '*IstRest')
          where  screen=1 and AKTIV ='T' and
                       substr("ARG", 1, 8) = 'Gesamt: ';
       endsr;

       //-----------------------------------------------------------------------
       //Screen 2
       //-----------------------------------------------------------------------

       begsr sr_screen2;

       //____________________________________________________________________
       //for screen two two two two two two
       //http://edc.dometic.com/inbound-gates/
       exec sql  // !!!!!!!!!!!!!!!!!!!!!!!!!!!two two
         update EDCDISP set soll  =
         (select count(*)
                 FROM we_checktr
                 WHERE (((#LBLBLANR ='500' or #LBLBLANR ='510')
                       and DATE100110 = current date - 0 day
                              and DAT100110 <> 0 ))
                       or
                       ((#LBLBLANR ='100' or #LBLBLANR ='110')
                       and DATE100110 = current date - 0 day
                              and DAT100110 <> 0 ))
           where screen=2 and rrn=1 and AKTIV ='A';
       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM = current date + 0 day
                 and DAT100110 =0)
           where screen=2 and rrn=1 and AKTIV ='A';
       exec sql
         update EDCDISP set ist   =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM = current date + 0 day
                 and DAT100110 <>0)
           where screen=2 and rrn=1 and AKTIV ='A';
       exec sql
         update EDCDISP set delay =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM < current date + 1 day
                 and DAT100110 =0)
           where screen=2 and rrn=1 and AKTIV ='A';


       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM = current date + 1 day
                 and DAT100110 =0)
           where screen=2 and rrn=2 and AKTIV ='A';

       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM > current date
                 and DATELFTERM < current date + 5 day
                 and DAT100110 =0)
           where screen=2 and rrn=3 and AKTIV ='A';

       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM we_checktr
                 WHERE #LBLBLANR in ('500', '510')
                 and DATELFTERM > current date
                 and DATELFTERM < current date + 30 day
                 and DAT100110 =0)
           where screen=2 and rrn=4 and AKTIV ='A';

       endsr;

       //-----------------------------------------------------------------------
       //Screen 3
       //-----------------------------------------------------------------------

       begsr sr_screen3;

       //____________________________________________________________________
       //for screen three three three
       //http://edc.dometic.com/inbound-ppf/

       //Soll aus der domdatv7/PBESTTP
       §records=*zero;
       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date)
         where screen=3 and rrn=1 and AKTIV ='A';
       //Soll plus aus der domdatv7/phisttp
       exec sql
         update EDCDISP set soll  = soll +
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date)
         where screen=3 and rrn=1 and AKTIV ='A';

       //IST aus der domdatv7/phisttp erledigte
       exec sql
         update EDCDISP set ist   =
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date)
         where screen=3 and rrn=1 and AKTIV ='A';

       //Delay aus der domdatv7/PBESTTP unerledigte
       exec sql
         update EDCDISP set delay =
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) < current date)
         where screen=3 and rrn=1 and AKTIV ='A';

       //Soll TLS
       //select * from phisttp a
       //where exists(SELECT * FROM ptplhst b WHERE a.tppaln = b.tlpaln)
       //vollpalette tls  vorzone
       §records=*zero;
       exec sql
         update EDCDISP set soll  =
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                       and  tppaln in (select tlpaln from domdatv7/PTPLEIT))
         where screen=3 and rrn=2 and AKTIV ='A';
       //Soll plus aus der domdatv7/phisttp
       exec sql
         update EDCDISP set soll  = soll +
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                       and  tppaln in (select tlpaln from domdatv7/ptplhst))
         where screen=3 and rrn=2 and AKTIV ='A';

       //IST  TLS
       exec sql
         update EDCDISP set ist   =
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                       and  tppaln in (select tlpaln from domdatv7/ptplhst))
         where screen=3 and rrn=2 and AKTIV ='A';

       //Delay TLS
       exec sql
         update EDCDISP set delay =
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) < current date
                       and  tppaln in (select tlpaln from domdatv7/PTPLEIT))
         where screen=3 and rrn=2 and AKTIV ='A';

       //offene Kundenaufträge
       §records=*zero;
       exec sql
         update EDCDISP set SOLL =
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                            and substr(tpanr1, 1, 3) ='K01'               )
         where screen=3 and rrn=3 and AKTIV ='A';
       exec sql
         update EDCDISP set SOLL = Soll +
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                            and substr(tpanr1, 1, 3) ='K01'               )
         where screen=3 and rrn=3 and AKTIV ='A';

       exec sql
         update EDCDISP set IST  =
         (select count(*)
                 FROM  domdatv7/phisttp
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) = current date
                            and substr(tpanr1, 1, 3) ='K01'               )
         where screen=3 and rrn=3 and AKTIV ='A';

       §records=*zero;
       exec sql
         update EDCDISP set delay=
         (select count(*)
                 FROM  domdatv7/PBESTTP
                 where tpFIRM  ='DWI'  and tpkonz  = 'EMS' and
                       date(substr(char(tpDTa ), 1, 4) concat '-' concat
                            substr(char(tpDTa ), 5, 2) concat '-' concat
                            substr(char(tpDTa ), 7, 2)) < current date
                            and substr(tpanr1, 1, 3) ='K01'               )
         where screen=3 and rrn=3 and AKTIV ='A';

       endsr;
       //-----------------------------------------------------------------------
       //log report cutoff zum recherchieren
       //-----------------------------------------------------------------------

       begsr sr_cutoff;

       MONITOR;
       Wrk.var1 =
           'CLRPFM FILE(TVRELWAECO/cutoff)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CLRPFM successful FILE(TVRELWAECO/cutoff)        ';
       on-error;
          status='Error by clrpfm object (TVRELWAECO/cutoff)       ';
       endmon;

       //*ist ( sind erledigt )
       //     aus DOMDATV7/PSAVEak, DOMDATV7/PSAVEap
       exec sql
            insert into TVRELWAECO/cutoff
            SELECT AKDTDF,AKTIDF,akanr1,akvart,aklakz,akra13 LieferDat,
                   APGKZ,APTOUR,APDTB,APIDEN,APANRP,LND,LNDNR,VSB,VSBNAME,
                   CUTOFFT,WODAY, ADVICE,PICKUPT,WODAYOICK,FORWARDER, DAYADV,
                   WOKZ weekend, bereich,
                   char('*Ist', 10) zustand ,current timestamp tstamp
            FROM  DOMDATV7/PSAVEak, DOMDATV7/PSAVEap, CUTOFFOUT
            where AKFIRM ='DWI'   and AKAPN   = APAPN   and
                  substr(AKANR1, 1, 1)        = 'K'     and
                  AKVART  = vsb   and LNDKZ   = AKLAKz  and  APTOUR = TOUR and
                  AKTIVKZ ='A'    and  SCREEN1 = 1      and
                  AKSTS1 <>'2'    and  APIDEN <>'ENDE'  and
                  AKKGEW < 1000   and
       //*Lieferdatum kleiner (aktuells Datum + Referenztage)
                  date(substr(char(AKRA13), 1, 4) concat '-' concat
                       substr(char(AKRA13), 5, 2) concat '-' concat
                       substr(char(AKRA13), 7, 2)) < current date
                       + DAYADV  day   and
                  date(date (date(substr(AKDTE , 1, 4)
                  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
                  substr(AKDTE, 7, 2)))) = current date - 000 day;

       //*Referenzen zu cutoffout: vsb, landkz, aktivkz='A',screen
       //*soll ( Können noch geändert werden, erst alle aufnehmen, die
       //        nicht erledigt sind. )
       exec sql
            insert into TVRELWAECO/cutoff
            SELECT AKDTDF,AKTIDF,akanr1,akvart,aklakz,akra13 LieferDat,
                   APGKZ,APTOUR,APDTB,APIDEN,APANRP,LND,LNDNR,VSB,VSBNAME,
                   CUTOFFT,WODAY, ADVICE,PICKUPT,WODAYOICK,FORWARDER, DAYADV,
                   WOKZ weekend, bereich,
                   char('*Soll ', 10) zustand ,current timestamp tstamp
            FROM  DOMDATV7/PANFKOP, DOMDATV7/PANFpos, CUTOFFOUT
            where AKFIRM  ='DWI'  and AKAPN   = APAPN   and
                  substr(AKANR1, 1, 1)        = 'K'     and
                  AKVART  = vsb   and LNDKZ   = AKLAKz  and APTOUR = TOUR and
                  AKTIVKZ ='A'    and  SCREEN1 = 1      and
                  AKSTS1 <>'2'    and  APIDEN <>'ENDE'  and
                  AKKGEW < 1000;

       //*delay
       exec sql
            update TVRELWAECO/cutoff set zustand = '*DelaySoll*'
            where   zustand = '*Soll   '
       //*delay nur wenn Liefertermin in range area
       //     ( (date(substr(char(LieferDat), 1, 4) concat '-' concat
       //             substr(char(LieferDat), 5, 2) concat '-' concat
       //             substr(char(LieferDat), 7, 2)) < current date
       //             - DAYADV  day)                               or
       //      ((date(substr(char(LieferDat), 1, 4) concat '-' concat
       //             substr(char(LieferDat), 5, 2) concat '-' concat
       //             substr(char(LieferDat), 7, 2)) = current date
       //             - DAYADV  day) and
       //              current time > time(PICKUPT))          )
       //*delay nur wenn Auftrag zeitgemäß vorlag!
                 and ((date(substr(char(AKDTDF), 1, 4) concat '-' concat
                            substr(char(AKDTDF), 5, 2) concat '-' concat
                            substr(char(AKDTDF), 7, 2)) < current date ) or
                      (date(substr(char(AKDTDF), 1, 4) concat '-' concat
                            substr(char(AKDTDF), 5, 2) concat '-' concat
                            substr(char(AKDTDF), 7, 2)) = current date  and
                        substr(char(digits(AKTIDF)), 1, 2) concat ':' concat
                        substr(char(digits(AKTIDF)), 3, 2) > time(CUTOFFT))
                     );

       //*IstRest ==> aus DOMDATV7/PANFKOP a, DOMDATV7/PANFpos
       //             üver Referenznummer
       exec sql
            insert into tvrelwaeco/cutoff
            SELECT AKDTDF,AKTIDF,akanr1,akvart,aklakz,akra13 LieferDat,
                   APGKZ,APTOUR,APDTB,APIDEN,APANRP,
                   char(' ', 40) lnd, char(' ', 3) LNDNR,akvart,
                   char('undefined', 06) VSBNAME, char ('      ', 06) CUTOFFT,
                   char(' ', 01) WODAY  , char('      ', 06) ADVICE,
                   char('*no ', 06) PICKUPT, char(' ', 01) WODAYOICK,
                   char('*alle ', 40) forwarder,  zoned(0, 2, 0) DAYADV,
                   zoned(0, 1, 0) weekend,        char('*alle ', 25) bereich,
                   char('*Rest ', 10) zustand ,current timestamp tstamp
            FROM  DOMDATV7/PANFKOP a, DOMDATV7/PANFpos
            where AKFIRM  ='DWI'  and AKAPN   = APAPN   and
                  substr(AKANR1, 1, 1)        = 'K'     and
                  AKSTS1 <>'2'    and  APIDEN <>'ENDE'  and
                  a.akanr1 not in (select b.akanr1 from cutoff b);

       //*IstRest ==> aus DOMDATV7/PSAVEak a, DOMDATV7/PSAVEap
       //*            und unlängst erledigt
       exec sql
            insert into TVRELWAECO/cutoff
            SELECT AKDTDF,AKTIDF,akanr1,akvart,aklakz,akra13 LieferDat,
                   APGKZ,APTOUR,APDTB,APIDEN,APANRP,
                   char(' ', 40) lnd, char(' ', 3) LNDNR,akvart,
                   char('undefined', 06) VSBNAME, char ('      ', 06) CUTOFFT,
                   char(' ', 01) WODAY  , char('      ', 06) ADVICE,
                   char('*no ', 06) PICKUPT, char(' ', 01) WODAYOICK,
                   char('*alle ', 40) forwarder,  zoned(0, 2, 0) DAYADV,
                   zoned(0, 1, 0) weekend, char('*alle ', 25) bereich,
                   char('*IstRest ', 10) zustand ,current timestamp tstamp
            FROM  DOMDATV7/PSAVEak a, DOMDATV7/PSAVEap
            where AKFIRM  ='DWI'  and AKAPN   = APAPN   and
                  substr(AKANR1, 1, 1)        = 'K'     and
                  AKSTS1 <>'2'    and  APIDEN <>'ENDE'  and
                  a.akanr1 not in (select b.akanr1 from cutoff b) and
       //         date(substr(char(AKRA13), 1, 4) concat '-' concat
       //              substr(char(AKRA13), 5, 2) concat '-' concat
       //              substr(char(AKRA13), 7, 2)) < current date
       //              and
                  date(date (date(substr(AKDTE , 1, 4)
                  concat '-' concat substr(AKDTE, 5, 2) concat '-' concat
                  substr(AKDTE, 7, 2)))) = current date - 000 day;

       //*Ü b e r s c h r e i b u n g e n
       //*Soll auf *rest wenn:
       //* c > h + f
       //* LIEFERDAT > Eingangsdatum + Auslagerungstage
       //* von *Soll auf *Rest
       exec sql
            update TVRELWAECO/cutoff set zustand = '*RestSoll1'
                                            WHERE ZUSTAND ='*Soll'
            and (date(substr(char(LieferDat), 1, 4) concat '-' concat
                      substr(char(LieferDat), 5, 2) concat '-' concat
                      substr(char(LieferDat), 7, 2)))
                                                                >
                      date(tstamp + dayadv day );


       //*Soll auf *rest wenn:
       //* a = h and c <(a+h) and (b>d)
       //* timestamp=Eingangsdatum +
       //* LIEFERDAT < (Eingangsdatum + Auslagerungstage)
       //* Uhrzeit Einlieferung>time cutoff
       //* von *Soll auf *Rest
       exec sql
            update TVRELWAECO/cutoff set zustand = '*RestSoll2'
                           WHERE ZUSTAND ='*Soll' and date(tstamp)=
                 date(substr(char(AKDTDF), 1, 4) concat '-' concat
                      substr(char(AKDTDF), 5, 2) concat '-' concat
                      substr(char(AKDTDF), 7, 2))
            and  (date(substr(char(LieferDat), 1, 4) concat '-' concat
                       substr(char(LieferDat), 5, 2) concat '-' concat
                       substr(char(LieferDat), 7, 2)))
                                                                <
                 (date(substr(char(AKDTDF), 1, 4) concat '-' concat
                       substr(char(AKDTDF), 5, 2) concat '-' concat
                       substr(char(AKDTDF), 7, 2)) + dayadv day )
            and (time(substr(char(digits(AKTIDF)), 1, 2) concat ':' concat
                      substr(char(digits(AKTIDF)), 3, 2)) > time(CUTOFFT));


       //* timestamp=Eingangsdatum +
       //* LIEFERDAT < (Eingangsdatum + Auslagerungstage)
       //* Uhrzeit Einlieferung>time cutoff
       //* von *Soll auf *Delay
       exec sql
            update TVRELWAECO/cutoff set zustand = '*DelaySoll'
                           WHERE ZUSTAND ='*Soll' and time(tstamp)>
                                                      time(PICKUPT) ;


       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_sicher;

       endsr;

       //-----------------------------------------------------------------------
       //Feiertage in Berechnung?
       //-----------------------------------------------------------------------

       begsr SRbankh1;
           x=0;
           exec sql
              SELECT sum(de) into :x FROM calender
              WHERE ($DATE > current date - 1 day)
                     and ($DATE < current date + :advance day)
                     and $DOWISO not in( 6, 7);
       endsr;

       //-----------------------------------------------------------------------
       //Feiertage in Berechnung inklusive Samstag
       //-----------------------------------------------------------------------

       begsr SRbankh2;
           x=0;
           exec sql
              SELECT sum(de) into :x FROM calender
              WHERE ($DATE > current date - 1 day)
                     and ($DATE < current date + :advance day)
                     and $DOWISO not in(7);
       endsr;

       //-----------------------------------------------------------------------
       //report
       //-----------------------------------------------------------------------

       begsr SR_output;

         eval p_infil   =  'CUTOFF_'        +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
         eval p_outfil =  'CUTOFF';

         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_lib     =  'TVRELWAECO';

         clear     Wrk.var1;
         clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Lager/Rhenania/CUTOFF_*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed /Lager/Rhenania/CUTOFF_*';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object /Lager/Rhenania/CUTOFF_*';
          exsr      SR_log;
       endmon;

       eval p_outfil  =  'CUTOFF   ';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done                           ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object CUTOFF                    ';
          exsr      SR_log;
       endmon;
       eval p_outfil  =  'CUTOFF';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='chgaut successful FILE(TVRELWAECO/cutoff)        ';
       on-error;
          status='Error by chgaut object (TVRELWAECO/cutoff)       ';
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
