     H dftactgrp(*no) actgrp(*caller) expropts(*resdecpos)
     H datfmt(*iso)   timfmt(*iso)    option(*nodebugio)
     H decedit('0,') datedit(*dmy.)
     H copyright('(C) Copyright trend SWM Verwaltung GmbH - 2000')
     **************************************************************************
     H/TITLE  Ermitteln/ Berechnen Preis/Kondition
     **************************************************************************
     *  Copyright 2000 by    trend SWM
     *                       Verwaltungs GmbH
     *                       Ziegelhofstraße 210a
     *                       DE 79110 Freiburg
     *  -----------------------------------------------------------------------
     *  Erstellt: RE 18.12.2000
     *  -----------------------------------------------------------------------
     *  Änderung: RE 28.03.2002 Stada Projekt 1185
     *            Ermitteln Preise/Konditionen mit Vertriebslinie
     *            neues KZ in Datei KBST Key-Bestückung
     *  Änderung: MG 18.06.2009 Burton Erw. des Feldes EXKOSCGWBR auf 13,4
     *  Änderung: AL 27.11.2009 Projekt 3267 Ersetzen *DATE durch WKTDAT
     *  Änderung: RE 24.11.2010 MOTIP Projekt 6831
     *                          WAECO Projekt 6944
     *            Übergabe Auftraggeber-Kunden-Nr, Verband-Kunden-Nr und
     *            Preis-Version und Sortiment an ERPRKO
     *  Änderung: schneider 9/11 Anpassung an WAECO
     *            vorbelegung menge mit 1 fix
     **************************************************************************
     *
     *

     //--*STAND ALONE-------------------------------------------
     D ##chi           s            + 7    like(wkc001)
     D ##pgst          s                   like(wkc001)
     D ##rtcd          s                   like(wkc001)
     D exprko02brsu    s                   like(dun153)
     D exprko02date    s                   like(dun080)
     D exprko02ergb    s                   like(dun153)
     D exprko02kdnr    s                   like(duc010)
     D exprko02kosc    s                   like(duc001)
     D exprko02mein    s                   like(duc001)
     D exprko02meng    s                   like(dun153)
     D exprko02nesu    s                   like(dun153)
     D exprko02prei    s                   like(dun153)
     D exprko02tenr    s                   like(tetenr)
     D exprko02prar    s                   like(exkondprar)
     D exprko02kon1    s                   like(exkondkon1)
     D exprko02kow1    s                   like(exkondkow1)
     D exprko02kon2    s                   like(exkondkon2)
     D exprko02kow2    s                   like(exkondkow2)

     D exprko02wacd    s                   like(duc003)
     D pcpgst          s            + 5    like(wkc001)
     D wkc001          s              1a
     D wkfenr          s            + 3    like(wkc001)
     D wkifmt          s                   like(wkc001)
     D wki000          s                   like(wkc001)
     D wkn010          s              1p 0
     D wkrtcd          s                   like(wkc001)
     D wktrpa          s                   like(wkc001)
     D wktrpakdzr      s                   like(wkc001)
     D wkvbkd          s                   like(duc010)

     **************************************************************************
     ***  T A B E L L E N   U N D   F E L D G R U P P E N                   ***
     **************************************************************************
     D/COPY QCPYSRC,EXTRBR
     *
     **************************************************************************
     ***  DATEIEN                                                           ***
     **************************************************************************
     D kund          e ds                  inz
     D kykund        e ds                  inz
     *
     D teil          e ds                  inz
     D kyteil        e ds                  inz
     *
     D trpa          e ds                  inz
     D kytrpa        e ds                  inz
     *
     **************************************************************************
     ***  INTERNE DATENSTRUKTUR                                             ***
     **************************************************************************
     D/COPY QCPYSRC,EXTRIN
     *
     D  wktdat         s               d   datfmt(*iso) inz
     *
     **************************************************************************
     ***  KOMMUNIKATIONSPARAMETER                                           ***
     **************************************************************************
     D extr01        e ds                  inz
     D extr02        e ds                  inz
     *
     D exprko01      e ds                  inz
     D rtprko01      e ds                  inz
     *
     D exkond        e ds                  inz
     D rtkond        e ds                  inz
     *
     D exkser        e ds                  inz
     D rtkser        e ds                  inz
     *
     D exkosc        e ds                  inz
     D rtkosc        e ds                  inz
     *
     D exkdzr        e ds                  inz
     D rtkdzr        e ds                  inz
     *
     **************************************************************************
     ***  DATENSTATIONSARBEITSBEREICH                                       ***
     **************************************************************************
     D extrld        euds
     *
     **************************************************************************
     ***  R E C H E N B E S T I M M U N G E N                               ***
     **************************************************************************
     C     *entry        plist
     C                   parm                    exprko02tenr
     C                   parm                    exprko02kdnr
     C                   parm                    exprko02meng
     C                   parm                    exprko02mein
     C                   parm                    exprko02date
     C                   parm                    exprko02wacd
     C                   parm                    exprko02kosc
     C                   parm                    exprko02prei
     C                   parm                    exprko02ergb
     C                   parm                    exprko02brsu
     C                   parm                    exprko02nesu
     C                   parm                    exprko02prar
     C                   parm                    exprko02kon1
     C                   parm                    exprko02kow1
     C                   parm                    exprko02kon2
     C                   parm                    exprko02kow2
     *-------------------------------------------------------------------------
     C                   exsr      uebkom
     *-------------------------------------------------------------------------
 1b  C     wki000        casne     *on           anfang
 1e  C                   endcs
     *-------------------------------------------------------------------------
     C     *dtaara       define    *lda          extrld
     C                   in        extrld
     *-------------------------------------------------------------------------
     C                   exsr      vorlauf
     **************************************************************************
     ***  P R O G R A M M S T E U E R U N G                                 ***
     **************************************************************************
     C                   movel     exprko02kdnr  kykdnr
     C                   movea     '01C     '    chi
     C                   exsr      chkund
     *-------------------------------------------------------------------------
     C                   eval      wkvbkd = kdvbkd
     *
 1b  C                   if        wktrpakdzr = *on
     C                   exsr      trkdzr
     *
 2b  C                   if        rtkdzrfenr = *zero  and
     C                             rtkdzrvbkd <> *blank
     C                   eval      wkvbkd = rtkdzrvbkd
 2e  C                   endif
 1e  C                   endif
     *-------------------------------------------------------------------------
 1b  C                   if        kdkokd <> exprko02kdnr  and
     C                             kdkokd <> *blank
     C                   eval      kykdnr = kdkokd
     C                   movea     '01C     '    chi
     C                   exsr      chkund
 1e  C                   endif
     *-------------------------------------------------------------------------
     C                   eval      kytenr = exprko02tenr
     C                   movea     '01C     '    chi
     C                   exsr      chteil
     *-------------------------------------------------------------------------
     C                   clear                   exprko01
     C                   clear                   rtprko01
     C                   eval      exprkovpkz = 'V'
     C                   eval      exprkokdnr = kdkdnr
     C                   movel     exprko02kdnr  exprkoagkd
     C                   eval      exprkotenr = exprko02tenr
     C                   eval      exprkomeng = 1
     c*****              eval      exprkomeng = exprko02meng
     C                   movel     exprko02mein  exprkomein
 1b  C                   if        exprkomein = *blank
     C                   eval      exprkomein = temevk
 1e  C                   endif
     C                   movel     exprko02date  exprkodate
     C                   movel     exprko02wacd  exprkowacd
 1b  C                   if        exprkowacd = *blank
     C                   eval      exprkowacd = kdwacd
 1e  C                   endif
     C                   eval      exprkopsli = kdpsli
     C                   eval      exprkoland = kdland
     C                   eval      exprkovkgb = kdvkgb
     C                   eval      exprkokdgr = kdkdgr
     C                   eval      exprkopolz = kdpolz
     *
     C                   eval      exprkoprgr = teprgr
     C                   eval      exprkomagr = temagr
     C                   eval      exprkovtli = tevtli
     *
     C                   call      'ERPRKO'
     C                   parm                    exprko01
     C                   parm                    rtprko01
     *-------------------------------------------------------------------------
     C                   clear                   exkond
     C                   clear                   rtkond
     C                   eval      exkondvpkz = 'V'
     C                   eval      exkondtenr = exprkotenr
     C                   eval      exkondmeng = exprkomeng
     C                   eval      exkondmein = exprkomein
     C                   eval      exkondmepr = rtprkomepr
     C                   eval      exkondwacd = exprkowacd
     C                   eval      exkondprar = rtprkoprar
     C                   eval      exprko02prar = rtprkoprar
     C                   eval      exkondprei = rtprkoprei
     C                   eval      exkondpdim = rtprkopdim
     C                   eval      exkondkon1 = rtprkokon1
     C                   eval      exprko02kon1 = rtprkokon1
     C                   eval      exkondkow1 = rtprkokow1
     C                   eval      exprko02kow1 = rtprkokow1
     C                   eval      exkondprz1 = rtprkoprz1
     C                   eval      exkondpdi1 = rtprkopdi1
     C                   eval      exkondbas1 = rtprkobas1
     C                   eval      exkondkon2 = rtprkokon2
     C                   eval      exprko02kon2 = rtprkokon2
     C                   eval      exkondkow2 = rtprkokow2
     C                   eval      exprko02kow2 = rtprkokow2
     C                   eval      exkondprz2 = rtprkoprz2
     C                   eval      exkondpdi2 = rtprkopdi2
     C                   eval      exkondbas2 = rtprkobas2
     C                   eval      exkondkon3 = rtprkokon3
     C                   eval      exkondkow3 = rtprkokow3
     C                   eval      exkondprz3 = rtprkoprz3
     C                   eval      exkondpdi3 = rtprkopdi3
     C                   eval      exkondbas3 = rtprkobas3
     C                   eval      exkondkon4 = rtprkokon4
     C                   eval      exkondkow4 = rtprkokow4
     C                   eval      exkondprz4 = rtprkoprz4
     C                   eval      exkondpdi4 = rtprkopdi4
     C                   eval      exkondbas4 = rtprkobas4
     C                   eval      exkondpgst = 'BRPRKO'
     C                   call      'BRPRKO'                             99
     C                   parm                    exkond
     C                   parm                    rtkond
     *-------------------------------------------------------------------------
 1b  C                   if        exprko02kosc = *on
     *-------------------------------------------------------------------------
     C                   clear                   exkser
     C                   clear                   rtkser
     C                   eval      exkservpkz = 'V'
     C                   eval      exkserkdnr = kdkdnr
     C                   eval      exkserland = kdland
     C                   eval      exkservkgb = kdvkgb
     C                   eval      exkserkdgr = kdkdgr
     C                   eval      exkserpolz = kdpolz
     C                   eval      exkserwacd = kdwacd
     C                   eval      exkserlibd = kdlibd
     C                   eval      exkserdate = exprkodate
     C                   eval      exksermeng = exprkomeng
 2b  C                   if        rtprkoafkz = dajnkz
     C                   z-add     rtkondnesu    exkserafwt
 2e  C                   endif
 2b  C                   if        rtprkobokz = dajnkz
     C                   z-add     rtkondnesu    exkserrbba
 2e  C                   endif
     *
     C                   call      'ERKSER'                             99
     C                   parm                    exkser
     C                   parm                    rtkser
     *-------------------------------------------------------------------------
     C                   clear                   exkosc
     C                   clear                   rtkosc
     C                   eval      exkoscvpkz = 'V'
     C                   eval      exkoscwacd = kdwacd
     C                   eval      exkosckon1 = rtkserkon1
     C                   eval      exkosckow1 = rtkserkow1
     C                   eval      exkoscprz1 = rtkserprz1
     C                   eval      exkoscbas1 = rtkserbas1
     C                   eval      exkosckon2 = rtkserkon2
     C                   eval      exkosckow2 = rtkserkow2
     C                   eval      exkoscprz2 = rtkserprz2
     C                   eval      exkoscbas2 = rtkserbas2
     C                   eval      exkosckon3 = rtkserkon3
     C                   eval      exkosckow3 = rtkserkow3
     C                   eval      exkoscprz3 = rtkserprz3
     C                   eval      exkoscbas3 = rtkserbas3
     C                   eval      exkosckon4 = rtkserkon4
     C                   eval      exkosckow4 = rtkserkow4
     C                   eval      exkoscprz4 = rtkserprz4
     C                   eval      exkoscbas4 = rtkserbas4
     C                   z-add     rtkondnesu    exkoscwtnt
 2b  C                   if        rtprkoafkz = dajnkz
     C                   z-add     rtkondnesu    exkoscrbba
 2e  C                   endif
     *
     C                   call      'BRKOSC'                             99
     C                   parm                    exkosc
     C                   parm                    rtkosc
     *-------------------------------------------------------------------------
 1e  C                   endif
     *-------------------------------------------------------------------------
     C                   exsr      nachlauf
     *-------------------------------------------------------------------------
     C                   return
     **************************************************************************
     ***  UEBERNAHME KOM-BEREICH                                            ***
     **************************************************************************
     C     uebkom        begsr
     *
     *-------------------------------------------------------------------------
     C                   eval      pcpgst = exprkopgst
     *-------------------------------------------------------------------------
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  EROEFFNUNGSZYKLUS                                                 ***
     **************************************************************************
     C     anfang        begsr
     *
     C                   eval      wki000 = *on
     *-------------------------------------------------------------------------
     C                   eval      wkc001 = *blanks
     C                   eval      wkn010 = *zeros
     *-------------------------------------------------------------------------
     C                   eval      kykdfi = dafirm
     C                   eval      kytefi = dafirm
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  VORLAUF                                                           ***
     **************************************************************************
     C     vorlauf       begsr
     *
     *-------------------------------------------------------------------------
     C                   test(d)                 exprko02date           99
     *-------------------------------------------------------------------------
 1b  C                   if        *in99  or
     C                             exprko02date <= *zero
     C                   time                    dun120
     C                   move      dun120        dun060
     C     *jobrun       move      dun060        wktdat
     ********           eval      exprko02date = wktdat
     C                   movel     wktdat        exprko02date
 1e  C                   endif
     *-------------------------------------------------------------------------
     C                   eval      kytafi = dafirm
     C                   eval      kytata = 'TREND'
     C                   eval      kytatc = 'KDZR'
     C                   eval      kytapa = 'KDZR'
     C                   movea     '01C     '    chi
     C                   exsr      chtrpa
     C                   movel(p)  tapcde        wktrpakdzr
 1b  C                   if        wktrpakdzr = *blank
     C                   eval      wktrpakdzr = *off
 1e  C                   endif
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  NACHLAUFROUTINE                                                   ***
     **************************************************************************
     C     nachlauf      begsr
     *
     *-------------------------------------------------------------------------
     c********           if        exprko02meng <> *zero
 1b  C                   if        exprkomeng   <> *zero
     c***  rtkondergb    div(h)    exprko02meng  exprko02prei
     C     rtkondergb    div(h)    exprkomeng    exprko02prei
 1x  C                   else
     C                   z-add(h)  rtprkoprei    exprko02prei
 1e  C                   endif
     *
     C                   z-add(h)  rtkondergb    exprko02ergb
     C
 1b  C                   if        exprko02kosc = *on
     C                   z-add(h)  rtkoscbrsu    exprko02brsu
     C                   z-add(h)  rtkoscnesu    exprko02nesu
 1x  C                   else
     C                   z-add(h)  rtkondnesu    exprko02brsu
     C                   z-add(h)  rtkondnesu    exprko02nesu
 1e  C                   endif
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  VERWALTEN KD-AUFTRAGS-ZENTRALREGULIERUNG                          ***
     **************************************************************************
     C     trkdzr        begsr
     *
     *-------------------------------------------------------------------------
     C                   clear                   exkdzr
     C                   clear                   rtkdzr
     C                   eval      exkdzrpgst = 'PRUEFE'
     C                   eval      exkdzrkdnr = kdkdnr
     *
     C                   call      'TRKDZR'
     C                   parm                    exkdzr
     C                   parm                    rtkdzr
     *-------------------------------------------------------------------------
     C                   eval      wkfenr = rtkdzrfenr
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  DEFINITION DER WORKFELDER                                         ***
     **************************************************************************
     C     vlike         begsr
     *
     *-------------------------------------------------------------------------
     *--------------------------------------------------------
     *-------------------------------------------------------------------------
     *-------------------------------------------------------------------------
     *
     C                   endsr
     **************************************************************************
     ***  C O P Y - M O D U L E                                             ***
     **************************************************************************
     C/COPY QCPYSRC,CHKUND
     C/COPY QCPYSRC,CHTEIL
     C/COPY QCPYSRC,CHTRPA
     C/COPY QCPYSRC,TRDAUM
     **************************************************************************
     ***  E N D E    D E S    P R O G R A M M S                             ***
     **************************************************************************
