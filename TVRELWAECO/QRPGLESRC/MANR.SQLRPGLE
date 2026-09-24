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
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      * SELECT DISTR, COUNTR, SUPPLWORLD, CATEGORY, SUPPLLOCAL,
      * KIAINTER.BRAND, TPTTXT, KIAINTER.TEEANR, KIAINTER.ARTNR, TETBZ1,
      * BILLING, RABATT, NETTO, TEPRGR, RABATTP, INPUT FROM
      * tvrelwaeco/kiainter, internet WHERE KIAINTER.ARTNR = INTERNET.ARTNR
      * and (input not like '%Thumbnail%') and ((input like '%_p%') or
      * (input like '%_P%')) and (input not like '%.pdf%') and (hex(input)
      * like '%6D97%')
      * Datei INT_KIA in TVRELWAECO wurde ersetzt.
      *****************************************************************

     fman_input uf   e             disk
     f                                     RENAME(man:phy01r)
     fman_docum uf a e             disk
     f                                     RENAME(man_docum:phy02r)
     f***                                  INFDS(DSF1)
     fkalk_file2if   e           k disk
     finternetl1if   e           k disk
     ftrtp01    if   e           k disk
     fteil01    uf a e           k disk    RENAME(teil1:phy03r)
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
     Dpos              s             10i 0
     D
     D**********************************************************************
     ****
     D***  KOMMUNIKATIONSPARAMETER
     ***
     D**********************************************************************
     D/COPY QCPYSRC,EXTRIN
     D KOM             S              1    DIM(220)                             Kommunikation
     D EXTR02        E DS
     D
     D*-------------------------------------------------------------------------
     DfPos             s              5  0
     DnPos             s              5  0
     Dlength           s              5  0
     DmField           s             30A
     DmScan            S              4a
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     Iphy02r
     I              man_docum                   #man_docum
     I*-------------------------------------------------------------------------
     c***********        exsr      sr1000
     C***********        open      man_input
     C                   DO        *HIVAL
     C
     C                   READ      man_input                              95
     C                   IF        *in95 = '1'
     C                   leave
     C                   else
     c                   clear                   t                 1
     C                   clear                   man05
     C                   clear                   man06
     C                   clear                   man07
     C                   clear                   man08
     C                   clear                   man09
     C                   clear                   man10
     C                   clear                   man11
     C                   clear                   man12
     C                   clear                   man13
     C                   clear                   man14
     C                   clear                   man15
     C                   clear                   man16
     C                   clear                   man17
     C                   clear                   man18
     C                   clear                   man19
     C                   clear                   man20
     C                   clear                   man21
     C                   clear                   man22
     C                   clear                   man23
     C                   clear                   man28
     C                   clear                   man29
     C                   clear                   man30
     C                   exsr      sr2000
     C                   exsr      sr2010
     C                   exsr      sr2020
     C                   exsr      sr2030
     C                   exsr      srlines
     c                   update    phy01r
     c                   endif
     C
     C                   enddo
     C***********        close     man_input
     C                   EXSR      RETURN
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------


     C**************************************************************************
     C*lesen aus interface und u.U. Filter
     C*-------------------------------------------------------------------------
     C*
     C     srlines       BEGSR

     c                   setoff                                       81
     c                   clear                   i               180
     c                   clear                   i1              200
     c                   clear                   i2              200
     c                   clear                   i3              200
     c                   clear                   i4              200
     c                   clear                   i5              200
     c                   clear                   i6              200
     c                   clear                   i7              200
     c                   clear                   i8              200
     c                   clear                   i9              200
     c                   clear                   i10             200
     c                   clear                   man21

     C     artnr         SETLL     internetl1
     C                   DO        *HIVAL
     C     artnr         READE     internetl1                             91
     C   91              LEAVE
     C*                 maximal 6 Bilder
     C                   if        artnr <> man12   or
     c                             artnr <> man12
     c                   leave
     c                   else
      *                  1234567890123456789012345678901234567890123
     C*                 nur aus diesem Verzeichnis die Dokumente ziehen
     C*                 http://pis.waeco.de/img/images/JPG/PrintJPG
     c                   clear                   mScan
     c                   clear                   pos
     c                   eval      mScan  = '.eps'
     c                   eval      pos = %scan(mScan: input)
     c                   clear                   ix              200
     c                   movel     input         ix
     c                   if        pos = 0 and %subst(ix:1:043) =
     c                             'http://pis.waeco.de/img/images/JPG/PrintJPG'
      *
     c                   clear                   #man_docum
     c                   movel     input         #man_docum
     c                   write     phy02r
     c*                  http://pis.waeco.de/   herausfiltern
     c                   eval      i = %subst(ix:20:180)
     c
     c                   movel     '/'           check             1
     c
     C**       nPos = %scan(mScan:ix:nPos);      **
      /Free
         MONITOR;
            fPos = *zero;
            for nPos = 1 to %size(ix);
               nPos = %scan(check:ix:nPos);
               if nPos > *zero;
                  fPos = nPos;
                  iter;
               endif;
               leave;
            endfor;
            if fPos > *zero;
                 length=%size(ix);
                 i = %subst(ix:fPos+1:length-fPos);
            // gefunden
            endif;
            ON-ERROR;
                fPos  = 0 ;
         ENDMON;
      /End-Free
     c
     c
     c                   select
     c                   when      i1      = *blank
     c                   movel     i             i1
     c*
     c                   when      i2      = *blank
     c                   if        i      <>     i1
     c                   movel     i             i2
     c                   endif
     c*
     c                   when      i3      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2
     c                   movel     i             i3
     c                   endif
     c*
     c                   when      i4      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3
     c                   movel     i             i4
     c                   endif
     c*
     c                   when      i5      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4
     c                   movel     i             i5
     c                   endif
     c*
     c                   when      i6      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4  and
     c                             i      <>     i5
     c                   movel     i             i6
     c                   endif
     c*
     c                   when      i7      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4  and
     c                             i      <>     i5  and
     c                             i      <>     i6
     c                   movel     i             i7
     c                   endif
     c*
     c                   when      i8      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4  and
     c                             i      <>     i5  and
     c                             i      <>     i6  and
     c                             i      <>     i7
     c                   movel     i             i8
     c                   endif
     c*
     c                   when      i9      = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4  and
     c                             i      <>     i5  and
     c                             i      <>     i6  and
     c                             i      <>     i7  and
     c                             i      <>     i8
     c                   movel     i             i9
     c                   endif
     c*
     c                   when      i10     = *blank
     c                   if        i      <>     i1  and
     c                             i      <>     i2  and
     c                             i      <>     i3  and
     c                             i      <>     i4  and
     c                             i      <>     i5  and
     c                             i      <>     i6  and
     c                             i      <>     i7  and
     c                             i      <>     i8  and
     c                             i      <>     i9
     c                   movel     i             i10
     c                   endif
     c                   endsl
     c                   endif
     c                   endif
     C                   ENDDO
      *
     c                   eval      man21     =   %trim(i1) + ',' +
     c                                           %trim(i2) + ',' +
     c                                           %trim(i3) + ',' +
     c                                           %trim(i4) + ',' +
     c                                           %trim(i5) + ',' +
     c                                           %trim(i6) + ',' +
     c                                           %trim(i7) + ',' +
     c                                           %trim(i8) + ',' +
     c                                           %trim(i9) + ',' +
     c                                           %trim(i10) + ','
      *
     C     ##lines       ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/internet
     c+ SELECT ARTNR,E9,ARTGRP,STATNR,input,ARTBEZ,abc,
     c+ char(' ', 1) pdf, char(' ', 1) jpg,char(' ', 1) rest,
     c+ current timestamp tstamp FROM lotus/artnotes, gang/picture
     c+ WHERE artgrp <> 'SON' and
     c+ ((input like '%.jpg%') or (input like '%.pdf%')) and
     c+ ((input like '%_WAE%') or (input like '%_wae%')  or
     c+  (input like '%_dom%') or (input like '%_DOM%')  or
     c+  (input like '%_mbc%') or (input like '%_MBC%')) and
     c+ upper(trim(input)) like '%' concat trim
     c+ (substr("E9", 1, 15)) concat '%'
     c/end-exec

     C     ##1000        ENDSR

     *********************************************************************
     C* SR2000:
     C*-------------------------------------------------------------------

     C     SR2000        BEGSR
     C*
     c     KEY2000       klist
     c                   kfld                    version          10
     c                   kfld                    artnr
     c                   movel     man04         artnr
     c                   movel     '$$EL_PS_DB'  VERSION
     c                   if        artnr = '9103009001 '
     c                   clear                   t                 1
     c                   endif
     C*
      *                  Kalk_file2
     c     KEY2000       chain     kalk_file2
     c                   IF        %found(kalk_file2)
     C                   movel     ARTBEZ        man05
     C                   movel     ARTBEZ        man07
     C                   eval      man11='Dometic WAECO International GmbH'
     C                   eval      man14    =   'L:'    +
     C                                           %char(LAENGE)  +
     C                                          'B:'    +
     C                                           %char(BREITE) +
     C                                          'H:'    +
     C                                           %char(HOEHE)
     C                   eval      gewicht = gewicht/1000
     C                   eval      man15    =   %char(GEWICHT) +
     C                                           'kg'
     C                   movel     artnr         man12
     c                   eval      man12     =   %trim(artnr)
     C                   eval      man23='http://www.waeco.com/de/        '
     C                   eval      EVP_AJ=EVP_AJ *1,19
     C                   movel     EVP_AJ        man29
     c                   ENDIF

     C     ##2000        ENDSR

     *********************************************************************
     C* SR2010:
     C*-------------------------------------------------------------------

     C     SR2010        BEGSR
     C*
     c     KEY2010       klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     'PRGR'        TPTART
     c                   movel     ARTGRP        TPTCDE
     C*
     c     KEY2010       chain     trtp01
     c                   IF        %found(trtp01)
     C                   movel     TPTTXT        MAN08
     c                   else
     c                   clear                   TPTTXT
     c                   ENDIF

     C     ##2010        ENDSR

     *********************************************************************
     C* SR2020:
     C*-------------------------------------------------------------------

     C     SR2020        BEGSR
     C*
     c     KEY2020       klist
     c                   kfld                    TPFIRM
     c                   kfld                    TPSPCD
     c                   kfld                    TPTART
     c                   kfld                    TPTCDE
     c                   movel     '01'          TPFIRM
     c                   movel     'D'           TPSPCD
     c                   movel     '$$TEEWPRGR'  TPTART
     c                   movel     statnr        TPTCDE
     C*
     c     KEY2020       chain     trtp01
     c                   IF        %found(trtp01)
     c                   eval      man20     =   %trim(TPTTXT) + ',' +
     c                                           %trim(artnr) + ',' +
     c                                           %trim(ARTBEZ)
     c                   else
     c                   clear                   man20
     c                   ENDIF

     C     ##2020        ENDSR

     *********************************************************************
     C* SR2030:
     C*-------------------------------------------------------------------

     C     SR2030        BEGSR
     C*
     c     KEY2030       klist
     c                   kfld                    TEFIRM
     c                   kfld                    TETENR
     c                   movel     '01'          TEFIRM
     c                   movel     artnr         TETENR
     C*
     c     KEY2030       chain     teil01                             98
     c                   IF        *in98 = '01'
     c                   eval      MAN06 =       %trim(TETBZ2)
     c                   movel     TEMIBM        man28
     c                   else
     c                   clear                   man06
     c                   clear                   man28
     c                   endif

     C     ##2030        ENDSR

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec
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
