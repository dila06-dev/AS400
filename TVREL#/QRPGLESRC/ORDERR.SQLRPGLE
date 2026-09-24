     ******************************************************************
      * PROGRAMMNAME.:FTPI002r          0761/8888038 SZ                       
      * FUNKTION.....:holen Aufträge             010 Burkart
      *               CALL PGM(MODWAOREL/STRTRDREL)
      * Konditionen:  a) feld: ifapIFNR in der ifap entspricht
      *                        Auftrags# im Fremdsystem
      *               b) es besteht Positionstreue zwischen den Systemen
      *
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      * mg01 c   93              exsr      sr2300k
      * mg02     timestamp lesen bei auftragswechsel sr9999
      *
      *****************************************************************

     forderhl1  up   e           k disk
     forderll1  uf   e           k disk

     f#IFAKL1   uf a e           k disk
     f#IFAPL1   uf a e           k disk
     fifad      uf a e           k disk
     fifat      uf a e           k disk
     fifan      uf a e           k disk
     fifed      uf a e           k disk
     fifep      uf a e           k disk
     fwao8      uf a e           k disk

     DDate             S               D   DATFMT(*iso)
     D##date           S               D   DATFMT(*iso)
     Djahr             S              4  0
     Dmonat            S              2  0
     Dtag              S              2  0
     DTime             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     ****
     D EXIFAK        E DS                  INZ
     D RTIFAK        E DS                  INZ
     D*
     I*-------------------------------------------------------------------------
     d d_head          DS                  INZ
     D  §orh310                1      2
     D  §orh315                3      4
     D  §orh316                5      9
     D  §orh400               10     10
     D  §orh420               11     13
     D  §orh430               14     18
     D  §orh440               19     23
     D  §orh410               24     31
     D  §orh450               32     37
     D  §orh460               38     43
     D  §orh470               44     49
     D*                                    prefix('§')

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------

     C     *ENTRY        PLIST
     C                   PARM                    #h030


     C     *LIKE         DEFINE    h030          #h030

     C     *LIKE         DEFINE    IFAKIFFI      $IFAKIFFI
     C     *LIKE         DEFINE    IFAKIFNR      $IFAKIFNR

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C                   seton                                        30
     C                   if        #h030     = 0000003
     C                   movel     'TECCOM   '   §§§usr
     C                   endif
     c                   setoff                                       77
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   seton                                        77
     C                   endif
     C                   if        #h030     =    h030
MG02 c                   exsr      sr9999
     C                   exsr      srlines
     C*                 update Protokoll Header
     c                   exsr      sr2900
     c                   unlock    #IFAKL1
     c                   unlock    #IFAPL1
     c                   unlock    ifad
     c                   unlock    ifat
     c                   unlock    ifan
     c                   unlock    ifed
     c                   unlock    ifep
     c                   unlock    wao8
     c                   exsr      aifak
     c                   if        IFAKIFFI = '00003'
     c                   else
     c                   exsr      GNIFAK
     c                   exsr      message
     C                   endif
     C                   endif

     C**************************************************************************
     C*lesen Positionen aus interface
     C*-------------------------------------------------------------------------
     C*
     C     srlines       BEGSR

     C     KEYlines      KLIST
     C                   KFLD                    h030
     C                   KFLD                    h050

     C     KEYlines      SETLL     orderll1
     C                   DO        *HIVAL
     C     KEYlines      READE     orderll1                               91
     C   91              LEAVE
     C*                 sc # und auftrag müssen identisch sein
     C                   if        l250  <> h030    or
     c                             l040  <> h050
     c                   leave
     c                   else
     c                   exsr      sr1000
     c                   endif
     C                   ENDDO
      *
     C     ##lines       ENDSR

     C**************************************************************************
     C*lesen Kopfsatz in Trend z.B: 88505 und Auftrags# Fremdsystem
     C*lesen Possatz in Trend z.B: 88505 und Auftrags# Fremdsystem und Pos#
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     C     KEYkopf       KLIST
     C                   KFLD                    IFAKIFFI
     C                   KFLD                    IFAKIFNR
     c                   move      h030          ifakiffi
     c                   movel     h050          ifakIFNR
     c     keykopf       chain     #IFAKL1                            92

     C     KEYpos        KLIST
     C                   KFLD                    IFApIFFI
     C                   KFLD                    ifapIFNR
     C                   KFLD                    ifapifpo
     c                   eval      IFApIFFI   =  IFAkIFFI
     c                   eval      ifapIFNR   =  ifakIFNR
     c                   eval      ifapifpo   =  l050

     c     keypos        chain     #IFAPL1                            93

