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
      *****************************************************************

     fartdaten  ip   e           k disk    RENAME(ARTDATENR:phy01r)
     fteos01    uf a e           k disk
     fTEIL00    if   e           k disk

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
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------

      *                 ...                                                   
     c                   if        f1# = *blank
     c                   movel     #teewtenr     f1#
     c                   endif
     c                   if        f1#  = '9100100003'
     c                   exsr      SR5850
     c                   exsr      sr9000
     c                   endif

     c
     C**************************************************************************
     C* SR5850: TEOS01
     C*-------------------------------------------------------------------------
     C*
     C     SR5850        BEGSR
     C*
     c     KEY5850       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '1000'        TEOSKLCD
     c                   movel     f1#           TEOSTENR
     C*
     C                   clear                   #1#               8 0
     C                   clear                   #2#               8 0
     C                   clear                   #3#               8 0
     C                   clear                   #6#               8 0
     c     KEY5850       chain     TEOS01
     c                   IF        %found(TEOS01)
     c                   eval      #1# = #1  *10
     c                   move      #1#           TEOSMM01
     c     ' ':'0'       xlate     TEOSMM01      TEOSMM01
     c                   eval      #2# = #2  *10
     c                   move      #2#           TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   eval      #3# = #3  *10
     c                   move      #3#           TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   eval      #6# = #6  *1000
     c                   move      #6#           TEOSMM04
     c     ' ':'0'       xlate     TEOSMM04      TEOSMM04
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##5850        ENDSR
     C*
     C**************************************************************************
     C* SR9000: lesen Parameterdaten aus DometicSystemdatei
     C*-------------------------------------------------------------------------
     C*
     C     SR9000        BEGSR
     C*
     c     teilkey       klist
     c                   kfld                    firma             2
     c                   kfld                    TETENR
     c                   movel     '01'          firma
     c                   movel     f1#           tetenr
     C*
     c     teilkey       chain     TEIL1
     c                   IF        %found(TEIL00)
     c                   else
     c                   endif
     C*
     C     ##9000        ENDSR
     C*
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     C                   setoff                                       20
     C                   clear                   error             1
     C                   clear                   xpos              3 0

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
