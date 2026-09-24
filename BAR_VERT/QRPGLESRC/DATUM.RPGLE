     *****************************************************************
     * ------------------------------------------------------------- *
     *  ! Achtung !! Programm muss wegen der verwendeten APIs        *
     *  erst mit CRTRPGMOD und dann mit CRTRPGPGM ACTGRP(QILE)       *
     *  DFTACTGRP = *NO                                              *
     *  umgewandelt werden !!                                        *
     * ------------------------------------------------------------- *
     *                                                               *
     *****************************************************************
     *                                                               *
     * ------------------------------------------------------------- *
     *         P r o g r a m m   -   B e s c h r e i b u n g         *
     * ------------------------------------------------------------- *
     *                                                               *
     *  Das Programm addiert zu dem im Parameter mitgegebenem Datum  *
     *  ein Jahr in Datei KALENDER hinzu                             *

     *  Eingangsparameter / Rückgabeparameter :                      *
     *
     *  PE#Datum  (6S 0)  -  Datumsfeld Format TTMMJJ
     *                       immer letzter tag des alten jahres
     *
     *  Rückgabeparameter:
     *
     *  PE#Error   (1A)   -  Fehler  ('0' = O.K., '1' = Fehler)
     ****************************************************************
     H datedit(*dmy.)
     H datfmt(*eur.)
     H debug(*yes)
     H decedit('0,')
     H expropts(*maxdigits)
     H option(*showcpy : *nodebugio : *srcstmt)
     H timfmt(*hms)

     Fkalender  uf a e           k disk    rename(kalpf:datei)

     D pe#datum        s              6s 0
     D pe#datum2       s              8s 0
     D pe#tag          s              2a
     D pe#rtncode      s              1a

     D p#datum         s             10a
     D p#datfmt        s             10a   inz('DDMMYY')
     D p#apiparm       s              9b 0
     D p#tagnr         s              9b 0

     D #datumd         s               d
     D #count          s              3s 0


     *=====================================================================
     *    *  *ENTRY - Parameter
     *=====================================================================

     C     *entry        plist
     C                   parm                    pe#datum
     C**                 parm                    pe#datum2
     C**                 parm                    pe#tag
     C**                 parm                    pe#rtncode

     C     key_kal       klist
     C                   kfld                    kaldat1

     *********************************************************************
     *              H  A  U  P  T  V  E  R  A  R  B  E  I  T  U  N  G
     *********************************************************************

     C                   eval      pe#rtncode = '0'
     C                   eval      #count = 1

 1b  C                   dow       #count <> 366

     * Datum auf Gültigkeit prüfen

     C     *dmy          test(d)                 pe#datum               rt

 2b  C                   if        *inrt
     C                   eval      pe#rtncode = '1'
 1v  C                   leave
 2e  C                   endif

     C     *dmy          move      pe#datum      #datumd
     c                   adddur    01:*d         #datumd
     C     *dmy          move      #datumd       pe#datum
     C                   movel     pe#datum      p#datum

     C                   callb(d)  'CEEDAYS'
     C                   parm                    p#datum
     C                   parm                    p#datfmt
     C                   parm                    p#apiparm
     C                   parm                    *omit

     C                   callb(d)  'CEEDYWK'
     C                   parm                    p#apiparm
     C                   parm                    p#tagnr
     C                   parm                    *omit

     * neuer Tag ist Samstag

 2b  C                   if        p#tagnr = 7
     ***                adddur    2:*d          #datumd
 2e  C                   endif

     * neuer Tag ist Sonntag

 2b  C                   if        p#tagnr = 1
     C***                adddur    1:*d          #datumd
 2e  C                   endif

     * wochentag ermitteln
 2b  C                   select
 2x  C                   when      p#tagnr = 1
     C                   eval      pe#tag   = 'SO'
 2x  C                   when      p#tagnr = 2
     C                   eval      pe#tag   = 'MO'
 2x  C                   when      p#tagnr = 3
     C                   eval      pe#tag   = 'DI'
 2x  C                   when      p#tagnr = 4
     C                   eval      pe#tag   = 'MI'
 2x  C                   when      p#tagnr = 5
     C                   eval      pe#tag   = 'DO'
 2x  C                   when      p#tagnr = 6
     C                   eval      pe#tag   = 'FR'
 2x  C                   when      p#tagnr = 7
     C                   eval      pe#tag   = 'SA'
 2e  C                   endsl

     C     *dmy          move      #datumd       pe#datum
     C     *iso          move      #datumd       pe#datum2

     C                   eval      #count = #count +1

     C                   eval      kaldat1 = pe#datum2
     C     key_kal       chain     datei
 2b  C                   if        not %found(kalender)
     C                   eval      kaldat2 = pe#datum
     C                   eval      kalwotag = pe#tag
     C                   write     datei
 2e  C                   endif

 1e  C                   enddo

     C                   eval      *inlr = *on
