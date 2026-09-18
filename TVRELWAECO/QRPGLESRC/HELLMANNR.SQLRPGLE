     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      * create index tvrelwaeco/AVISHELLl1
      * on TVRELWAECO/AVISHELLPF(APAFJJ,APAFNR,ALLIJJ,ALLINR)
      * Index AVISHELLL1 in TVRELWAECO für Tabelle AVISHELLPF in TVRELWAECO
      *
      * create index tvrelwaeco/LBLBHELLl1
      * on TVRELWAECO/LBLBHELLpf(#AEWEJJ,#AEWENR)
      * Index LBLBHELLL1 in TVRELWAECO für Tabelle LBLBHELLPF in TVRELWAECO
      *
      * SELECT * FROM AVISorder ORDER BY substr(AVISORDER, 3, 12) ,
      *                                  substr(AVISORDER, 1, 01)
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fAVISHELLl1uf   e             disk
     f                                     RENAME(AVISHELLPF:phy01r)
     f                                     INFDS(DSF1)
     F                                     USROPN
     fAVISorder if a e             disk    RENAME(avisorder:PHY02R)

     fLBLBHELLl1uf   e             disk
     f                                     RENAME(LBLBHELLPF:phy03r)
     f                                     INFDS(DSF2)
     F                                     USROPN
     fWEorder   if a e             disk    RENAME(weorder:PHY04R)

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
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     Iphy01r
     I              key                         #key
     I*-------------------------------------------------------------------------
     Iphy02r
     I              avisorder                   input
     I*-------------------------------------------------------------------------
     Iphy03r
     I              key                         #key
     I*-------------------------------------------------------------------------
     Iphy04r
     I              weorder                     input
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    p                10
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C     *LIKE         DEFINE    APAFJJ        #APAFJJ
     C     *LIKE         DEFINE    APAFNR        #APAFNR
     C     *LIKE         DEFINE    ALLIJJ        #ALLIJJ
     C     *LIKE         DEFINE    ALLINR        #ALLINR
     C*...
     C*Aufträge
     c                   exsr      sr9999
     C
     c                   if        p = 'AVISORDER'
     c                   exsr      sr1000
     c
     C                   open      AVISHELLL1
     C                   DO        *HIVAL
     C
     C                   READ      AVISHELLl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   select
     C                   when      status     = '  '
     C                   exsr      sr2500
     C                   eval      status     = '10'
     C                   eval      #outputd   = datum
     C                   eval      #outputst  = tstampi
     c                   update    phy01r
     C                   when      status     = '20'
     C                   eval      status     = '30'
     C                   eval      #released  = datum
     C                   eval      #releasest = tstampi
     c                   update    phy01r
     C                   other
     C                   endsl
     c                   endif
     C
     C                   enddo
     C                   close     AVISHELLl1
     C                   endif
b
     C*...
     C*Wareneingänge

     C     *LIKE         DEFINE    #AEWEJJ       AEWEJJ
     C     *LIKE         DEFINE    #AEWENR       AEWENR

     c                   if        p = 'WEORDER  '
     c                   exsr      sr4000
     c
     C                   open      LBLBHELLL1
     C                   DO        *HIVAL
     C
     C                   READ      LBLBHELLl1                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   select
     C                   when      status     = '  '
     C                   exsr      sr4500
     C                   eval      status     = '10'
     C                   eval      #outputd   = datum
     C                   eval      #outputst  = tstampi
     c                   update    phy03r
     C                   when      status     = '20'
     C                   eval      status     = '30'
     C                   eval      #released  = datum
     C                   eval      #releasest = tstampi
     c                   update    phy03r
     C                   other
     C                   endsl
     c                   endif
     C
     C                   enddo
     C                   close     LBLBHELLl1
     C                   endif
b

     C                   EXSR      RETURN

     C**************************************************************************
     C*Sätze nach Kommissionierung
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau ...
     c/exec sql
     c+ insert into tvrelwaeco/AVISHELLPF
     c+ SELECT APFIRM,APAFJJ,APAFNR,APAFPO,APKMJJ,APKMNR,APKMPO,APEIUZ,
     c+ APKDNR,APKMTE,APTENR,APLANR,APTBZ1,aplfte,APGLMG,AMLIAR,AMLFTE,
     c+ AMVSNR,AMAFAT,AMVSBD,AMLIBD,AMLIAR,AMNAM1,AMNAM2,AMNAM3,
     c+ AMSTRA,AMPOLD,AMPOLZ,AMWORT,AMPOFA,AMLAND,ALAFJJ,ALAFNR,
     c+ ALAFPO,ALKMJJ,ALKMNR,ALKMPO,ALLIJJ,ALLINR,ALLIPO,ALRGJJ,
     c+ ALRGNR,ALMAAF,ALLSDA,ALREDA,ALGLMG ,dec(0, 10)#cc,
     c+ char('  ', 2) status,current date #inputd,current timestamp
     c+ #inputst, current date #outputd, current timestamp #outputst,
     c+ current date #released, current timestamp #releasest,
     c+ char((APFIRM concat char(digits(APAFJJ)) concat APAFNR
     c+              concat char(digits(APAFPO)) concat
     c+       AMFIRM concat char(digits(APKMJJ)) concat APKMNR
     c+              concat char(digits(APKMPO)) concat
     c+       AlFIRM concat char(digits(ALAFJJ)) concat ALAFNR
     c+              concat char(digits(ALAFPO))), 64) KEY
     c+ from afpo01,afkm01,aflp01
     c+ WHERE apkmjj>2013 and apfirm='01' and APAFST <'99'
     c+ and aptenr in
     c+ ('9102800004','9103500495','9103500717','9103500719',
     c+  '9105302773','9103500714','9103500794','9103500818',
     c+  '9103501043','9999Z-021360E3')
     c+ and APFIRM=amfirm and apkmjj=amkmjj and APKMNR=AmKMNR
     c+ and apafjj=amafjj and apafjj=amafjj and apafnr=amafnr
     c+ and apfirm=alfirm and apkmjj=alkmjj and APKMNR=alKMNR
     c+ and APKMPO=alkmpo and
     c+ substr((APFIRM concat char(digits(APAFJJ)) concat APAFNR
     c+                concat char(digits(APAFPO)) concat
     c+         AMFIRM concat char(digits(APKMJJ)) concat APKMNR
     c+                concat char(digits(APKMPO)) concat
     c+         AlFIRM concat char(digits(ALAFJJ)) concat ALAFNR
     c+                concat char(digits(ALAFPO))), 1, 64)
     c+ not in ( select key from tvrelwaeco/AVISHELLPF)
     c+
     c/end-exec

     C     ##1000        ENDSR
     c*
     C**************************************************************************
     C* sr2500: Sendungssatz Aufträge
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     C                   if        #APAFJJ  <>  APAFJJ  or
     C                             #APAFNR  <>  APAFNR  or
     C                             #ALLIJJ  <>  ALLIJJ  or
     C                             #ALLINR  <>  ALLINR
     c                   clear                   count             3 0
      *   Header
     c                   eval      input                         =
     c                             'K'                           +
     c                             ';'                           +
     c                             %subst(#key:03:10)            +
     c                             ';'                           +
     c                             %char(APLFTE)                 +
     c                             ';'                           +
     c                             APKDNR                        +
     c                             ';'                           +
     c                             %trimr(AMNAM1)                +
     c                             ';'                           +
     c                             %trimr(AMNAM2)                +
     c                             ';'                           +
     c                             %trimr(AMSTRA)                +
     c                             ';'                           +
     c                             %trimr(AMPOLZ)                +
     c                             ';'                           +
     c                             %trimr(AMWORT)                +
     c                             ';'                           +
     c                             %trimr(AMPOLD)                +
     c                             ';'                           +
     c                             '???VART'                     +
     c                             ';'                           +
     c                             %char(tstampi)                +
     c                             ';'                           +
     c                             %trimr(#key)
     c
     c                   write     phy02r
     c                   endif
     C*
      *   position
     c                   clear                   menge            12 0
     c                   eval      menge=(ALGLMG*1)
     c                   eval      input                         =
     c                             'P'                           +
     c                             ';'                           +
     c                             %subst(#key:03:10)            +
     c                             ';'                           +
     c                             %subst(#key:13:04)            +
     c                             ';'                           +
     c                             %char(APLFTE)                 +
     c                             ';'                           +
     c                             %trimr(APTENR)                +
     c                             ';'                           +
     c                             %char(menge)                  +
     c                             ';'                           +
     c                             'ST'                          +
     c                             ';'                           +
     c                             %char(tstampi)                +
     c                             ';'                           +
     c                             %trimr(#key)
     c
     c                   write     phy02r
     C*
      *   position Texte
     c                   eval      count=(count+1)
     c                   eval      input                         =
     c                             'T'                           +
     c                             ';'                           +
     c                             %subst(#key:03:10)            +
     c                             ';'                           +
     c                             %subst(#key:13:04)            +
     c                             ';'                           +
     c                             %char(count)                  +
     c                             ';'                           +
     c*  Druck auf Lieferschein
     c                             '0'                           +
     c                             ';'                           +
     c*  Druck auf Kommliste
     c                             '0'                           +
     c                             ';'                           +
     c*  Packhinweis
     c                             '  '                          +
     c                             ';'                           +
     c*  Speditionshinweis
     c                             '  '                          +
     c                             ';'                           +
     c*  Text
     c                             '  '                          +
     c                             ';'                           +
     c                             %char(tstampi)                +
     c                             ';'                           +
     c                             %trimr(#key)
     c*
     c                   write     phy02r
     c
     c                   eval      #APAFJJ   =  APAFJJ
     c                   eval      #APAFNR   =  APAFNR
     c                   eval      #ALLIJJ   =  ALLIJJ
     c                   eval      #ALLINR   =  ALLINR
     C*
     C     ##2500        ENDSR
     C*
     c*
     C**************************************************************************
     C*Sätze für Wareneingang
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##4000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau ...
     c/exec sql
     c+ insert into tvrelwaeco/LBLBHELLPF
     c+ SELECT #AEFIRM, #AEBEJJ, #AEBENR, #AEBEPO, #AELFNR, #AEWEJJ,
     c+ #AEWENR, #LBLBFIRM, #LBLBTENR, #LBLBLSTC, #LBLBBDAT, #LBLBBZEI,
     c+ #LBLBBWMG, #LBLBBEZ1, #LBLBBEZ2, #TSTAMP,
     c+                                     dec(0, 10)#cc,
     c+ char('  ', 2) status,current date #inputd,current timestamp
     c+ #inputst, current date #outputd, current timestamp #outputst,
     c+ current date #released, current timestamp #releasest,
     c+ char((#AEFIRM concat char(digits(#AEBEJJ)) concat #AEBENR
     c+               concat char(digits(#AEBEPO)) concat
     c+       #AEFIRM concat char(digits(#AEWEJJ)) concat #AEWENR)
     c+                                            , 64) KEY
     c+ FROM datenkw/#lblb
     c+ WHERE #LBLBTMST > '20140000000000000000000000' and #LBLBFIRM ='01'
     c+ and #LBLBLANR = 070 and #LBLBBDAT>20140100 and #LBLBLSTC in
     c+ ('825','950')
     c+ and #LBLBTENR not in
     c+ ('9102800004','9103500495','9103500717','9103500719',
     c+  '9105302773','9103500714','9103500794','9103500818',
     c+  '9103501043','9999Z-021360E3') and
     c+ substr((#AEFIRM concat char(digits(#AEBEJJ)) concat #AEBENR
     c+                 concat char(digits(#AEBEPO)) concat
     c+         #AEFIRM concat char(digits(#AEWEJJ)) concat #AEWENR),
     c+                                          1, 64)
     c+ not in ( select key from tvrelwaeco/LBLBHELLPF)
     c/end-exec

     C     ##4000        ENDSR
     c*
     C**************************************************************************
     C* sr4500: Sendungssatz Wareneingänge
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C                   if        #AEWEJJ  <>  AEWEJJ  or
     C                             #AEWENR  <>  AEWENR
      *   Header
     c                   eval      input                         =
     c                             'K'                           +
     c                             ';'                           +
     c                             %subst(#key:03:10)            +
     c                             ';'                           +
     c                             #AELFNR                       +
     c                             ';'                           +
     c                             %char(#LBLBBDAT)              +
     c                             ';'                           +
     c                             %char(tstampi)                +
     c                             ';'                           +
     c                             %trimr(#key)
     c
     c                   write     phy04r
     c                   endif
     C*
      *   position
     c                   clear                   menge            12 0
     c                   eval      menge=(#LBLBBWMG*1)
     c                   eval      input                         =
     c                             'P'                           +
     c                             ';'                           +
     c                             %subst(#key:03:10)            +
     c                             ';'                           +
     c                             %subst(#key:13:04)            +
     c                             ';'                           +
     c                             %char(#LBLBBDAT)              +
     c                             ';'                           +
     c                             %trimr(#LBLBTENR)             +
     c                             ';'                           +
     c                             %char(menge)                  +
     c                             ';'                           +
     c                             'ST'                          +
     c                             ';'                           +
     c                             %char(tstampi)                +
     c                             ';'                           +
     c                             %trimr(#key)
     c
     c                   write     phy04r
     C*
     c
     c                   eval      AEWEJJ    =  #AEWEJJ
     c                   eval      AEWENR    =  #AEWENR
     C*
     C     ##4500        ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C*.
     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
