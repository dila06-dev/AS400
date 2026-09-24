     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Stücklisten der Dachklimaanlagen erstellen              *
     F************************************************************
     fteil      ip   e             disk

     dartnrprefix      s              6a
     d#KOMSLAT         s              3a
     d#KOMTENR         s             15a
     d#KOMAZAR         s              2a
     d#KOMJNUM         s              6a
     d#KOMVARK         s              3a
     d#KOMMENG         s             11p 2
     d#KOMBETE         s              8p 0
     d#KOMGADA         s              8p 0
     d#KOMPEAR         s              2a


     C                   CALL      'EXSLAZS'
     C                   PARM      '100'         #KOMSLAT
     C                   PARM      TETENR        #KOMTENR
     C                   PARM      'ST'          #KOMAZAR
     C                   PARM      '123456'      #KOMJNUM
     C                   PARM      '   '         #KOMVARK
     C                   PARM      0.00          #KOMMENG
     C                   PARM      0             #KOMBETE
     C                   PARM      0             #KOMGADA
     C                   PARM      '  '          #KOMPEAR

     c*                  move      *on           *inlr

     C* --------------------------------------------------
     C     *inzsr        BEGSR
     C                   ENDSR
