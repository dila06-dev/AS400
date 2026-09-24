      *-------------------------------------------------------------------------
      *  Dieses Programm wird aus eigenen Anwenungen aufgerufen
      *
      *
      *  Es zeigt dem Anwender die ausgewählten archivierten Dokumente an.
      *  dspffd aisobj/ifxpar
      *------------------------------------------------------------------------
      *  A C H T U N G
      *  A C H T U N G
      *  A C H T U N G
      *  A C H T U N G
      *
      *  In diesem Source wurden bereits Änderungen für Easy vorgenommen. Nicht
      *  fertig nicht getestet. Für Änderungen DVS/400 Archiv FREMDARCHO ver-
      *  wenden
      *------------------------------------------------------------------------
      *
      *  M. Ahorner
      *
      *-------------------------------------------------------------------------
     Ffremdarch cf   e             workstn UsrOpn
      * DVS/400
     Fdocil5    if   e           k disk
      *-------------------------------------------------------------------------
      *  Konstanten
      *-------------------------------------------------------------------------

      * Schilling
     D cKt             c                   Const('KT')
     D cBw             c                   Const('BW')
     D cBew            C                   Const('BEW')
     D cOp             C                   Const('OP')
     D cOa             C                   Const('OA')
     D cOpA            C                   Const('OPA')
     D cOs             C                   Const('OS')
     D cBp             C                   Const('BP')
     D cDebitor        c                   Const('1')
     D cKreditor       c                   Const('2')
     D cSachkonto      c                   Const('3')
     D cInstFunkt      c                   Const('KT BEWBP OP BS OP OA OPA OP O-
     D                                     P OS OP BW BEWBWDBEW')

      * DVS/400
     D ccEingrg        c                   Const('EING.RG.')
     D ccAusgAvw       c                   Const('AUSG.AVW')
     D ccKreditor      c                   Const('L')
     D ccDebitor       c                   Const('K')
     D ccSachkonto     c                   Const('S')

     D cDVS400         c                   Const('DVS400')
     D CEasyArchiv     c                   Const('EasyArchiv')
      *-------------------------------------------------------------------------
      *  Variable
      *-------------------------------------------------------------------------
     D ktoArt          s              1
     D gKtoArt         s              1
     D CmdStr          s             80
     D CmdStrLen       s             15  5
     D Archiv          s             10
     D SelFunkt        s              6
      *-------------------------------------------------------------------------
      *  Datenstrukturen
      *-------------------------------------------------------------------------
     D PgmDs          sds
     D  jWsName              244    253
     D  jUser                254    263
     D  jJobNbr              264    269

      * DVS/400 Übergabeparameter DOCEINZ
     D pParmDs         ds
     d pdifir                         3
     d pdikdnr                       10
     d pdirgnr                       10
     d pdirgda                        6
     d pdityp                         8
     d pdikz                          1
     d pwsname                       10
     d pmsgid                         7
     d pdildkz                        3
     d pdiakta                        1
EIMP d panzkz                         1

      * Synchron-Übergabeparameter
     d IfxPar        e ds

      * Schilling Übergabeparameter an FREMDARCH
     D pParm           ds          1024
      * Kopfdaten
     D  pFir                          5
     D  pFunkt                        3
     D  pKto                          9
     D  pKBer                         3
     D  pRefKto                       9
     D  pKWhrg                        3
     D  pBuPerV                       6
     D  pBuPerB                       6
     D  pKKst                         8
     D  pKKtr                        19
     D  pKProj                       10
     D  pKbzg                         4
     D  pFiller_01                   98
     D  pRCode                        1
     D  pFtx                         72
      * Info abhängig von Cursorstellung
     D  pDatenTyp                     3
     D  pKtoC                         9
     D  pOpNrC                       10s 0
     D  pOpUNrC                       2s 0
     D  pBelegNrC                    10s 0
     D  pBelegJJMTC                   8
     D  pBupJJMC                      6
     D  pFaelJJMTC                    8
     D  pGegenKtoC                    9
     D  pBelegArtC                    3
     D  pBelegArtRefC                 3
     D  pHerkunftC                    1
      * Funktion OP, BP
     D  pSaldC                       13p 2
     D  pUrDMC                       13p 2
     D  pDMC                         13p 2
      * Funktion KT
     D  pPosDMC                      13p 2
     D  pPosStDMC                    13p 2
     D  pShKzC                        1
     D  pErfEURoKzC                   1
     D  pStSlC                        2
     D  pWhrgC                        3
     D  pWhrEinhC                     1
     D  pWhrKusr                      9p 5
     D  pErfKursKzC                   1
      * Funktion OP, BP
     D  pWhrSaldC                    13p 2
     D  pUrWhrgDMC                   13p 2
     D  pWhrDMC                      13p 2
      * Funktion KT
     D  pPosWhrDMC                   13p 2
     D  pPosStWhrDMC                 13p 2
     D  pBereichC                     3
     D  pKstC                         8
     D  pKstrC                       19
     D  pProjC                       10
     D  pOpRestKzC                    1
     D  pOpRestSlC                    2
     D  pMahnKzC                      1
     D  pMahnPausSlC                  2
     D  pMahnStC                      1s 0
     D  pLtzMahnJJMTC                 8
     D  pZahlKzC                      1
     D  pLieferNrC                   25
      * Funktion BW, BWD, BWL
     D  pBewArt                       3
     D  pKoreHerkC                    1
      * Funktion BW, BWD, BWL
     D  pBzgC                         4
     D  pMgC                         11p 3
     D  pFiller_02                   42
      * Funktion OP, BP
     D  pEUSaldC                     13p 2
     D  pUrEUDMC                     13p 2
      * Funktion KT
     D  pPosEUDMC                    13p 2
     D  pPosStEUDMC                  13p 2
     D  pFiller_03                  439
     D  pEndKz                        1

     C     *Entry        Plist
     c                   Parm                    pParm

      * DVS/400
     C     IndKey        Klist
     C                   Kfld                    pdifir
     C                   Kfld                    pdiakta
     C                   Kfld                    pdityp
     C                   Kfld                    pdikdnr
     C                   Kfld                    pdirgnr

      * Aufgerufene Funktion prüfen
     c                   Eval      SelFunkt = pFunkt +
     c                                        pDatenTyp
     c                   If        %scan(SelFunkt:cInstFunkt) = 0
     c                   Exsr      Nachricht
     c                   Eval      *inlr = *on
     c                   Return
     c                   Endif

      * Kontenart Schilling festellen (aus Kopf)
     c                   Eval      ktoArt = %subst(pKto:1:1)

      * Aufruf Routine je Kontenart
     C                   Select

     C                   When      ktoArt = cDebitor
     C                   Exsr      SubKunde
     C                   When      ktoArt = cKreditor
     C                   Exsr      SubLieferant
     C                   When      ktoArt = cSachkonto
     C                   Exsr      SubSachkonto
     c                   Other
     c                   Exsr      Nachricht

     C                   Endsl

     c                   Eval      *inlr = *on
     c                   Return

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     SubKunde      Begsr

     c                   Select

     c                   When      pDatenTyp = cBew or
     c                             pDatenTyp = cOp  or
     c                             pDatenTyp = cOpA
     c                   Exsr      SubPosten
     c                   When      pDatenTyp = *blank
     c                   Exsr      SubKopf

     c                   Endsl

     C                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     SubLieferant  Begsr

     c                   Select

     c                   When      pDatenTyp = cBew or
     c                             pDatenTyp = cOp  or
     c                             pDatenTyp = cOpA
     c                   Exsr      SubPosten
     c                   When      pDatenTyp = *blank
     c                   Exsr      SubKopf

     c                   Endsl

     c                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     SubSachkonto  Begsr

     c                   Select

     c                   When      pDatenTyp = cBew or
     c                             pDatenTyp = cOp  or
     c                             pDatenTyp = cOpA
     c                   Exsr      SubPosten
     c                   Other
     c                   Exsr      SubKopf

     c                   Endsl

     C                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     SubPosten     Begsr

     C                   Select

     c                   When      Archiv = cDVS400
     c                   Exsr      EasyArchiv
     c                   When      Archiv = cEasyArchiv
     c                   Exsr      EasyArchiv

     c                   Endsl

     c                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     DVS400        Begsr

     c                   Clear                   pParmDs

     C                   Move      pFir          pdifir
     c                   Eval      pwsname= jwsname

      * Konto finden
     c                   If        pDatenTyp <> cBew
     c                   If        pFunkt =  cOp or
     c                             pFunkt = cOs
     C                   Eval      pdikdnr= '0' + pKtoC
     c                   Else
     C                   Eval      pdikdnr= '0' + pKtoC
     C                   Eval      pdikdnr= '0' + pGegenKtoC
     c                   Endif
     c                   Else
     c                   If        pFunkt = cBw or
     c                             ktoArt = cSachkonto
     C                   Eval      pdikdnr= '0' + pGegenKtoC
     c                   Else
     C                   Eval      pdikdnr= '0' + pKtoC
     c                   Endif
     c                   Endif

      * Aktenart und Aktentyp ermitteln
     c                   Select

     c                   When      ktoArt = cKreditor
     C                   Eval      pdiakta= ccKreditor
     C                   Eval      pdityp = ccEingRg
     c                   When      ktoArt = cDebitor
     C                   Eval      pdiakta= ccDebitor
     C                   Eval      pdityp = ccAusgAvw
     c                   When      ktoArt = cSachkonto
     c                   Eval      gKtoArt= %subst(pGegenKtoC:1:1)
     c                   Select
     c                   When      gKtoArt = cKreditor
     C                   Eval      pdiakta= ccKreditor
     C                   Eval      pdityp = ccEingRg
     c                   When      gKtoArt = cDebitor
     C                   Eval      pdiakta= ccDebitor
     C                   Eval      pdityp = ccAusgAvw
     c                   Other
     c                   Exsr      Nachricht
     c                   Leavesr
     c                   Endsl
     c
     c                   Endsl

      * Rechnungsnummer ermitteln
     C                   Select

     C                   When      pDatenTyp <> cBew
     C                   Move      pOpNrC        pdirgnr
     C                   Other
     C                   Move      pBelegNrC     pdirgnr

     C                   Endsl

      * Daten aus DOCIND/DOCCTLS lesen
     C     IndKey        Setll     dil5
     C     IndKey        Reade     dil5
      * Wenn nicht archiviert, Nachricht Rücksprung
     C                   If        %eof(docil5)
     c                   Eval      *in99 = *on
     c                   Exsr      Nachricht
     C                   LeaveSr
     C                   Endif

      * Dokument aus Archiv anzeigen
     c                   Move      dirgda        pdirgda
     c                   Eval      pdildkz = 'D  '
     C                   Eval      pmsgid = 'DXX0521'

     C                   Call      'DOCEINZ'
     c                   Parm                    pdifir
     c                   Parm                    pdikdnr
     c                   Parm                    pdirgnr
     c                   Parm                    pdirgda
     c                   Parm                    pdityp
     c                   Parm                    pdikz
     c                   Parm                    jwsname
     c                   Parm                    pmsgid
     c                   Parm                    pdildkz
     c                   Parm                    pdiakta
     c                   Parm                    panzkz
     C
     C                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     EasyArchiv    Begsr

      * Aktenart und Aktentyp ermitteln
     c                   Select

     c                   When      ktoArt = cKreditor
     C                   Eval      pdiakta= ccKreditor
     C                   Eval      pdityp = ccEingRg
     c                   When      ktoArt = cDebitor
     C                   Eval      pdiakta= ccDebitor
     C                   Eval      pdityp = ccAusgAvw
     c                   When      ktoArt = cSachkonto
     c                   Eval      gKtoArt= %subst(pGegenKtoC:1:1)
     c                   Select
     c                   When      gKtoArt = cKreditor
     C                   Eval      pdiakta= ccKreditor
     C                   Eval      pdityp = ccEingRg
     c                   When      gKtoArt = cDebitor
     C                   Eval      pdiakta= ccDebitor
     C                   Eval      pdityp = ccAusgAvw
     c                   Other
     c                   Exsr      Nachricht
     c                   Leavesr
     c                   Endsl
     c
     c                   Endsl

      * Rechnungsnummer ermitteln
     C                   Select

     C                   When      pDatenTyp <> cBew
     C                   Move      pOpNrC        pdirgnr
     C                   Other
     C                   Move      pBelegNrC     pdirgnr

     C                   Endsl
     c                   Clear                   IfxPar

      * KZ-Rechercheart
      * 'X' = X-Web-Client
     C                   Eval      XSKZRE = 'W'
      * Sprachkürzel
     C                   Eval      XSLOCA = 'de'
      * KZ-Trefferliste
     C                   Eval      xskhit = '1'

      *----------------------------------------------------
      * Unit
     C                   Eval      xsun01 = 'Default'
      * Instance
     C                   Eval      xsin01 = 'Default'
      * View
     c                   Eval      xsvw01 = 'FiBu       '

      *---Indexfeld 1-Firma -------------------------------
      * Dokumentenschema
     c                   Eval      xsch01 = 'DometicBasis'
      * Indexfeldname
     c                   Eval      xsfl01 = 'Firma'
      * Suchbegriff
     c                   move      pfir          pfirx             3
     c                   movel     pfirx         xsix01
      * Bei Angabe von '1' werden die führenden Nullen entfernt
     c                   Eval      xskn01 = '0'

      *---Indexfeld 2-Rechnungsnummer ---------------------
     c                   Eval      xsch02 = 'DometicBasis'
      * Indexfeldname
     c                   Eval      xsfl02 = 'Rechnungsnummer'
      * Suchbegriff
     c                   movel     pbelegnrc     xsix02
      * Bei Angabe von '1' werden die führenden Nullen entfernt
     c                   Eval      xskn02 = '1'

      *---Indexfeld 3-Gegenkontor -------------------------
     c                   Eval      xsch03 = 'DometicBasis'
      * Indexfeldname
     c                   Eval      xsfl03 = 'Kontonummer'
      * Suchbegriff
     c                   movel     pgegenktoc    xsix03
     c                   if        %subst(pKto:1:1) = '1'
     c                   Eval      xsix03 = %subst(pKto:2:6)
     c                   endif
      * '1' werden die führenden Nullen entfernt
     c                   Eval      xskn03 = '1'


      * Rechere-Programm aufrufen
     C                   CALL      'LIBADD  '
     C                   PARM      '1'           x                 1
     C                   CALL      'AIR20XCL'
     C                   PARM                    IFXPAR
     C                   CALL      'LIBADD  '
     C                   PARM      '0'           x                 1

     c                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     SubKopf       Begsr

      * Aus den Kopfdaten keine Anzeige implementiert

     c                   Eval      *in98 = *on

     c                   Exsr      Nachricht

     C                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     Nachricht     Begsr

      * Fehlerhafte Situation anzeigen
     c                   Select

     c                   When      pDatenTyp = cBew or
     c                             pDatentyp = cOp  or
     c                             pDatentyp = cBp
     C                   Eval      bKtoArt = gKtoArt
     c                   Other
     C                   Eval      bKtoArt = ktoArt

     c                   Endsl

     C                   Eval      bKto    = %subst(pdikdnr:2)
     C                   Eval      bFunkt  = pFunkt +
     c                                          '/' +
     c                                          pDatenTyp
     c                   If        *in99
     c                   Eval      bRgNr   = pdirgnr
     c                   Endif

     c                   Open      fremdarch
     c                   Exfmt     FMT01
     c                   Close     fremdarch

     C                   Endsr

      *-------------------------------------------------------------------------
      *
      *-------------------------------------------------------------------------

     C     *Inzsr        Begsr

      * Bibliotheken hinzufügen
     C                   Eval      CmdStr = 'ADDLIBLE LIB(DOCS) ' +
     c                                      'POSITION(*LAST)'
     c                   Eval      CmdStrLen = %len(%trim(CmdStr))
     c                   Call(e)   'QCMDEXC'
     c                   Parm                    CmdStr
     c                   Parm                    CmdStrLen
     C                   Eval      CmdStr = 'ADDLIBLE LIB(DOCD) ' +
     c                                      'POSITION(*LAST)'
     c                   Eval      CmdStrLen = %len(%trim(CmdStr))
     c                   Call(e)   'QCMDEXC'
     c                   Parm                    CmdStr
     c                   Parm                    CmdStrLen
     C                   Eval      CmdStr = 'ADDLIBLE LIB(DOCE) ' +
     c                                      'POSITION(*LAST)'
     c                   Eval      CmdStrLen = %len(%trim(CmdStr))
     c                   Call(e)   'QCMDEXC'
     c                   Parm                    CmdStr
     c                   Parm                    CmdStrLen
     C                   Eval      CmdStr = 'ADDLIBLE LIB(DOCALLE) ' +
     c                                      'POSITION(*LAST)'
     c                   Eval      CmdStrLen = %len(%trim(CmdStr))
     c                   Call(e)   'QCMDEXC'
     c                   Parm                    CmdStr
     c                   Parm                    CmdStrLen

     c     *DTAARA       Define                  ARCHIV
     c                   In        Archiv

     c                   Endsr
