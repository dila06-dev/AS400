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

     D*Cmd                         1024A   Options(*Varsize) Const

     D Qcmd            PR                  ExtPgm('QCMDEXC')
     D   Command                  32702A   const options(*varsize)
     D   Length                      15P 5 const

     D Comando         S           1024a

      /Free
          Exsr sr1000;
          *inlr=*on;
      /End-Free

     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    #AELFNR          10
     C                   PARM                    #AEBEJJ           4 0
     C                   PARM                    #AEBENR           6
     C                   PARM                    #LBLBBWMG        13 4
     C                   PARM                    #LBLBTENR        15
     C                   PARM                    #AEBEPO           4 0
     C                   PARM                    EPBEDA            8 0
     C                   PARM                    EPBETE            8 0
     C                   PARM                    EPBEST            2
     C                   PARM                    #WERTA           10
     C                   PARM                    #LBLBFBNR        20
     C                   PARM                    #LBLBLSTC         3
     C                   PARM                    #LBLBBDAT         8 0
     C                   PARM                    #LBLBBWM01       13 4
     C                   PARM                    #LBLBBWME         1
     C                   PARM                    #AEWENR           2
     C                   PARM                    #LBLBTMST        26 0
     I*-------------------------------------------------------------------------

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C                   eval          #AELFNR     = '1234567890'
     C                   eval          #AEBEJJ     = 0000
     C                   eval          #AEBENR     = '000000'
     C                   eval          #LBLBBWMG   = 0
     C                   eval          #LBLBTENR   = '81.63910-6015'
     C                   eval          #AEBEPO     = 0
     C                   eval          EPBEDA      = 0
     C                   eval          EPBETE      = 0
     C                   eval          EPBEST      = '  '
     C                   eval          #WERTA      = '          '
     C                   eval          #LBLBFBNR   = '                    '
     C                   eval          #LBLBLSTC   = '   '
     C                   eval          #LBLBBDAT   = 0
     C                   eval          #LBLBBWM01  = 0
     C                   eval          #LBLBBWME   = ' '
     C                   eval          #AEWENR     = '      '
     c                   eval          #LBLBTMST   = 0
     c     ##1000        ENDSR
