     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F************************************************************
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  update der SBGAU500 Auftragsdatei um Informationen      *
     F*  M.Gang 17.09.2009                                       *
     F*  Änderungsprotokoll:                                     *
     F*  ...                                                     *
     F*  ...                                                     *
     F************************************************************

     fWAEEDIlPL1uf   e           k disk
     fsbgau500  uf   e           k disk

     Fsbgart07  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(ART07R1:log07r)
     Fsbgart00  if   E           k DISK    INFSR(*PSSR)
     F                                     RENAME(ART00R1:log08r)

     DDate             S               D   DATFMT(*EUR)
     DPLZHelp          S              5A
     D#TIMESTAMP       S               z

     I*-------------------------------------------------------------------------
     I/COPY ##E
     I*/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
b
     C     *ENTRY        PLIST
     C                   PARM                    #EDIl030          7 0
     C                   PARM                    #EDIl040          7 0
     C                   PARM                    #EDIh380          6 0
     C                   PARM                    #cc               1

     c**                 eval      #EDIl030   =  88505
     c**                 eval      #EDIl040   =  55352
     c**                 eval      #EDIh380   =  572306

     c                   clear                   #EDIL350
     c                   clear                   Error

     C*-------------------------------------------------------------------------

     C     KEY0000       KLIST
     C                   KFLD                    EDIL030
     C                   KFLD                    EDIL040
     C                   z-add     #EDIl030      EDIl030
     C                   z-add     #EDIl040      EDIl040
     c
     C     KEY0000       SETll     WAEEDIlPL1                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDIlPL1                             95
     C                   IF        *in95 = '1'            or
     C                             EDIl030  <>  #EDIl030  or
     C                             EDIl040  <>  #EDIl040
     c                   unlock    WAEEDIlPL1
     C                   leave
     C                   else
     C                   setoff                                       3077
     c                   exsr      sr3000
     c                   unlock    sbgau500
     c   77              update    AU500R1
     c   30              movel     '1'           LRESTART
     c   30              z-add     AU5030        EDIL340
     c   30              z-add     AU5060        EDIL350
     c                   z-add     AU5060        #EDIL350          3 0
     c   30              movel     AU5290        EDIL250
     c   30              move      '00'          LSTATUS
     c                   clear                   Error
     c                   exsr      sr_art
     c                   clear                   TEXTL512
     c                   movel     Error         TEXTL512
     c                   if        %subst(TEXTL512:01:80) <> *blank or
     c                             EDIL250                <> *blank
     c                   eval      #cc  = '1'
     c                   endif
     c                   update    EDILPF0
     C                   endif
     C                   enddo
     C                   endif

     C                   return

     c**********************************************************************
     c* lesen Auftrag
     c**********************************************************************

     C     sr3000        begsr

     c     key3000       klist
     c                   kfld                    #AU5010
     c                   kfld                    #AU5020
     c                   kfld                    #AU5030
     c                   kfld                    #AU5040
     c                   kfld                    #AU5050
     c                   kfld                    #AU5060
     c                   kfld                    #AU5070

     C                   z-add     1             #AU5010           2 0
     C                   z-add     #edil030      #AU5020           5 0
     C                   z-add     #EDIh380      #AU5030           6 0
     C                   z-add     08            #AU5040           2 0
     C                   movel     '10'          #AU5050           2
     C                   clear                   #AU5060           3 0
     C                   movel     'N'           #AU5070           1
     C*                 aus Schleife
     c                   z-add     #EDIL350      #AU5060
     c
     C     KEY3000       SETgt     sbgau500                           96
     C     *IN96         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      sbgau500                               96
     C                   IF        *in96 = '1'            or
     C                             AU5010   <>  #AU5010   or
     C                             AU5020   <>  #AU5020   or
     C                             AU5030   <>  #AU5030   or
     C                             AU5040   <>  #AU5040   or
     C                             AU5050   <>  #AU5050
     C******                       AU5070   <>  #AU5070
     c                   unlock    sbgau500
     C                   leave
     C                   else
     C*
     C                   if        AU5090   =    EDIL220
     C                   seton                                        30
     C                   move      edil050       ##edil050         3
     C     ' ':'0'       xlate     ##edil050     ##edil050         3
     C                   move      ##edil050     AU5730
     C                   leave
     C                   else
     C*
     c                   clear                   Error
     c                   clear                   art100
     c                   exsr      sr_art
     c                   clear                   Error
     C                   if        AU5090   =    art100
     C                   seton                                        30
     C                   move      edil050       ##edil050         3
     C     ' ':'0'       xlate     ##edil050     ##edil050         3
     C                   move      ##edil050     AU5730
     C                   leave
     C                   endif
     C*
     C                   endif
     C*
     C                   endif
     C                   enddo
     C                   endif
     C
     C     ##3000        endsr

     c**********************************************************************
     c* lesen Auftrag
     c**********************************************************************

     C     sr4000        begsr

     c     keysr4000     klist
     c                   kfld                    #AU5010
     c                   kfld                    #AU5020
     c                   kfld                    #AU5030
     c                   kfld                    #AU5040
     c                   kfld                    #AU5050
     c                   kfld                    #AU5060
     c                   kfld                    #AU5070

     c                   exsr      sr4400
     c                   movel     '10'          #AU5050
     c                   clear                   #AU5060
     c                   movel     'N'           #AU5070

     c     keysr4000     chain     sbgau500
     c                   IF        %found(sbgau500)
     c
     c                   setoff                                       30
     c
     C                   clear                   b                08
      *
     c                   endif
     C
     C     ##4000        endsr

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr4400        BEGSR
     C*
     C*
     C     ##4400        ENDSR
     C*
     C* --------------------------------------------------------------------


     C     *inzsr        BEGSR
     C                   TIME                    Date
     c*                  z-add     1             firma
     c                   CLEAR                   ATR
     c                   movel     'SBGAU500R'   DSPGM            10
     c                   movel     '         '   MSGF             10
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
     C* lesen aus sbgart07    check auf artikel
     C*-------------------------------------------------------------------------
     C*
     C     sr_art        BEGSR
     C*
     c     EDIL220       chain     sbgart07                           92
     C*
     C     key_art       KLIST
     C                   KFLD                    ART010
     C                   KFLD                    ART020
     C                   KFLD                    ART030
     c
     c                   clear                   error            80
     C   92              eval      Error=
     C                             ' article does not exist in the system'
     c
     c  n92key_art       chain     sbgart00                           92
     c  n92              if        art550  = 'VKNEIN'
     C  n92              eval      Error=
     C                             ' article is protected by supervisor  '
     c                   endif
     c  n92              if        art550  = 'VKSPER'
     C  n92              eval      Error=
     C                             ' article is not allowed for selling  '
     c                   endif
     c  n92              if        art180  = 'X' and art100 <> *blank
     C  n92              eval      Error=
     C                             ' article is not anymore valid replaced by:'
     c                   eval      %subst(Error:44:15) = art100
     c                   endif
     C*
     C                   clear                   anldat            8 0
     C                   clear                   #a                8
     C                   clear                   #anldat          10
     c  n92              movel     ART280        jj                2 0
     c  n92              movel     ART280        jjmm              4 0
     c  n92              move      ART280        tt                2 0
     c  n92              move      jjmm          mm                2 0
     c  n92              eval      anldat=(20000000+(jj*10000)+(mm*100)+tt)
     c  n92              if        anldat > 20500000
     c  n92              movel     '19'          anldat
     c                   endif
     c  n92              movel     anldat        #a
     c  n92              eval      %subst(#anldat:01:02) = %subst(#a:07:02)
     c  n92              eval      %subst(#anldat:03:01) = '.'
     c  n92              eval      %subst(#anldat:04:02) = %subst(#a:05:02)
     c  n92              eval      %subst(#anldat:06:01) = '.'
     c  n92              eval      %subst(#anldat:07:04) = %subst(#a:01:04)
     C*
     C     ##_art        ENDSR
     C*
     C**************************************************************************
     C/COPY ##PSSR                                         Errorroutine
