     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      * CRTSQLRPGI
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * CRTPGM PGM(TVRELWAECO/HDXWEBRW) MODULE(TVRELWAECO/HDXWEBRW)
      * UPDPGM PGM(HDXWEBRW) MODULE(HDXWEBRW)
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *                                mit 14      dftactgrp(*no)
      *****************************************************************

     d  str            ds                  qualified
     d                                     dim(999)
     d                                     inz
     d  #AELFNR                      10a   INZ('          ')
     d  #AEBEJJ                       4s 0 INZ(0000)
     d  #AEBENR                       6a   INZ('      ')
     d  #LBLBBWMG                    13s 4 INZ(0)
     d  #LBLBTENR                    15a   INZ('             ')
     d  #AEBEPO                       4s 0 INZ(0)
     d  EPBEDA                        8s 0 INZ(0)
     d  EPBETE                        8s 0 INZ(0)
     d  EPBEST                        2a   INZ('  ')
     d  #WERTA                       10a   INZ('          ')
     d  #LBLBFBNR                    20a   INZ('                    ')
     d  #LBLBLSTC                     3a   INZ('   ')
     d  #LBLBBDAT                     8s 0 INZ(0)
     d  #LBLBBWM01                   13s 4 INZ(0)
     d  #LBLBBWME                     1a   INZ(' ')
     d  #AEWENR                       6a   INZ('      ')
     d  #LBLBTMST                    26s 0 INZ(0)


     D*Cmd                         1024A   Options(*Varsize) Const

     D Qcmd            PR                  ExtPgm('QCMDEXC')
     D   Command                  32702A   const options(*varsize)
     D   Length                      15P 5 const

     D Comando         S           1024a

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
     c                   eval      xlblbtenr='81.63910-6015'
     c                   call      'HDXWEBRW'
     c                   parm                    xLBLBTENR        15
     c                   parm      2015          xAEBEJJ           4 0
     c                   parm                    xAEBENR           6
     c                   parm                    str
     c     ##1000        ENDSR
