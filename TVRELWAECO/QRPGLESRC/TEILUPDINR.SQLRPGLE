     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * directory/object:
      * G:\Abteilungen\Prozess-Controlling EDC\KHT_PBM
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  option(*SRCSTMT:*NoDebugIO)

     fTEILUPDOUTup   e           k disk    RENAME(TEILUPDOUT:phy01r)
     fteos01    uf a e           k disk
     flbpm01    uf a e           k disk
     fTEIL00    uf   e           k disk

     D*Date             S               D   DATFMT(*EUR)
     DDate             S               D   DATFMT(*iso)
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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying
     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

      *                 ...                                                   
     c                   seton                                        25
     c                   if        status    = *blank  or
     c                             status    =
     c                             'error in command appeared: '+
     c                             'CPYFRMIMPF'
      *                 kl,Einheit                                            
     c                   if        H4        = *blank
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     '
     c                   eval      H4           =  '1'
     c                   exsr      sr9000
     c                   update    phy01r
     c                   endif
     c                   endif
     c                   endif

     C**************************************************************************
     C* SR9000: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9000        BEGSR
     C*
     c     teilkey       klist
     c                   kfld                    firma             2
     c                   kfld                    TETENR
     c                   clear                   firma
     c                   clear                   TETENR
     c                   movel     '01'          firma
     c                   movel     item          tetenr
     C*
     c     teilkey       chain     TEIL1
     C                   movel     §§§usr        teuser
     C                   movel     §§§pgm        tePROG
     C                   movel     §§§job        tejnam
     C                   movel     §§§LIB        tebibl
     c                   movel     date          teJDAT
     c                   movel     zeit          teJZEI
     c                   clear                   teabc1
     c                   movel     'X'           teabc1
     c                   clear                   TETEST
     c                   movel     '90'          TETEST
     c                   IF        %found(TEIL00)
     c                   eval      H4           =  '1'
     c                   eval      h6           =  tstampi
     c                   eval      h5           =  datum
     c                   update    teil1
     c                   else
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     C                   setoff                                       20
     C                   clear                   error             1
     C                   clear                   xpos              3 0

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR

     c                   exsr      sr9999

     c                   clear                   Wrk.var1
     c                   clear                   status          132
      *
      /free
       MONITOR;
       Wrk.var1 =
           'call (TVRELWAECO/#LIBLIST) ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared TVRELWAECO/#LIBLIST     ';
          exsr      SR_log;
       endmon;
      /End-Free

      *
      /free
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/TEILUPDIN) ' +
           'TOFILE(TVRELWAECO/TEILUPDOUT) MBROPT(*ADD) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(2) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;
      /End-Free

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR

     C                   ENDSR

     C**************************************************************************
     C*log report
     C*-------------------------------------------------------------------------
     C*
     C     sr_log        BEGSR

     C                   clear                   md
     C                   movea(p)  'TEILUPDINR'  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  status        md(033)
     C*                  MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md

     C     ##_log        ENDSR
     C**************************************************************************
