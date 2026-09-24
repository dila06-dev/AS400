     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * qsys2/qsqptabl
      * char('2012' concat '/' concat '123456'
      * concat '/' concat '0000' concat '    '),
      * current timestamp c090
      * c070, current date c40
      *
      *
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     H*datfmt(*iso) timfmt(*iso)
     H*datfmt(*eur) timfmt(*eur)

     f#confirm  uf   e             disk
     f                                     RENAME(#confirm:phy01r)
     f***                                  INFDS(DSF1)
     f                                     USROPN
     fconfirm   uf a e             disk
     f                                     RENAME(confirmpf:phy02r)
     f***                                  INFDS(DSF1)

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
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr1000
     c****               exsr      sr8000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
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

     C*Ableitung nach Auftragseingang
     c/exec sql
     c+ insert into qtemp/confirmhlp
     c+ SELECT zoned( substr(DOKDNR, 1, 6), 7) c010,
     c+        char(domaaf, 10) C020,
     c+        zoned(digits(doafpo), 5) C030,
     c+        date(substr(char(dolfTE), 1, 4) concat '-' concat
     c+             substr(char(dolfTE), 5, 2) concat '-' concat
     c+             substr(char(dolfTE), 7, 2) ) c040,
     c+        zoned(doBSMG*1, 8, 3) c050,
     c+        char('expected new delivery date! old: ' concat
     c+        char(substr(DOLFTE, 7, 2)) concat '.' concat
     c+        char(substr(DOLFTE, 5, 2)) concat '.' concat
     c+        char(substr(DOLFTE, 1, 4)) concat ' new: ' concat
     c+        char(substr(DODSTE, 7, 2)) concat '.' concat
     c+        char(substr(DODSTE, 5, 2)) concat '.' concat
     c+        char(substr(DODSTE, 1, 4)), 60) c060,
     c+        char(doAFJJ concat '/' concat char(doAFNR)
     c+        concat '/' concat char(digits(doAFPO)), 20) c070,
     c+        char (' ', 1) c080, DOTMST c090,
     c+        char(dotenr concat char (' ', 085)) c100,
     c+        char('00', 2) c110
     c+        FROM DOMCHKBAS
     c+        where DODSTE <> 0  and DOAFST ='17'
     c+        and   DOTMST > (select tstamp -00 days from confirmcr)
     c/end-exec
     c
     C     ##1000        ENDSR

     C**************************************************************************
     C*Zuweisungen Case
     C*-------------------------------------------------------------------------
     C*
     C     sr8000        BEGSR

     C                   open      #confirm
     C                   DO        *HIVAL
     C                   READ      #confirm                               95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C                   eval      #IFAPAFJJ= %subst(C070: 1: 04)
     C                   eval      #IFAPAFNR= %subst(C070: 6: 06)
     C
     c                   eval      #IFAPAFPO     =
     c                             '0'                     +
     c                             %subst(C070: 13: 04)

     C                   CALL      'WAO00F   '
     C                   PARM                    #IFAPAFJJ         4
     C                   PARM                    #IFAPAFNR         6
     C                   PARM                    #IFAPAFPO         5
     C                   PARM                    #IFAPLFTE         8 0
     C                   movel     #IFAPLFTE     IFAPLFTE         10
     c                   eval      IFAPLFTE      =
     c                             %subst(IFAPLFTE: 01: 04)    +
     c                             '-'                          +
     c                             %subst(IFAPLFTE: 05: 02)    +
     c                             '-'                          +
     c                             %subst(IFAPLFTE: 07: 02)
     c*    I S O - Norm
     c                   setoff                                       20
      /Free
         MONITOR;
          Test(DE) *EUR IFAPLFTE;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     C*             *euro auf *iso
     c  n20              eval      IFAPLFTE =
     c                             %char(%date (IFAPLFTE:*eur) :*iso)
     c  n20              movel     IFAPLFTE      c040

     c                   setoff                                       20
      /Free
         MONITOR;
          Test(DE) *iso IFAPLFTE;
            If %Error;
                *in20 = '1';
            Endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     C     *LIKE         DEFINE    c040          #c040
     c                   movel     c040          #c040
     c                   movel     #c040         ##c040           10
     c  n20              movel     IFAPLFTE      c040

     c  n20              if        #c040   =   c040
     c                   seton                                        20
     c                   endif

     c  n20              if        #c040   <>  c040

     C                   eval      TETENR   = %subst(C100: 1: 15)
     C                   CALL      'WAO00D'
     C                   PARM                    TETENR           15
     C                   PARM                    DSLBBSIDBS       13 4
     C                   if        DSLBBSIDBS  > C050  or
     C                             DSLBBSIDBS  = C050
     c                   seton                                        20
     c                   endif

     c  n20              eval      c060          =
     c                             'important note, expected new d' +
     c                             'elivery date old: '             +
     c                             ##c040
     c                   endif

     c  n20              update    phy01r
     c** 20  ==>         delete    phy01r
     c  n20              write     phy02r
     C                   endif
     C                   enddo
     c                   close     #confirm

     C     ##8000        ENDSR

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
