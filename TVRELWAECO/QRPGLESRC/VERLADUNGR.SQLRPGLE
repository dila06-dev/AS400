     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*      Gang 05/2025                                        *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*create index tvrelwaeco/#VERLADUNl on                     *
     F*tvrelwaeco/#VERLADUNG (PKANR1, PKANRP, PKANRU)            *
     F*      where status in (' ', '77', '96', '97')             *
     F* AKANR1 =  'K012025153806' kaputt                         *
     F*                                                          *
     F* SELECT * FROM #verladung WHERE AKLM1 =28 and PKPKNR=     *
     F*    '105019411'                                           *
     F* SELECT * FROM #verladung WHERE AKLM1 =28 and PKVENR      *
     F* ='340157040002402666'                                    *
     F*                                                          *
     F*insert into tvpf/afvs
     F*SELECT * FROM afvsiss a WHERE a.AVKMJJ =2025 and a.AVJDAT > 20250808
     F*                                         and a.AVKDLI =  '92214'
     F*    and a.AVKMJJ not in (select b.AVKMJJ  from afvs01 b where
     F*                         a.avkmnr=b.avkmnr and
     F*                         a.AVJDAT=b.AVJDAT and
     F*                         a.AVKDLI=b.AVKDLI and
     F*                         b.AVKDLI =  '92214')
     F* Achtung Rückführung ggf. auf level Artikel in DESASV     *
     F* SELECT                                                   *
     F*     PKIDEN,                                              *
     F*     PKMPKN,                                              *
     F*     PKPKNR,                                              *
     F*     SUBSTR(PKVENR, 9, 14) AS PKVENR,                     *
     F*     SUM(p.PKPMEN) AS PKPMEN,pkanrp                       *
     F* FROM                                                     *
     F*     DOMDATV7.psaveak a                                   *
     F* JOIN                                                     *
     F*     DOMDATV7.ppaket p                                    *
     F*     ON a.AKFIRM = p.PKFIRM                               *
     F*     AND a.AKAPN = p.PKAPN                                *
     F* WHERE                                                    *
     F*     AKANR1 = 'K012025202212' in                          *
     F*     AND PKIDEN <> ' '                                    *
     F* GROUP BY                                                 *
     F*     PKIDEN,PKPKNR,PKMPKN,PKVENR,pkanrp                   *
     F*                                                          *
     F*                                                          *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)

     f#VERLADUNGup   e             disk    RENAME(#VERLADUNG:PHY01R)
     f**VERLSCAN  if a e             disk    RENAME(VERLSCANR :PHY02R)
     f**                                     USROPN
     faflp04    if   e           k disk
     fafko01    if   e           k disk
     fafpo01    if   e           k disk
     fifap02    if   e           k disk
     fafsp01    uf a e           k disk
     fafspIss   uf a e           k disk    RENAME(AFSP1:afspIss1)
     fafvs01    uf a e           k disk
     fafvsIss   uf a e           k disk    RENAME(afvs1:afvsIss1)
     fvsbd01    if   e           k disk
     fafkm01    uf a e           k disk

     DDate             S               D   DATFMT(*EUR)
     DTimeT            S               T   TIMFMT(*EUR)
     DPLZHelp          S              5A
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     d*firma            s                   like(xprs010)

     Dcode             C                   CONST('²³°§µÖÜÄòÉ')
     Dkonv             C                   CONST(X'40404040404040404040')
     D**konv             C                   CONST(X'B2B3B0A7B5D6DCC4F2C9')
      *                                            ² ³ ° § µ Ö Ü Ä ò É

     D*-------------------------------------------------------------------------
     Dtstampi          S               Z
     Ddatum            S               D
     Ddatum2           S               D
     Dzeit             S               T
     Dpos              s             10i 0
     D
     D*-------------------------------------------------------------------------
       // ______________________________________________________________________
       // dummy512
       // ______________________________________________________________________
     D DUMMY512        PR                  ExtPgm('DUMMY512')
     D p_md                         256a
     D p_MSG                          7a
     D p_MSGF                        10a
     D p_PRINT                       10a
     D p_OUTFIL                      10a
     D p_LIB                         10a
     D P_REPADD                      10a


      // dummy512
      //------------------------------------------------------------------------
      // p_md            s            001a   inz
      //                                     dim(256)
     D p_md            s            256a   inz
     D p_MSG           s              7a   inz
     D p_MSGF          s             10a   inz
     D p_PRINT         s             10a   inz
     D p_OUTFIL        s             10a   inz
     D p_LIB           s             10a   inz
     D P_REPADD        s             10a   inz
     D p_inFIL         s             22a   inz
     D p_out           s              9a   inz


      // qcmdexc
      //------------------------------------------------------------------------
     D Wrk             DS                  Qualified inz
     D Var1                         460A   inz(' ')
     D L               s              9  0
     D
     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            460A   varying

     Dstatus#          s            132A   inz
     Dstring_file      s             60A   inz
     Dsuffix           s             06A   inz
     Dtransfer         s             30A   inz
     Derr_msg          s              1a   inz
     D§records         s              9s 0 inz

     I/COPY ##E
     I/COPY ##I001
     I*------------------------------------------------------------------------
     IAFKO1
     I              AKFIRM                      #akfirm
     I*------------------------------------------------------------------------

     C*-------------------------------------------------------------------------
