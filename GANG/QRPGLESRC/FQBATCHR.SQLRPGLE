      * PROGRAMMNAME.:Interface fqbatch füllen                                
      * FUNKTION.....:Hinweis:
      * FUNKTION.....:
      * Jan. 2010      GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
     F**************************************************************************
     D*-------------------------------------------------------------------------
     Fpersinter if   E             DISK    INFSR(*PSSR)
     F                                     RENAME(persinter:log01R)
     Ffqbatch   uF a E           k DISK
     F***                                  USROPN
     F                                     RENAME(bcsatz:phy01r)
     D*-------------------------------------------------------------------------
     D**************************************************************************
     D/COPY ##E
     D**************************************************************************
     Ddatvgl           s               D
     Ddatvgl2          s               D
     D*-------------------------------------------------------------------------
     D*-------------------------------------------------------------------------
     Dtstamp           s               Z
     Dtdate            s               d
     Dvdate            s               d
     D*-------------------------------------------------------------------------
     D* PROGRAMMSPEZIFISCHE ZUWEISUNGEN FÜR MELDUNGEN
     D CTLPGM          DS
     D  I§§§01               161    168    INZ('FQBATCH ')
     D  I§§§02               169    176    INZ('    0000')
     D*
     I*-------------------------------------------------------------------------
     I/COPY ##I001
     I/COPY ##I002
     I/COPY ##I003
     I*-------------------------------------------------------------------------
     C**************************************************************************
     C*
     C                   DO        *HIVAL
     C                   READ      persinter                              90
     C   90              LEAVE
     C*
      *                 verarbeitung
     C                   if        w_lw <> 0
     C                   clear                   phy01r
     C                   exsr      SR_hab218
     C                   endif
     C*
     C                   enddo
     C*
     C                   EXSR      RETURN
     C*
     C**************************************************************************
     C* übergabe der Hab218
     C*-------------------------------------------------------------------------
     C*
     C     SR_hab218     BEGSR
     C*
      *   Verarbeitung nur Führungsbuchung ohne KZ FB
      *                    Konto, Gegenkonto und Betrag ' '
     C*
     C                   z-add     000000        satzanz           6 0
     C                   movel     '000'         satzmo            3
     C                   movel     '000'         satzln            3
     C                   eval      satzmo = %subst(DAT_ABR:4:3)
     C                   movel     satzmo        satzanz
     C                   eval      satzln = %subst(HBREC:3:3)
     C                   move      satzln        satzanz
     C*
     C                   movel     '0'           HBREC
     C                   if        user_upd      = 'BAB558C  '
     C                   movel     '1'           BCSTAT
     C                   movel     '0206'        BCRSNR
     C*                  movel     release       BCRSNR
     C                   z-add     1             bcfa
     C*
     C*                  z-add     0             BCRCNR
      *      Satznummer übergeben aus PGM bzw. CL
     C                   if        user_upd      = 'BAB0505R '
     C                   z-add     5050000000    BCRCNR
     C                   endif
     C*
     C                   movel     ' '           BCFGKZ
     C*
      *                 Kreditversicherung
     C                   if        user_upd      = 'BAB603   '
     C                   move      'KV '         BCBGAR
     C                   endif
      *      ende
     C                   movel     ' '           BCSTOR
     C                   movel     DAT_BEL       BCBGJT
     C                   movel     DAT_ABR       BCJP
     C*                  move      BEL           BCBGNR
     C                   z-add     BCRCNR        BCBGNR
     C*
     C                   movel     ' '           BCKTO
     C                   movel     ' '           BCGKTO
     C                   if        KZ_S_H        = '1'
     C                   move      'S'           BCSH
     C                   endif
     C                   if        KZ_S_H        = '2'
     C                   move      'H'           BCSH
     C                   endif
     C                   z-add     0             BCQDM
     C                   movel     '+'           BCDMVZ
     C                   movel     '  '          BCSTSL
     C                   z-add     0             BCQSTD
     C                   z-add     0             BCQWGD
     C                   z-add     0             BCQWGS
     C                   movel     '   '         BCWG
     C                   z-add     0             BCQKUR
     C                   movel     '   '         BCBR
     C                   movel     ' '           BCKS
     C                   movel     ' '           BCKTR
     C                   movel     ' '           BCPJ
     C                   movel     ' '           BCLERN
     C                   movel     ' '           BCHK
     C                   movel     '  '          BCBGTS
     C                   movel     'Führungs-'   BCBGT1
     C                   move      'buchung'     BCBGT1
     C*
     C*****              move      satzanz       BCOPNR
     C*
     C                   movel     'PGM'         BCAEUS
     C                   movel     USER_UPD      BCAEWS
     C                   movel     ZM_UPD        BCAEJT
     C*
     C                   movel     'J'           BCEFEU
     C                   Z-ADD     0             BCQDE
     C*
     C                   movel     ' '           BCMM01
     C                   movel     ' '           BCMM02
     C                   movel     ' '           BCMM03
     C                   movel     ' '           BCMM04
     C                   movel     ' '           BCMM05
     C                   movel     ' '           BCMM06
     C                   movel     ' '           BCMM07
     C*
     C                   movel     ' '           BCMM13
     C                   movel     ' '           BCMM14
     C                   movel     ' '           BCMM15
     C                   write     phy01r
     C                   endif
     C*
     C**********************************************************************
      *   Ende der Führungsbuchung
     C**********************************************************************
     C*
     C                   movel     '1'           BCSTAT
     C                   movel     '0206'        BCRSNR
     C*                  movel     release       BCRSNR
     C                   z-add     2             bcfa
     C*                  move      HBREC         zhbrec            5 0
     C*                  z-add     zhbrec        BCRCNR
     C**                 z-add     1             BCRCNR
      *      Satznummer übergeben aus PGM bzw. CL
     C                   if        user_upd      = 'BAB558C  '
     C                   z-add     5583000000    BCRCNR
     C                   endif
     C*
     C                   movel     'A'           BCFGKZ
     C*                  movel     BEL_ART       BCBGAR
      *                 Kreditversicherung
     C                   if        user_upd      = 'BAB603   '   or
     C                             user_upd      = 'BAB4600  '
     C                   move      'KV '         BCBGAR
     C                   endif
      *      ende
     C                   movel     ' '           BCSTOR
     C                   movel     DAT_BEL       BCBGJT
     C                   movel     DAT_ABR       BCJP
     C*                  move      BEL           BCBGNR
     C                   z-add     BCRCNR        BCBGNR
     C*
     C*                  movel     '0'           BCKTO
     C*                  movel     KTO           BCKTO
     C*                  movel     '3'           BCKTO
     C                   z-add     0             kto01             4 0
     C                   z-add     0             kto02             5 0
     C                   z-add     0             kto03             6 0
     C                   movel     kto           kto01
     C     kto01         add       30000         kto02
     C     kto02         mult      10            kto03
     C                   movel     kto03         BCKTO
     C                   if        KTO           = '1899    '
     C                   movel     '318992'      bckto
     C                   endif
     C*** ???            movel     'F'           BCGKTO
     C                   move      'S'           BCSH
     C                   move      'H'           BCSH
     C                   z-add     0             BCQDM
     C                   movel     '+'           BCDMVZ
     C                   movel     '  '          BCSTSL
     C                   z-add     0             BCQSTD
     C                   z-add     0             BCQWGD
     C                   z-add     0             BCQWGS
     C                   movel     '   '         BCWG
     C                   z-add     0             BCQKUR
     C                   movel     '   '         BCBR
     C                   movel     OS_KS         BCKS
     C                   movel     ' '           BCKTR
     C                   if        PRJ           <> ' '
     C                   move      PRJ           prj01             8
     C                   movel     '00'          prj01
     C                   movel     prj01         BCPJ
     C                   endif
     C                   movel     ' '           BCLERN
     C                   movel     ' '           BCHK
     C                   movel     '  '          BCBGTS
     C                   movel     ' text '      BCBGT1
     C                   movel     ' text '      BCBGT2
     C*
     C                   z-add     BCRCNR        BCOPNR
     C                   move      satzanz       BCOPNR
     C*   lt. A.Nyhoff
     C*   alle  SAart    if        bcbgar        = 'SB '
     C                   add       1             BCOPNR
     C*                  endif
     C*
     C                   movel     'PGM'         BCAEUS
     C                   movel     USER_UPD      BCAEWS
     C                   movel     ZM_UPD        BCAEJT
     C*
     C                   movel     'J'           BCEFEU
     C                   Z-ADD     W_LW          BCQDE
     C**********
     C                   movel     PERS          BCMZWF
     C                   if        PERS          = '      '
     C                   movel     PNRG          BCMZWF
     C                   endif
     C**********
     C***                movel     'KD-NR'       BCMM01
     C**********
     C                   if        TXT_FI23      <> '             '
     C                   movel     '       '     partner           7
     C                   movel     '      '      TXT_FI            6
     C                   eval      TXT_FI = %subst(txt_fi23:1:6)
     C                   movel     '1'           partner
     C                   move      TXT_FI        partner
     C                   movel     partner       BCMM01
     C                   endif
     C**********
     C                   movel     ' '           BCMM02
     C                   movel     ' '           BCMM03
     C                   movel     ' '           BCMM04
     C                   if        KTO           = '2170    '
     C                   movel     '000005'      PNRG
     C                   endif
     C                   movel     PNRG          BCMM05
     C                   if        user_upd      = 'BAB4700  '
     C                   movel     '     '       REFNR
     C                   move      '     '       REFNR
     C                   endif
     C* Datum JJJJMM übergeben  (wird nur in Dormagen bebucht!)
     C                   if        KTO           = '0977    '  or
     C                             KTO           = '1820    '
     C                   movel     BCJP          REFNR
     C                   eval      BCMM06 = %subst(REFNR:1:6)
     C                   endif
     C                   if        KTO           = '1899    '
     C                   movel     '     '       REFNR
     C                   move      '     '       REFNR
     C                   endif
     C                   if        KTO           = '0979    '
     C                   eval      BCMM06 = %subst(REFNR:6:5)
     C                   endif
     C                   movel     PERS          BCMM07
     C*
     C***                movel     'UMSPART'     BCMM13
     C                   movel     ' '           BCMM14
     C***                movel     'ISOCODE'     BCMM15
     C                   write     phy01r
     C*
     C     ##_hab218     ENDSR
     C*
     C**************************************************************************
     C* Datum
     C*-------------------------------------------------------------------------
     C*
     C     sr0000        BEGSR
     C*
     C/EXEC SQL
     C+ WHENEVER SQLERROR GOTO ##0000
     C/END-EXEC
     C*
      *
     c/EXEC SQL
     c+ SELECT CURRENT TIMESTAMP
     c+ INTO :tstamp
     c+ FROM DUMMY
     c/END-EXEC
      *
     c/EXEC SQL
     c+ SELECT CURRENT DATE
     c+ INTO :TDATE
     c+ FROM DUMMY
     c/END-EXEC
      *
     C*
     C     ##0000        ENDSR
     C*
     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C* *LDA DEFINIEREN/LESEN
     C     *DTAARA       DEFINE    *LDA          LDA
     C                   IN        LDA
     C*
     C     *DTAARA       DEFINE                  release           4
     C*    aktuelle Firma einlesen
     C                   IN        release
     C                   exsr      sr0000
     C*
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN, Dummys ansprechen
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
     C/COPY ##PSSR
     C/COPY ##MESSAGES                                     Nachrichten
