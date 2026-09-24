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
      * checken, ob Kunde Konditionskunde
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     f#id1010   up   e           k disk    RENAME(#id1010:phy01r)
     fteil00    if   e           k disk    RENAME(teil1:phy02r)
     fPRJ627L3  if   e           k disk    RENAME(PRJ627F:phy03r)
     fPRJ626p   if   e           k disk    RENAME(PRJ626F:phy04r)

     DDate             S               D   DATFMT(*EUR)
     Djahrx            S              4  0
     Dmonatx           S              2  0
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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   seton                                        40
     C     #WE#EL        chain     PRJ627L3                           94
     C  n94renr          chain     prj626p
     C  n94              z-add     wschl         #wschl            2 0
     C  n94              clear                   WACDEK
     C  n94              movel     wschl         WACDEK
     C  n94              update    phy01r

     C**************************************************************************
     C* SR1000:
     C*-------------------------------------------------------------------------
     C*
     C     SR1000        BEGSR
     C*
     C
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
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
     C                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
