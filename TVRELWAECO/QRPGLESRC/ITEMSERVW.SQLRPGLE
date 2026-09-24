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
      * CRTPGM PGM(TVRELWAECO/ITEMSERVW) MODULE(TVRELWAECO/ITEMSERVW)
      * UPDPGM PGM(ITEMSERVW) MODULE(ITEMSERVW)
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *                                mit 14      dftactgrp(*no)
      *ITEMSERVW       pr                  ExtPgm('HDXWEBRWI')                  Kommunikation
      *****************************************************************
     h  PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)
     h  option(*SRCSTMT:*NoDebugIO)
     h* dftactgrp(*NO) actgrp(*NEW)

     fitemserv  if   e           k disk    rename (itemserv:phy01r)
     f                                     USROPN
     f#TEOSL1   if   e           k disk

     d ITEMSERVW       pr                                                       Kommunikation
     d  iLBLBTENR                    15a
     d  istr                       1024a
     d* istr                               like(str)
     d                                     dim(15000)

     d ITEMSERVW       pi
     d  iLBLBTENR                    15a
     d  istr                       1024a
     d* istr                               like(str)
     d                                     dim(15000)

     d  str            ds                  qualified
     d                                     dim(15000)
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
     d                                     dim(15000)
     d                                     inz
     d  #quantity                    13s 4
     d  #quantity2                   13s 4

     d  inp_i        e ds                  extname(itemserv:*input)
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
     c                   clear                   inp_I
     c                   clear                   istr
     C*Logfile
     c                   Exsr      sr9000

     c                   eval      Comando = 'CLRPFM ' +
     c                                       'TVRELWAECO/__________'

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
     C*********          call      '__________'

     C                   open      itemserv
     C                   clear                   i                 5 0
     C                   DO        *HIVAL
     C
     C                   READ      itemserv      inp_i                    95
     C                   IF        *in95 = '1' or i =20000
     C                   leave
     C                   else
     C                   if        inp_I.item     <> 'xxxxxxxx'
     C                   select
     C                   when      (inp_I.item       = iLBLBTENR or
     c                              iLBLBTENR        = '               ')
     c                   eval      i = i + 1
     c
     c
     c                   eval      tetenr=inp_I.item
     c                   eval      str_new(i).#quantity = 0
     c                   eval      str_new(i).#quantity2= 0
     C                   CALL      'WAO00D'
     C                   PARM                    tetenr           15
     C                   PARM                    xquantity        13 4
     c                   if        xquantity    = *zero
     c                   exsr      sr5000
     c                   endif
     c                   eval      str_new(i).#quantity=xquantity
     c
     c
     c                   if        i=1
     c                   eval      istr(I)    =   ' '
     c                   eval      istr(I)    =   'Item '            +
     c                                            ';'                +
     c                                            'Description'      +
     c                                            ';'                +
     c                                            'DutyNumber'       +
     c                                            ';'                +
     c                                            'EAN-Code'         +
     c                                            ';'                +
     c                                            'Status'           +
     c                                            ';'                +
     c                                            'Length'           +
     c                                            ';'                +
     c                                            'Width'            +
     c                                            ';'                +
     c                                            'Height'           +
     c                                            ';'                +
     c                                            'Weight'           +
     c                                            ';'                +
     c                                            'ICS_Price'        +
     c                                            ';'                +
     c                                            'Replacement'      +
     c                                            ';'                +
     c                                            'SC_Item'          +
     c                                            ';'                +
     c                                            'Quantity'         +
     c                                            ';'                +
     c                                            'Turnover'         +
     c                                            ';'                +
     c                                            'STK_LCP'          +
     c                                            ';'                +
     c                                            'ICS_'             +
     c                                            ';'                +
     c                                            'ICS_from'         +
     c                                            ';'                +
     c                                            'ICS_until'        +
     c                                            ';'                +
     c                                            'ICS_current'      +
     c                                            ';'                +
     c                                            'ICS_currentfrom'  +
     c                                            ';'                +
     c                                            'ICS_currentuntil' +
     c                                            ';'                +
     c                                            'SUREQTY'          +
     c                                            ';'                +
     c                                            'SKU'              +
     c                                            ';'                +
     c                                            'ABC'              +
     c                                            ';'                +
     c                                            'MATGROUP'         +
     c                                            ';'                +
     c                                            'PRODGROUP'        +
     c                                            ';'                +
     c                                            'DOMGROUP'         +
     c                                            ';'                +
     c                                            'UPDATE_ID'        +
     c                                            ';'                +
     c                                            'ENDUSERPNJ'       +
     c                                            ';'                +
     c                                            'MCOB_SKU'         +
     c                                            ';'                +
     c                                            'MDP_SKU'          +
     c                                            ';'                +
     c                                            'MF_SKU'           +
     c                                            ';'                +
     c                                            'OTRA_SKU'         +
     c                                            ';'                +
     c                                            'CURRENCY'         +
     c                                            ';'                +
     c                                            'PRICEGROUP'       +
     c                                            ';'                +
     c                                            'BIRTHDATE'        +
     c                                            ';'                +
     c                                            'TSTAMP'           +
     c                                            ';'                +
     c                                            'akt.Bestand'      +
     c                                            ';'                +
     c                                            'Sperrbestand'
     c                   endif
     c
     c
     c                   eval      str(I)     =   inp_i
     c                   eval      istr(I+1)  =   ' '
     c                   eval      istr(I+1)  =   inp_i.ITEM         +
     c                                            ';'                +
     c                                            inp_i.DESC         +
     c                                            ';'                +
     c                                            inp_i.DUTY#        +
     c                                            ';'                +
     c                                            inp_i.EAN          +
     c                                            ';'                +
     c                                            inp_i.STATUS       +
     c                                            ';'                +
     c                                      %char(inp_i.LENGTH   )   +
     c                                            ';'                +
     c                                      %char(inp_i.WIDTH    )   +
     c                                            ';'                +
     c                                      %char(inp_i.HEIGHT   )   +
     c                                            ';'                +
     c                                      %char(inp_i.WEIGHT   )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_PRICE)   +
     c                                            ';'                +
     c                                            inp_i.REPLACEM     +
     c                                            ';'                +
     c                                            inp_i.SC_ITEM      +
     c                                            ';'                +
     c                                      %char(inp_i.QUANTITY )   +
     c                                            ';'                +
     c                                      %char(inp_i.TURNOVER )   +
     c                                            ';'                +
     c                                      %char(inp_i.STK_LCP  )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_     )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_VON  )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_BIS  )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_2    )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_VON2 )   +
     c                                            ';'                +
     c                                      %char(inp_i.ICS_BIS2 )   +
     c                                            ';'                +
     c                                      %char(inp_i.SUREQTY  )   +
     c                                            ';'                +
     c                                            inp_i.SKU          +
     c                                            ';'                +
     c                                            inp_i.abc          +
     c                                            ';'                +
     c                                            inp_i.MATGROUP     +
     c                                            ';'                +
     c                                            inp_i.PRODGROUP    +
     c                                            ';'                +
     c                                            inp_i.DOMGROUP     +
     c                                            ';'                +
     c                                            inp_i.UPDATE_ID    +
     c                                            ';'                +
     c                                      %char(inp_i.ENDUSERPNJ)  +
     c                                            ';'                +
     c                                            inp_i.MCOB_SKU     +
     c                                            ';'                +
     c                                            inp_i.MDP_SKU      +
     c                                            ';'                +
     c                                            inp_i.MF_SKU       +
     c                                            ';'                +
     c                                            inp_i.OTRA_SKU     +
     c                                            ';'                +
     c                                            inp_i.CURRENCY     +
     c                                            ';'                +
     c                                            inp_i.PRICEGROUP   +
     c                                            ';'                +
     c                                      %char(inp_i.BIRTHDATE)   +
     c                                            ';'                +
     c                                      %char(inp_i.TSTAMP)      +
     c                                            ';'                +
     c                                      %char(str_new(i).#quantity)+
     c                                            ';'                +
     c                                      %char(str_new(i).#quantity2)
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
     C                   close     itemserv
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
     C*Protokoll
     C*-------------------------------------------------------------------------
     C*
     C     sr9000        BEGSR

     C                   clear                   md
     C                   movea(p)  'ITEMSERVW '  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'input:'      md(040)
     C*                  MOVEA     ATR(14)       md(099)
     C****protokoll      move      iAEBEJJ       xiAEBEJJ          4
     C****protokoll      movea(p)  xiAEBEJJ      md(100)
     C****protokoll      movea(p)  iAEBENR       md(105)
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
     C                   movea(p)  'ITEMSERVW '  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'output:'     md(040)
     C                   movea(p)  out           md(050)
     C*                  MOVEA     ATR(14)       md(099)
     C****protokoll      move      iAEBEJJ       xiAEBEJJ          4
     C****protokoll      movea(p)  xiAEBEJJ      md(100)
     C****protokoll      movea(p)  iAEBENR       md(105)
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


