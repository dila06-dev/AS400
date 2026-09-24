      /TITLE DWE Frachtdatensatz aus Trend laden
     h  option(*SRCSTMT:*NoDebugIO)
      * Copyright
     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*      Änderungsdienst                                     *
     F*MG001 19.01.2015                                          *
     F*      bislang wurde ein FRDTN-Satz generiert              *
     F*      daher Abfrage Fehlercode (bedingte weitere          *
     F*      Durchführung)                                       *
     F*      Routinen wie sr_aflp04 können einen Fehler übergeben*
     F*      eval      ysds  = Nein (Fehlersetzung)              *
     F*      mit der Wikung, dass kein Satz in FRDTN geschrieben *
     F*      wird und nur ein Protokolleintrag erfolgt           *
     F*                                                          *
     F*                                                          *
     F*MG002 19.01.2015                                          *
     F*      teilweise gibt es Aufträge, die nicht über den      *
     F*      normalen Prozess gefahren werden (meistens Auftrags-*
     F*      art '03') Hier wird kein direkter Lieferschein ge-  *
     F*      druckt, Kom- erfolgt auch per Hand.                 *
     F*      Es wird nachgelesen ohne Bezug zu einer Position.   *
     F*      Nur wenn auch hier (kleinster Zugriff ohne Position)*
     F*      kein Leseerfolg ist, erfolgt Abweisung durch        *
     F*      eval      ysds  = Nein (Fehlersetzung).             *
     F*                                                          *
     F*MG003 20.01.2015                                          *
     F*      Zahlungsbedingungsroutine nachgelagert wegen        *
     F*      Zugriff auf Versender und evtl. COD Zusatzkosten    *
     F*      für den Empfänger                                   *
     F*                                                          *
     F*MG004 28.01.2014 Änderung der Abfrage                     *
     *************************************************************
     *** /copy rpg_cpr
     *** VLF95DWE
     *** VLPLGUSR
     *** VLF95USR
     *** VLNABUSR27
     fff5       uf   e             disk
     f                                     RENAME(ff5:phy01r)
     F                                     USROPN
     faflp04    if   e           k disk
     F                                     USROPN
     fTEIL00    if   e           k disk
     F                                     USROPN
     fLAND01    if   e           k disk
     F                                     USROPN
     ftrtp01    if a e           k disk
     F                                     USROPN
     fkund01    if a e           k disk
     F                                     USROPN
     fzabd01    if a e           k disk
     F                                     USROPN
     fafrk01    if a e           k disk
     F                                     USROPN
     ftxbe01    if a e           k disk
     F                                     USROPN
     fwao802    if a e           k disk
     F                                     USROPN
MG005fvssp01    if a e           k disk
     F                                     USROPN
      /copy yqrpglesrc,eqsrpgiys
      /copy yqrpglesrc,eqsrpgixs
      /space 2
     d p00001        e ds                  extname(frdtn1a)
     d                                     prefix(r)
     d p00002        e ds                  extname(frdzp1a)
     d                                     prefix(z)
     d p00003        e ds                  extname(frdem1a)
     d                                     prefix(e)
     d*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*-------------------------------------------------------------------------
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
     c* Datensatz gefunden
     c                   endsr
      /space 2
      * Load
      /space 1
     c     d10           begsr
     c
     c                   setoff                                       70
     c**********==>      z-add     0             open              1 0
     c                   eval      ysds  = Nein
     c                   eval      ystxt = 'Lieferschein nicht vor' +
     c                                     'handen                 '
     C     *LIKE         DEFINE    ystxt         #ystxt
     c                   eval      #ystxt   = ystxt
     c                   eval      rvsrhe      = %subst(rvsrhe:1:15) +
     c                                   '                         '
     c                   if        open  = 0
     c                   call      'IFDTRLOADC'
     c                   parm      'OPEN '       opt               5
     c                   parm      '          '  JOB              10
     c                   parm      '          '  USER             10
     c                   parm      '          '  NBR               6
     c                   endif
     c
     c                   call      'FORWARDERA'
     c                   parm                    rvsrhe
     c
     c                   seton                                        50
     c                   open      ff5
     c                   if        open  = 0
     c                   open      aflp04
     c                   open      teil00
     c                   open      land01
     c                   open      trtp01
     c                   open      kund01
     c                   open      zabd01
     c                   open      afrk01
     c                   open      txbe01
     c                   open      wao802
