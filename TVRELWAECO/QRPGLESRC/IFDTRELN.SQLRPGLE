     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * STRSEU SRCFILE(TVRELWAECO/QRPGLESRC) SRCMBR(IFDTRELN) OPTION( 2)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * update auf afsp feld assped
      * SELECT assped FROM afsp WHERE ASFIRM ='01' and ASJAHR =2014 and
      * ASKART = 'KMNR' and asnumm='315057' ORDER BY assped
      *
      *
      * SELECT AVKMPO, AVKMNN, AVKDLI FROM test/AFVS WHERE AVFIRM ='01' and
      * AVKMJJ =2014 and AVKMNR ='309511'
      *
      * select assped from afsp where
      *               asfirm = avfirm and
      *               asjahr = avkmjj and
      *               asnumm = avkmnr and
      *               ASKART = 'KMNR'
      *
      *  update afsp01 set assped  =
      *  (select AVKDLI from afvs where
      *          asfirm = avfirm and asjahr = avkmjj and
      *          asnumm = avkmnr and  ASKART = 'KMNR'
      *          and asnumm='xxxxxx' and asfirm ='__')
      *   where exists
      *  (select AVKDLI from afvs where
      *          asfirm = avfirm and asjahr = avkmjj and
      *          asnumm = avkmnr and  ASKART = 'KMNR'
      *          and asnumm='xxxxxx' and asfirm ='__')
      *
      * SELECT idbcd, vsrhe, eltim FROM VLF95DWE/frdtn WHERE idbcd not in
      * (select avpakn from afvs where AVPROG ='IFDTRELN#')
      *
      * SELECT SNSTS, count(*) FROM VLF95DWE/frdtn WHERE idbcd not in
      * (select avpakn from afvs where AVPROG ='IFDTRELN#') GROUP BY snsts
      *
      * 1
      * SELECT *        FROM VLF95DWE/frdtn WHERE snsts='3' and idbcd not
      * in (select avpakn from  tvpf/afvs where AVPROG ='IFDTRELN#')
      * Datei FRDTN in QTEMP wurde erstellt.
      *
      * 2
      * call IFDTRELN
      *
      *
      *
      *SELECT substr(LKDNR, 1, 6) Kunde, substr(LNAM1, 1, 30) Name1,
      *substr(LNAM2, 1, 30) Name2, lkz Land, plz, ort, LSTR, apdtj concat
      *APDTM concat APDTT Datum, APTIM zeit, LSNR liefersch, FREBT
      *NachnahmeRF, FVSGW,VSBKZ, fAUNR auftrag,nve Sendungsnummer,
      *substr(vsrhe, 1, 20) scan, PKASn Pakete#,PKAVS FROM VLF95DWE/frdtn
      *WHERE apdtj concat APDTM concat APDTT >'20150100' and
      *lkdnr='078678' or FREBT <> 0
      *
      *
      * SELECT substr(LKDNR, 1, 6) Kunde, substr(LNAM1, 1, 30) Name1,
      * substr(LNAM2, 1, 30) Name2, lkz Land, plz, ort, LSTR, apdtj concat
      * APDTM concat APDTT Datum, APTIM zeit, LSNR liefersch, FREBT
      * NachnahmeRF, FVSGW,VSBKZ, fAUNR auftrag,nve Sendungsnummer,
      * substr(vsrhe, 1, 20) scan, PKASn Pakete#,PKAVS ,FDS01 asn#,
      * LBSNR FROM VLF95DWE/frdtn WHERE apdtj concat APDTM concat APDTT
      * >'20150100' and lkdnr='055278' or FREBT <> 0
      * Datei REMOVERS in TVRELWAECO wurde erstellt.
      * select * from removers
      * SELECT-Anweisung vollständig verarbeitet.
      * select * from removers
      *
      * insert into qtemp/frdtn
      * SELECT * FROM VLF95DWE/frdtn WHERE LFTMJ = '2016' and snsts='3
      * and idbcd not in (select avpakn from tvpf/afvs
      * where AVPROG ='IFDTRELN#' or AVPROG ='IFDTRELN_')
      *
      *** VLF95DWE
      *** VLPLGUSR
      *** VLF95USR
      *** VLNABUSR27
      * select * from frdtp
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      *  PKASN               PKAVS
      *      1                   1
      *  gesamtanzahl        laufende
      *  Pakete                  1
      *      1                   1
      *
      *  SELECT * FROM tvrelwaeco/AFVS a , tvpf/AFVS b WHERE
      *  A.AVKMJJ=b.AVKMJJ and a.AVDPDN=b.avdpdn and
      *  A.AVFIRM=b.AVFIRM and
      *  A.AVKMNR=b.AVKMNR
      *  #SR-250838   06.07.2023 last action
      *********************************************************************************

     fAFVS      uf   e             disk
     f                                     RENAME(AFVS1:phy01r)
     f*********                            INFDS(DSF1)
     F                                     USROPN

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
     C     *ENTRY        PLIST
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

     C*update infos     aus VLF95DWE/Qrpglesrc/IFDW119
     c*****              call      'IFDW119'
     C*freigaben
     c                   call      'PUBLICC'
     C*write
     c                   exsr      sr9999
     c                   exsr      sr7000
     c                   exsr      sr1000
     C*IGLOO
     c************       exsr      srIGLOO
     C*ezetil Sendungsverfolgung
     c*******            exsr      sr2000
     C*Mandant 52 Sendungsverfolgung
     c*******            exsr      sr2000_52
     C*-alle mit falschem Bezug bei Dachser
     c/exec sql
     c+ update tvpf/afvs01 set avfirm='01'
     c+ WHERE avfirm='80' and  AVKMJJ >'2022'
     c/end-exec
     c                   setoff                                       77

     C                   open      AFVS
     C                   DO        *HIVAL
     C
     C                   READ      AFVS                                   95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c   77              update    phy01r
     c                   endif

     C                   enddo
     C                   close     AFVS
