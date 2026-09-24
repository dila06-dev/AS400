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
      * UPDPGM PGM(ABESTAND5W) MODULE(ABESTAND5W)
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)

     d ABestand5W      pr                                                       Kommunikation
     d  tetenr                       15a
     d  quantity                     13s04

     d  ABestand5W     pi
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
     c                   z-add     xquantity     quantity
     c*                  z-add     999           quantity
     c                   exsr      sr3000

     C     ##1000        ENDSR

     C**************************************************************************
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR

     c                   CallP     QCmdExc('' :  %size('+
     c                             CALL PGM(DSPJOBLOG OUTPUT(*PRINT)'))
     c                   call      '#DSPJOBLOG'

     C     ##3000        ENDSR


