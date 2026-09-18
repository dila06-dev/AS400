      /TITLE DWE Frachtdatensatz aus Trend laden
     h  option(*SRCSTMT:*NoDebugIO)
      * Copyright
     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F* OVRDBF FILE(GG) TOFILE(VLF95DWE/VEMMBR) MBR(I_STD) OVRSCOPE(*JOB)
     F* SELECT SRCDTA FROM gg                                    *
     F*                                                          *
     F* select a.fir, a.btnr, a.lnam1, a.idbcd,  a.eldtt,  a.faunr, e.email
     F*  from frdtn a inner Join frdem e on
     F* a.fir = e.fir and a.btnr = e.btnr and a.elj = e.elj
     F* and a.vsnr = e.vsnr and a.vspn = e.vspn
     F* where ela ='BAR' and
     F* a.eldtj ='2015' and a.eldtm = '03'
     F* and e.email = 'l.benedetti@power-line.it'
     F* order by a.fir, a.btnr, a.idbcd
     F*                                                          *
     F* SELECT DISTINCT a.fir, a.btnr, a.lnam1, a.idbcd, a.eldtt, a.faunr,
     F* e.email , emsts FROM VLF95DWE/frdtn a inner Join VLF95DWE/frdem e
     F* on a.fir = e.fir and a.btnr = e.btnr and a.elj = e.elj and a.vsnr =
     F* e.vsnr and a.vspn = e.vspn WHERE a.eldtj ='2015' ORDER BY a.fir,
     F* a.btnr, a.idbcd
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*                                                          *
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
     F*                                                          *
     F*MG003 20.01.2015                                          *
     F*      Zahlungsbedingungsroutine nachgelagert wegen        *
     F*      Zugriff auf Versender und evtl. COD Zusatzkosten    *
     F*      für den Empfänger                                   *
     F*                                                          *
     F*                                                          *
     F*MG004 28.01.2015                                          *
     F*      Routine geändert für Aufruf                         *
     F*                                                          *
     F*                                                          *
     F*MG005 29.01.2015                                          *
     F*      ASN# integriert bei derzeit nur 024 und 025         *
     F*      AMAZONE (später über Parameter)                     *
     F*                                                          *
     F*                                                          *
     F*MG006 02.02.2015                                          *
     F*      Textbausteine für Zusatzmodule                      *
     F*                                                          *
     F*                                                          *
     F*MG007 10.04.2015                                          *
     F*      Zahlungsbedingungen fordern eine Nachnahme, Wert    *
     F*      der Rechnung ist aber Null, Reaktion auf Fehler im  *
     F*      Vorfeld                                             *
     F*                                                          *
     F*MG008 20.04.2015                                          *
     F*      Gefahrgutintegration                                *
     F*                                                          *
     F*MG009 08.05.2015                                          *
     F*      Gefahrgutintegration neu, da Gruppierungen geändert *
     F*SELECT        rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     F*              RGBFK,RGKFC,RGTBC,RGME,RGWGK,
     F*              RGCT1,RGCT2,RGCT3,
     F*              dec(sum(rgbm*alglmg), 11, 3)    rgbm,
     F*              dec(sum(rgnm*alglmg), 11, 3)    rgnm,
     F*              dec(sum(RGNME*alglmg*0), 11, 3) RGNME,
     F*              dec(sum(rgnvo      ), 11, 0)    rgnvo,
     F*              dec(sum(rgmg       ), 11, 3)    rgmg,
     F*            zoned(sum(nds01      ), 03, 0)    nds01,
     F*              dec(sum(alglmg     ), 11, 3)    rmenge
     F*FROM RHGEFAHRn inner JOIN #AFLPL2 ON rgtenr=altenr
     F*                                 and rgfirm=alfirm
     F*WHERE ALKMJJ=2015     and ALKMNR>'125000' and ALFIRM='01'
     F*      and RGGVS<>' ' and RGGVS<>' ' and RGGVV<>' '
     F*group BY      rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     F*              RGBFK,RGKFC ,RGTBC,RGME,RGWGK,
     F*              RGCT1,RGCT2,RGCT3, RGZF, RGBS
     F*Datei FRDGP# in TVRELWAECO wurde erstellt.                *
     F*
     F*MG009 15.05.2015
     F*      Ergänzung 20. KW 2015neu, da Gruppierungen geändert *
     F*      Die Verdichtung schließt ergänzend der Logik auch   *
     F*      die Namensfelder ein, da der Inhalt sich auf die    *
     F*      Bestandteile bezieht.                               *
     F*      integration neu, da Gruppierungen geändert          *
     F*MG009 27.05.2015
     F*      Ergänzung 22. KW 2015neu, da Gruppierungen geändert *
     F*      Die Verdichtung schließt ergänzend der Logik auch   *
     F*      die Verpackungsdaten ein, da der Inhalt sich auf die*
     F*      Bestandteile bezieht. RGVPA, RGVG                   *
     F*      integration neu, da Gruppierungen geändert          *
     F*MG010 28.05.2015
     F*      Beipackanpassungen                                  *
     F*      über YSOA = "BK" wird erkannt, dass ein Beipack-    *
     F*      prozess eingeleitet worden ist über Command F20.    *
     F*      Bestimmte Prozesse werden dann nicht aufgerufen.    *
     F*      D910, D130 und D940 werden nicht benötigt           *
     F*MG011 05.06.2015
     F*      Sammelpick                                          *
     F*      über YSOA = "AK" wird erkannt, dass ein Sammelpick- *
     F*      prozess eingeleitet worden.                         *
     F*      referenz1 ==> rfds02                                *
     F*MG012 08.09.2015
     F*      afad01, da KommDaten nicht immer korrekt            *
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
     ftrtp01    if   e           k disk
     F                                     USROPN
     fkund01    if   e           k disk
     F                                     USROPN
     fzabd01    if   e           k disk
     F                                     USROPN
     fafrk01    if   e           k disk
     F                                     USROPN
     fafad01    if   e           k disk
     F                                     USROPN
     ftxbe01    if   e           k disk
     F                                     USROPN
     ftxst01    if   e           k disk
     F                                     USROPN
     fwao802    if   e           k disk
     F                                     USROPN
