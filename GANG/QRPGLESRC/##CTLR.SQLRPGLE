      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *               
      * November 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     finput     ip   e             disk
     F*                                    USROPN
     f##CTL     uf a e             disk
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
     C                   exsr      sr1000
     C*
     C**************************************************************************
     C*...kulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*

     c                   eval      #MBR     =    '1'
     c                   eval      #FILE    =    '2'
     c                   eval      #LIBL    =    '1'
     c                   eval      #ATTRC   =    '01'
     c                   eval      #status  =    '1'
     c                   eval      %subst(#txt:01:01) = X'01' +
     c                             srcdta
     c                   eval      #ATTRC   =    '01'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'02' +
     c                             srcdta
     c                   eval      #ATTRC   =    '02'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'03' +
     c                             srcdta
     c                   eval      #ATTRC   =    '03'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'04' +
     c                             srcdta
     c                   eval      #ATTRC   =    '04'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'05' +
     c                             srcdta
     c                   eval      #ATTRC   =    '05'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'06' +
     c                             srcdta
     c                   eval      #ATTRC   =    '06'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'07' +
     c                             srcdta
     c                   eval      #ATTRC   =    '07'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'08' +
     c                             srcdta
     c                   eval      #ATTRC   =    '08'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'09' +
     c                             srcdta
     c                   eval      #ATTRC   =    '09'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'10' +
     c                             srcdta
     c                   eval      #ATTRC   =    '10'
     C                   write     ##CTLr

     c                   eval      %subst(#txt:01:01) = X'11' +
     c                             srcdta
     c                   eval      #ATTRC   =    '11'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'12' +
     c                             srcdta
     c                   eval      #ATTRC   =    '12'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'13' +
     c                             srcdta
     c                   eval      #ATTRC   =    '13'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'14' +
     c                             srcdta
     c                   eval      #ATTRC   =    '14'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'15' +
     c                             srcdta
     c                   eval      #ATTRC   =    '15'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'16' +
     c                             srcdta
     c                   eval      #ATTRC   =    '16'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'17' +
     c                             srcdta
     c                   eval      #ATTRC   =    '17'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'18' +
     c                             srcdta
     c                   eval      #ATTRC   =    '18'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'19' +
     c                             srcdta
     c                   eval      #ATTRC   =    '19'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'20' +
     c                             srcdta
     c                   eval      #ATTRC   =    '20'
     C                   write     ##CTLr
     C*

     c                   eval      %subst(#txt:01:01) = X'21' +
     c                             srcdta
     c                   eval      #ATTRC   =    '21'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'22' +
     c                             srcdta
     c                   eval      #ATTRC   =    '22'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'23' +
     c                             srcdta
     c                   eval      #ATTRC   =    '23'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'24' +
     c                             srcdta
     c                   eval      #ATTRC   =    '24'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'25' +
     c                             srcdta
     c                   eval      #ATTRC   =    '25'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'26' +
     c                             srcdta
     c                   eval      #ATTRC   =    '26'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'27' +
     c                             srcdta
     c                   eval      #ATTRC   =    '27'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'28' +
     c                             srcdta
     c                   eval      #ATTRC   =    '28'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'29' +
     c                             srcdta
     c                   eval      #ATTRC   =    '29'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'30' +
     c                             srcdta
     c                   eval      #ATTRC   =    '30'
     C                   write     ##CTLr
     C*

     c                   eval      %subst(#txt:01:01) = X'31' +
     c                             srcdta
     c                   eval      #ATTRC   =    '31'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'32' +
     c                             srcdta
     c                   eval      #ATTRC   =    '32'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'33' +
     c                             srcdta
     c                   eval      #ATTRC   =    '33'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'34' +
     c                             srcdta
     c                   eval      #ATTRC   =    '34'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'35' +
     c                             srcdta
     c                   eval      #ATTRC   =    '35'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'36' +
     c                             srcdta
     c                   eval      #ATTRC   =    '36'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'37' +
     c                             srcdta
     c                   eval      #ATTRC   =    '37'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'38' +
     c                             srcdta
     c                   eval      #ATTRC   =    '38'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'39' +
     c                             srcdta
     c                   eval      #ATTRC   =    '39'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'40' +
     c                             srcdta
     c                   eval      #ATTRC   =    '40'
     C                   write     ##CTLr

     c                   eval      %subst(#txt:01:01) = X'41' +
     c                             srcdta
     c                   eval      #ATTRC   =    '41'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'42' +
     c                             srcdta
     c                   eval      #ATTRC   =    '42'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'43' +
     c                             srcdta
     c                   eval      #ATTRC   =    '43'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'44' +
     c                             srcdta
     c                   eval      #ATTRC   =    '44'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'45' +
     c                             srcdta
     c                   eval      #ATTRC   =    '45'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'46' +
     c                             srcdta
     c                   eval      #ATTRC   =    '46'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'47' +
     c                             srcdta
     c                   eval      #ATTRC   =    '47'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'48' +
     c                             srcdta
     c                   eval      #ATTRC   =    '48'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'49' +
     c                             srcdta
     c                   eval      #ATTRC   =    '49'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'50' +
     c                             srcdta
     c                   eval      #ATTRC   =    '50'

     c                   eval      %subst(#txt:01:01) = X'51' +
     c                             srcdta
     c                   eval      #ATTRC   =    '51'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'52' +
     c                             srcdta
     c                   eval      #ATTRC   =    '52'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'53' +
     c                             srcdta
     c                   eval      #ATTRC   =    '53'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'55' +
     c                             srcdta
     c                   eval      #ATTRC   =    '55'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'45' +
     c                             srcdta
     c                   eval      #ATTRC   =    '55'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'56' +
     c                             srcdta
     c                   eval      #ATTRC   =    '55'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'57' +
     c                             srcdta
     c                   eval      #ATTRC   =    '57'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'58' +
     c                             srcdta
     c                   eval      #ATTRC   =    '58'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'55' +
     c                             srcdta
     c                   eval      #ATTRC   =    '59'
     C                   write     ##CTLr
     c                   eval      %subst(#txt:01:01) = X'60' +
     c                             srcdta
     c                   eval      #ATTRC   =    '60'
     C                   write     ##CTLr
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*Funktion Werte aus Kopf deliver-date und fix-kennung
     C*-------------------------------------------------------------------------
     C*
     C     sr5000        BEGSR
     C*
     C                   clear                   $fak013          14 2
     C                   clear                   $mwst            14 2

     c/exec sql
     c+ whenever not found goto ##5000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##5000
     c/end-exec

     c/exec sql
     C+ SELECT sum( FAK013 ) into  :$fak013 FROM waetechp
     c/end-exec
     C*
     C
     C                   eval      $mwst  = $fak013 *19/100

     C     ##5000        ENDSR

     C**************************************************************************
     C* INITIALISIERUNGSROUTINE
     C*-------------------------------------------------------------------------
     C     *INZSR        BEGSR
     C*
     C                   TIME                    Date
     c                   extrct    date:*Y       pjahr
     c                   extrct    date:*M       pmonat
     C                   extrct    date:*D       ptag
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
     C                   clear                   m                 6 0
     C                   exsr      sr5000
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
