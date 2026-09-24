      /TITLE Kundenstammdaten Trend laden
     h  option(*SRCSTMT:*NoDebugIO)
      * Copyright
     **** /copy rpg_cpr
     fKund01    if   e           k disk
      /copy yqrpglesrc,eqsrpgiys
      /space 2
     d p00001        e ds                  extname(frdtn1a)
     d                                     prefix(r)
      /space 1
      * Main
      /space 1
     c     *entry        plist
     c                   parm                    ys
     c                   parm                    p00001
     c* Open
     c     *in01         ifeq      '0'
     c                   exsr      o
     c                   movel     '1'           *in01
     c                   endif
     c* Close
     c* Detail
     c                   exsr      d
     c                   return
      /space 2
      * Open
      /space 1
     c     o             begsr
     c                   exsr      sinz
     c                   endsr
      /space 3
      * Detail
      /space 1
     c     d             begsr
     c                   movel     nein          ysds
     c                   exsr      d10
     c                   endsr
      /space 2
      * Adresse in Trend lesen
      /space 1
     c     d10           begsr
     c     k_kund01      klist
     c                   kfld                    #rfir
     c                   kfld                    #rlkdnr
     c                   movel     rfir          #rfir             2
     c                   movel     rlkdnr        #rlkdnr          10
     c     k_kund01      chain     kund01
     c                   IF        %found(kund01)
     c                   exsr      d110
     c                   eval       ysds  = ja
     c                   endif
     c* Wenn Datensatz gefunden, dann
     c                   endsr
      /space 2
      * Felder FRDTN füllen
      /space 1
     c     d110          begsr
     c                   eval      rbtnr  =    *blanks
     c******                       Anrede
     c                   eval      rlnam0 =    *blank
     c                   eval      rlnam1 =    KDNAM1
     c                   eval      rlnam2 =    KDNAM2
     c                   eval      rlnam3 =    KDNAM3
     c*******            eval      rlnam4 = alnam4
     c                   eval      rlstr  =    KDSTRA
     c                   eval      rlplz  =    kdPOLZ
     c                   eval      rplz   =    KDPOLZ
     c                   eval      rlkz   =    KDPOLD
     c                   eval      rort   =    KDWORT
     c                   endsr
      /copy yqrpglesrc,eqsrpgcsin