MG005fvssp01    if   e           k disk
MG005F                                     USROPN
MG005fzkun01    if   e           k disk
MG005F                                     USROPN
     fFRDGP#    if   e           k disk    prefix('Q')
     F                                     USROPN
     f                                     RENAME(FRDGP#:phy02r)
     F                                     INFDS(DSF1)
MG008f
      /copy yqrpglesrc,eqsrpgiys
      /copy yqrpglesrc,eqsrpgixs
      /space 2
     d p00001        e ds                  extname(frdtn1a)
     d                                     prefix(r)
     d p00002        e ds                  extname(frdzp1a)
     d                                     prefix(z)
     d p00003        e ds                  extname(frdem1a)
     d                                     prefix(e)
     d p00004        e ds                  extname(frdtt1a)
     d                                     prefix(t)
MG008d p00010        e ds                  extname(frdgp1a)
MG008d                                     prefix(g)
     d*-------------------------------------------------------------------------
     D*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D §search         s              1a   inz
     D §string         s            100a   inz
     D §replace        s              1a   inz
     D §pos            s              3s 0 inz
     D §notifier       s              4a   inz
     D §gln            s             13a   inz
     D §glnNum         s             13  0 inz
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
     c                   movel     '0'           norun             1
     c                   if        ysvm      =  '#'
     c                   movel     '1'           norun             1
     c                   endif
     c                   if        norun = '0'
     c                   call      'FORWARDERA'
     c                   parm                    rfir
     c                   parm                    rvsrhe
     c                   endif
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
     c                   open      txst01
     c                   open      afad01
     c                   open      zkun01
     c                   open      wao802
MG005c                   open      VSSP01
MG008c*****              open      FRDGP#
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
     c                   exsr      sr_LesZkun
mg003c****************** exsr      sr_ZABD01
     c****************** exsr      sr_wao802
     c* Frachdatensatz erstellen  (Kopf)
     c*****              z-add     1             open              1 0
mg001c                   if        ysds = ja
     c  n70              exsr      d110
mg001c                   endif
     c* Emailpositonen erstellen wenn nicht Beipack
     c                   if        ysds = ja  and
MG010c                             ysoa <> 'BK'
     c  n70              exsr      d130
     c                   endif
     c* besondere Services  wenn nicht Beipack
     c                   if        ysds = ja  and
MG010c                             ysoa <> 'BK'
     c  n70              exsr      sr_txbe01_
     c**n70              exsr      d940
     c                   endif
mg004c***                seton                                        70
     c*
     c* besondere Services
     c                   if        ysds = ja
      *                 Gefahrgutübergabe
     c******                       user = 'RCF95'
     c                   if        *in70='0'
     C     *LIKE         DEFINE    ALFIRM        qALFIRM
     C     *LIKE         DEFINE    ALKMJJ        qALKMJJ
     C     *LIKE         DEFINE    ALKMNR        qALKMNR
     c                   eval      qALFIRM   =   AMFIRM
     c                   eval      qALKMJJ   =   AMKMJJ
     c                   eval      qALKMNR   =   AMKMNR
     c                   exsr      sr9900
MG008c                   open      FRDGP#
     c                   eval      F1RRN     =1
mg008c                   DO        *HIVAL
mg008c                   READ      FRDGP#                                 91
mg008c   91              LEAVE
mg008c  n91              exsr      sr_gefahr
     C                   ENDDO
     C                   endif
MG008c                   close     FRDGP#
     c                   exsr      sr9902x
     c                   endif
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
     c                   close     afad01
     c                   close     zkun01
     c                   close     txst01
     c                   close     wao802
MG005c                   close     vssp01
MG008c*******            close     FRDGP#
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
MG012c                   exsr      srafad01_
     c******             Schafflik 14.08.2015 Übergabe der Firma bereits
     c******             in Parameter Programmaufruf
     c******             eval      rfir   =    LBPCFIRM
     c******             eval      rbtnr  =
     c                   eval      rlkdnr =    AKKDNR
MG010c                   eval      rbpzor =    akkdnr
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
MG010c                   eval      rbpzor =    rfir    +
MG010c                                         rbtnr   +
MG010c                                         rlkdnr
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
     c                               AMPOLD='HU'  or
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
      *                 Amazone
     c                   if        AMVSBD   ='024'
MG005c                   exsr      sr_vssp01
     c                   eval      message='AMAZON Abwicklung ' +
     c                                      'Pakete '           +
MG005c                                      VSSPKFZK
MG005c                   if        VSSPSDNR = *BLANK
MG005c                   eval      message='AMAZON Abwicklung ' +
MG005c                                      'Pakete ohne ASN# '
MG005c                   endif
MG005c                   eval      RFDS01 =  'ASN' + VSSPKFZK
     c                   exsr      sr_messag
     c                   endif
     c                   if        AMVSBD   ='025'
MG005c                   exsr      sr_vssp01
     c                   eval      message='AMAZON Abwicklung ' +
     c                                      'Pakete '           +
     c                                      VSSPSDNR
MG005c                   if        VSSPSDNR = *BLANK
MG005c                   eval      message='AMAZON Abwicklung ' +
MG005c                                      'Pakete ohne ASN# '
MG005c                   endif
     c                   exsr      sr_messag
MG005c                   eval      RFDS01 =  'ASN' + VSSPKFZK
     c                   endif
      *                 Zahlungsbedingung Nachnahme
      *                 Ausnahme Kunde 088883
MG003c                   exsr      sr_ZABD01
MG003c                   exsr      sr_wao802
MG003c                   if        rfrebt =0
MG003c                   exsr      sr_afrk01
MG003c                   endif
     c                   eval      rfrnk    = *blank
     c*******              wenn aus Sammelpick dann übersteuert  ysvm=*
     c                   if        ysvm      =  '*'  or
     c                             ysvm      =  '#'
     c                   eval      rfvsgw    = AVGWBR * 1000/rpkasn
     c                   else
     c                   eval      rfvsgw    = AVGWBR * 1000
     c                   endif
     c*******              Anzahl_Packstuecke
     c*******              wenn aus Sammelpick dann übersteuert  ysvm=*
     c                   if        rpkasn    = 0
     c                   eval      rpkasn    = 1
     c                   endif
     c                   if         rfnnbt    <> 0  and
     c                              akfirm = '08'
     c                   movel     'PX06'        rfvsat
     c                   movel     'PX06'        #rfvsat
     c                   endif
     c                   if         rfnnbt    <> 0  and
     c                              akfirm = '52'
     c                   movel     'PX05'        rfvsat
     c                   movel     'PX05'        #rfvsat
     c                   endif
     c
     c
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
     c                   if        akafat  = '28'  and
     c                             AMKMAT  = 'S'
     c                   eval      rfds02  =  AKREF1
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
     c                   exsr      sr_txst01
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
     c                   if        akafat  = '28' and
     c                             AMKMAT  = 'S'
     c                   eval      xsoa = 'AK'
     c                   endif
MG010c                   if        ysoa  <> 'BK'
     c                   call      'VSE55'
     c                   parm                    xs
     c                   parm                    p00001
MG010c                   endif
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
      /space 2
      * Hinweistexte erstellen
      /space 1
     c     d940          begsr
     c                   eval      xsoa = 'W '
     c                   call      'VSE56'
     c                   parm                    xs
     c                   parm                    p00004
     c                   endsr
     C**************************************************************************
      * :Einzelsatz Lieferschein(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr_aflp04     BEGSR
     C*
     C                   if        LBPCPOSI  = 0
mg002c                   exsr      sr_aflp04_
     C                   z-add     10            LBPCPOSI
     C                   z-add     ALKMPO        LBPCPOSI
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
     C     sr_TEIl00     BEGSR
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
     c                             LBPCTENR='8887100019' or
     c                             %subst(LBPCTENR:1:08) ='91072001'
     c                   seton                                        74
     c                   eval      message='Achtung Gefahrgut '       +
     c                                      %subst(LBPCTENR:1:10)     +
     c                                      ' Transport über Dachser'
     c                   movel     'DC01'        rfvsat
     c                   movel     'DC01'        #rfvsat           4
     c                   exsr      sr_messag
     c                   endif
     c
     c                   IF        LBPCTENR='9104100244' or
     c                             LBPCTENR='9107200133' or
     c                             LBPCTENR='9107200132' or
     c                             LBPCTENR='9107200098' or
     c                             %subst(LBPCTENR:1:08) ='91072001'
     c                   seton                                        74
     c                   eval      message='Achtung Gefahrgut '       +
     c                                      %subst(LBPCTENR:1:10)     +
     c                                      ' Transport Gewicht prüfen'
     c                   exsr      sr_messag
     c                   endif
     c                   endif
     c*
     C     ##_teil00     ENDSR
     C*
       //************************************************************************
     c     sr_LesZkun    begsr

     c     Xkunde        klist
     c                   kfld                    AKFIRM
     c                   kfld                    AKKDNR

     c     Xkunde        chain     Zkun01
     c                   IF        %found(Zkun01)
     c                   IF        KZEDIB <> *Blank
      /FREE

              clear §gln;
              §gln = KZEDIB;
       //    ( Mindestprüfung auf 13Stellen Variable hat 13 Stellen )
              §search              = ' ';
              §string              = §gln;
              §pos                 = 0 ;
              §pos = %scan(§search: §gln);
              monitor;
              if %dec(§gln:13:00) <> *zero;
                 §glnnum = %dec(§gln:13:00);
              endif;
              on-error *all;
              // nicht numerisch wrong contens
                 §pos =1;
              endmon;
              if §pos > 0;
       //    ( error ) Ausfilterung erfolgt noch nicht!!!!
                 clear §gln;
              else;
                 rilnr =§gln;
              endif;
      /End-FREE
     c                   endif
     c                   endif

     C     ##_LesZkun    ENDSR

     C**************************************************************************
MG008 * :Gefahrgutpositionen hier Übergabe
     C*-------------------------------------------------------------------------
     C*
MG008C     sr_gefahr     BEGSR
     C*
      * :lesen Gehafrhutdatei Pseuda, da keine definiert durch Trend
     C*
     c                   clear                   p00010
      * :                         Gefahrgut
     c*********          eval      gfir   = qrgfirm   aus datenstruktur
     c                   eval      gfir   = rfir
     c****nicht mehr     eval      gFARNR = #qALTENR
     c                   eval      gFARNR = *blank
     c                   eval      gbtnr  = rbtnr
     c                   eval      gelj   = relj
     c                   eval      gvsnr  = rvsnr
     c                   eval      gvspn  = rvspn
     c                   eval      ggfgvs  = qRGGVS
     c                   eval      ggfgvv  = qRGGVV
     c*****              eval      gGFBM  =
     c                   eval      gGFBS  = *blank
     c*Achtung wegen Gruppe
     c                   eval      gGFCT1 = qRGCT1
     c                   eval      gGFCT2 = qRGCT2
     c                   eval      gGFCT3 = qRGCT3
     c                   eval      gGFKL  = qRGKL
     c                   eval      gGFKZ  = *blank
     c                   eval      ggfkfc = qRGKFC
     c                   eval      ggfbfk = qRGWGK
     c                   eval      gGFNM  = qRGNM
     c                   eval      gGFbM  = qRGBM
     c                   eval      gGfme  = qRGME
     c                   eval      ggfmg  = qRGNM
     c                   eval      gGFNME = *zero
     c                   eval      gGFNVO = *zero
     c                   eval      gGFUNR = qRGUNR
     c                   eval      gGFVG  = qRGVG
     c                   eval      gGFVPA = qRGVPA
     c****               eval      gGFWGK =
     c****               eval      gGFZF  =
     c****               eval      gFARBZ =
     c                   eval      GNDS01 = qNDS01
     c*****                          =====>
     c****nicht mehr     eval      gFARBZ = TETBZ1
     c****nicht mehr     eval      gFARGR = TEMAGR
     c****nicht mehr     eval      gFARNR = #qALTENR
     c                   eval      gFARNR = *blank
     c                   eval      gFAUNR = %char(AMAFJJ) +
     c                                      AMAFNR
     c****               eval      gFAUPA = zFAUPA
     c****               eval      gFAUPN = zFAUPN
     c                   eval      gFVSGW = qrmenge
     c                   eval      gFVSMG = qrmenge
     c                   eval      gLBSNR  =  ALMAAf
     c                   if        gLBSNR  =  *blank
     c                   eval      gLBSNR  =  AKREF1
     c                   endif
     c                   if        gLBSNR  =  *blank
     c                   eval      gLBSNR  =  AKREF2
     c                   endif
     c                   eval      gLKDNR = AKKDNR
     c                   eval      gLRENR = %char(RKRGJJ)+
     c                                            RKRGNR
     c                   eval      gLSNR  = %char(ALLIJJ) +
     c                                      ALLINR
     c*****              eval      gLSPN  = zLSPN
     c                   eval      gdsk01  = %char(AVKMJJ)
     c                   eval      gdsk02  = (LBPCNMKR)
     c                   eval      gdsk03  = %char(LBPCPCJJ)
     c                   eval      gdsk04  = LBPCPCNR
     c                   eval      gdsk05  = AVKDLI
     c*****
     c                   eval      GGFTBC  = qRGTBC
     c*****
     c                   eval      gsts   = 'A'
     c                   eval      xsoa   = 'W '
     c                   call      'IFD52'
     c                   parm                    xs
     c                   parm                    p00001
     c                   parm                    p00010
     c*
     C     ##_gefahr     ENDSR
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
MG003c****************             #ZBPRZ <> 0
     c                   exsr      srTRTP01_
     c                   endif
     c                   eval      rlrenr =   %char(RKRGJJ)+
     c                                              RKRGNR
     c*******            eval      rfrebt  =  Rechnungsbetrag
     c*******            eval      rfnnbt  =  Nachnahmebetrag
     c**** kfm höchste g eval(hr)  #nn=
     c                   eval      rfrebt  = (RKWAWT+RKWAW2+RKWAW3+
     c                                        RKMWS1+RKMWS2+RKMWS3)
MG007c                   if        rfrebt  =  0
MG007c                   eval      cod     =  0
MG007c                   endif
     c                   eval(h)   #nn=((RKWAWT + RKWAW2 + RKWAW3+
     c                                   RKMWS1 + RKMWS2 + RKMWS3) *
     c                                   (100 - #ZBPRZ) / 100) +COD
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
      * :Rechnungsbetrag
     C*-------------------------------------------------------------------------
     C*
     C     sr_afrk01     BEGSR
     C*
     c     k_afrk01      chain     afrk01
     c                   IF        %found(afrk01)
     c                   eval      rlrenr =   %char(RKRGJJ)+
     c                                              RKRGNR
     c                   eval      rfrebt  = (RKWAWT+RKWAW2+RKWAW3+
     c                                        RKMWS1+RKMWS2+RKMWS3)
     c                   endif
     c*
     C     ##_afrk01     ENDSR
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
     c                   if        rfvsat   =    'BA01'
      * :Nachnahme generieren für BA01
     c                   movel     'BA05'        rfvsat
     c                   movel     'BA05'        #rfvsat           4
     c                   endif
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
     c                   movel     LBPCFIRM      TPFIRM
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
     c                   movel     LBPCFIRM      TPFIRM
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
     c                   movel     LBPCFIRM      TPFIRM
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
     c                   movel     LBPCFIRM      TPFIRM
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
     C     k_txbe01      SETLL     txbe01
     C                   DO        *HIVAL
     C     k_txbe01      READE     txbe01                                 91
     C   91              LEAVE
     C                   if        TBDRK1 = 'M'
     c                   if        AKKDNR = '055278'
     c                   eval      TBSPCD = 'I'
     c                   endif
     c                   if        AKKDNR = '040631' or
     c                             AKKDNR = '001887' or
     c                             AKKDNR = '078678' or
     c                             AKKDNR = '002511' or
     c                             AKKDNR = '015177' or
     c                             AKKDNR = '062465' or
     c                             AKKDNR = '078146' or
     c                             AKKDNR = '009969' or
     c                             AKKDNR = '040631'
     c                   eval      TBSPCD = 'E'
     c                   endif
     c                   if        AKKDNR = '088505'
     c                   eval      TBSPCD = 'F'
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
      * :Informationen zum Spediteur
     c* Avisierung   TTXTSC     'AVIS'
     c* Avisierung   THNTX1     'Bitte telefonisch avisieren 0228/471112'
     c* Avisierung   TTXA       '   '
     c* Hebebühne    TTXTSC     'HEB '
     c* Hebebühne    THNTX1     'Bitte mit Hebebühne anliefern'
     c* Hebebühne    TTXA       '   '
     c* Fixtermin    TTXTSC     'FIX '
     c* Fixtermin    THNTX1     'JJJJMMTT HH:MM:SS'
     c* Fixtermin    TTXA       '   '
     c* Fixterm. Bis TTXTSC     'FIXBIS'
     c* Fixterm. Bis THNTX1     'JJJJMMTT HH:MM:SS'
     c* Fixterm. Bis TTXA       '   '
     c* Fixterm. AB  TTXTSC     'FIXAB '
     c* Fixterm. AB  THNTX1     'JJJJMMTT HH:MM:SS'
     c* Fixterm. AB  TTXA       '   '
     c* Freitext AB  TTXTSC     'FREI  '
     c* Freitext AB  THNTX1     'Anlieferung Mo-Fr  12:00 - 17:00 Uhr'
     c* Freitext AB  TTXA       '   '
     C*-------------------------------------------------------------------------
     C*
     C     sr_txbe01_    BEGSR
     C*
     C                   z-add     LBPCPOSI      #LBPCPOSI         4 0
      * :lesen Lieferscheindaten
     c     k_txbe01_     klist
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
     c                   eval      tbtcde   =    'TXSP'
     c
     C     k_txbe01_     SETLL     txbe01
     C                   DO        *HIVAL
     C     k_txbe01_     READE     txbe01                                 91
     C   91              LEAVE
     C                   if        %subst(TBTEXT:1:3) ='301'
     c                   clear                   p00004
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      tfir  = rfir
     c                   eval      tbtnr = rbtnr
     c                   eval      telj  = relj
     c                   eval      tvsnr = rvsnr
     c                   eval      tvspn = rvspn
     c*******************************************************
     C* Hier die Routinen zur Ermittlung der Hinweistexte aus Trend
     c*******************************************************
     c* Avisierung   THNTX1     'Bitte telefonisch avisieren 0228/471112'
     c* Avisierung   TTXA       'ORG'
     c                   eval      ttxtsc = 'AVIS '
     c                   eval      TTXTA  = 'ORG'
     c                   eval      thntx1 = '' +
     c                                      %triml(%subst(TBTEXT:5:60))
     c                   eval      tsts = 'A'
     c                   exsr      d940
     c                   else
     C                   if        %subst(TBTEXT:1:3) ='311'
     c                   clear                   p00004
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      tfir  = rfir
     c                   eval      tbtnr = rbtnr
     c                   eval      telj  = relj
     c                   eval      tvsnr = rvsnr
     c                   eval      tvspn = rvspn
     c                   eval      ttxtsc = 'HEB  '
     c                   eval      TTXTA  = 'ORG'
     c                   eval      thntx1 = '' +
     c                                     %triml(%subst(TBTEXT:5:60))
     c                   eval      tsts = 'A'
     c                   exsr      d940
     c                   else
     c                   clear                   p00004
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      tfir  = rfir
     c                   eval      tbtnr = rbtnr
     c                   eval      telj  = relj
     c                   eval      tvsnr = rvsnr
     c                   eval      tvspn = rvspn
     c                   eval      ttxtsc = 'FREI '
     c                   eval      TTXTA  = 'ORG'
     c                   movel     TBTEXT        thntx1
     c                   eval      tsts = 'A'
     c                   exsr      d940
     c                   endif
     c                   endif
     C                   ENDDO
     C
      * :Fixtermin generieren für wao8
     c     k_wao802      chain     wao802
     c                   IF        %found(wao802)  and
     c                             WAO8LFTE <> 0
     c                   eval      message='Achtung Fixtermin:' +
     c                                       %char(WAO8LFTE)
     c                   exsr      sr_messag
     c                   clear                   p00004
     c* Übertragen Primärschlüssel aus Paketdatensatz (FRDTN)
     c                   eval      tfir  = rfir
     c                   eval      tbtnr = rbtnr
     c                   eval      telj  = relj
     c                   eval      tvsnr = rvsnr
     c                   eval      tvspn = rvspn
     c                   eval      ttxtsc = 'FIX  '
     c                   eval      TTXTA  = 'ORG'
     c                   eval      thntx1 = '' +
     c                                     %triml(%char(WAO8LFTE))
     c                   eval      tsts = 'A'
     c                   exsr      d940
     c                   endif
     c*
     C     ##_txbe01_    ENDSR
     C*
     C**************************************************************************
      * :eMails aus TXst auf Ebene des Kunden
      * :landen später in die Datei FRDEM bei Rhenania
     C*-------------------------------------------------------------------------
     C*
     C     sr_txst01     BEGSR
     C*
      * :lesen Lieferscheindaten
     c     k_txst01      klist
     c                   kfld                    LBPCFIRM
     c                   kfld                    TTTCDE
     c                   kfld                    AKKDNR
     c
     c                   eval      TTTCDE   =    'TRTX27'
     c
     C     k_txst01      SETLL     txst01
     C                   DO        *HIVAL
     C     k_txst01      READE     txst01                                 91
     C   91              LEAVE
     C                   if        TTDR01 = 'EB' or TTDR02 = 'EB' or
     C                             TTDR03 = 'EB' or TTDR04 = 'EB' or
     C                             TTDR05 = 'EB' or TTDR06 = 'EB' or
     C                             TTDR07 = 'EB' or TTDR08 = 'EB' or
     C                             TTDR09 = 'EB' or TTDR10 = 'EB'
     c                   if        AKKDNR = '040631' or
     c                             AKKDNR = '001887' or
     c                             AKKDNR = '078678' or
     c                             AKKDNR = '002511' or
     c                             AKKDNR = '015177' or
     c                             AKKDNR = '062465' or
     c                             AKKDNR = '078146' or
     c                             AKKDNR = '009969' or
     c                             AKKDNR = '040631'
     c                   eval      TTSPCD = 'E'
     c                   endif
     c                   if        AKKDNR = '088505'
     c                   eval      TTSPCD = 'F'
     c                   endif
     c                   eval      eemtpl = TTSPCD + '_' + 'STD'
     c                   eval      eemail  = TTTEXT
     c*****              eval      eemail  = 'manfred.gang@yahoo.de'
     c                   eval      ests = 'A'
     c                   if        TTUCDE  = 'EMAIL  '
     c                   exsr      d930
     c                   endif
     c                   else
     c                   endif
     C                   ENDDO
     c*
     C     ##_txst01     ENDSR
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
mg005c     k_vssp01      chain     vssp01                             91
mg005c                   IF        %found(vssp01)
mg005c                   else
mg005c                   clear                   VSSPKFZK
mg005c                   endif
mg005c*
mg005C     ##_vssp01     ENDSR
     C*
     C**************************************************************************
      * :Wechsel der Adresse
     C*-------------------------------------------------------------------------
     C*
mg012C     srafad01_     BEGSR
mg012C*
mg012c     afad01_       klist
mg012c                   kfld                    ADFIRM
mg012c                   kfld                    ADAFJJ
mg012c                   kfld                    ADAFNR
mg012c                   kfld                    ADPOSI
mg012c                   kfld                    ADAART
mg012c                   movel     LBPCFIRM      ADFIRM
mg012c                   movel     AMAFJJ        ADAFJJ
mg012c                   movel     AMAFNR        ADAFNR
mg012c                   clear                   ADPOSI
mg012c                   movel     'AFVS'        ADAART
mg012c     afad01_       chain     afad01                             86
mg012c                   IF        %found(afad01)
mg012c                   eval      AMNAM1 =    ADNAM1
mg012c                   eval      AMNAM2 =    ADNAM2
mg012c                   eval      AMNAM3 =    ADNAM3
mg012c                   eval      AMSTRA =    ADSTRA
mg012c                   eval      AMPOLD =    ADPOLD
mg012c                   eval      AMPOLZ =    ADPOLZ
mg012c                   eval      AMWORT =    ADWORT
mg012c                   eval      AMPOFA =    ADPOFA
mg012c                   eval      AMLAND =    ADLAND
mg012c                   eval      AMPOLN =    ADPOLN
mg012c                   endif
mg012c
mg012C     ##_afad01     ENDSR
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
     C*File
     C*-------------------------------------------------------------------------
     C*
     C     sr9900        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ delete from qtemp/FRDGP#
     c/end-exec
     c                   exsr      sr9902
     C                   goto      ##9900
     C
     c/exec sql
     c+ insert into qtemp/FRDGP#
     c+ SELECT        rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,RGVPA, RGVG,
     c+               dec(sum(rgbm*alglmg), 11, 3)/:TEIVPE rgbm,
     c+               dec(sum(rgnm*alglmg), 11, 3)/:TEIVPE rgnm,
     c+               dec(sum(RGNME*alglmg*0), 11, 3) RGNME,
     c+               dec(sum(rgnvo      ), 11, 0)    rgnvo,
     c+               dec(sum(rgmg       ), 11, 3)    rgmg,
     c+             zoned(sum(nds01      ), 03, 0)    nds01,
     c+               dec(sum(alglmg     ), 11, 3)    rmenge
     c+ FROM RHGEFAHRn inner JOIN #AFLPL2 ON rgtenr=altenr
     c+                                  and rgfirm=alfirm
     c+ WHERE ALKMJJ=:qALKMJJ and ALKMNR=:qALKMNR and ALFIRM=:qALFIRM
     c+       and RGGVS<>' ' and RGGVS<>' ' and RGGVV<>' '
     c+ group BY      rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC ,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,
     c+               RGZF, RGBS, RGVPA, RGVG
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*File
     C*-------------------------------------------------------------------------
     C*
     C     sr9902        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ delete from qtemp/FRDGP#2
     c/end-exec

     c/exec sql
     c+ delete from qtemp/FRDGP#
     c/end-exec

     c/exec sql
     c+ insert into qtemp/FRDGP#2
     c+ SELECT        rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,RGVPA, RGVG,
     c+               dec(sum(rgbm*alglmg), 11, 3)        rgbm,
     c+               dec(sum(rgnm*alglmg), 11, 3)        rgnm,
     c+               dec(sum(RGNME*alglmg*0), 11, 3) RGNME,
     c+               dec(sum(rgnvo      ), 11, 0)    rgnvo,
     c+               dec(sum(rgmg       ), 11, 3)    rgmg,
     c+             zoned(sum(nds01      ), 03, 0)    nds01,
     c+               dec(sum(alglmg     ), 11, 3)    rmenge,
     c+               RGZF, RGBS, rgtenr
     c+ FROM ( RHGEFAHRn inner join  #AFLPL2 ON rgtenr=altenr
     c+                                  and rgfirm=alfirm )
     c+ WHERE ALKMJJ=:qALKMJJ and ALKMNR=:qALKMNR and ALFIRM=:qALFIRM
     c+       and RGGVS<>' ' and RGGVS<>' ' and RGGVV<>' '
     c+ group BY      rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC ,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,
     c+               RGZF, RGBS, RGVPA, RGVG, rgtenr
     c/end-exec

     c/exec sql
     c+ update frdgp#2 set rgbm=rgbm/
     c+ (select teivpe from teil01 where rgtenr=tetenr and rgfirm=tefirm)
     c+ where exists
     c+ (select teivpe from teil01 where rgtenr=tetenr and rgfirm=tefirm)
     c/end-exec

     c/exec sql
     c+ update frdgp#2 set rgnm=rgnm/
     c+ (select teivpe from teil01 where rgtenr=tetenr and rgfirm=tefirm)
     c+ where exists
     c+ (select teivpe from teil01 where rgtenr=tetenr and rgfirm=tefirm)
     c/end-exec

     c/exec sql
     c+ insert into qtemp/FRDGP#
     c+ SELECT        rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,RGVPA, RGVG,
     c+               dec(sum(rgbm), 11, 3)        rgbm,
     c+               dec(sum(rgnm), 11, 3)        rgnm,
     c+               dec(sum(RGNME), 11, 3) RGNME,
     c+               dec(sum(rgnvo), 11, 0)    rgnvo,
     c+               dec(sum(rgmg), 11, 3)    rgmg,
     c+             zoned(sum(nds01), 03, 0)    nds01,
     c+               dec(sum(rmenge), 11, 3)    rmenge
     c+ FROM  frdgp#2
     c+ group BY      rgfirm,RGGVS,RGGVV,RGUNR,RGUPN,RGKL,
     c+               RGBFK,RGKFC ,RGTBC,RGME,RGWGK,
     c+               RGCT1,RGCT2,RGCT3,
     c+               RGZF, RGBS, RGVPA, RGVG
     c/end-exec


     C     ##9902        ENDSR

     C**************************************************************************
     C*File
     C*-------------------------------------------------------------------------
     C*
     C     sr9902x       BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ delete from qtemp/FRDGP#2
     c/end-exec

     c/exec sql
     c+ delete from qtemp/FRDGP#
     c/end-exec

     C     ##9902x       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##9999
     c/end-exec


     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C
     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------
      /copy yqrpglesrc,eqsrpgcsin
