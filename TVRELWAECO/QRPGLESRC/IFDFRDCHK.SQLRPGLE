      /TITLE Frachtdatensatz nach Erstellung prüfen
      * Copyright
      /copy rpg_cpr
      /copy yqrpglesrc,eqsrpgiys
      /copy yqrpglesrc,eqsrpgixs
      /copy yqrpglesrc,eqsrpgixc
      /copy yqrpglesrc,eqsrpgixy
     d  §§§JOB               244    253
     d  §§§USR               254    263
     d  §§§JNO               264    269  0
      /space 2
     d p00001        e ds                  extname(frdtn1a)
     d                                     prefix(r)
     d p00003        e ds                  extname(vsd19f)
     d                                     prefix(a)
     d wxstxt          s                   like(xstxt)
     d ww1nb           s              1
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*-------------------------------------------------------------------------
      /space 1
      * Main
      /space 1
     c     *entry        plist
     c                   parm                    ys
     c                   parm                    p00001
     c* Open
     c     *in01         ifeq      '0'
     c                   exsr      sinz
     c                   exsr      o
     c                   movel     '1'           *in01
     c                   endif
     c* Close
     c* Detail
     c                   exsr      d
     c                   return
      /space 2
      * Open
      /space 1
     c     o             begsr
     C                   CALL      'EQSINZXC'
     C                   PARM                    XC
     C                   CALL      'EQSINZXS'
     C                   PARM                    XS
     C* Modus
     C                   MOVEL     XYOBJ         XSOBJ
     c                   endsr
      /space 3
      * Detail
      /space 1
     c     d             begsr
     c* Landkennzeichen prüfen, ob gefüllt
     c                   if        rlkz = *blanks
     c                   eval      ystxt = 'Landkennzeichen fehlt! Stammdaten +
     c                                      sind falsch!'
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Landkennzeichen prüfen
     c                   clear                   p00003
     c                   eval      xsoa = '  '
     c                   eval      afir  = rfir
     c                   eval      abtnr = rbtnr
     c                   eval      alkz  = rlkz
     c                   eval      alplz = rlplz
     c                   eval      aort  = rort
     c                   call      'VSD19   '
     c                   parm                    xs
     c                   parm                    p00003
     c                   eval      wxstxt = xstxt
     c                   movea     aapds         xse(01)
     c                   movea     *blanks       xse(02)
     c                   movea     rlkz          xse(03)
     c                   movea     *blanks       xse(06)
     c                   movel     'LKZ     '    xsfld
     c                   movel     ' '           xspar
     c                   exsr      spr
     c                   if        xsfs > ' '
     c                   movel     wxstxt        ystxt
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Postleitzalhl prüfen, ob gefüllt
     c                   if        rlplz = *blanks
     c                   eval      ystxt = 'Postleitzahl fehlt! Stammdaten +
     c                                      sind falsch!'
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Postleitzahl prüfen
     c                   clear                   p00003
     c                   movel     rfir          afir
     c                   movel     rbtnr         abtnr
     c                   movel     rlkz          alkz
     c                   movel     rlkzis        alkzis
     c                   movel     rlplz         alplz
     c                   movel     rort          aort
     c                   movel     'PL'          xsoa
     c                   call      'VSD19   '
     c                   parm                    xs
     c                   parm                    p00003
     c                   movel     xstxt         wxstxt
     c* Datensatz prüfen
     c                   movea     aapds         xse(01)
     c                   movea     *blanks       xse(02)
     c                   movea     rlplz         xse(03)
     c                   movel     'LPLZ    '    xsfld
     c                   movel     '1'           xspar
     c                   exsr      spr
     c                   if        xsfs > ' '
     c                   movel     wxstxt        ystxt
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Ort prüfen, ob gefüllt
     c                   if        rort  = *blanks
     c                   eval      ystxt = 'Ort fehlt! Stammdaten +
     c                                      sind falsch!'
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Versandart prüfen, ob gefüllt
     c                   if        rfvsat = *blanks
     c                   eval      ystxt = 'Versandart wurde nicht übergeben!'
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   return
     c                   endif
     c* Versandart Nachnahme prüfen, wenn Nachnahmebetrag gefüllt ist
     c                   eval      ww1nb = *blanks
     c                   eval      xsew = rfvsat
     c                   eval      %subst(xsew:11:1) = 'F'
     c                   eval      xsfld = 'FVSAT   '
     c                   eval      xspar = ' '
     c                   exsr      spwc
     c                   if        xsds = ja
     c                   eval      ww1nb = %subst(xstxt:30:1)
     c* Nachnahme > 0 und Parameter Nachnahmebetrag =' ' --> Nachnahmeversandart gefordert!!
     c                   if        rfnnbt > *Zeros and ww1nb = *blanks
     c                   eval      ystxt = 'Keine Nachnahme Versandart! NN-Betr'
     c                                   + 'ag vorhanden'
     c                   eval      ysds = nein
     c                   exsr      errorlog
     c                   endif
     c                   endif
     c                   endsr
      /space 3
      * Errorlog
      /space 1
     C**********************************************************************
     C*Sicherung in das Protokoll
     C*-------------------------------------------------------------------------
     c     errorlog      begsr

      *
     C                   move      §§§JNO        jno              10
     C                   clear                   md
     C                   movea(p)  'IFDFRDCHK '  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  JNO           md(033)
     C                   movea(p)  ' ERROR '     md(040)
     C**********         movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(050)
     C                   movea(p)  rvsrhe        md(051)
     C                   movea(p)  ystxt         md(106)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     c                   setoff                                       44
     C
     c                   endsr
      /copy yqrpglesrc,eqsrpgcsin
      /COPY YQRPGLESRC,EQSRPGCSP