MG02 c****               exsr      sr9999

     C*                 Kopfdaten Trend bei *in92 = '1'
     c   92              exsr      sr2000
     C*                 Sendungsdaten Trend bei *in92 = '1' Ebene 92
     c   92              exsr      sr2200
     C*                 Textdaten Trend bei *in92 = '1' Ebene 92
     c                   setoff                                       202122
     c                   clear                   p                 3 0
     c                   if        h180 = 'H' or h180 = 'F'
     c                   seton                                        20
     c   92              exsr      sr2300
     c                   endif
     c                   if        h200 = 'H' or h200 = 'F'
     c                   seton                                        21
     c   92              exsr      sr2300
     c                   endif
     c                   if        h220 = 'H' or h220 = 'F'
     c                   seton                                        22
     c   92              exsr      sr2300
     c                   endif
     C*                 EDIdaten Trend bei *in92 = '1' Ebene 92
     c   92              exsr      sr2250
     C*                 Sonderinfos für Benelux Ebene kopf
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   clear                   p                 3 0
mg01 c   92              exsr      sr2300k
     c                   endif

     C*                 Positionsdaten Trend bei *in93 = '1'
     c   93              exsr      sr2100
     C*                 Textdaten Trend bei *in93 = '1' Ebene 93
     c                   setoff                                       202122
     c                   if        h180 = 'L'
     c                   seton                                        20
     c   93              exsr      sr2300
     c                   endif
     c                   if        h200 = 'L'
     c                   seton                                        21
     c   93              exsr      sr2300
     c                   endif
     c                   if        h220 = 'L'
     c                   seton                                        22
     c   93              exsr      sr2300
     c                   endif
     C*                 Sonderinfos für Benelux Ebene Position
     c                   if        IFAKIFFI = '15177' or
     c                             IFAKIFFI = '62765'
     c                   clear                   p                 3 0
     c   93              exsr      sr2300p
     c   93              exsr      sr2260
     c                   endif

     c                   if        L110  <>  *blank
     c   93              exsr      sr2280
     c                   endif

     C*                 update Protokoll line
     c                   exsr      sr2800

      *
     C     ##1000        ENDSR

     C**************************************************************************
     C*übergaben Kopf KOPFEBENE Kopfdatei
     C*ifakvsbd  = spediteur/versandbedingung  '014' z.B Hellmann  UK
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
      *
     C*                 Kopfdaten Trend
     c                   clear                   IFAK1
     c                   move      h030          ifakiffi
     c                   movel     date          ifakueda
     c                   movel     zeit          ifakueuz
     c                   movel     date          IFAKERDA
     c                   movel     zeit          IFAKEZEI
     c                   movel     date          ifakJDAT
     c                   movel     zeit          ifakJZEI
     C                   movel     'EDI    '     IFAKKDSB
     C                   movel     §§§usr        IFAkUSER
     C                   movel     §§§pgm        IFAkPROG
     C                   movel     §§§job        IFAkjnam
     C                   movel     §§§LIB        IFAkbibl
      *
     c                   movel     '*  '         ifAKSABE
     c                   if        %subst(h300:57:04) ='BGFS'
     c                   movel     '*  '         ifAKSABE
     c                   endif
     c                   if        IFAKIFFI = '88505'
     c                   movel     '#01'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '40631'
     c                   movel     '#02'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '15177'
     c                   movel     '#03'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '62765'
     c                   movel     '#04'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '55278'
     c                   movel     '#05'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '01887'
     c                   movel     '#06'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '78146'
     c                   movel     '#07'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '08138'
     c                   movel     '#08'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '02921'
     c                   movel     '#09'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '05084'
     c                   movel     '#11'         ifAKSABE
     C                   endif
     c                   if        IFAKIFFI = '42634'
     c                   movel     '#12'         ifAKSABE
     C                   endif
     c                   movel     h050          ifakifnr
     c     ' ':'0'       xlate     h250          h250
     c                   move      h250          ifakafat
     c                   movel     '08 '         ifakafat
     c                   if        IFAKIFFI  = '00003'
     c                   movel     '27 '         ifakafat
     c                   endif
     c                   move      h040          ##h040            6
     c                   movel     ##h040        ifakkdnr
     c                   move      h230          ifaklibd
     c                   move      h060          ifakbeda
     c                   move      h060          ifakafda
     c                   movel     h050          ifakref1
     c                   movel     h300          ifakref2
     c                   movel     h240          IFAKMAAF
     c
     c***                Altdaten
     c                   if        %subst(h300:57:04) ='BGFS'
     c                   movel     h050          ifakref1
     c                   movel     h240          IFAKMAAF
     c                   movel     h320          ifakafat
     c                   clear                   ifakref2
     c                   movel     h300          ifakref2
     c*********          #over     'BGFS'        ifakref2
     c                   endif
     c                   if        IFAKIFFI = '00003'
     c                   movel     h050          IFAKMAAF
     c                   movel     h300          ifakref1
     C                   movel     'TECCOM '     IFAKKDSB
     c                   endif
     c
     c     '0':'N'       xlate     h260          h260
     c     ' ':'N'       xlate     h260          h260
     c     '1':'J'       xlate     h260          h260
     c                   movel     h260          ifakliar
     c
     c                   if        h260 = 'J'
     c                   movel     'N'           ifaknlkz
     c                   endif
     c     ' ':'0'       xlate     h270          h270
     c                   movel     h270          ifaksarg
     c  n30              unlock    #IFAKL1
     c   30              write     IFAK1
      *
     C     ##2000        ENDSR

     C**************************************************************************
     C*übergaben Sendungsempfangsdaten KOPFEBENE
     C*IFADIFAA = 1 Auftraggeber-Adresse
     C*IFADIFAA = 2 Versand Adresse
     C*IFADIFAA = 3 Rechnungsempfänger Adresse
     C*-------------------------------------------------------------------------
     C*
     C     sr2200        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFAd1
     c                   movel     date          ifadueda
     c                   movel     zeit          ifadueuz
     c                   movel     date          ifadERDA
     c                   movel     zeit          ifadEZEI
     c                   movel     date          ifadJDAT
     c                   movel     zeit          ifadJZEI
     C                   movel     §§§usr        IFAdUSER
     C                   movel     §§§pgm        IFAdPROG
     C                   movel     §§§job        IFAdjnam
     C                   movel     §§§LIB        IFAdbibl
     c                   move      IFAkIFFI      ifadiffi
     C                   movel     ifakIFNR      ifadifnr
      *
     c                   movel     '2 '          IFADIFAA
     c                   movel     h060          ifaderda
     c                   movel     h070          ifadezei
     c                   movel     h100          ifadnam1
     c                   movel     h110          ifadnam2
     c                   movel     h120          ifadnam3
     c                   movel     h130          ifadstra
     c                   movel     h140          ifadpold
     c                   movel     h150          ifadpolz
     c                   movel     h160          ifadwort
     c                   if        IFAKIFFI = '40631'
     c                   eval      ifadpolz =  %subst(h160:01:10)
     c                   eval      ifadwort =  %subst(h160:11:20)
     c                   else
     c                   movel     h160          ifadwort
     c                   endif
     c   30              write     IFAd1
      *
     C     ##2200        ENDSR

     C**************************************************************************
     C*übergaben EDIdaten KOPFEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2250        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFed1
     c                   movel     date          ifedueda
     c                   movel     zeit          ifedueuz
     c                   movel     date          ifedERDA
     c                   movel     zeit          ifedEZEI
     c                   movel     date          ifedJDAT
     c                   movel     zeit          ifedJZEI
     C                   movel     §§§usr        IFedUSER
     C                   movel     §§§pgm        IFedPROG
     C                   movel     §§§job        IFedjnam
     C                   movel     §§§LIB        IFedbibl
     c                   move      IFAkIFFI      ifediffi
     C                   movel     ifakIFNR      ifedifnr
      *
     c                   move      'N'           IFEDAPER
     c   30              write     IFed1
      *
     C     ##2250        ENDSR

     C**************************************************************************
     C*übergaben Textdaten
     C*-------------------------------------------------------------------------
     C*
     C     sr2300        BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c                   movel     h070          ifatezei
     C*
     C*                 kopf (1)
     c                   if        ( h180 = 'H' and *in20 = '1' or
     c                               h200 = 'H' and *in21 = '1' or
     c                               h220 = 'H' and *in22 = '1'    )
     c                   movel     '1 '          ifatiftx
     c                   endif
     C*                 Fuss (2)
     c                   if        ( h180 = 'F' and *in20 = '1' or
     c                               h200 = 'F' and *in21 = '1' or
     c                               h220 = 'F' and *in22 = '1'    )
     c                   movel     '2 '          ifatiftx
     c                   endif
     C*                 Position (3)
     c                   if        ( h180 = 'L' and *in20 = '1' or
     c                               h200 = 'L' and *in21 = '1' or
     c                               h220 = 'L' and *in22 = '1'    )
     c                   movel     '3 '          ifatiftx
     c                   eval      ifatifpo   =  l050
     c                   endif
     c
     c                   movel     '1         '  ifatifuc
     c   20              movel     h170          ifattext
     c   21              movel     H190          ifattext
     c   22              movel     h210          ifattext
     c                   if        ifattext <> ' '
     c                   z-add     p             ifatifzn
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   endif
     c                   setoff                                       202122
      *
     C     ##2300        ENDSR

     C**************************************************************************
     C*übergaben Textdaten Kopf
     C*-------------------------------------------------------------------------
     C*
     C     sr2300k       BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c                   movel     h070          ifatezei
     C*
     c                   z-add     1             z                 3 0
     C     z             DOUgt     420
     c
     C*                 kopf
     c                   if        %subst(h310:z:60) <> *blank
     c                   movel     '2 '          ifatiftx
     c                   eval      ifattext   =  %subst(h310:z:60) +
     c                                           '     '
     c                   movel     '1         '  ifatifuc
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c                   eval      z =  z + 60
     c                   enddo
     c
      *
     C     ##2300k       ENDSR

     C**************************************************************************
     C*übergaben Textdaten Positionen
     C*-------------------------------------------------------------------------
     C*
     C     sr2300p       BEGSR
     C*                 Textfelder auf Ebene des Kopfes und des Fusses
     c                   clear                   IFAt1
     c                   movel     date          ifatueda
     c                   movel     zeit          ifatueuz
     c                   movel     date          ifatERDA
     c                   movel     zeit          ifatEZEI
     c                   movel     date          ifatJDAT
     c                   movel     zeit          ifatJZEI
     C                   movel     §§§usr        IFAtUSER
     C                   movel     §§§pgm        IFAtPROG
     C                   movel     §§§job        IFAtjnam
     C                   movel     §§§LIB        IFatbibl
     c                   move      IFAkIFFI      ifatiffi
     C                   move      ifakIFNR      ifatifnr
     c                   movel     h060          ifaterda
     c                   movel     h070          ifatezei
     C*
     c                   z-add     1             z                 3 0
     C     z             DOUgT     420
     c
     C*                 positionen
     c                   if        %subst(l150:z:60) <> *blank
     c                   movel     '3 '          ifatiftx
     c                   eval      ifattext   =  %subst(l150:z:60) +
     c                                           '     '
     c                   movel     '3         '  ifatifuc
     c                   eval      ifatifpo   =  l050
     c   30              write     IFAt1
     c                   eval      p = p + 1
     c                   z-add     p             ifatifzn
     c                   endif
     c                   eval      z =  z + 60
     c                   enddo
      *
     C     ##2300p       ENDSR

     C**************************************************************************
     C*übergaben Positionen POSITIONSEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR

     C*                 Positionsdaten Trend
     c                   clear                   IFAp1
     c                   movel     date          ifapueda
     c                   movel     zeit          ifapueuz
     c                   movel     date          ifapERDA
     c                   movel     zeit          ifapEZEI
     c                   movel     date          ifapJDAT
     c                   movel     zeit          ifapJZEI
     C                   movel     §§§usr        IFApUSER
     C                   movel     §§§pgm        IFApPROG
     C                   movel     §§§job        IFApjnam
     C                   movel     §§§LIB        IFapbibl
     c                   movel     IFAkIFFI      IFApIFFI
     c                   movel     ifakIFNR      ifapIFNR

     c                   eval      ifapifpo   =  l050
     c                   eval      IFAPTENR   =  L080
     c                   if        l070 = '1' or l070 = 'J' or l070 = 'Y'
     c                   move      l060          ifaplfte
     c                   else
     c                   move      l060          ifapkwte
