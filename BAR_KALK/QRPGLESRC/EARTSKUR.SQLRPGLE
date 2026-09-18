     *************************************************************
     F*      WAECO International GmbH                            *
     F*                                                          *
     F*      Hollefeldstrasse 63                                 *
     F*                                                          *
     F*      48282 Emsdetten                                     *
     F*                                                          *
     F*                                                          *
     F************************************************************
     F*                                                          *
     F*  PROGRAMMFUNKTION:                                       *
     F*                                                          *
     F*  Kalkulation ausführen                                   *
     F************************************************************
     Hdatfmt(*eur) timfmt(*eur)
     fkalk_file2if   e           k disk

     DDate             S               D   DATFMT(*EUR)
     Dxdate            S               D   DATFMT(*iso)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0

     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D**************************************************************************
     D/COPY ##E

     c*  Schlüsselliste für .
     c     key1000       klist
     c                   kfld                    version
     c                   kfld                    artnr


     C     *ENTRY        PLIST
     C                   PARM                    version
     C                   PARM                    artnr
     C                   PARM                    artsku
     C                   PARM                    artbezfra

      *                 Kalk_file2                                            
     c* Frachtsatz bestimmen
     c     KEY1000       chain     kalk_file2
     c                   IF        %found(kalk_file2)
     c                   Else                                                   %found(FRACHTKS)
     c                   clear                   artsku                         %found(FRACHTKS)
     c                   clear                   artbezfra                      %found(FRACHTKS)
     c                   ENDIF                                                  %found(FRACHTKS)
     c                   movel     '1'           *inlr                          %found(FRACHTKS)

     C**************************************************************************
     C* *inzsr  Druckausgabesteuerung
     C*-------------------------------------------------------------------------
     C     *inzsr        BEGSR

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   kalk_file
     c/end-exec
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   eval      nxt_jahr = pjahr

     C                   ENDSR
