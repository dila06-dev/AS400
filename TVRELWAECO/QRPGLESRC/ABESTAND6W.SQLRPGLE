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
      * UPDPGM PGM(ABESTAND6W) MODULE(ABESTAND6W)
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      * 20250122_01 Änderung der verfügbaren Meng über SR5000
      *             (Lager 100 und 110) deaktiviert, damit nur
      *             noch Standardlager
      *
      * CRTPGM PGM(TVRELWAECO/ABESTAND6W) MODULE(TVRELWAECO/ABESTAND6W)
      * UPDPGM PGM(ABESTAND6W) MODULE(ABESTAND6W)
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)

     f#TEOSL1   if   e           k disk

     d ABestand6W      pr                                                       Kommunikation
     d  tetenr                       15a
     d  quantity                     13s04

     d  ABestand6W     pi
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

     C                   CALL      'WAO00D'
     C                   PARM                    TETENR
     C                   PARM                    xquantity        13 4
     c
     c                   if        xquantity = *zero
     c                   exsr      sr2000
     c                   endif
     c
     c                   z-add     xquantity     quantity
     c*                  z-add     999           quantity
     c***** 20250122_01  exsr      sr5500
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
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR

     c                   CallP     QCmdExc('' :  %size('+
     c                             CALL PGM(DSPJOBLOG OUTPUT(*PRINT)'))
     c                   call      '#DSPJOBLOG'

     C     ##3000        ENDSR

     C**************************************************************************
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr5500        BEGSR

     C*inquiry
     c                   clear                   link             13 2

     c/exec sql
     c+ whenever not found goto ##5500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##5500
     c/end-exec

     c/exec sql
     C+   SELECT DISTINCT
     C+          decimal(sum(LBBSLAGB ), 13, 2) amount
     C+          into    :link
     C+   FROM LBBs a, lbsd b where
     C+   LBBSFIRM=01 and LDFIRM=01 and LBBSFIRM=LDFIRM and
     C+   LBBSlanr=LDlanr and LBBSSPGR not in('--', '--') and
     C+   (lbbslanr ='100' or lbbslanr ='110')
     C******+   and LBBSSPKZ = 'J'
     C+   and   LBBSTENR  =    :TETENR
     C+   GROUP BY LBBSSPGR
     c/end-exec
     C*
     c
     c                   eval      quantity=quantity+link

     C     ##5500        ENDSR


