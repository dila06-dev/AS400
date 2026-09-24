     ******************************************************************

     d p00010        e ds                  extname(frdgp1)
     d                                     prefix(g)
      /space 2
      * Gefahrgutpositionen erzeugen        */
      /space 1
     c     d10           begsr
     c                   clear                   p00010
     c                   eval      gfir   = cfir
      * ==>              eval      Sfelder = Trend Inhalte


























     c                   eval      gsts   = 'A'
     c                   eval      xsoa   = 'W '
     c                   call      'VSE51      '
     c                   parm                    xs
     c                   parm                    p00010
     c                   endsr
