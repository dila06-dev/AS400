     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *  SELECT * fromainput  where substr(char(sku), 1, 10) in
      *                     (SELECT teewskun from teew)
      *
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
      * SELECT * FROM kund WHERE KDKDNR = '015048'
      * Datei #KUND01 in QTEMP wurde erstellt.
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)
     fainput    ip   e           k disk    RENAME(ainput:phy01r)
     f#teil01   if   e             disk    prefix('#')
     f                                     RENAME(#teil01:phy02r)
     f                                     INFDS(DSF1)
     F                                     USROPN
     f#teuf01   if   e             disk    prefix('#')
     f                                     RENAME(#teuf01:phy07r)
     f                                     INFDS(DSF2)
     F                                     USROPN

     fteil01    uf a e           k disk    RENAME(teil1:phy03r)

     fteos01    uf a e           k disk
     fTEEW01    uf a e           k disk
     fteuf01    uf a e           k disk    RENAME(teuf1:phy09r)
     f#teew     if   e           k disk    rename(TEEW1:#teew1)

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
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D**********************************************************************
     ****
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

     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     c
      /Free
         MONITOR;
         if %Nullind(ARTIKEL);
            %Nullind(ARTIKEL) = *off;
            ARTIKEL = *Blanks;
         endif;
         if %Nullind(DESCR);
            %Nullind(DESCR) = *off;
            DESCR   = *Blanks;
         endif;
         if %Nullind(class);
            %Nullind(class) = *off;
            class   = *Blanks;
         endif;
         if %Nullind(GROUP);
            %Nullind(GROUP) = *off;
            GROUP   = *Blanks;
         endif;
         if %Nullind(EAN);
            %Nullind(EAN)   = *off;
            EAN     = *Blanks;
         endif;
         if %Nullind(WEIGHT);
            %Nullind(WEIGHT) = *off;
            WEIGHT  = *zero;
         endif;
         if %Nullind(LENGTH);
            %Nullind(LENGTH) = *off;
            LENGTH  = *zero;
         endif;
         if %Nullind(WIDTH);
            %Nullind(WIDTH) = *off;
            WIDTH   = *zero;
         endif;
         if %Nullind(PROD);
            %Nullind(PROD) = *off;
            PROD   = *Blanks;
         endif;
         if %Nullind(COMPONENT);
            %Nullind(COMPONENT) = *off;
            COMPONENT = *Blanks;
         endif;
         if %Nullind(MODEL);
            %Nullind(MODEL) = *off;
            MODEL = *Blanks;
         endif;
         if %Nullind(SKU);
            %Nullind(SKU) = *off;
            SKU       = *Blanks;
         endif;
         if %Nullind(HARMONIZED);
            %Nullind(HARMONIZED) = *off;
            HARMONIZED = *Blanks;
         endif;
         if %Nullind(COUNTRY);
            %Nullind(COUNTRY) = *off;
            COUNTRY = *Blanks;
         endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free
     c
     c                   setoff                                       91
     c
     c                   if        error = '0' and
     c                             (ARTIKEL = '304898341 '  or
     c                              ARTIKEL = '322601101 '  or
     c                              ARTIKEL = '302332081 ' )
     c                   setoff                                       91
     c                   endif
     c                   movel     descr         #descr           10
     c                   if        %subst(#DESCR:01:09) ='OBSOLETE-'
     c                   seton                                        91
     c                   endif
     c
     c                   if        *in91 = '0'
     c
     c                   movel     '01'          TEFIRM
     c                   clear                   TETENR
     c                   movel     ARTIKEL       TETENR
     c
     c     keykund       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c
     c     keykund       chain     teil01                             98
     C                   clear                   phy03r
     c                   exsr      sr2500
     C   98              write     phy03r
     C  n98              update    phy03r
     C                   exsr      sr2750
     C                   exsr      sr2850
     c
     c                   movel     '01'          TUFIRM
     c                   clear                   TUTENR
     c                   movel     ARTIKEL       TUTENR
     c                   movel     #TUMEIN       TUMEIN
     c
     c     keyteuf       klist
     c                   kfld                    TUFIRM
     c                   kfld                    TUTENR
     c                   kfld                    TUMEIN
     c
     c     keyteuf       chain     teuf01                             98
     C                   clear                   phy09r
     c                   exsr      sr2505
     c
     C   98              write     phy09r
     C  n98              update    phy09r
     c
     C                   endif

     C**************************************************************************
     C* sr2500:
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     C                   eval      TELOCK   =  #TELOCK
     C                   eval      TEJNAM   =  #TEJNAM
     C                   eval      TEJDAT   =  #TEJDAT
     C                   eval      TEJZEI   =  #TEJZEI
     C                   eval      TEUSER   =  #TEUSER
     C                   eval      TEPROG   =  #TEPROG
     C                   eval      TEBIBL   =  #TEBIBL
     C                   eval      TEFIRM   =  #TEFIRM
     C                   eval      TETENR   =  #TETENR
     C                   eval      TEEZNR   =  #TEEZNR
     C                   eval      TEINDX   =  #TEINDX
     C                   eval      TERALN   =  #TERALN
     C                   eval      TEWKNR   =  #TEWKNR
     C                   eval      TETBZ1   =  #TETBZ1
     C                   eval      TETBZ2   =  #TETBZ2
     C                   eval      TEZINR   =  #TEZINR
     C                   eval      TETEST   =  #TETEST
     C                   eval      TEMCBG   =  #TEMCBG
     C                   eval      TEERTE   =  #TEERTE
     C                   eval      TETART   =  #TETART
     C                   eval      TEMEIN   =  #TEMEIN
     C                   eval      TEMAGR   =  #TEMAGR
     C                   eval      TEARKZ   =  #TEARKZ
     C                   eval      TEZIFM   =  #TEZIFM
     C                   eval      TENOAR   =  #TENOAR
     C                   eval      TENONR   =  #TENONR
     C                   eval      TEGWDI   =  #TEGWDI
     C                   eval      TEEANR   =  #TEEANR
     C                   eval      TEWKST   =  #TEWKST
     C                   eval      TEFRDA   =  #TEFRDA
     C                   eval      TEAEDA   =  #TEAEDA
     C                   eval      TEAEND   =  #TEAEND
     C                   eval      TENGKZ   =  #TENGKZ
     C                   eval      TEGWNT   =  #TEGWNT
     C                   clear                   TEGWNT
     C                   eval      TEGWBR   =  #TEGWBR
     C                   clear                   TEGWBR
     C*****              eval      TEERDA   =  date
     C                   movel     date          TEERDA
     C                   eval      TEERUS   =  #TEERUS
     C                   eval      TESAAV   =  #TESAAV
     C                   eval      TEDIAV   =  #TEDIAV
     C                   eval      TELOGR   =  #TELOGR
     C                   eval      TEAUSF   =  #TEAUSF
     C                   eval      TEAUSA   =  #TEAUSA
     C                   eval      TEVOZ1   =  #TEVOZ1
     C                   eval      TEVOA1   =  #TEVOA1
     C                   eval      TEALDI   =  #TEALDI
     C                   eval      TEBESL   =  #TEBESL
     C                   eval      TEGKKZ   =  #TEGKKZ
     C                   eval      TERPZT   =  #TERPZT
     C                   eval      TEFBKZ   =  #TEFBKZ
     C                   eval      TESITG   =  #TESITG
     C                   eval      TESIBE   =  #TESIBE
     C                   eval      TEMEAV   =  #TEMEAV
     C                   eval      TEABC1   =  #TEABC1
     C                   eval      TEABC2   =  #TEABC2
     C                   eval      TEABC3   =  #TEABC3
     C                   eval      TEPDAV   =  #TEPDAV
     C                   eval      TEDUP2   =  #TEDUP2
     C                   eval      TEVEP2   =  #TEVEP2
     C                   eval      TEV2DA   =  #TEV2DA
     C                   eval      TEVEPV   =  #TEVEPV
     C                   eval      TESTPV   =  #TESTPV
     C                   eval      TESTDA   =  #TESTDA
     C                   clear                   TESTDA
     C                   eval      TESTPR   =  #TESTPR
     C                   clear                   TESTPR
     C                   eval      TEINPR   =  #TEINPR
     C                   eval      TEINDA   =  #TEINDA
     C                   eval      TEUMDA   =  #TEUMDA
     C                   eval      TEUMMG   =  #TEUMMG
     C                   eval      TEBGKZ   =  #TEBGKZ
     C                   eval      TEAPKZ   =  #TEAPKZ
     C                   eval      TESAEK   =  #TESAEK
     C                   eval      TEDIEK   =  #TEDIEK
     C                   eval      TEMEEK   =  #TEMEEK
     C                   eval      TEMPEK   =  #TEMPEK
     C                   clear                   TEMPEK
     C                   eval      TELVZ1   =  #TELVZ1
     C                   eval      TEEWPF   =  #TEEWPF
     C                   eval      TELVA1   =  #TELVA1
     C                   eval      TELVZ2   =  #TELVZ2
     C                   eval      TELVA2   =  #TELVA2
     C                   eval      TEZOTN   =  #TEZOTN
     C                   eval      TELFNR   =  #TELFNR
     C                   eval      TESTLF   =  #TESTLF
     C                   eval      TEMIBM   =  #TEMIBM
     C                   clear                   TEMIBM
     C                   eval      TEPDEK   =  #TEPDEK
     C                   eval      TEHOBS   =  #TEHOBS
     C                   eval      TELEEK   =  #TELEEK
     C                   eval      TELEBS   =  #TELEBS
     C                   eval      TELENE   =  #TELENE
     C                   eval      TELBPB   =  #TELBPB
     C                   eval      TELERE   =  #TELERE
     C                   eval      TELBPN   =  #TELBPN
     C                   eval      TEDUPR   =  #TEDUPR
     C                   eval      TEDUDA   =  #TEDUDA
     C                   eval      TEVEPR   =  #TEVEPR
     C                   eval      TEVEDA   =  #TEVEDA
     C                   eval      TELPGR   =  #TELPGR
     C                   eval      TEACDA   =  #TEACDA
     C                   eval      TEQSEK   =  #TEQSEK
     C                   eval      TEPDVK   =  #TEPDVK
     C                   eval      TEMWST   =  #TEMWST
     C                   eval      TEMPVK   =  #TEMPVK
     C                   eval      TEURLD   =  #TEURLD
     C                   eval      TEUREG   =  #TEUREG
     C                   eval      TEMEVK   =  #TEMEVK
     C                   eval      TEVPEI   =  #TEVPEI
     C                   eval      TESAVK   =  #TESAVK
     C                   eval      TEFRTA   =  #TEFRTA
     C                   eval      TEPRGR   =  #TEPRGR
     C                   eval      TEKOKZ   =  #TEKOKZ
     C                   eval      TEZOAN   =  #TEZOAN
     C                   eval      TEZPUR   =  #TEZPUR
     C                   eval      TEEBKZ   =  #TEEBKZ
     C                   eval      TEABC4   =  #TEABC4
     C                   eval      TEABC5   =  #TEABC5
     C                   eval      TEABC6   =  #TEABC6
     C                   eval      TEZUAB   =  #TEZUAB
     C                   eval      TEKASL   =  #TEKASL
     C                   eval      TEWBKT   =  #TEWBKT
     C                   eval      TEEBKT   =  #TEEBKT
     C                   eval      TEKOTR   =  #TEKOTR
     C                   eval      TELANR   =  #TELANR
     C                   eval      TEEPFG   =  #TEEPFG
     C                   eval      TEPAM1   =  #TEPAM1
     C                   eval      TEIVPE   =  #TEIVPE
     C                   eval      TELANG   =  #TELANG
     C                   eval      TEBSKZ   =  #TEBSKZ
     C                   eval      TEGBKZ   =  #TEGBKZ
     C                   eval      TEGPKZ   =  #TEGPKZ
     C                   eval      TECTKZ   =  #TECTKZ
     C                   eval      TERPKZ   =  #TERPKZ
     C                   eval      TEDALA   =  #TEDALA
     C                   eval      TEDALZ   =  #TEDALZ
     C                   eval      TEDOKZ   =  #TEDOKZ
     C                   eval      TECHKZ   =  #TECHKZ
     C                   eval      TEWEMT   =  #TEWEMT
     C                   eval      TEQSME   =  #TEQSME
     C                   eval      TEGUZT   =  #TEGUZT
     C                   eval      TEGUDI   =  #TEGUDI
     C                   eval      TEAWKZ   =  #TEAWKZ
     C                   eval      TEKDGR   =  #TEKDGR
     C                   eval      TEBONU   =  #TEBONU
     C                   eval      TEVLZ1   =  #TEVLZ1
     C                   eval      TEVLA1   =  #TEVLA1
     C                   eval      TEGBST   =  #TEGBST
     C                   eval      TEIAKZ   =  #TEIAKZ
     C                   eval      TEPEOB   =  #TEPEOB
     C                   eval      TEAFKZ   =  #TEAFKZ
     C                   eval      TEFAKZ   =  #TEFAKZ
     C                   eval      TEVIKZ   =  #TEVIKZ
     C                   eval      TEHIKZ   =  #TEHIKZ
     C                   eval      TEVAKZ   =  #TEVAKZ
     C                   eval      TEVOLA   =  #TEVOLA
     C                   eval      TELORT   =  #TELORT
     C                   eval      TETLWP   =  #TETLWP
     C                   eval      TETLWN   =  #TETLWN
     C                   eval      TETLKZ   =  #TETLKZ
     C                   eval      TEVOLU   =  #TEVOLU
     C                   clear                   TEVOLU
     C                   eval      TEDART   =  #TEDART
     C                   eval      TEPRPL   =  #TEPRPL
     C                   eval      TEVTLI   =  #TEVTLI
     C                   eval      TEKTTR   =  #TEKTTR
     C                   eval      TEHPGR   =  #TEHPGR
     C                   eval      TEWKPZ   =  #TEWKPZ
     C                   eval      TEPPKZ   =  #TEPPKZ
     C                   eval      TEVSKZ   =  #TEVSKZ
     C                   eval      TEGWRE   =  #TEGWRE
     C                   eval      TEGUZM   =  #TEGUZM
     C                   eval      TEGUDM   =  #TEGUDM
     C                   eval      TEBESC   =  #TEBESC
     C                   eval      TEBREI   =  #TEBREI
     C                   eval      TESTDV   =  #TESTDV
     C                   eval      TEBSEI   =  #TEBSEI
     C                   eval      TESAQK   =  #TESAQK
     C                   eval      TEKAFE   =  #TEKAFE
     C                   eval      TEBLAT   =  #TEBLAT
     C                   eval      TELBQM   =  #TELBQM
     C                   eval      TEVODI   =  #TEVODI
     C                   eval      TEFREX   =  #TEFREX
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
     c                   movel     ARTIKEL       TETENR
     c                   clear                   TETBZ1
     c                   movel     DESCR         TETBZ1
     c                   clear                   TEEANR
     c                   movel     EAN           TEEANR
     c                   z-add     WEIGHT        TEGWBR
     c                   movel     '89'          TETEST
     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C* sr2505:
     C*-------------------------------------------------------------------------
     C*
     C     sr2505        BEGSR
     C*
     C                   eval      TELOCK   =  *blank
     C                   eval      TUJNAM   =  §§§job
     c                   movel     date          TUJDAT
     c                   movel     zeit          TUJZEI
     C                   eval      TUUSER   =  §§§usr
     C                   eval      TUPROG   =  §§§pgm
     C                   eval      TUBIBL   =  §§§LIB
     C                   eval      TUFIRM   =  #TUFIRM
     c                   clear                   TUTENR
     c                   movel     ARTIKEL       TUTENR
     C                   eval      TUMEIN   =  #TUMEIN
     C                   eval      TUUFAK   =  #TUUFAK
     C                   eval      TUUMV1   =  #TUUMV1
     C                   eval      TUUMV2   =  #TUUMV2
     C                   eval      TUANBR   =  #TUANBR
     C                   eval      TUTUST   =  #TUTUST
     C                   eval      TUFRIN   =  #TUFRIN
     C                   eval      TUFREX   =  #TUFREX
     C*
     C     ##2505        ENDSR
     C*
     C**************************************************************************
     C* SR2750: TEOS01
     C*-------------------------------------------------------------------------
     C*
     C     SR2750        BEGSR
     C*
     c     KEY2750       klist
     c                   kfld                    TEOSFIRM
     c                   kfld                    TEOSKLCD
     c                   kfld                    TEOSTENR
     C*
     C                   movel     '01'          TEOSFIRM
     c                   movel     '1000'        TEOSKLCD
     c                   clear                   TEOSTENR
     c                   movel     ARTIKEL       TEOSTENR
     C*
     c     KEY2750       chain     TEOS01
     c                   eval      TEOSLOCK  =  *blank
     c                   eval      TEOSJNAM  =  §§§job
     c                   movel     date          TEOSJDAT
     c                   movel     zeit          TEOSJZEI
     c                   eval      TEOSUSER  =  §§§usr
     c                   eval      TEOSPROG  =  §§§pgm
     c                   eval      TEOSBIBL  =  §§§LIB
     c                   move      LENGTH        TEOSMM01
     c     ' ':'0'       xlate     TEOSMM01      TEOSMM01
     c                   move      WIDTH         TEOSMM02
     c     ' ':'0'       xlate     TEOSMM02      TEOSMM02
     c                   move      HEIGHT        TEOSMM03
     c     ' ':'0'       xlate     TEOSMM03      TEOSMM03
     c                   move      WEIGHT        TEOSMM04
     c     ' ':'0'       xlate     TEOSMM04      TEOSMM04
     C*
     c                   IF        %found(TEOS01)
     c                   update    teos1
     c                   else
     c                   write     teos1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##2750        ENDSR
     C*
     C**************************************************************************
     C* SR2850: TEEW01
     C*-------------------------------------------------------------------------
     C*
     C     SR2850        BEGSR
     C*
     C*****              goto      ##2850
     c     key2850b      klist
     c                   kfld                    TEEWFIRM
     c                   kfld                    TEEWSKUN
     C*
     C                   movel     '01'          TEEWFIRM
     C                   clear                   TEEWSKUN
     C                   movel     SKU           TEEWSKUN
     C*
     c     KEY2850b      chain     #teew                              93
     c  n93              movel     '7'           sku
     C*
     C*
     c     KEY2850       klist
     c                   kfld                    TEEWFIRM
     c                   kfld                    TEEWTENR
     C*
     C                   movel     '01'          TEEWFIRM
     c                   clear                   TEEWTENR
     c                   movel     ARTIKEL       TEEWTENR
     C*
     c     KEY2850       chain     TEEW01
     c                   eval      TEEWLOCK  =  *blank
     c                   eval      TEEWJNAM  =  §§§job
     c                   movel     date          TEEWJDAT
     c                   movel     zeit          TEEWJZEI
     c                   eval      TEEWUSER  =  §§§usr
     c                   eval      TEEWPROG  =  §§§pgm
     c                   eval      TEEWBIBL  =  §§§LIB
     c                   clear                   TEEWTENR
     c                   movel     artikel       TEEWTENR
     c                   clear                   TEEWSKUN
     c                   movel     SKU           TEEWSKUN
     c                   movel     '240'         TEEWPRGR
     C*
     c                   IF        %found(TEEW01)
     c                   update    teew1
     c                   else
     c                   movel     §§§usr        TEEWERUS
     c                   write     teew1
     c                   ENDIF                                                  %found(WAECOLCP)
     C*
     C     ##2850        ENDSR
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

     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     c                   clear                   company          02
     c                   eval      company = '01'
     c                   clear                   item             15
     c                   eval      item = '9103302938'
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
     c                   z-add     1             F1RRN
     C     F0RRN         CHAIN     ##teil                             91
     C   91              movel     '1'           error             1
     C  N91              movel     '0'           error

     C                   open      ##teew
     c                   z-add     1             F1RRN
     C     F1RRN         CHAIN     ##teew                             91
     C   91              movel     '1'           error             1

     C                   open      ##tebb
     c                   z-add     1             F1RRN
     C     F4RRN         CHAIN     ##tebb                             91
     C   91              movel     '1'           error             1

     C                   open      ##teuf
     c                   z-add     1             F2RRN
     C     F5RRN         CHAIN     ##teuf                             91
     C   91              movel     '1'           error             1

     C                   open      ##teos
     c                   z-add     1             F2RRN
     C     F6RRN         CHAIN     ##teos                             91
     C   91              movel     '1'           error             1

     c                   exsr      sr9999
     C                   close     ##teil
     C                   close     ##teew
     C                   close     ##teeb
     C                   close     ##teuf
     C                   close     ##teos

     C                   ENDSR

     C**************************************************************************
