     H dftactgrp(*no) actgrp(*caller) expropts(*resdecpos)
     H datfmt(*iso)   timfmt(*iso)    option(*nodebugio)
     *_______________________________________________________________________*/
     * Programmname.: #preiaktr2                                             */
     * Funktion.....: ermitteln aktuelle preise in datei                     */
     *                tvrelwaeco/#preisakt                                   */
     *                                                                       */
     *                                                                       */
     * 09/2011        schneider                                              */
     *                                                                       */
     *-Änderungsdienst-------------------------------------------------------*/
     * 11/2011        schneider  abfragen auf bestimmte produktgruppen       */
     *                           im programm                                 */
     * 01/2012        schneider  abfragen auf bestimmte produktgruppen       */
     *                           aus datei #prgr in tvrelwaeco               */
     *                           abfragen von 11/2011 ausgebaut              */
     *_______________________________________________________________________*/
     F#kund_t   if   e             disk    rename(kund1:eingabe1)
     Fkund01    if   e           k disk    rename(kund1:eingabe2)
     Fteil01    if   e           k disk    rename(teil1:eingabe3)
     F                                     usropn
     F#prgr     if   e           k disk    rename(prgrf:vergl1)
     F#preisakt uf a e           k disk    rename(preisaf:ausgabe)


     //--*STAND ALONE-------------------------------------------
     D pdatum          s              8a

     Dtimestamp        s               z   inz(*sys)
     Dtimestamp_a      s             26a
     Ddate_a           s               d
     Dzeit_a           s               t
     Dh#feld           s              1a
     Dh#firm           s              2a
     Dh#tenr           s             15a
     Dh#kdnr           s             10a
     Dh#datu           s              8a
     Dh#mnge           s              1a
     Dh#prgr           s              4a
     Dh#menge          s              9s 3
     Dh#whcd           s              3a
     Dh#prozent        s             30  9
     D p#tenr          s             15a
     D p#kdnr          s             10a
     D p#meng          s              9s 3
     D p#mein          s              1a
     D p#date          s              8a
     D p#wacd          s              3a
     D p#kosc          s              1a
     D p#prei          s             15s 3
     D p#ergb          s             15s 3
     D p#brsu          s             15s 3
     D p#nesu          s             15s 3
     D p#prar          s              3a
     D p#kon1          s              3a
     D p#kow1          s              9s 2
     D p#kon2          s              3a
     D p#kow2          s              9s 2
     Ddate             s               d   datfmt(*iso)
     D datum           s              8s 0 inz(0)

     D kund          e ds                  inz
     D kykund        e ds                  inz
     *
     D teil          e ds                  inz
     D kyteil        e ds                  inz
     *
     D trpa          e ds                  inz
     D kytrpa        e ds                  inz

     D/COPY QCPYSRC,EXTRBR
     D/COPY QCPYSRC,EXTRIN

     D extrld        euds
     D/COPY TAMP/QCPYSRC,EXPSDS


     C     *entry        plist
     C                   parm                    pdatum

     // -----------------------------------
     C     *dtaara       define    *lda          extrld
     C                   in        extrld

     *---------------------------------------------------------------
     *  Schlüsselliste
     *---------------------------------------------------------------

     C     key_eingabe2  klist
     C                   kfld                    h#firm
     C                   kfld                    h#kdnr

     C     key_eingabe3  klist
     C                   kfld                    h#firm
     C                   kfld                    h#tenr

     C     key_ausgabe   klist
     C                   kfld                    h#kdnr
     C                   kfld                    h#tenr

     C     key_vergl     klist
     C                   kfld                    h#prgr

     *---------------------------------------------------------------
     * vorbelegung
     *---------------------------------------------------------------
     C                   eval      h#firm = '01'
     C                   movel     pdatum        datum

     *---------------------------------------------------------------
     * hauptroutine
     *---------------------------------------------------------------
      /free
 1b    if datum = *zeros;
       datum = %uns(%char(%date:*iso0));
 1e    endif;
      /end-free

 1b  C                   dow       not %eof(#kund_t)
     C                   read      eingabe1
 2b  C                   if        kdkdst = '01'
     C                   eval      h#kdnr = kdkdnr
     C                   movel     datum         h#datu

     C                   exsr      $verarbeitung

 2e  C                   endif
 1e  C                   enddo

     C                   eval      *inlr = *on

     *---------------------------------------------------------------
     *  subroutinen
     *---------------------------------------------------------------
     C     $verarbeitung begsr

     C                   open      teil01
 1b  C                   dow       not %eof(teil01)
     C                   read      eingabe3
 2b  C                   if        tetest < '90'
     C                   eval      h#prgr = teprgr
     C     key_vergl     chain     vergl1
 3b  C                   if        not %found(#prgr)
 1i  C                   iter
 3e  C                   endif
     C                   eval      h#tenr = tetenr
     C                   exsr      $preiserm
     C                   eval      prakdnr   =  p#kdnr
     C                   eval      pratenr   =  p#tenr
     C                   eval      prameng   =  p#meng
     C                   eval      pramenge  =  p#mein
     C                   movel     p#date        pradatum
     C                   eval      prawaecd  =  p#wacd
     C                   eval      praprei   =  p#prei
     C                   eval      pranesu   =  p#nesu
     C                   eval      prabegr   =  p#prar
     C                   eval      prakon1   =  p#kon1
     C                   eval      prakow1   =  p#kow1
     C                   eval      prakon2   =  p#kon2
     C                   eval      prakow2   =  p#kow2
     C     key_ausgabe   chain     ausgabe
 3b  C                   if        not %found(#preisakt)
     C                   write     ausgabe
 3x  C                   else
     C                   update    ausgabe
 3e  C                   endif
 2e  C                   endif
 1e  C                   enddo
     C                   close     teil01
     C                   endsr

     *---------------------------------------------------------------
     C     $preiserm     begsr
     C                   eval      p#tenr    =  h#tenr
     C                   eval      p#kdnr    =  h#kdnr
     C                   eval      p#meng    =  1
     C                   eval      p#mein    =  'S'
     C                   eval      p#date    =  h#datu
     C                   eval      p#wacd    =  'EUR'
     C                   eval      p#kosc    =  *blanks
     C                   eval      p#prei    =  *zeros
     C                   eval      p#ergb    =  *zeros
     C                   eval      p#brsu    =  *zeros
     C                   eval      p#nesu    =  *zeros
     C                   eval      p#prar    =  *blanks
     C                   eval      p#kon1    =  *blanks
     C                   eval      p#kow1    =  *zeros
     C                   eval      p#kon2    =  *blanks
     C                   eval      p#kow2    =  *zeros

     C                   call      'PRR070'
     C                   parm                    p#tenr
     C                   parm                    p#kdnr
     C                   parm                    p#meng
     C                   parm                    p#mein
     C                   parm                    p#date
     C                   parm                    p#wacd
     C                   parm                    p#kosc
     C                   parm                    p#prei
     C                   parm                    p#ergb
     C                   parm                    p#brsu
     C                   parm                    p#nesu
     C                   parm                    p#prar
     C                   parm                    p#kon1
     C                   parm                    p#kow1
     C                   parm                    p#kon2
     C                   parm                    p#kow2
     C                   endsr
     *---------------------------------------------------------------