b
     C*    *ENTRY        PLIST
     C*                  PARM                    #version         10
     C*                  PARM                    modus             1
     C*                  PARM                    rtncode           1

     I*-------------------------------------------------------------------------

     c                   if        PKANRP > 0
     c                             or      ( AKLSNR =' '
     c                             and       AKANR1 <>'x012025210001')
     c                   if        status = '  ' or
      * :AFSP                               96
     c                             status = '96' or
      * :AFVS                               97
     c*  20.10.2025 status 97      status = '97' or      bei 97 wird
     c*  20.10.2025 inaktiv        status = '97' or      jetzt ein neuer Satz
     c*  20.10.2025 gesetzt        status = '97' or      geschrieben
      * :VSBD unbekannter Spediteur         77
     c                             status = '77'
      * :Selektion streng
     c                   if        AKANR1 <>'x012025195344'
     c*                            AKANR1 = 'K012025169563' or
     c*                            AKANR1 = 'K012025170443' or
     c*                            AKANR1 = 'K012025153806' or
     c*                  If        AKANR1 = 'K012025170953'
     c*                            AKANR1 = 'K012025161241'

     C     *DTAARA       DEFINE                  $VERLADUNG       10 0
     C  n25*lock         IN        $VERLADUNG
     C  n25              eval      $VERLADUNG = $VERLADUNG + 1
     C  n25              out       $VERLADUNG
      * :PKPKNR in Bezug auf Spedition eindeutig, in Bezug auf Pakete ggf. nicht
      * :siehe afsp Kopfsätze
     c                   seton                                        25
      * :zur Sicherheit keine updates
     c                   setoff                                       66
     c                   if        AKSSC <> ' '
     c                   seton                                        66
     c                   endif
      * :Komm# wird unterschiedlich Achtung relevant AFVS01
     c                   if        pKANR1   <>   #pKANR1
      * :update Gesamtvolumen in afsp01 wenn pKANR1# <> 0 Erstsatz und #pKANR1> ' '
     c                   z-add     1             pKANR1#           4 0
     c                   else
     c                   eval      pKANR1# = pKANR1# + 1
     c                   endif
     c                   movel     pKANR1        #pKANR1          25
     c                   exsr      sr1000
     C                   if        *in91='0' and
     C                             *in92='0' and
     C                             *in93='0' and
     C                             *in94='0' and
     C                             *in98='0'
     C**********                   *in95='0'
     c                   exsr      sr2000
     C                   endif
     c                   eval      status = '10'
     c   95              eval      status = '95'
     c   97              eval      status = '97'
     c   98              eval      status = '98'
     c   96              eval      status = '96'
     c   94              eval      status = '94'
     c   93              eval      status = '93'
     c   92              eval      status = '92'
     c   91              eval      status = '91'
      * :schwerer Fehler Spediteur nicht definiert
     c   77              eval      status = '77'
     c                   eval      #cc = $VERLADUNG
     c                   update    phy01r

     c                   endif
     c                   endif
     c                   endif

     clr                 eval      status#='Ende VERLADUNGR  Daten ermitteln'
     clr                 exsr      SR_log

     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)  über aflp04  PKANR1  K012018288118
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      * :Artikeldaten
      * :in jedem Fall lt. Trend Satz vorhanden
     c     keysr_aflp    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c                   kfld                    ALKMPO
     c
      * :korrekter Auftrag ?    -0-      *in91 Fehler
      /Free
         monitor;
         *in91 ='0';
         if %dec(%subst(PKANR1:03:04):4:0) <> *zero;
         endif;
         on-error *all;
         // nicht numerisch
                  *in91 ='1';
         endmon;
      /End-Free
     c                   if        *in91 = '0'
     C                   eval      ALFIRM  = '01'
     C                   eval      ALKMJJ  = %dec(%subst(PKANR1:04:04):4:0)
     C                   eval      ALKMNR  = %subst(PKANR1:08:06)
     C                   move      PKANRP        ALKMPO
      * :Lieferscheinpositionen -1-      *in92 Fehler
      * :Besonderheit Eingaben per Hand ( AKLSNR =' ' PKANRP=0, daher
      * :             auf Standard 10 setzten)
     C                   if        AKLSNR =' '
     C                   z-add     10            ALKMPO
     C                   endif
     c     keysr_aflp    chain     AFLP04                             92
     c   92              clear                   AFLP1
     C*
      * :Kopfdaten Auftrag      -2-      *in93 Fehler
     c     keysr_afko    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR

     c                   if        *in92 = '0'
     c     keysr_afko    chain     afko01                             93
     c   92              clear                   afko1
     c   93              clear                   afko1
     c
     C*
      * :lesen bezug Afpo       -3-      *in94 Fehler
     c     keysr_afpo    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    ALAFPO
     C*
     c     keysr_afpo    chain     afpo01                             94
     c   92              clear                   afpo1
     c   93              clear                   afpo1
     c   94              clear                   afpo1
     C*
      * :lesen bezug Interface ifap -4-  *in95 Fehler !!!!! APAFPO !!!!!
     c     keysr_ifap    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALAFJJ
     c                   kfld                    ALAFNR
     c                   kfld                    APAFPO
     C*
     c     keysr_ifap    chain     ifap02                             95
     c   92              clear                   ifap1
     c   93              clear                   ifap1
     c   94              clear                   ifap1
     c   95              clear                   ifap1
     c   95              clear                   IFAPIFPO
     C*
      * :lesen bezug Interface afsp -5-  *in96 Kopfsatz ok
     c     keysr_afsp    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c                   kfld                    ASKART
     c                   eval      ASKART  = 'KMNR'
     C*
     c     keysr_afsp    chain     afsp01                             96
     c   92              clear                   afsp1
     c   93              clear                   afsp1
     c   94              clear                   afsp1
     c***95              clear                   afsp1
     c   96              clear                   afsp1
     C*
      * :lesen bezug Interface afvs -6- *in97 Positionssätze ok ?
     c     keysr_afvs    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c                   kfld                    #AKLM1
     c*                  kfld                    ALKMPO
     c                   z-add     pKANR1#       #AKLM1            4 0
     C*
     c     keysr_afvs    chain     afvs01                             97
     c   92              clear                   afvs1
     c   93              clear                   afvs1
     c   94              clear                   afvs1
     c***95              clear                   afvs1
     c***96              clear                   afvs1
     c   97              clear                   afvs1
     C*
      * :lesen Versandbedingung korrekt?
      * :lesen Kopfsatz afSP
      * :lesen Positionen für Lieferungen afVS
     C                   exsr      sr_vsbd
     C*
     C                   endif
     C                   endif
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
      * :Einzelsatz Artikeldaten(Lines)
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
      * :in jedem Fall lt. Trend
     c* n95              eval      LINENUM   = IFAPIFPO
     c*  95              eval      LINENUM   = ALAFPO
     c                   eval      #ALfirm   = ALfirm
     c                   eval      #ALRAKD   = ALRAKD
     c                   eval      #ALAFJJ   = ALAFJJ
     C                   eval      #ALAFPO   = ALAFPO
     C                   eval      #ALDBKD   = ALDBKD
     C                   eval      #ALKDNR   = ALKDNR
     C                   eval      #ALAFNR   = ALAFNR
     C                   eval      #ALKMJJ   = ALKMJJ
     C                   eval      #ALKMPO   = ALKMPO
     C                   eval      #ALLIJJ   = ALLIJJ
     C                   eval      #ALLIPO   = ALLIPO
     C                   eval      #ALRGJJ   = ALRGJJ
     C                   eval      #ALWKNR   = ALWKNR
     C                   eval      #ALLSDA   = ALLSDA
     C                   eval      #ALKMNR   = ALKMNR
     C                   eval      #ALLINR   = ALLINR
     C                   eval      #ALRGNR   = ALRGNR
     C                   eval      #ALREDA   = ALREDA
     C                   eval      #ASSPED   = ASSPED
     C                   eval      #AVANZA   = AVANZA
     C                   eval      #AVGWBR   = AVGWBR
     C                   eval      #AVGWNT   = AVGWNT
     C                   eval      #AVVOLU   = AVVOLU
     C                   eval      #AVTENR   = AVTENR
     C                   eval      #AVKZ01   = AVKZ01
     C                   eval      #AVKLKZ   = AVKLKZ
     C                   eval      #AVKZ04   = AVKZ04
     C                   eval      #AVABJJ   = AVABJJ
     C                   eval      #AVABNR   = AVABNR
     C                   eval      #AVKDLI   = AVKDLI
     C                   eval      #AVABMS   = AVABMS
     C                   eval      #AVTMST   = AVTMST
     C                   eval      #AVDPDN   = AVDPDN
     C                   eval      #AVFRIN   = AVFRIN
     C                   eval      #AVDSKZ   = AVDSKZ
     C                   eval      #AVDSDF   = AVDSDF
     C                   eval      #AVDSUE   = AVDSUE
     C                   eval      #AVPAKN   = AVPAKN
     C                   eval      #AVHINW   = AVHINW
     C                   eval      #IFAPIFFI = IFAPIFFI
     C                   eval      #IFAPIFNR = IFAPIFNR
     C                   eval      #IFAPERDA = IFAPERDA
     C                   eval      #IFAPUEDA = IFAPUEDA
     C                   eval      #IFAPIFPO = IFAPIFPO
     C                   eval      #IFAPEZEI = IFAPEZEI
     C                   eval      #IFAPUEUZ = IFAPUEUZ
     C                   eval      #IFAPKWTE = IFAPKWTE
     C                   eval      #IFAPLFTE = IFAPLFTE
     C                   eval      #IFAPTENR = IFAPTENR
     C                   eval      #IFAPBSMG = IFAPBSMG
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
      * :Versandbedingung prüfen aus LFS
     C*-------------------------------------------------------------------------
     C*
     C     sr_vsbd       BEGSR
     C*
      * :muss in Trend sein   SC40631_RB                      Fehlerfall IN77
     c     vsbd01_key    klist
     c                   kfld                    ALFIRM
     c                   kfld                    VBVSBD
     C*
     c                   eval      VBVSBD = %subst(AKVART:01:03)
     C*
     c     vsbd01_key    chain     vsbd01                             77
      * :Versandbedingung korrekt? muss in Trend sein !!!!!
      * :und nur beim ersten Satz
     C                   if        pKANR1# =     1
     C                   if        *in77 = '1' and
     C                             *in96 = '0'
     C   66              delete    AFSP1
     C                   endif
     C                   endif
      * :AFSP Satz mit richtigem ASSPED? bei Kopfsatz
      * :ASSPED  <> VBSPED wird hier korrigiert
     C                   if        pKANR1# =     1
     C                   if        *in77 = '0'
     c                   clear                   afsp1
     c                   exsr      sr_afsp
      * :update error bei *in55  (kann eigentlich nicht
     c   66              update    afsp1                                55
     c                   write     afspIss1
     c                   setoff                                       96
     c                   endif
     C                   endif
      * :AFVS Satz mit richtigem AVKDLI? bei jeder einzelnen Sendung ?
      * :AVKDLI  <> VBSPED wird hier korrigiert
     C                   if        *in77 = '0'
     c                   clear                   afvs1
     c                   exsr      sr_afvs
      * :update error bei *in55  (kann eigentlich nicht sein)
      * :20.10.2025 update nur, wenn logisch Satz existent war, gibt Ausnahmen
      * :20.10.2025 wenn Pakete generiert werden ==> afvs1
     c                   if        *in97 = '0'
     c   66              update    afvs1                                55
     c                   endif
     c                   write     afvsIss1
      * :20.10.2025 setoff 97 auf Kommentar gesetzt
      * :20.10.2025 97 wird oben gesetzt auf Ebene AVKMPO bzw. pKANR1# f. chain
      * :20.10.2025 u n d   bei 97 ein write gesetzt, da Satz sonst fehlen würde
     c*** 20.10.2025     setoff                                       97
     c   97              write     afvs1
     c                   endif
     C*
     C     ##_vsbd       ENDSR
     C*
     C**************************************************************************
      * :Speditionsdaten Kopfsatz SELECT * FROM afsp WHERE ASKART ='KMNR'
     C*-------------------------------------------------------------------------
     C*
     C     sr_afsp       BEGSR
     C*
      * :lesen Kommissionierdaten afkm -7- *in98 ok ?
     c     keysr_afkm    klist
     c                   kfld                    ALFIRM
     c                   kfld                    ALKMJJ
     c                   kfld                    ALKMNR
     c     keysr_afkm    chain     afkm01                             98
     c   92              clear                   afkm1
     c   93              clear                   afkm1
     c   94              clear                   afkm1
     c***95              clear                   afkm1
     c***96              clear                   afkm1
     c   97              clear                   afkm1
     c   98              clear                   afkm1
     C*
      * :               pKANR1 Ebene Kommissioniernummer
     C                   movel     pKANR1        #pKANR1          25
      * :               pKPKNR Ebene Sendungsnummer
     C                   z-add     PKPKNR        #PKPKNR           9 0
     C                   clear                   #PKKTL            7 2
     C                   clear                   #PKKTB            7 2
     C                   clear                   #PKKTH            7 2
     C                   clear                   #PKPTYP           3
     C                   clear                   #PKBGEW          14 5
     C                   clear                   #PKNGEW          14 5
     C                   clear                   #PKTARA          14 5
     C                   clear                   #asvolu          14 5
     C*
      * : pKANR1 Ebene Kommissioniernummer  !!!!
     c/exec sql
     c+ SELECT  zoned(sum(PKBGEW), 14, 5),
     c+         zoned(sum(PKNGEW), 14, 5),
     c+         zoned(sum(PKTARA), 14, 5),
     c+         zoned(sum(PKKTL*PKKTB*PKKTH/1000000), 14, 5)
     c+ into   :#PKBGEW, :#PKNGEW, :#PKTARA, :#asvolu
     C+ from tvrelwaeco/#verladung
     C+ WHERE pKANR1 = :#pKANR1 and PKANRP = 0
     c/end-exec
     C*
     C                   eval      ASLOCK     = *blank
     C                   eval      ASJNAM     = §§§job
     C                   eval      ASJDAT     = %dec(%char(%date():*iso0):8:0)
     C                   eval      ASJZEI     = %dec(%char(%time():*iso0):6:0)
     C                   eval      ASUSER     = §§§usr
     C                   eval      ASPROG     = §§§pgm
     C                   eval      ASBIBL     = §§§LIB
      * :ALFIRM Lieferschein Firma
     C                   eval      ASFIRM     = ALFIRM
      * :ALKMJJ Lieferschein KommissionierJahr
     C                   eval      ASJAHR     = ALKMJJ
      * :ALKMNR Lieferschein Kommissioniernummer
     C                   eval      ASNUMM     = ALKMNR
     C                   eval      ASKART     = 'KMNR'
      * :VBSPED Spediteur/Kunde
     C                   eval      ASSPED     = VBSPED
     C                   eval      ASPENR     = ASPENR
     C                   eval      ASSTAT     = ASSTAT
      * :ALKDNR Kunden
     C                   eval      ASKDNR     = ALKDNR
     C                   eval      ASVSNR     = ASVSNR
      * :ALAFJJ Auftragsjahr
     C                   eval      ASAFJJ     = ALAFJJ
      * :ALAFNR Auftragsnummer
     C                   eval      ASAFNR     = ALAFNR
     C                   eval      ASTOUR     = ASTOUR
     C                   eval      ASKOR1     = ASKOR1
     C                   eval      ASKOR2     = ASKOR2
      * :ALAFNR Kom_datum aus AFKM01
     C                   eval      ASKMDA     = AMKMDA
     C                   eval      ASSPDA     = ASSPDA
     C                   eval      ASSUDA     = ASSUDA
      * :ASGSAZ Ges-Anz. Verp
     C                   eval      ASGSAZ     = #PKTARA
      * :ASGSGW Ges-Gw. Br. kg
     C                   eval      ASGSGW     = #PKBGEW
      * :ASEDVG Ges-Gw.berechn
     C                   eval      ASEDVG     = #PKNGEW
     C                   eval      ASINCD     = ASINCD
     C                   eval      ASKZ01     = ASKZ01
     C                   eval      ASVSKZ     = ASVSKZ
     C                   eval      ASKZ03     = ASKZ03
      * :ASVOLU Ges-Volumen
     C                   eval      ASVOLU     = #ASVOLU
      * :ASWKNR werk aus AFKM01
     C                   eval      ASWKNR     = AMWKNR
     C                   eval      ASTEXT     = ASTEXT
      * :AKLM1  Anzahl Paletten
     C                   if        AKLM1      = 0
     C                   eval      ASPLAZ     = 1
     C                   else
     C                   eval      ASPLAZ     = AKLM1
     C                   endif
     C                   eval      ASTENR     = ASTENR
     C                   eval      ASSDJJ     = ASSDJJ
     C                   eval      ASSDNR     = ASSDNR
     C                   eval      ASRMDA     = ASRMDA
     C                   eval      ASLFNR     = ASLFNR
     C                   eval      ASPE2R     = ASPE2R
     C                   eval      ASPE3R     = ASPE3R
     C                   eval      ASFREX     = ASFREX
     C
     C     ##_afsp       ENDSR
     C*
     C**************************************************************************
      * :Speditionsdaten Positionen SELECT * FROM afvs
     C*-------------------------------------------------------------------------
     C*
     C     sr_afvs       BEGSR
     C*
      * :               pKANR1 Ebene Kommissioniernummer
     C                   movel     pKANR1        #pKANR1          25
      * :               pKPKNR Ebene Sendungsnummer
     C                   z-add     PKPKNR        #PKPKNR           9 0
     C                   clear                   #PKKTL            7 2
     C                   clear                   #PKKTB            7 2
     C                   clear                   #PKKTH            7 2
     C                   clear                   #PKPTYP           3
     C                   clear                   #PKBGEW          14 5
     C                   clear                   #PKNGEW          14 5
     C                   clear                   #PKTARA          14 5
     C                   clear                   #asvolu          14 5
     C                   clear                   #PKKTB            7 2
     C                   clear                   #PKKTL            7 2
     C                   clear                   #PKKTH            7 2
     C*
      * : pKPKNR Ebene Sendungsnummer        !!!
      * : es darf eigentlich nur ein Satz existieren
     c/exec sql
     c+ SELECT  zoned(sum(PKBGEW), 14, 5),
     c+         zoned(sum(PKNGEW), 14, 5),
     c+         zoned(sum(PKTARA), 14, 5),
     c+         zoned(sum(PKKTL*PKKTB*PKKTH/1000000), 14, 5),
     c+         dec(max(PKKTL), 07, 2),
     c+         dec(max(PKKTB), 07, 2),
     c+         dec(max(PKKTH), 07, 2)
     c+ into   :#PKBGEW, :#PKNGEW, :#PKTARA, :#asvolu,
     c+        :#PKKTL,  :#PKKTB,  :#PKKTH
     C+ from tvrelwaeco/#verladung
     C+ WHERE pKPKNR = :#pKPKNR and PKANRP = 0
     c/end-exec
     C*
     C                   eval      AVLOCK     = *blank
     C                   eval      AVJNAM     = §§§job
     C                   eval      AVJDAT     = %dec(%char(%date():*iso0):8:0)
     C                   eval      AVJZEI     = %dec(%char(%time():*iso0):6:0)
     C                   eval      AVUSER     = §§§usr
     C                   eval      AVPROG     = §§§pgm
     C                   eval      AVBIBL     = §§§LIB
      * :ALFIRM Lieferschein Firma
     C                   eval      AVFIRM     = ALFIRM
      * :ALKMJJ Lieferschein KommissionierJahr
     C                   eval      AVKMJJ     = ALKMJJ
      * :ALKMNR Lieferschein Kommissioniernummer
     C                   eval      AVKMNR     = ALKMNR
      * :       Paketnummer laufende  in Bezug auf Komm#
     C                   eval      AVKMPO     = pKANR1#
      * :       Kommissioniernummer numerisch
     C                   eval      AVKMNN     = %dec(AVKMNR:6:0)
     C                   eval      AVFR01     = AVFR01
      * :       Anz.Packmittel
     C                   eval      AVANZA     = AKLM1+AKLM2+AKLM3+
     C                                          AKLM4+AKLM5+AKLM6
      * :       Gewicht brutto
     C                   eval      AVGWBR     = #PKBGEW
      * :       Gewicht netto
     C                   eval      AVGWNT     = #PKNGEW
      * :       Volumen
     C                   eval      AVVOLU     = #asvolu
      * :       Packmittelnummer
     C                   eval      AVTENR     = AKLMT1
     C                   if        PKPTYP  <> *blank
     C                   eval      AVTENR     = PKPTYP
     C                   endif
      * :       Hinweis +Servicecode
     C                   eval      AVKZ01     = AKSSC
     C                   eval      AVKLKZ     = 'L'
     C                   eval      AVKZ04     = AVKZ04
     C                   eval      AVABJJ     = AVABJJ
     C                   eval      AVABNR     = AVABNR
      * :VBSPED Spediteur/Kunde
     C                   eval      AVKDLI     = VBSPED
     C                   eval      AVABMS     = %subst(%char(#PKKTL):1:3) +
     C                                          ' ' +
     C                                          %subst(%char(#PKKTB):1:3) +
     C                                          ' ' +
     C                                          %subst(%char(#PKKTh):1:3)
     C
      * :Datum der Verladung Tag/Zeit
     C                   eval      AVTMST     = AVTMST
     C                   eval      AVTMST     = AKDTL*1000000+AKTIL
     C                   if        AVTMST     = *zero
      * :Datum der Packzeit wenn keine Verladung
     C                   eval      AVTMST     = PKDTB*1000000+PKTIB
     C                   endif
      * :       Paket-Nr (LFS)
     C                   movel     PKPKNR        AVDPDN
     C                   eval      AVFRIN     = AVFRIN
     C                   eval      AVDSKZ     = AVDSKZ
     C                   eval      AVDSDF     = AVDSDF
     C                   eval      AVDSUE     = AVDSUE
      * :       VS-Gebinde-Nr  08.08.2025 Anpassung ab Stelle 9 und nächsten 14
     C**********         eval      AVPAKN     = PKVENR
     C                   clear                   AVPAKN
      * :       DPD Sonderegelung 92214
     C                   eval      AVPAKN     = %subst(%char(PKVENR):9:14)
     C                   if        AVKDLI    <> '92214     '
     C                   clear                   AVPAKN
     C                   eval      AVPAKN     = PKVENR
     C                   endif
      * :       Hinweis + beteiligte Positionen der Bestellung
     C                   eval      AVHINW     = 'Bestellpos: '    +
     C                                          %char(INPAKET)
     C
     C*
     C     ##_afvs       ENDSR
     C*
     C**************************************************************************
     C*
     C     *inzsr        BEGSR
     C*
     c                   eval      status#='Start VERLSCANR  Daten ermitteln'
     c                   exsr      SR_log
     C*
     C                   TIME                    Date
     C                   TIME                    Timet
     c*                  z-add     1             firma
     C                   seton                                        30
     C
     C*    *DTAARA       DEFINE                  unique_ff        10 0
     C*    *lock         IN        unique_ff
     C
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   CONTINUE
     c/end-exec
     c/exec sql
     C
     c+ select current timestamp, current date, current date -365 day,
     c+        current time
     c+ into   :tstampi, :datum, :datum2, :zeit
     c+ from   sbghel00
     c/end-exec
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
       //Bereinigung zeitlich in trend ok aber noch nicht verladen
     c/exec sql
     c+ update afvs01 set  AVPAKN = 'in loading status'
     c+ WHERE AVKMJJ > 2024 and avprog='WAIFKMST'
     c+                     and AVPAKN <> 'in loading status'
     c+                     and AVFIRM ='01'
     c+                     and AVKDLI ='92214'
     c/end-exec

       //DOMDATV7  TSTDATV7   PKVENR Achtung Sortierung PKANR1, pkvenr
       //Achtung abhängige Komnummern beachten unter pKANR1
     c/exec sql
     c+ insert into tvrelwaeco/#verladung
     c+ SELECT AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+        AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,
     c+        AKPLZ,AKLM1,AKKG1,AKLMT1,AKLM2,AKKG2,AKLMT2,AKLM3,
     c+        AKKG3,AKLMT3,AKLM4,AKKG4,AKLMT4,AKLM5,AKKG5,AKLMT5,
     c+        AKLM6,AKKG6,AKLMT6,PKKTL,PKKTB,PKKTH,PKPTYP,
     c******   AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,     PKANRP,
     c+        AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1, max(PKANRP) pkanrp,
     c+        max(PKANRU) pkanru, PKKDNR,max(PKIDEN) pkiden,
     c+        max(PKEAN) pkean,
     c+        dec(sum(PKPMEN), 13, 3) PKPMEN,
     c+        dec(sum(PKSMEN), 13, 3) PKSMEN,
     c+        dec(sum(PKEGEW), 13, 3) PKEGEW,
     c+        dec(sum(PKBGEW), 14, 5) PKBGEW,
     c+        dec(sum(PKNGEW), 14, 5) PKNGEW,
     c+        dec(sum(PKTARA), 14, 5) PKTARA,
     c+        PKPKNR,PKVENR,AKSSC,max(PKDTB) pkdtb,max(PKTIB) pktiB,
     c+        dec(0, 10) #cc, char('  ', 2) status, current date
     c+        #date, current timestamp #tstamp,
     c+        dec(0, 10) #cc2, char('  ', 2) status2, current date
     c+        #date, current timestamp #tstamp2,
     c+        char(' ', 02) #alfirm, char(' ', 10) #ALDBKD,
     c+        char(' ', 10) #ALRAKD, char(' ', 10) #ALKDNR,
     c+       zoned(0, 4, 0) #ALAFJJ, char(' ', 06) #ALAFNR,
     c+       zoned(0, 4, 0) #ALAFPO,
     c+       zoned(0, 4, 0) #ALKMJJ, char(' ', 06) #ALKMNR,
     c+       zoned(0, 4, 0) #ALKMPO,
     c+       zoned(0, 4, 0) #ALLIJJ, char(' ', 06) #ALLINR,
     c+       zoned(0, 4, 0) #ALLIPO,
     c+       zoned(0, 4, 0) #ALRGJJ, char(' ', 06) #ALRGNR,
     c+        char(' ', 06) #ALWKNR,
     c+       zoned(0, 8, 0) #ALLSDA, zoned(0, 8, 0) #ALREDA,
     c+        char(' ', 10) #ASSPED,
     c+       zoned(0, 4, 0) #AVANZA, zoned(0, 9, 4) #AVGWBR,
     c+       zoned(0, 9, 4) #AVGWNT, zoned(0, 11, 2) #AVVOLU,
     c+        char(' ', 15) #AVTENR, char(' ', 01) #AVKZ01,
     c+        char(' ', 01) #AVKLKZ, char(' ', 02) #AVKZ04,
     c+       zoned(0, 4, 0) #AVABJJ,
     c+        char(' ', 06) #AVABNR, char(' ', 10) #AVKDLI,
     c+        char(' ', 15) #AVABMS, zoned(0, 26, 0) #AVTMST,
     c+        char(' ', 20) #AVDPDN, char(' ', 15) #AVFRIN,
     c+        char(' ', 01) #AVDSKZ, char(' ', 02) #AVDSDF,
     c+        char(' ', 01) #AVDSUE, char(' ', 20) #AVPAKN,
     c+        char(' ', 20) #AVHINW, char(' ', 05) #IFAPIFFI,
     c+        char(' ', 32) #IFAPIFNR, zoned(0, 4, 0) #IFAPIFPO,
     c+       zoned(0, 8, 0) #IFAPERDA, zoned(0, 6, 0) #IFAPEZEI,
     c+       zoned(0, 8, 0) #IFAPUEDA, zoned(0, 6, 0) #IFAPUEUZ,
     c+       zoned(0, 8, 0) #IFAPKWTE,  char(' ', 15) #IFAPTENR,
     c+       zoned(0, 8, 0) #IFAPLFTE, zoned(0, 11, 2) #IFAPBSMG,
     c+       dec(count(*), 04) InPaket
     c+ FROM domdatv7/psaveak,DOMDATV7/ppaket
     c********       AKANR1='K012023102944' and PKKDNR='175000' and
     c********   PKANRP = 0  = Kopf und <> 0   Positionen
     c+ WHERE AKFIRM = pkfirm and AKAPN=pkapn  and
     c+       ((akPSTS ='49' and AKDTL > 0 and
     c+         (date(substr((AKDTL), 1, 4) concat '-' concat
     c+               substr((AKDTL), 5, 2) concat '-' concat
     c+               substr((AKDTL), 7, 2)  ) +2 days ) > current date)
     c+       or
     c+        (akPSTS ='44' and PKDTB > 0 and
     c+         (date(substr((PKDTB), 1, 4) concat '-' concat
     c+               substr((PKDTB), 5, 2) concat '-' concat
     c+               substr((PKDTB), 7, 2)  ) +2 days ) > current date)
     c+       or   AKANR1 in ('x012025167335', 'x012025169563',
     c+                       'x012025170443', 'x012025153806',
     c+                       'x012025170953', 'x012025161241',
     c+                       'x012025170508', 'K012025171745'  ))
     c+       and pkAPN  not in (select pkAPN from tvrelwaeco/#verladung )
     c+ group by AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+       AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,AKPLZ,
     c+       AKLM1,AKKG1,AKLMT1,AKLM2,AKKG2,AKLMT2,AKLM3,AKKG3,AKLMT3,
     c+       AKLM4,AKKG4,AKLMT4,AKLM5,AKKG5,AKLMT5,AKLM6,AKKG6,AKLMT6,
     c*****   PKKTL,PKKTB,PKKTH,AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,PKANRP,
     c+       PKKTL,PKKTB,PKKTH,AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,
     c+              PKKDNR,             PKPKNR,PKVENR,AKSSC,
     c+       PKPTYP  order by PKANR1, pkvenr
     c/end-exec

       //B2B Rückmeldung lowest level der TrackingInfos
     c/exec sql
     c+ insert into tvrelwaeco/TRACK_IFAP
     c+ SELECT PKTOUR,PKVART,PKSSC,substr(PKIDEN, 1, 15) as item,
     c+        PKPKNR,PKVENR,PKPMEN,PKANRP,PKANR1,ALKMJJ,ALKMNR,
     c+        ALKMPO,ALLIJJ,ALLINR,ALLIPO,ALAFJJ,ALAFNR,ALAFPO,
     c+        ALVSBD,ALMAAF,VBSPED,
     c+        PKKDNR,AKDTL,AKTIL,AKGGEW ,PKPTYP,pkAPN,
     c+
     c+        zoned(0, 8, 0) #IFAPUEDA, zoned(0, 6, 0) #IFAPUEUZ,
     c+        char(' ', 15)  #IFAPTENR, zoned(0, 8, 0) #IFAPLFTE,
     c+        zoned(0, 15, 2) #IFAPBSMG,zoned(0, 4, 0) #IFAPAFJJ,
     c+        char(' ', 06)   #IFAPAFNR, zoned(0, 4, 0) #IFAPAFPO,
     c+        zoned(0, 4, 0) #ifapifpo,
     c+        CHAR('  ', 2) AS statusNVE,CURRENT TIMESTAMP AS tstamp
     c+        FROM domdatv7/psaveak,DOMDATV7/ppaket
     c+ JOIN   tvpf.aflp01 b
     c+        ON PKANR1 = ('K01' CONCAT b.ALKMJJ CONCAT b.ALKMNR)
     c+ JOIN   tvpf.vsbd01 c
     c+        ON PKVART = VBVSBD
     c+ WHERE ALLIJJ > 2025 and ALFIRM ='01' and PKANRP<>0
     c+   AND ALLINR not in ('x20089','x20090') and  ALKMPO = PKANRP and
     c+       AKFIRM = pkfirm and AKAPN=pkapn  and  VBFIRM ='01' and
     c+
     c+      ((akPSTS ='49' and AKDTL > 0 and
     c+        (date(substr((AKDTL), 1, 4) concat '-' concat
     c+              substr((AKDTL), 5, 2) concat '-' concat
     c+              substr((AKDTL), 7, 2)  ) +3 days ) > current date)
     c+      or
     c+       (akPSTS ='44' and PKDTB > 0 and
     c+        (date(substr((PKDTB), 1, 4) concat '-' concat
     c+              substr((PKDTB), 5, 2) concat '-' concat
     c+              substr((PKDTB), 7, 2)  ) +3 days ) > current date)
     c+      or   AKANR1 in ('K012025222729', 'K012025222728' ))
     c+ and  pkAPN not in (select v.pkAPN  from tvrelwaeco/TRACK_IFAP v)
     c/end-exec

     c/exec sql
     c+ update      tvrelwaeco/TRACK_IFAP set
     c+ (#IFAPUEDA,#IFAPUEUZ,#IFAPTENR,#IFAPLFTE,
     c+  #IFAPBSMG,#IFAPAFJJ,#IFAPAFNR,#IFAPAFPO,#ifapifpo,statusNVE)=
     c+ (select IFAPUEDA,IFAPUEUZ,IFAPTENR,IFAPLFTE,
     c+         IFAPBSMG,IFAPAFJJ,IFAPAFNR,IFAPAFPO,ifapifpo, '20'
     c+ from ifap01 where IFAPFIRM = '01'   and
     c+                   IFAPAFJJ = ALAFJJ and
     c+                   IFAPAFNR = ALAFNR and
     c+                   IFAPAFPO = ALAFPO and  statusNVE =' ')
     c+ where exists
     c+ (select IFAPUEDA,IFAPUEUZ,IFAPTENR,IFAPLFTE,
     c+         IFAPBSMG,IFAPAFJJ,IFAPAFNR,IFAPAFPO,ifapifpo, '20'
     c+ from ifap01 where IFAPFIRM = '01'   and
     c+                   IFAPAFJJ = ALAFJJ and
     c+                   IFAPAFNR = ALAFNR and
     c+                   IFAPAFPO = ALAFPO and  statusNVE =' ')
     c/end-exec

     c/exec sql
     c+ update tvrelwaeco/TRACK_IFAP
     c+ set statusNVE ='10' where statusNVE ='  '
     c/end-exec


       //Rückmeldung für Kostenermittlung und Abrecchnung
     c/exec sql
     c+ insert into tvrelwaeco/transport
     c+ SELECT AKTOUR,AKVART,AKKDNR,AKLSNR,AKANR1,AKDTL,#ALKDNR,#ALAFJJ,
     c+ #ALAFNR, #ALAFPO, #ALKMJJ, #ALKMNR, #ALKMPO, #ALLIJJ, #ALLINR,
     c+ #ALLIPO ,PKVENR,#ALLSDA, current timestamp as tstamp
     c+                 FROM tvrelwaeco/#verladung WHERE STATUS <> ' ' and
     c+ status <> '92' and  #ALLSDA > 20260000  and AKANR1 not in
     c+ (select AKANR1 b from tvrelwaeco/transport)
     c+ order by #ALAFJJ,#ALLIJJ, #ALLINR
     c/end-exec

      /free
       MONITOR;
       Wrk.var1 =
           'RMVLNK    OBJLNK(''/Lager/Rhenania/Transport.TXT'')' ;
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#='rmvlnk successful removed  Transport             ';
          exsr      SR_log;
       on-error;
          status#='Error by rmvlnk object Transport                 ';
          exsr      SR_log;
       endmon;

      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/Rhenania/Transport.TXT'') '  +
           'DBFILE(TVRELWAECO/TRANSPORT) DBOUTFMT(*TXT) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         l      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#='CVTDBF by copy in directory done                  ';
          exsr      SR_log;
       on-error;
          status#='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free

         eval p_out     =  'TRANSPORT';

       MONITOR;
       Wrk.var1 =
           'CHGAUT OBJ(''/Lager/Rhenania/'+ p_out +''  +
                      '.TXT'') ' +
           'USER(*PUBLIC) DTAAUT(*RWX)                   ' +
           'OBJAUT(*ALL)';
         cmd = %TrimR(Wrk.Var1);
         L      = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
          status#='chgaut successful FILE(TVRELWAECO/TRANSPORT     ';
          exsr      SR_log;
       on-error;
          status#='Error by chgaut object (TVRELWAECO/TRANSPORT    ';
          exsr      SR_log;
       endmon;


     c*****              exsr      sr_hist
     c*****              open      VERLSCAN

     C                   ENDSR

       //-----------------------------------------------------------------------
       //Historie
       //-----------------------------------------------------------------------

     C     sr_hist       BEGSR

       //DOMDATV7  TSTDATV7   PKVENR Achtung Sortierung PKANR1, pkvenr
     c/exec sql
     c+ insert into tvrelwaeco/#verladung
     c+ SELECT AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+        AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,
     c+        AKPLZ,AKLM1,AKKG1,AKLMT1,AKLM2,AKKG2,AKLMT2,AKLM3,
     c+        AKKG3,AKLMT3,AKLM4,AKKG4,AKLMT4,AKLM5,AKKG5,AKLMT5,
     c+        AKLM6,AKKG6,AKLMT6,PKKTL,PKKTB,PKKTH,PKPTYP,
     c+        AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1, max(PKANRP) pkanrp,
     c+        max(PKANRU) pkanru, PKKDNR,max(PKIDEN) pkiden,
     c+        max(PKEAN) pkean,
     c+        dec(sum(PKPMEN), 13, 3) PKPMEN,
     c+        dec(sum(PKSMEN), 13, 3) PKSMEN,
     c+        dec(sum(PKEGEW), 13, 3) PKEGEW,
     c+        dec(sum(PKBGEW), 14, 5) PKBGEW,
     c+        dec(sum(PKNGEW), 14, 5) PKNGEW,
     c+        dec(sum(PKTARA), 14, 5) PKTARA,
     c+        PKPKNR,PKVENR,AKSSC,max(PKDTB) pkdtb,max(PKTIB) pktiB,
     c+        dec(0, 10) #cc, char('  ', 2) status, current date
     c+        #date, current timestamp #tstamp,
     c+        dec(0, 10) #cc2, char('  ', 2) status2, current date
     c+        #date, current timestamp #tstamp2,
     c+        char(' ', 02) #alfirm, char(' ', 10) #ALDBKD,
     c+        char(' ', 10) #ALRAKD, char(' ', 10) #ALKDNR,
     c+       zoned(0, 4, 0) #ALAFJJ, char(' ', 06) #ALAFNR,
     c+       zoned(0, 4, 0) #ALAFPO,
     c+       zoned(0, 4, 0) #ALKMJJ, char(' ', 06) #ALKMNR,
     c+       zoned(0, 4, 0) #ALKMPO,
     c+       zoned(0, 4, 0) #ALLIJJ, char(' ', 06) #ALLINR,
     c+       zoned(0, 4, 0) #ALLIPO,
     c+       zoned(0, 4, 0) #ALRGJJ, char(' ', 06) #ALRGNR,
     c+        char(' ', 06) #ALWKNR,
     c+       zoned(0, 8, 0) #ALLSDA, zoned(0, 8, 0) #ALREDA,
     c+        char(' ', 10) #ASSPED,
     c+       zoned(0, 4, 0) #AVANZA, zoned(0, 9, 4) #AVGWBR,
     c+       zoned(0, 9, 4) #AVGWNT, zoned(0, 11, 2) #AVVOLU,
     c+        char(' ', 15) #AVTENR, char(' ', 01) #AVKZ01,
     c+        char(' ', 01) #AVKLKZ, char(' ', 02) #AVKZ04,
     c+       zoned(0, 4, 0) #AVABJJ,
     c+        char(' ', 06) #AVABNR, char(' ', 10) #AVKDLI,
     c+        char(' ', 15) #AVABMS, zoned(0, 26, 0) #AVTMST,
     c+        char(' ', 20) #AVDPDN, char(' ', 15) #AVFRIN,
     c+        char(' ', 01) #AVDSKZ, char(' ', 02) #AVDSDF,
     c+        char(' ', 01) #AVDSUE, char(' ', 20) #AVPAKN,
     c+        char(' ', 20) #AVHINW, char(' ', 05) #IFAPIFFI,
     c+        char(' ', 32) #IFAPIFNR, zoned(0, 4, 0) #IFAPIFPO,
     c+       zoned(0, 8, 0) #IFAPERDA, zoned(0, 6, 0) #IFAPEZEI,
     c+       zoned(0, 8, 0) #IFAPUEDA, zoned(0, 6, 0) #IFAPUEUZ,
     c+       zoned(0, 8, 0) #IFAPKWTE,  char(' ', 15) #IFAPTENR,
     c+       zoned(0, 8, 0) #IFAPLFTE, zoned(0, 11, 2) #IFAPBSMG
     c+ FROM domdatv7/psaveak2,DOMDATV7/ppaket2
     c********       AKANR1='K012023102944' and PKKDNR='175000' and
     c********   PKANRP = 0  = Kopf und <> 0   Positionen
     c+ WHERE AKFIRM = pkfirm and AKAPN=pkapn  and
     c+       ((akPSTS ='49' and AKDTL > 0 and
     c+         (date(substr((AKDTL), 1, 4) concat '-' concat
     c+               substr((AKDTL), 5, 2) concat '-' concat
     c+               substr((AKDTL), 7, 2)  ) +2 days ) > current date)
     c+       or
     c+        (akPSTS ='44' and PKDTB > 0 and
     c+         (date(substr((PKDTB), 1, 4) concat '-' concat
     c+               substr((PKDTB), 5, 2) concat '-' concat
     c+               substr((PKDTB), 7, 2)  ) +2 days ) > current date)
     c+       or   AKANR1 in ('x012025167335', 'x012025169563',
     c+                       'x012025170443', 'x012025153806',
     c+                       'x012025170953', 'x012025161241',
     c+                       'x012025170508', 'K012025171670'  ))
     c+       and pkAPN  not in (select pkAPN from tvrelwaeco/#verladung )
     c+ group by AKKONZ,AKTOUR,AKFIRM,AKVART,AKAPN,AKDTB,AKAPPO,AKTIB,
     c+       AKSST,AKBHF,AKKDNR,AKLSNR,AKANR1,AKBST1,AKRFNR,AKLAKZ,AKPLZ,
     c+       AKLM1,AKKG1,AKLMT1,AKLM2,AKKG2,AKLMT2,AKLM3,AKKG3,AKLMT3,
     c+       AKLM4,AKKG4,AKLMT4,AKLM5,AKKG5,AKLMT5,AKLM6,AKKG6,AKLMT6,
     c+       PKKTL,PKKTB,PKKTH,AKGGEW,AKDTL,AKTIL,pkAPN,PKANR1,
     c+              PKKDNR,             PKPKNR,PKVENR,AKSSC,
     c+       PKPTYP  order by PKANR1, pkvenr
     c/end-exec


     C     #sr_hist      ENDSR

       //-----------------------------------------------------------------------
       //log report
       //-----------------------------------------------------------------------

     C     sr_log        BEGSR

      /FREE
         clear p_md;
         eval p_md      =  §§§PGM         +
                           §§§JOB         +
                           §§§USR         +
                           status#;

         eval p_msg     =  '#DC0002';
         eval p_msgf    =  *blank;
         eval p_print   =  *blank;
         eval p_outfil  =  'JOB_RUN   ';
         eval p_lib     =  'TVRELWAECO';
         eval p_repadd  =  '*ADD';

         callP DUMMY512(p_md:     p_msg:    p_msgf:     p_print:
                        p_outfil: p_lib:    p_repadd);
         clear status#;

      /End-FREE

     c                   clear                   status#
     C
     C     #sr_log       ENDSR

