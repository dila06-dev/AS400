     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
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
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      * CRTDUPOBJ OBJ(AFVS) FROMLIB(TVPF)
      * OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(AFVS)
      *
      * SELECT AVJDAT , count(*) FROM afvs WHERE AVPROG in ('IFDTRELN_',
      * 'IFDTRELN#') and AVFIRM ='01' and AVJDAT > 20220101 GROUP BY avjdat
      * ORDER BY AVjdat
      *
      * SELECT substr(char(AVJDAT), 1, 6), AVPROG, AVKDLI ,count(*),
      * current timestamp FROM AFVS01 WHERE AVfirm ='01' and AVKMJJ =2023
      * GROUP BY substr(char(AVJDAT), 1, 6) , AVPROG, AVKDLI ORDER BY
      * AVKDLI ,AVPROG
      * Datei CHECKTRACK in TVRELWAECO wurde ersetzt.
      *
      * SELECT substr(char(AVJDAT), 1, 6), AVPROG, AVKDLI, AVHINW,
      * count(*), current timestamp FROM AFVS01 WHERE AVfirm ='01' and
      * AVKMJJ =2023 GROUP BY substr(char(AVJDAT), 1, 6) , AVPROG, AVKDLI,
      * avhinw ORDER BY AVKDLI ,AVPROG
      *
      * Schafflik mit getestet
      * beipack
      * select * from VLF95DWE/frdtp
      * where bcd ='K012023105243'
      * SELECT-Anweisung vollständig verarbeitet.
      * select fir, btnr, trkz, snsts, fvsat, dsk01, dsk02, dsk05,
      * idbcd, vsrhf, lsnr, faunr, snref, vsrhe
      * , a.* from frdtn a  where vsnr ='0002092372'       0002091140
      * SELECT-Anweisung vollständig verarbeitet.
      *
      * select fir, btnr, trkz, snsts, fvsat, dsk01, dsk02, dsk05,
      * idbcd, vsrhf, lsnr, faunr, snref, vsrhe
      * , a.* from VLF95DWE/frdtn a  where vsrhf like 'K012023100203%'
      * trafko???????
      * SELECT avjdat,avjzei,AVPROG, AVBIBL,AVKMJJ, AVKMNR, AVKMPO,AVKMNN,
      * AVTENR, AVDPDN, AVPAKN, AVKdli, AVHINW FROM AFVS01 WHERE AVfirm
      * ='01' and AVKMJJ =2023 and AVPROG= 'TRAFKOST' and AVPAKN =' ' ORDER
      * BY AVJDAT, AVJZEI,AVFIRM, AVKMJJ, avkmnr
      *
      *********************************************************************************

     f***man       uf   e             disk
     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)
     F***                                     USROPN

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
     Dpos              s             10i 0
     D
     D$d               S              3A
     D$d2              S              2A
     D$m               S              2A
     D$j               S              4A
     D
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

     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C*                  open      man
     C*                  DO        *HIVAL
     C*
     C*                  READ      man                                    95
     C*                  IF        *in95 = '1'
     C*                  leave
     C*                  else
     C*                  movel     man12         artnr
     C*                  exsr      srlines
     c*                  update    phy01r
     c*                  endif
     C
     C*                  enddo
     C*                  close     man
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*select '0' concat                       ---------------------------------
     C*       char(DAY(current date - 1 days)) ---------------------------------
     C*       FROM qsys2/qsqptabl              ---------------------------------
     C*-------------------------------------------------------------------------
     C*select '0' concat                        --------------------------------
     C*       char(month(current date - 1 days))--------------------------------
     C*       FROM qsys2/qsqptabl               --------------------------------
     C*-------------------------------------------------------------------------
     C*select char(year(current date - 1 days))---------------------------------
     C*       FROM qsys2/qsqptabl              ---------------------------------
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------
     C*-------------------------------------------------------------------------

     C*data base
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CRTDUPOBJ OBJ(AFVS) FROMLIB(TVPF) '  +
           'OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(AFVS)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by CRTDUPOBJ OBJ(AFVS)                      ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/AFVS_Rhena';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared delete TVRELWAECO/AFVS_Rhena';
          exsr      SR_log;
       endmon;
      /End-Free


     c                   clear                   $d
     c                   clear                   $m
     c                   clear                   $j
     c/exec sql
     c+ select '0' concat char(DAY(current date - 1 days)),
     c+        '0' concat char(month(current date - 1 days)),
     c+         char(year(current date - 1 days))
     c+ into :$d,
     c+      :$m,
     c+      :$j
     c+         FROM qsys2/qsqptabl
     c/end-exec

     c                   move      $d            $d2
     c                   exsr      sr6600
     c                   exsr      sr6800
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'DLTF QTEMP/AFVS ';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by dltf qtemp/afvs                          ';
          exsr      SR_log;
       endmon;
      /End-Free


     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C**************************************************************************
     C*time stamp      VLF95DWE/frdtn    APDTT (APDTM =:$m  and  APDTT > :$d2)
     C*-------------------------------------------------------------------------
     C*
     C     sr6600        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     c*
     C*-alle mit AVKMNN = 0   ????WAIFKMST????
     c/exec sql
     c+ delete FROM tvpf/AFVS01 WHERE AVKMJJ > 2025 and AVKMNN =0
     c/end-exec
     c*
     C*-alle mit ohne Bezug   ????WAIFKMST????
     c*/exec sql
     c*+ delete   FROM tvpf/AFVS01 WHERE AVfirm ='01' and AVKMJJ >2023
     c*+                    and AVPROG = 'WAIFKMST' and AVPAKN = ' '
     c*/end-exec
     c*
     C*-alle mit falschem Bezug bei Dachser ohne Italien
     c/exec sql
     c+ delete   FROM tvpf/AFVS01 WHERE AVfirm ='01' and AVKMJJ >2023 and
     c+ AVPROG = 'WAIFKMST' and AVPAKN <>' '  and
     c+ AVFIRM not in ( select alfirm from tvpf/aflp01 where
     c+                     AVKMJJ = AlKMJJ and
     c+ AVKMNR = AlKMNR and ALKDNR='055278')
     c+
     c/end-exec
     c*
     C*-1-
     c/exec sql
     c+ insert into qtemp/AFVS
     c+ select  char(' ', 1) aVLOCK,  char('GANG#', 10)   AVJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   AVJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)  AVJZEI,
     c+        char('GANG#', 10)                AVUSER,
     c+        char('TRACKINGa', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)          AVBIBL,
     c+         substr(FIR, 1, 2)               AVFIRM,
     c+         zoned((substr(dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(VSRHE, 9, 6)), 6, 0) AVKMNR,
     c+         zoned(pkavs, 04, 0)              AVKMPO,
     c+         zoned((substr(VSRHE, 9, 6)), 6, 0) AVKMNN,
     c+         char('  ', 09)                   AVFR01,
     c+         zoned(PKASN, 04, 0)              AVANZA,
     c+         zoned(fvsgw/1000, 09, 4)         AVGWBR,
     c+         zoned(SNNGW/1000, 09, 4)         AVGWNT,
     c+         zoned(SNVLM, 09, 2)              AVVOLU,
     c+         char('2', 15)                    AVTENR,
     c+         char(' ', 01)                    AVKZ01,
     c+         char('L', 01)                    AVKLKZ,
     c+         char(' ', 02)                    AVKZ04,
     c+         zoned(0, 04, 0)                  AVABJJ,
     c+         char(' ', 06)                    AVABNR,
     c+         substr(DSK05, 1, 08)             AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c+         substr(VSRHE, 1, 20)             AVDPDN,
     c+         char(' ', 15)                    AVFRIN,
     c+         char('N', 1)                     AVDSKZ,
     c+         char(' ', 2)                     AVDSDF,
     c+         char(' ', 1)                     AVDSUE,
     c+         substr(TRKNR, 1, 20)             AVPAKN,
     c+         substr(frf, 1, 06) concat '              '  AVHINW
     c+ from    VLF95DWE/frdtn     a
     c+         where   dsk01 <> '    ' and dsk05 <> '    '  and
     c+                 substr(VSRHF, 1, 1) <> 'K'
     c+          and  elDTJ='2024' and nds03<100000000  and
     c+           (elDTM ='10' or elDTM ='10' or elDTM ='10')
     c*           (APDTM ='10' or APDTM ='10' or APDTM ='10')
     c*           (APDTM =:$m)
     c/end-exec
     c
     c
     C*-2-
     c/exec sql
     c+ insert into qtemp/AFVS
     c+ select  char(' ', 1) aVLOCK,  char('GANG#', 10)   AVJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   AVJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)  AVJZEI,
     c+         char('GANG#', 10)                AVUSER,
     c+         char('TRACKINGb', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)           AVBIBL,
     c+         substr(FIR, 1, 2)                AVFIRM,
     c+         zoned((substr(dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(dsk02, 1, 6)), 6, 0) AVKMNR,
     c+         zoned(pkavs, 04, 0)              AVKMPO,
     c+         zoned((substr(dsk02, 1, 6)), 6, 0) AVKMNN,
     c+         char('  ', 09)                   AVFR01,
     c+         zoned(PKASN, 04, 0)              AVANZA,
     c+         zoned(fvsgw/1000, 09, 4)         AVGWBR,
     c+         zoned(SNNGW/1000, 09, 4)         AVGWNT,
     c+         zoned(SNVLM, 09, 2)              AVVOLU,
     c+         char('2', 15)                    AVTENR,
     c+         char(' ', 01)                    AVKZ01,
     c+         char('L', 01)                    AVKLKZ,
     c+         char(' ', 02)                    AVKZ04,
     c+         zoned(0, 04, 0)                  AVABJJ,
     c+         char(' ', 06)                    AVABNR,
     c+         substr(DSK05, 1, 08)             AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c+          substr(VSRHE, 1, 20)             AVDPDN,
     c+         char(' ', 15)                    AVFRIN,
     c+         char('N', 1)                     AVDSKZ,
     c+         char(' ', 2)                     AVDSDF,
     c+         char(' ', 1)                     AVDSUE,
     c+         substr(TRKNR, 1, 20)             AVPAKN,
     c+ substr(frf, 1, 06) concat '              '  AVHINW
     c+ from    VLF95DWE/frdtn     a
     c+         where   dsk01 <> '    ' and dsk05 <> '    ' and
     c+                 dsk02 <> '    ' and
     c+                 substr(VSRHF, 1, 1) = 'K'
     c+      and  elDTJ='2024' and nds03<100000000  and
     c+           (elDTM ='10' or elDTM ='10' or elDTM ='10')
     c*           (APDTM =:$m)
     c/end-exec
     c*
     c
     C*-3-
     c/exec sql
     c+ insert into qtemp/AFVS
     c+ select  char(' ', 1) aVLOCK,  char('GANG#', 10)  AVJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   AVJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)  AVJZEI,
     c+         char('GANG#', 10)                AVUSER,
     c+         char('TRACKINGc', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)           AVBIBL,
     c+         substr(a.fir, 1, 2)              AVFIRM,
     c+         zoned((substr(a.dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(b.bcd, 8, 6)), 6, 0)   AVKMNR,
     c+         zoned(a.pkavs, 04, 0)              AVKMPO,
     c+        zoned((substr(b.bcd, 8, 6)), 6, 0) AVKMNN,
     c+        char('  ', 09)                   AVFR01,
     c+        zoned(a.PKASN, 04, 0)              AVANZA,
     c+        zoned(a.fvsgw/1000, 09, 4)         AVGWBR,
     c+        zoned(a.SNNGW/1000, 09, 4)         AVGWNT,
     c+        zoned(a.SNVLM, 09, 2)              AVVOLU,
     c+        char('2', 15)                    AVTENR,
     c+        char(' ', 01)                    AVKZ01,
     c+        char('L', 01)                    AVKLKZ,
     c+        char(' ', 02)                    AVKZ04,
     c+        zoned(0, 04, 0)                  AVABJJ,
     c+        char(' ', 06)                    AVABNR,
     c+        substr(a.DSK05, 1, 08)             AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c+        substr(b.bcd, 1, 20)             AVDPDN,
     c+        char(' ', 15)                    AVFRIN,
     c+        char('N', 1)                     AVDSKZ,
     c+        char(' ', 2)                     AVDSDF,
     c+        char(' ', 1)                     AVDSUE,
     c+        substr(a.trknr, 1, 20)           AVPAKN,
     c+        substr(a.frf, 1, 06) concat '              '  AVHINW
     c+        from vlf95dwe/frdtn a inner join vlf95dwe/frdtp b on
     c+        a.fir  = b.fir and
     c+        a.btnr = b.btnr and
     c+        a.elj  = b.elj and
     c+        a.vsnr = b.vsnr and
     c+        a.vspn = b.vspn
     c+        where  substr(a.vsrhf, 1, 13) <> substr(b.bcd, 1, 13)
     c+               and a.dsk01 <> '    ' and a.dsk05 <> '    '
     c+               and elDTJ='2024' and a.nds03<100000000
     c+               and                  b.nds03<100000000
     c+               and (elDTM ='10' or elDTM ='10' or elDTM ='10')
     c***************************************************************
     c**       from VLF95DWE/frdtn a       ,VLF95DWE/frdtp b
     c**where  a.dsk01 <> '    ' and a.dsk05 <> '    '   and
     c**       a.FIR = b.FIR and a.BTNR = b.btnr and a.elj = b.elj
     c**       and a.VSNR = b.VSNR and a.VSPN = b.VSPN and pkpn<>'000001'
     c**     and  elDTJ='2023' and a.nds03<100000000  and
     c**                           b.nds03<100000000  and
     c**         (elDTM ='01' or elDTM ='02' or elDTM ='03')
     c**         (APDTM =:$m)
     c/end-exec
     C*
     C*

     C     ##6600        ENDSR


     C**************************************************************************
     C*-------------------------------------------------------------------------
     C*
     C     sr6800        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*
     C*Wechsel eines Spediteurs
     C*
     c/exec sql
     c+ update qtemp/AFVS set AVKDLI=
     c+ ( select substr(TPTTXT, 1, 08) from trtp01
     c+   WHERE  substr(AVHINW, 1, 06) =TPTCDE and
     c+   tpfirm= AVFIRM   and tptart='FRACHTFUER' and TPSPCD='D')
     c+ where exists
     c+ ( select substr(TPTTXT, 1, 08) from trtp01
     c+   WHERE  substr(AVHINW, 1, 06) =TPTCDE and
     c+   tpfirm= AVFIRM   and tptart='FRACHTFUER' and TPSPCD='D')
     c/end-exec

     C*von mandant 80(Rhenania) Wechsel auf 01(Trend)
     C*
     c/exec sql
     c+ update qtemp/AFVS  set avfirm='01' where avfirm='80'
     c/end-exec

     c/exec sql
     c+  insert into tvrelwaeco/SAVE_AFVS
     c+  select * from qtemp/afvs
     c/end-exec

     c/exec sql
     c+  insert into tvrelwaeco/SAVE_FRDTN
     c+  select * from qtemp/FRDTN
     c/end-exec

     C*
     C*Originalsätze aus Trend für Austausch Sicherung
     c/exec sql
     c+ insert into tvrelwaeco/AFVS_Rhena
     c+ SELECT AVLOCK, AVJNAM, AVJDAT, AVJZEI, AVUSER, AVPROG, AVBIBL,
     c+ AVFIRM, AVKMJJ, AVKMNR, AVKMPO, AVKMNN, AVFR01, AVANZA, AVGWBR,
     c+ AVGWNT, AVVOLU, AVTENR, AVKZ01, AVKLKZ, AVKZ04, AVABJJ, AVABNR,
     c+ AVKDLI, AVABMS, AVTMST, AVDPDN, AVFRIN, AVDSKZ, AVDSDF, AVDSUE,
     c+ AVPAKN, AVHINW , current timestamp tstampi
     c+ FROM tvpf/AFVS a
     c+ WHERE a.AVKMNR in (select b.AVKMNR
     c+ from  qtemp/AFVS b where  A.AVFIRM=b.AVFIRM and
     c+                           A.AVKMJJ=b.AVKMJJ and
     c+                           A.AVKMNR=b.AVKMNr and
     c+                           a.AVKMJJ>2023     and
     c+                           a.avkmnn > 0)
     c/end-exec
     C*
     C*evtl. Übernahme original Inhalte
     c/exec sql
     c+ update qtemp/AFVS a set AVHINW=
     c+ ( select AVHINW from tvrelwaeco/AFVS_Rhena b
     c+   WHERE              A.AVFIRM=b.AVFIRM and
     c+                      A.AVKMJJ=b.AVKMJJ and
     c+                      A.AVKMNR=b.AVKMNR)
     c+ where exists
     c+ ( select AVHINW from tvrelwaeco/AFVS_Rhena b
     c+   WHERE              A.AVFIRM=b.AVFIRM and
     c+                      A.AVKMJJ=b.AVKMJJ and
     c+                      A.AVKMNR=b.AVKMNR)
     c/end-exec


     C                   clear                   count            10 0
     C*
     C*Protokoll Originalsätze für Austausch später rausnehmen
     c/exec sql
     c+ SELECT count(*) into :count
     c+ FROM tvpf/AFVS a
     c+ WHERE a.AVKMNR in (select b.AVKMNR
     c+ from  qtemp/AFVS b where  A.AVFIRM=b.AVFIRM and
     c+                           A.AVKMJJ=b.AVKMJJ and
     c+                           A.AVKMNR=b.AVKMNR)
     c/end-exec

     c                   eval      status='Sätze ausgetauscht: ' +
     c                                     %char(count) + ' '    +
     c                                     %char(tstampi)
     C                   exsr      sr_log

     C                   clear                   count            10 0
     C*
     c/exec sql
     c+ SELECT count(*) into :count
     c+ FROM qtemp/AFVS
     c/end-exec

     c                   eval      status='Sätze übergeben: ' +
     c                                     %char(count) + ' '    +
     c                                     %char(tstampi)
     C                   exsr      sr_log

     C*
     C*alte Sätze löschen aus Trend
     c/exec sql
     c+ delete from tvpf/AFVS a
     c+ WHERE a.AVKMNR in (select b.AVKMNR
     c+ from  qtemp/AFVS b where  A.AVFIRM=b.AVFIRM and
     c+                           A.AVKMJJ=b.AVKMJJ and
     c+                           A.AVKMNR=b.AVKMNr and
     c+                           A.AVKMPO=b.AVKMPO and
     c+                           A.AVKMJJ>2023     and
     c+                           A.avkmnn > 0      )    and
     c+                    substr(a.AVPROG, 1, 8) <>'IFDTRELN' and
     c+                    substr(a.AVPROG, 1, 8) <>'TRACKING'
     c/end-exec

     c/exec sql
     c+ insert into tvpf/AFVS
     c+ SELECT *  FROM qtemp/AFVS a
     c+ WHERE a.AVKMNR not in (select b.AVKMNR
     c+ from  tvpf/AFVS b where   A.AVFIRM=b.AVFIRM and
     c+                           A.AVKMJJ=b.AVKMJJ and
     c+                           A.AVKMNR=b.AVKMNr and
     c+                           A.AVKMPO=b.AVKMPO and
     c+                           A.AVKMJJ>2023     and
     c+                           A.avkmnn > 0)
     c/end-exec


     C                   clear                   count            10 0
     C*
     C*Protokoll Originalsätze für Austausch    später rausnehmen
     C*Abweichungen geänderten Lieferanten
     c/exec sql
     c+ select count(*) into :count     from qtemp/AFVS
     c+         where avfirm in
     c+       ( select avfirm from afsp where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         asnumm = avkmnr and ASKART = 'KMNR' and
     c+         AVKDLI <> assped  and AVANZA = 1 )
     c/end-exec

     c                   eval      status='geänderter Lieferant:' +
     c                                     %char(count) + ' '    +
     c                                     %char(tstampi)
     C                   exsr      sr_log

     C                   clear                   count            10 0

     C*Update des evtl geänderten Speferanten
     c/exec sql
     c+ update tvpf/afsp  set assped  =
     c+ (select distinct AVKDLI from qtemp/AFVS where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         char(asnumm)=char(AVKMNR) and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2023)
     c+  where exists
     c+ (select distinct AVKDLI from qtemp/AFVS where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         char(asnumm)=char(AVKMNR) and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2023)
     c/end-exec

     c/exec sql
     c+ update  afvs01 set   AVKDLI ='90330'
     c+ WHERE substr(AVHINW, 1, 03)='DAC' and
     c+       substr(AVPAKN, 1, 10)='0034015704'
     c+                 and AVKDLI ='*NO AFVS'
     c+                 and avfirm='01'
     c/end-exec

     c/exec sql
     c+ update  afsp set  ASSPED ='90330   '
     c+ WHERE ASFIRM ='01' and ASKDNR ='078680' and
     c+       ASSPED ='*NO AFVS' and  ASNUMM   in
     c+ (select AVKMNR  from afvs01 where   AVFIRM =asfirm and
     c+          AVKMJJ =asjahr and substr(AVPAKN, 1, 10)='0034015704'
     c+          and  ASKART ='KMNR' and AVKMJJ > 2023 )
     c/end-exec

     c/exec sql
     c+ update  afsp set  ASSPED ='92225   '
     c+ WHERE ASFIRM ='01' and ASKDNR ='055278' and
     c+       ASSPED ='*NO AFVS' and  ASNUMM   in
     c+ (select AVKMNR  from afvs01 where   AVFIRM =asfirm and
     c+          AVKMJJ =asjahr and substr(AVPAKN, 1, 10)='0034015704'
     c+          and  ASKART ='KMNR' and AVKMJJ > 2023 )
     c/end-exec

     C*

     C     ##6800        ENDSR


     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

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

     C**********************************************************************
     C*Sicherung in das Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_log        BEGSR
      *
      *
     C                   clear                   md
     C                   movel     §§§JNO        §§§JNO#          06
     C                   movea(p)  'TRACKINGR '  md(001)
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
     C**************************************************************************
