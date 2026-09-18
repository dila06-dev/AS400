     * H dftactgrp(*no) actgrp(*caller) expropts(*resdecpos)
     H datfmt(*iso)   timfmt(*iso)    option(*nodebugio)
     *_______________________________________________________________________*/
     * Programmname.: #TRDCGP1R                                              */
     * Funktion.....: hilfprogramm zur aktualisierung datei                  */
     *                tvrelwaeco/#trdcgp1                                    */
     *                ermitteln %faktoren                                    */
     *                                                                       */
     * 09/2011        schneider                                              */
     *                                                                       */
     *-Änderungsdienst-------------------------------------------------------*/
     *                                                                       */
     *_______________________________________________________________________*/
     F#trdcgp1  uf a e             disk    rename(#trdcgp1:eingabe)

     Dtimestamp        s               z   inz(*sys)
     Dtimestamp_a      s             26a
     Ddate_a           s               d
     Dzeit_a           s               t
     Dh#feld           s              1a
     Dh#prozent        s             30  9

     D extrld        euds
     D/COPY TAMP/QCPYSRC,EXPSDS


     // -----------------------------------
     C     *dtaara       define    *lda          extrld
     C                   in        extrld

     *  Schlüsselliste

     * vorbelegung

     * hauptroutine
 1b  C                   dow       not %eof(#trdcgp1)
     C                   read      eingabe

     C                   exsr      $verarbeitung

 1e  C                   enddo

     C                   eval      *inlr = *on

     *  subroutinen

     *---------------------------------------------------------------

     *---------------------------------------------------------------
     C     $verarbeitung begsr

 1b  C                   if        evp_aj <> *zeros
     C                   clear                   prozent
     C                   eval(h)   h#prozent = 100-((prezpr*100)/evp_aj)
     C                   eval(h)   prozent = h#prozent
     C                   update    eingabe                              RT
 1e  C                   endif
     C                   endsr

     *---------------------------------------------------------------

