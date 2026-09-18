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

     fcalenderl1if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     D*#CDATEISO        S               D   DATFMT(*iso)
     D$Date            S               D   DATFMT(*iso)
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
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #CDATEISO        10
     C                   PARM                    #CDATEISO2        8
     C                   PARM                    sc                2
     C                   PARM                    count             3 0

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------
     c                   movel     #CDATEISO     $CDATEISO
     c                   clear                   #count

     C*                 update zkun
      * :Rechnungspositionen -2-
     C     $CDATEISO     SETgt     calenderl1                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READp     calenderl1                             95
     C                   IF        *in95 = '1' or count = #count or
     C                             datum > $DATE
     C                   leave
     C                   else
     c                   exsr      sr1000
     c                   endif
     c                   enddo
     c                   endif
     C                   EXSR      RETURN

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C                   if        sc       = 'UK'
     C                   z-add     uk            #sc               6 0
     C                   endif
     C                   if        sc       = 'FR'
     C                   z-add     fr            #sc               6 0
     C                   endif
     C                   if        sc       = 'SE'
     C                   z-add     se            #sc               6 0
     C                   endif
     C                   if        sc       = 'IT'
     C                   z-add     it            #sc               6 0
     C                   endif
     C*
     C                   if        $NAMEDAY <> 'Samstag' and
     C                             $NAMEDAY <> 'Sonntag' and
     C                             #sc  <> 1             and
     C                             de   <> 1
     C     #count        add       1             #count            5 0
     C                   movel     $CDATEISO     #CDATEISO        10
     C                   eval      #CDATEISO2 = %subst(#CDATEISO:01:04) +
     C                                          %subst(#CDATEISO:06:02) +
     C                                          %subst(#CDATEISO:09:02)
     C                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C*
     C                   RETURN
     C*
     C                   ENDSR
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

     c                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
