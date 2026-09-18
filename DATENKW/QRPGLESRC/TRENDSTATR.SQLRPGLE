      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:update auf Rechnungssätze im EL-System PRJ627P,
      *               update auf Protokolldatei #lblb,
      *               update auf Trenddateien WAE-Sätze auf 20
      *               update auf Trenddateien BAE-Sätze auf 65
      *               update auf Trenddateien TEIL-Sätze
      *               
      * Zusammensetzung der WE#WE-NR.::           00011033 55904 0
      *                        laufend Zählnummer 00011033
      *                        WE# aus TREND eigen 6 Bytes alphanum
      *                            jedoch letztes Byte = *blank und
      *                            initialisiert mit *zero
      *                            es muss unterstellt werden, dass
      *                            das letzte Byte nicht mehr benutzt
      *                            wird für den Belegnummernkreis
      * Zusammensetzung der WE#WE-NR.::           00011033 55904 0
      * Juli     2010  GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#BILLSL1  ip   e             disk    RENAME(#BILLSR0:phy01r)
     fprj535p   if   e           k disk
     f#LBlbl4   uf   e           k disk    RENAME(#lblbr:phy02r)
     fPRJ627P   uf   e           k disk    RENAME(PRJ627F:phy03r)
     fBWAE09    uf   e           k disk
     fbbep00    uf   e           k disk
     fTEIL00    uf   e           k disk
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------
     IPRJ535f
     I              wkur                        §wkur
     I*-------------------------------------------------------------------------
      *                                                                     ----
      *  update          prj627p set m04 =  0                               ----
      *                          WHERE wenr = 341494106930                  ----
      *  1 Zeilen in PRJ627P in PRODWIN51 aktualisiert.                     ----
      *                                                                     ----

     c                   clear                   §buchung
     c                   setoff                                       40

     c                   if        wenr  =    408008124834
     c*****                        wenr    =  427340107885    or
     c*****                        wenr    =  430458110413
     c                   clear                   sdsad             1
     c                   if        FIBSTA  <> M04
      *                 Bestellungsvorgang lesen für ANGPOS (Position)        
     c     wenr          chain     PRJ535P
     C                   if        %found(PRJ535P)
     c                   exsr      sr0000
     c                   endif
     c                   endif
     c                   endif
     Clr                 out       count
     C*
     C**************************************************************************
     C*Lesezyklus in Abhängigkeit von %found(PRJ535P) und
     C*                               FIBSTA  <> M04
     C*-------------------------------------------------------------------------
     C*
     C     sr0000        BEGSR
     C*
     c                   seton                                        40
      *
     C     KEY9820       KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEBENR
     C                   KFLD                    #WE#EL
     C                   KFLD                    #AEBEPO
     C     *LIKE         DEFINE    #AEFIRM       §AEFIRM
     C     *LIKE         DEFINE    #AEBENR       §AEBENR
     C     *LIKE         DEFINE    #AEWENR       §AEWENR
     c     *LIKE         DEFINE    #AEBEPO       §AEBEPO
     c     *LIKE         DEFINE    #buchung      §buchung
     C
     C                   movel     '01'          #AEFIRM
     C
     C                   move      bstnum        §bestell         07
     C                   move      wenr          §wenr            14
 mg01C                   z-add     wenr          #WE#EL           14 0
     C                   eval      #AEBENR   =  %subst(§bestell: 2: 6)
     C                   eval      #AEWENR   =  %subst(§wenr   : 9: 6)
     C                   move      '  '          #AEBENR
     C                   z-add     angpos        #aebepo
     C
     C                   setoff                                       55
     C                   eval      §AEFIRM   =   #AEFIRM
     C                   eval      §AEBENR   =   #AEBENR
     C                   eval      §AEWENR   =   #AEWENR
     C                   eval      §AEBEPO   =   #AEBEPO
     C                   setoff                                           95
     C
     C     KEY9820       SETLL     #LBlbl4                            99
     C                   DO        *HIVAL
     C                   READ      #LBlbl4                                95
     C                   if        ( §AEFIRM <> #AEFIRM   or
     C                               §AEBENR <> #AEBENR   or
     C                               wenr    <> #WE#EL    or
     C                               §AEBEPO <> #AEBEPO  )
     C                   seton                                            95
     C                   endif
     C   95              LEAVE
     C                   if          #WE#EL  =  wenr
     C                   clear                   #STATUSX
     C                   movel     FIBSTA        #STATUSX
     C                   clear                   #AETLKZ
     c   40              exsr      sr1000
     c   40              exsr      sr1500
     c   40              exsr      sr1750
     c   40              exsr      sr2000
     c                   movel     §buchung      #buchung
     c************       setoff                                       40
     C                   update    phy02r
     C* n55              unlock    #LBlbl4
     C                   endif
     C                   enddo
     C*
     C     ##0000        ENDSR
     C*
     C**************************************************************************
     C*Wareneingangsposition auf 90 Sätzen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
      *                 Wareneingang lesen                                    
     C     KEY1000       KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEWEJJ
     C                   KFLD                    $AEWENR
     C     KEY1000b      KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEWEJJ
     C                   KFLD                    $AEWENN
      *                 Wareneingang lesen                                    
     C                   movel     #AEWENR       $AEWENR           6 0
     C                   clear                   $AEWENN           6
     C*
     c     KEY1000       chain     bwae09
     c                   IF        %found(bwae09)
     c                   movel     AETLKZ        #AETLKZ           1
     c                   movel     '90'          aewest
     c                   eval      %subst(§buchung: 1: 1) = '1'
     c                   update    BWAE1
     C* n55              unlock    BWAE09
     c                   else
     c*                  vorher    '3918__' dann '__9318'
     c                   evalr     $AEWENN = %trimr(#AEWENR)
     c*                  und zurück auf   '9918__'
     c                   evalr     $AEWENN = %triml(#AEWENR)
     C*
     c                   evalr     $AEWENN = %trimr(#AEWENR)
     C                   movel     $AEWENN       $AEWENR           6 0
     c     KEY1000       chain     bwae09
     c                   IF        %found(bwae09)
     c                   movel     AETLKZ        #AETLKZ           1
     c                   movel     '90'          aewest
     c                   eval      %subst(§buchung: 1: 1) = '1'
     c                   update    BWAE1
     C* n55              unlock    BWAE09
     c                   ENDIF
     c                   ENDIF
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*Bestellpositionen auf 65 Sätzen
      *                 Sicherung abhängiger Disposätze  Kennung 023          
     #*                 Löschung  abhängiger Disposätze  Kennung 023          
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*
      *                 Bestellposition                                       
     C     KEY1500       KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEBeJJ
     C                   KFLD                    #AEBenr
     C                   KFLD                    #AEBEPO
     C*
     c     key1500       chain     bbep00
     C                   if        %found(bbep00)
     c                   exsr      sr2600
     c                   exsr      sr2700
     c                   eval      #recmng  = #recmng + #EPBRMG
     c*******            movel     epbest        #STATUSBEP
     c*******nein        z-add     #recmng       EPGLMG       13.09.2010
     c                   z-add     #recmng       EPBRMG
     c                   if        #recmng  < epmeng
     c                   movel     '36'          epbest
     c                   else
     c                   movel     '65'          epbest
     c                   endif
     c                   if        #AETLKZ  = 'J'
     c                   movel     '65'          epbest
     c                   endif
     c
     c                   eval      %subst(§buchung: 2: 1) = '1'
     c                   update    BBEP1
     C* n55              unlock    BBEP00

      *                  hinweis: habe einige manuell gelöscht, key wohl
      *                  nicht immer korrekt
      *                  siehe datenkw/#dis00
     **                 Sicherung abhängiger Disposätze in datenkw/#DIST00    
     C                   if        epbest   =   '65'
     C                   clear                   md
     C                   movel     #AEBeJJ       #hlp001           4
     C                   movea(p)  #hlp001       md(001)
     C                   movea(p)  #AEBenr       md(005)
     C                   move      #AEBEPO       #hlp002           5
     C                   movel     '0'           #hlp002           5
     C                   movea(p)  #hlp002       md(011)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#KW0020'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DIST00'     OUTFIL           10
     C                   PARM      'DATENKW'     LIB              10
     C                   PARM      '*ADD    '    REPADD           10
      *                 Löschung  abhängiger Disposätze                       
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#KW0021'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *BLANK        OUTFIL           10
     C                   PARM      *BLANK        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C                   endif

     c                   ENDIF
     C*
     C     ##1500        ENDSR
     C*
     C**************************************************************************
     C*Preisstellungen im Artikelstamm aktualisieren
     C*-------------------------------------------------------------------------
     C*
     C     sr1750        BEGSR
     C*
      *                 Artikeldatei                                          
     C     KEY1750       KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #LBLBTENR
     C*
     c     key1750       chain     TEIL00
     C                   if        %found(TEIL00)
     C*l re-Datum 20100517, RP PreisBrutto, RP PreisNetto
     c                   z-add     redat         TELERE
     c   55              eval      #WERTN  = (TELEEK * 10)
     c   55              movel     date          #werta
     c   55              eval      TELEEK  = (recbtr*wkur*1,19/RECMNG)
     c   55              eval      TELENE  = (recbtr*wkur/RECMNG)
     c   55              eval      %subst(§buchung: 3: 1) = '1'
     c   55              eval      count = count +1
     c   55              move      count         §buchung
     c   55              update    teil1
     C  n55              unlock    TEIL00
     c                   ENDIF
     C*
     C     ##1750        ENDSR
     C*
     C**************************************************************************
     C*Rechnungssätze Positionen aktualisieren
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     C     KEY2000       KLIST
     C                   KFLD                    RENR
     C                   KFLD                    REPOS
     C*
     c     KEY2000       chain     PRJ627P
     c                   IF        %found(PRJ627P)
     c                   z-add     FIBSTA        M04
     c                   eval      %subst(§buchung: 4: 1) = '1'
     c                   update    phy03r
     C**                 unlock    PRJ627P
     c                   endif
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*sr2600: Mengen aus rechnungen ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     sr2600        BEGSR
     C*
      *                 lesen rechnungsbezug ermitteln                        
     C     *LIKE         DEFINE    recmng        #recmng
     C     *LIKE         DEFINE    bstnum        #bstnum
     C     *LIKE         DEFINE    bstpos        #bstpos
     C                   clear                   #recmng
     C                   clear                   #bstnum
     C                   clear                   #bstpos
     C                   clear                   #bstpos
     C                   z-add     bstnum        #bstnum
     C                   z-add     bstpos        #bstpos
     C*
     c/exec sql
     c+ whenever not found goto ##2600
     c/end-exec
     C*
     c/exec sql
     c+ SELECT   sum(recmng) into
     c+          :#recmng
     c+ from  prodwin51/PRJ627P
     c+ where bstnum   = :#bstnum  and
     c+       bstpos   = :#bstpos  and
     c+       ARTNUM   = :#ARTNUMS and
     c+       fibsta = 1
     c/end-exec
     C*
     C
     C     ##2600        ENDSR
     C*
     C**************************************************************************
     C*sr2700: Mengen aus Historie ermitteln
     C*-------------------------------------------------------------------------
     C*
     C     sr2700        BEGSR
     C*
      *                 ...                                                   
     C     *LIKE         DEFINE    EPBRMG        #EPBRMG
     C     *LIKE         DEFINE    EPBENR        #EPBENR
     C     *LIKE         DEFINE    EPBEPO        #EPBEPO
     C                   clear                   #EPBRMG
     C                   clear                   #bstnum
     C                   clear                   #bstpos
     C                   movel     EPBENR        #EPBENR
     C                   movel     EPBEPO        #EPBEPO
     C*
     c/exec sql
     c+ whenever not found goto ##2700
     c/end-exec
     C*
     c/exec sql
     c+ SELECT   sum(EPBRMG) into
     c+          :#EPBRMG
     c+ from  datenkw/#BBEP00
     c+ where EPBENR   = :#EPBENR and
     c+       EPBEPO   = :#EPBEPO
     c/end-exec
     C*
     C
     C     ##2700        ENDSR
     C*
     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C     *DTAARA       DEFINE                  count             6 0
     C     *lock         IN        count
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   out       count
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