MG01 c                   if        IFAKIFFI = '15177' or
MG01 c                             IFAKIFFI = '62765'
MG01 c*                  eval      l060 = l060 - 1 day
MG01 c                   move      l060          ifaplfte
MG01 C                   endif
     c                   endif
MG01 C* in jedem Fall wird hierdurch eine zu fruehe Lieferung
MG01 C* verhindert
MG01 C
MG01 c                   if        (IFAKIFFI = '88505' or
MG01 c                             IFAKIFFI = '40631')
MG01 C                             and l060 > datum
     c                   move      l060          ifaplfte
     c                   endif
MG01 C
MG01 C                   if        ifaplfte <> *zero
MG01 C                   if        %date(ifaplfte) < datum
MG01 C                   exsr      sr9900
MG01 C                   movel     newdate       ifaplfte
MG01 C                   endif
MG01 C                   endif
     c
     c                   z-add     l100          IFAPBSMG
     c   30              write     IFAp1
     c                   setoff                                       202122
      *
     C     ##2100        ENDSR

     C**************************************************************************
     C*übergaben Sendungsempfangsdaten KOPFEBENE
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   IFAn1
     c                   movel     date          ifanueda
     c                   movel     zeit          ifanueuz
     c                   movel     date          ifanERDA
     c                   movel     zeit          ifanEZEI
     c                   movel     date          ifanJDAT
     c                   movel     zeit          ifanJZEI
     C                   movel     §§§usr        IFAnUSER
     C                   movel     §§§pgm        IFAnPROG
     C                   movel     §§§job        IFAnjnam
     C                   movel     §§§LIB        IFanbibl
     c                   movel     IFAkIFFI      IFAnIFFI
     c                   movel     ifakIFNR      ifanIFNR
     c* kein Druckoptionsfenster eröffnen IFANDRKZ = 'N'
     c                   movel     'N'           IFANDRKZ
      *
     c                   movel     h060          ifanerda
     c                   movel     h070          ifanezei
     c                   movel     '0'           ifanabkz
     c   30              write     IFAd1
      *
     C     ##2500        ENDSR

     C**************************************************************************
     C*übergaben Nachnahmedaten in WAO8
     C*-------------------------------------------------------------------------
     C*
     C     sr2260        BEGSR
      *
     C*                 Sendungsempfangsdaten übergeben Neuanlage *in53=1
     c                   clear                   wao81
     c                   movel     date          WAO8ERDA
     c                   movel     date          WAO8JDAT
     c                   movel     zeit          WAO8JZEI
     C                   movel     §§§usr        WAO8USER
     C                   movel     §§§pgm        WAO8PROG
     C                   movel     §§§job        WAO8jnam
     C                   movel     §§§LIB        WAO8bibl
     c                   move      IFAkIFFI      WAO8iffi
     C                   movel     ifakIFNR      WAO8ifnr
     c                   eval      WAO8IFPO   =  l050

     c                   eval      d_head    = %subst(h310:420:49)
     c*                  movel     §orh310       orh310
     c*                  movel     §orh315       orh315
     c                   movel     §orh316       WAO8SPWG
     c                   movel     §orh400       WAO8CODN
     c                   movel     §orh420       WAO8CODW
     c                   move      §orh430       WAO8CODS
     c                   move      §orh440       WAO8CODM
     c                   move      §orh410       WAO8CODB
     c                   move      §orh450       WAO8CODV
     c                   move      §orh460       WAO8CODK
     c                   move      §orh470       WAO8CODI
     c                   clear                   ##pwinord        18
     c                   eval      ##pwinord = %subst(l150:481:18)
     c                   movel     ##pwinord     §ord450          11 2
     c                   move      ##pwinord     §ord460           7 2
     c                   z-add     §ord450       WAO8CODP
     c                   z-add     §ord460       WAO8CODU
     c
     c   30              write     wao81
      *
     C     ##2260        ENDSR

     C**************************************************************************
     C*übergaben Kundendaten Artikel
     C*-------------------------------------------------------------------------
     C*
     C     sr2280        BEGSR
      *
     C*                 Positionsdaten Trend
     c                   clear                   ifep1
     c                   movel     date          ifepueda
     c                   movel     zeit          ifepueuz
     c                   movel     date          ifepERDA
     c                   movel     zeit          ifepEZEI
     c                   movel     date          ifepJDAT
     c                   movel     zeit          ifepJZEI
     C                   movel     §§§usr        IFepUSER
     C                   movel     §§§pgm        IFepPROG
     C                   movel     §§§job        IFepjnam
     C                   movel     §§§LIB        IFepbibl
     c                   movel     IFAkIFFI      IFepIFFI
     c                   movel     ifakIFNR      ifepIFNR

     c                   eval      ifepifpo   =  l050
     c                   eval      IFEPTENR   =  L080
     c                   eval      IFEPIDEN   =  L110
     c
     c   30              write     IFep1
     c                   setoff                                       202122
      *
     C     ##2280        ENDSR

     C**************************************************************************
     C*Protokoll line
     C*-------------------------------------------------------------------------
     C*
     C     sr2800        BEGSR
      *
     C*                 Übergabeprotokoll  "E D C" - part Kopf
     c*                  clear                   l150
     c                   if        *in93 = '1' and
     c                             ( ifakafjj <>   *Zero  or
     c                               ifakafnr <>   *blank or
     c                               ifakfenr <>   *blank or
     c                               ifakffld <>   *blank )
     C                   eval      l150 =
     C                             ' order already in the system          '
     C*                            ===> date and time
     c                   endif
     c                   movel     §§§USR        l160
     c                   movel     '10'          l240
     c                   movel     date          l180
     c                   movel     tstampi       l190
     c  n30              unlock    orderll1
     c   30              update    ORDERLPF
      *
      *
     C     ##2800        ENDSR

     C**************************************************************************
     C*Protokoll header
     C*-------------------------------------------------------------------------
     C*
     C     sr2900        BEGSR
      *
     C*                 Übergabeprotokoll  "E D C" - part Kopf
     c*                  clear                   h310
     c                   if        *in93 = '1' and
     c                             ( ifakafjj <>   *Zero  or
     c                               ifakafnr <>   *blank or
     c                               ifakfenr <>   *blank or
     c                               ifakffld <>   *blank )
     C                   eval      h310 =
     C                             ' order already in the system          '
     C*                            ===> date and time
     c                   endif
     c                   movel     §§§USR        h330
     c                   movel     '10'          h350
     c                   movel     date          h360
     c                   movel     tstampi       h370
     c  n30              unlock    orderhl1
     c   30              update    ORDERhPF
      *
      *
     C     ##2900        ENDSR

     C**********************************************************************
     C*LÖSCHEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     LIFAK         BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  '4     '      EXIFAKPGST
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     c                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     C*
     C                   CALL      'TRIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
     C*
     C     ##LIFAK       ENDSR
     C
     C**********************************************************************
     C*ABSCHLIEßEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     AIFAK         BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  'ABSCHL'      EXIFAKPGST
     C                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     C*
     C                   CALL      'TRIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
     C*
     C     ##AIFAK       ENDSR
     C
     C**********************************************************************
     C*FREIGEBEN IFAK
     C*-------------------------------------------------------------------------
     C
     C     GNIFAK        BEGSR
      *
     C                   CLEAR                   EXIFAK
     C                   MOVEL(P)  'GNAFKO'      EXIFAKPGST
     C                   MOVEL(P)  ifakIFNR      EXIFAKIFNR
     c                   MOVEL(P)  IFAkIFFI      EXIFAKIFFI
     C*
     C                   CALL      'GNIFAK'
     C                   PARM                    EXIFAK
     C                   PARM                    RTIFAK
      *
     C     ##GNIFAK      ENDSR
     C
     C**********************************************************************
     C*message
     C*-------------------------------------------------------------------------
     C
     C     message       BEGSR
      *
     C                   setoff                                       66
     C                   if        ifakiffi  = 'x8505' or
     C                             ifakiffi  = 'x0631' or
     C                             ifakiffi  = 'x5177' or
     C                             ifakiffi  = 'x2765' or
     C                             ifakiffi  = '02921' or
     C                             ifakiffi  = '55278'
     C                   seton                                        66
     C                   endif
     C   66              CALL      'MESSAGE_SC'
     C                   PARM                    ifakiffi
     C                   PARM                    IFAKMAAF
     C                   PARM      '1'           PARMX             1
      *
     C     ##message     ENDSR
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
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 7, 4)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 4, 2)
     c+ concat
     c+         substr(char
     c+ (date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+       substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+       substr(char(:ifaplfte), 7, 2)  ) +2 days, eur), 1, 2)
     c+ into  :newdate
     c+       from qsys2/qsqptabl
     c+
     c/end-exec

     C     ##9900        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9900x       BEGSR
     C*
     c

     c/exec sql
     c+ select
     c+ date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c+      substr(char(:ifaplfte), 5, 2) concat '-' concat
     c+      substr(char(:ifaplfte), 7, 2)  ) +2 days into :##date
     c+ from qsys2/qsqptabl
     c***+ where
     c***+ date(substr(char(:ifaplfte), 1, 4) concat '-' concat
     c***+      substr(char(:ifaplfte), 5, 2) concat '-' concat
     c***+      substr(char(:ifaplfte), 7, 2)  ) < current date
     c/end-exec

     C     ##9900x       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C*-------------------------------------------------------------------------

     C     *inzsr        BEGSR
      *

     C                   TIME                    Date
     c                   extrct    date:*Y       jahr
     c                   extrct    date:*M       monat
     C                   extrct    date:*D       tag

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
