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
     F*  Mail confirmation                                       *
     F*                                                          *
     F*                                                          *
     F*                                                          *
     F*  M.Gang 18.09.2009                                       *
     F*  Änderungsprotokoll:                                     *
     F*  ...                                                     *
     F*  ...                                                     *
     F************************************************************

     fWAEEDIHPL4uf   e           k disk
     f#IN0601l1 uf   e             disk
     F                                     RENAME(#IN0601:phy02r)
     F                                     USROPN

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

     C*-------------------------------------------------------------------------

     c                   exsr      sr4000
     C                   open      #IN0601l1
     c                   exsr      sr4500
     C                   close     #IN0601l1

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
     c                   movel     '1'           HRESTART
     c                   update    EDIHPF0
     C                   endif
     C                   enddo
     C                   endif

     C                   return

     C**************************************************************************
     C*Zwischendatei generieren
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     C                   clear                   md
     C                   movea(p)  #EDIH030      md(001)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#IN0601'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#IN0601'     OUTFIL           10
     C                   PARM      'QTEMP     '  LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md
     C
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#IN0602'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      *BLANK        OUTFIL           10
     C                   PARM      *BLANK        LIB              10
     C                   PARM      *BLANK        REPADD           10
     C                   clear                   md
     C*
     C     ##4000        ENDSR
     C*

     C**************************************************************************
     C*Zwischendatei bearbeiten
     C*-------------------------------------------------------------------------
     C*
     C     sr4500        BEGSR
     C*
     C     *LIKE         DEFINE    edil040       #edil040
     C     *LIKE         DEFINE    au5030        #au5030
     C     *LIKE         DEFINE    au5080        #au5080
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #IN0601l1                              95
     C   95              LEAVE
     C*
     c                   setoff                                       45
     c                   if        edil040 =  #edil040 and
     c                             au5030  =  #au5030  and
     c                             au5080  =  #au5080
     c                   seton                                        45
     c                   else
     c                   eval      #edil040  =   edil040
     c                   eval      #au5030   =   au5030
     c                   eval      #au5080   =   au5080
     c
     c                   endif
     c
     C   45              delete    phy02r
     C*
     C                   enddo
     C*
     C     ##3000        ENDSR
     C*

     C**************************************************************************
     C**inzsr
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR
     C                   TIME                    Date
     c*                  z-add     1             firma
     c                   CLEAR                   ATR
     c                   CALL      '#MODATR'                            97
     c                   PARM                    ATR
     C                   ENDSR

     C**************************************************************************
