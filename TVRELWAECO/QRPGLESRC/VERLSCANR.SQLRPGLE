     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63      008864    196527           *
     F*                               582158                     *
     F*      48282 Emsdetten          199086                     *
     F*      Gang 02/2025             196754                     *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*             Schnittstelle                                *
     F*update #VERLSCAN set status =' '  WHERE  status <>' '     *
     F*create index tvrelwaeco/#VERLSCAN1 on                     *
     F*tvrelwaeco/#VERLSCAN (PKVENR, AKBST1)                     *
     F*      where status=' '                                    *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#VERLSCAN up   e             disk    RENAME(#VERLSCAN :PHY01R)
     fVERLSCAN  if a e             disk    RENAME(VERLSCANR :PHY02R)
     f                                     USROPN
     faflp04    if   e           k disk
     fafko01    if   e           k disk
     fafpo01    if   e           k disk
     fifap02    if   e           k disk
     ftrtp01    if   e           k DISK

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     D*-------------------------------------------------------------------------
       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
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
     D p_inFIL         s             22a   inz


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

     Dstatus#          s            132A   inz
     Dstring_file      s             60A   inz
     Dsuffix           s             06A   inz
     Dtransfer         s             30A   inz
     Derr_msg          s              1a   inz
     D§records         s              9s 0 inz

     I/COPY ##E
     I/COPY ##I001
     I*------------------------------------------------------------------------
     IAFKO1
     I              AKFIRM                      #akfirm
     I*------------------------------------------------------------------------

     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------

     c****               exsr      file_out
     c                   if        status = '  '

     C     *DTAARA       DEFINE                  $VERLSCANR       10 0
     C  n25*lock         IN        $VERLSCANR
     C  n25              eval      $VERLSCANR = $VERLSCANR + 1
     C  n25              out       $VERLSCANR
     c  n25              z-add     PKPKNR        #PKPKNR           9 0
     c  n25              movel     AKBST1        #AKBST1          25
     c                   seton                                        25
     C                   setoff                                       47
     C                   if        PKPKNR <> #PKPKNR and
     C                             AKBST1 <> #AKBST1
     C                   exsr      file_out
     c                   close     VERLSCAN

                     MONITOR;
                        *in90 ='0';
                        Wrk.var1 =
                         'CPYF FROMFILE(TVRELWAECO/VERLSCAN) '       +
                         'TOFILE(TVRELWAECO/VERLSCANS) MBROPT(*ADD)';
                        cmd = %TrimR(Wrk.Var1);
                        L      = %Len(Cmd);
                        QCMDEXC(cmd: %len(cmd));
                        on-error;
                           *in90 ='1';
                           status#='Error by CPYF FROMFILE VERLSCAN';
                           exsr      SR_log;
                     endmon;

                     MONITOR;
                        *in90 ='0';
                        Wrk.var1 =
                            'CLRPFM FILE(TVRELWAECO/VERLSCAN)';
                        cmd = %TrimR(Wrk.Var1);
                        L      = %Len(Cmd);
                        QCMDEXC(cmd: %len(cmd));
                        on-error;
                           *in90 ='1';
                           status#='Error by CLRPFM object VERLSCAN';
                           exsr      SR_log;
                     endmon;
     c                   open      VERLSCAN
     C                   z-add     PKPKNR        #PKPKNR
     C                   movel     AKBST1        #AKBST1
     C                   endif
     c                   exsr      sr1000
     C                   if        *in91='0' and
     C                             *in92='0' and
     C                             *in93='0' and
     C                             *in94='0'
     C**********                   *in95='0'
     c                   exsr      sr2000
     C                   endif
     c                   eval      status = '10'
     c   95              eval      status = '95'
     c   94              eval      status = '94'
     c   93              eval      status = '93'
     c   92              eval      status = '92'
     c   91              eval      status = '91'
     c  n97              eval      status = '97'
     c                   eval      #cc = $VERLSCANR
     c                   update    phy01r

     c                   endif

     clr                 close     VERLSCAN
     clr                 exsr      file_out

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
             'CPYF FROMFILE(TVRELWAECO/VERLSCAN) '       +
             'TOFILE(TVRELWAECO/VERLSCANS) MBROPT(*ADD)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status#='Error by CPYF FROMFILE VERLSCAN';
               exsr      SR_log;
         endmon;

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/VERLSCAN)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status#='Error by CLRPFM object VERLSCAN';
               exsr      SR_log;
         endmon;

     clr                 eval      status#='Ende  VERLSCANR  Daten ermitteln'
     clr                 exsr      SR_log

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)  über aflp04  PKANR1  K012018288118
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_aflp    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c                   kfld                    ALKMPO
      /Free
         monitor;
         *in91 ='0';
         if %dec(%subst(PKANR1:03:04):4:0) <> *zero;
         endif;
         on-error *all;
         // nicht numerisch
                  *in91 ='1';
         endmon;
      /End-Free
     c                   if        *in91 = '0'
     C                   eval      ALFIRM  = '01'
     C                   eval      ALKMJJ  = %dec(%subst(PKANR1:04:04):4:0)
     C                   eval      ALKMNR  = %subst(PKANR1:08:06)
     C                   move      PKANRP        ALKMPO
      * :Lieferscheinpositionen -1-
     c     keysr_aflp    chain     AFLP04                             92
     c   92              clear                   AFLP1
     C*
      * :Kopfdaten Auftrag      -2-
     c     keysr_afko    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR

     c                   if        *in92 = '0'
     c     keysr_afko    chain     afko01                             93
     c   92              clear                   afko1
     c   93              clear                   afko1
     c
     C*
      * :lesen bezug Afpo       -3-
     c     keysr_afpo    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_afpo    chain     afpo01                             94
     c   92              clear                   afpo1
     c   93              clear                   afpo1
     c   94              clear                   afpo1
     C*
      * :lesen bezug Interface ifap -4-
     c     keysr_ifap    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_ifap    chain     ifap02                             95
     c   92              clear                   ifap1
     c   93              clear                   ifap1
     c   94              clear                   ifap1
     c   95              clear                   ifap1
     c   95              clear                   IFAPIFPO
     C*
     C                   endif
     C                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
      * :in jedem Fall lt. Trend
     C                   eval      ARRIVALID = %char(PKAPN)
     c                   eval      CUSTOMER  = PKKDNR
     c                   eval      HDXDEL#   = AKBST1
     c  n95              eval      LINENUM   = IFAPIFPO
     c   95              eval      LINENUM   = ALAFPO
     c                   eval      PURCHID   = AKMAAF
     c                   eval      ITEMID    = PKIDEN
     c                   eval      QTY       = PKPMEN
     c                   eval      NVE       = PKVENR
     c                   movel     AKDTL         verldat
     c                   movel     AKTIL         verlzeit
     c
     c                   eval      #AKFAHR   =    AKFAHR
     c                   eval      #AKSPED   =    AKSPED
     c                   eval      #AKVHTY   =    AKVHTY
     c                   eval      #AKVHLN   =    AKVHLN
     c                   eval      #AKHAZG   =    AKHAZG
     c                   eval      #AKPNTH   =    AKPNTH
     c                   eval      #AKHGRT   =    AKHGRT
     c                   eval      #AKHGRW   =    AKHGRW
     c                   eval      #AKHGIW   =    AKHGIW
     c                   eval      #AKHGSS   =    AKHGSS
     c                   eval      #AKHGAF   =    AKHGAF
     c                   eval      #PKVLUS   =    PKVLUS
     C*
     c/exec sql
     c+ select current timestamp into :##tstamp
     c+                          from gang/systempf
     c/end-exec
     C*
     c*                  eval      ##TSTAMP  = #tstamp
     c                   eval      *in97 = '0'
     c                   exsr      sr3000
     C*
      * :Abschlussbuchung erledigt aus dem System für diese
      * :besonderen Kunden, die keine DFÜ können/wollen.
      * :Aktuell wird der Satz nur im Fehlerfall geschrieben,
      * :also kein Eintrag in der Datei ist f.d. Kunden#.
      * :(NURABSCHL = '1' nur den Abschluss machen im HDX, also keine EDI.
      * : NURABSCHL = '0' hier muss beides gemacht werden EDI und Abschluss des Auftrags in HDX)
     c  n97              eval      NURABSCHL = '1'
     c   97              eval      NURABSCHL = '0'
     C*
     c   97              write     phy02r
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C* sr2000: lesen trtp  für nicht relevante Kunden
     C*         Firmennummer:    01
     C*         Sprachcode:      D
     C*         Tabellenart:     VERLSCANR
     C*         Tabellencode:    008864
     C*         Folgenr:
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     c     keysr_trtp    klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     'VERLSCANR '  TPTART
     c                   movel     PKKDNR        TPTCDE
     c
     c     keysr_trtp    chain     trtp01                             97
     c   97              clear                   TPTTXT
     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     c                   eval      status#='Start VERLSCANR  Daten ermitteln'
     c                   exsr      SR_log
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C*    *DTAARA       DEFINE                  unique_ff        10 0
     C*    *lock         IN        unique_ff
     C
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     C
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag

       //DOMDATV7  TSTDATV7   PKVENR
     c/exec sql
     c+ insert into tvrelwaeco/#VERLSCAN
     c+ SELECT AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+        AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,
     c+        AKPLZ,AKLM1,AKKG1,AKLMT1,AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,
     c+        PKANRP,PKANRU,PKKDNR,PKIDEN,PKEAN,
     c+        dec(sum(PKPMEN), 13, 3) PKPMEN,
     c+        dec(sum(PKSMEN), 13, 3) PKSMEN,
     c+        dec(sum(PKEGEW), 13, 3) PKEGEW,
     c+        PKPKNR,PKVENR,
     c+        dec(0, 10) #cc, char('  ', 2) status, current date
     c+        #date, current timestamp #tstamp,
     c+        dec(0, 10) #cc2, char('  ', 2) status2, current date
     c+        #date, current timestamp #tstamp2,
     c+         AKFAHR, AKSPED, AKVHTY, AKVHLN, AKHAZG, AKPNTH, AKHGRT,
     c+         AKHGRW, AKHGIW, AKHGSS, AKHGAF, PKVLUS
     c+ FROM domdatv7/psaveak,DOMDATV7/ppaket
     c+ WHERE akPSTS ='49' and AKSTEU ='OEM' and AKFIRM = pkfirm and
     c+       AKAPN=pkapn and PKANRP <> '0' and
     c+       pkAPN  not in (select pkAPN from
     c+                      tvrelwaeco/#VERLSCAN)
     c+ group by AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+       AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,
     c+       AKPLZ,AKLM1,AKKG1,AKLMT1,AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,
     c+       PKANRP,PKANRU,PKKDNR,PKIDEN,PKEAN,PKPKNR,PKVENR,
     c+         AKFAHR, AKSPED, AKVHTY, AKVHLN, AKHAZG, AKPNTH, AKHGRT,
     c+         AKHGRW, AKHGIW, AKHGSS, AKHGAF, PKVLUS
     c+ order by PKVENR, AKBST1
     c/end-exec

      /FREE

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
             'CPYF FROMFILE(TVRELWAECO/VERLSCAN) '       +
             'TOFILE(TVRELWAECO/VERLSCANS) MBROPT(*ADD)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status#='Error by CPYF FROMFILE VERLSCAN';
               exsr      SR_log;
         endmon;

         MONITOR;
            *in90 ='0';
            Wrk.var1 =
                'CLRPFM FILE(TVRELWAECO/VERLSCAN)';
            cmd = %TrimR(Wrk.Var1);
            L      = %Len(Cmd);
            QCMDEXC(cmd: %len(cmd));
            on-error;
               *in90 ='1';
               status#='Error by CLRPFM object VERLSCAN';
               exsr      SR_log;
         endmon;

     c                   open      VERLSCAN

     C                   ENDSR

       //-----------------------------------------------------------------------
       //output
       //CRTPF FILE(TVRELWAECO/VERLSCANE) RCDLEN(200) TEXT('output VERLSCAN')
       //APPEND /QSYS.LIB/TVRELWAECO.LIB/CONFIRMOUT.FILE/CONFIRMOUT.MBR CONFIRM.TXT
       //
       //-----------------------------------------------------------------------

       begsr file_out;

         §records=*zero;
         exec sql
           select count(*) into :§records
                  from  TVRELWAECO/VERLSCAN;

         if §records <> *zero;

            eval  p_infil  = 'SCAN'                                +
                             '-'                                   +
                              %trimr(#AKBST1)                      +
                             '-'                                   +
                              %char(%dec(%char(%date():*iso0):8:0));

            clear     Wrk.var1;
            clear     status#;

            eval p_outfil  =  'VERLSCAN';

       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/HDXSCAN/snd/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#=p_infil + 'successful' + ' ' + %char(§records);
          exsr      SR_log;
       on-error;
          status#='Error by CVTDBF object ' + p_infil;
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/HDXSCAN/snd/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#='chgaut successful ' + p_infil;
       on-error;
          status#='Error by chgaut object ' + p_infil;
       endmon;

       //  >> 1) PAKE40670  nach  PAKE40670E
       //   MONITOR;
       //   Wrk.var1 =
       //        'QSYS/CPYTOIMPF FROMFILE('+ p_outfil +') '+
       //        'TOFILE(TVRELWAECO/VERLSCANE) '+
       //        'MBROPT(*REPLACE) STRDLM(''"'') '+
       //        'RMVBLANK(*BOTH) FLDDLM('';'') DECPNT(*COMMA) ';
       //      cmd = %TrimR(Wrk.Var1);
       //      L      = %Len(Cmd);
       //      QCMDEXC(cmd: %len(cmd));
       //      on-error;
       //         status='error CPYTOIMPF FROMFILE '  +
       //              p_outfil;
       //      //Aufbereitung für Export  Abbruch
       //         exsr      SR_log;
       //   endmon;

            eval p_outfil  =  'VERLSCAN';
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/HDXSCANProtokoll/'+ p_infil +''  +
                      '.csv'') ' +
           'DBFILE(TVRELWAECO/'+ p_outfil +') DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       // exsr      SR_log;
       on-error;
          status#='Error by CVTDBF object (HDXSCANProtokoll)        ';
          exsr      SR_log;
       endmon;

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/HDXSCANProtokoll/'+ p_infil +''  +
                      '.csv'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*OBJMGT *OBJEXIST *OBJALTER *OBJREF)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#='chgaut successful load(HDXSCANProtokoll)         ';
       on-error;
          status#='Error by chgaut object (HDXSCANProtokoll)        ';
       endmon;

            clear     Wrk.var1;
            clear     status#;
            err_msg = ' ';

         endif;

       endsr;

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

     C     sr_log        BEGSR

      /FREE
         clear p_md;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status#;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status#;

      /End-FREE

     c                   clear                   status#
     C
     C     #sr_log       ENDSR

