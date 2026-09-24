      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Order über FTP prüfen und anpassen
      *               
      * Dezember 2009   GANG, MANFRED
      *
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
      *                                                                     ----
     fARTNR_KALKif   e           k disk    prefix('Z')
     fKALKSCHZU if   e           k disk
     fKSchemata if   e           k disk    prefix('Y')
      *                                                                     ----
     f#kp0100   uf   e             disk
     F                                     RENAME(#kp0100r:phy02r)
     F                                     USROPN
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

     c*  Schlüsselliste für KSchemata
     c     keyschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    KSCHEMA

     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    PR_GROUP

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    SUPPLIER
     c                   kfld                    MODEL_NO
     C*
     C                   exsr      sr2000
     C                   exsr      sr2100
     C                   exsr      sr2150
     C                   open      #kp0100
     C                   exsr      sr3000
     C                   close     #kp0100
     C                   exsr      sr4000
     C
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Gesamtauswertung aktuelles Jahr (#mg0021)
     C*into: gang/#st0050
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ insert into gang/#KP0053
     c+ SELECT
     c+ KDS070 COUNTRY, KDS210 BRANCHE,  KDS580 S_CHANNEL, kds200 C_GROUP,
     c+ art020 SUPPLIER, art030 MODEL_NO, art290 PRICE, Art050 PR_GROUP,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ as keyt, ' ' as record,
     c+ 0,0000 kurs, 0,0000 ics, 0,0000 icn, 0,0000 exs, 0,0000 exn,
     c+ 0,0000 oem, 0,0000 ghnetto, 0,0000 ghrab, 0,0000 risiko,
     c+ 0,0000 gk,
     c+ 0,00 kurs, 0,00 #ICS, 0,00 #ICN, 0,00 #EXS, 0,00 #EXN, 0,00 OEM,
     c+ 0,00 GHNETTO, 0,00 #GHRAB, 0,00 RISIKO, 0,00 #GK,
     c+ sum(KCJ070*0) Abs_Jan_Vj, sum(KCJ080*0) Abs_Feb_Vj,
     c+ sum(KCJ090*0) Abs_Mae_Vj, sum(KCJ100*0) Abs_Apr_Vj,
     c+ sum(KCJ110*0) Abs_Mai_Vj, sum(KCJ120*0) Abs_Jun_Vj,
     c+ sum(KCJ130*0) Abs_Jul_Vj, sum(KCJ140*0) Abs_Aug_Vj,
     c+ sum(KCJ150*0) Abs_Sep_Vj, sum(KCJ160*0) Abs_Okt_Vj,
     c+ sum(KCJ170*0) Abs_Nov_Vj, sum(KCJ180*0) Abs_Dez_Vj,
     c+ sum(KCJ190*0) Ums_Jan_Vj, sum(KCJ200*0) Ums_Feb_Vj,
     c+ sum(KCJ210*0) Ums_Mae_Vj, sum(KCJ220*0) Ums_Apr_Vj,
     c+ sum(KCJ230*0) Ums_Mai_Vj, sum(KCJ240*0) Ums_Jun_Vj,
     c+ sum(KCJ250*0) Ums_Jul_Vj, sum(KCJ260*0) Ums_Aug_Vj,
     c+ sum(KCJ270*0) Ums_Sep_Vj, sum(KCJ280*0) Ums_Okt_Vj,
     c+ sum(KCJ290*0) Ums_Nov_Vj, sum(KCJ300*0) Ums_Dez_Vj,
     c+ sum(KCJ430*0) Roh_Jan_Vj, sum(KCJ440*0) Roh_Feb_Vj,
     c+ sum(KCJ450*0) Roh_Mae_Vj, sum(KCJ460*0) Roh_Apr_Vj,
     c+ sum(KCJ470*0) Roh_Mai_Vj, sum(KCJ480*0) Roh_Jun_Vj,
     c+ sum(KCJ490*0) Roh_Jul_Vj, sum(KCJ500*0) Roh_Aug_Vj,
     c+ sum(KCJ510*0) Roh_Sep_Vj, sum(KCJ520*0) Roh_Okt_Vj,
     c+ sum(KCJ530*0) Roh_Nov_Vj, sum(KCJ540*0) Roh_Dez_Vj,
     c+ sum(KCJ070) Abs_Jan_Lj, sum(KCJ080) Abs_Feb_Lj,
     c+ sum(KCJ090) Abs_Mae_Lj, sum(KCJ100) Abs_Apr_Lj,
     c+ sum(KCJ110) Abs_Mai_Lj, sum(KCJ120) Abs_Jun_Lj,
     c+ sum(KCJ130) Abs_Jul_Lj, sum(KCJ140) Abs_Aug_Lj,
     c+ sum(KCJ150) Abs_Sep_Lj, sum(KCJ160) Abs_Okt_Lj,
     c+ sum(KCJ170) Abs_Nov_Lj, sum(KCJ180) Abs_Dez_Lj,
     c+ sum(KCJ190) Ums_Jan_Lj, sum(KCJ200) Ums_Feb_Lj,
     c+ sum(KCJ210) Ums_Mae_Lj, sum(KCJ220) Ums_Apr_Lj,
     c+ sum(KCJ230) Ums_Mai_Lj, sum(KCJ240) Ums_Jun_Lj,
     c+ sum(KCJ250) Ums_Jul_Lj, sum(KCJ260) Ums_Aug_Lj,
     c+ sum(KCJ270) Ums_Sep_Lj, sum(KCJ280) Ums_Okt_Lj,
     c+ sum(KCJ290) Ums_Nov_Lj, sum(KCJ300) Ums_Dez_Lj,
     c+ sum(KCJ430) Roh_Jan_Lj, sum(KCJ440) Roh_Feb_Lj,
     c+ sum(KCJ450) Roh_Mae_Lj, sum(KCJ460) Roh_Apr_Lj,
     c+ sum(KCJ470) Roh_Mai_Lj, sum(KCJ480) Roh_Jun_Lj,
     c+ sum(KCJ490) Roh_Jul_Lj, sum(KCJ500) Roh_Aug_Lj,
     c+ sum(KCJ510) Roh_Sep_Lj, sum(KCJ520) Roh_Okt_Lj,
     c+ sum(KCJ530) Roh_Nov_Lj, sum(KCJ540) Roh_Dez_Lj
     c+ FROM #mg0021
     c+ WHERE art050 in ('212', '313', '314', '316', '317', '318', '320',
     c+                  '328', '329', '330', '331', '332', '333', '334',
     c+                  '335', '336', '339', '340', '401', '404', '406',
     c+                  '407', '410', '412', '424', '429', '701', '703',
     c+                  '704', '338', '402')
     c+ GROUP BY
     c+ KDS070, KDS210, KDS580, KDS200,
     c+ art020, art030, art290, art050,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c/end-exec
     C*
     C     ##2000        ENDSR
     C*
     C**************************************************************************
     C*Gesamtauswertung Vorjahr(#mg0022)
     C*into: gang/#st0051
     C*-------------------------------------------------------------------------
     C*
     C     sr2100        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2100
     c/end-exec
     c/exec sql
     c+ insert into gang/#kp0054
     c+ SELECT
     c+ KDS070 COUNTRY, KDS210 BRANCHE,  KDS580 S_CHANNEL, kds200 C_GROUP,
     c+ art020 SUPPLIER, art030 MODEL_NO, art290 PRICE, Art050 PR_GROUP,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ as keyt, ' ' as record,
     c+ 0,0000 kurs, 0,0000 ics, 0,0000 icn, 0,0000 exs, 0,0000 exn,
     c+ 0,0000 oem, 0,0000 ghnetto, 0,0000 ghrab, 0,0000 risiko,
     c+ 0,0000 gk,
     c+ 0,00 kurs, 0,00 #ICS, 0,00 #ICN, 0,00 #EXS, 0,00 #EXN, 0,00 OEM,
     c+ 0,00 GHNETTO, 0,00 #GHRAB, 0,00 RISIKO, 0,00 #GK,
     c+ sum(KCJ070) Abs_Jan_Vj, sum(KCJ080) Abs_Feb_Vj,
     c+ sum(KCJ090) Abs_Mae_Vj, sum(KCJ100) Abs_Apr_Vj,
     c+ sum(KCJ110) Abs_Mai_Vj, sum(KCJ120) Abs_Jun_Vj,
     c+ sum(KCJ130) Abs_Jul_Vj, sum(KCJ140) Abs_Aug_Vj,
     c+ sum(KCJ150) Abs_Sep_Vj, sum(KCJ160) Abs_Okt_Vj,
     c+ sum(KCJ170) Abs_Nov_Vj, sum(KCJ180) Abs_Dez_Vj,
     c+ sum(KCJ190) Ums_Jan_Vj, sum(KCJ200) Ums_Feb_Vj,
     c+ sum(KCJ210) Ums_Mae_Vj, sum(KCJ220) Ums_Apr_Vj,
     c+ sum(KCJ230) Ums_Mai_Vj, sum(KCJ240) Ums_Jun_Vj,
     c+ sum(KCJ250) Ums_Jul_Vj, sum(KCJ260) Ums_Aug_Vj,
     c+ sum(KCJ270) Ums_Sep_Vj, sum(KCJ280) Ums_Okt_Vj,
     c+ sum(KCJ290) Ums_Nov_Vj, sum(KCJ300) Ums_Dez_Vj,
     c+ sum(KCJ430) Roh_Jan_Vj, sum(KCJ440) Roh_Feb_Vj,
     c+ sum(KCJ450) Roh_Mae_Vj, sum(KCJ460) Roh_Apr_Vj,
     c+ sum(KCJ470) Roh_Mai_Vj, sum(KCJ480) Roh_Jun_Vj,
     c+ sum(KCJ490) Roh_Jul_Vj, sum(KCJ500) Roh_Aug_Vj,
     c+ sum(KCJ510) Roh_Sep_Vj, sum(KCJ520) Roh_Okt_Vj,
     c+ sum(KCJ530) Roh_Nov_Vj, sum(KCJ540) Roh_Dez_Vj,
     c+ sum(KCJ070*0) Abs_Jan_Lj, sum(KCJ080*0) Abs_Feb_Lj,
     c+ sum(KCJ090*0) Abs_Mae_Lj, sum(KCJ100*0) Abs_Apr_Lj,
     c+ sum(KCJ110*0) Abs_Mai_Lj, sum(KCJ120*0) Abs_Jun_Lj,
     c+ sum(KCJ130*0) Abs_Jul_Lj, sum(KCJ140*0) Abs_Aug_Lj,
     c+ sum(KCJ150*0) Abs_Sep_Lj, sum(KCJ160*0) Abs_Okt_Lj,
     c+ sum(KCJ170*0) Abs_Nov_Lj, sum(KCJ180*0) Abs_Dez_Lj,
     c+ sum(KCJ190*0) Ums_Jan_Lj, sum(KCJ200*0) Ums_Feb_Lj,
     c+ sum(KCJ210*0) Ums_Mae_Lj, sum(KCJ220*0) Ums_Apr_Lj,
     c+ sum(KCJ230*0) Ums_Mai_Lj, sum(KCJ240*0) Ums_Jun_Lj,
     c+ sum(KCJ250*0) Ums_Jul_Lj, sum(KCJ260*0) Ums_Aug_Lj,
     c+ sum(KCJ270*0) Ums_Sep_Lj, sum(KCJ280*0) Ums_Okt_Lj,
     c+ sum(KCJ290*0) Ums_Nov_Lj, sum(KCJ300*0) Ums_Dez_Lj,
     c+ sum(KCJ430*0) Roh_Jan_Lj, sum(KCJ440*0) Roh_Feb_Lj,
     c+ sum(KCJ450*0) Roh_Mae_Lj, sum(KCJ460*0) Roh_Apr_Lj,
     c+ sum(KCJ470*0) Roh_Mai_Lj, sum(KCJ480*0) Roh_Jun_Lj,
     c+ sum(KCJ490*0) Roh_Jul_Lj, sum(KCJ500*0) Roh_Aug_Lj,
     c+ sum(KCJ510*0) Roh_Sep_Lj, sum(KCJ520*0) Roh_Okt_Lj,
     c+ sum(KCJ530*0) Roh_Nov_Lj, sum(KCJ540*0) Roh_Dez_Lj
     c+ FROM #mg0022
     c+ WHERE art050 in ('212', '313', '314', '316', '317', '318', '320',
     c+                  '328', '329', '330', '331', '332', '333', '334',
     c+                  '335', '336', '339', '340', '401', '404', '406',
     c+                  '407', '410', '412', '424', '429', '701', '703',
     c+                  '704', '338', '402')
     c+ GROUP BY
     c+ KDS070, KDS210, KDS580, KDS200,
     c+ art020, art030, art290, art050,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c/end-exec
     C*
     C     ##2100        ENDSR
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #kp0100                                95
     C   95              LEAVE
     C*
     c* Kalkulationsschema bestimmen
     c                   clear                   kschema           2 0
     c     akkey         chain     ARTNRKF0
     c                   IF        %found(ARTNR_KALK)
     c                   eval      KSCHEMA    = ZSCHEMA
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      kschema = KALKSCHEMA
     c                   ENDIF
     c                   ELSE
     c     kzuSCHEMA     chain     KALKSZUF1
     c                   IF        %found(Kalkschzu)
     c                   eval      KSCHEMA    = KALKSCHEMA
     c                   ENDIF
     c                   ENDIF
     c* SCHEMA

     c* Kalkulationsschema bestimmen
     c     keySCHEMA     chain     KSCHEMA_F1
     c                   IF        %found(KSchemata)
     c* SCHEMA
     c                   eval      KURS       = yKURS
     c                   eval      ICS        = yICS
     c                   eval      ICN        = yICN
     c                   eval      EXS        = yEXS
     c                   eval      EXN        = yEXN
     c                   eval      OEM        = yOEM
     c                   eval      GHNETTO    = yGHNETTO
     c                   eval      GHRAB      = yGHRAB
     c                   eval      RISIKO     = yRISIKO
     c                   eval      GK         = yGK
     c                   eval      #KURS      = yKURS    /  100 * Price
     c                   eval      #ICS       = yICS     /  100 * Price
     c                   eval      #ICN       = yICN     /  100 * Price
     c                   eval      #EXS       = yEXS     /  100 * Price
     c                   eval      #EXN       = yEXN     /  100 * Price
     c                   eval      #OEM       = yOEM     /  100 * Price
     c                   eval      #GHNETTO   = yGHNETTO /  100 * Price
     c                   eval      #GHRAB     = yGHRAB   /  100 * Price
     c                   eval      #RISIKO    = yRISIKO  /  100 * Price
     c                   eval      #GK        = yGK      /  100 * Price
     c                   else
     c                   clear                   KURS
     c                   clear                   ICS
     c                   clear                   ICN
     c                   clear                   EXS
     c                   clear                   EXN
     c                   clear                   OEM
     c                   clear                   GHNETTO
     c                   clear                   GHRAB
     c                   clear                   RISIKO
     c                   clear                   GK
     c                   clear                   #KURS
     c                   clear                   #ICS
     c                   clear                   #ICN
     c                   clear                   #EXS
     c                   clear                   #EXN
     c                   clear                   #OEM
     c                   clear                   #GHNETTO
     c                   clear                   #GHRAB
     c                   clear                   #RISIKO
     c                   clear                   #GK
     c                   ENDIF

     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR
     C*
     C**************************************************************************
     C*Ableitungen generieren
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#KP0101'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      '#KP0101'     OUTFIL           10
     C                   PARM      'GANG'        LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md

     C     ##4000        ENDSR
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
     C                   eval      vj_jahr = pjahr - 1
     C                   eval      nxt_jahr = pjahr + 1
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
