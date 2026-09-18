      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Call Anzeige Dokument
      *               
      * Juni     2010  GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     f#LBlbl2   if   e           k disk
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

     C*
     C     *ENTRY        PLIST
     C                   PARM                    #firma            3 0
     C                   PARM                    #user            10
     C                   PARM                    #bestell         10 0
     C                   PARM                    #wenr            14 0
     c
     c                   eval      #firma   =    01
     c*                  eval      #user    =    'GANG      '
     c*                  eval      #bestell =    00000556700
     c*                  eval      #wenr    =    00000000156569
      *
      * Zusammensetzung der WE#WE-NR.::           00011033 55904 0
      *                        laufend Zählnummer 00011033
      *                        WE# aus TREND eigen 6 Bytes alphanum
      *                            jedoch letztes Byte = *blank und
      *                            initialisiert mit *zero
      *                            es muss unterstellt werden, dass
      *                            das letzte Byte nicht mehr benutzt
      *                            wird für den Belegnummernkreis
      * Zusammensetzung der WE#WE-NR.::           00011033 55904 0
     C     KEY9820       KLIST
     C                   KFLD                    #AEFIRM
     C                   KFLD                    #AEBENR
     C                   KFLD                    #AEWENR
     C
     C                   movel     '01'          #AEFIRM
     C
     C                   move      #bestell      §bestell         10
     C                   move      #wenr         §wenr            14
     C                   eval      #AEBENR   =  %subst(§bestell: 5: 6)
     C                   eval      #AEWENR   =  %subst(§wenr   : 9: 6)
     C                   move      ' '           #AEBENR
     C
     c     KEY9820       chain     #LBlbl2
     c                   IF        %found(#LBlbl2)
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   endif
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*call auf Anzeige und Konvertierung des Spools
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C                   movel     #AEBEJJ       $AEBEJJ           4
     C                   call      'DOKUMENTC'
     C                   parm                    $AEBEJJ
     C                   parm                    #AEBENR
     C                   parm                    #user
     C*
     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*Integration des Spools (eigentlich der temporären Datei)
     C*into: prodwin51/prjbst051
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into  prodwin51/prjbst051
     c+ SELECT
     c+ :#user,  :#bestell,  RRN(TRBA47), TRBA47
     c+ FROM qtemp/TRBA47
     c/end-exec
     C*
     C     ##2000        ENDSR
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
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
