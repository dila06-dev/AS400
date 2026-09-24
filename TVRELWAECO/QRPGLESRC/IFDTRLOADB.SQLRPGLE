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

     fsammelpickuf   e             disk
     f                                     RENAME(sammelpick:phy01r)
     f***                                  INFDS(DSF1)
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
     I*/COPY ##I001
     D DSPGM          SDS
     D  §§§PGM                 1     10
     D  §§§STS                11     15  0
     D  §§§SEQ                21     28
     D  §§§SR                 29     36
     D  §§§MSG                40     46
     D  §§§LIB                81     90
     D  §§§MTX                91    170
     D  §§§FIL               201    208
     D  §§§FST               209    243
     D  §§§JOB               244    253
     D  §§§USR               254    263
     D  §§§JNO               264    269  0
     D  §§§SDT               276    281  0
     D  §§§STM               282    287  0
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
      /copy yqrpglesrc,eqsrpgiys
     d p00001        e ds                  extname(frdtn1a)
     d                                     prefix(r)
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

     Iphy01r
     I              status                      #status
     I
     I*-------------------------------------------------------------------------

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*
     C*call
     C
     C                   eval      d3text ='Sammelpick aussteuern' +
     C                                     ' Etikettendruck      '
     C                   CALL      'QM0004C '
     C                   PARM                    d3text           60
     C                   PARM      '003'         ypos              3
     C                   PARM      '03'          xpos              2
     C                   PARM      '0'           ausgabe           1
     C                   PARM      *blank        D3REF1           20
     C                   PARM      *blank        D3VSBD            3
     C                   PARM      *blank        D3KDGR            3
     C                   PARM      *zero         D3KMDA            8 0
     C                   PARM      *zero         D3LFDA            8 0
     C
      *
     c*********          exsr      sr2000
     c                   if        D3REF1 <> ' '      and
     c                             D3VSBD <> ' '      and
     c                             D3KDGR <> ' '      and
     c                             D3KMDA  > 20150000 and
     c                             D3LFDA  > 20150000
     c                   exsr      sr1000
     c                   exsr      sr3000
     c                   exsr      sr4000
     c                   endif

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

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/sammelpick
     c+ SELECT DISTINCT
     c+        AKFIRM concat substr(AKKDNR, 1, 6) concat KLKMNR concat'1',
     c+        ASPLAZ, current timestamp xtime, '0' status
     c+ FROM   afko01, aflk01, afsp01
     c+ WHERE  akfirm='01' and akafat='28' and akKMAT='S' and
     c+        AKREF1 = :d3ref1 and  akkdgr= :d3kdgr  and
     c+        akfirm = klfirm and akAFJJ = klAFJJ and klAFNR = AkAFNR and
     c+        asfirm = akfirm and asAFJJ = klAFJJ and asAFNR = AkAFNR and
     c+        klkmda = :d3kmda and KLLSDA = :D3LFDA  and
     c+        klvsbd = :d3vsbd and askart='AFNR '
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
           'tvrelwaeco/Sammelpick';
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
           'CVTDBF OBJ(''/Lager/SAMMELPICK.CSV'') '  +
           'DBFILE(TVRELWAECO/SAMMELPICK) DBOUTFMT(*CSV) '  +
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
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR

     C                   open      sammelpick

     C                   DO        *HIVAL
     C                   READ      sammelpick                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   if        #status = '0'
     C                   clear                   count             2 0
     c                   dou       count > ASPLAZ
     c                   eval      count = count+1
     c                   if        count > ASPLAZ
     C                   leave
     C                   endif
     C                   clear                   p00001
     C                   eval      rvsrhe   =    SEL0001
     C                   eval      rpkasn   =    ASPLAZ
     C                   eval      ysvm     =    '*'
     C                   if        count    >    1
     C                   eval      ysvm     =    '#'
     C                   endif
     c                   call      'IFDTRLOAD '
     C                   parm                    ys
     C                   parm                    p00001
     c                   enddo
     c                   eval      #status ='1'
     c                   update    phy01r
     C                   endif
     C                   endif
     C                   enddo

     c                   close     sammelpick

     C     ##4000        ENDSR

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
     C                   movea(p)  'IFDTRLOADB'  md(001)
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
