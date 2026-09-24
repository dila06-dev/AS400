     F************************************************************
     F*  (C) Barenkamp
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*  Einmalige Übergabe der Teledonnummer aus Web in die     *
     F*  die TRPAPF00 schreiben.                                 *
     F************************************************************
     F* APF020            Kundennummer  5 Key                    *
     F* APF230            E-Mail-Priv. 50 Mail für News          *
     F* apf250            PASS         20 Zugang Internet        *
     F* apf270            FREIGA        2 Anzeige Internet       *
     F* apf260            HTYPE         4 Händlertype Air/Web    *
     F* apf080            News          4 Newsletter = Tätigkeit *
     F************************************************************
     F* EMAIL             Text 34       --> AIRCWEB              *
     F* KDNR                    5                                *
     F* PASSW                   6                                *
     F* PUBLIC                  2       Anzeige Internet ja/nein *
     F* STATUS                  1                                *
     F* NEWS                    2                                *
     F************************************************************
     fAIRCWEB2  ip   e             disk
     fTRPAPl99  uf   e           k disk

     c                   movel     KDNR          xxxkd             5 0
     c     xxxkd         chain     trpapl99                           99
     c     *in99         ifeq      *off
     c                   move      *blanks       APF090
     c                   movel     NEWS          APF090
     c                   update    apf00r1
     c                   endif
     c
