     H dftactgrp(*no) actgrp(*caller) expropts(*resdecpos)
     H datfmt(*iso)   timfmt(*iso)    option(*nodebugio)
     H bnddir('QC2LE')
     *_______________________________________________________________________*/
     * Programmname.: #kalenderr                                             */
     * Funktion.....: anzeigen dateiinhalt von bar_vert/kalender             */
     *                in subfile bar_vert/kalendersf                         */
     *                parameter 'N' setzt nicht auf tagesdatum auf,          */
     *                sondern auf beginn der datei.                          */
     *                                                                       */
     * 10/2011        schneider                                              */
     *                                                                       */
     *-Änderungsdienst-------------------------------------------------------*/
     *                                                                       */
     *_______________________________________________________________________*/

     Fkalendern if   e           k disk

     Fkalende_sfcf   e             workstn sfile(kalend2sf: rrn)

     D #firma          s              2a

     D #timeexv        s              4a
     D #timeinv        s              4a
     D #timewov        s              4a

     D #timeexvi       s              4a
     D #timeinvi       s              4a
     D #timeiwoi       s              4a

     D #datvor         s              1a

     D #location       s              3a

     D sortds          pr                  extproc('qsort')
     D   datatosort                        like(subfiledata)
     D   elements                    10u 0 value
     D   size                        10u 0 value
     D   sortfunct                     *   procptr value

     D high            c                   1
     D low             c                   -1
     D equal           c                   0

     D datumsort       pr            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

     D rgsort          pr            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

     D rgtagsort       pr            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

     D loadarray       pr            10i 0
     D displaysubfile  pr
     D clearsubfile    pr
     D loadsubfile     pr
     D   recordcount                 10i 0


     D subfiledata     ds                  qualified
     D    subfilerec                       likerec(kalend2sf: *output) dim(4000)

     D count           s             10i 0 inz(0)
     D rrn             s             10i 0 inz(0)
     Ddate             s               d   datfmt(*iso)
     D datum           s              8s 0 inz(0)

     D sortroutine     s               *   procptr
     D sortdatum       s               *   procptr inz(%paddr(datumsort))
     D sortrg          s               *   procptr inz(%paddr(rgsort))
     D sortrgtag       s               *   procptr inz(%paddr(rgtagsort))

     D exit            c                   3
     D sortdatums      c                   5
     D sortrgs         c                   6
     D sorttags        c                   7

     D sfldspctl       c                   90
     D sflclear        c                   91
     D sfldsp          c                   92

     C     *entry        plist
     C                   parm                    #firma
     C                   parm                    #timeexv
     C                   parm                    #timeinv
     C                   parm                    #timewov
     C                   parm                    #datvor
     C                   parm                    #location

     C                   time                    date

     C     key_datum     klist
     C                   kfld                    #firma
     C                   kfld                    datum

     C                   eval      timeinv = #timeinv
     C                   eval      timeexv = #timeexv
     C                   eval      timewov = #timewov
     C                   eval      kalfirms= #firma
     C                   eval      kalloks = #location

     *___hauptroutine beginn_________________________________________________*/

     * firmennummer holen
     C                   call      'DOWR000'
     C                   parm                    #location
     C                   parm                    #firma

     C                   eval      kalfirms= #firma
     C                   eval      kalloks = #location
      /free

       datum = %uns(%char(%date:*iso0));

       count = loadarray();

 1b    dou *in(exit);

           loadsubfile(count);

           displaysubfile();

 2b        select;

 2x          when *in(sortdatums);
               sortroutine = sortdatum;

 2x          when *in(sortrgs);
               sortroutine = sortrg;

 2x          when *in(sorttags);
               sortroutine = sortrgtag;

 2x          other;
               sortroutine = sortdatum;

 2e        endsl;

                 sortds(subfiledata:
                        count:
                        %size(subfiledata.subfilerec):
                        sortroutine);

           clearsubfile();

 1e    enddo;

       *inlr = *on;

      /end-free
     *__hauptroutine ende____________________________________________________*/

     *__bereich pozeduren_*************************************************__*/

     *__beginn loadarray_____________________________________________________*/
     P loadarray       b
     D                 pi            10i 0

     D n               s             10i 0

      /free

 1b       if #datvor = 'N';
           eval datum = *zeros;
 1e       endif;

        setll key_datum kalpf;

 1b     dou %eof(kalendern);

          read kalpf;

 2b       if not %eof(kalendern) and kalfirm = #firma;

            n +=1;

            subfiledata.subfilerec(n).kaldat1    = kaldat1;
            subfiledata.subfilerec(n).kalwotag   = kalwotag;
            subfiledata.subfilerec(n).kalrgzeit  = kalrgzeit;
            subfiledata.subfilerec(n).kalrgzeite = kalrgzeite;
            subfiledata.subfilerec(n).kalrgzeiti = kalrgzeiti;
            subfiledata.subfilerec(n).kalfirms   = kalfirms;
            subfiledata.subfilerec(n).kalbandi   = kalbandi;
            subfiledata.subfilerec(n).kalbands   = kalbands;
            subfiledata.subfilerec(n).kalrgpara  = kalrgpara;
            subfiledata.subfilerec(n).kalsich    = kalsich;

 2e       endif;

 1e     enddo;

        return n;

       /end-free

     P loadarray       e
     *__ende loadarray_______________________________________________________*/

     *__beginn displaysubfile________________________________________________*/
     P displaysubfile  b
     D                 pi

      /free

         *in(sflclear) = *off;
         *in(sfldspctl) = *on;
         *in(sfldsp) = *on;

         write keys;

         exfmt kalend2ctl;

         return;

      /end-free

     P displaysubfile  e
     *__ende displaysubfile__________________________________________________*/

     *__beginn loadsubfile___________________________________________________*/
     P loadsubfile     b
     D                 pi
     D   recordcount                 10i 0

     D i               s             10i 0

      /free

 1b     for rrn = 1 to recordcount;

            write kalend2sf subfiledata.subfilerec(rrn);

 1e     endfor;

      /end-free

     P loadsubfile     e
     *__ende loadsubfile_____________________________________________________*/

     *__beginn clearsubfile__________________________________________________*/
     P clearsubfile    b
     D                 pi
      /free

        *in(sflclear) = *on;
        *in(sfldspctl) = *off;
        *in(sfldsp) = *off;

        write kalend2ctl;

        return;

      /end-free

     P clearsubfile    e
     *__ende clear subfile___________________________________________________*/

     *__beginn datumsort_____________________________________________________*/
     P datumsort       b
     D                 pi            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

      /free

 1b      select;
 1x        when element1.kaldat1 > element2.kaldat1;
              return high;
 1x        when element1.kaldat1 < element2.kaldat1;
              return low;
 1x        other;
              return equal;
 1e      endsl;

      /end-free

     P datumsort       e
     *__ende datumsort_______________________________________________________*/

     *__beginn rgsort________________________________________________________*/
     P rgsort          b

     D                 pi            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

      /free

 1b      select;
 1x        when element1.kalrgpara > element2.kalrgpara;
              return low;
 1x        when element1.kalrgpara < element2.kalrgpara;
              return high;
 1x        other;
              return equal;

 1e      endsl;

      /end-free

     P rgsort          e
     *__ende rgsort__________________________________________________________*/

     *__beginn rgtagsort_____________________________________________________*/
     P rgtagsort       b

     D                 pi            10i 0
     D   element1                          likerec(kalend2sf: *output)
     D   element2                          likerec(kalend2sf: *output)

      /free

 1b      select;
 1x        when element1.kalwotag > element2.kalwotag;
              return low;
 1x        when element1.kalwotag < element2.kalwotag;
              return high;
 1x        other;
              return equal;

 1e      endsl;

      /end-free

     P rgtagsort       e
     *__ende rgtagsort_______________________________________________________*/

