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
     *                                                                       */
     *_______________________________________________________________________*/
     F#kund_t   if   e             disk    rename(kund1:eingabe1)
     Fkund01    if   e           k disk    rename(kund1:eingabe2)
     Fteil01    if   e           k disk    rename(teil1:eingabe3)
     F                                     usropn
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
     *#menge          s             10a
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
     C                   parm                    pdatum            8

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

     *---------------------------------------------------------------
     * vorbelegung
     *---------------------------------------------------------------
     C                   eval      h#firm = '01'
     c                   movel     pdatum        datum

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
 2b  C                   if        kdkdst < '80'
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
 2b  C                   if        tetest = '01'
     C                   if        teprgr = '208'or
     C                             teprgr = '210'or
     C                             teprgr = '299'or
     C                             teprgr = '303'or
     C                             teprgr = '305'or
     C                             teprgr = '306'or
     C                             teprgr = '307'or
     C                             teprgr = '308'or
     C                             teprgr = '313'or
     C                             teprgr = '314'or
     C                             teprgr = '316'or
     C                             teprgr = '317'or
     C                             teprgr = '318'or
     C                             teprgr = '319'or
     C                             teprgr = '320'or
     C                             teprgr = '323'or
     C                             teprgr = '328'or
     C                             teprgr = '329'or
     C                             teprgr = '330'or
     C                             teprgr = '331'or
     C                             teprgr = '332'or
     C                             teprgr = '333'or
     C                             teprgr = '334'or
     C                             teprgr = '335'or
     C                             teprgr = '336'or
     C                             teprgr = '337'or
     C                             teprgr = '338'or
     C                             teprgr = '339'or
     C                             teprgr = '342'or
     C                             teprgr = '399'or
     C                             teprgr = '401'or
     C                             teprgr = '402'or
     C                             teprgr = '405'or
     C                             teprgr = '406'or
     C                             teprgr = '407'or
     C                             teprgr = '408'or
     C                             teprgr = '410'or
     C                             teprgr = '411'or
     C                             teprgr = '412'or
     C                             teprgr = '413'or
     C                             teprgr = '415'or
     C                             teprgr = '421'or
     C                             teprgr = '424'or
     C                             teprgr = '427'or
     C                             teprgr = '428'or
     C                             teprgr = '429'or
     C                             teprgr = '499'or
     C                             teprgr = '701'or
     C                             teprgr = '703'or
     C                             teprgr = '704'
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
 4b  C                   if        not %found(#preisakt)
     C                   write     ausgabe
 4x  C                   else
     C                   update    ausgabe
 4e  C                   endif
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
