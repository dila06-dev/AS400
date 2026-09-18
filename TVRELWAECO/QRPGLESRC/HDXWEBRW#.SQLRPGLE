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
      * 1. ) Funktion 15
      * CRTPGM PGM(TVRELWAECO/HDXWEBRW) MODULE(TVRELWAECO/HDXWEBRW)
      * UPDPGM PGM(HDXWEBRW) MODULE(HDXWEBRW)
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *                                mit 14      dftactgrp(*no)
      *HDXWEBRW        pr                  ExtPgm('HDXWEBRWI')                  Kommunikation
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)
     h  option(*SRCSTMT:*NoDebugIO)

     fhdxforcastif   e           k disk    rename (HDXFORCAST: phy01r)

     d HDXWEBRW        pr                                                       Kommunikation
     d  #AELFNR                      10a
     d  #AEBEJJ                       4s 0
     d  #AEBENR                       6a
     d  #LBLBBWMG                    13s 4
     d  #LBLBTENR                    15a
     d  #AEBEPO                       4s 0
     d  EPBEDA                        8s 0
     d  EPBETE                        8s 0
     d  EPBEST                        2a
     d  #WERTA                       10a
     d  #LBLBFBNR                    20a
     d  #LBLBLSTC                     3a
     d  #LBLBBDAT                     8s 0
     d  #LBLBBWM01                   13s 4
     d  #LBLBBWME                     1a
     d  #AEWENR                       6a
     d  #LBLBTMST                    26s 0
     d* link                        256a

     d HDXWEBRW        pi
     d  #AELFNR                      10a
     d  #AEBEJJ                       4s 0
     d  #AEBENR                       6a
     d  #LBLBBWMG                    13s 4
     d  #LBLBTENR                    15a
     d  #AEBEPO                       4s 0
     d  EPBEDA                        8s 0
     d  EPBETE                        8s 0
     d  EPBEST                        2a
     d  #WERTA                       10a
     d  #LBLBFBNR                    20a
     d  #LBLBLSTC                     3a
     d  #LBLBBDAT                     8s 0
     d  #LBLBBWM01                   13s 4
     d  #LBLBBWME                     1a
     d  #AEWENR                       6a
     d  #LBLBTMST                    26s 0
     d* link                        256a

     d  str            ds                  qualified
     d                                     dim(999)
     d                                     export
     d  #AELFNR                      10a
     d  #AEBEJJ                       4s 0
     d  #AEBENR                       6a
     d  #LBLBBWMG                    13s 4
     d  #LBLBTENR                    15a
     d  #AEBEPO                       4s 0
     d  EPBEDA                        8s 0
     d  EPBETE                        8s 0
     d  EPBEST                        2a
     d  #WERTA                       10a
     d  #LBLBFBNR                    20a
     d  #LBLBLSTC                     3a
     d  #LBLBBDAT                     8s 0
     d  #LBLBBWM01                   13s 4
     d  #LBLBBWME                     1a
     d  #AEWENR                       6a
     d  #LBLBTMST                    26s 0
     d* link                        256a

     d  hdx_I        e ds                  extname(HDXFORCAST:*input)
     d                                     qualified

     D*Cmd                         1024A   Options(*Varsize) Const

     D Qcmd            PR                  ExtPgm('QCMDEXC')
     D   Command                  32702A   const options(*varsize)
     D   Length                      15P 5 const

     D Comando         S           1024a

      /Free
          Exsr sr3000;
          Exsr sr0000;
          Exsr sr1000;
          Exsr sr2000;
          Exsr sr3000;
          *inlr=*on;
      /End-Free

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr0000        BEGSR

     C*initialisierung
     c                   clear                   hdx_I
     c                   clear                   #AELFNR
     c                   clear                   #AEBEJJ
     c                   clear                   #AEBENR
     c                   clear                   #LBLBBWMG
     c                   clear                   #LBLBTENR
     c                   clear                   #AEBEPO
     c                   clear                   EPBEDA
     c                   clear                   EPBETE
     c                   clear                   EPBEST
     c                   clear                   #WERTA
     c                   clear                   #LBLBFBNR
     c                   clear                   #LBLBLSTC
     c                   clear                   #LBLBBDAT
     c                   clear                   #LBLBBWM01
     c                   clear                   #LBLBBWME
     c                   clear                   #AEWENR
     c                   clear                   #LBLBTMST

     C     ##0000        ENDSR

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     C*create envirnonment and log
     c                   call      '#LIBLIST'
     c                   call      '#DSPJOBLOG'
     c
     c                   movel     #LBLBTENR     ##LBLBTENR       15

     C     ##1000        ENDSR

     C**************************************************************************
     C*Selektives Füllen
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR

     C*create envirnonment and log
     C                   call      'HDXFORCAST'

     C                   clear                   i                 3 0
     C                   DO        *HIVAL
     C
     C                   READ      hdxforcast                             95
     C                   IF        *in95 = '1' or i =999
     C                   leave
     C                   else
     C                   select
     C                   when      #LBLBTENR  = ##LBLBTENR
     c                   eval      i = i + 1
     c                   eval      str(I)     =   hdx_i
     C                   other
     C                   endsl
     c                   endif
     C
     C                   enddo


     C     ##2000        ENDSR

     C**************************************************************************
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR

     c                   eval      Comando = 'DSPJOBLOG ' +
     c                                       'OUTPUT(*PRINT)'

     c                   callp(e)  Qcmd(%trim(Comando) :
     c                             %len(%trim(Comando)))

     c*                  call      '#DSPJOBLOG'

     C     ##3000        ENDSR


