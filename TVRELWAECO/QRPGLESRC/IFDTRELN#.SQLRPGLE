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
      *
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

     C*write
     c                   exsr      sr9999
     c                   exsr      sr7000
     c                   exsr      sr1000
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

     C*
     C*Ableitungen für Übergaben in qtemp
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
     c+         char('IFDTRELN#', 10)            AVPROG,
     c+         char('TVRELWAECO', 10)           AVBIBL,
     c+         substr(VSRHE, 1, 2)              AVFIRM,
     c+         zoned((substr(dsk01, 1, 4)), 4, 0) AVKMJJ,
     c+         zoned((substr(VSRHE, 9, 6)), 6, 0) AVKMNR,
     c*****     substr(VSRHF, 9, 6)              AVKMNR,
     c+         zoned(pkavs, 04, 0)              AVKMPO,
     c+         zoned((substr(VSRHE, 9, 6)), 6, 0) AVKMNN,
     c+         char('  ', 09)                   AVFR01,
     c+         zoned(PKASN, 04, 0)              AVANZA,
     c+         zoned(fvsgw/1000, 09, 4)         AVGWBR,
     c+         zoned(SNNGW/1000, 09, 4)         AVGWNT,
     c+         zoned(SNVLM, 09, 4)              AVVOLU,
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
     c+ from    VLF95DWE/frdtn        a
     c+         where   dsk01 <> '    ' and dsk05 <> '    '
     c***+ from    VLF95DWE/frdtn        a
     c***+ where   VSNR >'0000002999'
     c/end-exec


     C*Wechsel eines Spediteurs
     C*
     c/exec sql
     c+ update qtemp/AFVS set AVKDLI=
     c+ ( select substr(TPTTXT, 1, 08) from trtp01
     c+   WHERE  substr(AVHINW, 1, 06) =TPTCDE and
     c+   tpfirm='01' and tptart='FRACHTFUER' and TPSPCD='D')
     c+ where exists
     c+ ( select substr(TPTTXT, 1, 08) from trtp01
     c+   WHERE  substr(AVHINW, 1, 06) =TPTCDE and
     c+   tpfirm='01' and tptart='FRACHTFUER' and TPSPCD='D')
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


     C*Update des evtl geänderten Speferanten
     c/exec sql
     c+ update tvpf/afsp  set assped  =
     c+ (select distinct AVKDLI from qtemp/AFVS where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         asnumm = avkmnr and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 )
     c+  where exists
     c+ (select distinct AVKDLI from qtemp/AFVS where
     c+         asfirm = avfirm and asjahr = avkmjj and
     c+         asnumm = avkmnr and ASKART = 'KMNR' and
     c+         AVKDLI <> assped and AVKMPO = 1 )
     c/end-exec


     C     ##1000        ENDSR

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
