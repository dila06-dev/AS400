
      //************************************************************************
      // SELECT
      //     PKIDEN,
      //     PKMPKN,
      //     PKPKNR,
      //     SUBSTR(PKVENR, 9, 14) AS PKVENR,
      //     SUM(p.PKPMEN) AS PKPMEN, pkanrp, AKANR1,
      //     ALKMJJ, ALKMNR, ALKMPO , ALLIJJ, ALLINR,
      //     ALLIPO
      // FROM
      //     DOMDATV7.psaveak a
      // JOIN
      //     DOMDATV7.ppaket p
      //     ON a.AKFIRM = p.PKFIRM
      //     AND a.AKAPN = p.PKAPN
      // JOIN
      //     tvpf/aflp01     b
      //     on a.AKANR1 = 'K01' concat ALKMJJ concat ALKMNR
      //     and pkanrp = ALKMPO
      // WHERE
      //     ALLIJJ=???? and ALLINR=????   and ALFIRM='01' and
      //     PKIDEN <> ' '
      // GROUP BY
      //     PKIDEN, PKPKNR, PKMPKN, PKVENR, pkanrp, AKANR1,
      //     ALKMJJ, ALKMNR, ALKMPO , ALLIJJ, ALLINR, ALLIPO
      // ORDER BY
      //     PKIDEN
      //
      //      Programmname       AKTIVBANKR
      //      Erstellt  am       08.10.2020
      //      Erstellt von       M.Gang
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
      // sonstiges check
      // ===============
      // SELECT * FROM Bar_edi/aktivbank
      //
      // SELECT maikey, a14#1 , a14#2, a14#4,hrclvl, XEORF FROM stddat WHERE
      // maikey='2020206875' and hrclvl= '100000000'
      //
      // update  edifact/stddat set xeorf='X'
      // WHERE (PRTNUM like '%DE_MARKANT%'
      // or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP ='INVOIC' and UPDDAT
      // ='20220722' and HRCLVL = '100000000'
      //
      // SELECT * FROM edifact/stddat a WHERE (PRTNUM like '%DE_MARKANT%' or
      // PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP ='INVOIC' and UPDDAT
      // ='20220722' and HRCLVL='100000000' and a.maikey in (select b.maikey
      // from HRCLVL1300 b )
      //
      // update               edifact/stddat a set   SCDDAT = '        ',
      //  USERNM = 'HRCLVLZUAB'                WHERE (PRTNUM like
      // '%DE_MARKANT%' or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP
      // ='INVOIC' and UPDDAT ='20220721' and HRCLVL='100000000' and
      // a.maikey in (select b.maikey from HRCLVL1300 b )
      // 7 Zeilen in STDDAT in EDIFACT aktualisiert.
      //
       //Umstellung 21.07.2022
      // update               edifact/stddat a set   SCDDAT = '        ',
      //  USERNM = 'HRCLVLZUAB'                WHERE (PRTNUM like
      // '%DE_MARKANT%' or PRTNUM like 'MARKANT_RECHNUNG%') and MSGTYP
      // ='INVOIC' and UPDDAT >'20220721' and HRCLVL='100000000' and
      // a.maikey in (select b.maikey from HRCLVL1300 b )
      // 77 Zeilen in STDDAT in EDIFACT aktualisiert.
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  insert into  tvrelwaeco/afrkstddat
      //  select RKRGJJ, RKRGNR, sum(RKERG1*0), sum(RKERG2*0),
      //                         sum(RKERG3*0), sum(RKERG4*0)
      //           from afrk01
      //           where rkfirm='01' and RKERG1 > 0 and rkrgnr='162858'and
      //                 (RkRGJJ concat RKRGNR) in
      //                 ( select maikey from       stddat
      //                   where a3#01 ='A' )
      //           group by RKRGJJ, RKRGNR
      //
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  SELECT * FROM HRCLVL1300 ORDER BY ERRORTYP, maikey
      ///Umstellung 21.07.2022  wenn Datei gebraucht wird
      //  SELECT HRCLVL1300.SNDREC, HRCLVL1300.PRTNUM, HRCLVL1300.MSGTYP,
      //  HRCLVL1300.MAIKEY, HRCLVL1300.HRCLVL, HRCLVL1300.LINNUM,
      //  HRCLVL1300.ANZAHL, HRCLVL1300.STATUS, HRCLVL1300.ERRORTYP,
      //  HRCLVL1300.TSTAMP, STDDAT.UPDDAT, STDDAT.WRTTIM, STDDAT.WRTDAT,
      //  STDDAT.USERNM, STDDAT.XEORF, STDDAT.SCDDAT FROM HRCLVL1300,
      //  edifact/stddat WHERE HRCLVL1300.MAIKEY = STDDAT.MAIKEY and
      //  STDDAT.HRCLVL ='100000000' ORDER BY ERRORTYP , rrn(HRCLVL1300)
      //
      //  update  afrk01 set RKST02= '10' where RKFIRM ='01' and
      //  RKRGJJ =2021 and RKRGNR ='163392'
      //
      //  SELECT * FROM stddat WHERE ( HRCLVL ='130000000' and MSGTYP =
      //  'INVOIC' ) and HRCLVL  ='130000000' and np3#1 <> 0
      //  and prtnum=        'EZ_MARKANT_RECHNUNG'
      ///Fehler gemeldet! 08.08.2022 #
      //  update EDIFACT/stddat set np3#1 =  0
      //  WHERE (HRCLVL ='130000000' and MSGTYP = 'INVOIC' and np3#1 <> 0)
      //  update tvrelwaeco/HRCLVL1300 set status= '  '
      //  WHERE MAIKEY = '2019617116'
      ///Beispiel Aktivbank ab datum bei invoices
      //  update EDIFACT/stddat set SCDDAT = 'NEU     '
      //                       WHERE PRTNUM like 'AKTIVBANK_SELECT%' and
      //  msgtyp='INVOIC' and wrtdat>'20220830' and hrclvl='100000000'
      ///log file sehen
      //  SELECT * FROM job_run WHERE JOBDESC like '%BARTRR3%'
      ///italienjob wiederholung
      //  delete tvrelwaeco/i55_match  WHERE KLRGNR ='149844' and KLRGJJ =2022
      //  delete edifacT/stddat WHERE maikey='2022246283'
      //  delete tvrelwaeco/HRCLVL1300 wherE maikey='2022246283'
      //  update  afrk01 set RKST02= '10' where
      //  RKFIRM ='01' and RKRGJJ =2022 and RKRGNR ='246283'
      //   CALL       PGM(TVPP/TRED70SJ) PARM('MODWAO' '01' 'EA'
      //                '          ' '175000')
      //  danach unbedingt signoff
      //  wieder anmelden und call aktivbankr
      //  alternativ debugger:    STRDBG PGM(AKTIVBANKR) und
      //                          mit F6 breakpoint(s) setzen und verlassen
      //                          anschliessend call aktivbankr
      //                          jederzeit Abbruch mit f3 möglich
      //                          am Ende ENDDBG
      ///Protokolle:
      ///select * from Bar_edi/aktivbank
      ///select * from tvrelwaeco/i55_match
      ///select * from tvrelwaeco/HRCLVL1300
      ///
      ///
      ///Anforderung NVE in a70#15 schreiben (Ticket: #INC-233319)
      ///
      ///Festellung, wann die Messages erzeugt werden
      ///SELECT MSGTYP , WRTDAT, WRTDAT,max(WRTTIM), max(WRTDAT) FROM stddat
      ///WHERE wrtdat > '20231100' and msgtyp <> 'ORDERS' GROUP BY MSGTYP,
      ///wrtdat ORDER BY MSGTYP , WRTDAT
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

     fHRCLVL130luf   e           k DISK    usropn
     f                                     RENAME(HRCLVL1300:PHY01R)

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


       // define files
       // ______________________________________________________________________
     d HRCLVL130l_i  e ds                  ExtName(HRCLVL130l:*input)
     d                                     Qualified

     d HRCLVL130l_o  E DS                  ExtName(HRCLVL130l:*output)
     d                                     Qualified

     d HRCLVL130l_k  E DS                  ExtName(HRCLVL130l:*key)
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
       eval status ='Start FTP Transfer for AKTIVBANKR   ';

       exsr      SR_log;
       //exsr HRCLVL1300;

       //LF-Nr. beim KD (Kunden, Werk <- Debitor)
       //Markant Igloo
       //In Bezug auf LfNr übergibt Trend immer den Standard
       //Standard = Kundenstamm KUND
       //Wenn nicht Standard dann aus Debitor-Werk Zuordnung (KDDB)
       exec sql
       update edifact/stddat a set a.a17#1 =
       (select b.KDDBLFBK from TVPF/kddb01 b where
         b.KDDBKDNR = a.a35#09 and b.KDDBLFBK <> ' ' and
         b.KDDBWKNR = '010' and b.KDDBFIRM = '01' and
         a.a35#01   = '7315090000001'
         and (
         a.PRTNUM   like 'OBI_RECHNUNG%' or
         a.PRTNUM   = 'DE_MARKANT_METRO_RECHNUNG'
         ) and
         a.HRCLVL   = '100000000' and a.SCDDAT <> 'Yce')
       where exists
       (select b.KDDBLFBK from TVPF/kddb01 b where
         b.KDDBKDNR = a.a35#09 and b.KDDBLFBK <> ' ' and
         b.KDDBWKNR = '010' and b.KDDBFIRM = '01' and
         a.a35#01   = '7315090000001'
         and (
         a.PRTNUM  like 'OBI_RECHNUNG%' or
         a.PRTNUM  = 'DE_MARKANT_METRO_RECHNUNG'
         ) and
         a.HRCLVL   = '100000000' and a.SCDDAT <> 'Yce');

       //Urspungsland Update
        exec sql
        update edifact/stddat a set a.a3#32 =
        (select b.TEURLD from TVPF/TEIL01 b
         where a.a35#02 = b.TETENR
         and b.TEFIRM = '01'
         and (a.PRTNUM = 'VOLVO_RECHNUNG' OR
              a.PRTNUM = 'DAF_RECHNUNG'
              )
         and a.MSGTYP = 'INVOIC' and a.HRCLVL = '150000000'
         and a.a3#32 = '' and WRTDAT > '20240208')
         where exists (
         select b.TEURLD from TVPF/TEIL01 b
         where a.a35#02 = b.TETENR
         and b.TEFIRM = '01'
         and (a.PRTNUM = 'VOLVO_RECHNUNG' OR
              a.PRTNUM = 'DAF_RECHNUNG'
              )
         and a.MSGTYP = 'INVOIC' and a.HRCLVL = '150000000'
         and a.a3#32 = '' and WRTDAT > '20240208'
         );

       //For HDx only, set a35#09(HDx-LS) to a35#12
         exec sql
         UPDATE EDIFACT/STDDAT A SET A.A35#12 = (
         SELECT B.A35#09 FROM EDIFACT/STDDAT B
          WHERE A.MAIKEY = B.MAIKEY AND A.HRCLVL = B.HRCLVL
           AND  A.PRTNUM = B.PRTNUM AND ( A.PRTNUM = 'VOLVO_RECHNUNG' )
           AND  A.HRCLVL = '150000000'
           AND  A.MAIKEY IN ((
          SELECT C.MAIKEY FROM EDIFACT/STDDAT C WHERE A.MAIKEY = C.MAIKEY
           AND  A.PRTNUM = C.PRTNUM
           AND  A.MSGTYP = C.MSGTYP
           AND  A.WRTDAT = C.WRTDAT
           AND  C.SCDDAT <> 'Yce'
           AND  C.HRCLVL = '100000000')))
         WHERE EXISTS (
         SELECT B.A35#09 FROM EDIFACT/STDDAT B
          WHERE A.MAIKEY = B.MAIKEY AND A.HRCLVL = B.HRCLVL
           AND  A.PRTNUM = B.PRTNUM AND ( A.PRTNUM = 'VOLVO_RECHNUNG' )
           AND  A.HRCLVL = '150000000'
           AND  A.MAIKEY IN ((
          SELECT C.MAIKEY FROM EDIFACT/STDDAT C WHERE A.MAIKEY = C.MAIKEY
           AND  A.PRTNUM = C.PRTNUM
           AND  A.MSGTYP = C.MSGTYP
           AND  A.WRTDAT = C.WRTDAT
           AND  C.SCDDAT <> 'Yce'
           AND  C.HRCLVL = '100000000')));

       //INVOIC LIEFERADRESSE
        exec sql
        update edifact/stddat a
        set (a.a3#32, a.a11#2, a.a70#09, a.a70#11, a.a70#12) =
        ( select b.ADPOLD, b.ADPOLZ, b.ADNAM1, b.ADWORT, b.ADSTRA
        from TVPF/afad02 b where
        a.a35#09 = b.ADKDNR and b.ADFIRM = '01'
        and a.a35#14 = b.ADAFNR and B.ADAART = 'ADVS'
        and b.ADAFJJ = substr(a.MAIKEY, 1, 4) and a.HRCLVL = '100000000'
        and (
        a.PRTNUM = 'VOLVO_RECHNUNG' OR
        a.PRTNUM = 'COOLBLUE_RECHNUNG' OR
        a.PRTNUM = 'SCANIA_RECHNUNG' OR
        a.PRTNUM = 'GALAXUS_RECHNUNG'
        )
        and a.MSGTYP = 'INVOIC'
        and a.a3#32='' and a.a11#2='' and a.a70#09='' and a.a70#11=''
        and a.SCDDAT <> 'Yce'
        )
        where exists (
        select b.ADPOLD, b.ADPOLZ, b.ADNAM1, b.ADWORT, b.ADSTRA
        from TVPF/afad02 b where
        a.a35#09 = b.ADKDNR and b.ADFIRM = '01'
        and a.a35#14 = b.ADAFNR and B.ADAART = 'ADVS'
        and b.ADAFJJ = substr(a.MAIKEY, 1, 4) and a.HRCLVL = '100000000'
        and (
        a.PRTNUM = 'VOLVO_RECHNUNG' OR
        a.PRTNUM = 'COOLBLUE_RECHNUNG' OR
        a.PRTNUM = 'SCANIA_RECHNUNG' OR
        a.PRTNUM = 'GALAXUS_RECHNUNG'
        )
        and a.MSGTYP = 'INVOIC'
        and a.a3#32='' and a.a11#2='' and a.a70#09='' and a.a70#11=''
        and a.SCDDAT <> 'Yce'
        );


       //INVOIC RECHNUNGSDATEN aus dem Auftrag (Rechnungskunde)
       //KD-Auftrags-Adresse AFAD, Ländercode
        exec sql
        UPDATE EDIFACT.STDDAT A SET A3#31 = (
         SELECT B.ADPOLD FROM TVPF.AFAD02 B
         WHERE
         B.ADFIRM = '01' AND
         A.A35#14 = B.ADAFNR AND
         B.ADAART = 'ADRE' AND
         B.ADAFJJ = SUBSTR( A.MAIKEY, 1, 4 ) AND
         A.HRCLVL = '100000000' AND (
         A.PRTNUM = 'VOLVO_RECHNUNG' OR
         A.PRTNUM = 'COOLBLUE_RECHNUNG' OR
         A.PRTNUM = 'SCANIA_RECHNUNG' OR
         A.PRTNUM = 'XXXXX_RECHNUNG'
         ) AND
         A.MSGTYP = 'INVOIC' AND
         A.SCDDAT <> 'Yce')
         WHERE  EXISTS(
         SELECT B.ADPOLD FROM TVPF.AFAD02 B
         WHERE
         B.ADFIRM = '01' AND
         A.A35#14 = B.ADAFNR AND
         B.ADAART = 'ADRE' AND
         B.ADAFJJ = SUBSTR( A.MAIKEY, 1, 4 ) AND
         A.HRCLVL = '100000000' AND (
         A.PRTNUM = 'VOLVO_RECHNUNG' OR
         A.PRTNUM = 'COOLBLUE_RECHNUNG' OR
         A.PRTNUM = 'SCANIA_RECHNUNG' OR
         A.PRTNUM = 'XXXXX_RECHNUNG'
         ) AND
         A.MSGTYP = 'INVOIC' AND
         A.SCDDAT <> 'Yce');


       //INVOIC UPDATE LOCAL CURRENCY for UK
       //Created at 08.05.2024
        exec sql
        update edifact/stddat a set (a.np3#6, a.np3#1) =
        (select DECIMAL((b.RKMWS1/c.WAKURS), 9, 2), '20.00'
          from TVPF/AFRK01 b, TVPF/WAEH01 c where
          b.RKREDA >= c.WAGADA and b.RKFIRM = c.WAFIRM
          and (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
          and b.RKFIRM = '01' and c.WAKURS > 0
          and b.RKMWS1 > 0 and a.MSGTYP = 'INVOIC'
          and a.HRCLVL = '100000000' and a.SCDDAT <> 'Yce'
          and b.RKREDA > '20240514' and b.RKRGJJ > '2023'
          and c.WAWACD = 'GBP' and a.PRTNUM like 'AMAZON_RE_UK%'
          and c.WAGADA =
          (select e.WAGADA from TVPF/AFRK01 d, TVPF/WAEH01 e where
          d.RKREDA >= e.WAGADA and d.RKFIRM = e.WAFIRM and
          b.RKRGNR = d.RKRGNR and b.RKRGJJ = d.RKRGJJ and
          c.WAWACD = e.WAWACD
          order by e.WAGADA desc
          FETCH FIRST 1 ROW ONLY))
        where exists
        (select DECIMAL((b.RKMWS1/c.WAKURS), 9, 2), '20.00'
          from TVPF/AFRK01 b, TVPF/WAEH01 c where
          b.RKREDA >= c.WAGADA and b.RKFIRM = c.WAFIRM
          and (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
          and b.RKFIRM = '01' and c.WAKURS > 0
          and b.RKMWS1 > 0 and a.MSGTYP = 'INVOIC'
          and a.HRCLVL = '100000000' and a.SCDDAT <> 'Yce'
          and b.RKREDA > '20240514' and b.RKRGJJ > '2023'
          and c.WAWACD = 'GBP' and a.PRTNUM like 'AMAZON_RE_UK%'
          and c.WAGADA =
          (select e.WAGADA from TVPF/AFRK01 d, TVPF/WAEH01 e where
          d.RKREDA >= e.WAGADA and d.RKFIRM = e.WAFIRM and
          b.RKRGNR = d.RKRGNR and b.RKRGJJ = d.RKRGJJ and
          c.WAWACD = e.WAWACD
          order by e.WAGADA desc
          FETCH FIRST 1 ROW ONLY));

       //INVOIC Update Artikelnummer des Kaeufers 06.08.2024
       //KD-Produkt-Information Feld KPIDEN (KD-Ident-Nr)
       exec sql
       update EDIFACT/STDDAT a set a.A35#03 = (
         select distinct b.KPIDEN from TVPF.KPIF b
           where b.KPTENR = a.a35#02 and b.KPFIRM = '01'
              and a.MSGTYP = 'INVOIC' and a.HRCLVL = '150000000'
              and a.a35#02 <> ' ' and b.KPIDEN <> ' '
              and a.a35#03 = ' ' and a.MAIKEY in (
              select c.MAIKEY from EDIFACT/STDDAT c
           where b.KPKDNR = c.a35#09  and a.MAIKEY = c.MAIKEY and
              a.MSGTYP = c.MSGTYP and a.WRTDAT = c.WRTDAT and
              c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'))
        where exists (
          select distinct b.KPIDEN from TVPF.KPIF b
           where b.KPTENR = a.a35#02 and b.KPFIRM = '01'
              and a.MSGTYP = 'INVOIC' and a.HRCLVL = '150000000'
              and a.a35#02 <> ' ' and b.KPIDEN <> ' '
              and a.a35#03 = ' ' and a.MAIKEY in (
              select c.MAIKEY from EDIFACT/STDDAT c
            where b.KPKDNR = c.a35#09  and a.MAIKEY = c.MAIKEY and
               a.MSGTYP = c.MSGTYP and a.WRTDAT = c.WRTDAT and
               c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'));


       //IGLOO hole aus dem Kundenauftrag
       //INVOIC Update Artikelnummer des Kaeufers 04.09.2024
       //AFEP01 Auftragsposition
       //Voraussetzung Auftragsnummer in a35#14 und Kund-Teil-Nr werden
       //per EDI übertragen und stehen in AFEP
         exec sql
         update EDIFACT/STDDAT a set a.A35#03 = (
              select e.AFEPIDEN  from (
                select b.AFEPIDEN, b.AFEPEANR, b.AFEPTENR, c.MAIKEY,
                       c.MSGTYP, c.WRTDAT
                from TVPF/afep01 b, edifact/stddat c where
                b.AFEPAFNR = c.a35#14 and c.MSGTYP = 'INVOIC'
                and b.AFEPAFJJ = substr(c.WRTDAT, 1, 4)
                and c.HRCLVL = '100000000' and c.a35#01 = '7315090000001'
                and c.a35#14 <> ' ' and b.AFEPIDEN <> ' '
                and b.AFEPFIRM = '01' and c.SCDDAT <> 'Yce'
              ) e
              where
              a.MAIKEY = e.MAIKEY and a.MSGTYP = e.MSGTYP and
              e.AFEPEANR <> ' ' and
              a.WRTDAT = e.WRTDAT and a.HRCLVL = '150000000')
         where exists (
              select e.AFEPIDEN  from (
                select b.AFEPIDEN, b.AFEPEANR, b.AFEPTENR, c.MAIKEY,
                       c.MSGTYP, c.WRTDAT
                from TVPF/afep01 b, edifact/stddat c where
                b.AFEPAFNR = c.a35#14 and c.MSGTYP = 'INVOIC'
                and b.AFEPAFJJ = substr(c.WRTDAT, 1, 4)
                and c.HRCLVL = '100000000' and c.a35#01 = '7315090000001'
                and c.a35#14 <> ' ' and b.AFEPIDEN <> ' '
                and b.AFEPFIRM = '01' and c.SCDDAT <> 'Yce'
                ) e
                where
                a.MAIKEY = e.MAIKEY and a.MSGTYP = e.MSGTYP and
                e.AFEPEANR <> ' ' and
                a.WRTDAT = e.WRTDAT and a.HRCLVL = '150000000'
         );


       //INVOIC Update
       //MEDIA MARKT => EMPFÄNGER GLN AUS EDI AUFTRAG
       //DILA 29.04.2025
          exec sql
          UPDATE EDIFACT.STDDAT A
          SET A.A35#02 = (
              SELECT B.EKILNR
              FROM TVPF.AFED01 B
              WHERE
                  B.EKAFNR = A.A35#14 AND
                  B.EKAFJJ = SUBSTR(A.WRTDAT, 1, 4) AND
                  B.EKFIRM = '01' AND
                  B.EKILNR <> ' '
              FETCH FIRST 1 ROW ONLY
          )
          WHERE
              A.A35#01 = '7315090000001' AND
                  A.MSGTYP = 'INVOIC' AND
                  A.HRCLVL = '100000000' AND
                  A.PRTNUM = 'MM_RECHNUNG' AND
                  A.SCDDAT <> 'Yce'
                  AND EXISTS (
                      SELECT 1 FROM TVPF.AFED01 B
                      WHERE
                          B.EKAFNR = A.A35#14 AND
                          B.EKAFJJ = SUBSTR(A.WRTDAT, 1, 4) AND
                          B.EKFIRM = '01' AND
                          B.EKILNR <> ' '
                  );


       //INVOIC DELETE POSITION
       //GALAXUS SWITZERLANG
       //DELETE POS WITH ROUNDING CORRECTION CAN BE NEGLECTED
       //DILA 30.04.2025
       exec sql
       DELETE FROM EDIFACT.STDDAT A
       WHERE
           A.HRCLVL = '150000000' AND
           A.MSGTYP = 'INVOIC' AND
           A.A35#01 = ' ' AND
           A.PRTNUM = 'GALAXUS_RECHNUNG' AND
           A.A35#01 = ' ' AND
           EXISTS (
               SELECT 1
               FROM EDIFACT.STDDAT B
               WHERE
                   B.MAIKEY = A.MAIKEY AND
                   B.MSGTYP = A.MSGTYP AND
                   B.PRTNUM = A.PRTNUM AND
                   B.HRCLVL = '100000000' AND
                   B.SCDDAT <> 'Yce'
           );

       //GALAXUS SWITZERLANG
       //DILA 04.04.2025
       //FIRST POSITION ARE UPDATED
       exec sql
       UPDATE EDIFACT.STDDAT A
       SET (A.NP2#6, A.NP3#4, A.NP5#2) = (
           SELECT
               (C.ALGPRABA * A.NP5#1),
               //PRICE_LINE_AMOUNT
               //((C.ALGPRABA * A.NP5#1) + NP2#1),
               ((C.ALGPRABA * A.NP5#1) + NP2#2),
               (C.ALGPRABA + NP5#2)
           FROM TVPF.AFLK01 B
           JOIN TVPF.ALGP C ON B.KLKMNR = C.ALGPKMNR AND B.KLKMJJ = C.ALGPKMJJ
           WHERE (B.KLLIJJ CONCAT B.KLRGNR) = A.MAIKEY
             AND B.KLFIRM = '01'
             AND C.ALGPFIRM = '01'
             AND C.ALGPTENR = A.A35#02
           FETCH FIRST 1 ROW ONLY
        )
        WHERE A.MSGTYP = 'INVOIC'
          AND A.HRCLVL = '150000000'
          AND A.PRTNUM = 'GALAXUS_RECHNUNG'
          AND A.NP5#1 <> 0
          AND EXISTS (
                SELECT 1
                FROM TVPF.AFLK01 B
                JOIN TVPF.ALGP C ON B.KLKMNR = C.ALGPKMNR AND
                                    B.KLKMJJ = C.ALGPKMJJ
                WHERE (B.KLLIJJ CONCAT B.KLRGNR) = A.MAIKEY
                  AND B.KLFIRM = '01'
                  AND C.ALGPFIRM = '01'
                  AND C.ALGPTENR = A.A35#02
          )
          AND EXISTS (
                SELECT 1 FROM EDIFACT.STDDAT D
                WHERE D.MAIKEY = A.MAIKEY
                  AND D.MSGTYP = A.MSGTYP
                  AND D.HRCLVL = '100000000'
                  AND D.SCDDAT <> 'Yce'
            );


       //THEN TOTAL AMOUNT IS UPDATED
       exec sql
       UPDATE EDIFACT.STDDAT A
       SET (
           A.NP3#3,
           //NET_VALUE_GOODS
           A.NP2#2,
           A.NP2#4,
           //TOTAL_AMOUNT
           A.NP2#1
       ) = (
           SELECT
               SUM(B.NP2#6),
               //NET_VALUE_GOODS
               SUM(B.NP3#4),
               SUM(B.NP3#4),
               //TOTAL_AMOUNT
               SUM(B.NP3#4) + A.NP2#3
           FROM EDIFACT.STDDAT B
           WHERE A.MAIKEY = B.MAIKEY
             AND A.MSGTYP = B.MSGTYP
             AND B.HRCLVL = '150000000'
             AND B.NP2#6 <> 0
             AND B.NP3#4 <> 0
             AND B.SNDREC = A.SNDREC
             AND B.PRTNUM = A.PRTNUM
           GROUP BY B.HRCLVL, B.MSGTYP, B.NP2#3
       )
       WHERE A.MSGTYP = 'INVOIC'
         AND A.HRCLVL = '100000000'
         AND A.PRTNUM = 'GALAXUS_RECHNUNG'
         AND A.SCDDAT <> 'Yce'
         AND EXISTS (
             SELECT 1
             FROM EDIFACT.STDDAT B
             WHERE A.MAIKEY = B.MAIKEY
               AND A.MSGTYP = B.MSGTYP
               AND B.HRCLVL = '150000000'
               AND B.NP2#6 <> 0
               AND B.NP3#4 <> 0
               AND B.SNDREC = A.SNDREC
               AND B.PRTNUM = A.PRTNUM
         );





       //INVOIC VAT update
       exec sql
       update edifact/stddat a set a17#8 =
       ( select KEUSTI from TVPF/Kueg01 b
         where
         a.a35#09 = b.kekdnr and b.KEFIRM = '01'
         and
         (PRTNUM like 'TRADEINN_RECHNUNG%' or
          PRTNUM like 'DAF_RECHNUNG%' or
          PRTNUM like 'OBI_RECHNUNG%' or
          PRTNUM like 'WESSELS_RE%' or
          PRTNUM like 'SCANIA_RECHNUNG%' or
          PRTNUM like 'GALAXUS_RECHNUNG%' or
          PRTNUM like 'AKTIVBANK_WM%' or
          PRTNUM like 'HOGAST_RECHNUNG%' or
          PRTNUM = 'COOLBLUE_RECHNUNG' OR
          PRTNUM like 'VOLVO_RECHNUNG%')
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
         and a.a17#8 = ''
       ) where exists
       ( select KEUSTI from TVPF/Kueg01 b
         where
         a.a35#09 = b.kekdnr and b.KEFIRM = '01'
         and
         (PRTNUM like 'TRADEINN_RECHNUNG%' or
          PRTNUM like 'DAF_RECHNUNG%' or
          PRTNUM like 'OBI_RECHNUNG%' or
          PRTNUM like 'WESSELS_RE%' or
          PRTNUM like 'SCANIA_RECHNUNG%' or
          PRTNUM like 'GALAXUS_RECHNUNG%' or
          PRTNUM like 'AKTIVBANK_WM%' or
          PRTNUM like 'HOGAST_RECHNUNG%' or
          PRTNUM = 'COOLBLUE_RECHNUNG' OR
          PRTNUM like 'VOLVO_RECHNUNG%')
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
         and a.a17#8 = '');

       // INVOIC VAT update fuer SCANIA RECHNUNG
       // wurde mit Land-NR ergänzt
       // Anpassung 11.12.2025
        exec sql
        update edifact.stddat s set s.a17#8 =
        ( select a.KEUSTI from TVPF.kueg01 a,
                TVPF.afad02 b where
                b.ADKDNR = a.KEKDNR and
                a.KELDNR = b.ADLAND and
                s.a35#09 = b.ADKDNR and
                b.ADFIRM = '01' and
                b.ADAART = 'ADVS' and
                b.ADAFNR = s.a35#14 and
                b.ADAFJJ = substr(s.MAIKEY, 1, 4) and
                s.HRCLVL = '100000000' and
                s.PRTNUM = 'SCANIA_RECHNUNG' and
                s.MSGTYP = 'INVOIC' and
                a.KEUSTI <> '' and
                s.SCDDAT <> 'Yce'
        ) where exists (
          select a.KEUSTI from TVPF.kueg01 a,
                TVPF.afad02 b where
                b.ADKDNR = a.KEKDNR and
                a.KELDNR = b.ADLAND and
                s.a35#09 = b.ADKDNR and
                b.ADFIRM = '01' and
                b.ADAART = 'ADVS' and
                b.ADAFNR = s.a35#14 and
                b.ADAFJJ = substr(s.MAIKEY, 1, 4) and
                s.HRCLVL = '100000000' and
                s.PRTNUM = 'SCANIA_RECHNUNG' and
                s.MSGTYP = 'INVOIC' and
                a.KEUSTI <> '' and
                s.SCDDAT <> 'Yce');

       //Projekt 240163 Lieferant VATID (AFRK.RKUSTE)
       //Erweiterung der Datei AFRK um die ermittelte UST-ID
       //Anfrage von Dometic am 19.03.2024 [not IGLOO]
       exec sql
       update edifact/stddat a set a.a17#7 =
       (select distinct b.RKUSTE from TVPF/AFRK01 b
        where
        (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01' and b.RKUSTE <> ' '
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
         and A.A35#01 <> '7315090000001'
       ) where exists
       (select distinct b.RKUSTE from TVPF/AFRK01 b
        where
        (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01' and b.RKUSTE <> ' '
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
         and A.A35#01 <> '7315090000001'
       );


       //Erweiterung der Datei AFRK um die ermittelte UST-ID
       //VAT-ID for Igloo OBI
       exec sql
       update edifact/stddat a set a.a17#7 =
       (select distinct b.RKUSTE from TVPF/AFRK01 b
        where
        (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01' and b.RKUSTE <> ' '
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.PRTNUM = 'OBI_RECHNUNG'
         and a.SCDDAT <> 'Yce'
         and A.A35#01 = '7315090000001'
       ) where exists
       (select distinct b.RKUSTE from TVPF/AFRK01 b
        where
        (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01' and b.RKUSTE <> ' '
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.PRTNUM = 'OBI_RECHNUNG'
         and a.SCDDAT <> 'Yce'
         and A.A35#01 = '7315090000001'
       );

       //LIEFERBEDINGUNG update for Volvo AFKO01
       //LIEFERBEDINGUNG aktuell aus Lieferscheindaten
       //und nicht aus dem Auftragskopf
       exec sql
       update edifact/stddat a set a.a3#07 =
       (select b.KLLIBD from TVPF/AFLK01 b
        where
        (b.KLLIJJ concat b.KLRGNR) = a.MAIKEY
         and b.KLFIRM = '01'
         and a.PRTNUM = 'VOLVO_RECHNUNG'
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
        ) where exists (
        select b.KLLIBD from TVPF/AFLK01 b
         where
         (b.KLLIJJ concat b.KLRGNR) = a.MAIKEY
         and b.KLFIRM = '01'
         and a.PRTNUM = 'VOLVO_RECHNUNG'
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '100000000'
         and a.SCDDAT <> 'Yce'
        );

       //Warenempfänger-GLN vom Kunden-Versand-Adresse
       //Muss sonst aus der Bestellung übernommen werden
       //Volvo aus HDX muss eine LA enthalten
        exec sql
         update edifact/stddat a set
         (a.a17#3, a.a17#4, a.a35#02, a.A70#08) =
         (select distinct
          b.VSEDIL, b.VSEDIL, b.VSEDIL, b.VSEDIL
         from TVPF/KDVS b
         where
           a.A35#09 = b.VSKDNR
           and UPPER(b.VSNAM1) = UPPER(a.A70#09)
           and b.VSEDIL <> ' ' and b.VSFIRM = '01'
           and (
           a.PRTNUM = 'VOLVO_RECHNUNG' OR
           a.PRTNUM = 'COOLBLUE_RECHNUNG' OR
           a.PRTNUM = 'SCANIA_RECHNUNG' OR
           a.PRTNUM = 'GALAXUS_RECHNUNG'
           )
           and a.MSGTYP = 'INVOIC'
           and a.HRCLVL = '100000000' and a.SCDDAT <> 'Yce'
           ) where exists
         (select distinct
         b.VSEDIL, b.VSEDIL, b.VSEDIL, b.VSEDIL
         from TVPF/KDVS b
         where
            a.A35#09 = b.VSKDNR
            and UPPER(b.VSNAM1) = UPPER(a.A70#09)
            and b.VSEDIL <> ' ' and b.VSFIRM = '01'
            and (
            a.PRTNUM = 'VOLVO_RECHNUNG' OR
            a.PRTNUM = 'COOLBLUE_RECHNUNG' OR
            a.PRTNUM = 'SCANIA_RECHNUNG' OR
            a.PRTNUM = 'GALAXUS_RECHNUNG'
            )
            and a.MSGTYP = 'INVOIC'
            and a.HRCLVL = '100000000' and a.SCDDAT <> 'Yce');

       //bei HDX-Aufträgen!!!  in Feld a35#09 über Zwischendatei
       //Bar_edi/HDXOEMEDI
       //läuft global für alle Rechnungen ab 20240101

       exec sql
       insert into BAR_EDI/HDXOEMEDI
       SELECT rkfirm, RKRGJJ, RKRGNR, RKLIJJ, RKLINR, klafjj, klafnr,
       char(substr(TBTEXT, 17, 10), 10) Deliv#, char(substr(TBTEXT, 46,
       15), 15) Purch#,
         char('  ', 2) status,current date #date,current timestamp #tstamp
         FROM TVPF/afrk01 b, TVPF/aflk01, TAMF/txbe01 WHERE substr(tbtext, 1,
       16)= 'DeliveryNote Nr.' and substr(tbtext, 28, 18) =
       'Purchase Order Nr.' and ((RKFIRM = KLFIRM and RKRGJJ = KLRGJJ and
       RKRGNR = KLRGNR) and RKFirm='01' and klFirm='01') and
       (klafnr=tbafnr and klafjj=tbJHJJ and klfirm=tbfirm) and RKRGNR <>
       ' '  and  RKLIJJ > 2023       and  b.RKRGNR
       not in (select a.rkrgnr from Bar_edi/HDXOEMEDI a
               where b.rkfirm=a.rkfirm and b.RKRGJJ=a.RKRGJJ and
                     b.RKLIJJ=a.RKLIJJ and b.RKLINR=a.RKLINR );

       MONITOR;
       Wrk.var1 =
           'DSPJOBLOG OUTPUT(*OUTFILE) ' +
           'OUTFILE(TVRELWAECO/AKTIVBANKR) ' +
           'OUTMBR(*FIRST *ADD)' ;
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DSPJOBLOG OUTPUT(*outfile)';
          exsr      SR_log;
       endmon;

       //Update Abladestelle und Kundenwerk aus AFED
       //Sonderfall DAF, kann aber anderen Kunden betreffen
       exec sql
        update edifact/stddat a set (a.a17#7, a.a17#8) =
        (select b.EKABST, b.EKWKKD from TVPF/AFED01 b
         where
           a.maikey = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4)
           and b.EKFIRM = '01' and a.HRCLVL = '120000000'
           and a.MSGTYP = 'INVOIC' and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
           and a.maikey in (select c.maikey from edifact/stddat c
           where
            a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and
            c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'))
        where exists
         (select b.EKABST, b.EKWKKD from TVPF/AFED01 b
           where
          a.maikey = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4)
          and b.EKFIRM = '01' and a.HRCLVL = '120000000'
          and a.MSGTYP = 'INVOIC' and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
          and a.maikey in (select c.maikey from edifact/stddat c
          where
           a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and
           c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'));


        //Update Abladestelle und Kundenwerk aus AFED
        //Sonderfall betrifft DAF, kann aber bei anderen Kunden auft
        //Auftragsnummer muss zuerst aus HRCLVL = '100000000' holen
        //HRCLVL = 120000000
        exec sql
        update edifact/stddat g set (g.a17#7, g.a17#8) =
        (select e.EKABST, e.EKWKKD from edifact/stddat d,
        (select a.maikey, a.MSGTYP, a.WRTDAT, b.EKABST, b.EKWKKD from
        edifact/stddat a, TVPF/AFED01 b
        where a.a35#14 = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4) and
        b.EKFIRM = '01' and a.HRCLVL = '100000000' and a.MSGTYP = 'INVOIC'
        and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
        and a.maikey in (select c.maikey from edifact/stddat c
        where a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and c.SCDDAT <>
        'Yce' and c.HRCLVL = '100000000')) e
        where e.maikey = d.maikey and e.MSGTYP = d.MSGTYP and e.WRTDAT =
        d.WRTDAT and g.maikey = d.maikey and g.MSGTYP = d.MSGTYP and
        g.WRTDAT = d.WRTDAT and d.HRCLVL = '120000000' and
        d.MSGTYP = 'INVOIC' and d.HRCLVL = g.HRCLVL)
        where exists
        (select e.EKABST, e.EKWKKD from edifact/stddat d,
        (select a.maikey, a.MSGTYP, a.WRTDAT, b.EKABST, b.EKWKKD from
        edifact/stddat a, TVPF/AFED01 b
        where a.a35#14 = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4) and
        b.EKFIRM = '01' and a.HRCLVL = '100000000' and a.MSGTYP = 'INVOIC'
        and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
        and a.maikey in (select c.maikey from edifact/stddat c
        where a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and c.SCDDAT <>
        'Yce' and c.HRCLVL = '100000000')) e
        where e.maikey = d.maikey and e.MSGTYP = d.MSGTYP and e.WRTDAT =
        d.WRTDAT and g.maikey = d.maikey and g.MSGTYP = d.MSGTYP and
        g.WRTDAT = d.WRTDAT and d.HRCLVL = '120000000' and
        d.MSGTYP = 'INVOIC' and d.HRCLVL = g.HRCLVL);



       //und update der INVOIC
       exec sql
        update edifact/stddat a set a.a35#09 =
       (select DISTINCT PURCH# from Bar_edi/HDXOEMEDI b
        WHERE (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01'
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '150000000'
         and a.PRTNUM <> 'JOHN_DEERE_RECHNUNG'
         and a.MAIKEY in (
          select c.MAIKEY from EDIFACT/STDDAT c
          where
          a.MAIKEY = c.MAIKEY and
          a.MSGTYP = c.MSGTYP and
          a.WRTDAT = c.WRTDAT and
          c.SCDDAT <> 'Yce'   and
          c.HRCLVL = '100000000'))
       where exists
       (select DISTINCT PURCH# from Bar_edi/HDXOEMEDI b
        WHERE (b.RKRGJJ concat b.RKRGNR) = a.MAIKEY
         and b.RKFIRM = '01'
         and a.MSGTYP = 'INVOIC'
         and a.HRCLVL = '150000000'
         and a.PRTNUM <> 'JOHN_DEERE_RECHNUNG'
         and a.MAIKEY in (
          select c.MAIKEY from EDIFACT/STDDAT c
          where
          a.MAIKEY = c.MAIKEY and
          a.MSGTYP = c.MSGTYP and
          a.WRTDAT = c.WRTDAT and
          c.SCDDAT <> 'Yce'   and
          c.HRCLVL = '100000000'));

       // Update: add year to delivery note number in
       // INVOICES only on the LVL10 possible
       // for Media Markt customer
       exec sql
        UPDATE EDIFACT.STDDAT A
           SET A.A35#12 = (
           SELECT (substr(a.WRTDAT, 1, 4) concat A.A35#12)
           FROM EDIFACT.STDDAT B
           WHERE
               A.MAIKEY = B.MAIKEY
           AND A.MSGTYP = B.MSGTYP
           AND A.WRTDAT = B.WRTDAT
           AND A.HRCLVL = B.HRCLVL
           AND length(trim(A.A35#12)) = 6
           AND A.HRCLVL = '100000000'
           AND A.MSGTYP = 'INVOIC'
           AND A.PRTNUM = 'MM_RECHNUNG'
           AND A.SCDDAT <> 'Yce'  )
           where exists (
           SELECT (substr(a.WRTDAT, 1, 4) concat A.A35#12)
           FROM EDIFACT.STDDAT B
           WHERE
               A.MAIKEY = B.MAIKEY
           AND A.MSGTYP = B.MSGTYP
           AND A.WRTDAT = B.WRTDAT
           AND A.HRCLVL = B.HRCLVL
           AND length(trim(A.A35#12)) = 6
           AND A.HRCLVL = '100000000'
           AND A.MSGTYP = 'INVOIC'
           AND A.PRTNUM = 'MM_RECHNUNG'
           AND A.SCDDAT <> 'Yce');

       //balance INVOICES for erp ERP Trend-System
       exec sql
         insert into bar_edi/aktivbank
         SELECT RKFIRM,RKRGJJ,RKRGNR,RKLIJJ,RKLINR,RKKDNR,rkreda
                             ,dec(0, 10) #cc,
         char('  ', 2) status,current date #date,current timestamp #tstamp,
         dec(0, 10) #count,current timestamp updtstamp,
         char(' ', 10) pgm,char(' ', 10) job,char(' ', 10) user,
         char(' ', 128) protokoll
         FROM TVPF/afrk01 b WHERE RKRGJJ > 2021 and rkreda > 20210000  and
                             rkkdnr<>'xxxxxx'  and  rkrgnr<>' ' and rkrgnr
         not in (select rkrgnr from bar_edi/aktivbank a
                 where b.rkfirm=a.rkfirm and b.RKRGJJ=a.RKRGJJ and
                       b.RKLIJJ=a.RKLIJJ and b.RKLINR=a.RKLINR and
                       b.RKKDNR=a.RKKDNR)        and b.RKKDNR in
                 (select kdkdnr from TVPF/kund01
                  where kdfirm=b.rkfirm
                  and (
                         KDKDGR='025'
                      OR KDKDGR='018'
                      OR KDKDGR='014'
                      OR KDKDGR='012'
                      OR KDKDGR='0751'
                  )
                  and KDKDST='01');

       exec sql
         update        Bar_edi/aktivbank set protokoll =
         (select kdnam3 from TVPF/kund01
          where kdfirm=rkfirm and  kdkdnr=rkkdnr  and
          STATUS='  ' )
         where exists
          (select kdnam3 from TVPF/kund01
          where kdfirm=rkfirm and  kdkdnr=rkkdnr  and
          STATUS='  ' );

       exec sql
         update Bar_edi/aktivbank set #tstamp = current timestamp
         where  aktivbank.status='  ' and
                char(RKRGJJ concat RKRGNR) in
                ( select MAIKEY from edifact/stddat where
                (a14#1=' ' or a14#2=' ' or a14#4=' ') and
       //       hrclvl= 100000000 and STDDAT.XEORF ='X');
                hrclvl= '100000000' and STDDAT.XEORF <>'#'
                and substr( MAIKEY, 1, 4)>'2021');

       exec sql
         update Bar_edi/aktivbank set status = '10'
         where  aktivbank.status=' ' and
                char(RKRGJJ concat RKRGNR) in
                ( select MAIKEY from edifact/stddat where
                (a14#1=' ' or a14#2=' ' or a14#4=' ') and
       //       hrclvl= 100000000 and STDDAT.XEORF ='X');
                hrclvl= '100000000' and STDDAT.XEORF <>'#'
                and substr( MAIKEY, 1, 4)>'2021');


       //a14#2 ZR
       exec sql
          update  edifact/stddat set a14#2 =
          (SELECT distinct substr(PROTOKOLL, 4, 5) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021')
          where exists
          (SELECT distinct substr(PROTOKOLL, 4, 5) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021');

       //a14#1 VL
       exec sql
          update  edifact/stddat set a14#1 =
          (SELECT distinct substr(PROTOKOLL, 12, 7) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021')
          where exists
          (SELECT distinct substr(PROTOKOLL, 12, 7) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021');


       //a14#4 AH
       exec sql
          update  edifact/stddat set a14#4 =
          (SELECT distinct substr(PROTOKOLL, 22, 7) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021')
          where exists
          (SELECT distinct substr(PROTOKOLL, 22, 7) FROM bar_edi/aktivbank
           where  aktivbank.status='10' and
                  char(RKRGJJ concat RKRGNR)= MAIKEY and
                  (a14#1=' ' or a14#2=' ' or a14#4=' ') and
                  hrclvl= '100000000' and STDDAT.XEORF <>'#'
                  and substr( MAIKEY, 1, 4)>'2021');


       //update Aktivbank restart bbbb
       exec sql
          update  edifact/stddat set XEORF  = 'X'
          where   maikey in
                  (select char(RKRGJJ concat RKRGNR)
                   FROM bar_edi/aktivbank
                   where  aktivbank.status='10' and
                     hrclvl= '100000000' and STDDAT.XEORF <>'#'
                     and substr( MAIKEY, 1, 4)>'2021');

       //..
       exec sql
           update  Bar_edi/aktivbank
           set status='20' where status='10';

       //italienische Steuernummer eintragen!!!!!
       //Acchtung AKAFAT ='I55' and AKMWCD ='74' nur diese Verbindung
       //Protokoll erzeugen                 !!!!!
       //hier gegenwärtig nur der Kunde 489440
       exec sql
          insert into tvrelwaeco/i55_match
          SELECT
          a.KLFIRM,a.KLRGJJ,a.KLRGNR,a.KLRGNN,a.KLAFJJ,a.KLAFNR,
          char('  ', 2) status, current timestamp as tstamp
          FROM TVPF/aflk01 a,  TVPF/afko01 b WHERE
          (a.KLfirm=b.akfirm and a.KLAFJJ=b.akafjj and a.KLAFNR=b.akAFNR and
          a.KLRGJJ>2020 and (AKAFAT='I55' or AKAFAT='N55') and AKMWCD='74' and
          (AKRAKD='489440' or  AKRAKD='400174' or  AKRAKD='006016')) and
          (a.KLRGNR not in (138864, 165924))
          and a.klfirm not in (select c.klfirm from tvrelwaeco/i55_match c
          where a.KLRGJJ =c.KLRGJJ and a.KLRGNR =c.KLRGNR
          and a.KLRGNN =c.KLRGNN and a.KLAFJJ =c.KLAFJJ and
          a.KLAFNR =c.KLAFNR );

       //italienische Steuernummer eintragen!!!!!
       //Treffer Protokoll auf 10 setzen    !!!!!
       exec sql
          update tvrelwaeco/i55_match set status='10' where
          KLRGJJ concat KLRGNR in
          (select maikey from edifact/stddat
          where MSGTYP ='INVOIC' and a17#7='DE124393501' and
                HRCLVL = '100000000')
          and  status = '  ';

       //italienische Steuernummer eintragen!!!!!
       //update auf edifact/stddat          !!!!!
       //wenn die Rechnung von euch dem ReverseCharge unterliegt
       //->    ( "AE" = "Verlagerung der Umsatzsteuerschuld (Reverse Charge)" )
       //->        maßgeblichen Steuersatz "0"
       exec sql
          update edifact/stddat set a17#7 = 'IT00201079993',
                                    a3#04 = 'AE',
                                    np3#1 =  0
          where maikey in
          (select KLRGJJ concat KLRGNR from
           tvrelwaeco/i55_match where status='10')
           and MSGTYP ='INVOIC' and HRCLVL = '100000000';

       //->        Umsatzsteuernummer holen für a17#8 und a25#2
       exec sql
          update edifact/stddat set a17#8 =
          ( select KEUSTI from TVPF/Kueg01
            where a35#09 = kekdnr and KEFIRM = '01'
                  and maikey in
          ( select KLRGJJ concat KLRGNR from
            tvrelwaeco/i55_match where status='10'
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
          where exists
          ( select KEUSTI from TVPF/Kueg01
            where a35#09 = kekdnr and KEFIRM = '01'
                  and maikey in
          ( select KLRGJJ concat KLRGNR from
            tvrelwaeco/i55_match where status='10'
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
            and MSGTYP ='INVOIC' and HRCLVL = '100000000');


       exec sql
          update edifact/stddat set a25#2 =
          ( select KEUSTI from TVPF/Kueg01
            where a35#09 = kekdnr and KEFIRM = '01'
                  and maikey in
          ( select KLRGJJ concat KLRGNR from
            tvrelwaeco/i55_match where status='10'
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
          where exists
          ( select KEUSTI from TVPF/Kueg01
            where a35#09 = kekdnr and KEFIRM = '01'
                  and maikey in
          ( select KLRGJJ concat KLRGNR from
            tvrelwaeco/i55_match where status='10'
            and MSGTYP ='INVOIC' and HRCLVL = '100000000')
            and MSGTYP ='INVOIC' and HRCLVL = '100000000');


       //Im Falle Innergemeinschaftliche Lieferung:
       //HrcLvL 110000000   // a3#01 mit REG füllen , a3#04 mit IGL füllen , a70#01 mit IGL füllen
       //Satz kann jetzt ?????????????????????????? raus   1. satz
       exec sql
          update edifact/stddat set a17#7 = ' ',
                                    a3#01 = 'REG',
                                    a3#04 = 'LES',
                                   a70#01 = ' '
          where maikey in
          (select KLRGJJ concat KLRGNR from
           tvrelwaeco/i55_match where status='10')
           and MSGTYP ='INVOIC' and HRCLVL = '110000000';

       //SELECT * FROM stddat WHERE MAIKEY ='2022128511' and
       // HrcLvL = '110000000'
       //Datei I55_ZUSATZ in TVRELWAECO wurde erstellt.
       //HrcLvL 110000000   // a3#01 mit REG füllen, a3#04 mit LES füllen
                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(tvrelwaeco/I55_ZUSATZ)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(tvrelwaeco/I55_ZUSATZ)  ';
                      exsr      SR_log;
                endmon;

       // 20220909 - DILA LINNUM von 1000 auf 1 geändert
       exec sql
          insert into  tvrelwaeco/I55_ZUSATZ
          SELECT * FROM edifact/stddat WHERE MAIKEY in
          ( select KLRGJJ concat KLRGNR from
            tvrelwaeco/i55_match where status='10') and
           HrcLvL = '110000000';

       exec sql
          update tvrelwaeco/I55_ZUSATZ set a17#7 = ' ',
                                    a3#01 = 'REG',
                                    a3#04 = 'LES',
                                    a70#01 = ' ',
                                    LINNUM = 1000;
       //2. satz anlegen
       //  exec sql
       //   insert into edifact/stddat
       //   select * from tvrelwaeco/I55_ZUSATZ;

       //1. satz löschen (!!!) Rücksprache mit Markant/Lehmeier
       //exec sql
       //   delete from edifact/stddat where maikey in
       //   ( select KLRGJJ concat KLRGNR from
       //     tvrelwaeco/i55_match where status='10') and
       //    HrcLvL = '110000000' and a3#04 ='IGLXXX';


                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(tvrelwaeco/I55_ZUSATZ)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(tvrelwaeco/I55_ZUSATZ)  ';
                      exsr      SR_log;
                endmon;


       //italienische Steuernummer eintragen!!!!!
       //update Protokoll
       //
       exec sql
          update tvrelwaeco/i55_match set status='20'
          where status='10';


       eval status ='Start HRCLVL1300                    ';
       exsr      SR_log;
       exsr HRCLVL1300;
       eval status ='Ende  HRCLVL1300                    ';
       exsr      SR_log;


       eval status ='Start ORDRSP                        ';
       exsr      SR_log;
       exsr sr_ORDRSP;
       eval status ='Ende  ORDRSP                        ';
       exsr      SR_log;

       eval status ='Start DESADV                        ';
       exsr      SR_log;
       exsr sr_DESADV;
       eval status ='Ende  DESADV                        ';
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

       eval status ='Ende  FTP Transfer for AKTIVBANKR   ';
       exsr      SR_log;

       *inlr = *on;

      /eject
       //***********************************************************************
       //    ---------------------
       //    S U B R O U T I N E S
       //    ---------------------
       //***********************************************************************


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
       //    Füllen Felder Zieldatei    F
       //-----------------------------------------------------------------------

       begsr HRCLVL1300;

       //Funktion HRCLVLZUAB
       //Sätze ohne Werte im HRCLVL 1300000 dürfen nicht übertragen werden!
       //Die Funktion HRCLVLZUAB muß vor der Funktion HRCLVL1300 laufen   !
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%' or
             PRTNUM like 'VOLVO_RECHNUNG%' or
             PRTNUM like 'MM_RECHNUNG%' or
             PRTNUM like 'DAF_RECHNUNG%' or
             PRTNUM like 'OBI_RECHNUNG%' or
             PRTNUM like 'WESSELS_RE%' or
             PRTNUM = 'COOLBLUE_RECHNUNG' OR
             PRTNUM like 'TECCOM_RECHNUNG%' OR
             PRTNUM like 'SCANIA_RECHNUNG%' OR
             PRTNUM like 'GALAXUS_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_WM%' or
             PRTNUM like 'AKTIVBANK_SELECT%' or
             PRTNUM like 'BOL_RECHNUNG%' or
             PRTNUM like 'HOGAST_RECHNUNG%' or
             PRTNUM like 'TRADEINN_RECHNUNG%' or
             PRTNUM like 'AMAZON%' or PRTNUM like 'TECCOM_RECHNUNG%' or
             PRTNUM like 'CONRAD_RECHNUNG%')
                                            and substr( MAIKEY, 1, 4)>'2021'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVLZUAB nur prtnum='EZ_MARKANT_RECHNUNG' !!!!!!!!
       //Bereigung da altlast   alt Ezitel   erledigt         !!!!!!!!
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (prtnum='EZ_MARKANT_RECHNUNG')
                                            and substr( MAIKEY, 1, 4)='2019'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;


       //Funktion HRCLVLZUAB nur prtnum='MARKANT_RECHNUNG' alt aus 2020 und 2021
       //die über den restart hineingegangen sind wrtdat(20220805) ladedatum
       //===> update  afrk01 set RKST02= '10'
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM,                                   dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVLZUAB', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                                             WHERE (np2#1 = 0 and np2#2
          = 0 and np2#3 = 0 and np2#4 =  0 and np2#6 = 0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'VOLVO_RECHNUNG%' or
             PRTNUM like 'OBI_RECHNUNG%' or
             PRTNUM like 'WESSELS_RE%' or
             PRTNUM like 'MM_RECHNUNG%' or
             PRTNUM like 'TECCOM_RECHNUNG%' OR
             PRTNUM like 'SCANIA_RECHNUNG%' OR
             PRTNUM like 'GALAXUS_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_WM%' or
             PRTNUM like 'DAF_RECHNUNG%' OR
             PRTNUM = 'COOLBLUE_RECHNUNG' OR
             PRTNUM like 'BOL_RECHNUNG%' or
             PRTNUM like 'HOGAST_RECHNUNG%' or
             PRTNUM like 'TRADEINN_RECHNUNG%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
             and (substr( MAIKEY, 1, 4)='2020' or substr( MAIKEY, 1, 4)='2021')
             and wrtdat > '20220804'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 a.LINNUM=b.LINNUM and b.errortyp='HRCLVLZUAB')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;


       exec sql
          insert into tvrelwaeco/savestddat
          select * from EDIFACT/stddat a where a.maikey in
          (select b.maikey from TVRELWAECO/HRCLVL1300 b
           where a.HRCLVL = b.HRCLVL  and
                 a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                     and status='  ' );
      // Warum werden die RE gelöscht ???
       exec sql
          delete   from EDIFACT/stddat a where a.maikey in
          (select b.maikey from TVRELWAECO/HRCLVL1300 b
         where a.HRCLVL = b.HRCLVL  and
               a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                   and status='  ' );

       exec sql
          update TVRELWAECO/HRCLVL1300 a set status = '10' where
          a.maikey in
          (select b.maikey from EDIFACT/stddat b
           where a.HRCLVL = b.HRCLVL  and
                 a.LINNUM = b.LINNUM and errortyp='HRCLVLZUAB'
                                     and status='  ' );

       exec sql
          update TVRELWAECO/HRCLVL1300  set status = '20'
          where errortyp='HRCLVLZUAB' and status='  ';

       //Funktion HRCLVL1300
       //Sätze müssen in der Reihenfolge von HRCLVL erfolgen und nur bei
       //Rechnungen, die auch Wert haben!!
       //b e a r b e i t u n g s wü r d i g e    Sätze
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%' or
             PRTNUM like 'VOLVO_RECHNUNG%' or
             PRTNUM like 'MM_RECHNUNG%' or
             PRTNUM like 'OBI_RECHNUNG%' OR
             PRTNUM like 'WESSELS_RE%' OR
             PRTNUM like 'DAF_RECHNUNG%' OR
             PRTNUM like 'TECCOM_RECHNUNG%' OR
             PRTNUM like 'SCANIA_RECHNUNG%' OR
             PRTNUM like 'GALAXUS_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_WM%' or
             PRTNUM = 'COOLBLUE_RECHNUNG' OR
             PRTNUM like 'BOL_RECHNUNG%' or
             PRTNUM like 'HOGAST_RECHNUNG%' or
             PRTNUM like 'TRADEINN_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_SELECT%' or
             PRTNUM like 'AMAZON%' or PRTNUM like 'TECCOM_RECHNUNG%' or
             PRTNUM like 'CONRAD_RECHNUNG%')
                                            and substr( MAIKEY, 1, 4)>'2021'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVL1300  nur prtnum='EZ_MARKANT_RECHNUNG' !!!!!!!!
       //Bereigung da altlast   alt Ezitel  erledigt          !!!!!!!!
       //b e a r b e i t u n g s wü r d i g e    Sätze
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (prtnum='EZ_MARKANT_RECHNUNG')
                                            and substr( MAIKEY, 1, 4)='2019'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVL1300 nur prtnum='MARKANT_RECHNUNG' alt aus 2020 und 2021
       //die über den restart hineingegangen sind wrtdat(20220805) ladedatum
       //===> update  afrk01 set RKST02= '10'
       //Bereigung da altlast   2020/2021                     !!!!!!!!
       //b e a r b e i t u n g s wü r d i g e    Sätze
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('HRCLVL1300', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
                            WHERE (np2#1 <>0 or np2#2
          <>0 or np2#3 <>0 or np2#4 <> 0 or np2#6 <>0) and HRCLVL
          ='130000000' and MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'VOLVO_RECHNUNG%' or
             PRTNUM like 'MM_RECHNUNG%' or
             PRTNUM like 'DAF_RECHNUNG%' OR
             PRTNUM like 'OBI_RECHNUNG%' OR
             PRTNUM like 'WESSELS_RE%' OR
             PRTNUM = 'COOLBLUE_RECHNUNG' OR
             PRTNUM like 'BOL_RECHNUNG%' or
             PRTNUM like 'TRADEINN_RECHNUNG%' or
             PRTNUM like 'TECCOM_RECHNUNG%' OR
             PRTNUM like 'SCANIA_RECHNUNG%' OR
             PRTNUM like 'GALAXUS_RECHNUNG%' or
             PRTNUM like 'HOGAST_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_WM%' or
             PRTNUM like 'MARKANT_RECHNUNG%')
             and (substr( MAIKEY, 1, 4)='2020' or substr( MAIKEY, 1, 4)='2021')
             and wrtdat > '20220804'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                                       b.errortyp='HRCLVL1300')
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;

       //Funktion HRCLVL1300  ACHTUNG hier Direktgeschäft
       //b e a r b e i t u n g s wü r d i g e    Sätze, die bislang
       //noch keinen errortyp='HRCLVL1300' hatten.
       //Dieses ist notwendig, da level 1000 mitgegeben wurde und er
       //durch die Sortierung muß!!!    I55 Auftragsart
       exec sql
          insert into tvrelwaeco/HRCLVL1300
          SELECT distinct a.SNDREC, a.PRTNUM, a.MSGTYP, a.MAIKEY,
          a.HRCLVL, a.LINNUM*0,                                 dec(count(*),
          10) anzahl , char('  ', 2) status, char('I55       ', 10) errortyp,
          current timestamp as tstamp FROM  EDIFACT/stddat a
            WHERE  a17#7 ='IT00201079993' and HRCLVL='100000000' and
                  MSGTYP ='INVOIC' and
            (PRTNUM like '%DE_MARKANT%' or
             PRTNUM like 'MARKANT_RECHNUNG%' or
             PRTNUM like 'VOLVO_RECHNUNG%' or
             PRTNUM like 'MM_RECHNUNG%' or
             PRTNUM like 'WESSELS_RE%' or
             PRTNUM like 'TECCOM_RECHNUNG%' OR
             PRTNUM like 'SCANIA_RECHNUNG%' OR
             PRTNUM like 'GALAXUS_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_WM%' or
             PRTNUM = 'COOLBLUE_RECHNUNG' OR
             PRTNUM like 'BOL_RECHNUNG%' or
             PRTNUM like 'HOGAST_RECHNUNG%' or
             PRTNUM like 'TRADEINN_RECHNUNG%' or
             PRTNUM like 'OBI_RECHNUNG%' or
             PRTNUM like 'AKTIVBANK_SELECT%' or
             PRTNUM like 'AMAZON%' or PRTNUM like 'TECCOM_RECHNUNG%' or
             PRTNUM like 'CONRAD_RECHNUNG%')
             and maikey in ('2021138866', '2021138865', '2021165925')
                                            and substr( MAIKEY, 1, 4)='2021'
          and a.MAIKEY not in (select b.MAIKEY from tvrelwaeco/HRCLVL1300 b
          where  a.SNDREC=b.SNDREC and a.PRTNUM=b.PRTNUM and
                 a.MSGTYP=b.MSGTYP and a.HRCLVL=b.HRCLVL and
                 (b.errortyp='I55       ' or b.errortyp='HRCLVL1300'))
          GROUP BY SNDREC, PRTNUM, MSGTYP, MAIKEY, HRCLVL, LINNUM;



       exec sql
         create index tvrelwaeco/HRCLVL130l on tvrelwaeco/HRCLVL1300
         (status);

       MONITOR;
       Wrk.var1 =
           'DLTOBJ OBJ(QTEMP/STDDAT) OBJTYPE(*FILE)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DLTOBJ OBJ(QTEMP/STDDAT)';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CRTDUPOBJ OBJ(STDDAT) FROMLIB(EDIFACT) ' +
           'OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(STDDAT)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in CRTDUPOBJ OBJ(STDDAT)   ';
          exsr      SR_log;
       endmon;

          open HRCLVL130l;
          HRCLVL130l_k.status  =  *blank;
          setll %kds(HRCLVL130l_k:1) HRCLVL130l;
          reade %kds(HRCLVL130l_k:1) HRCLVL130l  HRCLVL130l_i;
          dow not %eof(HRCLVL130l);
       //CRTDUPOBJ OBJ(STDDAT) FROMLIB(EDIFACT) OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(STDDAT)
       //// HRCLVL130l_i.ANZAHL < 4      and -> 07092022 geändert
       //// HRCLVL130l_i.ANZAHL = 1      and -> 08092022 (original)
             if HRCLVL130l_i.status = *blank and
                HRCLVL130l_i.ANZAHL = 1      and
                (HRCLVL130l_i.ERRORTYP = 'HRCLVL1300' or
                 HRCLVL130l_i.ERRORTYP = 'I55       ');

                HRCLVL130l_i.status = '10';
                HRCLVL130l_o = HRCLVL130l_i;
                update phy01r   HRCLVL130l_o;
                §SNDREC = HRCLVL130l_i.SNDREC;
                §PRTNUM = HRCLVL130l_i.PRTNUM;
                §MSGTYP = HRCLVL130l_i.MSGTYP;
                §MAIKEY = HRCLVL130l_i.MAIKEY;
                §HRCLVL = HRCLVL130l_i.HRCLVL;
                §LINNUM = HRCLVL130l_i.LINNUM;

                eval status ='####  HRCLVL1300   ' + §MAIKEY;
       //no log exsr      SR_log;

                exec sql
                   insert into   qtemp/stddat
                   select * from  EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY and
                                  HRCLVL <   '139999999'
                            ORDER BY SNDREC, PRTNUM,  MSGTYP,
                                     MAIKEY, HRCLVL, LINNUM;
       //Achtung: Order by ganz wichtig
                exec sql
                   insert into   qtemp/stddat
                   select * from  EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY and
                                  (HRCLVL >   '150000000' or
                                   HRCLVL =   '150000000')
                            ORDER BY SNDREC, PRTNUM,  MSGTYP,
                                     MAIKEY, LINNUM;

                exec sql
                   insert into   tvrelwaeco/savestddat
                   select * from  EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY;

                exec sql
                   delete from   EDIFACT/stddat
                            where SNDREC = :§SNDREC and
                                  PRTNUM = :§PRTNUM and
                                  MSGTYP = :§MSGTYP and
                                  MAIKEY = :§MAIKEY;

       //Korrektur: laufende Nummer mit Sequenz (wegen order by)
                exec sql
                   update qtemp/stddat
                          set LINNUM = rrn(stddat) - 1,
                              USERNM = 'HRCLVL1300';

       //Achtung start if
                if HRCLVL130l_i.ERRORTYP <> 'I55       ';
       //Korrektur: HRCLVL: 130000000      hier einer aus 2021:MAIKEY ='2021146902'
       //-> A = Allowance= Abschläge  / C = Charge=Zuschläge
       //where a3#01 ='A' dieses ist ein Fehler bei RKERG1 > 0, RKERG2 > 0 usw.
       //zwischendatei für Erkennung ableiten
                   exec sql
                      insert into   tvrelwaeco/afrkstddat
                      select RKRGJJ, RKRGNR, sum(RKERG1) a from TVPF/afrk01
                      where rkfirm='01' and RKERG1 > 0 and
                            (RkRGJJ concat RKRGNR) in
                            ( select maikey from qtemp/stddat
                              where a3#01 ='A' and HRCLVL = '130000000')
                      group by RKRGJJ, RKRGNR;
                   exec sql
                      insert into   tvrelwaeco/afrkstddat
                      select RKRGJJ, RKRGNR, sum(RKERG2) a from TVPF/afrk01
                      where rkfirm='01' and RKERG2 > 0 and
                            (RkRGJJ concat RKRGNR) in
                            ( select maikey from qtemp/stddat
                              where a3#01 ='A' and HRCLVL = '130000000')
                      group by RKRGJJ, RKRGNR;
                   exec sql
                      insert into   tvrelwaeco/afrkstddat
                      select RKRGJJ, RKRGNR, sum(RKERG3) a from TVPF/afrk01
                      where rkfirm='01' and RKERG3 > 0 and
                            (RkRGJJ concat RKRGNR) in
                            ( select maikey from qtemp/stddat
                              where a3#01 ='A' and HRCLVL = '130000000')
                      group by RKRGJJ, RKRGNR;
                   exec sql
                      insert into   tvrelwaeco/afrkstddat
                      select RKRGJJ, RKRGNR, sum(RKERG4) a from TVPF/afrk01
                      where rkfirm='01' and RKERG4 > 0 and
                            (RkRGJJ concat RKRGNR) in
                            ( select maikey from qtemp/stddat
                              where a3#01 ='A' and HRCLVL = '130000000')
                      group by RKRGJJ, RKRGNR;


       //Korrektur:                    für HRCLVL = '130000000'
       //hier alle Fehler:  K O P F
       //SELECT DISTINCT RKRGJJ, RKRGNR, sum(RKERG1),sum(RKERG2),
       //sum(RKERG3),sum(RKERG4) FROM afrk01 WHERE RkRGJJ =2022 and RKERG1 >
       //0 and (RkRGJJ concat RKRGNR) in ( select maikey from stddat where
       //a3#01 ='A' and hrclvl='130000000' and MSGTYP ='INVOIC')
       //GROUP BY RKRGJJ, RKRGNR
       //                   U N D   P O S T I O N
       //SELECT DISTINCT RpRGJJ, RpRGNR, sum(RpERG1),sum(RpERG2),
       //sum(RpERG3),sum(RpERG4) FROM afrp01 WHERE RpRGJJ =2022 and RpERG1 >
       //0 and (RpRGJJ concat RpRGNR) in ( select maikey from stddat where
       //a3#01 ='A' and hrclvl='155000000' and MSGTYP ='INVOIC')
       //GROUP BY RpRGJJ, RpRGNR
       //
       //Korrektur: -> A = Allowance= Abschläge  / C = Charge=Zuschläge
       //Korrektur: auf ===> c
                   exec sql
                      update qtemp/stddat
                             set a3#01 ='C'
                      where HRCLVL = '130000000' and
                            np2#2 in (select a from tvrelwaeco/afrkstddat);
       //Korrektur: -> np3#1 = '0'  -> hier müsste der MWStsatz für die Zu/Abschläge stehen  ( 0 dürfte nur dann
       //Korrektur: -> sein, wenn ohne Mwst) wird aus Kopfsatz gezogen
       //          exec sql
       //             update qtemp/stddat a
       //                    set a.np3#1 =
       //             (select b.np3#1 from qtemp/stddat b where
       //                   b.HRCLVL = '100000000'  and
       //                   a.HRCLVL = '130000000')
       //             where exists
       //             (select b.np3#1 from qtemp/stddat b where
       //                   b.HRCLVL = '100000000'  and
       //                   a.HRCLVL = '130000000');

       //Korrektur: -> Qualifier bei  Zu/Abschlagsangaben
                   exec sql
                      update qtemp/stddat  set A3#02 = CASE
                         when a35#02 = 'Versandkosten     ' then 'FC '
                         when a35#02 = 'Frachtkosten      ' then 'FC '
                         when a35#02 = 'Frachtzuschlag    ' then 'FC '
                         when a35#02 = 'Versandnebenkosten' then 'FC '
                         when a35#02 = 'Zentrallagerrabatt' then 'DI '
                         when a35#02 = 'Auftragsrabatt    ' then 'DI '
                         when a35#02 = 'Rabatt            ' then 'DI '
                         when a35#02 = 'Auftrags-Bonus    ' then 'TD '
                         when a35#02 = 'Verpackungs-Kosten' then 'PC '
                         when a35#02 = '                  ' then 'FC '
                         when A3#02  = 'Ver'                then 'FC '
                         else                                    'FC '
                         end
                      where HRCLVL = '130000000';

       //Korrektur: der gesamtbonuswert ist negativ !!!!!!
       //update        stddat set np3#4 =
       //(select  RKERG1+RKERG2+RKERG3+RKERG4
       // from afrk01
       // where RKERG1+RKERG2+RKERG3+RKERG4 < 0 and
       //       maikey=(RkRGJJ concat RKRGNR) and
       //       MSGTYP = 'INVOIC' and HRCLVL = '100000000'
       //       and MAIKEY = '2019617116')
       //where exists
       //(select  RKERG1+RKERG2+RKERG3+RKERG4
       // from afrk01
       // where RKERG1+RKERG2+RKERG3+RKERG4 < 0 and
       //       maikey=(RkRGJJ concat RKRGNR) and
       //       MSGTYP = 'INVOIC' and HRCLVL = '100000000'
       //       and MAIKEY = '2019617116')
       //
       //
       //
       //    > update                            stddat set XEORF='X'
       //                                               WHERE MAIKEY = '2019617116'
       //         and HRCLVL  ='100000000'
       //      1 Zeilen in STDDAT in EDIFACT aktualisiert.
       //    > update                            stddat set SCDDAT ='NEU'
       //                                               WHERE MAIKEY = '2019617116'
       //         and HRCLVL  ='100000000'


       //Korrektur: alt für EDDY
       ////     exec sql
       ////        update qtemp/stddat set XEORF  = 'X'
       ////               where HRCLVL = '100000000';
       //Achtung ende Endif
                endif;

       //Korrektur: SCDDAT = 'NEU     '  übergabe System neu
       //ACHTUNG: WRTDAT=Datum, wann die Rechnung bzw. STDDAT-Satz geschrieben wurde
       //Deaktviert Status NEU wird unten gesetzt 17.07.2024 DILA
       //       exec sql
       //          update qtemp/stddat set SCDDAT = 'NEU     '
       //                 where HRCLVL = '100000000'
       //                   and WRTDAT >'20220900';

                exec sql
                   insert into  EDIFACT/stddat
                   select * from qtemp/stddat a
                   order by a.LINNUM;

       //Anlage über sql
       //       exec sql
       //          insert into  TVRELWAECO/SAMMELEDI
       //          select * from qtemp/stddat a
       //          order by a.LINNUM;
       //Anlage über cpyf
       //       exec sql
       //          insert into  TVRELWAECO/SAMMELEDI2
       //          select * from qtemp/stddat a
       //          order by a.LINNUM;
       //       MONITOR;
       //          Wrk.var1 =
       //              'CLRPFM FILE(qtemp/stddat)';
       //          cmd = %TrimR(Wrk.Var1);
       //          L      = %Len(Cmd);
       //          QCMDEXC(cmd: %len(cmd));
       //          on-error;
       //             status='error CLRPFM FILE(qtemp/stddat)           ';
       //             exsr      SR_log;
       //       endmon;
             endif;
                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(tvrelwaeco/afrkstddat)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(qtemp/afrkstddat)       ';
                      exsr      SR_log;
                endmon;
                MONITOR;
                   Wrk.var1 =
                       'CLRPFM FILE(qtemp/stddat)';
                   cmd = %TrimR(Wrk.Var1);
                   L      = %Len(Cmd);
                   QCMDEXC(cmd: %len(cmd));
                   on-error;
                      status='error CLRPFM FILE(qtemp/stddat)           ';
                      exsr      SR_log;
                endmon;
             reade %kds(HRCLVL130l_k:1) HRCLVL130l  HRCLVL130l_i;
          enddo;

          close HRCLVL130l;


       //Korrektur: SCDDAT = 'NEU     '  übergabe System neu
       //Freigabe aller Rechnungen ab Stapel
       //Lars updatet das SCDDAT = 'Yce'
       //Markant-Gruppe   WRTDAT ab >'20220721'
       //Amazon           WRTDAT ab >'20220816'
            exec sql
               update EDIFACT/stddat set SCDDAT = 'NEU '
               where MSGTYP ='INVOIC' and
                     HRCLVL ='100000000' and
                     SCDDAT = ' ' and
               (   PRTNUM like '%DE_MARKANT%' or
                   PRTNUM like 'MARKANT_RECHNUNG%'  or
                   PRTNUM =    'EZ_MARKANT_RECHNUNG' or
                   PRTNUM = 'COOLBLUE_RECHNUNG' OR
                   PRTNUM like 'AKTIVBANK_SELECT%' or
                   PRTNUM like 'AMAZON%' or
                   PRTNUM like 'VOLVO_RECHNUNG%' or
                   PRTNUM like 'MM_RECHNUNG%' or
                   PRTNUM like 'WESSELS_RE%' or
                   PRTNUM like 'BOL_RECHNUNG%' or
                   PRTNUM like 'OBI_RECHNUNG%' or
                   PRTNUM like 'TRADEINN_RECHNUNG%' or
                   PRTNUM like 'SCANIA_RECHNUNG%' or
                   PRTNUM like 'GALAXUS_RECHNUNG%' or
                   PRTNUM like 'HOGAST_RECHNUNG%' or
                   PRTNUM like 'AKTIVBANK_WM%' or
                   PRTNUM like 'CONRAD_RECHNUNG%' or
                   PRTNUM like 'TECCOM_RECHNUNG%')
                and WRTDAT >'20251001';

        //Versandstatus auf 'NEU ' setzen und Übergabedatum neu vorbelegen
        //Freigabe aller DAF-Rechnungen,
        //zu denen ein korrespondierender Lieferschein existiert,
        //dessen Status ungleich 'NF' (= nicht fertig) ist
        //Derzeit werden nur DAF-Rechnungen berücksichtigt!! (Probezeit)
            exec sql
            UPDATE EDIFACT.stddat r
            SET r.SCDDAT = 'NEU ',
                r.A35#03 = VARCHAR_FORMAT(CURRENT DATE, 'YYYYMMDD'),
                r.A35#04 = VARCHAR_FORMAT(CURRENT DATE, 'YYYYMMDD'),
                r.A35#13 = VARCHAR_FORMAT(CURRENT DATE, 'YYYYMMDD')
            WHERE r.MSGTYP = 'INVOIC'
              AND r.HRCLVL = '100000000'
              AND r.SCDDAT <> 'Yce'
              AND r.PRTNUM = 'DAF_RECHNUNG'
              AND (SUBSTR(r.WRTDAT, 1, 4) CONCAT r.A35#12) IN (
                    SELECT SUBSTR(l.WRTDAT, 1, 4) CONCAT l.A35#12
                    FROM EDIFACT.stddat l
                    WHERE r.HRCLVL = l.HRCLVL
                      //'NF' = nicht fertig, daher noch kein Rechnungsversand
                      AND l.SCDDAT <> 'NF'
                      AND l.PRTNUM = 'DAF_LIEFERSCHEIN'
                  );
       endsr;

       //-----------------------------------------------------------------------
       //    ORDRSP
       //    Achtung update nur für akuelle noch einbauen und teilweise test
       //-------------------------------------------------------cc--------------

       begsr sr_ORDRSP;

       //a25#1 => Warenempfänger Abladestelle HA04
       //a25#2 => Werksnummer PODC
       //a35#10 => Lieferantennummer
       //a35#11 => ILN
       exec sql
        update edifact/stddat a set (a25#1, a25#2, a35#10, a35#11) =
        (select  EKABST,  EKWKKD, EKLFBK, EKILNR from TVPF/AFED01 b
          where
            a.maikey = b.EKAFNR
            and b.EKAFJJ = substr(a.WRTDAT, 1, 4)
            and b.EKFIRM = '01'
            and a.MSGTYP = 'ORDRSP'
            and a.HRCLVL = '120000000'
            and a.maikey in (select c.maikey from edifact/stddat c
            where
          a.maikey = c.maikey and
          a.MSGTYP = c.MSGTYP and
          c.SCDDAT <> 'Yce' and
          c.HRCLVL = '100000000')  )
         where exists
         (select  EKABST,  EKWKKD, EKLFBK, EKILNR from TVPF/AFED01 b
           where
            a.maikey = b.EKAFNR
            and b.EKAFJJ = substr(a.WRTDAT, 1, 4)
            and b.EKFIRM = '01'
            and a.MSGTYP = 'ORDRSP'
            and a.HRCLVL = '120000000'
            and a.maikey in (select c.maikey from edifact/stddat c
            where
            a.maikey = c.maikey and
            a.MSGTYP = c.MSGTYP and
            c.SCDDAT <> 'Yce' and
            c.HRCLVL = '100000000')  );

       //ORDRSP Update Empfänger-Kennung für Ingloo aus EDI-Auftrag
       //DILA 15.11.2024
       exec sql
       UPDATE EDIFACT.STDDAT A SET A.A35#02 =(
        SELECT B.EKILNR FROM TVPF.AFED01 B
        WHERE  B.EKAFNR = A.A35#07 AND
        B.EKAFJJ = SUBSTR( A.WRTDAT, 1, 4 ) AND
        B.EKFIRM = '01' AND A.A35#01 = B.EKLFBK AND
        A.A35#01 = '7315090000001' AND
        A.MSGTYP = 'ORDRSP' AND A.HRCLVL = '100000000' AND
        A.SCDDAT <> 'Yce' AND B.EKILNR <> ' ')
         WHERE  EXISTS(
         SELECT B.EKILNR FROM TVPF.AFED01 B
         WHERE  B.EKAFNR = A.A35#07 AND
         B.EKAFJJ = SUBSTR( A.WRTDAT, 1, 4 ) AND
         B.EKFIRM = '01' AND A.A35#01 = B.EKLFBK AND
         A.A35#01 = '7315090000001' AND
         A.MSGTYP = 'ORDRSP' AND A.HRCLVL = '100000000' AND
         A.SCDDAT <> 'Yce' AND B.EKILNR <> ' ');

       //ORDRSP update Lieferbedingung
       //wird aus dem Kundenauftrag entnommen
       exec sql
       update edifact/stddat a set a.a3#08 =
       (select b.AKLIBD from TVPF/AFKO01 b where
       ((b.AKAFJJ concat b.AKAFNR ) = (substr(a.WRTDAT, 1, 4) concat a.A35#07)
         and b.AKFIRM = '01' and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000'
         and b.AKLIBD <> ' ' and a.SCDDAT <> 'Yce'))
       where exists
       (select b.AKLIBD from TVPF/AFKO01 b where
       ((b.AKAFJJ concat b.AKAFNR ) = (substr(a.WRTDAT, 1, 4) concat a.A35#07)
         and b.AKFIRM = '01' and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000'
         and b.AKLIBD <> ' ' and a.SCDDAT <> 'Yce'));

       //ORDRSP update Kunden LF-Nr-bei-Kunde
       exec sql
           update EDIFACT/STDDAT a set a.A17#4= (
            select b.AKKDNR from TVPF/AFKO01 b
            where b.AKAFNR = a.MAIKEY and b.AKAFJJ = substr(a.WRTDAT, 1, 4)
            and b.AKFIRM = '01' and b.AKKDNR <> ' '
            and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000'
            and a.SCDDAT <> 'Yce' and a.WRTDAT >'20240130')
           where exists (
            select b.AKKDNR from TVPF/AFKO01 b
            where b.AKAFNR = a.MAIKEY and b.AKAFJJ = substr(a.WRTDAT, 1, 4)
            and b.AKFIRM = '01' and b.AKKDNR <> ' '
            and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000'
            and a.SCDDAT <> 'Yce' and a.WRTDAT >'20240130');


       //ORDRSP update Kunden LF-Nr-bei-Kunde von Kundenstamm (TECCOM)
       //For Dometic Germany 4015704000009 only
       exec sql
        UPDATE EDIFACT.STDDAT A SET A.A35#10 = (
         SELECT B.KDLIFN FROM TVPF.KUND03 B
                    WHERE
                        A.MSGTYP = 'ORDRSP' AND
                        A.A17#4  = B.KDKDNR AND
                        A.HRCLVL = '120000000' AND
                        A.A35#01 = '4015704000009' AND
                        B.KDFIRM = '01' AND
                        A.MAIKEY IN (
                    SELECT C.MAIKEY FROM EDIFACT.STDDAT C
                    WHERE  A.MAIKEY = C.MAIKEY AND
                           A.MSGTYP = C.MSGTYP AND
                           A.WRTDAT = C.WRTDAT AND
                                      C.HRCLVL = '100000000' AND
                                      C.SCDDAT <> 'Yce'))
          WHERE  EXISTS(
           SELECT B.KDLIFN FROM TVPF.KUND03 B
            WHERE
                A.MSGTYP = 'ORDRSP' AND
                A.A17#4  = B.KDKDNR AND
                A.HRCLVL = '120000000' AND
                A.A35#01 = '4015704000009' AND
                B.KDFIRM = '01' AND
                A.MAIKEY IN (
            SELECT C.MAIKEY FROM EDIFACT.STDDAT C
            WHERE  A.MAIKEY = C.MAIKEY AND
                   A.MSGTYP = C.MSGTYP AND
                   A.WRTDAT = C.WRTDAT AND
                              C.HRCLVL = '100000000' AND
                              C.SCDDAT <> 'Yce'));

       //ORDRSP EAN Code
       exec sql
       update EDIFACT/STDDAT a set a.A35#01 =
       (select b.TEEANR from TVPF/TEIL01 b
        where   a.a35#03 = b.TETENR
         and b.TEEANR <> ' '
         and b.TEFIRM = '01'
         and a.MSGTYP = 'ORDRSP'
         and a.HRCLVL = '150000000'
         and a.a35#03 <> ' '
         and a.MAIKEY in (
          select c.MAIKEY from EDIFACT/STDDAT c
          where
          a.MAIKEY = c.MAIKEY and
          a.MSGTYP = c.MSGTYP and
          a.WRTDAT = c.WRTDAT and
          c.SCDDAT <> 'Yce' and
          c.HRCLVL = '100000000'))
        where exists
        (select b.TEEANR from TVPF/TEIL01 b
         where   a.a35#03 = b.TETENR
          and b.TEEANR <> ' '
          and b.TEFIRM = '01'
          and a.MSGTYP = 'ORDRSP'
          and a.HRCLVL = '150000000'
          and a.a35#03 <> ' '
          and a.MAIKEY in (
            select c.MAIKEY from EDIFACT/STDDAT c
            where
            a.MAIKEY = c.MAIKEY and
            a.MSGTYP = c.MSGTYP and
            a.WRTDAT = c.WRTDAT and
            c.SCDDAT <> 'Yce' and
            c.HRCLVL = '100000000'));

       //KD-Ident-Nr
       //ORDRSP Kunden-Produkt-Information
       //ORDRSP Kaufer IdentNr
        exec sql
        update EDIFACT/STDDAT a set a.A35#02 = (
         select b.KPIDEN from TVPF/KPIF b
          where
              b.KPTENR = a.a35#03 and b.KPFIRM = '01'
          and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '150000000'
          and a.a35#02 <> ' '
          and a.MAIKEY in (
           select c.MAIKEY from EDIFACT/STDDAT c
           where
           b.KPKDNR = c.a17#4  and a.MAIKEY = c.MAIKEY and
           a.MSGTYP = c.MSGTYP and a.WRTDAT = c.WRTDAT and
           c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'))
          where exists (
           select b.KPIDEN from TVPF/KPIF b
           where
           b.KPTENR = a.a35#03 and b.KPFIRM = '01'
           and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '150000000'
           and a.a35#02 <> ' '
           and a.MAIKEY in (
            select c.MAIKEY from EDIFACT/STDDAT c
            where
            b.KPKDNR = c.a17#4  and a.MAIKEY = c.MAIKEY and
            a.MSGTYP = c.MSGTYP and a.WRTDAT = c.WRTDAT and
            c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'
          ));

       //RESPONSE CODE 27-Abgehlent, im Falle wenn
       //alle Positionen storniert sind | Pos. A3#01=2 = Storniert
        exec sql
        update edifact/stddat a set a.a3#01 = '27' where
        (select COUNT(b.maikey) from edifact/stddat b where
         a.maikey = b.maikey and a.msgtyp = b.msgtyp and a.prtnum = b.prtnum and
         b.hrclvl = '150000000' group by b.maikey
        ) =
        (select COUNT(b.maikey) from edifact/stddat b where
         a.maikey = b.maikey and a.msgtyp = b.msgtyp and a.prtnum = b.prtnum and
         b.hrclvl = '150000000' and b.A3#01 = '2' group by b.maikey
        )
        and a.MAIKEY in ( select c.MAIKEY from EDIFACT/STDDAT c
         where a.MAIKEY = c.MAIKEY and a.MSGTYP = c.MSGTYP and
         a.WRTDAT = c.WRTDAT and c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'
        ) and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000';

       //RESPONSE CODE 29-Akzeptiert im Falle wenn
       //alle Positionen akzeptiert sind | Pos. A3#01=5 => Akzeptiert
        exec sql
        update edifact/stddat a set a.a3#01 = '29' where
        (select COUNT(b.maikey) from edifact/stddat b where
         a.maikey = b.maikey and a.msgtyp = b.msgtyp and a.prtnum = b.prtnum and
         b.hrclvl = '150000000' group by b.maikey
        ) =
        (select COUNT(b.maikey) from edifact/stddat b where
         a.maikey = b.maikey and a.msgtyp = b.msgtyp and a.prtnum = b.prtnum and
         b.hrclvl = '150000000' and b.A3#01 = '5' group by b.maikey
        )
        and a.MAIKEY in ( select c.MAIKEY from EDIFACT/STDDAT c
         where a.MAIKEY = c.MAIKEY and a.MSGTYP = c.MSGTYP and
         a.WRTDAT = c.WRTDAT and c.SCDDAT <> 'Yce' and c.HRCLVL = '100000000'
        ) and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000';

       //RESPONSE CODE wenn Status 2 dann wird das Feld np2#5
       //mit stornierten Mengen befüllt
       exec sql
       update edifact/stddat a set a.np2#5 = a.np2#1 where
       a.hrclvl = '150000000' and a.A3#01 = '2' and a.MSGTYP = 'ORDRSP' and
       a.MAIKEY IN
        (SELECT b.MAIKEY FROM EDIFACT/STDDAT b WHERE
         a.MAIKEY = b.MAIKEY AND a.MSGTYP = b.MSGTYP AND b.SCDDAT <> 'Yce'
         and b.HRCLVL = '100000000'
       );

       //RESPONSE CODE 4-Aenderung im Falle wenn
       //wenn Positionen storniert und akzeptiert worden sind
       //Pos. A3#01=2 = Storniert und Pos. A3#01=5 => Akzeptiert
        exec sql
        update edifact/stddat a set a.a3#01 = '4' where (
         select COUNT(b.maikey) from edifact/stddat b where
         a.maikey = b.maikey and a.msgtyp = b.msgtyp and a.prtnum = b.prtnum and
         a.prtnum = b.prtnum and b.hrclvl = '150000000' and
         b.A3#01 = '2' group by b.maikey HAVING COUNT(b.maikey) > 0
       ) > 0 and (
        select COUNT(b.maikey) from edifact/stddat b where
        a.maikey = b.maikey and a.msgtyp = b.msgtyp and
        a.prtnum = b.prtnum and b.hrclvl = '150000000' and
        b.A3#01 = '5' group by b.maikey HAVING COUNT(b.maikey) > 0
       ) > 0 and a.MAIKEY in (
        select c.MAIKEY from EDIFACT/STDDAT c where a.MAIKEY = c.MAIKEY and
        a.MSGTYP = c.MSGTYP and a.WRTDAT = c.WRTDAT and c.SCDDAT <> 'Yce' and
        c.HRCLVL = '100000000'
       ) and a.MSGTYP = 'ORDRSP' and a.HRCLVL = '100000000';


       //Update der Käufer-GLN für Igloo mit dem Feld EDI-ILN
       //ORDRSP Tabelle ZKUND liefert EDI-Kundenstamm (7315090000001)
        EXEC SQL
        UPDATE EDIFACT.STDDAT A SET A.A17#2 =(
        SELECT B.KZEDIB FROM TVPF.ZKUN01 B
            WHERE
            B.KZFIRM = '01' AND
            A.HRCLVL = '120000000' AND
            A.A17#1  = '7315090000001' AND
            B.KZEDIB <> ' ' AND
            A.MSGTYP = 'ORDRSP'
        AND
            A.MAIKEY CONCAT B.KZKDNR IN (
            SELECT C.MAIKEY CONCAT C.A17#4 FROM EDIFACT.STDDAT C
            WHERE
            A.MAIKEY = C.MAIKEY AND
            A.WRTDAT = C.WRTDAT AND
            A.MSGTYP = C.MSGTYP AND
            C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'))
        WHERE  EXISTS(
        SELECT B.KZEDIB FROM TVPF.ZKUN01 B
            WHERE
            B.KZFIRM = '01' AND
            A.HRCLVL = '120000000' AND
            A.A17#1  = '7315090000001' AND
            B.KZEDIB <> ' ' AND
            A.MSGTYP = 'ORDRSP'
        AND
            A.MAIKEY CONCAT B.KZKDNR IN (
            SELECT C.MAIKEY CONCAT C.A17#4 FROM EDIFACT.STDDAT C
            WHERE
            A.MAIKEY = C.MAIKEY AND
            A.WRTDAT = C.WRTDAT AND
            A.MSGTYP = C.MSGTYP AND
            C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'));

       //GLN-Warenempfänger  ORDRSP frü Igloo
       //Update EDI-ILN aus der Kunden-Versand-Adresse (KDVS01)
       //Unter Voraussetzung, es gibt eine aktive Lieferadresse
       //Über AFKO wird eine Lieferadresse-Nr. bestimmt,
       //da es gibt mehrere Adressen in Kunden-Versand-Adresse
       EXEC SQL
       UPDATE EDIFACT.STDDAT A SET A.A17#3 =(
        SELECT B.VSEDIL FROM TVPF.KDVS01 B, TVPF.AFKO01 C
            WHERE B.VSFIRM = '01' AND
                A.HRCLVL = '120000000' AND
                A.A17#1 = '7315090000001' AND
                B.VSEDIL <> ' ' AND A.MSGTYP = 'ORDRSP' AND
                B.VSKDNR = C.AKKDNR AND A.MAIKEY = C.AKAFNR AND
                SUBSTR (A.WRTDAT, 1 , 4) = C.AKAFJJ AND
                B.VSVSNR = C.AKVSNR AND
                A.MAIKEY CONCAT B.VSKDNR IN(
                SELECT C.MAIKEY CONCAT C.A17#4 FROM EDIFACT.STDDAT C
                WHERE  A.MAIKEY = C.MAIKEY AND
                A.WRTDAT = C.WRTDAT AND A.MSGTYP = C.MSGTYP AND
                C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'))
        WHERE  EXISTS(
        SELECT B.VSEDIL FROM TVPF.KDVS01 B, TVPF.AFKO01 C
            WHERE B.VSFIRM = '01' AND
                A.HRCLVL = '120000000' AND
                A.A17#1 = '7315090000001' AND
                B.VSEDIL <> ' ' AND A.MSGTYP = 'ORDRSP' AND
                B.VSKDNR = C.AKKDNR AND A.MAIKEY = C.AKAFNR AND
                SUBSTR (A.WRTDAT, 1 , 4) = C.AKAFJJ AND
                B.VSVSNR = C.AKVSNR AND
                A.MAIKEY CONCAT B.VSKDNR IN(
                SELECT C.MAIKEY CONCAT C.A17#4 FROM EDIFACT.STDDAT C
                WHERE  A.MAIKEY = C.MAIKEY AND
                A.WRTDAT = C.WRTDAT AND A.MSGTYP = C.MSGTYP AND
                C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'));

       //Aktualisierung des Dokumenten-/Nachrichtendatum (CCJJMMTT)
       //Betrifft ORDRSP und DESADV
       exec sql
       UPDATE EDIFACT.stddat SET (a35#04) = (WRTDAT)
       WHERE SCDDAT <> 'Yce' and HRCLVL = '100000000'
       and MSGTYP in ('ORDRSP', 'DESADV');

       //Rückmeldung nach Verarbeitung 'Yce' wie bei ORDRSP
       exec sql
          update EDIFACT/stddat set SCDDAT = 'NEU     ', a1#1 = ' '
          where MSGTYP ='ORDRSP' and
                HRCLVL ='100000000' and
                SCDDAT = '        ' and
                WRTDAT >'20240310';
       endsr;


       //-----------------------------------------------------------------------
       //    DESADV
       //-------------------------------------------------------cc--------------

       begsr sr_DESADV;

       //DESADV update Abladestelle und Kundenwerk
       //Sonderfall betrifft DAF, kann aber bei anderen Kunden auftr
       //Auftragsnummer muss zuerst aus HRCLVL = '100000000' holen
       //HRCLVL = 120000000
       exec sql
       update edifact/stddat g set (g.a25#1, g.a25#2) =
       (select e.EKABST, e.EKWKKD from edifact/stddat d,
       (select a.maikey, a.MSGTYP, a.WRTDAT, b.EKABST, b.EKWKKD from
       edifact/stddat a, TVPF/AFED01 b
       where a.a35#14 = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4) and
       b.EKFIRM = '01' and a.HRCLVL = '100000000' and a.MSGTYP = 'DESADV'
       and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
       and a.maikey in (select c.maikey from edifact/stddat c
       where a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and c.SCDDAT <>
       'Yce' and c.HRCLVL = '100000000')) e
       where e.maikey = d.maikey and e.MSGTYP = d.MSGTYP and e.WRTDAT =
       d.WRTDAT and g.maikey = d.maikey and g.MSGTYP = d.MSGTYP and
       g.WRTDAT = d.WRTDAT and d.HRCLVL = '120000000' and
       d.MSGTYP = 'DESADV' and d.HRCLVL = g.HRCLVL)
       where exists
       (select e.EKABST, e.EKWKKD from edifact/stddat d,
       (select a.maikey, a.MSGTYP, a.WRTDAT, b.EKABST, b.EKWKKD from
       edifact/stddat a, TVPF/AFED01 b
       where a.a35#14 = b.EKAFNR and b.EKAFJJ = substr(a.WRTDAT, 1, 4) and
       b.EKFIRM = '01' and a.HRCLVL = '100000000' and a.MSGTYP = 'DESADV'
       and (b.EKABST <> ' ' OR b.EKWKKD <> ' ')
       and a.maikey in (select c.maikey from edifact/stddat c
       where a.maikey = c.maikey and a.MSGTYP = c.MSGTYP and c.SCDDAT <>
       'Yce' and c.HRCLVL = '100000000')) e
       where e.maikey = d.maikey and e.MSGTYP = d.MSGTYP and e.WRTDAT =
       d.WRTDAT and g.maikey = d.maikey and g.MSGTYP = d.MSGTYP and
       g.WRTDAT = d.WRTDAT and d.HRCLVL = '120000000' and
       d.MSGTYP = 'DESADV' and d.HRCLVL = g.HRCLVL);

       //DESADV update   test and b.VSKDNR='401579'
       //                Versandadresse(GLN#!!!) wird anstelle der
       //                Käuferadresse verwendet, da über if ifak/Ifad-Dateien
       //                keine weiteren Einstellungsmöglichkeiten
       //                muss: a17#2=KäuferGLN, a17#3=VersanadresseGLN
       //                muss: a17#2=KäuferGLN, a17#3=VersanadresseGLN
       exec sql
       update EDIFACT/STDDAT a set a.a17#3 = (
       select b.VSEDIL from tvpf/kdvs01 b where
        a.a35#09=b.VSKDNR and b.VSFIRM='01' and
        a.HRCLVL='120000000' and
        a.MSGTYP='DESADV' and a.PrtNum='GLOBUS_LS' and
        a.MAIKEY IN (
         SELECT C.MAIKEY FROM EDIFACT/STDDAT C WHERE
         A.MAIKEY = C.MAIKEY AND
         A.MSGTYP = C.MSGTYP AND C.SCDDAT <> 'Yce' AND C.HRCLVL = '100000000'
        ))
        where exists (
        select b.VSEDIL from tvpf/kdvs01 b where
         a.a35#09=b.VSKDNR and b.VSFIRM='01' and
         a.HRCLVL='120000000' and
         a.MSGTYP='DESADV' and a.PrtNum='GLOBUS_LS' and
         a.MAIKEY IN (
          SELECT C.MAIKEY FROM EDIFACT/STDDAT C WHERE
          A.MAIKEY = C.MAIKEY AND
          A.MSGTYP = C.MSGTYP AND C.SCDDAT <> 'Yce' AND C.HRCLVL = '100000000'
        ));

       //GLN-Buyer DESADV für Igloo
       //Update EDI-ILN aus der Kunden-EDI aus ZKUN01
       exec sql
        UPDATE EDIFACT.STDDAT A SET A.A17#2 =(
        SELECT B.KZEDIB FROM TVPF.ZKUN01 B
            WHERE
            B.KZFIRM = '01' AND
            A.HRCLVL = '120000000' AND
            A.A17#1  = '7315090000001' AND
            A.A35#09 = B.KZKDNR AND
            B.KZEDIB <> ' ' AND
            A.MSGTYP = 'DESADV' AND
            A.PRTNUM = 'MM_LIEFERSCHEIN' AND
            A.MAIKEY IN (
            SELECT C.MAIKEY FROM EDIFACT.STDDAT C
            WHERE
            A.MAIKEY = C.MAIKEY AND
            A.WRTDAT = C.WRTDAT AND
            A.MSGTYP = C.MSGTYP AND
            C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'))
       WHERE  EXISTS(
       SELECT B.KZEDIB FROM TVPF.ZKUN01 B
            WHERE
            B.KZFIRM = '01' AND
            A.HRCLVL = '120000000' AND
            A.A17#1  = '7315090000001' AND
            A.A35#09 = B.KZKDNR AND
            B.KZEDIB <> ' ' AND
            A.MSGTYP = 'DESADV' AND
            A.PRTNUM = 'MM_LIEFERSCHEIN' AND
            A.MAIKEY IN (
            SELECT C.MAIKEY FROM EDIFACT.STDDAT C
            WHERE
            A.MAIKEY = C.MAIKEY AND
            A.WRTDAT = C.WRTDAT AND
            A.MSGTYP = C.MSGTYP AND
            C.HRCLVL = '100000000' AND C.SCDDAT <> 'Yce'));

       //GLN-Warenempfänger DESADV für Igloo
       //Update EDI-ILN aus der Kunden-Versand-Adresse (KDVS01)
       //Unter Voraussetzung, es gibt eine aktive Lieferadresse
       exec sql
       UPDATE EDIFACT.STDDAT A
       SET A.A17#3 = (
         SELECT MIN(B.VSEDIL)
         FROM TVPF.KDVS01 B
         WHERE B.VSKDNR = A.A35#09
           AND B.VSVSST = '01'
           AND B.VSFIRM = '01'
           AND B.VSEDIL <> ' '
           AND A.A17#1 = '7315090000001'
           AND A.HRCLVL = '120000000'
           AND A.MSGTYP = 'DESADV'
           AND A.MAIKEY IN (
             SELECT C.MAIKEY
             FROM EDIFACT.STDDAT C
             WHERE A.MAIKEY = C.MAIKEY
               AND A.MSGTYP = C.MSGTYP
               AND A.WRTDAT = C.WRTDAT
               AND C.SCDDAT <> 'Yce'
               AND C.HRCLVL = '100000000'
         ))
         WHERE EXISTS(
         SELECT 1
           FROM TVPF.KDVS01 B
           WHERE B.VSKDNR = A.A35#09
           AND B.VSVSST = '01'
           AND B.VSFIRM = '01'
           AND B.VSEDIL <> ' '
           AND A.A17#1 = '7315090000001'
           AND A.HRCLVL = '120000000'
           AND A.MSGTYP = 'DESADV'
           AND A.MAIKEY IN (
             SELECT C.MAIKEY
             FROM EDIFACT.STDDAT C
             WHERE A.MAIKEY = C.MAIKEY
               AND A.MSGTYP = C.MSGTYP
               AND A.WRTDAT = C.WRTDAT
               AND C.SCDDAT <> 'Yce'
               AND C.HRCLVL = '100000000'
           ));

       // Update: add year to delivery note number
       exec sql
         UPDATE EDIFACT.STDDAT A
           SET A.A35#12 = (
           SELECT (substr(a.WRTDAT, 1, 4) concat B.MAIKEY)
           FROM EDIFACT.STDDAT B
           WHERE
               A.MAIKEY = B.MAIKEY
           AND A.MSGTYP = B.MSGTYP
           AND A.WRTDAT = B.WRTDAT
           AND A.HRCLVL = B.HRCLVL
           AND A.A35#12 <> ' '
           AND A.HRCLVL = '100000000'
           AND A.MSGTYP = 'DESADV'
           AND A.PRTNUM = 'MM_LIEFERSCHEIN'
           AND A.SCDDAT <> 'Yce')
           where exists
           (
           SELECT (substr(a.WRTDAT, 1, 4) concat B.MAIKEY)
           FROM EDIFACT.STDDAT B
           WHERE
               A.MAIKEY = B.MAIKEY
           AND A.MSGTYP = B.MSGTYP
           AND A.WRTDAT = B.WRTDAT
           AND A.HRCLVL = B.HRCLVL
           AND A.A35#12 <> ' '
           AND A.HRCLVL = '100000000'
           AND A.MSGTYP = 'DESADV'
           AND A.PRTNUM = 'MM_LIEFERSCHEIN'
           AND A.SCDDAT <> 'Yce');

       //Freigabe des Prozesses/Sätze durch uns
       //Rückmeldung nach Verarbeitung 'Yce' wie bei DESADV
       exec sql
          update EDIFACT/stddat set SCDDAT = 'NEU     ', a1#1 = ' '
          where MSGTYP = 'DESADV' and
                PRTNUM <> 'AMAZON_LS' and
                HRCLVL = '100000000' and
                (SCDDAT = '     ' or  SCDDAT = 'M ') and
                WRTDAT > '20251203';

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

       //callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
       //               p_outfil: p_lib:    p_repadd);
         clear status;

       //callP     QMHSNDPM('CPF9897': 'QCPFMSG   *LIBL':
       //            Msg: MsgLen: '*ESCAPE':
       //            '*': 3: TheKey: dsEC);

       endsr;


