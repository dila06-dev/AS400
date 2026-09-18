     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      * UPDPGM PGM(ABESTANB2C) MODULE(ABESTANB2C)
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)

     f#TEOSL1   if   e           k disk

     d ABESTANB2C      pr                                                       Kommunikation
     d  tetenr                       15a
     d  quantity                     13s04

     d  ABESTANB2C     pi
     d  tetenr                       15a
     d  quantity                     13s04

     D*Cmd                         1024A   Options(*Varsize) Const

     DqCmdExc          PR                  ExtPgm('QCMDEXC')
     D Cmd                         1024A   Options(*Varsize) Const
     D CmdLen                        15P 5 Const

      /Free
          Exsr sr1000;
          *inlr=*on;
      /End-Free

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     C*create envirnonment and log
     c                   call      '#LIBLIST'
     c                   call      '#DSPJOBLOG'

     c                   eval      quantity = 0
     c                   exsr      sr2500

     c                   exsr      sr3000

     C     ##1000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR

     C*create envirnonment and log

     C*                 sku Konformität
     c     key001        klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSMM01

     c                   eval      TEOSFIRM = '01'
     c                   eval      TEOSKLCD = 'SKU '
     c                   eval      TEOSMM01 = TETENR

     c     key001        chain     #TEOSL1                            93
     C   93              clear                   quantity

     C  n93              CALL      'WAO00D'
     C                   PARM                    TEOSTENR
     C                   PARM                    xquantity        13 4
     c                   z-add     xquantity     quantity
     c*                  z-add     999           quantity
     c                   exsr      sr3000

     C     ##2000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR

     C*create envirnonment and log

     C*Grundaufbau
     c/exec sql
     c*+ insert into TVRELWAECO/HELL_LFSP
     c+ SELECT TB2CTENR,
     c+        dec( sum(lbrsrsmg), 13, 4) into :tetenr, :quantity
     c+ FROM  tb2c left join lbrs01 on
     c+       (TB2CFIRM=lbrsfirm and TB2CTENR=lbrstenr and
     c+       TB2CLANR=lbrslanr and lbrsdana='TB2C'   and
     c+       LBRSSTAT<'90'     and TB2CFIRM='01'     and
     c+       TB2CLANR ='001' )
     c+ WHERE TB2CFIRM='01' and TB2CLANR ='001'       and
     c+       TB2CTENR = :tetenr
     c+ GROUP BY TB2CTENR, TB2CMIBS
     c/end-exec

       //sql handling
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c                   exsr      sr3000

     C     ##2500        ENDSR

     C**************************************************************************
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR

     c                   CallP     QCmdExc('' :  %size('+
     c                             CALL PGM(DSPJOBLOG OUTPUT(*PRINT)'))
     c                   call      '#DSPJOBLOG'

     C     ##3000        ENDSR


