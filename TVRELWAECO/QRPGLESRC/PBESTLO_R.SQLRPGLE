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
     D l               s              9  0

     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz
     D p_inFIL         s             22a

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
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

      /free
          eval      status    =*blank;
          eval      status    =
                              'Sicherung PBESTOH in tvrelwaeco/PBESTLO#    ';
          exsr      SR_log;
          eval      status    =
                              'Sicherung PBESTOH in tvrelwaeco/PBESTLO#    ';
      /End-Free

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/PBESTLO#
     c+ SELECT BMKONZ, BMFIRM, BMORT, BMBER, BMGANG, BMREG, BMHOR, BMVER,
     c+ BMSEGM, BMCELL, BMLFDN, BMBLPX, BMBLPY, BMBLPZ, BMIDEN, BMIDV,
     c+ BMIDVA, BMPALN, BMPALP, BMLENR, BMZULE, BMZUNV, BMZUPK, BMEXLE,
     c+ BMBENR, BMRVOR, BMKZAR, BMRFAR, BMIAMF, BMMOSQ, BMMKOM, BMABWB,
     c+ BMABWN, BMLOC, BMTXTP, BMKZP, BMBST1, BMBSTP, BMPKNR, BMVENR,
     c+ BMIZSL, BMZUSL, BMZUSLA, BMZUNR, BMMOIQ, BMMOID, BMLIEF, BMWENR,
     c+ BMWEPO, BMZUBE, BMFNR1, BMFNRP, BMANR1, BMANRP, BMKDNR, BMREKZ,
     c+ BMRENR, BMPRN, BMBMEN, BMRMEN, BMVMEN, BMSTCK, BMEGEW, BMSGEW,
     c+ BMTARA, BMME, BMVPE, BMME1, BMVPE2, BMME2, BMMCAS, BMBART, BMQKZ,
     c+ BMQSTA, BMQCHR, BMDTEE, BMDTZU, BMTLM, BMLM, BMMLM, BMABKZ, BMALUT,
     c+ BMALUC, BMALUW, BMWAKZ, BMNRSP, BMKOMA, BMOWNR, BMAPN, BMAPPO,
     c+ BMAPN1, BMAPP1, BMLFD1, BMDTDC, BMHKLD, BMPRNR, BMREVS, BMMDRF,
     c+ BMSRN, BMKZEA, BMTXEA, BMSOFO, BMANB, BMRFNR, BMEXRF, BMSRRF,
     c+ BMDTRF, BMDTLI, BMDTSE, BMTISE, BMSEP1, BMSEP2, BMBOEN, BMBOEX,
     c+ BMEXRT, BMPPR, BMWAER, BMPPRF, BMWAEF, BMCPPR, BMRECN, BMFDOK,
     c+ BMINRF1, BMINRF2, BMINRF3, BMRTSQ, BMVASR, BMRN1, BMRN2, BMRN5,
     c+ BMRN7, BMRN9, BMRN92, BMRN113, BMRN114, BMRA1, BMRA2, BMRA3, BMRA4,
     c+ BMRA5, BMRA7, BMRA10, BMRA13, BMRA15, BMRA18, BMFN1, BMFN2, BMFN5,
     c+ BMFN7, BMFN9, BMFN92, BMFN113, BMFN114, BMFA1, BMFA2, BMFA3, BMFA4,
     c+ BMFA5, BMFA7, BMFA10, BMFA13, BMFA15, BMFA18, BMDTDI, BMTIDI,
     c+ BMDIUSR, BMDIBS, BMDIJBN, BMDIUSRB, BMDIBSB, BMDIJBNB, BMDIPGM,
     c+ BMDIPGMU, BMDTDU, BMTIDU, BMDUUSR, BMDUBS, BMDUJBN, BMDUUSRB,
     c+ BMDUBSB, BMDUJBNB, BMDUPGM, BMDUPGMU, current timestamp tstamp,
     c+ :status
     c+ from domdatv7/PBESTLO
     c/end-exec

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
           'TVRELWAECP/PBESTLO##';
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
       exec sql
         insert into tvrelwaeco/PBESTLO##
         select * from  tvrelwaeco/PBESTLO#
         where tstamp > current timestamp -1 hour;

       eval p_infil   =  'PBESTLOH' +
                        %char(%dec(%char(%date():*iso0):8:0)) +
                        %char(%dec(%char(%time():*iso0):8:0));
       eval p_outfil =  'PBESTLOH##';

       eval p_msgf    =  *blank;
       eval p_print   =  *blank;
       eval p_lib     =  'TVRELWAECO';

       clear     Wrk.var1;
       clear     status;

       MONITOR;
       Wrk.var1 =
           'RMVLNK OBJLNK(''/Controlling/KALKULATION/PBESTLO*'')';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='rmvlnk successful removed PBESTLO#               ';
          exsr      SR_log;
       on-error;
          status='Error by rmvlnk object   PBESTLO#                ';
          exsr      SR_log;
       endmon;

       eval p_outfil =  'PBESTLO##';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Controlling/KALKULATION/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='CVTDBF successful done PBESTLO#                  ';
          exsr      SR_log;
       on-error;
          status='Error by CVTDBF object PBESTLO#                  ';
          exsr      SR_log;
       endmon;

      /End-Free

     C     ##3000        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

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
     C                   movea(p)  'PBESTLO_R '  md(001)
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