MG005c                   open      VSSP01
     c                   z-add     1             open              1 0
     c                   endif
     c
     c                   DO        *HIVAL
     c                   READ      ff5                                    95
     c                   IF        *in95 = '1'
     c                   leave
     c                   else
     c                   eval      ysds  = Ja
     c                   clear                   #ystxt
     c                   clear                   ystxt
     c  n50              update    phy01r
     c                   exsr      sr_aflp04
     c                   exsr      sr_teil00
mg003c****************** exsr      sr_ZABD01
     c                   exsr      sr_wao802
     c* Frachdatensatz erstellen  (Kopf)
     c*****              z-add     1             open              1 0
mg001c                   if        ysds = ja
     c  n70              exsr      d110
mg001c                   endif
     c* Emailpositonen erstellen
     c                   if        ysds = ja
     c  n70              exsr      d130
     c                   endif
mg004c***                seton                                        70
     c
     c* Zollpositonen erstellen   (Positionen)
     c                   if        ysds = ja and rlkzsc = *blanks
mg004c  n70              exsr      d120
     c                   endif
mg004c                   seton                                        70
     c                   endif
     c                   enddo
     c
     c                   setoff                                       74
     c                   if        open  = 3
     c                   close     land01
     c                   close     teil00
     c                   close     aflp04
     c                   close     trtp01
     c                   close     kund01
     c                   close     zabd01
     c                   close     afrk01
     c                   close     txbe01
     c                   close     wao802
