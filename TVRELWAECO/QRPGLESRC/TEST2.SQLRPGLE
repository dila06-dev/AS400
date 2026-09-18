     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *wichtiger Hinweis:
      *
      * SELECT hex(substr(DPD020, 2, 1)), (substr(DPD020, 2, 1)), dpd020
      * FROM tvrelwaeco/sped51# ORDER BY hex(substr(DPD020, 2, 1))
      *
      *
      *********************************************************************************

     ftest      if   e             disk
     f                                     RENAME(test:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     ftest3     uf a e           k disk    RENAME(test3:phy02r)

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
     D
     D chrc            S              1    DIM(1024)
     D address         S              1    DIM(1024)
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C                   open      test
     C                   DO        *HIVAL
     C                   READ      test                                   95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
      *DPD015:
     C                   clear                   umlaut            1
     C                   clear                   umlaut2           2
     C                   clear                   pos               3 0
     C                   clear                   pos2              3 0
     C                   clear                   n_                3 0
     C                   eval      umlaut  = '@'
     C                   eval      umlaut2 = '##'
     C                   eval      pos = %scan(umlaut: h310)
     C                   eval      pos2= %scan(umlaut2: h310)
     C                   if        pos > 0 and pos2 > 0
     C                   clear                   address
     C                   setoff                                       61
     c                   setoff                                       62
     c                   movea     h310          chrc
     C     pos2          do        120           n_
     C     chrc(n_)      ifeq      '#'
     C     #address      ifne      *blank
     C                   movea     address       #address       1024
     C                   eval      h600x     =   %subst(h310:1:03)
     C                   eval      h610x     =   %trim(#address)
     c                   if        h610x  <> ' '
     C   62              write     phy02r
     C                   endif
     C   62              clear                   h600x
     C   62              clear                   h610x
     C   62              clear                   address
     C   62              clear                   #address
     C                   endif
     C   61              seton                                        62
     C                   seton                                        61
     C                   else
     c   62              move      chrc(n_)      address(n_)
     c   62              movea     address       #address
     c   62              setoff                                       61
     c                   endif
     c                   enddo
     c                   movea     address       #address       1024
     c                   eval      h600x     =   %subst(h310:1:03)
     c                   eval      h610x     =   %trim(#address)
     c                   if        h610x  <> ' '
     C                   write     phy02r
     c                   endif
     C                   clear                   h600x
     C                   clear                   h610x
     C                   clear                   address
     C                   clear                   #address
     C
     c                   endif
     c                   endif
     C                   enddo
     C                   close     test

     C                   EXSR      RETURN
b
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
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
