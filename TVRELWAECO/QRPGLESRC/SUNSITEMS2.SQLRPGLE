     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *  SELECT * fromainput  where substr(char(sku), 1, 10) in
      *
      *  CRTSRCPF FILE(TVRELWAECO/CSV_ITEMS) RCDLEN(256)
      *  CPYFRMIMPF FROMFILE(TVRELWAECO/CSV_ITEMS)
      *  TOFILE(TVRELWAECO/SUN_ITEMS)
      *  MBROPT(*REPLACE) FLDDLM(';') DECPNT(*COMMA) RPLNULLVAL(*FLDDFT)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * SELECT * FROM kund WHERE KDKDNR = '015048'
      * Datei #KUND01 in QTEMP wurde erstellt.
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)
     fSUN_ITEMS ip   e           k disk    RENAME(SUN_ITEMSR:phy01r)

     fSUNSHINEL1if   e           k disk

     f##teil    if   e             disk    prefix('#')
     f                                     RENAME(##teil:phy##teil)
     f                                     INFDS(DSF0)
     F                                     USROPN

     fteil01    uf a e           k disk    RENAME(teil1:phyteil)


     f##teew    if   e             disk    prefix('#')
     f                                     RENAME(##teew:phy##teew)
     f                                     INFDS(DSF1)
     F                                     USROPN

     fteew01    uf a e           k disk    RENAME(teew1:phyteew)



     f##tebb    if   e             disk    prefix('#')
     f                                     RENAME(##tebb:phy##tebb)
     f                                     INFDS(DSF4)
     F                                     USROPN

     ftebb01    uf a e           k disk    RENAME(tebb1:phytebb)



     f##teuf    if   e             disk    prefix('#')
     f                                     RENAME(##teuf:phy##teuf)
     f                                     INFDS(DSF5)
     F                                     USROPN

     fteuf01    uf a e           k disk    RENAME(teuf1:phyteuf)


     f##teos    if   e             disk    prefix('#')
     f                                     RENAME(##teos:phy##teos)
     f                                     INFDS(DSF6)
     F                                     USROPN

     fteos02    uf a e           k disk    RENAME(teos1:phyteos)


     DDate             S               D   DATFMT(*iso)
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
     D*-------------------------------------------------------------------------
     D DSF0            DS
     D  F0STS                 11     15  0
     D  F0RRN                397    400B 0
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D DSF4            DS
     D  F4STS                 11     15  0
     D  F4RRN                397    400B 0
     D DSF5            DS
     D  F5STS                 11     15  0
     D  F5RRN                397    400B 0
     D DSF6            DS
     D  F6STS                 11     15  0
     D  F6RRN                397    400B 0
     D**********************************************************************
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     ****

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    company          02

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   setoff                                       88
     c                   movel     '0'           error             1
     c                   if        error = '0' and
     c                             (ITEM#   = '304898341 '  or
     c                              ITEM#   = '322601101 '  or
     c                              ITEM#   = '302332081 ' )
     c                   setoff                                       88
     c                   endif
     c
     c                   movel     item#         ITEMS            15
     c
     c     items         chain     SUNSHINEL1
     c                   IF        %found(SUNSHINEL1)
     c                   seton                                        77
     c                   else
     c                   setoff                                       77
     c                   endif
     c                   If         item# <> '#BEZUG!  ' and
     c***                           item# <> '9103100000     '  and
     c                              item# <> '9103100001     '  and
     c                              item# <> '               '
     C*teil
     c                   if        *in90 = '0'
     c                   movel     company       TEFIRM
     c                   clear                   TETENR
     c                   movel     ITEM#         TETENR
     c***                clear                   TETENR
     c***                clear                   ITEM#
     c***                eval      tetenr  = 'xxxxxxxx'
     c***                eval      ITEM#   = 'xxxxxxxx'
     c
     c     keyteil01     klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c
     c     keyteil01     chain     teil01                             98
     C
     c                   exsr      srteil
     C
     C                   if        ITEM# <> 'xxxxxxxx'
     C   98              write     phyteil
     C  n98              update    phyteil
     c                   endif
     c
     C                   endif

     c
     C*teew
     c                   if        *in91 = '0'
     c                   movel     company       TEEWFIRM
     c                   clear                   TEEWTENR
     c                   movel     ITEM#         TEEWTENR
     c***                clear                   TEEWTENR
     c***                clear                   ITEM#
     c***                eval      TEEWTENR= 'xxxxxxxx'
     c***                eval      ITEM#   = 'xxxxxxxx'
     c
     c     keyteew01     klist
     c                   kfld                    TEEWFIRM
     c                   kfld                    TEEWTENR
     c
     c     keyteew01     chain     teew01                             98
     C
     c                   exsr      srteew
     C
     C                   if        ITEM# <> 'xxxxxxxx'
     C   98              write     phyteew
     C  n98              update    phyteew
     c                   endif
     c
     C                   endif

     C*tebb
     c                   if        *in94 = '0'
     c                   movel     company       TEBBFIRM
     c                   clear                   TEBBTENR
     c                   movel     ITEM#         TEBBTENR
     c***                clear                   TEBBTENR
     c***                clear                   ITEM#
     c***                eval      TEBBTENR= 'xxxxxxxx'
     c***                eval      ITEM#   = 'xxxxxxxx'
     c
     c     keytebb01     klist
     c                   kfld                    TEBBFIRM
     c                   kfld                    TEBBTENR
     c
     c     keytebb01     chain     tebb01                             98
     C
     c                   exsr      srtebb
     C
     C                   if        ITEM# <> 'xxxxxxxx'
     C   98              write     phytebb
     C  n98              update    phytebb
     c                   endif
     c
     C                   endif


     C*teuf
     c                   if        *in95 = '0'
     c                   movel     company       TUFIRM
     c                   clear                   TUTENR
     c                   movel     ITEM#         TUTENR
     c***                clear                   TUTENR
     c***                clear                   ITEM#
     c***                eval      TUTENR  = 'xxxxxxxx'
     c***                eval      ITEM#   = 'xxxxxxxx'
     c
     c     keyteuf01     klist
     c                   kfld                    TUFIRM
     c                   kfld                    TUTENR
     c
     c     keyteuf01     chain     teuf01                             98
     C
     c                   exsr      srteuf
     C
     C                   if        ITEM# <> 'xxxxxxxx'
     C   98              write     phyteuf
     C  n98              update    phyteuf
     c                   endif
     c
     C                   endif


     C*teos
     c                   if        *in96 = '0'
     c                   movel     company       TEOSFIRM
     c                   clear                   TEOSTENR
     c                   movel     ITEM#         TEOSTENR
     c***                clear                   TEOSTENR
     c***                clear                   ITEM#
     c***                eval      TEOSTENR= 'xxxxxxxx'
     c***                eval      ITEM#   = 'xxxxxxxx'
     c
     c     keyteos02     klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSTENR
     c
     c     keyteos02     chain     teos02                             98
     C
     c                   exsr      srteos
     C
     C                   if        ITEM# <> 'xxxxxxxx'
     C   98              write     phyteos
     C  n98              update    phyteos
     c                   endif
     c
     C                   endif

     C                   endif

     C**************************************************************************
     C* srteil:
     C*-------------------------------------------------------------------------
     C*
     C     srteil        BEGSR
     C*
     C                   eval      TELOCK  =  #TELOCK
     C                   eval      TEJNAM  =  #TEJNAM
     C                   eval      TEJDAT  =  #TEJDAT
     C                   eval      TEJZEI  =  #TEJZEI
     C                   eval      TEUSER  =  #TEUSER
     C                   eval      TEPROG  =  #TEPROG
     C                   eval      TEBIBL  =  #TEBIBL
     C                   eval      TEFIRM  =  #TEFIRM
     C                   eval      TETENR  =  #TETENR
     C                   eval      TEEZNR  =  #TEEZNR
     C                   eval      TEINDX  =  #TEINDX
     C                   eval      TERALN  =  #TERALN
     C                   eval      TEWKNR  =  #TEWKNR
     C                   eval      TETBZ1  =  #TETBZ1
     C                   eval      TETBZ2  =  #TETBZ2
     C                   eval      TEZINR  =  #TEZINR
     C                   eval      TETEST  =  #TETEST
     C                   eval      TEMCBG  =  #TEMCBG
     C                   eval      TEERTE  =  #TEERTE
     C                   eval      TETART  =  #TETART
     C                   eval      TEMEIN  =  #TEMEIN
     C                   eval      TEMAGR  =  #TEMAGR
     C                   eval      TEARKZ  =  #TEARKZ
     C                   eval      TEZIFM  =  #TEZIFM
     C                   eval      TENOAR  =  #TENOAR
     C                   eval      TENONR  =  #TENONR
     C                   eval      TEGWDI  =  #TEGWDI
     C                   eval      TEEANR  =  #TEEANR
     C                   eval      TEWKST  =  #TEWKST
     C                   eval      TEFRDA  =  #TEFRDA
     C                   eval      TEAEDA  =  #TEAEDA
     C                   eval      TEAEND  =  #TEAEND
     C                   eval      TENGKZ  =  #TENGKZ
     C                   eval      TEGWNT  =  #TEGWNT
     C                   eval      TEGWBR  =  #TEGWBR
     C                   eval      TEERDA  =  #TEERDA
     C                   eval      TEERUS  =  #TEERUS
     C                   eval      TESAAV  =  #TESAAV
     C                   eval      TEDIAV  =  #TEDIAV
     C                   eval      TELOGR  =  #TELOGR
     C                   eval      TEAUSF  =  #TEAUSF
     C                   eval      TEAUSA  =  #TEAUSA
     C                   eval      TEVOZ1  =  #TEVOZ1
     C                   eval      TEVOA1  =  #TEVOA1
     C                   eval      TEALDI  =  #TEALDI
     C                   eval      TEBESL  =  #TEBESL
     C                   eval      TEGKKZ  =  #TEGKKZ
     C                   eval      TERPZT  =  #TERPZT
     C                   eval      TEFBKZ  =  #TEFBKZ
     C                   eval      TESITG  =  #TESITG
     C                   eval      TESIBE  =  #TESIBE
     C                   eval      TEMEAV  =  #TEMEAV
     C                   eval      TEABC1  =  #TEABC1
     C                   eval      TEABC2  =  #TEABC2
     C                   eval      TEABC3  =  #TEABC3
     C                   eval      TEPDAV  =  #TEPDAV
     C                   eval      TEDUP2  =  #TEDUP2
     C                   eval      TEVEP2  =  #TEVEP2
     C                   eval      TEV2DA  =  #TEV2DA
     C                   eval      TEVEPV  =  #TEVEPV
     C                   eval      TESTPV  =  #TESTPV
     C                   eval      TESTDA  =  #TESTDA
     C                   eval      TESTPR  =  #TESTPR
     C                   eval      TEINPR  =  #TEINPR
     C                   eval      TEINDA  =  #TEINDA
     C                   eval      TEUMDA  =  #TEUMDA
     C                   eval      TEUMMG  =  #TEUMMG
     C                   eval      TEBGKZ  =  #TEBGKZ
     C                   eval      TEAPKZ  =  #TEAPKZ
     C                   eval      TESAEK  =  #TESAEK
     C                   eval      TEDIEK  =  #TEDIEK
     C                   eval      TEMEEK  =  #TEMEEK
     C                   eval      TEMPEK  =  #TEMPEK
     C                   eval      TELVZ1  =  #TELVZ1
     C                   eval      TEEWPF  =  #TEEWPF
     C                   eval      TELVA1  =  #TELVA1
     C                   eval      TELVZ2  =  #TELVZ2
     C                   eval      TELVA2  =  #TELVA2
     C                   eval      TEZOTN  =  #TEZOTN
     C                   eval      TELFNR  =  #TELFNR
     C                   eval      TESTLF  =  #TESTLF
     C                   eval      TEMIBM  =  #TEMIBM
     C                   eval      TEPDEK  =  #TEPDEK
     C                   eval      TEHOBS  =  #TEHOBS
     C                   eval      TELEEK  =  #TELEEK
     C                   eval      TELEBS  =  #TELEBS
     C                   eval      TELENE  =  #TELENE
     C                   eval      TELBPB  =  #TELBPB
     C                   eval      TELERE  =  #TELERE
     C                   eval      TELBPN  =  #TELBPN
     C                   eval      TEDUPR  =  #TEDUPR
     C                   eval      TEDUDA  =  #TEDUDA
     C                   eval      TEVEPR  =  #TEVEPR
     C                   eval      TEVEDA  =  #TEVEDA
     C                   eval      TELPGR  =  #TELPGR
     C                   eval      TEACDA  =  #TEACDA
     C                   eval      TEQSEK  =  #TEQSEK
     C                   eval      TEPDVK  =  #TEPDVK
     C                   eval      TEMWST  =  #TEMWST
     C                   eval      TEMPVK  =  #TEMPVK
     C                   eval      TEURLD  =  #TEURLD
     C                   eval      TEUREG  =  #TEUREG
     C                   eval      TEMEVK  =  #TEMEVK
     C                   eval      TEVPEI  =  #TEVPEI
     C                   eval      TESAVK  =  #TESAVK
     C                   eval      TEFRTA  =  #TEFRTA
     C                   eval      TEPRGR  =  #TEPRGR
     C                   eval      TEKOKZ  =  #TEKOKZ
     C                   eval      TEZOAN  =  #TEZOAN
     C                   eval      TEZPUR  =  #TEZPUR
     C                   eval      TEEBKZ  =  #TEEBKZ
     C                   eval      TEABC4  =  #TEABC4
     C                   eval      TEABC5  =  #TEABC5
     C                   eval      TEABC6  =  #TEABC6
     C                   eval      TEZUAB  =  #TEZUAB
     C                   eval      TEKASL  =  #TEKASL
     C                   eval      TEWBKT  =  #TEWBKT
     C                   eval      TEEBKT  =  #TEEBKT
     C                   eval      TEKOTR  =  #TEKOTR
     C                   eval      TELANR  =  #TELANR
     C                   eval      TEEPFG  =  #TEEPFG
     C                   eval      TEPAM1  =  #TEPAM1
     C                   eval      TEIVPE  =  #TEIVPE
     C                   eval      TELANG  =  #TELANG
     C                   eval      TEBSKZ  =  #TEBSKZ
     C                   eval      TEGBKZ  =  #TEGBKZ
     C                   eval      TEGPKZ  =  #TEGPKZ
     C                   eval      TECTKZ  =  #TECTKZ
     C                   eval      TERPKZ  =  #TERPKZ
     C                   eval      TEDALA  =  #TEDALA
     C                   eval      TEDALZ  =  #TEDALZ
     C                   eval      TEDOKZ  =  #TEDOKZ
     C                   eval      TECHKZ  =  #TECHKZ
     C                   eval      TEWEMT  =  #TEWEMT
     C                   eval      TEQSME  =  #TEQSME
     C                   eval      TEGUZT  =  #TEGUZT
     C                   eval      TEGUDI  =  #TEGUDI
     C                   eval      TEAWKZ  =  #TEAWKZ
     C                   eval      TEKDGR  =  #TEKDGR
     C                   eval      TEBONU  =  #TEBONU
     C                   eval      TEVLZ1  =  #TEVLZ1
     C                   eval      TEVLA1  =  #TEVLA1
     C                   eval      TEGBST  =  #TEGBST
     C                   eval      TEIAKZ  =  #TEIAKZ
     C                   eval      TEPEOB  =  #TEPEOB
     C                   eval      TEAFKZ  =  #TEAFKZ
     C                   eval      TEFAKZ  =  #TEFAKZ
     C                   eval      TEVIKZ  =  #TEVIKZ
     C                   eval      TEHIKZ  =  #TEHIKZ
     C                   eval      TEVAKZ  =  #TEVAKZ
     C                   eval      TEVOLA  =  #TEVOLA
     C                   eval      TELORT  =  #TELORT
     C                   eval      TETLWP  =  #TETLWP
     C                   eval      TETLWN  =  #TETLWN
     C                   eval      TETLKZ  =  #TETLKZ
     C                   eval      TEVOLU  =  #TEVOLU
     C                   eval      TEDART  =  #TEDART
     C                   eval      TEPRPL  =  #TEPRPL
     C                   eval      TEVTLI  =  #TEVTLI
     C                   eval      TEKTTR  =  #TEKTTR
     C                   eval      TEHPGR  =  #TEHPGR
     C                   eval      TEWKPZ  =  #TEWKPZ
     C                   eval      TEPPKZ  =  #TEPPKZ
     C                   eval      TEVSKZ  =  #TEVSKZ
     C                   eval      TEGWRE  =  #TEGWRE
     C                   eval      TEGUZM  =  #TEGUZM
     C                   eval      TEGUDM  =  #TEGUDM
     C                   eval      TEBESC  =  #TEBESC
     C                   eval      TEBREI  =  #TEBREI
     C                   eval      TESTDV  =  #TESTDV
     C                   eval      TEBSEI  =  #TEBSEI
     C                   eval      TESAQK  =  #TESAQK
     C                   eval      TEKAFE  =  #TEKAFE
     C                   eval      TEBLAT  =  #TEBLAT
     C                   eval      TELBQM  =  #TELBQM
     C                   eval      TEVODI  =  #TEVODI
     C                   eval      TEKLSP  =  #TEKLSP
     C                   eval      TEFREX  =  #TEFREX
     C*
     c                   eval      TELOCK  =  *blank
     c                   eval      TEJNAM  =  §§§job
     c                   movel     date          TEJDAT
     c                   movel     zeit          TEJZEI
     c                   eval      TEUSER  =  §§§usr
     c                   eval      TEPROG  =  §§§pgm
     c                   eval      TEBIBL  =  §§§LIB
     c
     c                   clear                   TETENR
     c                   movel     ITEM#         TETENR
     c                   clear                   TETBZ1
     c                   movel     DESC2         TETBZ1
     c                   clear                   TETBZ2
     c                   movel     DESC3         TETBZ2
     c                   eval      %subst(TETBZ2:10:15) =ITEMSS
     c   77              eval      %subst(TETBZ2:30:01) ='1'
     c  n77              eval      %subst(TETBZ2:30:01) ='0'
     c                   clear                   TEMCBG
     c                   movel     MATCHCODE     TEMCBG
     c                   clear                   TEEANR
     c                   movel     EAN           TEEANR
     c                   clear                   TESTPR
     c                   z-add     STK           TESTPR
     c                   clear                   TEMCBG
     c                   movel     MATCHCODE     TEMCBG
     c                   clear                   TESTLF
     c                   movel     STAMMLFR      TESTLF
     c                   if        company = '55'
     c                   movel     '00999'       TESTLF
     c                   endif
     c                   z-add     GEWBRUTTO     TEGWBR
     c                   z-add     GEWBNETTO     TEGWNT
     c                   z-add     VOLUMEN       TEVOLU
     c                   clear                   teabc1
     c                   movel     abc           teabc1
     c                   if        company = '01'
     c                   clear                   TESAAV
     c                   movel     DISPON        TESAAV
     c                   clear                   TEDIAV
     c                   movel     DISPON        TEDIAV
     c                   endif
     C                   movel     date          TEERDA
     C                   movel     date          TESTDA
     c                   movel     '01'          TETEST
     C*
     C     ##_teil       ENDSR
     C*
     C**************************************************************************
     C* srteew:
     C*-------------------------------------------------------------------------
     C*
     C     srteew        BEGSR
     C*
     C                   eval      TEEWLOCK =  #TEEWLOCK
     C                   eval      TEEWJNAM =  #TEEWJNAM
     C                   eval      TEEWJDAT =  #TEEWJDAT
     C                   eval      TEEWJZEI =  #TEEWJZEI
     C                   eval      TEEWUSER =  #TEEWUSER
     C                   eval      TEEWPROG =  #TEEWPROG
     C                   eval      TEEWBIBL =  #TEEWBIBL
     C                   eval      TEEWFIRM =  #TEEWFIRM
     C                   eval      TEEWTENR =  #TEEWTENR
     C                   eval      TEEWSKUN =  #TEEWSKUN
     C                   eval      TEEWPNCN =  #TEEWPNCN
     C                   eval      TEEWPRGR =  #TEEWPRGR
     C                   eval      TEEWERUS =  #TEEWERUS
     C                   eval      TEEWLVZT =  #TEEWLVZT
     C                   eval      TEEWLVZA =  #TEEWLVZA
     C                   eval      TEEWKZLF =  #TEEWKZLF
     C                   eval      TEEWKZHS =  #TEEWKZHS
     C                   eval      TEEWVKG1 =  #TEEWVKG1
     C                   eval      TEEWVKG2 =  #TEEWVKG2
     C                   eval      TEEWVKG3 =  #TEEWVKG3
     C                   eval      TEEWVKG4 =  #TEEWVKG4
     C                   eval      TEEWVKG5 =  #TEEWVKG5
     C                   eval      TEEWVWIT =  #TEEWVWIT
     C                   eval      TEEWSDBP =  #TEEWSDBP
     C                   eval      TEEWFREI =  #TEEWFREI
     C*
     c                   eval      TEEWLOCK =  *blank
     c                   eval      TEEWJNAM =  §§§job
     c                   movel     date          TEEWJDAT
     c                   movel     zeit          TEEWJZEI
     c                   eval      TEEWUSER =  §§§usr
     c                   eval      TEEWPROG =  §§§pgm
     c                   eval      TEEWBIBL =  §§§LIB
     c
     c                   clear                   TEEWTENR
     c                   movel     ITEM#         TEEWTENR
     c                   clear                   TEEWSKUN
     c                   movel     ITEM#         TEEWSKUN
     C*
     C     ##_teew       ENDSR
     C*
     C**************************************************************************
     C* srtebb:
     C*-------------------------------------------------------------------------
     C*
     C     srtebb        BEGSR
     C*
     C                   eval      TEBBLOCK =  #TEBBLOCK
     C                   eval      TEBBJNAM =  #TEBBJNAM
     C                   eval      TEBBJDAT =  #TEBBJDAT
     C                   eval      TEBBJZEI =  #TEBBJZEI
     C                   eval      TEBBUSER =  #TEBBUSER
     C                   eval      TEBBPROG =  #TEBBPROG
     C                   eval      TEBBBIBL =  #TEBBBIBL
     C                   eval      TEBBFIRM =  #TEBBFIRM
     C                   eval      TEBBABTL =  #TEBBABTL
     C                   eval      TEBBSTAT =  #TEBBSTAT
     C                   eval      TEBBTENR =  #TEBBTENR
     C                   eval      TEBBAENR =  #TEBBAENR
     C                   eval      TEBBVABT =  #TEBBVABT
     C                   eval      TEBBLFZN =  #TEBBLFZN
     C                   eval      TEBBTEXT =  #TEBBTEXT
     C                   eval      TEBBTSTP =  #TEBBTSTP
     C                   eval      TEBBFREI =  #TEBBFREI
     C*
     c                   eval      TEBBLOCK =  *blank
     c                   eval      TEBBJNAM =  §§§job
     c                   movel     date          TEBBJDAT
     c                   movel     zeit          TEBBJZEI
     c                   eval      TEBBUSER =  §§§usr
     c                   eval      TEBBPROG =  §§§pgm
     c                   eval      TEBBBIBL =  §§§LIB
     c
     c                   clear                   TEBBTENR
     c                   movel     ITEM#         TEBBTENR
     C*
     C     ##_tebb       ENDSR
     C*
     C**************************************************************************
     C* srteuf:
     C*-------------------------------------------------------------------------
     C*
     C     srteuf        BEGSR
     C*
     C                   eval      TULOCK   =  #TULOCK
     C                   eval      TUJNAM   =  #TUJNAM
     C                   eval      TUJDAT   =  #TUJDAT
     C                   eval      TUJZEI   =  #TUJZEI
     C                   eval      TUUSER   =  #TUUSER
     C                   eval      TUPROG   =  #TUPROG
     C                   eval      TUBIBL   =  #TUBIBL
     C                   eval      TUFIRM   =  #TUFIRM
     C                   eval      TUTENR   =  #TUTENR
     C                   eval      TUMEIN   =  #TUMEIN
     C                   eval      TUUFAK   =  #TUUFAK
     C                   eval      TUUMV1   =  #TUUMV1
     C                   eval      TUUMV2   =  #TUUMV2
     C                   eval      TUANBR   =  #TUANBR
     C                   eval      TUTUST   =  #TUTUST
     C                   eval      TUFRIN   =  #TUFRIN
     C                   eval      TUFREX   =  #TUFREX
     C*
     c                   eval      TULOCK   =  *blank
     c                   eval      TUJNAM   =  §§§job
     c                   movel     date          TUJDAT
     c                   movel     zeit          TUJZEI
     c                   eval      TUUSER  =  §§§usr
     c                   eval      TUPROG   =  §§§pgm
     c                   eval      TUBIBL   =  §§§LIB
     c
     c                   clear                   TUTENR
     c                   movel     ITEM#         TUTENR
     C*
     C     ##_teuf       ENDSR
     C*
     C**************************************************************************
     C* srteos:
     C*-------------------------------------------------------------------------
     C*
     C     srteos        BEGSR
     C*
     C                   eval      TEOSLOCK =  #TEOSLOCK
     C                   eval      TEOSJNAM =  #TEOSJNAM
     C                   eval      TEOSJDAT =  #TEOSJDAT
     C                   eval      TEOSJZEI =  #TEOSJZEI
     C                   eval      TEOSUSER =  #TEOSUSER
     C                   eval      TEOSPROG =  #TEOSPROG
     C                   eval      TEOSBIBL =  #TEOSBIBL
     C                   eval      TEOSFIRM =  #TEOSFIRM
     C                   eval      TEOSKLCD =  #TEOSKLCD
     C                   eval      TEOSTENR =  #TEOSTENR
     C                   eval      TEOSMM01 =  #TEOSMM01
     C                   eval      TEOSMM02 =  #TEOSMM02
     C                   eval      TEOSMM03 =  #TEOSMM03
     C                   eval      TEOSMM04 =  #TEOSMM04
     C                   eval      TEOSMM05 =  #TEOSMM05
     C                   eval      TEOSMM06 =  #TEOSMM06
     C                   eval      TEOSMM07 =  #TEOSMM07
     C                   eval      TEOSMM08 =  #TEOSMM08
     C                   eval      TEOSMM09 =  #TEOSMM09
     C                   eval      TEOSMM10 =  #TEOSMM10
     C                   eval      TEOSFREI =  #TEOSFREI
     C*
     c                   eval      TEOSLOCK =  *blank
     c                   eval      TEOSJNAM =  §§§job
     c                   movel     date          TEOSJDAT
     c                   movel     zeit          TEOSJZEI
     c                   eval      TEOSUSER =  §§§usr
     c                   eval      TEOSPROG =  §§§pgm
     c                   eval      TEOSBIBL =  §§§LIB
     c
     c                   clear                   TEOSTENR
     c                   movel     ITEM#         TEOSTENR
     C*
     C     ##_teos       ENDSR
     C*
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

     c                   exsr      sr9999

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     c                   clear                   item             15
     c                   if        company = '01'
     c                   eval      item = '9103104005'
     c                   endif
     c                   if        company = '55'
     c                   eval      item = '9103104005'
     c                   endif
     c
     C*                 Standardkunde Parameter
     C                   clear                   md
     C                   movea(p)  company       md(001)
     C                   movea(p)  item          md(003)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#SO5000'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '##teil '     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     c
     C                   clear                   md
     C                   movea(p)  company       md(001)
     C                   movea(p)  item          md(003)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#SO5001'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '##teew '     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     c
     c
     c
     c
     C                   clear                   md
     C                   movea(p)  company       md(001)
     C                   movea(p)  item          md(003)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#SO5004'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '##tebb '     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     c
     C                   clear                   md
     C                   movea(p)  company       md(001)
     C                   movea(p)  item          md(003)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#SO5005'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '##teuf '     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     c
     C                   clear                   md
     C                   movea(p)  company       md(001)
     C                   movea(p)  item          md(003)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#SO5006'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '##teos '     OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     c
     c
     C                   open      ##teil
     c                   z-add     1             F0RRN
     C     F0RRN         CHAIN     ##teil                             90
     C                   close     ##teil
     c
     C                   open      ##teew
     c                   z-add     1             F1RRN
     C     F1RRN         CHAIN     ##teew                             91
     C                   close     ##teew
     c
     C                   open      ##tebb
     c                   z-add     1             F4RRN
     C     F4RRN         CHAIN     ##tebb                             94
     C                   close     ##tebb

     C                   open      ##teuf
     c                   z-add     1             F5RRN
     C     F5RRN         CHAIN     ##teuf                             95
     C                   close     ##teuf


     C                   open      ##teos
     c                   z-add     1             F6RRN
     C     F6RRN         CHAIN     ##teos                             96
     C                   close     ##teos

     C                   ENDSR

     C**************************************************************************
