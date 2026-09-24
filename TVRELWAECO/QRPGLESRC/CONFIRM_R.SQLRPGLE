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
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *  SC     Schnittstelle                                      *
      *                                                            *
      *  Freischaltung: 88505 Frankreich                           *
      *                 55278 Italien                              *
      *                 08138 Schweden                             *
      *                 78146 Spanien                              *
      *                 42634 Norwegen                             *
      *                 78678 Polen                                *
      *                 54939 Österreich                           *
      *                 01887 Dänemark                             *
      *                 40631 England                              *
      *                                                            *
      *****************************************************************

     fconfirml1 uf   e           k disk
     fconfirmoutuf a e           k disk    RENAME(confirmpf:PHY01R)
     fconfirmprouf a e           k disk    RENAME(confirmpf:PHY02R)

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
     I/COPY ##E
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    ##C010            7

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     c                   exsr      sr9999
     c                   movel     ##c010        #c010             7 0
     C     #c010         SETLL     confirml1                          95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      confirml1                              95
     C                   IF        *in95 = '1'            or
     C                             #c010    <>  c010
     C                   leave
     C                   else
     C*                 update original confirm
     c                   movel     '10'          c110
     C                   write     phy01r
     C                   update    confirmpf
     C                   movel     tstampi       c120
     C                   write     phy02r
     c                   endif
     c                   enddo
     c                   endif

     C                   EXSR      RETURN

     C*-------------------------------------------------------------------------
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
