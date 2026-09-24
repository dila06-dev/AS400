      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:Auswertungen Herr Petersson
      *               
      * November 2009   GANG, MANFRED
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
     c                   kfld                    $lieferant

     c     kzuschema     klist
     c                   kfld                    nxt_jahr
     c                   kfld                    PR_GROUP

     c*  Schlüsselliste für ARTNR_KALK
     c     akkey         klist
     c                   kfld                    nxt_jahr
     c                   kfld                    SUPPLIER
     c                   kfld                    MODEL_NO
     C*
     C     *LIKE         DEFINE    lieferant     $lieferant
     C                   clear                   $lieferant
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
     c+ KDS070 COUNTRY, KDS020 CUSTOMER,
     c+                 KDS210 BRANCHE,  KDS580 S_CHANNEL, kds200 C_GROUP,
     c+ art020 SUPPLIER, art030 MODEL_NO, art290 PRICE, Art050 PR_GROUP,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ concat (digits(kds020))          as keyt, ' ' as record,
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
     c+ KDS070, kds020, KDS210, KDS580, KDS200,
     c+ art020, art030, art290, art050,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ concat (digits(kds020))
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
     c+ KDS070 COUNTRY, KDS020 CUSTOMER,
     c+                 KDS210 BRANCHE,  KDS580 S_CHANNEL, kds200 C_GROUP,
     c+ art020 SUPPLIER, art030 MODEL_NO, art290 PRICE, Art050 PR_GROUP,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ concat (digits(kds020))             as keyt, ' ' as record,
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
     c+ KDS070, kds020, KDS210, KDS580, KDS200,
     c+ art020, art030, art290, art050,
     c+ KDS070 concat (digits(kds210)) concat kds580 concat
     c+ (digits(kds200)) concat art020 concat art030 concat art050
     c+ concat (digits(kds020))
     c/end-exec
     C*
     C     ##2100        ENDSR
     C*
     C**************************************************************************
     C*Gesamtauswertung Vorjahr(#mg0022) Kunde
     C*into: gang/#st0051
     C*-------------------------------------------------------------------------
     C*
     C     sr2150        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2150
     c/end-exec
     c/exec sql
     c+ insert into gang/#kp0100
     c+ SELECT a.COUNTRY, a.customer, a.BRANCHE,  a.S_CHANNEL, a.C_GROUP,
     c+        a.SUPPLIER, a.MODEL_NO, a.PRICE, a.PR_GROUP,
     c+        a.keyt, a.record, a.kurs, a.ics, a.icn, a.exs,
     c+        a.exn, a.oem, a.ghnetto, a.ghrab, a.risiko, a.gk,
     c+                          a.#kurs, a.#ics, a.#icn, a.#exs,
     c+        a.#exn, a.#oem, a.#ghnetto, a.#ghrab, a.#risiko, a.#gk,
     c+        b.ABS_JAN_vJ, b.abS_FEB_vJ, b.ABS_MAE_vJ,
     c+        b.ABS_APR_vJ, b.ABS_MAI_vJ, b.ABS_JUN_vJ,
     c+        b.ABS_JUL_vJ, b.ABS_AUG_vJ, b.ABS_SEP_vJ,
     c+        b.ABS_OKT_vJ, b.ABS_NOV_vJ, b.ABS_DEZ_vJ,
     c+        b.UMS_JAN_vJ, b.UMS_FEB_vJ, b.UMS_MAE_vJ,
     c+        b.UMS_APR_vJ, b.UMS_MAI_vJ, b.UMS_JUN_vJ,
     c+        b.UMS_JUL_vJ, b.UMS_AUG_vJ, b.UMS_SEP_vJ,
     c+        b.UMS_OKT_vJ, b.UMS_NOV_vJ, b.UMS_DEZ_vJ,
     c+        b.ROH_JAN_vJ, b.ROH_FEB_vJ, b.ROH_MAE_vJ,
     c+        b.ROH_APR_vJ, b.ROH_MAI_vJ, b.ROH_JUN_vJ,
     c+        b.ROH_JUL_vJ, b.ROH_AUG_vJ, b.ROH_SEP_vJ,
     c+        b.ROH_OKT_vJ, b.ROH_NOV_vJ, b.ROH_DEZ_vJ,
     c+        a.ABS_JAN_LJ, a.abS_FEB_LJ, a.ABS_MAE_LJ,
     c+        a.ABS_APR_LJ, a.ABS_MAI_LJ, a.ABS_JUN_LJ,
     c+        a.ABS_JUL_LJ, a.ABS_AUG_LJ, a.ABS_SEP_LJ,
     c+        a.ABS_OKT_LJ, a.ABS_NOV_LJ, a.ABS_DEZ_LJ,
     c+        a.UMS_JAN_LJ, a.UMS_FEB_LJ, a.UMS_MAE_LJ,
     c+        a.UMS_APR_LJ, a.UMS_MAI_LJ, a.UMS_JUN_LJ,
     c+        a.UMS_JUL_LJ, a.UMS_AUG_LJ, a.UMS_SEP_LJ,
     c+        a.UMS_OKT_LJ, a.UMS_NOV_LJ, a.UMS_DEZ_LJ,
     c+        a.ROH_JAN_LJ, a.ROH_FEB_LJ, a.ROH_MAE_LJ,
     c+        a.ROH_APR_LJ, a.ROH_MAI_LJ, a.ROH_JUN_LJ,
     c+        a.ROH_JUL_LJ, a.ROH_AUG_LJ, a.ROH_SEP_LJ,
     c+        a.ROH_OKT_LJ, a.ROH_NOV_LJ, a.ROH_DEZ_LJ
     c+ FROM gang/#kp0053 a, gang/#kp0054 b
     c+ WHERE A.country   = b.country    and A.customer = b.customer
     c+                                  and A.BRANCHE  = b.BRANCHE   and
     c+       A.S_CHANNEL = b.S_CHANNEL  and A.C_GROUP  = b.C_GROUP   and
     c+       A.SUPPLIER  = b.SUPPLIER   and a.MODEL_NO = b.MODEL_NO  and
     c+       A.PRICE     = b.PRICE      and a.PR_GROUP = b.PR_GROUP  and
     c+       A.keyt      = b.keyt
     c/end-exec
     C*************      goto      ##2150
     c/exec sql
     c+ whenever not found goto ##2150
     c/end-exec
     c/exec sql
     c+ insert into gang/#kp0100
     c+ SELECT COUNTRY,
     c+        customer,
     c+        BRANCHE,
     c+        S_CHANNEL,
     c+        C_GROUP,
     c+        SUPPLIER,
     c+        MODEL_NO,
     c+        PRICE,
     c+        PR_GROUP,
     c+        KEYT,
     c+        'N',
     c+        KURS,
     c+        ICS,
     c+        ICN,
     c+        EXS,
     c+        EXN,
     c+        OEM,
     c+        GHNETTO,
     c+        GHRAB,
     c+        RISIKO,
     c+        GK,
     c+        #KURS,
     c+        #ICS,
     c+        #ICN,
     c+        #EXS,
     c+        #EXN,
     c+        #OEM,
     c+        #GHNETTO,
     c+        #GHRAB,
     c+        #RISIKO,
     c+        #GK,
     c+        ABS_JAN_VJ,
     c+        ABS_FEB_VJ,
     c+        ABS_MAE_VJ,
     c+        ABS_APR_VJ,
     c+        ABS_MAI_VJ,
     c+        ABS_JUN_VJ,
     c+        ABS_JUL_VJ,
     c+        ABS_AUG_VJ,
     c+        ABS_SEP_VJ,
     c+        ABS_OKT_VJ,
     c+        ABS_NOV_VJ,
     c+        ABS_DEZ_VJ,
     c+        UMS_JAN_VJ,
     c+        UMS_FEB_VJ,
     c+        UMS_MAE_VJ,
     c+        UMS_APR_VJ,
     c+        UMS_MAI_VJ,
     c+        UMS_JUN_VJ,
     c+        UMS_JUL_VJ,
     c+        UMS_AUG_VJ,
     c+        UMS_SEP_VJ,
     c+        UMS_OKT_VJ,
     c+        UMS_NOV_VJ,
     c+        UMS_DEZ_VJ,
     c+        ROH_JAN_VJ,
     c+        ROH_FEB_VJ,
     c+        ROH_MAE_VJ,
     c+        ROH_APR_VJ,
     c+        ROH_MAI_VJ,
     c+        ROH_JUN_VJ,
     c+        ROH_JUL_VJ,
     c+        ROH_AUG_VJ,
     c+        ROH_SEP_VJ,
     c+        ROH_OKT_VJ,
     c+        ROH_NOV_VJ,
     c+        ROH_DEZ_VJ,
     c+        ABS_JAN_LJ,
     c+        ABS_FEB_LJ,
     c+        ABS_MAE_LJ,
     c+        ABS_APR_LJ,
     c+        ABS_MAI_LJ,
     c+        ABS_JUN_LJ,
     c+        ABS_JUL_LJ,
     c+        ABS_AUG_LJ,
     c+        ABS_SEP_LJ,
     c+        ABS_OKT_LJ,
     c+        ABS_NOV_LJ,
     c+        ABS_DEZ_LJ,
     c+        UMS_JAN_LJ,
     c+        UMS_FEB_LJ,
     c+        UMS_MAE_LJ,
     c+        UMS_APR_LJ,
     c+        UMS_MAI_LJ,
     c+        UMS_JUN_LJ,
     c+        UMS_JUL_LJ,
     c+        UMS_AUG_LJ,
     c+        UMS_SEP_LJ,
     c+        UMS_OKT_LJ,
     c+        UMS_NOV_LJ,
     c+        UMS_DEZ_LJ,
     c+        ROH_JAN_LJ,
     c+        ROH_FEB_LJ,
     c+        ROH_MAE_LJ,
     c+        ROH_APR_LJ,
     c+        ROH_MAI_LJ,
     c+        ROH_JUN_LJ,
     c+        ROH_JUL_LJ,
     c+        ROH_AUG_LJ,
     c+        ROH_SEP_LJ,
     c+        ROH_OKT_LJ,
     c+        ROH_NOV_LJ,
     c+        ROH_DEZ_LJ
     c+ FROM gang/#kp0053
     c+ WHERE keyt  not in (select keyt  from gang/#kp0100)
     c/end-exec
     C*
     C*
     c/exec sql
     c+ whenever not found goto ##2150
     c/end-exec
     c/exec sql
     c+ insert into gang/#kp0100
     c+ SELECT COUNTRY,
     c+        customer,
     c+        BRANCHE,
     c+        S_CHANNEL,
     c+        C_GROUP,
     c+        SUPPLIER,
     c+        MODEL_NO,
     c+        PRICE,
     c+        PR_GROUP,
     c+        KEYT,
     c+        'A',
     c+        KURS,
     c+        ICS,
     c+        ICN,
     c+        EXS,
     c+        EXN,
     c+        OEM,
     c+        GHNETTO,
     c+        GHRAB,
     c+        RISIKO,
     c+        GK,
     c+        #KURS,
     c+        #ICS,
     c+        #ICN,
     c+        #EXS,
     c+        #EXN,
     c+        #OEM,
     c+        #GHNETTO,
     c+        #GHRAB,
     c+        #RISIKO,
     c+        #GK,
     c+        ABS_JAN_VJ,
     c+        ABS_FEB_VJ,
     c+        ABS_MAE_VJ,
     c+        ABS_APR_VJ,
     c+        ABS_MAI_VJ,
     c+        ABS_JUN_VJ,
     c+        ABS_JUL_VJ,
     c+        ABS_AUG_VJ,
     c+        ABS_SEP_VJ,
     c+        ABS_OKT_VJ,
     c+        ABS_NOV_VJ,
     c+        ABS_DEZ_VJ,
     c+        UMS_JAN_VJ,
     c+        UMS_FEB_VJ,
     c+        UMS_MAE_VJ,
     c+        UMS_APR_VJ,
     c+        UMS_MAI_VJ,
     c+        UMS_JUN_VJ,
     c+        UMS_JUL_VJ,
     c+        UMS_AUG_VJ,
     c+        UMS_SEP_VJ,
     c+        UMS_OKT_VJ,
     c+        UMS_NOV_VJ,
     c+        UMS_DEZ_VJ,
     c+        ROH_JAN_VJ,
     c+        ROH_FEB_VJ,
     c+        ROH_MAE_VJ,
     c+        ROH_APR_VJ,
     c+        ROH_MAI_VJ,
     c+        ROH_JUN_VJ,
     c+        ROH_JUL_VJ,
     c+        ROH_AUG_VJ,
     c+        ROH_SEP_VJ,
     c+        ROH_OKT_VJ,
     c+        ROH_NOV_VJ,
     c+        ROH_DEZ_VJ,
     c+        ABS_JAN_LJ,
     c+        ABS_FEB_LJ,
     c+        ABS_MAE_LJ,
     c+        ABS_APR_LJ,
     c+        ABS_MAI_LJ,
     c+        ABS_JUN_LJ,
     c+        ABS_JUL_LJ,
     c+        ABS_AUG_LJ,
     c+        ABS_SEP_LJ,
     c+        ABS_OKT_LJ,
     c+        ABS_NOV_LJ,
     c+        ABS_DEZ_LJ,
     c+        UMS_JAN_LJ,
     c+        UMS_FEB_LJ,
     c+        UMS_MAE_LJ,
     c+        UMS_APR_LJ,
     c+        UMS_MAI_LJ,
     c+        UMS_JUN_LJ,
     c+        UMS_JUL_LJ,
     c+        UMS_AUG_LJ,
     c+        UMS_SEP_LJ,
     c+        UMS_OKT_LJ,
     c+        UMS_NOV_LJ,
     c+        UMS_DEZ_LJ,
     c+        ROH_JAN_LJ,
     c+        ROH_FEB_LJ,
     c+        ROH_MAE_LJ,
     c+        ROH_APR_LJ,
     c+        ROH_MAI_LJ,
     c+        ROH_JUN_LJ,
     c+        ROH_JUL_LJ,
     c+        ROH_AUG_LJ,
     c+        ROH_SEP_LJ,
     c+        ROH_OKT_LJ,
     c+        ROH_NOV_LJ,
     c+        ROH_DEZ_LJ
     c+ FROM gang/#kp0054
     c+ WHERE Keyt  not in (select Keyt  from gang/#kp0100)
     c/end-exec
     C*
     C     ##2150        ENDSR
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
     C                   eval      nxt_jahr = pjahr + 0
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