MG005c                   close     vssp01
     c                   endif
     c                   close     ff5
     c                   exsr      sr_save
     c***96              return
     c                   return
     c
     c                   endsr
      /space 2
      * Load
      /space 1
     c     d110          begsr
     c                   if        ( LBPCSTAT <'51'  or
     c                               LBPCSTAT >'90') and
     c                               LBPCSTAT <> *Blank
     c                   eval      message='Auftragsstatus falsch ' +
     c                                      LBPCSTAT                +
     c                                     ' falsch Info an Trend'
     c                   exsr      sr_messag
     c                   endif
     c                   eval      rfir   =    LBPCFIRM
     c******             eval      rbtnr  =
     c                   eval      rlkdnr =    AKKDNR
     c******                       Anrede
     c                   eval      rlnam0 =    *blank
     c                   eval      rlnam1 =    AMNAM1
     c                   eval      rlnam2 =    AMNAM2
     c                   eval      rlnam3 =    AMNAM3
     c******             eval      rlnam4 = alnam4
     c                   eval      rlstr  =    AMSTRA
     c                   eval      rlplz  =    AMPOLZ
     c                   eval      rplz   =    AMPOLZ
     c                   eval      rlkz   =    AMPOLD
     c
      *   fehlende Kennzeichnung Landkennung
     c                   if        AMPOLD   = *blank
     c     amland        chain     land1
     c                   IF        %found(land01)
     c                   eval      AMPOLD  =     LNLISO
     c                   eval      rlkz   =    AMPOLD
     c                   endif
     c                   seton                                        72
     c                   eval      message='Landcode fehlt, ermitt' +
     c                                     'elt über: '             +
     c                                      amland                  +
     c                                     ' '                      +
     c                                      ampold
     c                   exsr      sr_messag
     c                   endif
     c
      *   falsche Polstleitzahlen
     c                   if        ( %subst(AMPOLZ:5:1) <> ' ' and
     c                               %subst(AMPOLZ:1:1) =  '0'     )
     c                               and
     c                             ( AMPOLD='AT'  or
     c                               AMPOLD='BE'  or
     c                               AMPOLD='CH'  or
     c                               AMPOLD='DK'  or
     c                               AMPOLD='NL'  or
     c                               AMPOLD='LU'  or
     c                               AMPOLD='SI'  or
     c                               AMPOLD='AT'  )
     c                   eval      rlplz = %subst(AMPOLZ:2:4)
     c                   eval      rplz  = %subst(AMPOLZ:2:4)
     c                   seton                                        73
     c                   eval      message='Postleitzahl '    +
     c                                     'vierstellig '     +
     c                                      AMPOLZ
     c                   exsr      sr_messag
     c                   endif
     c
     c
     c                   eval      rort   =    AMWORT
     c                   eval      rlsnr  = %char(ALLIJJ) +
     c                                      ALLINR
     c                   eval      rfaunr =    %char(AMAFJJ) +
     c                                         AMAFNR
     c*******            eval      rrenr = arenr
     c                   eval      rsnref  =  %char(ALLIJJ) +
     c                                        ALLINR
     c                   eval      rlftmj  =  %subst(#ALLSDA:1:4)
     c                   eval      rlftmm  =  %subst(#ALLSDA:5:2)
     c                   eval      rlftmt  =  %subst(#ALLSDA:7:2)
      *                 rfvsat    Versandart Beispiel
      *                           DP01 = Versandpaket Inland
      *                           wird über Interface in Verbindung mit
      *                           Landkennzeichen gesteuert
      *                 rfrnk     gleiches gilt für die Frankatur rfrnk
     c                   exsr      srTRTP01
     c                   if        AMVSBD   ='024'
MG005c                   exsr      sr_vssp01
     c                   eval      message='AMAZON Abwicklung ' +
     c                                      'Pakete           '
     c                   exsr      sr_messag
     c                   endif
     c                   if        AMVSBD   ='025'
MG005c                   exsr      sr_vssp01
     c                   eval      message='AMAZON Abwicklung ' +
     c                                      'Stückgut         '
     c                   exsr      sr_messag
     c                   endif
      *                 Zahlungsbedingung Nachnahme
      *                 Ausnahme Kunde 088883
MG003c                   exsr      sr_ZABD01
     c                   eval      rfrnk    = *blank
     c                   eval      rfvsgw    = AVGWBR * 1000
     c*******                      Anzahl_Packstuecke
     c                   eval      rpkasn    = 1
     c                   eval      rvshn1  =  ALMAAf  + ' ' +
     c                                        %char(ALLIJJ) +
     c                                        ALLINR
     c*******  ist Hinweisfeld in der mail
     c                   eval      rlbsnr  =  ALMAAf
     c                   if        rlbsnr  =  *blank
     c                   eval      rlbsnr  =  AKREF1
     c                   endif
     c                   if        rlbsnr  =  *blank
     c                   eval      rlbsnr  =  AKREF2
     c                   endif
     c*******                      Paket-NR wird gescannt
     c**********         eval      rvsrhe  =  Paket-NR
     c                   eval      rvsrhf  =  %char(ALLIJJ) +
     c                                        ALLINR
     c*******            eval      rfrebt  = Rechnungsbetrag
     c*******            eval      rfnnbt  = Nachnahmebetrag
     c                   eval      rdsk01  = %char(AVKMJJ)
     c                   eval      rdsk02  = (LBPCNMKR)
     c                   eval      rdsk03  = %char(LBPCPCJJ)
     c                   eval      rdsk04  = LBPCPCNR
     c                   eval      rdsk05  = AVKDLI
     c                   eval      rdsk06  = AMVSBD
     c                   eval      rsnsts = '1'
     c                   eval      rsts   = 'A'
      *                 rlkdna    Frachtzahlerkundennummer
      *                           (hinterlegt,wer die Fracht zahlt z.B.TNT)
     c                   eval      ystxt  =  *blank
     c                   exsr      d1110
     c* Wenn kein Fehler, dann Datensatz erstellen
     c                   if        ystxt = *blanks
     c                   exsr      D910
     c                   else
     c                   eval      ysds = nein
     c                   endif
     c                   endsr
      /space 1
     c* Zollpositionen erstellen, wenn Drittland
      /space 2
     c     d1110         begsr
     c                   call      'IFDFRDCHK'
     c                   parm                    ys
     c                   parm                    p00001
     c                   endsr
      /space 1
     c* Zollpositionen erstellen, wenn Drittland
      /space 2
     c     d120          begsr
     c                   clear                   p00002
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      zfir  = rfir
     c                   eval      zbtnr = rbtnr
     c                   eval      zelj  = relj
     c                   eval      zvsnr = rvsnr
     c                   eval      zvspn = rvspn
     c                   eval      zfaunr = rfaunr
     c                   eval      zlsnr = rlsnr
     c                   eval      zlkdnr = rlkdnr
     c                   eval      zlrenr = rlrenr
     c* Artikeldaten aus Trend
     c                   eval      zfarnr = LBPCTENR
     c                   eval      zfarbz = TETBZ1
     c                   eval      zfargr = TEMAGR
     c                   z-add     ALGLMG        zfvsmg
     c* Ursprungsland bestimmen
     c                   eval      zurlnd  =     teurld
     c     teurld        chain     land1
     c                   IF        %found(land01)
     c                   eval      zurlnd  =     LNLISO
     c                   endif
     c                   eval      zztnr  =  TEZOTN
     c* Zollwert (Positonswert)
     c                   eval      zfzlwt  =     ALWAWT
     c*
     c                   eval      zsts = 'A'
     c* Ausgabe Zollpositionen
     c                   exsr      D920
     c                   endsr
      /space 1
     c* E-Maildatensatz erstellen für Sendungsbenachrichtigung
      /space 2
     c     d130          begsr
     c                   clear                   p00003
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      efir  = rfir
     c                   eval      ebtnr = rbtnr
     c                   eval      eelj  = relj
     c                   eval      evsnr = rvsnr
     c                   eval      evspn = rvspn
     c*
     c                   exsr      sr_txbe01
     c***                eval      eemtpl = 'DESTD'
     c***                eval      eemail  = 'manfred.gang@yahoo.de'
     c***                eval      ests = 'A'
     c***                exsr      d930
     c                   endsr
      /space 2
      * Ausgabe FRDTN Datensatz
      /space 1
     c     d910          begsr
     c                   eval      xsoa = 'CT'
     c                   call      'VSE55'
     c                   parm                    xs
     c                   parm                    p00001
     c                   if        xsds <> ja
     c                   eval      ysds = xsds
     c                   eval      ystxt = xstxt
     c                   return
     c                   endif
     c                   endsr
      /space 2
      * Zollpositionen erstellen
      /space 1
     c     d920          begsr
     c                   eval      xsoa = 'W '
     c                   call      'VSE54'
     c                   parm                    xs
     c                   parm                    p00002
     c                   endsr
     c
      /space 2
      * Emailadressen erstellen
      /space 1
     c     d930          begsr
     c                   eval      xsoa = 'W '
     c                   call      'VSE59'
     c                   parm                    xs
     c                   parm                    p00003
     c                   endsr
     C**************************************************************************
      * :Einzelsatz Lieferschein(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_aflp04     BEGSR
     C*
     C                   if        LBPCPOSI  = 0
     C                   z-add     10            LBPCPOSI
     C                   endif
     C                   z-add     LBPCPOSI      #LBPCPOSI         4 0
      * :lesen Lieferscheindaten
     c     k_aflp04      klist
     c                   kfld                    AMFIRM
     c***                kfld                    LBPCFIRM
     c                   kfld                    AMKMJJ
     c***                kfld                    LBPCJAHR
     c                   kfld                    AMKMNR
     c***                kfld                    LBPCNMKR
     c                   kfld                    #LBPCPOSI
     c     k_aflp04      chain     aflp04                             96
     c   96              clear                   #ALLSDA           8
     c   96              clear                   ALLSDA
     c                   movel     allsda        #ALLSDA
mg002c                   if        AKAFAT <> '03'
     c   96              eval      ysds  = Nein
     c   96              eval      ystxt = 'Lieferscheindaten sind' +
     c                                     ' nicht vorhanden       '
     c                   else
mg002c                   exsr      sr_aflp04_
     c                   endif
     c*
     C     ##_aflp04     ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Lieferschein(Lines)
     C*-------------------------------------------------------------------------
     C*
mg002C     sr_aflp04_    BEGSR
     C*
     C                   z-add     LBPCPOSI      #LBPCPOSI         4 0
      * :lesen Lieferscheindaten
     c     k_aflp04_     klist
     c                   kfld                    AMFIRM
     c                   kfld                    AMKMJJ
     c                   kfld                    AMKMNR
     c     k_aflp04_     chain     aflp04                             96
     c   96              clear                   #ALLSDA           8
     c   96              clear                   ALLSDA
     c                   movel     allsda        #ALLSDA
     c   96              eval      ysds  = Nein
     c   96              eval      ystxt = 'Lieferscheindaten sind' +
     c                                     ' nicht vorhanden       '
     c*
     C     ##_aflp04_    ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_teil00     BEGSR
     C*
     C                   z-add     LBPCPOSI      #LBPCPOSI         4 0
      * :lesen Lieferscheindaten
     c     k_teil00      klist
     c                   kfld                    LBPCFIRM
     c                   kfld                    LBPCTENR
     c
     c     k_teil00      chain     teil00
     c                   IF        %found(teil00)
      * :                         Gefahrgut
     c                   IF        LBPCTENR='8887100007' or
     c                             LBPCTENR='8887100019'
     c                   seton                                        74
     c                   eval      message='Achtung Gefahrgut '       +
     c                                      %subst(LBPCTENR:1:10)     +
     c                                      ' Transport über Hellmann'
     c                   exsr      sr_messag
     c                   endif
     c                   endif
     c
     c*
     C     ##_teil00     ENDSR
     C*
     C**************************************************************************
      * :Zahlungsbedingung und Nachnahme  RKRGJJ
      * :Zahlungsbedingung und Nachnahme  RKRGNR
     C*-------------------------------------------------------------------------
     C*
     C     sr_ZABD01     BEGSR
     C*
     c                   clear                   #ZBNAKZ           1
     c                   clear                   #ZBPRZ            5 2
     c                   clear                   #nn              13 2
      * :lesen Lieferscheindaten
     c     k_ZABD01      klist
     c                   kfld                    AKFIRM
     c                   kfld                    AKZABD
     c
     c     k_ZABD01      chain     ZABD01
     c                   IF        %found(ZABD01)  and
     c                             ZBNAKZ   =      'J'
     c                   movel     ZBNAKZ        #ZBNAKZ
     c                   eval      #ZBPRZ =(ZBPRZ1 +ZBPRZ2 +
     c                                      ZBPRZ3 +ZBPRZ4 + ZBPRZ5)
     c****               evalhr    nn=
     c     k_afrk01      klist
     c                   kfld                    AKFIRM
     c                   kfld                    ALRGJJ
     c                   kfld                    ALRGNR
     c                   kfld                    ALLIJJ
     c                   kfld                    ALLINR
     c     k_afrk01      chain     afrk01
     c                   IF        %found(afrk01)
     c                   clear                   cod               8 3
MG003c                   if        akkdnr <> '088883'
     c                   exsr      srTRTP01_
     c                   endif
     c                   eval      rlrenr =   %char(RKRGJJ)+
     c                                              RKRGNR
     c*******            eval      rfrebt  =  Rechnungsbetrag
     c*******            eval      rfnnbt  =  Nachnahmebetrag
     c**** kfm höchste g eval(hr)  #nn=
     c                   eval(h)   #nn=((RKWAWT + RKWAW2 + RKWAW3+
     c                                   RKMWS1 + RKMWS2 + RKMWS3) *
     c                                   (100 - #ZBPRZ) / 100) +COD
     c                   eval      rfrebt  = (RKWAWT+RKWAW2+RKWAW3+
     c                                        RKMWS1+RKMWS2+RKMWS3)
     c                   eval      rfnnbt  =  #nn
     c                   eval      message='Achtung Nachnahme:' +
     c                                      ' Betrag: '         +
     c                                       %char(#nn)
     c                   exsr      sr_messag
     c
     c                   else
     c                   eval      message='Achtung Nachnahme' +
     c                                     'betrag fehlt, da ' +
     c                                     'keine Rechnung vo' +
     c                                     'rhanden'
     c                   exsr      sr_messag
     c                   endif
     c                   endif
     c*
     C     ##_ZABD01     ENDSR
     C*
     C**************************************************************************
      * :Nachnahme über wao8 bei sales companies
      * :keine Teillieferung möglich. nur Komplettauftrag
     C*-------------------------------------------------------------------------
     C*
     C     sr_wao802     BEGSR
     C*
     c
      * :lesen Lieferscheindaten
     c     k_wao802      klist
     c                   kfld                    AKFIRM
     c                   kfld                    AKAFJJ
     c                   kfld                    AKAFNR
     c
     c     k_wao802      chain     wao802
     c                   IF        %found(wao802)  and
     c                             WAO8CODB <> 0
     c                   eval      rlrenr =   %char(RKRGJJ)+
     c                                              RKRGNR
     c                   eval(h)   #nn=WAO8CODB
     c                   eval      rfrebt  = WAO8CODB
     c                   eval      rfnnbt  =  #nn
     c                   eval      message='Achtung Nachnahme:' +
     c                                      ' Betrag: '         +
     c                                       %char(#nn)
     c                   exsr      sr_messag
     c                   endif
     c*
     C     ##_wao802     ENDSR
     C*
     C**************************************************************************
     C*...                  TRTP01
     C*-------------------------------------------------------------------------
     C*
     C     srTRTP01      BEGSR
     C*
     C*                 update bestand pflege über call trtrtpst
     c     key001        klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   clear                   TPTART
     c                   movel     'RHENANIA'    TPTART
     c                   clear                   TPTCDE
     c                   movel     AMVSBD        TPTCDE
     c                   clear                   #TPTTXT           3
     c     key001        chain     trtp01                             97
     c   97              movel     '*ERR'        rfvsat
     c   97              movel     '*ERR'        #rfvsat           4
     c  n97              eval      rfvsat  = %subst(TPTTXT:1:4)
     c  n97              eval      #rfvsat  = %subst(TPTTXT:1:4)
     c
     c   97              eval      message='Versandart: '+
     c                                     AMVSBD        +
     c                                     ' nicht hinterlegt'
     c   97              exsr      sr_messag
     c                   if        AMVSBD = '001'
     c                   eval      message='Achtung unfreie Sendung '
     c                   exsr      sr_messag
     c                   endif
     c                   if        AMVSBD = '057'
     c                   eval      message='Achtung unfreie Sendung '
     c                   exsr      sr_messag
     c                   endif
     c
     C*Kundenzuordnung zu TNT für Zahlung
     c                   if        rfvsat  = 'TI01' or
     c                             rfvsat  = 'TI02' or
     c                             rfvsat  = 'TI03'
     c     #kunde        klist
     c                   kfld                    AKFIRM
     c                   kfld                    #AKKDNR
     c                   movel     AKKDNR        #AKKDNR          10
     c                   if        AKLIBD    ='001' or
     c                             AKLIBD    ='033'
     c                   movel     '000000'      #AKKDNR
     c                   endif
     C*Reihenfolge Prioritäte: KDRAKD,   KDKOKD,    KDDBKD
     C*                        Rechnung, Kondition, Debitor
     c     #kunde        chain     kund01
     c                   IF        %found(kund01)
     c                   if        KDDBKD  <> *blank
     c                   movel     KDDBKD        #tntkdnr         10
     c                   endif
     c                   if        KDKOKD  <> *blank
     c                   movel     KDKOKD        #tntkdnr         10
     c                   endif
     c                   if        KDRAKD  <> *blank
     c                   movel     KDRAKD        #tntkdnr         10
     c                   endif
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   clear                   TPTART
     c                   movel     '#TNTKDNR'    TPTART
     c                   clear                   TPTCDE
     c                   movel     #tntkdnr      TPTCDE
     c                   clear                   #TPTTXT           3
     c     key001        chain     trtp01                             97
      *                 rlkdna    Frachtzahlerkundennummer
      *                           (hinterlegt,wer die Fracht zahlt z.B.TNT)
     c   97              movel     '00000000'    rlkdna
     c   97              eval      message='Frachtzahler fehlt für Kunde: '+
     c                                     #tntkdnr
     c   97              exsr      sr_messag
     c   97              seton                                        44
     c  n97              eval      rlkdna  = %subst(TPTTXT:1:8)
     c                   else
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   clear                   TPTART
     c                   movel     '#TNTKDNR'    TPTART
     c                   clear                   TPTCDE
     c                   movel     '000000    '  TPTCDE
     c                   clear                   #TPTTXT           3
     c     key001        chain     trtp01                             97
      *                 rlkdna    Frachtzahlerkundennummer
      *                           (hinterlegt,wer die Fracht zahlt z.B.TNT)
     c   97              movel     '00000000'    rlkdna
     c   97              eval      message='Frachtzahler Dometic fehlt '+
     c                                     #tntkdnr
     c   97              exsr      sr_messag
     c   97              seton                                        44
     c  n97              eval      rlkdna  = %subst(TPTTXT:1:8)
     c                   endif
     c                   endif
     C*
     C     ##TRTP01      ENDSR

     C**************************************************************************
     C*...TRTP01 Nachnahmegebühr?
     C*-------------------------------------------------------------------------
     C*
     C     srTRTP01_     BEGSR
     C*
     C*                 update bestand pflege über call trtrtpst
     c     key001_       klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   clear                   TPTART
     c                   movel     'CODAMOUNT'   TPTART
     c                   clear                   TPTCDE
     c                   eval      TPTCDE  =     rfvsat
     c     key001_       chain     trtp01                             86
     c   86              eval      cod     =     *zero
     c  n86              eval      cod     =     TPTNUM
     c
     C*
     C     ##TRTP01_     ENDSR

     C**************************************************************************
      * :eMails aus TXBE
      * :landen später in die Datei FRDEM bei Rhenania
     C*-------------------------------------------------------------------------
     C*
     C     sr_txbe01     BEGSR
     C*
     C                   z-add     LBPCPOSI      #LBPCPOSI         4 0
      * :lesen Lieferscheindaten
     c     k_txbe01      klist
     c                   kfld                    LBPCFIRM
     c                   kfld                    TBTXAR
     c                   kfld                    AKAFJJ
     c                   kfld                    akafnr
     c                   kfld                    TBPOSI
     c                   kfld                    TBupos
     c                   kfld                    tbtcde
     c
     c                   eval      TBTXAR   =    'AFDA'
     c                   eval      TBPOSI   =    0
     c                   eval      TBupos   =    0
     c                   eval      tbtcde   =    'TXVS'
     c
     C     k_txbe01      chain     txbe01                                 91
     C   91              LEAVE
     C                   if        TBDRK1 = 'M'
     c                   if        AKKDNR = '055278'
     c                   eval      TBSPCD = 'I'
     c                   endif
     c                   eval      eemtpl = TBSPCD + '_' + 'STD'
     c                   eval      eemail  = tbtext
     c*****              eval      eemail  = 'manfred.gang@yahoo.de'
     c                   eval      ests = 'A'
     c                   exsr      d930
     c                   else
     c                   endif
     C                   ENDDO
     c*
     C     ##_txbe01     ENDSR
     C*
     C**************************************************************************
      * :Amazone
     C*-------------------------------------------------------------------------
     C*
mg005C     sr_vssp01     BEGSR
mg005C*
mg005 * :lesen Lieferscheindaten
mg005c     k_vssp01      klist
mg005c                   kfld                    ASFIRM
mg005c                   kfld                    ASSDJJ
mg005c                   kfld                    ASSDNR
mg005c
mg005C     k_vssp01      SETLL     vssp01
mg005C                   DO        *HIVAL
mg005C     k_vssp01      READE     vssp01                                 91
mg005c                   IF        %found(vssp01)
mg005c                   else
mg005c                   clear                   VSSPSDNR
mg005c                   endif
mg005C                   ENDDO
mg005c*
mg005C     ##_txbe01     ENDSR
     C*
     C**********************************************************************
     C*Sicherung in das Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_save       BEGSR
      *
     C                   clear                   error            60
     C                   if        #ystxt= 'Lieferschein nicht vor' +
     C                                     'handen                 '
     C                   eval      error    = 'Lieferschein fehlt'
     C                   endif
     C                   clear                   ##ZBPRZ           5
     C                   clear                   ##nn             13
     C                   if        #ZBNAKZ  ='J'
     C                   move      #ZBPRZ        ##ZBPRZ
     C                   move      #nn           ##nn
     C                   endif
     c                   setoff                                       71
     c                   if        LBPCSTAT <'51'  or
     c                             LBPCSTAT >'90'
     c                   seton                                        71
     c                   endif
      *
     C                   clear                   md
     C                   movea(p)  'IFDTRLOAD '  md(001)
     C                   movea(p)  job           md(011)
     C                   movea(p)  user          md(022)
     C                   movea(p)  nbr           md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C**********         movea(p)  chx           md(046)
     C                   MOVEA     ATR(14)       md(050)
     C                   movea(p)  rvsrhe        md(051)
     C                   movea(p)  AMVSBD        md(068)
     C                   movea(p)  #rfvsat       md(072)
     C                   movea(p)  #ZBNAKZ       md(077)
     C                   movea(p)  ##ZBPRZ       md(079)
     C                   movea(p)  ##nn          md(085)
     C   44              movea(p)  #tntkdnr      md(099)
     C                   movea(p)  error         md(106)
     C   71              movea(p)  'ST?'         md(127)
     C   71              movea(p)  LBPCSTAT      md(130)
     C   72              movea(p)  amland        md(133)
     C   72              movea(p)  '>'           md(135)
     C   72              movea(p)  ampold        md(136)
     C   73              movea(p)  AMPOLZ        md(140)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     c                   setoff                                       44
     c                   setoff                                       72
     c                   setoff                                       73
      *
     C     ##_save       ENDSR
     C
     C**********************************************************************
     C*Messages
     C*-------------------------------------------------------------------------
     C
     C     sr_messag     BEGSR
      *
     C                   clear                   xpos              3
     C                   clear                   ypos              2
     C                   clear                   t                 1
     C                   eval      xpos  = '006'
     C                   eval      ypos  = '05'
     C                   eval      t     = '0'
      *
     C                   CALL      'QM0003C'
     C                   PARM                    message
     C                   PARM                    xpos
     C                   PARM                    ypos
     C                   PARM                    t
     C                   clear                   message          60
      *
     C     ##_message    ENDSR
     C
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9900        BEGSR
     C*
     c                   clear                   newdate           8

     c/exec sql
     c+ select  substr(char
     c+ (date(substr(char(:LBPCJDAT), 1, 4) concat '-' concat
     c+       substr(char(:LBPCJDAT), 5, 2) concat '-' concat
     c+       substr(char(:LBPCJDAT), 7, 2)  ) +2 days, eur), 7, 4)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:LBPCJDAT), 1, 4) concat '-' concat
     c+       substr(char(:LBPCJDAT), 5, 2) concat '-' concat
     c+       substr(char(:LBPCJDAT), 7, 2)  ) +2 days, eur), 4, 2)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:LBPCJDAT), 1, 4) concat '-' concat
     c+       substr(char(:LBPCJDAT), 5, 2) concat '-' concat
     c+       substr(char(:LBPCJDAT), 7, 2)  ) +2 days, eur), 1, 2)
     c+ into  :newdate
     c+       from qsys2/qsqptabl
     c+
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C
     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------
      /copy yqrpglesrc,eqsrpgcsin
