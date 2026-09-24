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
     h* PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)
     h  option(*SRCSTMT:*NoDebugIO)
     h* dftactgrp(*NO) actgrp(*NEW)

     fhdxforcastif   e           k disk    rename (HDXFORCAST: phy01r)
     f                                     USROPN
     f#TEOSL1   if   e           k disk

     d HDXWEBRW        pr                                                       Kommunikation
     d  iLBLBTENR                    15a
     d  iAEBEJJ                       4s 0
     d  iAEBENR                       6a
     d  istr                        256a
     d* istr                               like(str)
     d                                     dim(999)

     d HDXWEBRW        pi
     d  iLBLBTENR                    15a
     d  iAEBEJJ                       4s 0
     d  iAEBENR                       6a
     d  istr                        256a
     d* istr                               like(str)
     d                                     dim(999)

     d  str            ds                  qualified
     d                                     dim(999)
     d                                     export
     d                                     inz
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

     d  str_new        ds                  qualified
     d                                     dim(999)
     d                                     inz
     d  #quantity                    13s 4
     d  #quantity2                   13s 4

     d  hdx_I        e ds                  extname(HDXFORCAST:*input)
     d                                     qualified

     D*Cmd                         1024A   Options(*Varsize) Const

     D Qcmd            PR                  ExtPgm('QCMDEXC')
     D   Command                  32702A   const options(*varsize)
     D   Length                      15P 5 const

     D Comando         S           1024a

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*-------------------------------------------------------------------------

      /Free
          Exsr sr3000;
          Exsr sr0000;
          Exsr sr2000;
          Exsr sr3000;
          *inlr=*on;
      /End-Free

     C**************************************************************************
     C*ermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr0000        BEGSR

     C*create envirnonment and log
     c                   call      '#LIBLIST'
     C*initialisierung
     c*                  clear                   iLBLBTENR
     c*                  clear                   iAEBEJJ
     c*                  clear                   iAEBENR
     c                   clear                   hdx_I
     c                   clear                   istr
     C*Logfile
     c                   Exsr      sr9000

     c                   eval      Comando = 'CLRPFM ' +
     c                                       'TVRELWAECO/HDXFORCAST'

     c                   callp(e)  Qcmd(%trim(Comando) :
     c                             %len(%trim(Comando)))

     C     ##0000        ENDSR

     C**************************************************************************
     C*Selektives Füllen
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR

     C*create envirnonment and log
     c                   movel     '    '        out               4
     C                   call      'HDXFORCAST'

     C                   open      hdxforcast
     C                   clear                   i                 3 0
     C                   DO        *HIVAL
     C
     C                   READ      hdxforcast    hdx_i                    95
     C                   IF        *in95 = '1' or i =999
     C                   leave
     C                   else
     C                   if        hdx_I.#LBLBLSTC = '825' and
     C                             hdx_I.EPBEST    <>'65'
     C**************     eval      iAEBEJJ  =0       im debugger yes
     C                   select
     C                   when      (hdx_I.#LBLBTENR  = iLBLBTENR   or
     C                               iLBLBTENR  = ' '       )     and
     C                             (hdx_I.#AEBEJJ    = iAEBEJJ     or
     C                               iAEBEJJ    = 0         )     and
     C                             (hdx_I.#AEBENR    = iAEBENR     or
     C                               iAEBENR    = ' '       )
     c
     c                   eval      i = i + 1
     c
     c
     c                   eval      tetenr=hdx_I.#LBLBTENR
     c                   eval      str_new(i).#quantity = 0
     c                   eval      str_new(i).#quantity2= 0
     C                   CALL      'WAO00D'
     C                   PARM                    tetenr           15
     C                   PARM                    xquantity        13 4
     C
     c                   exsr      sr5500
     C
     c                   if        xquantity    = *zero
     c                   exsr      sr5000
     c                   endif
     c                   eval      str_new(i).#quantity=xquantity
     c                   eval      str_new(i).#quantity=xquantity
     c                                        +         link
     c
     c                   if        i=1
     c                   eval      istr(I)    =   ' '
     c                   eval      istr(I)    =   'Lieferant'        +
     c                                            ';'                +
     c                                            'Bestellung'       +
     c                                            ';'                +
     c                                            'BestellNr'        +
     c                                            ';'                +
     c                                            'Menge'            +
     c                                            ';'                +
     c                                            'Artikel'          +
     c                                            ';'                +
     c                                            'BestellPos'       +
     c                                            ';'                +
     c                                            'BestellDat'       +
     c                                            ';'                +
     c                                            'LieferDat'        +
     c                                            ';'                +
     c                                            'BestellStat'      +
     c                                            ';'                +
     c                                            'EintreffDat'      +
     c                                            ';'                +
     c                                            'Container#'       +
     c                                            ';'                +
     c                                            'BuchungCode'      +
     c                                            ';'                +
     c                                            'BuchungsDat'      +
     c                                            ';'                +
     c                                            'BuchungsMenge'    +
     c                                            ';'                +
     c                                            'Einheit'          +
     c                                            ';'                +
     c                                            'WeNummer'         +
     c                                            ';'                +
     c                                            'Timestamp'        +
     c                                            ';'                +
     c                                            'akt.Bestand'      +
     c                                            ';'                +
     c                                            'Sperrbestand'
     c                   eval      i = i + 1
     c                   endif
     c
     c                   clear                   p1               12 0
     c                   clear                   p2               12 0
     c                   eval      p1=(str_new(i).#quantity)
     c                   eval      p2=(str_new(i).#quantity2)
     c                   eval      str(I)     =   hdx_i
     c                   eval      istr(I)    =
     c                                   %subst(%trim(hdx_i.#AELFNR):1:05)
     c                   eval      istr(I)    =
     c                                   %char(hdx_i.#AEBEJJ  )
     c                   eval      istr(I)    =   ' '
     c                   eval      istr(I)    =
     c                             %subst(%trim(hdx_i.#AELFNR):1:05) +
     c                                            ';'                +
     c                                      %char(hdx_i.#AEBEJJ  )   +
     c                                            ';'                +
     c                                        %trim(hdx_i.#AEBENR)   +
     c                                            ';'                +
     c                                      %char(hdx_i.#LBLBBWMG)   +
     c                                            ';'                +
     c                                  %subst(hdx_i.#LBLBTENR:1:15) +
     c                                            ';'                +
     c                                      %char(hdx_i.#AEBEPO  )   +
     c                                            ';'                +
     c                                      %char(hdx_i.EPBEDA   )   +
     c                                            ';'                +
     c                                      %char(hdx_i.EPBETE   )   +
     c                                            ';'                +
     c                                            hdx_i.EPBEST       +
     c                                            ';'                +
     c                                            hdx_i.#WERTA       +
     c                                            ';'                +
     c                                  %subst(hdx_i.#LBLBFBNR:1:06) +
     c                                            ';'                +
     c                                            hdx_i.#LBLBLSTC    +
     c                                            ';'                +
     c                                      %char(hdx_i.#LBLBBDAT )  +
     c                                            ';'                +
     c                                      %char(hdx_i.#LBLBBWM01)  +
     c                                            ';'                +
     c                                            hdx_i.#LBLBBWME    +
     c                                            ';'                +
     c                                            hdx_i.#AEWENR      +
     c                                            ';'                +
     c                                      %char(hdx_i.#LBLBTMST )  +
     c                                            ';'                +
     c                                      %char(str_new(i).#quantity)+
     c                                            ';'                +
     c                                      %char(str_new(i).#quantity2)
     c****************                      %char(p1)                +
     c****************                            ';'                +
     c****************                      %char(p2)
     C                   other
     C                   endsl
     c                   endif
     c                   endif
     C
     C                   enddo
     c                   if        i>0
     c                   eval      istr(I+2)    =   ' '
     c                   eval      istr(I+2)    = 'sentences'        +
     c                                            ';'                +
     c                                      %char(i)
     c                   eval      out  =   %char(i)
     c                   else
     c                   eval      istr(I+1)    =   ' '
     c                   eval      istr(I+1)    = 'sentences'        +
     c                                            ';'                +
     c                                            '0000'
     c                   movel     '0000'        out               4
     c                   endif
     C                   close     hdxforcast
     C                   exsr      sr9005


     C     ##2000        ENDSR

     C**************************************************************************
     C*joblog
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     c                   goto      ##3000
     c                   eval      Comando = 'DSPJOBLOG ' +
     c                                       'OUTPUT(*PRINT)'

     c                   callp(e)  Qcmd(%trim(Comando) :
     c                             %len(%trim(Comando)))

     C     ##3000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR

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
     C   93              eval      str_new(i).#quantity =0

     C  n93              CALL      'WAO00D'
     C                   PARM                    TEOSTENR
     C                   PARM                    xquantity        13 4
     c                   eval      str_new(i).#quantity=xquantity

     C     ##5000        ENDSR

     C**************************************************************************
     C*SKU Übermittlung
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
     C                   eval      str_new(i).#quantity2=link
     c

     C     ##5500        ENDSR

     C**************************************************************************
     C*Protokoll
     C*-------------------------------------------------------------------------
     C*
     C     sr9000        BEGSR

     C*****              goto      ##9000
     C                   clear                   md
     C                   movea(p)  'HDXWEBRW  '  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'input:'      md(040)
     C*                  MOVEA     ATR(14)       md(099)
     C                   move      iAEBEJJ       xiAEBEJJ          4
     C                   movea(p)  xiAEBEJJ      md(100)
     C                   movea(p)  iAEBENR       md(105)
     C                   movea(p)  iLBLBTENR     md(111)
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

     C     ##9000        ENDSR

     C**************************************************************************
     C*Protokoll
     C*-------------------------------------------------------------------------
     C*
     C     sr9005        BEGSR

     C                   clear                   md
     C                   movea(p)  'HDXWEBRW  '  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'output:'     md(040)
     C                   movea(p)  out           md(050)
     C*                  MOVEA     ATR(14)       md(099)
     C                   move      iAEBEJJ       xiAEBEJJ          4
     C                   movea(p)  xiAEBEJJ      md(100)
     C                   movea(p)  iAEBENR       md(105)
     C                   movea(p)  iLBLBTENR     md(111)
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

     C     ##9005        ENDSR


