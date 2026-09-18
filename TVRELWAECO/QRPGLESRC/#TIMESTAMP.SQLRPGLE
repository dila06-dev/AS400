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
     F************************************************************

     DDate             S               D   DATFMT(*EUR)
     DTIME             S               T   TIMFMT(*EUR)

     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dtstampi          S               Z
     Dtstampplus       S               Z
     Dtstampminu       S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     Dweek             s              1s 0

     C     *entry        plist
     C                   parm                    funktion         02
     C                   parm                    zeitstempel      26
     C                   parm                    dayplus          03 0
     C                   parm                    daypminus        03 0

     c                   clear                   zeitstempel
     c                   if        funktion = '01'
     C                   movel     tstampi       zeitstempel
     c                   endif
     c                   if        dayplus  <> 0
     C                   movel     tstampplus    zeitstempel
     c                   endif
     c                   if        daypminus <> 0
     C                   movel     tstampminu    zeitstempel
     c                   endif

     C                   move      *on           *inlr

     C**************************************************************************
     c*
     C     *inzsr        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     c+ select current timestamp, current date, current date -365 day,
     c+        current time, dec(DAYOFWEEK_iso(current date ), 1, 0),
     c+        current timestamp + :dayplus day,
     c+        current timestamp - :daypminus day
     c+ into   :tstampi, :datum, :datum2, :zeit, :week, :tstampplus,
     c+                                                 :tstampminu
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag


     C                   ENDSR

