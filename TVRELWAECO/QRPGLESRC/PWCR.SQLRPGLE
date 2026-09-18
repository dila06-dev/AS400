     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *(dec(max(PREZPR), 12, 2) * dec(100-(max(koraba*-1)), 12, 2)/100)
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      * SELECT RPLIJJ, RPLINR, RPLIPO, RKKDNR, KUND01.KDNAM1, RPNESU,RPMWST
      * , RKWACD,APTENR,APTBZ1, APPRGR, dec(0, 13, 2) euro ,rkreda, AKAFAT,
      * AFPA.AAABEZ, STATISTIK.RPMWCD, char(' ', 10) konto , RKMWS1 FROM
      * statistik, kund01,afpa WHERE RKREDA > 20140100 and RKREDA <
      * 20141100 and STATISTIK.AKKDNR = KUND01.KDKDNR and STATISTIK.AKFIRM
      * = KUND01.KDFIRM and akafat=AAAFAT and AKFIRM = AAfirm
      * Datei PWC in TVRELWAECO wurde ersetzt.
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

     fpwc       uf   e             disk
     f                                     RENAME(pwc:phy01r)
     f***                                  INFDS(DSF1)
     F                                     USROPN
     fwaeh01    if   e           k disk
     DDate             S               D   DATFMT(*EUR)
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
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     I*-------------------------------------------------------------------------
     D DSF1            DS
     D  F1STS                 11     15  0
     D  F1RRN                397    400B 0
     I*-------------------------------------------------------------------------
     D DSF2            DS
     D  F2STS                 11     15  0
     D  F2RRN                397    400B 0
     D*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*

     c     key001        klist
     c                   kfld                    WAFIRM
     c                   kfld                    WASTWC
     c                   kfld                    WAWACD
     c                   kfld                    WAGADA
     c
     C                   open      pwc
     C                   DO        *HIVAL
     C                   READ      pwc                                    95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     C
     C                   eval      WAFIRM  = '01'
     C                   eval      WASTWC  = 'EUR'
     C                   eval      WAWACD  = RKWACD
     C                   eval      WAGADA  = RKREDA
     C                   z-add     1             wakurs
     C                   z-add     1             euro
     C     KEY001        SETgt     WAEH01                             95
     C*    *IN95         IFEQ      '0'
     C*    RKWACD        andne     'EUR'
     C                   DO        *HIVAL
     C                   READp     WAEH01                                 95
     C     *IN95         IFEQ      '1'
     c     WAFIRM        orne      '01'
     c     WASTWC        orne      'EUR'
     c     WAWACD        orne      RKWACD
     C                   clear                   wagada
     C                   z-add     1             euro
     C                   leave
     C                   else
     c                   eval      wagada    =   wagada
     c                   eval      euro      =   wakuvk
     C                   leave
     c                   ENDIF                                                  %found(FRACHTKS)
     C                   enddo
     C*                  endif
     C
     c                   endif
     c                   update    phy01r
     c                   enddo
     C                   close     pwc

     C     ##1000        ENDSR

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
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C**************************************************************************