b
     c                   exsr      sr7200
     c                   exsr      sr7500
     C*neu mail über Trend
     c                   call      'IFDTRELNII'
     C*freigaben
     c                   call      'PUBLICC'

      /free
       MONITOR;
       Wrk.var1 =
           'DSPJOBLOG OUTPUT(*PRINT) ';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in DSPJOBLOG OUTPUT(*PRINT)                 ';
          exsr      SR_log;
       endmon;
      /End-Free


     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
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

     C*-alle mit AVKMNN = 0   ????WAIFKMST????
     c/exec sql
     c+ delete FROM tvpf/AFVS01 WHERE AVKMJJ > 2025 and AVKMNN =0
     c+                                             and AVKDLI <> '92214'
     c/end-exec
     c*
     C*-alle mit ohne Bezug   ????WAIFKMST????
     c*/exec sql
     c*+ delete   FROM tvpf/AFVS01 WHERE AVfirm ='01' and AVKMJJ >2025
     c*+                    and AVPROG = 'WAIFKMST' and AVPAKN = ' '
     c*+                                            and AVKDLI <> '92214'
     c*/end-exec
     c*
     C*-alle mit falschem Bezug bei Dachser
     c/exec sql
     c+ delete   FROM tvpf/AFVS01 WHERE AVfirm ='01' and AVKMJJ >2025 and
     c+ AVPROG = 'WAIFKMST' and AVPAKN <>' '                     and
     c+ AVFIRM not in ( select alfirm from tvpf/aflp01 where
     c+                     AVKMJJ = AlKMJJ and
     c+ AVKMNR = AlKMNR and ALKDNR='055278') and AVKDLI <> '92214'
     c/end-exec
     c*
     C*
     C*Ableitungen für Übergaben in qtemp ab 11.04.2016 aufgrund der
     C*vielen manuellen Eingaben wieder aktivieren
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
     c+        char('IFDTRELNa', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)          AVBIBL,
     c+         substr(FIR, 1, 2)               AVFIRM,
     c+         zoned((substr(dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(VSRHE, 9, 6)), 6, 0) AVKMNR,
     c*****     substr(VSRHF, 9, 6)              AVKMNR,
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
     c*******+         'TEST     '                      AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c*******+   substr(VSRHF, 1, 20)             AVDPDN,
     c+         substr(VSRHE, 1, 20)             AVDPDN,
     c+         char(' ', 15)                    AVFRIN,
     c+         char('N', 1)                     AVDSKZ,
     c+         char(' ', 2)                     AVDSDF,
     c+         char(' ', 1)                     AVDSUE,
     c+         substr(TRKNR, 1, 20)             AVPAKN,
     c+         substr(frf, 1, 06) concat '              '  AVHINW
     c+
     c+ from    QTEMP/FRDTN        a
     c+         where   dsk01 <> '    ' and dsk05 <> '    '  and
     c+                 substr(VSRHF, 1, 1) <> 'K' and nds03<100000000
     c***+                 APDTJ>'2015' and APDTM>'01'
     c***+ from    VLF95DWE/frdtn        a
     c***+ where   VSNR >'0000200000'
     c/end-exec

     C*Ableitungen für Übergaben in qtemp
     C*ab 15.02.2016 für E+P Übergaben hier Feld DSK02 = 'KOMMNR'
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
     c+         char('IFDTRELNb', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)           AVBIBL,
     c+         substr(FIR, 1, 2)                AVFIRM,
     c+         zoned((substr(dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(dsk02, 1, 6)), 6, 0) AVKMNR,
     c*****     substr(VSRHF, 9, 6)              AVKMNR,
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
     c******+         'TEST     '                      AVKDLI,
     c+         char(' ', 15)                    AVABMS,
     c+         zoned(0, 26, 0)                  AVTMST,
     c******    substr(VSRHF, 1, 20)             AVDPDN,
     c+         substr(VSRHE, 1, 20)             AVDPDN,
     c+         char(' ', 15)                    AVFRIN,
     c+         char('N', 1)                     AVDSKZ,
     c+         char(' ', 2)                     AVDSDF,
     c+         char(' ', 1)                     AVDSUE,
     c+         substr(TRKNR, 1, 20)             AVPAKN,
     c+         substr(frf, 1, 06) concat '              '  AVHINW
     c+
     c+ from    QTEMP/FRDTN        a
     c+         where   dsk01 <> '    ' and dsk05 <> '    ' and
     c+                 dsk02 <> '    ' and  nds03<100000000  and
     c+                 substr(VSRHF, 1, 1) = 'K'
     c***+ from    VLF95DWE/frdtn        a
     c***+ where   VSNR >'0000002999'
     c/end-exec

     c*/exec sql
     c*+    insert into tvrelwaeco/TRACEAV
     c*+    select * from QTEMP/FRDTN a
     c*+         where   dsk01 <> '    ' and dsk05 <> '    ' and
     c*+                 dsk02 <> '    ' and  nds03<100000000  and
     c*+                 substr(VSRHF, 1, 1) = 'K'
     c*/end-exec

     C*
     C*Ableitungen für Übergaben in qtemp   BEIPACK
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
     c+         char('IFDTRELNc', 10)            AVPROG,
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
     c+        from qtemp/frdtn a inner join vlf95dwe/frdtp b on
     c+        a.fir  = b.fir and
     c+        a.btnr = b.btnr and
     c+        a.elj  = b.elj and
     c+        a.vsnr = b.vsnr and
     c+        a.vspn = b.vspn
     c+        where  substr(a.vsrhf, 1, 13) <> substr(b.bcd, 1, 13)
     c+               and a.dsk01 <> '    ' and a.dsk05 <> '    '
     c+                                and a.nds03<100000000
     c+               and                  b.nds03<100000000
     c/end-exec
     c***************************************************************

     C*für Igloo update auf 01 step 1 Umsetzung Firma 70 auf ==> 01
     c/exec sql
     c+ update qtemp/AFVS   set   AVFIRM ='01'
     c+ WHERE AVFIRM ='70'
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
     c+                           a.AVKMJJ>2022     and
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
     c+                           a.AVKMJJ>2022     and
     c+                           a.avkmnn > 0)
     c/end-exec

     c/exec sql
     c+ insert into tvpf/AFVS
     c+ SELECT *  FROM qtemp/AFVS
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
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2022)
     c+  where exists
     c+ (select distinct AVKDLI from qtemp/AFVS where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         char(asnumm)=char(AVKMNR) and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2022)
     c/end-exec

     C*hier fehlende Einträge über Rhenania
     c/exec sql
     c+ update  afvs01 set   AVKDLI ='92225'
     c+ WHERE AVKDLI ='*NO AFVS' and substr(AVPAKN, 1, 10)='0034015704'
     c+                 and avfirm='01'
     c/end-exec

     c/exec sql
     c+ update  afsp set  ASSPED ='92225   '
     c+ WHERE ASFIRM ='01' and ASKDNR ='055278' and
     c+       ASSPED ='*NO AFVS' and  ASNUMM   in
     c+ (select AVKMNR  from afvs01 where   AVFIRM =asfirm and
     c+          AVKMJJ =asjahr and substr(AVPAKN, 1, 10)='0034015704'
     c+          and  ASKART ='KMNR' and AVKMJJ > 2022 )
     c/end-exec


     C     ##1000        ENDSR

     C**************************************************************************
     C*ezetil
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
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

     C
     C*tvpf/afvs01 hat alle Sätze nun aktuell eingelesen unter Firma
     C*diese müssen gesichert werden wegen der Kommzuornung aus
     C*aus Firma 01, da sie anschließend überschrieben werden
     c/exec sql
     c+ insert into saveafvs
     c+ SELECT * FROM afvs01 a WHERE a.AVFIRM ='20' and a.AVKMJJ not in
     c+ (select b.AvKMJJ from saveafvs b where a.AVKMNR= b.AVKMNR)
     c+ and a.AVKMJJ not in (select BEALBZKJ from beal01 where
     c+     BEALBZKM=AVKMNR and BEALBZFI='20')
     c/end-exec

     C*überschreibung der Kommnummerndaten AVKMJJ
     c/exec sql
     c+ update tvpf/AFVS01 set AVKMJJ =
     c+  (select BEALBZKJ from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   zoned(BEALKMNR)=AVKMNN and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c+  where exists
     c+  (select BEALBZKJ from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   zoned(BEALKMNR)=AVKMNN and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c/end-exec

     C*überschreibung der Kommnummerndaten AVKMnr
     c/exec sql
     c+ update tvpf/AFVS01 set AvKMNR =
     c+  (select BEALBZKM from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   BEALKMNR=AvKMNR and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c+  where exists
     c+  (select BEALBZKM from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   BEALKMNR=AvKMNR and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c/end-exec

     C*überschreibung der Kommnummerndaten AVKMnn
     C*Achtung vergleichskriterien nun überschrieben
     C*daten für firma 20 nun bereit in AFVS
     c/exec sql
     c+ update tvpf/AFVS01 set AVKMNN =
     c+  (select zoned(BEALBZKM) from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   zoned(BEALKMNR)=AVKMNN and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c+  where exists
     c+  (select zoned(BEALBZKM) from beal01 where
     c+                   BEALFIRM='01'   and
     c+                   BEALKMJJ=AVKMJJ and
     c+                   zoned(BEALKMNR)=AVKMNN and
     c+               BEALBZFI='20'
     c+   and    avfirm='20')
     c/end-exec

     C*spediteur holen, da er meistens fehlt im Datei
     C*sollte ggf eine andere Zuornung vorliegen, dann hier ggf. über-
     C*schreiben (case)
     c/exec sql
     c+ update tvpf/afsp  set assped  =
     c+ (select distinct max(AVKDLI) from tvpf/AFVS where
     c+         assped=' ' and                       avfirm='20' and
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         char(asnumm)=char(AVKMNR) and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2022
     c+         group by avfirm, avkmjj, avkmnr, avkmpo)
     c+  where exists
     c+ (select distinct max(AVKDLI) from tvpf/AFVS where
     c+         assped=' ' and                       avfirm='20' and
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         char(asnumm)=char(AVKMNR) and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 and ASJAHR > 2022
     c+         group by avfirm, avkmjj, avkmnr, avkmpo)
     c/end-exec

     C*
     C*Zuordnungen auch für Firma 01 zulassen
     C*Kommdaten sind bereits korrekt in Save
     c/exec sql
     c+ update saveafvs set avfirm ='01'
     c+ WHERE AVFIRM ='20' and AVKMJJ in (select
     c+ BEALKMJJ from beal01 where AVKMNR=BEALKMNR)
     c/end-exec

     C*Übergabe
     c/exec sql
     c+ insert into tvpf/AFVS
     c+ select * from saveafvs WHERE AVFIRM ='01'
     c/end-exec

     C*Übergabe löschen, da jetzt in afvs
     c/exec sql
     c+ delete   from saveafvs WHERE AVFIRM ='01'
     c/end-exec
     c

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*Mandant 52
     C*-------------------------------------------------------------------------

     C     sr2000_52     BEGSR
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

     C
     c/exec sql
     c+ insert into tvrelwaeco/afvs52
     c+ SELECT a.AVLOCK,a.AVJNAM,a.AVJDAT,a.AVJZEI,a.AVUSER,a.AVPROG,
     c+ a.AVBIBL, b.BEALBZFI, b.BEALBZKJ,
     c+ b.BEALBZKM,a.AVKMPO,a.AVKMNN,a.AVFR01,
     c+ a.AVANZA,a.AVGWBR,a.AVGWNT,a.AVVOLU,a.AVTENR,a.AVKZ01,a.AVKLKZ,
     c+ a.AVKZ04,
     c+ a.AVABJJ,a.AVABNR,a.AVKDLI,a.AVABMS,a.AVTMST,a.AVDPDN,a.AVFRIN,a
     c+ .AVDSKZ,a.AVDSDF,a.AVDSUE,a.AVPAKN,a.AVHINW FROM tvpf/AFVS01 a,
     c+ beal01 b WHERE b.BEALFIRM='01' and b.BEALKMJJ=a.AVKMJJ and
     c+ b.BEALKMNR=a.AvKMNR and b.BEALBZFI='52' and a.avFIRM='01' and
     c+ a.avkmjj > 2022 and a.AVKMNN <> 0  and a.AVJNAM ='GANG#'  and
     c+               b.BEALBZKM<>'000000'
     c+ and b.BEALBZFI not in (select c.avfirm   from afvs01 c where
     c+                b.BEALBZKJ=c.AVKMJJ   and b.BEALBZKM=c.AVKMNR  and
     c+                c.AVPAKN <>' ' and c.avfirm='52')
     c/end-exec

     C*Zuordnungen Spediteur
     c/exec sql
     c+ update tvrelwaeco/afvs52 set AVKDLI='0000726' where
     c+                   AVKDLI='92213'
     c/end-exec
     c
     C*Sicherung in TVRELWAECO/AFVS52SAV
     c/exec sql
     c+ insert into tvrelwaeco/AFVS52SAV
     c+ SELECT * FROM afvs01 a WHERE a.AVFIRM in (select b.BEALBZFI from
     c+ tvrelwaeco/afvs52 b where a.AVKMJJ=b.BEALBZKJ and
     c+ b.BEALBZKM=a.avkmnr and b.AVPAKN <> ' ' )
     c/end-exec
     c
     C*delete aus Original
     c/exec sql
     c+ delete   FROM afvs01 a WHERE a.AVFIRM in (select b.BEALBZFI from
     c+ tvrelwaeco/afvs52 b where a.AVKMJJ=b.BEALBZKJ and
     c+ b.BEALBZKM=a.avkmnr and b.AVPAKN <> ' ' )
     c/end-exec
     c
     C*Kopieren
     c/exec sql
     c+ insert into afvs01
     c+ select * from tvrelwaeco/afvs52
     c/end-exec
     c
     C*bereinigung für nächsten Lauf
     c/exec sql
     c+ delete   from   tvrelwaeco/afvs52
     c/end-exec
     c

     C     ##2000_52     ENDSR

     c*
     C**************************************************************************
     C*IGLOO
     C*-------------------------------------------------------------------------

     C     srIGLOO       BEGSR
     C*
     c
     C*step 3 löschen Originale aus Igloo über alt_igloo
     c/exec sql
     c+ insert into ALT_IGLOO
     c+ SELECT distinct BEALFIRM, BEALBZKJ, BEALBZKM
     c+ FROM tvpf/AFVS01,    frdtn,beal01 WHERE fir='70'
     c+ and SNSTS='3' and substr(VSRHF, 02, 02) <> ' '
     c+               and substr(VSRHF, 04, 04) <> ' '
     c+               and substr(VSRHF, 08, 06) <> ' '
     c+               and AvFIRM =
     c+ substr(VSRHF, 02, 02) and AvKMJJ = dec(substr(VSRHF, 04, 04)) and
     c+ AVKMNR = substr(VSRHF, 08, 06) and BEALFIRM = substr(VSRHF, 02, 02)
     c+ and BEALKMJJ = dec(substr(VSRHF, 04, 04)) and BEALKMNR =
     c+ substr(VSRHF, 08, 06)
     c/end-exec
     c
     C*delete aus Original
     c/exec sql
     c+ delete FROM tvpf/AFVS01  WHERE AVFIRM in (select BEALFIRM from
     c+ ALT_IGLoo where AVKMJJ=BEALBZKJ and AVKMNR=BEALBZKM)
     c/end-exec
     c
     C*integration in afvs die aus Igloo original
     c/exec sql
     c+ insert into tvpf/afvs01
     c+ SELECT distinct
     c+        AVLOCK, AVJNAM, AVJDAT, AVJZEI, 'IGLOO','IGLOO','TVRELWAECO',
     c+ BEALFIRM,BEALBZKJ,BEALBZKM,AVKMPO,
     c+  dec(BEALBZKM),                        AVFR01, AVANZA, AVGWBR,
     c+ AVGWNT, AVVOLU, AVTENR, AVKZ01, AVKLKZ, AVKZ04, AVABJJ, AVABNR,
     c+ AVKDLI, AVABMS, AVTMST, AVDPDN, AVFRIN, AVDSKZ, AVDSDF, AVDSUE,
     c+ AVPAKN, AVHINW
     c+ FROM afvs01,         frdtn,beal01 WHERE fir='70'
     c+ and SNSTS='3' and substr(VSRHF, 02, 02) <> ' '
     c+               and substr(VSRHF, 04, 04) <> ' '
     c+               and substr(VSRHF, 08, 06) <> ' '
     c+               and AvFIRM =
     c+ substr(VSRHF, 02, 02) and AvKMJJ = dec(substr(VSRHF, 04, 04)) and
     c+ AVKMNR = substr(VSRHF, 08, 06) and BEALFIRM = substr(VSRHF, 02, 02)
     c+ and BEALKMJJ = dec(substr(VSRHF, 04, 04)) and BEALKMNR =
     c+ substr(VSRHF, 08, 06)
     c/end-exec
     c
     C*bereinigung für nächsten Lauf
     c/exec sql
     c+ delete   from   tvrelwaeco/alt_igloo
     c/end-exec
     c
     c
     C*originale aus Rhenania werk 001 und immer Kunde 900089
     c/exec sql
     c+ insert into ALT_IGLOO2
     c+ SELECT DISTINCT AFSP01.ASLOCK, AFSP01.ASJNAM, AFSP01.ASJDAT,
     c+ ASJZEI, ASUSER, ASPROG, ASBIBL, ASFIRM, ASJAHR, ASNUMM, ASKART,
     c+ ASSPED, ASPENR, ASSTAT, ASKDNR, ASVSNR, ASAFJJ, ASAFNR, ASTOUR,
     c+ ASKOR1, ASVSKZ, ASKOR2, ASKMDA, ASSPDA, ASSUDA, ASGSAZ, ASGSGW,
     c+ ASEDVG, ASINCD, ASKZ01, ASKZ03, ASVOLU, ASWKNR, ASTEXT, ASPLAZ,
     c+ ASTENR, ASSDJJ, ASSDNR, ASRMDA, ASLFNR, ASPE2R, ASPE3R, ASFREX ,
     c+ BEALFIRM, BEALKMJJ, BEALKMNR, BEALBZKJ, BEALBZKM
     c+ FROM afsp01,         frdtn,beal01 WHERE fir='70' and
     c+     substr(VSRHF, 02, 02) <> ' '                 and
     c+     substr(VSRHF, 04, 04) <> ' '                 and
     c+     substr(VSRHF, 08, 06) <> ' '                 and
     c+ SNSTS='3' and ASKART = 'KMNR' and AsFIRM = substr(VSRHF, 02, 02)
     c+ and AsJAHR = dec(substr(VSRHF, 04, 04)) and AsNUMM = substr(VSRHF,
     c+ 08, 06) and BEALFIRM = substr(VSRHF, 02, 02) and BEALKMJJ =
     c+ dec(substr(VSRHF, 04, 04)) and BEALKMNR = substr(VSRHF, 08, 06)
     c/end-exec
     c
     C*Spediteur übergeben
     C*           Werk 001        Werk 010
     C*01  2.024   189737  2.024   183525
     C*01  2.024   189738  2.024   183530
     c/exec sql
     c+ update tvpf/afsp01 a set a.ASSPED =
     c+ (  select b.ASSPED FROM ALT_IGLOO2 b
     c+   WHERE a.ASKART = 'KMNR' and a.ASWKNR='010'
     c+      and a.ASFIRM = BEALFIRM
     c+      and a.ASJAHR = BEALBZKJ
     c+      and a.asnumm = BEALBZKM)
     c+ where exists
     c+ (  select b.ASSPED FROM ALT_IGLOO2 b
     c+   WHERE a.ASKART = 'KMNR' and a.ASWKNR='010'
     c+      and a.ASFIRM = BEALFIRM
     c+      and a.ASJAHR = BEALBZKJ
     c+      and a.asnumm = BEALBZKM)
     c/end-exec
     c
     C*bereinigung für nächsten Lauf afsp!!!!!!
     c/exec sql
     c+ delete   from   tvrelwaeco/alt_igloo2
     c/end-exec

     C     ##igloo       ENDSR

     c*
     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr7000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'QTEMP/AFVS';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CRTDUPOBJ OBJ(AFVS) FROMLIB(TVPF) ' +
           'OBJTYPE(*FILE) TOLIB(QTEMP) NEWOBJ(AFVS)';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file already existing   ';
          exsr      SR_log;
       endmon;
      /End-Free
     C*
     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'HLDWTR WTR(PRTLAG06) ';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by HLDWTR WTR(PRTLAG06)                     ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'RLSWTR WTR(PRTLAG06) ';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by RLSWTR WTR(PRTLAG06)                     ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/AFVS52';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared delete TVRELWAECO/AFVS52';
          exsr      SR_log;
       endmon;
      /End-Free

     C*
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

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ALT_IGLOO';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ALT_IGLOO2';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free


     C     ##7000        ENDSR

     c*
     C**************************************************************************
     C*command
     C*-------------------------------------------------------------------------

     C     sr7200        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'DLTF' + ' ' +
           'QTEMP/AFVS';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='DLTF QTEMP/AFVS on error, file not deleted        ';
          exsr      SR_log;
       endmon;
      /End-Free

     C     ##7200        ENDSR

     c*
     C**************************************************************************
     C*TVRELWAECO/OUTBOUND generieren
     C*SELECT * FROM frdtn WHERE frf ='DAC' and eldtj concat eldtm concat
     C*eldtt ='20160422'
     C*-------------------------------------------------------------------------

     C     sr7500        BEGSR
     C*
     C                   clear                   outbound          1
     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/OUTBOUND';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='outbound konnte nicht gelöscht werden             ';
          exsr      SR_log;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/OUTBOUNDOP';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='outboundop konnte nicht gelöscht werden           ';
          exsr      SR_log;
       endmon;
      /End-Free

     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C
     C                   if        outbound = ' '
     C*Ableitungen für Übergaben in qtemp
     c/exec sql
     c+ insert into TVRELWAECO/OUTBOUND
     c+ SELECT LKDNR,LNAM1,LNAM2,LKZ,PLZ,ORT,LSTR, apdtj
     c+        concat APDTM concat APDTT dateinput,
     c+        APTIM,LSNR,FREBT,FVSGW,VSBKZ,FAUNR,TRKNR,
     c+        VSRHE,PKASN,PKAVS,FVSAT,frf,FREBT,FNNBT,elnr,
     c+        LKDNA,eldtj concat eldtm concat eldtt outrhena,
     c+        '*' concat IDBCD IBCDE,
     c+        nve Sendungsn,VSRHF,VSBLG,VSBBR,VSBHO,VSBVO,
     c+        KFVSA, gate, current timestamp tstamp
     c+ from VLF95DWE/FRDTN WHERE SNSTS ='3'  and
     c+  date(date(substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 1, 4) concat '-'
     c+   concat substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 5, 2) concat '-'
     c+   concat substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 7, 2))) >
     c+      date(current date) - 095 day
     c/end-exec
     c
     C*Ableitungen für Übergaben in qtemp
     c/exec sql
     c+ insert into TVRELWAECO/OUTBOUNDOP
     c+ SELECT LKDNR,LNAM1,LNAM2,LKZ,PLZ,ORT,LSTR, apdtj
     c+        concat APDTM concat APDTT dateinput,
     c+        APTIM,LSNR,FREBT,FVSGW,VSBKZ,FAUNR,TRKNR,
     c+        VSRHE,PKASN,PKAVS,FVSAT,frf,FREBT,FNNBT,elnr,
     c+        LKDNA,eldtj concat eldtm concat eldtt outrhena,
     c+        '*' concat IDBCD IBCDE,
     c+        nve Sendungsn,VSRHF,VSBLG,VSBBR,VSBHO,VSBVO,
     c+        KFVSA, gate, current timestamp tstamp
     c+ from VLF95DWE/FRDTN WHERE SNSTS ='2'  and
     c+  date(date(substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 1, 4) concat '-'
     c+   concat substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 5, 2) concat '-'
     c+   concat substr(char(apdtj concat APDTM concat APDTT)
     c+                                             , 7, 2))) >
     c+      date(current date) - 095 day
     c/end-exec
     c
     c
     C*Ableitungen für Übergaben in qtemp
     c/exec sql
     c+   update outbound set OUTRHENA = DATEINPUT
     c+   WHERE OUTRHENA =  ' '
     c/end-exec
     c/exec sql
     c+   update outboundop set OUTRHENA = DATEINPUT
     c+   WHERE OUTRHENA =  ' '
     c/end-exec
     c                   endif
     C*
     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'RMVLNK    OBJLNK(''/Lager/Rhenania/outbound.CSV'')' ;
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          outbound  = '1';
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'RMVLNK    OBJLNK(''/Lager/Rhenania/outboundop.CSV'')' ;
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed                        ';
          exsr      SR_log;
       on-error;
          outbound  = '1';
          status='Error by rmvlnk object                           ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/outbound.CSV'') '  +
           'DBFILE(TVRELWAECO/OUTBOUND) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free

     c                   clear                   Wrk.var1
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/outboundop.CSV'') '  +
           'DBFILE(TVRELWAECO/OUTBOUNDOP) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          outbound  = '1';
          status='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free


     C     ##7500        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
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
     C                   movea(p)  'IFDTRELN  '  md(001)
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
