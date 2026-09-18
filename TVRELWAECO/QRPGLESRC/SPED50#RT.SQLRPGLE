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

     fx         uf   e             disk
     f                                     RENAME(x      :phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fsped51#   uf a e             disk
     f                                     RENAME(DPD00R1:phy02r)
     f***                                  INFDS(DSF2)

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
     D chrc            S              1    DIM(1024)
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     Iphy02r
     I              DPD055                      #DPD055
     I              DPD080                      #DPD080
     I              DPD115                      #DPD115
     I              DPD120                      #DPD120
     I              DPD125                      #DPD125
     I              DPD130                      #DPD130
     I              DPD135                      #DPD135
     I              DPD140                      #DPD140
     I              DPD145                      #DPD145
     I              DPD150                      #DPD150
     I              DPD155                      #DPD155
     I              DPD160                      #DPD160
     I              DPD165                      #DPD165
     I              DPD170                      #DPD170
     I              DPD175                      #DPD175
     I              DPD180                      #DPD180
     I              DPD185                      #DPD185
     I              DPD190                      #DPD190
     I              DPD195                      #DPD195
     I              DPD200                      #DPD200
     I              DPD205                      #DPD205
     I              DPD210                      #DPD210
     I              DPD215                      #DPD215
     I              DPD220                      #DPD220
     I              DPD225                      #DPD225
     I              DPD230                      #DPD230
     I              DPD235                      #DPD235
     I              DPD240                      #DPD240
     I              DPD245                      #DPD245
     I              DPD250                      #DPD250
     I              DPD255                      #DPD250
     I              DPD260                      #DPD260
     I              DPD265                      #DPD260
     I              DPD270                      #DPD270
     I              DPD275                      #DPD270
     I              DPD280                      #DPD280
     I              DPD285                      #DPD280
     I
     I*-------------------------------------------------------------------------
     C                   open      x
     C                   DO        *HIVAL
     C
     C                   READ      x                                      95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
      *DPD015:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD015        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD015
     C
      *DPD020:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD020        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD020
     C*
      *DPD025:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD025        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD025
     C*
      *DPD030:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD030        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD030
     C
      *DPD045:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD045        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD045
     C*
      *DPD090:
     C                   z-add     0             n                 4 0
     C                   movel     ' '           chrfl1            1
     C                   movea     DPD090        chrc
     C                   do        35            n
     C                   movea     chrc(n)       chrfl1
     C     chrfl1        ifeq      X'60'
     C     chrfl1        oreq      X'60'
     C     chrfl1        oreq      X'21'
     C     chrfl1        oreq      X'22'
     C     chrfl1        oreq      X'23'
     C     chrfl1        oreq      X'24'
     C     chrfl1        oreq      X'25'
     C     chrfl1        oreq      X'26'
     C     chrfl1        oreq      X'27'
     C     chrfl1        oreq      X'28'
     C     chrfl1        oreq      X'29'
     C     chrfl1        oreq      X'1B'
     C     chrfl1        oreq      X'39'
     C                   move      X'40'         chrfl1
     C                   movea     chrfl1        chrc(n)
     C                   endif
     C                   enddo
     C                   movea     chrc          DPD090
     C*
      *DPD090:
     C*                  z-add     0             n                 4 0
     C*                  z-add     0             n2                4 0
     C*                  z-add     0             n3                4 0
     C*                  movel     ' '           chrfl1            1
     C*                  movea     DPD090        chrc
     C*                  movea     DPD090        chrc2
     C*                  do        35            n
     C*                  movea     chrc(n)       chrfl1
     C*    chrfl1        ifeq      X'60'
     C*    chrfl1        oreq      X'60'
     C*    chrfl1        oreq      X'60'
     C*    chrfl1        oreq      X'21'
     C*    chrfl1        oreq      X'22'
     C*    chrfl1        oreq      X'23'
     C*    chrfl1        oreq      X'24'
     C*    chrfl1        oreq      X'25'
     C*    chrfl1        oreq      X'26'
     C*    chrfl1        oreq      X'27'
     C*    chrfl1        oreq      X'28'
     C*    chrfl1        oreq      X'29'
     C*    chrfl1        oreq      X'28'
     C*    chrfl1        oreq      X'1B'
     C*    chrfl1        oreq      X'39'
     C*                  eval      n2 = n2 + 1
     C*                  endif
     C*                  eval      n3 = n2 + n
     C*                  movea     chrc2(n3)     chrc(n)
     C*                  enddo
     C*                  movea     chrc          DPD090
     C*
     C*
     c                   setoff                                       77
     c   77              write     phy02r
     c                   update    phy01r
     c                   endif
     C
     C
     C
     C                   enddo
     C                   close     x

     C                   EXSR      RETURN
     C**************************************************************************
     C*ermittlung der Nachnahme Schlüssel
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##6000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
     C*

     c*/exec sql
     c*+ update sped51# set dpd335=
     c*+ (select
     c**+ SELECT ALFIRM, ALAFJJ, ALAFNR, ALAFPO, ALKMJJ, ALKMNR, ALKMPO,
     c**+ ALLIJJ, ALLINR, ALLIPO, ALRGJJ, ALRGNR, ALLIAR ,
     c*+ char( AlFIRM concat char(digits(ALAFJJ)) concat ALAFNR
     c*+              concat char(digits(ALAFPO))
     c*+              concat char(digits(ALKMJJ)) concat ALKMNR
     c*+              concat char(digits(ALkmPO))
     c*+              concat char(digits(ALlijj)) concat allinr
     c*+              concat char(digits(ALlipo))
     c**+              concat char(digits(ALRGJJ)) concat ALRGNR , 60) KEY
     c*+              concat char(digits(ALRGJJ)) concat ALRGNR , 60)
     c*+ FROM sped51# ,AFlp01
     c*+ WHERE ALFIRM in ('01', '51') and substr(dpd065, 9, 6)= ALKMNR
     c*+                              and substr(dpd065, 3, 6)= ALKDNR
     c*+ and substr(dpd335, 1, 60) = ' '
     c*/end-exec

     c*/exec sql
     c*+ update sped51# set dpd320=
     c*+ (select '20'
     c*+ FROM sped51# ,AFlp01
     c*+ WHERE ALFIRM in ('01', '51') and substr(dpd065, 9, 6)= ALKMNR
     c*+                              and substr(dpd065, 3, 6)= ALKDNR
     c*+ and dpd320  = ' ' )
     c*/end-exec
     c
     C     ##6000        ENDSR


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
