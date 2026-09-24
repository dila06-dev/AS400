     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Timestamp für FTP erstellen                             *
     F************************************************************

     DDate             S               D   DATFMT(*EUR)
     DTIME             S               T   TIMFMT(*EUR)

     Djahr4            S              4  0
     Djahr2            S              2  0
     Dmonat            S              2  0
     Dtag              S              2  0
     Dstunden          S              2  0
     Dminuten          S              2  0
     Dzeitstempel      S             11A

     C     *entry        plist
     C                   parm                    zeitstempel

     C                   TIME                    Date
     C                   TIME                    time
     c                   extrct    date:*Y       jahr4
     c                   move      jahr4         jahr2
     c                   extrct    date:*M       monat
     c                   extrct    date:*D       tag
     c                   extrct    time:*H       stunden
     c                   extrct    time:*Mn      minuten

     c                   eval      zeitstempel=%EditC(jahr2:'X')+
     c                                         %EditC(monat:'X')+
     c                                         %EditC(tag:'X')+
     c                                         '_' +
     c                                         %EditC(stunden:'X')+
     c                                         %EditC(minuten:'X')

     C                   move      *on           *inlr
