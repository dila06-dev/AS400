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
      *
      * ********************************************************************************        
      *                                                                        
      *                                                                        
      *                                                                        
      *                                                                        
      * SELECT DISTINCT * FROM DB_OPTLFR6 WHERE EPBENR ='5368' and epbepo      
      * =260 ORDER BY #LBLBBDAT                                                
      *                                                                        
      * Änderungsprotokoll:...                                                
      *
      * SELECT DISTINCT EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO,
      * EKBEDA, EPBETE, max(EPBEST) EPBEST ,max(maximal) MAXIMAL,
      *   max(MINIMAL) MINIMAL, max("COUNT")      "COUNT", SEL0013,
      * #LBLBLSTC, #LBLBTENR, #LBLBBDAT, #LBLBBWMG, #LBLBBWME, #LBLBLGBS,
      * #AEBEJJ, #AEBENR, #AEBEPO, SEL0010,SEL0011,SEL0012, TSTAMP, A001,
      * NAME FROM DB_OPTLFR6
      * group by
      * EKLFNR, EPBEJJ, EPBENR, EPMENG, EPTENR, EPBEPO,EKBEDA, EPBETE,
      * SEL0013,#LBLBLSTC,#LBLBTENR,#LBLBBDAT,#LBLBBWMG,#LBLBBWME,
      * #LBLBLGBS,#AEBEJJ,#AEBENR,#AEBEPO,SEL0010,SEL0011,SEL0012,TSTAMP,
      * a001,Name ORDER BY #LBLBBDAT
      *
      *
      *
      *
      *********************************************************************************

     fDB_OPTLFR6uf   e             disk       RENAME(DB_OPTLFR6:phy01r)
     f                                        USROPN


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
     Dpos              s             10i 0
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
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C***  *ENTRY        PLIST
     C***                PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------

     c                   exsr      srvorlauf
     C                   seton                                        50
     C                   seton                                        44

     C                   open      DB_OPTLFR6
     C                   DO        *HIVAL
     C*
     C                   READ      DB_OPTLFR6                             95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c                   exsr      sr1000
     c  n44              delete    phy01r
     c  n50              update    phy01r
     c                   endif
     C                   enddo
     C                   close     DB_OPTLFR6
     C*
     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr1000        BEGSR

     C*
     C                   seton                                        44
     C                   if        EKLFNR       =   #EKLFNR    and
     C                             EPBEJJ       =   #EPBEJJ    and
     C                             EPBENR       =   #EPBENR    and
     C                             EPMENG       =   #EPMENG    and
     C                             EPTENR       =   #EPTENR    and
     C                             EPBEPO       =   #EPBEPO    and
     C                             EKBEDA       =   #EKBEDA    and
     C*                            EPBETE       =   #EPBETE    and
     C*                            EPBEST       =   #EPBEST    and
     C*                            MAXIMAL      =   #MAXIMAL   and
     C*                            MINIMAL      =   #MINIMAL   and
     C*                            "COUNT"      =   #"COUNT"   and
     C                             SEL0013      =   #SEL0013   and
     C                             #LBLBLSTC    =   ##LBLBLSTC and
     C                             #LBLBTENR    =   ##LBLBTENR and
     C                             #LBLBBDAT    =   ##LBLBBDAT and
     C                             #LBLBBWMG    =   ##LBLBBWMG and
     C                             #LBLBBWME    =   ##LBLBBWME and
     C*                            #LBLBLGBS    =   ##LBLBLGBS and
     c                             #AEBEJJ      =   ##AEBEJJ   and
     C                             #AEBENR      =   ##AEBENR   and
     C                             #AEBEPO      =   ##AEBEPO   and
     C*                            SEL0010      =   #SEL0010   and
     C*                            SEL0011      =   #SEL0011   and
     C*                            SEL0012      =   #SEL0012   and
     C                             TSTAMP       =   #TSTAMP    and
     C*                            A001         =   #A001      and
     C                             NAME         =   #NAME
     C                   setoff                                       44
     C                   endif
     C
     C     *LIKE         DEFINE    EKLFNR        #EKLFNR
     C     *LIKE         DEFINE    EPBEJJ        #EPBEJJ
     C     *LIKE         DEFINE    EPBENR        #EPBENR
     C     *LIKE         DEFINE    EPMENG        #EPMENG
     C     *LIKE         DEFINE    EPTENR        #EPTENR
     C     *LIKE         DEFINE    EPBEPO        #EPBEPO
     C     *LIKE         DEFINE    EKBEDA        #EKBEDA
     C     *LIKE         DEFINE    EPBETE        #EPBETE
     C     *LIKE         DEFINE    EPBEST        #EPBEST
     C     *LIKE         DEFINE    MAXIMAL       #MAXIMAL
     C     *LIKE         DEFINE    MINIMAL       #MINIMAL
     C*    *LIKE         DEFINE    "COUNT"       #"COUNT"
     C     *LIKE         DEFINE    SEL0013       #SEL0013
     C     *LIKE         DEFINE    #LBLBLSTC     ##LBLBLSTC
     C     *LIKE         DEFINE    #LBLBTENR     ##LBLBTENR
     C     *LIKE         DEFINE    #LBLBBDAT     ##LBLBBDAT
     C     *LIKE         DEFINE    #LBLBBWMG     ##LBLBBWMG
     C     *LIKE         DEFINE    #LBLBBWME     ##LBLBBWME
     C     *LIKE         DEFINE    #LBLBLGBS     ##LBLBLGBS
     C     *LIKE         DEFINE    #AEBEJJ       ##AEBEJJ
     C     *LIKE         DEFINE    #AEBENR       ##AEBENR
     C     *LIKE         DEFINE    #AEBEPO       ##AEBEPO
     C     *LIKE         DEFINE    SEL0010       #SEL0010
     C     *LIKE         DEFINE    SEL0011       #SEL0011
     C     *LIKE         DEFINE    SEL0012       #SEL0012
     C     *LIKE         DEFINE    TSTAMP        #TSTAMP
     C     *LIKE         DEFINE    A001          #A001
     C     *LIKE         DEFINE    NAME          #NAME
     C
     C                   eval      #EKLFNR     = EKLFNR
     C                   eval      #EPBEJJ     = EPBEJJ
     C                   eval      #EPBENR     = EPBENR
     C                   eval      #EPMENG     = EPMENG
     C                   eval      #EPTENR     = EPTENR
     C                   eval      #EPBEPO     = EPBEPO
     C                   eval      #EKBEDA     = EKBEDA
     C                   eval      #EPBETE     = EPBETE
     C                   eval      #EPBEST     = EPBEST
     C                   eval      #MAXIMAL    = MAXIMAL
     C                   eval      #MINIMAL    = MINIMAL
     C*                  eval      #"COUNT"    = "COUNT"
     C                   eval      #SEL0013    = SEL0013
     C                   eval      ##LBLBLSTC  = #LBLBLSTC
     C                   eval      ##LBLBTENR  = #LBLBTENR
     C                   eval      ##LBLBBDAT  = #LBLBBDAT
     C                   eval      ##LBLBBWMG  = #LBLBBWMG
     C                   eval      ##LBLBBWME  = #LBLBBWME
     C                   eval      ##LBLBLGBS  = #LBLBLGBS
     C                   eval      ##AEBEJJ    = #AEBEJJ
     C                   eval      ##AEBENR    = #AEBENR
     C                   eval      ##AEBEPO    = #AEBEPO
     C                   eval      #SEL0010    = SEL0010
     C                   eval      #SEL0011    = SEL0011
     C                   eval      #SEL0012    = SEL0012
     C                   eval      #TSTAMP     = TSTAMP
     C                   eval      #A001       = A001
     C                   eval      #NAME       = NAME
     C
     C

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     srvorlauf     BEGSR
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
     C*alle filtern, eigentlich nur RP5 und RP6 aber da Kunde KOKDLI
     C*auf *blank passt das
     C*A n d r e a
     c/exec sql
     c+ insert into tvrelwaeco/DB_OPTLFR6
     c+ SELECT * FROM DB_OPTLFR3 ORDER BY (rrn(DB_OPTLFR3)) desc
     c/end-exec


     C     ##vorlauf     ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
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
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

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
