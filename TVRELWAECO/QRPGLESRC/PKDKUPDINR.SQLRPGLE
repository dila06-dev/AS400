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
      * G:\Abteilungen\Prozess-Controlling EDC\PREISUPDIN
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  option(*SRCSTMT:*NoDebugIO)

     fPKKKUPDOUTup   e           k disk    RENAME(PKKKUPDOUT:phy01r)
     f#preil2   uf a e           k disk    RENAME(prei1:phy02r)
     fTEIL00    if   e           k disk

     D*Date             S               D   DATFMT(*EUR)
     DDate_in_V        S               D   DATFMT(*iso)
     DDate_in_B        S               D   DATFMT(*iso)
     DDate             S               D   DATFMT(*iso)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     DGoodDateV        S              1a
     DGoodDateB        S              1a
     D#TIMESTAMP       S               z
     D §records        s              9s 0 inz

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
     c                   if        (H4        = *blank and KIND ='PKD' and
     c                                          CURRENTCY <> *blank    )
     c                   if        COMPANY   = '01' or
     c                             COMPANY   = '61' or
     c                             COMPANY   = '08' or
     c                             COMPANY   = '55' or
     c                             COMPANY   = '52'
     c                   if        item    <>'xxxxxx         ' and
     c                             item    <>'xxxxxxxxxx     ' and
     c                             item    <>*blank
     c                   eval      #ERRORS = *blank
     c                   exsr      sr9000
     c                   update    phy01r
     c                   endif
     c                   endif
     c                   endif
     c                   endif
     clr                 exsr      SR9888
     C*

     C**************************************************************************
     C* SR9000: lesen Parameterdaten aus Workfile
     C*-------------------------------------------------------------------------
     C*
     C     SR9000        BEGSR
     C*
     C*                 key lieferant=Kunde
     c     preikey       klist
     c                   kfld                    COMPANY
     c                   kfld                    KIND
     c                   kfld                    LIEFERANT
     c                   kfld                    ITEM
     c                   kfld                    CURRENTCY
     c                   kfld                    FROMdat
     C*                 update prei
     C*
     c     preikey       chain     #preil2
     c                   IF        %found(#preil2)
     c                   eval      #PVKNETTO    =  prezpr
     c                   eval      #FROMdat     =  prgada
     c                   eval      #kind        =  PRBEGR
     c                   eval      #lieferant   =  PRKDLI
     c                   eval      #UNTILdat    =  PRGBDA
     c                   eval      #CURRENTCY   =  PRWACD
     c                   exsr      sr9500
     c                   update    phy02r
     c                   else
     c                   exsr      sr9500
     c                   if        #ERRORS = *blank
     c                   write     phy02r
     c                   exsr      sr9250
     c                   endif
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C**************************************************************************
     C* SR9250:
     C*-------------------------------------------------------------------------
     C*
     C     SR9250        BEGSR
     C*
      * : -------------------------------
     C     preikey       SETLL     #preil2                            95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READp     #preil2                                95
     C                   IF        *in95     =   '1'         or
     C                             PRGBDA    >    0          or
     C                             COMPANY   <>   PRFIRM     or
     C                             KIND      <>   PRBEGR     or
     C                             ITEM      <>   PRTENR     or
     C                             CURRENTCY <>   PRWACD     or
     C                             LIEFERANT <>   PRKDLI
     C                   leave
     C                   else
     c                   eval      Date_in_V  = Date_in_V  - %days(1)
     c                   eval      PRGBDA  =  %dec(%char((Date_in_V):*iso0):8:0)
     c                   eval      H1           =  '1'
     c                   update    phy02r
     C                   leave
     c                   endif
     c                   enddo
     c                   endif
     C*
     C     ##9250        ENDSR
     C*
     C**************************************************************************
     C* SR9500: Übergaben
     C*-------------------------------------------------------------------------
     C*
     C     SR9500        BEGSR
     C*
     C     teilkey       klist
     C                   kfld                    COMPANY
     C                   kfld                    item
     c                   eval      #TEILCHECK  = ' '
     c     teilkey       chain     TEIL1
     c                   IF        %found(TEIL00)
     c                   eval      #TEILCHECK  = 'J'
     c                   endif
      *      Non_Num_Posn = %check(Numbers:My_Field);
      *      If Non_Num_Posn > 0;
      *        Error = *On;
      *      EndIf;
     C*
     c
      /free
          eval  #ERRORS  = *blank;
          GoodDateV='1';
          monitor;
             Date_in_V=%date(%char(FROMdat):*iso0);
             On-error *all;
               GoodDateV='0';
               eval #ERRORS ='Von Datum kein reguläres Datum ' +
                                    %char(fromdat)           ;
          endmon;

             GoodDateB='1';
             if UNTILdat <> 0;
             monitor;
                Date_in_B=%date(%char(UNTILdat):*iso0);
                On-error *all;
                  GoodDateB='0';
                  eval #ERRORS ='Bis Datum kein reguläres Datum ' +
                                       %char(untildat)          ;
             endmon;
             endif;

       //    if Date_in_V < %date() + %days(1) and GoodDateV='1';
             if Date_in_V < %date() - %days(2) and GoodDateV='1';
                eval #ERRORS ='Von Datum zu klein ' +
                                          %char(fromdat);
             endif;

             if Date_in_B <  Date_in_V + %days(1) and UNTILdat <> 0
                                               and GoodDateB='1';
                eval #ERRORS ='Bis Datum zu klein '    +
                                       %char(untildat)          ;
             endif;

      /end-free


     C                   if        PVKNETTO    = *Zero
     C                             or PVKNETTO < *Zero
     c                   eval      #ERRORS = *blank
     c                   eval      #ERRORS ='Preis negativ oder Null'
     C                   endif
     C                   eval      PRFIRM   =    COMPANY
     c                   eval      PRBEGR   =    KIND
     c                   eval      PRTENR   =    ITEM
     c                   eval      PRWACD   =    CURRENTCY
     C                   z-add     PVKNETTO      prezpr
     C                   z-add     FROMdat       PRGADA
     C                   z-add     UNTILdat      PRGBDA
     C                   movel     kind          PRBEGR
     C                   movel     lieferant     PRKDLI
     C                   Movel     '1'           prpdvk
     C                   Movel     'S'           prmepr
     C                   movel     tstampi       PRTSTP
     C                   movel     §§§usr        pruser
     C                   movel     §§§pgm        prPROG
     C                   movel     §§§job        prjnam
     C                   movel     §§§LIB        prbibl
     c                   eval      PRJDAT     =  %dec(%char(%date():*iso0):8:0)
     c                   eval      PRJzei     =  %dec(%char(%time():*iso0):6:0)
     c                   if        #ERRORS = *blank
     c                   eval      H4           =  '1'
     c                   else
     c                   eval      H4           =  'E'
     c                   endif
     c                   eval      h5           =  datum
     c                   eval      h6           =  tstampi
     C*
     C     ##9500        ENDSR
     C*
     C**************************************************************************
     C* SR9888:
     C*-------------------------------------------------------------------------
     C*
     C     SR9888        BEGSR
     C*
      /Free
       if §records > 0;
           MONITOR;
           Wrk.var1 =
               'CD DIR(''/lager/SCM'') ';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
              status='CD DIR successful FILE(TVRELWAECO/PKDKUPDINR)    ';
           on-error;
              status='Error by CD DIR object (TVRELWAECO/PKDKUPDINR)   ';
           endmon;

           MONITOR;
           Wrk.var1 =
               'RMVLNK OBJLNK(''/LAGER/SCM/' +
               'PKDs done*'')';
             cmd = %TrimR(Wrk.Var1);
             l      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
              status='rmvlnk successful removed file done history      ';
              exsr      SR_log;
           on-error;
              status='Error by rmvlnk object file done history         ';
              exsr      SR_log;
           endmon;

           MONITOR;
           Wrk.var1 =
               'RNM OBJ(''PKDs.csv'') '+
               'NEWOBJ(''PKDs done.csv'')';
             cmd = %TrimR(Wrk.Var1);
             L      = %Len(Cmd);
             QCMDEXC(cmd: %len(cmd));
              status='rnm    successful FILE(TVRELWAECO/PKDKUPDINR)    ';
           on-error;
              status='Error by clrpfm object (TVRELWAECO/PKDKUPDINR)   ';
           endmon;
       endif;
      /End-Free
     C*
     C     ##9888        ENDSR
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

      // IMPORT2400 Hilfsfile
       MONITOR;
          Wrk.var1 =
              'CLRPFM FILE(TVRELWAECO/PKKKUPDIN)';
          cmd = %TrimR(Wrk.Var1);
          L      = %Len(Cmd);
          QCMDEXC(cmd: %len(cmd));
          on-error;
             status='error CLRPFM FILE(TVRELWAECO/PKKKUPDIN)          ';
             exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CPYFRMSTMF FROMSTMF'+
           '(''/LAGER/SCM/PKDs.csv'') '+
           'TOMBR'+
           '(''/QSYS.LIB/TVRELWAECO.LIB/PKKKUPDIN.FILE/PKKKUPDIN.MBR'') '+
           'MBROPT(*REPLACE) ';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status='erledigt                   CPYFRMSTMF PKKKUPDIN   ';
          exsr      SR_log;
       on-error;
          status='error in command appeared: CPYFRMSTMF PKKKUPDIN   ';
          exsr      SR_log;
       endmon;

       exec sql
         select count(*) into :§records
         from tvrelwaeco/PKKKUPDIN;

          status='Sätze: '  +
                     %char(§records);
          exsr      SR_log;

       if §records > 0;
      /free
       MONITOR;
       Wrk.var1 =
           'CPYFRMIMPF FROMFILE(TVRELWAECO/PKKKUPDIN) ' +
           'TOFILE(TVRELWAECO/PKKKUPDOUT) MBROPT(*ADD) '  +
           'FLDDLM('';'') DECPNT(*COMMA) ' +
           'FROMRCD(1) RPLNULLVAL(*FLDDFT)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared: CPYFRMIMPF             ';
          exsr      SR_log;
       endmon;
      /End-Free

       endif;

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/PKKKUPDIN';
         cmd = %TrimR(Wrk.Var1);

         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
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
     C                   movea(p)  'PKDKUPDINR'  md(001)
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
