     F#prtmsgd  if   e             disk
     F#dspmsgd  if a e           k disk
     F#cvtmsgd  uf a e           k disk
     D klein           C                   CONST('abcdefghijklmnopqrstuvwxyzäöü-
     D                                            ß')
     D gross           C                   CONST('ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜ-
     D                                            ß')
     D systxt          C                   CONST('5769SS1')
     D nactxt          C                   CONST('Nachrichtendatei')
     D nidtxt          C                   CONST('Anfangsnachricht')
     D nacknz          C                   CONST('Nachricht . . . :')
     D bewert          C                   CONST('Bewertung')
     c                   movel     *blank        orgnid            7
     c                   move      *off          *in20
     C     loop          tag
     C                   move      *off          *in80
     C                   read      #prtmsgr                               80
     C     *in80         ifeq      *on
     C                   goto      #end
     C                   end
     c                   z-add     0             pos               3 0
     c     systxt        scan      inhalt        pos
     c     pos           ifgt      0
     c                   goto      loop
     c                   end
     c                   z-add     0             pos               3 0
     c     nidtxt        scan      inhalt        pos
     c     pos           ifgt      0
     c                   goto      loop
     c                   end
     c     orgnid        ifeq      *blank
     c                   move      *off          *in20
     c                   if        %subst(inhalt:2:2) <> '  ' and
     c                             %subst(inhalt:9:12) = '            '
     c                   eval      orgnid = %subst(inhalt:2:7)
     c                   move      *on           *in20
     c                   goto      loop
     c                   endif
     c                   endif
     c                   z-add     0             pos               3 0
     c     bewert        scan      inhalt        pos
     c     pos           ifgt      0
     c                   if        %subst(inhalt:52:3) = 'SEV'
     c                   move      *blank        orgnid
     c                   move      *off          *in20
     c                   goto      loop
     c                   endif
     c                   endif
     c     *in20         ifeq      *off
     c                   goto      loop
     c                   endif
     c                   movel     *blank        #msgtxt
     c                   movel     orgnid        #msgid
     c                   z-add     0             pos               3 0
     c     nacknz        scan      inhalt        pos
     c     pos           ifgt      0
     c                   eval      #msgtxt = %trim(%subst(inhalt:21:112))
     c                   else
     c                   eval      #msgtxt = %trim(inhalt)
     c                   end
     c     klein:gross   xlate     #msgtxt       #msgtxt
     c                   write     #dspmsgr
     c                   goto      loop
     c     #end          tag
     c     *loval        setll     #dspmsgd
     c     #lm000        tag
     c                   move      *off          *in80
     c                   read      #dspmsgr                               80
     c     *in80         ifeq      *on
     c                   move      *on           *inlr
     c                   goto      #aus
     c                   end
     c                   movel     #msgid        msgid
     c                   move      *blank        msgtxt
     c     msgid         chain     #cvtmsgd                           82
     c     *in82         ifeq      *on
     c                   eval      msgtxt = %trim(#msgtxt)
     c                   write     #cvtmsgr                             99
     c                   else
     c                   eval      msgtxt = %trim(msgtxt) + %trim(#msgtxt)
     c                   update    #cvtmsgr
     c                   end
     c                   goto      #lm000
     c     #aus          tag
