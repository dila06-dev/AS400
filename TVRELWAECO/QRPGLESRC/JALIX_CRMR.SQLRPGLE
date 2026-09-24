     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     D Wrk             DS                  Qualified inz
     D SatzGef                        1A   inz(' ')
     D BatPfad                      100A   inz(' ')
     D WebDName                     100A   inz(' ')
     D BatName                      100A   inz(' ')
     D Var1                         200A   inz(' ')
     D Laenge          s              9  0

     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr2000
     c                   exsr      sr1000
     c                   exsr      sr3000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
     C*-------------------------------------------------------------------------
     C*
      /FREE
       BEGSR sr1000;
         //
       exec sql
         //+ whenever not found goto ##1000
        whenever not found CONTINUE;
       exec sql
        WHENEVER SQLWARNING CONTINUE;
       exec sql
        WHENEVER SQLERROR  CONTINUE;

       //Grundaufbau  BE111, NL411
       exec sql
        insert into tvrelwaeco/JALIX_CRM
        SELECT KDFIRM, KDKDNR, KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD,
        KDPOLZ, KDWORT, KDPOFA, KDKNAM, KDHINW, KDKDGR, KDLANR,
        current timestamp upload , kdtlnr,
        vsnam1,vsnam2, vsnam3, vsstra, vspold, vspolz, vswort,
        vstlnr, vstxnr, vzvtn1
         FROM kund01 inner join kdvs01 on kdfirm = vsFirm and
        kdkdnr = vskdnr inner join vezu01 on kdfirm = vzfirm and
        kdkdnr = VZKDLI
        WHERE (KDFIRM ='08' or KDFIRM ='52')
        and KDKDST <> '90' and vzbegr = 'VE3';
       //timestamp upload FROM kund01 WHERE (KDFIRM ='08' or KDFIRM ='52')
       // and KDKDST <> '90';

       exec sql
        insert into tvrelwaeco/JALIX_CRM
        SELECT distinct
               KDFIRM, KDKDNR, KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD,
        KDPOLZ, KDWORT, KDPOFA, KDKNAM, KDHINW, KDKDGR, KDLANR,
        current timestamp upload , kdtlnr,
        KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD, kdpolz, kdwort,
        kdtlnr, kdtxnr, vzvtn1
        FROM kund01 inner join vezu01 on kdfirm = vzfirm and
                    kdkdnr = VZKDLI
        WHERE (KDFIRM ='08' or KDFIRM ='52')
          and KDKDST <> '90' and vzbegr = 'VE3' and  kdfirm
          not in (select vsFirm from kdvs01 where kdkdnr = VSKDNR);

       //Grundaufbau  de411
       exec sql
        insert into tvrelwaeco/JALIXDE411
        SELECT distinct
               KDFIRM, KDKDNR, KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD,
        KDPOLZ, KDWORT, KDPOFA, KDKNAM, KDHINW, KDKDGR, KDLANR,
        current timestamp upload , kdtlnr,
        vsnam1,vsnam2, vsnam3, vsstra, vspold, vspolz, vswort,
        vstlnr, vstxnr, vzvtn2
         FROM kund01 inner join kdvs01 on kdfirm = vsFirm and
        kdkdnr = vskdnr inner join vezu01 on kdfirm = vzfirm and
        kdkdnr = VZKDLI
        WHERE (KDFIRM ='01' and KDKDST <> '90' and vzbegr = 'VE3' and
               VZVTN1<> ' ');

       exec sql
        insert into tvrelwaeco/JALIXDE411
        SELECT distinct
               KDFIRM, KDKDNR, KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD,
        KDPOLZ, KDWORT, KDPOFA, KDKNAM, KDHINW, KDKDGR, KDLANR,
        current timestamp upload , kdtlnr,
        KDNAM1, KDNAM2, KDNAM3, KDSTRA, KDPOLD, kdpolz, kdwort,
        kdtlnr, kdtxnr, vzvtn1
        FROM kund01 inner join vezu01 on kdfirm = vzfirm and
                    kdkdnr = VZKDLI
         WHERE (KDFIRM ='01' and KDKDST <> '90' and vzbegr = 'VE3' and
                VZVTN1<> ' ') and kdfirm
          not in (select vsFirm from kdvs01 where kdkdnr = VSKDNR);
      /END-FREE

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'tvrelwaeco/JALIX_CRM';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free

     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'tvrelwaeco/JALIXDE411';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr3000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/NL/JALIX_CRM.CSV'') '  +
           'DBFILE(TVRELWAECO/JALIX_CRM) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/SALESCOMPANY/JALIXDE411.CSV'') '  +
           'DBFILE(TVRELWAECO/JALIXDE411) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free


     C     ##3000        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

      /FREE
       BEGSR sr9999;
         //
       exec sql
        whenever not found goto ##9999;
       exec sql
        WHENEVER SQLWARNING CONTINUE;
       exec sql
        WHENEVER SQLERROR  CONTINUE;
         //

       exec sql
        select current timestamp, current date, current time
        into   :tstampi, :datum, :zeit
        from   gang/systempf;

      /END-FREE
     C     ##9999        ENDSR

     C**************************************************************************
     C*.
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**********************************************************************
     C*Sicherung in das Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_log        BEGSR
      *
      *
     C                   clear                   md
     C                   movel     §§§JNO        §§§JNO#          06
     C                   movea(p)  'JALIX_CRMR'  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  §§§JNO#       md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C*                  MOVEA     ATR(14)       md(050)
     C                   movea(p)  status        md(051)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C                   clear                   status           70
      *
     C     ##_log        ENDSR
     C
     C**************************************************************************
