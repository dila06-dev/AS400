     H dftactgrp(*no) actgrp(*caller) expropts(*resdecpos)
     H datfmt(*iso)   timfmt(*iso)    option(*nodebugio)
     *_______________________________________________________________________*/
     * Programmname.: #preisaktr                                             */
     * Funktion.....: ermitteln aktuelle preise in datei                     */
     *                tvrelwaeco/#preisakt                                   */
     *                                                                       */
     *                                                                       */
     * 09/2011        schneider                                              */
     *                                                                       */
     *-Änderungsdienst-------------------------------------------------------*/
     *                                                                       */
     *_______________________________________________________________________*/
     F#preisin  if   e           k disk    rename(preisif:eingabe1)
     Fteil01    if   e           k disk    rename(teil1:eingabe2)
     F#preisakt uf a e           k disk    rename(preisaf:ausgabe)

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
     **#menge          s             10a
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


     // -----------------------------------
     C     *dtaara       define    *lda          extrld
     C                   in        extrld

     *---------------------------------------------------------------
     *  Schlüsselliste
     *---------------------------------------------------------------

     C     key_eingabe2  klist
     C                   kfld                    h#firm
     C                   kfld                    h#tenr

     C     key_ausgabe   klist
     C                   kfld                    h#kdnr
     C                   kfld                    h#tenr

     *---------------------------------------------------------------
     * vorbelegung
     *---------------------------------------------------------------
     C                   eval      h#firm = '01'

     *---------------------------------------------------------------
     * hauptroutine
     *---------------------------------------------------------------
 1b  C                   dow       not %eof(#preisin)
     C                   read      eingabe1
     C                   eval      h#kdnr = prikdnr
     C                   eval      h#tenr = pritenr
     C****               eval      h#datu = pridatum
     C                   movel     pridatum      h#datu
     C                   eval      h#mnge = primenge
     C                   eval      h#menge= primeng
     C                   eval      h#whcd = priwaecd
     C****               eval      h#menge = ' '

     C                   exsr      $verarbeitung

 1e  C                   enddo

     C                   eval      *inlr = *on

     *---------------------------------------------------------------
     *  subroutinen
     *---------------------------------------------------------------
     C     $verarbeitung begsr

 1b  C                   if        h#tenr  = *blanks
 2b  C                   dow       not %eof(teil01)
     C                   read      eingabe2
 3b  C                   if        tetest = '01'
     C                   eval      h#tenr = tetenr
     C                   exsr      $preiserm
     C                   eval      prakdnr   =  p#kdnr
     C                   eval      pratenr   =  p#tenr
     C                   eval      prameng   =  p#meng
     C                   eval      pramenge  =  p#mein
     C*****              eval      pradatum  =  p#date
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
 4b  C                   if        not %found(#preisakt)
     C                   write     ausgabe
 4x  C                   else
     C                   update    ausgabe
 4e  C                   endif
 3e  C                   endif
 2e  C                   enddo
 1x  C                   else
     C                   exsr      $preiserm
     C                   eval      prakdnr   =  p#kdnr
     C                   eval      pratenr   =  p#tenr
     C                   eval      prameng   =  p#meng
     C                   eval      pramenge  =  p#mein
     C*****              eval      pradatum  =  p#date
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
 2b  C                   if        not %found(#preisakt)
     C                   write     ausgabe
 2x  C                   else
     C                   update    ausgabe
 2e  C                   endif
 1e  C                   endif
     C                   endsr

     *---------------------------------------------------------------
     C     $preiserm     begsr
     C                   eval      p#tenr    =  h#tenr
     C                   eval      p#kdnr    =  h#kdnr
     C                   eval      p#meng    =  1
     C****               eval      p#meng    =  h#menge
     C                   eval      p#mein    =  'S'
     C                   eval      p#date    =  h#datu
     C                   eval      p#wacd    =  h#whcd
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
