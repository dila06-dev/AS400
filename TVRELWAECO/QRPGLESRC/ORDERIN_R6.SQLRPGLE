     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  SC     Schnittstelle                                    *
     F*                                                          *
     F*  Freischaltung: shunshine                                *
     F*                                                          *
     F*SELECT EKBER2, EPBEPO , EPTENR , count(*) FROM xout GROUP BY
     F*EKBER2, EPBEPO , EPTENR HAVING count(*) > 1 ORDER BY EKBER2
     F*                                                          *
     F*SELECT EKFIRM, EKBEJJ, EKBENN, EKBER1,
     F*EKBENR, EKBER2, EPBEPO , EPTENR, epmeng FROM bbek, bbep
     F*WHERE EKFIRM ='01' and EKBER2 Like '%012015%' and EKFIRM=EPFIRM
     F*and EKBEJJ=EpBEJJ and EKBENR=EpBENR ORDER BY EKBER2
     F*                                                          *
     F*concat  substr(char(current date +0 day), 7, 2)  concat
     F*substr(char(current date +0 day), 4, 2)  concat
     F*substr(char(current date +0 day), 1, 2), 8, 0) BBSCBETE,
     F*APLFTE                           BBSCBETE,
     F*                                                          *
     F*                                                          *
     F*  Status RP für repeat, nur die Transaktion ftp wird     *
     F*  wiederholt                                             *
     F*  Status BE für repeat, nur die Einkaufsbestellung wird  *
     F*  wiederholt                                             *
     F*                                                          *
     F* SELECT BBSCBETE, date(date(substr(char(BBSCBETE) , 1, 4) concat '-'
     F* concat substr(char(BBSCBETE) , 5, 2) concat '-' concat
     F* substr(char(bbscbete) , 7, 2))) + 0001 day ,
     F*           char(date(date(substr(char(BBSCBETE) , 1, 4) concat '-'
     F* concat substr(char(BBSCBETE) , 5, 2) concat '-' concat
     F* substr(char(bbscbete) , 7, 2))) + 0001 day) FROM bbsc
     F*
     F* SELECT ORDERSUN.APFIRM, ORDERSUN.APAFJJ, ORDERSUN.APAFNR,
     F* ORDERSUN.APAFPO, ORDERSUN.APTENR, ORDERSUN.APAFST, ORDERSUN.APLFTE,
     F* ORDERSUN.APAFDA, BBSC_INPUT.BBSCBETE , TELVZ1 FROM ordersun,
     F* BBSC_INPUT , teil WHERE APFIRM = BBSCFIRM and APAFJJ = BBSCAFJJ and
     F* APAFNR = BBSCAFNR and APtenr = BBSCTENR and BBSCTSTP > current
     F* timestamp -2 day and BBSCBETE = aplfte and tetenr= APtenr and
     F* tefirm= APfirm
     F*   FROM       TELVZ1                                      *
     F************************************************************
     H*datfmt(*iso) timfmt(*iso)
     H*datfmt(*eur) timfmt(*eur)

     fORDERSUNL up   e             disk    prefix('#')
     f                                     RENAME(ordersun:PHY01R)

     forderh    if a e             disk    RENAME(orderhpf:header)
     forderl    if a e             disk    RENAME(orderlpf:line  )
     fordert    if a e             disk    RENAME(ordertpf:text  )
     fSUNSHINE_Cif a e             disk    RENAME(SUNSHINE_C:xout)
     fSUNSHINE_dif a e             disk    RENAME(SUNSHINE_C:dout)
     fSUNSHINE_eif a e             disk    RENAME(SUNSHINE_C:eout)
     fSUNSHINE_fif a e             disk    RENAME(SUNSHINE_C:fout)
     fSUNSHINE_gif a e             disk    RENAME(SUNSHINE_C:gout)

     fteil01    if   e           k disk
     fafko01    if   e           k disk
     fafpo01    if   e           k disk
     fafad01    if   e           k disk
     fafep01    if   e           k disk
     fkund01    if   e           k disk
     fkpif03    if   e           k disk
     D*-------------------------------------------------------------------------
     DDate             S               D   DATFMT(*EUR)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T

     D Chx             DS
     D  chx1                   1     20    INZ('Auftrag in Trend ein')
     D  chx2                  21     40    INZ('geleitet ==> next St')
     D  chx3                  41     50    INZ('ep: ORDERR')

     D Up              C                   'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
     D Lo              C                   'abcdefghijklmnopqrstuvwxyz'


     D*-----------Record -------------------------------------------------------
     d*d_record      E DS                  INZ
     D*                                    prefix('#')

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*-------------------------------------------------------------------------
     Ixout
     I              SUNSHINE_C                  §xout
     I*-------------------------------------------------------------------------
     Idout
     I              SUNSHINE_c                  §dout
     I*-------------------------------------------------------------------------
     Ieout
     I              SUNSHINE_c                  §eout
     I*-------------------------------------------------------------------------
     Ifout
     I              SUNSHINE_c                  §fout
     I*-------------------------------------------------------------------------
     Igout
     I              SUNSHINE_c                  §gout
     I*-------------------------------------------------------------------------

     c                   if        #status  = *blank  or
     c                             #status  = 'RP'    or
     c                             #status  = 'BE'
     c                   if        $APFIRM  = #APFIRM  and
     c                             $APAFJJ  = #APAFJJ  and
     c                             $APAFNR  = #APAFNR
     c                   seton                                        33
     c                   else
     c                   setoff                                       33
     c                   endif
     c  n33              exsr      sr9999
      * :Kopfdaten Auftrag
     c     keysr_afko    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #APAFJJ
     c                   kfld                    #APAFNR

     c     keysr_afko    chain     afko01                             96
     c   96              clear                   afko1
     C*
      * :Position Auftrag
     c     keysr_afpo    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #APAFJJ
     c                   kfld                    #APAFNR
     c                   kfld                    #APAFPO

     c     keysr_afpo    chain     afpo01                             96
     c   96              clear                   afpo1
     c
      * :Lieferadresse/Adresse bill
     c     keysr_afad    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #APAFJJ
     c                   kfld                    #APAFNR
     c                   kfld                    adposi
     c                   kfld                    adaart

     c                   clear                   adposi
     c                   movel     'ADVS'        adaart

     c     keysr_afad    chain     afad01
     c                   IF        %found(afad01)
     c                   else
     c                   movel     'ADAG'        adaart
     c                   clear                   adposi
     c     keysr_afad    chain     afad01                             96
     c   96              clear                   afad1
     C                   endif
     C*
      * :lesen bezug items     afep
     c     keysr_afep    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #APAFJJ
     c                   kfld                    #APAFNR
     c                   kfld                    #APAFPO
     C*
     c     keysr_afep    chain     afep01                             97
     c   97              clear                   AFEPIDEN
     c   97              clear                   AFEPTENR
     c
      * :lesen bezug     s     kund01
     c     keysr_kund    klist
     c                   kfld                    #APFIRM
     c                   kfld                    apkdnr
     C*
     c     keysr_kund    chain     kund01                             97
     c   97              clear                   KDNAM1
     c
      * :lesen item      s     kpif03
     c     keysr_kpif    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #aptenr
     c                   kfld                    apkdnr
     c                   if        AFEPIDEN   = *blank
     c     keysr_kpif    chain     kpif03                             97
     c   97              clear                   KPIDEN
     c  n97              movel     KPIDEN        AFEPIDEN
     c                   endif
     c
     C*
     c     keysr_kund    chain     kund01                             97
     c   97              clear                   KDNAM1
     c
      * :Teil lesen für TELVZ1 vorlaufzeit
     c     keysr_teil    klist
     c                   kfld                    #APFIRM
     c                   kfld                    #aptenr
     c     keysr_teil    chain     teil01                             97
     c   97              clear                   TELVZ1
     c                   clear                   #BBSCBETE         8 0
     c                   eval      #BBSCBETE = #APLFTE
     c  n97              exsr      sr9900y
     c  n97              exsr      sr9900
     c  n97              movel     newdate       newdate#
     c  n97              if        #APLFTE < newdate#  and
     c                             #APAFNR <> '000000'
     c                   eval      #BBSCBETE = newdate#
     c                   endif
     c
     c                   if        *in33 = '0' and
     c                             #status <> 'BE'
     c  n96              exsr      srheader
     c                   endif
     c
     c                   if        *in33 = '0' and
     c                             #status <> 'RP'
     c  n33              exsr      sr_save
     c                   if        AKAFAT  <> '58 '
     c  n33              exsr      srBBSC
     c                   endif
     c                   if        AKAFAT  <> '58 '
     c  n33              call      'ORDERIN_C6'
     C                   PARM                    akfirm
     c                   endif
     c                   if        AKAFAT  <> '58 '
     c  n33              exsr      srBBEU
     c                   endif
     c                   endif
     c
     c                   if        #status <> 'BE'
     c  n96              exsr      srline
     c                   endif
     c
     c  n96              eval      #status = '10'
     c   96              eval      #status = '96'
     c                   eval      $APFIRM  =    #APFIRM
     c                   eval      $APAFJJ  =    #APAFJJ
     c                   eval      $APAFNR  =    #APAFNR
     c                   update    phy01r
     c                   endif

     C     *LIKE         DEFINE    #APFIRM       $APFIRM
     C     *LIKE         DEFINE    #APAFJJ       $APAFJJ
     C     *LIKE         DEFINE    #APAFNR       $APAFNR

     C**************************************************************************
     C*header
     C*-------------------------------------------------------------------------
     C*
     C     srheader      BEGSR
      *
     C*header
     c                   movel     ADHINW        #adhinw          07
     c     ' ':'0'       xlate     #adhinw       #adhinw
     c                   movel     akfirm        #akfirm           2 0
     c                   movel     akkdnr        #akkdnr           6 0
     c                   eval      H010      =  'H'
     c                   eval      H020      =  *zero
     c                   movel     #adhinw       H020
     c                   eval      H030      =  #akfirm
     c                   eval      H040      =  #akkdnr
     c                   eval      H050      =  %char(#APAFJJ)   +
     c                                          %subst(#apafnr:01:06)
     c                   eval      H060      = %date()
     c                   eval      H070      = %time()
     c                   eval      H080      = *blank
     c                   eval      H090      = *blank
     c                   eval      H100      = ADNAM1
     c                   eval      H110      = ADNAM2
     c                   eval      H120      = ADNAM3
     c                   eval      H130      = ADSTRA
     c                   eval      H140      = ADPOLD
     c                   eval      H150      = *Zero
     c                   eval      H160      = ADWORT
     c                   eval      H170      = *Blank
     c                   eval      H180      = *Blank
     c                   eval      H190      = *Blank
     c                   eval      H200      = *Blank
     c                   eval      H210      = *Blank
     c                   eval      H220      = *Blank
     c                   eval      H230      = %subst(akvsbd:02:02)
     c                   eval      H240      = AKMAAF
     c                   if        akmaaf    = *blank
     c                   eval      H240      = AKREF1
     c                   endif
     c                   if        AKREF1    = *blank
     c                   eval      H240      = AKREF2
     c                   if        #akkdnr   = 015177 or
     c                             #akkdnr   = 062765
     c                   eval      H240      = %subst(AKREF2:08:20)
     c                   eval      H170      = 'H'
     c                   eval      H180      = AKREF2
     c                   endif
     c                   endif
     c                   eval      H250      = '0'
     c                   eval      H260      = AKLIAR
     c                   eval      H270      = '0'
     c                   eval      H280      = *blank
     c                   eval      H290      = *blank
     c                   exsr      sremail
     c                   if        #TPTTXT   <> *blank
     c                   movel     #TPTTXT       H300
     c                   else
     c                   eval      H300      = KDNAM1
     c                   endif
     c                   eval      %subst(h310:417:03) = akvsbd
     c                   eval      %subst(h310:501:12) = ADPOLZ +
     c                             '  '
     c                   eval      H320      = aksabe
     c                   eval      H330      = §§§USR
     c                   eval      H330      = 'Sunshin' +
     c                                         AKAFAT
     c                   eval      H340      = *blank
     c                   eval      H350      = '99'
     c                   eval      H360      = date
     c                   eval      H370      = tstampi
     c                   write     header
     c                   eval      H350      = '10'
     c
     c                   move      h020          #h020             7
     c     ' ':'0'       xlate     #h020         #h020
     c                   move      h030          #h030             7
     c     ' ':'0'       xlate     #h030         #h030
     c                   move      h040          #h040            10
     c     ' ':'0'       xlate     #h040         #h040
     c                   move      h020          #h150             5
     c     ' ':'0'       xlate     #h020         #h150
     c                   eval      %subst(h310:251:30) =  ADNAM1
     c                   eval      %subst(h310:281:30) =  ADNAM2
     c                   eval      %subst(h310:311:30) =  ADNAM3
     c                   eval      %subst(h310:341:30) =  ADSTRA
     c                   eval      %subst(h310:371:03) =  ADPOLD
     c                   eval      %subst(h310:374:10) =  ADPOLZ
     c                   eval      %subst(h310:384:30) =  adwort
     c
     c                   eval      §xout =       H010  +
     c****                                       #H020 +
     c                                         #adhinw +
     c                                           #H030 +
     c                                           #h040 +
     c                                          (H050) +
     c                                     %char(H060) +
     c                                     %char(H070) +
     c                                          (H080) +
     c                                          (H090) +
     c                                          (H100) +
     c                                          (H110) +
     c                                          (H120) +
     c                                          (H130) +
     c                                          (H140) +
     c                                           #H150 +
     c                                          (H160) +
     c                                          (H170) +
     c                                          (H180) +
     c                                          (H190) +
     c                                          (H200) +
     c                                          (H210) +
     c                                          (H220) +
     c                                          (H230) +
     c                                          (H240) +
     c                                          (H250) +
     c                                          (H260) +
     c                                          (H270) +
     c                                          (H280) +
     c                                          (H290) +
     c                                          (H300) +
     c                                          (H310) +
     c                                          (H320) +
     c                                          (H330) +
     c                                          (H340) +
     c                                          (H350) +
     c                                     %char(H360) +
     c                                     %char(H370)
     C*company 01 EDC          ==> X
     c                   if        akfirm='01'
     c                   write     xout
     c                   endif
     C*company 08 Belgien      ==> d
     c                   eval      §dout = §xout
     c                   if        akfirm='08'
     c                   write     dout
     c                   endif
     C*company 52 Niederland   ==> e
     c                   eval      §eout = §xout
     c                   if        akfirm='52'
     c                   write     eout
     c                   endif
     C*company 61 Österreich   ==> f
     c                   eval      §fout = §xout
     c                   if        akfirm='61'
     c                   write     fout
     c                   endif
     C*company 55 Schweiz      ==> g
     c                   eval      §gout = §xout
     c                   if        akfirm='55'
     c                   write     gout
     c                   endif

     C     ##header      ENDSR

     C**************************************************************************
     C*line
     C*-------------------------------------------------------------------------
     C*
     C     srline        BEGSR
     C*

     c                   eval      L010      = 'L'
     c                   eval      L020      = *zero
     c                   eval      L030      = *zero
     c                   eval      L040      = %char(#APAFJJ)   +
     c                                         %subst(#apafnr:01:06)
     c                   eval      L050      = #APAFPO
     c                   clear                   #l060            10
     c                   eval      #l060 = %subst(%char(APLFTE):1:4) +
     c                                                           '-' +
     c                                     %subst(%char(APLFTE):5:2) +
     c                                                           '-' +
     c                                     %subst(%char(APLFTE):7:2)
     c                   eval      l060      = %date(#l060)
     c                   eval      L070      = *zero
     c                   eval      L080      = #aptenr
     c                   eval      L090      = APTBZ1
     c                   eval      L100      = APBSMG
     c                   eval      L110      = AFEPIDEN
     c                   eval      L120      = *Blank
     c                   eval      L130      = *Blank
     c                   eval      L140      = 'N'
     c                   eval      L150      = *Blank
     c                   eval      L160      ='Sunshin' +
     c                                         AKfirm
     c*************                            AKAFAT
     c                   eval      L170      = *blank
     c                   eval      L180      = date
     c                   eval      L190      = tstampi
     c                   eval      L200      = date
     c                   eval      L210      = *zero
     c                   eval      L220      = *zero
     c                   eval      L230      = *zero
     c                   eval      L240      = '99'
     c                   eval      L250      = #akkdnr
     c                   eval      L990      = *blank
     c                   write     line
     c                   eval      L240      = '10'
     c
     c                   move      l020          #l020
     c     ' ':'0'       xlate     #l020         #l020             4
     c                   move      l030          #l030
     c     ' ':'0'       xlate     #l030         #l030             6
     c                   move      l050          #l050
     c     ' ':'0'       xlate     #l050         #l050             5
     c                   move      l100          #l100
     c     ' ':'0'       xlate     #l100         #l100             8
     c                   move      l210          #l210
     c     ' ':'0'       xlate     #l210         #l210             8
     c                   move      l220          #l220
     c     ' ':'0'       xlate     #l220         #l220             4
     c                   move      l230          #l230
     c     ' ':'0'       xlate     #l230         #l230             6
     c                   move      l250          #l250
     c     ' ':'0'       xlate     #l250         #l250             7
     c                   eval      §xout =      (L010) +
     c                                          (#L020) +
     c                                          (#L030) +
     c                                          (L040) +
     c                                          (#L050) +
     c                                     %char(L060) +
     c                                          (L070) +
     c                                          (L080) +
     c                                          (L090) +
     c                                          (#L100) +
     c                                          (L110) +
     c                                          (L120) +
     c                                          (L130) +
     c                                          (L140) +
     c                                          (L150) +
     c                                          (L160) +
     c                                          (L170) +
     c                                     %char(L180) +
     c                                     %char(L190) +
     c                                     %char(L200) +
     c                                          (#L210) +
     c                                          (#L220) +
     c                                          (#L230) +
     c                                          (L240) +
     c                                          (#L250) +
     c                                          (L990)
     C*company 01 EDC          ==> X
     c                   if        akfirm='01'
     c                   write     xout
     c                   endif
     C*company 08 Belgien      ==> d
     c                   eval      §dout = §xout
     c                   if        akfirm='08'
     c                   write     dout
     c                   endif
     C*company 52 Niederland   ==> e
     c                   eval      §eout = §xout
     c                   if        akfirm='52'
     c                   write     eout
     c                   endif
     C*company 61 Österreich   ==> f
     c                   eval      §fout = §xout
     c                   if        akfirm='61'
     c                   write     fout
     c                   endif
     C*company 55 Schweiz      ==> g
     c                   eval      §gout = §xout
     c                   if        akfirm='55'
     c                   write     gout
     c                   endif

     C     ##line        ENDSR

     C**************************************************************************
     C*text
     C*-------------------------------------------------------------------------
     C*
     C     srtext        BEGSR
      *
     c                   clear                   text


     c                   movel     'T'           h010
     c                   eval      t020      =   h030
     c***                linksbündige *blanks werden eleminiert
     c                   if        T020 = 55278 or T020 = 78146
     c                   eval      T030      =   %trim(%char (jahr)) +
     c                                           %trim(T030)
     c                   endif
     c*
     c                   movel     '99'          T350
     c                   if        T020 = 22691 or T020 = 03438
     c                   movel     '99'          T350
     c                   endif
     c                   movel     date          T040
     c                   movel     zeit          T050
     c                   movel     tstampi       t370

     C     ##text        ENDSR

     C**************************************************************************
     C*bbsc generieren
     C*-------------------------------------------------------------------------
     C*
     C     srBBSC        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c
     c                   clear                   ##BBSCLFNR       10
     c                   clear                   ##BBSCLANR       03
     C*company 01 EDC          ==> X
     c                   if        akfirm='01'
     c                   eval      ##BBSCLFNR = '92678     '
     c                   endif
     C*company 08 Belgien      ==> d
     c                   if        akfirm='08'
     c                   eval      ##BBSCLFNR = '6451200   '
     c                   endif
     C*company 52 Niederland   ==> e
     c                   if        akfirm='52'
     c                   eval      ##BBSCLFNR = '6451200   '
     c                   endif
     c                   clear                   ##BBSCABTL        3
     c                   clear                   ##BBSCBEAT        3
     c                   clear                   ##BBSCBEAR        1
     C*company 61 Österreich   ==> f
     c                   if        akfirm='61'
     c                   eval      ##BBSCLFNR = '330266    '
     c                   eval      ##BBSCABTL    ='EK'
     c                   eval      ##BBSCBEAT    ='100'
     c                   eval      ##BBSCBEAR    ='D'
     c                   endif
     C*company 55 Schweiz      ==> g
     c                   if        akfirm='55'
     c                   eval      ##BBSCLFNR = '01599     '
     c                   eval      ##BBSCLFNR = '01671     '
     c                   eval      ##BBSCBEAT    ='100'
     c                   eval      ##BBSCABTL    ='EK'
     c                   eval      ##BBSCBEAR    ='D'
     c                   eval      ##BBSCLANR    ='001'
     c                   endif
     c                   if        akfirm='08' or
     c                             akfirm='52'
     c                   eval      ##BBSCLFNR = '6451200   '
     c                   eval      ##BBSCBEAT    ='100'
     c                   eval      ##BBSCABTL    ='EK'
     c                   eval      ##BBSCBEAR    ='D'
     c                   eval      ##BBSCLANR    ='N95'
     c                   endif
     C*
     C*Ableitungen für Übergaben in qtemp
     c/exec sql
     c+ insert into       bbsc
     c+ select  char(' ', 1) BBSCLOCK,  char('GANG#', 10) BBSCJNAM,
     c+ zoned(('20')
     c+ concat  substr(char(current date +0 day), 7, 2)  concat
     c+ substr(char(current date +0 day), 4, 2)  concat
     c+ substr(char(current date +0 day), 1, 2), 8, 0)   BBSCJDAT,
     c+ zoned(substr(char(current time), 1, 2)  concat
     c+ substr(char(current time), 4, 2)  concat
     c+ substr(char(current time), 7, 2), 6, 0)  BBSCJZEI,
     c+         APUSER                           BBSCUSER,
     c+         char('ORDERIN_R6', 10)           BBSCPROG,
     c+         char('TVRELWAECO', 10)           BBSCBIBL,
     c+         APFIRM                           BBSCFIRM,
     c+         current timestamp                BBSCTSTP,
     c+         :##BBSCBEAT                      BBSCBEAT,
     c+         :##BBSCLFNR                      BBSCLFNR,
     c+         char('001', 03)                  BBSCWKNR,
     c+         :##BBSCABTL                      BBSCABTL,
     c+         :##BBSCBEAR                      BBSCBEAR,
     c+         zoned(('20')
     c+         concat  substr(char(current date +0 day), 7, 2)  concat
     c+         substr(char(current date +0 day), 4, 2)  concat
     c+         substr(char(current date +0 day), 1, 2), 8, 0)
     c+                                          BBSCBEDA,
     c+         char(' ', 01)                    BBSCBRKA,
     c+         :##BBSCLANR                      BBSCLANR,
     c+         APTENR                           BBSCTENR,
     c+         APBSMG                           BBSCMENG,
     c+         :#BBSCBETE                       BBSCBETE,
     c+         zoned(0, 04, 0)                  BBSCBEJJ,
     c+         char(' ', 06)                    BBSCBENR,
     c+         zoned(0, 04, 0)                  BBSCBEPO,
     c+         APAFDA                           BBSCUEDA,
     c+         char(' ', 01)                    BBSCUEKZ,
     c+         char(' ', 10)                    BBSCBDML,
     c+         char(' ', 01)                    BBSCVPKZ,
     c+         APAFJJ                           BBSCAFJJ,
     c+         APAFNR                           BBSCAFNR,
     c+         zoned(0, 05, 0)                  BBSCARBG,
     c+         zoned(0, 05, 0)                  BBSCAGFL,
     c+         zoned(0, 26, 0)                  BBSCTMST,
     c+         zoned(0, 03, 0)                  BBSCPOAZ,
     c+         char(' ', 03)                    BBSCSABE,
     c+         zoned(0, 08, 0)                  BBSCLFTE,
     c+         APMAAF                           BBSCREF1,
     c+         char(APFirm) concat
     c+         char(APAFJJ) concat
     c+         APAFNR                           BBSCREF2,
     c+         char(' ', 20)                    BBSCEXBL,
     c+         zoned(0, 06, 0)                  BBSCBLPO,
     c+         char(' ', 44)                    BBSCFREI
     c+ from    ORDERSUN   a
     c+         where  :#APFIRM = APFIRM  and
     c+                :#APAFJJ = APAFJJ  and
     c+                :#APAFNR = APAFNR
     c***+                :#APAFPO = APAFPO and  aptenr in
     c***+   ( select b.aptenr from ORDERSUNS b
     c***+         where  :#APFIRM = b.APFIRM and
     c***+                :#APAFJJ = b.APAFJJ and
     c***+                :#APAFNR = b.APAFNR and
     c***+                :#APAFPO = b.APAFPO )
     c/end-exec

     C     ##BBSC        ENDSR

     C**************************************************************************
     C*bbeu generieren
     C*-------------------------------------------------------------------------
     C*
     C     srBBEU        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     C*Ableitungen für Übergaben in bbeu
     c/exec sql
     c+ insert into       bbeu
     c+ SELECT char(' ', 1) EKLOCK,
     c+        EKJNAM, EKJDAT, EKJZEI, EKUSER, EKPROG, EKBIBL,
     c+        EKFIRM, EKBEJJ, EKBENR, EPBEPO, zoned(10, 4, 0) epbepu,
     c+        char('V', 1) EUVPKZ,
     c+        zoned((substr(EKBER2, 3, 4)), 4, 0) EUAFJJ,
     c+        char((substr(EKBER2, 09, 6)), 06) EUBENR,
     c+        zoned( EPBEPO  , 5, 0) EPBEPO, zoned(0, 5, 0) EUAGFL,
     c+        EPMENG, zoned(0, 11, 2) EUGLMG,zoned(0, 11, 2) EUBRMG,
     c+        zoned(0, 11, 2) EUQSMG, char('010', 3) EUBEGR, EPTENR,
     c+        char(' ', 1) EUKDKZ,char(' ', 1) EUFRIN,char(' ', 20)EUFRex
     c+        FROM bbek01, bbep01 WHERE EKLFNR ='92678' and
     c+             ekfirm=epfirm and EKBEJJ=EpBEJJ and EKBEnr=EpBEnr
     c+             and EKFIRM                        = '01'     and
     c+             char((substr(EKBER2, 03, 4)), 10) = 2015     and
     c+             char((substr(EKBER2, 09, 6)), 10) = '637297' and
     c+       ekfirm not in (select eufirm from bbeu01 where
     c+       EKBEJJ=EUBEJJ and EKBENR=EUBENR and EPBEPO=EUBEPO)
     c+
     c/end-exec

     C     ##BBEU        ENDSR

     C**************************************************************************
     C*bbek neu status auf 08 setzten ==> EBBEST
     C*-------------------------------------------------------------------------
     C*
     C     srBBEK        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     C*Ableitungen für Übergaben in bbeu
     c/exec sql
     c+ update bbek01 set ekbest='08' where ekfirm in
     c+ (select eufirm from BBEU01
     c+  WHERE eufirm=:#APFIRM  and
     c+        EUAFJJ=:#APAFJJ  and
     c+        EUAFNR=:#APAFNR  and
     c+        eufirm=ekfirm    and
     c+        EKBEJJ=EUBEjj    and
     c+        EKBENR=EUBENR)
     c/end-exec

     C     ##BBEK        ENDSR

     C**********************************************************************
     C*Sicherung nach Auftragserzeugung und Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_save       BEGSR
      *
     C                   movel     h020          #h030             7
     C                   clear                   md
     C                   movea(p)  'ORDERIN_R6'  md(001)
     C                   movea(p)  '§§§JOB    '  md(011)
     C                   movea(p)  '§§§USR    '  md(022)
     C                   movea(p)  '          '  md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C                   movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(099)
     C                   movea(p)  #h030         md(100)
     C                   movea(p)  h050          md(106)
     C                   MOVEA     ' '           md(117)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
      *
     C     ##_save       ENDSR
     C
     C**************************************************************************
     C*email holen
     C*-------------------------------------------------------------------------
     C*
     C     sremail       BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     c                   clear                   #TPTTXT          40
     c
     C*Ableitungen für Übergaben in bbeu
     c/exec sql
     c+
     c+ SELECT TPTTXT  into :#TPTTXT
     c+    FROM trtp01 WHERE TPTART ='SABE' and TPTCDE =:AKSABE and
     c+                TPTTXT like '%@%' and TPFIRM =:AKFIRM and TPSPCD ='D'
     c/end-exec

     C     ##email       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9900        BEGSR
     C*
     c                   clear                   newdate           8
     c                   clear                   newdate#          8 0

     c/exec sql
     c+ select  substr(char
     c+ (date(substr(char(:ccdate), 1, 4) concat '-' concat
     c+       substr(char(:ccdate), 5, 2) concat '-' concat
     c+       substr(char(:ccdate), 7, 2)  ) + :TELVZ1 days, eur), 7, 4)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ccdate), 1, 4) concat '-' concat
     c+       substr(char(:ccdate), 5, 2) concat '-' concat
     c+       substr(char(:ccdate), 7, 2)  ) + :TELVZ1 days, eur), 4, 2)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ccdate), 1, 4) concat '-' concat
     c+       substr(char(:ccdate), 5, 2) concat '-' concat
     c+       substr(char(:ccdate), 7, 2)  ) + :TELVZ1 days, eur), 1, 2)
     c+ into  :newdate
     c+       from qsys2/qsqptabl
     c+
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*time stamp
     C*update ifap set ifaplfte =  (select
     C*zoned(year(current date)
     C*concat digits(dec(month(current date), 2, 0)) concat
     C*       digits(dec(day(current date), 2, 0)))
     C*       FROM qsys2/qsqptabl) WHERE IFAPIFNR = '109175'
     C*-------------------------------------------------------------------------
     C*
     C     sr9900y       BEGSR
     C*
     c                   clear                   ccdate            8

     c/exec sql
     c+ select
     c+ zoned(year(current date)
     c+ concat digits(dec(month(current date), 2, 0)) concat
     c+        digits(dec(day(current date), 2, 0)))  into :ccdate
     c+ from qsys2/qsqptabl
     c/end-exec

     C     ##9900y       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   exsr      sr9999
     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     c                   clear                   ###h020           7 0
     c                   clear                   ###h050          10

     C                   ENDSR

