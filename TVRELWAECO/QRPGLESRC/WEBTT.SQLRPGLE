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
      * CRTPGM PGM(TVRELWAECO/WEBTT) MODULE(TVRELWAECO/WEBTT)
      * UPDPGM PGM(ABESTAND5W) MODULE(ABESTAND5W)
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)

     f#TEOSL1   if   e           k disk

     d WEBTT           pr                                                       Kommunikation
     d  avfirm                      002a
     d  avkmjj                      004a
     d  avkmnr                        6a
     d  link                        256a

     d WEBTT           pi
     d  avfirm                      002a
     d  avkmjj                      004a
     d  avkmnr                        6a
     d  link                        256a

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
     c                   call      '#LIBLIST'
     c*                  call      '#DSPJOBLOG'


     c*                  exsr      sr2000
     c
     c                   exsr      sr3000

     C     ##1000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR

     C*inquiry
     c                   eval      link   = *blank

     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##2000
     c/end-exec

     c/exec sql
     C+   SELECT char(TRIM(TRURURLP) concat trim(AVPAKN), 254)
     C+          into    :link
     C+   from   TRUR01,afvs01
     C+   where  avfirm = :avfirm and TRURFIRM = :avfirm and
     C+          avkmjj = :avkmjj and avkmnr   = :avkmnr and
     C+          TRURKEY2=AVKDLI and
     C+          TRURKEY1 ='LFNR' and TRURLFZN ='0'
     c/end-exec
     C*
     c

     C     ##2000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR

     C*create envirnonment and log

     C*                 sku Konformität
     c     key001        klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSMM01

     c                   eval      TEOSFIRM = '01'
     c                   eval      TEOSKLCD = 'SKU '
     c                   eval      TEOSMM01 = 'TETENR'

     c     key001        chain     #TEOSL1                            93
     C   93              clear                   quantity         14 6

     C  n93              CALL      'WAO00D'
     C                   PARM                    TEOSTENR
     C                   PARM                    xquantity        13 4
     c                   z-add     xquantity     quantity
     c*                  z-add     999           quantity
     c                   exsr      sr3000

     C     ##2500        ENDSR

     C**************************************************************************
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR

     c                   eval      Comando = 'DSPJOBLOG ' +
     c                                       '              '

     c                   callp(e)  Qcmd(%trim(Comando) :
     c                             %len(%trim(Comando)))

     c*                  call      '#DSPJOBLOG'

     C     ##3000        ENDSR


