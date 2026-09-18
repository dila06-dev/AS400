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
     F*  update der SBGAU100 Auftragsdatei um Informationen      *
     F*  OEM-Flag (priority identifier),                         *
     F*  DELIVERY-Flag (Only full order delivery allowed)        *
     F*  delivery date (delivery date must be exactly)           *
     F*  M.Gang 18.09.2009                                       *
     F*  Änderungsprotokoll:                                     *
     F*  ...                                                     *
     F*  ...                                                     *
     F************************************************************

     fWAEEDIHPL3uf   e           k disk
     fsbgau100  uf   e           k disk

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
     C                   PARM                    #EDIH030          6 0

     c*******            eval      #edih030   =  40631
     C*-------------------------------------------------------------------------

     C     KEY0000       KLIST
     C                   KFLD                    EDIH030
     C                   z-add     #EDIH030      EDIH030
     c
     C     KEY0000       SETLL     WAEEDIHPL3                         95
     C     *IN95         IFEQ      '0'
     C                   DO        *HIVAL
     C                   READ      WAEEDIHPL3                             95
     C                   IF        *in95 = '1'            or
     C                             EDIH030  <>  #EDIH030
     c                   unlock    WAEEDIHPL3
     C                   leave
     C                   else
     c                   exsr      sr4000
     c  n30              unlock    sbgau100
     c   30              update    AU100R1
     c                   movel     '1'           HRESTART
     c                   movel     #AU1030       EDIH380
     c                   update    EDIHPF0
     c                   call      'SGBAU500R'
     c                   parm                    EDIH030
     c                   parm                    EDIH040
     c                   parm                    EDIH380
     C                   PARM      ' '           #cc               1
     C                   endif
     C                   clear                   md
     C                   movel     EDIH030       ##EDIH030         7
     C                   movea(p)  ##EDIH030     md(001)
     C                   movel     EDIH040       #EDIH040          7
     C                   movea(p)  #EDIH040      md(008)
     C*
     C                   if        #cc = '1'
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC2525'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#DC2525'     OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md
     C*
     C                   if        #edih030 = 40631
     C                   CALL      '#DC2525C'
     C                   endif
     C                   if        #edih030 = 88505
     C                   CALL      '#DC2526C'
     C                   endif
     C                   endif
     C*
     C                   enddo
     C                   endif

     C                   return

     c**********************************************************************
     c* lesen Auftrag
     c**********************************************************************

     C     sr4000        begsr

     c     keysr4000     klist
     c                   kfld                    #AU1010
     c                   kfld                    #AU1020
     c                   kfld                    #AU1030
     c                   kfld                    #AU1040
     c                   kfld                    #AU1050
     c                   kfld                    #AU1060
     c                   kfld                    #AU1070

     c                   exsr      sr4400
     c                   movel     '01'          #AU1050

     c     keysr4000     chain     sbgau100
     c                   IF        %found(sbgau100)
     c
     c                   setoff                                       30
     c
     C                   clear                   a                10
     C                   if        %subst(EDIH370:1:01) <> '0' and
     C                             %subst(EDIH370:1:01) <> ' '
      *                 priority identifier
     c                   seton                                        30
     C                   movel     ATR(13)       a
     C                   eval      %subst(a:2:05) = 'Prio:'
     C                   if        %subst(EDIH370:1:1) = '1'
     C                   eval      %subst(a:7:03) = 'OEM'
     C                   else
     C                   eval      %subst(a:7:03) = '???'
     C                   endif
     C                   endif
      *
     C                   clear                   b                08
     C                   if        %subst(EDIH370:2:01) =  '1'
      *                 Only full order delivery allowed
     c                   seton                                        30
     C                   movel     ATR(13)       b
     C                   eval      %subst(b:2:05) = 'Teil:'
     C                   move      'N '          b
     C                   endif
      *
     C                   clear                   c                20
     C                   clear                   feld10           10
     C                   if        %subst(EDIH370:3:01) =  '1'
      *                 delivery date must be exactly
     c                   seton                                        30
     C                   movel     ATR(13)       c
     C                   eval      %subst(c:2:04) = 'Fix:'
      *                 Datum Termin
     C                   move      edih090       #060              8
     C                   eval      %subst(feld10:1:02) =  %subst(#060:7:02)
     C                   eval      %subst(feld10:3:01) =  '.'
     C                   eval      %subst(feld10:4:02) =  %subst(#060:5:02)
     C                   eval      %subst(feld10:6:01) =  '.'
     C                   eval      %subst(feld10:7:04) =  %subst(#060:1:04)
     C                   eval      %subst(c:7:10) = feld10
     c                   endif
     C
     C                   clear                   md
     C                   movel     au1170        #AU1170
     C
     C                   if        *in30 = '1'
     C                   if        a <> *blank
     C                   movea(p)  a             md(004)
     C                   if        b <> *blank and
     C                             c <> *blank
     C                   movea(p)  b             md(014)
     C                   movea(p)  c             md(025)
     C                   endif
     C                   if        b <> *blank and
     C                             c =  *blank
     C                   movea(p)  b             md(014)
     C                   endif
     C                   if        b =  *blank and
     C                             c <> *blank
     C                   movea(p)  c             md(014)
     C                   endif
     C                   endif
     C********
     C                   if        a =  *blank
     C                   if        b <> *blank and
     C                             c <> *blank
     C                   movea(p)  b             md(004)
     C                   movea(p)  c             md(014)
     C                   endif
     C                   if        b <> *blank and
     C                             c =  *blank
     C                   movea(p)  b             md(004)
     C                   endif
     C                   if        b =  *blank and
     C                             c <> *blank
     C                   movea(p)  c             md(004)
     C                   endif
     C                   endif
      *                 AUSGABE-übergeben
     C                   movea(p)  md            #AU1170          96
     C                   movel     #au1170       AU1170
     c                   endif
     C
     c                   endif
     C
     C     ##4000        endsr

     C**************************************************************************
     C*holen Bezug zum Kundenauftrag und kunde
     C*-------------------------------------------------------------------------
     C*
     C     sr4400        BEGSR
     C*
     C                   clear                   #AU1010           2 0
     C                   clear                   #AU1020           5 0
     C                   clear                   #AU1030           6 0
     C                   clear                   #AU1040           2 0
     C                   clear                   #AU1050           2
     C                   clear                   #AU1060           3 0
     C                   clear                   #AU1070           1
     C*
     c/exec sql
     c+ whenever not found goto ##4400
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##4400
     c/end-exec
     c/exec sql
     C+ select  AU3010,   AU3020,   AU3030,   AU3040,
     C+         AU3050,   AU3060,   AU3070   into
     C+       :#AU1010, :#AU1020, :#AU1030, :#AU1040,
     C+       :#AU1050, :#AU1060, :#AU1070
     C+ FROM sbgau300
     C+ where
     C+ substr(AU3090, 1, 8) = substr(:EDIH080, 1, 8) and
     C+ :EDIH030             = AU3020                 and
     C+ au3040  = 08
     C*
     c/end-exec
     C*
     C     ##4400        ENDSR
     C*
     C* --------------------------------------------------------------------


     C     *inzsr        BEGSR
     C                   TIME                    Date
     c*                  z-add     1             firma
     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
