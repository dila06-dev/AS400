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
     f#dl0100   uf   e             disk
     F                                     RENAME(#dl0100r:phy02r)
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

     C*
     C                   exsr      sr2000
     C                   exsr      sr2100
     C                   exsr      sr2150
     C                   exsr      sr2500
     C                   exsr      sr2505
     C                   open      #dl0100
     C                   exsr      sr3000
     C                   close     #dl0100
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
     c+ insert into gang/#dl0050
     c+ SELECT
     c+ kds020 Kunde, kds030 Name_1, kds040 Name_2, kds050 Name_3,
     c+ kds080 PLZ, kds090 Ort, KDS590 Vt1,
     c+ KDS210 BRANCHE, KDS200 Kgruppe, KDS100 mc, art050 StatNr,
     c+ ART020 Lief, ART030 Artikel, art060 ArtBezeich, ART040 Art_Grp,
     c+ art270 PREIS1, art290 PREIS2,
     c+ (digits(kds020)) concat art020 concat art030 as keyt, ' ' as record,
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
     c+ WHERE KDS210 = 63
     c+ GROUP BY
     c+ kds020, kds030, kds040, kds050, kds080, kds090, KDS590,
     c+ KDS210, KDS200, KDS100, art050,
     c+ ART020, ART030, art060, ART040,
     c+ art270, art290,
     c+ (digits(kds020)) concat art020 concat art030
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
     c+ insert into gang/#dl0051
     c+ SELECT
     c+ kds020 Kunde, kds030 Name_1, kds040 Name_2, kds050 Name_3,
     c+ kds080 PLZ, kds090 Ort, KDS590 Vt1,
     c+ KDS210 BRANCHE, KDS200 Kgruppe, KDS100 mc, art050 StatNr,
     c+ ART020 Lief, ART030 Artikel, art060 ArtBezeich,    ART040 Art_Grp,
     c+ art270 PREIS1, art290 PREIS2,
     c+ (digits(kds020)) concat art020 concat art030 as keyt, ' ' as record,
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
     c+ WHERE KDS210 = 63
     c+ GROUP BY
     c+ kds020, kds030, kds040, kds050, kds080, kds090, KDS590,
     c+ KDS210, KDS200, KDS100, art050,
     c+ ART020, ART030, art060, ART040,
     c+ art270, art290,
     c+ (digits(kds020)) concat art020 concat art030
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
     c+ insert into gang/#dl0100
     c+ SELECT
     c+        a.Kunde, a.Name_1, a.Name_2, a.Name_3, a.PLZ, a.Ort, a.Vt1,
     c+        a.BRANCHE, a.Kgruppe, a.mc, a.StatNr,
     c+        a.Lief, a.Artikel, a.ArtBezeich, a.Art_Grp,
     c+        a.PREIS1, a.PREIS2, a.keyt, a.record,
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
     c+ FROM gang/#dl0050 a, gang/#dl0051 b
     c+ where  A.keyt  = b.keyt
     c/end-exec
     C*************      goto      ##2150
     c/exec sql
     c+ whenever not found goto ##2150
     c/end-exec
     c/exec sql
     c+ insert into gang/#dl0100
     c+ SELECT KUNDE,
     c+        NAME_1,
     c+        NAME_2,
     c+        NAME_3,
     c+        PLZ,
     c+        ORT,
     c+        VT1,
     c+        BRANCHE,
     c+        KGRUPPE,
     c+        MC,
     c+        STATNR,
     c+        LIEF,
     c+        ARTIKEL,
     c+        ARTBEZEICH,
     c+        ART_GRP,
     c+        PREIS1,
     c+        PREIS2,
     c+        KEYT,
     c+        RECORD,
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
     c+ FROM gang/#dl0050
     c+ WHERE keyt  not in (select keyt  from gang/#dl0100)
     c/end-exec
     C*
     C*
     c/exec sql
     c+ whenever not found goto ##2150
     c/end-exec
     c/exec sql
     c+ insert into gang/#dl0100
     c+ SELECT KUNDE,
     c+        NAME_1,
     c+        NAME_2,
     c+        NAME_3,
     c+        PLZ,
     c+        ORT,
     c+        VT1,
     c+        BRANCHE,
     c+        KGRUPPE,
     c+        MC,
     c+        STATNR,
     c+        LIEF,
     c+        ARTIKEL,
     c+        ARTBEZEICH,
     c+        ART_GRP,
     c+        PREIS1,
     c+        PREIS2,
     c+        KEYT,
     c+        RECORD,
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
     c+ FROM gang/#dl0051
     c+ WHERE Keyt  not in (select Keyt  from gang/#dl0100)
     c/end-exec
     C*
     C     ##2150        ENDSR
     C*
     C**************************************************************************
     C*Gesamtauswertung in #dl0200
     C*Summenbildungen
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2500
     c/end-exec
     c/exec sql
     c+ insert into gang/#dl0200
     c+ SELECT
     c+ KUNDE, NAME_1, Name_2, Name_3,
     c+                PLZ, ORT, VT1, BRANCHE, KGRUPPE, MC, STATNR,
     c+ LIEF, ARTIKEL, ARTBEZEICH, ART_GRP, PREIS1, PREIS2,
     c+ decimal((ABS_JAN_VJ * :P01 + ABS_FEB_VJ * :P02 + ABS_MAE_VJ * :P03 +
     c+          ABS_APR_VJ * :P04 + ABS_MAI_VJ * :P05 + ABS_JUN_VJ * :P06 +
     c+          ABS_JUL_VJ * :P07 + ABS_AUG_VJ * :P08 + ABS_SEP_VJ * :P09 +
     c+          ABS_OKT_VJ * :P10 + ABS_NOV_VJ * :P11 + ABS_DEZ_VJ * :P12 )
     c+          , 12, 2 ) Absatz2008,
     c+ decimal((UMS_JAN_VJ * :P01 + UMS_FEB_VJ * :P02 + UMS_MAE_VJ * :P03 +
     c+          UMS_APR_VJ * :P04 + UMS_MAI_VJ * :P05 + UMS_JUN_VJ * :P06 +
     c+          UMS_JUL_VJ * :P07 + UMS_AUG_VJ * :P08 + UMS_SEP_VJ * :P09 +
     c+          UMS_OKT_VJ * :P10 + UMS_NOV_VJ * :P11 + UMS_DEZ_VJ * :P12 )
     c+          , 12, 2 ) Umsatz2008,
     c+ decimal((ROH_JAN_VJ * :P01 + ROH_FEB_VJ * :P02 + ROH_MAE_VJ * :P03 +
     c+          ROH_APR_VJ * :P04 + ROH_MAI_VJ * :P05 + ROH_JUN_VJ * :P06 +
     c+          ROH_JUL_VJ * :P07 + ROH_AUG_VJ * :P08 + ROH_SEP_VJ * :P09 +
     c+          ROH_OKT_VJ * :P10 + ROH_NOV_VJ * :P11 + ROH_DEZ_VJ * :P12 )
     c+          , 12, 2 ) Roherl2008,
     c+ decimal((ABS_JAN_LJ * :P01 + ABS_FEB_LJ * :P02 + ABS_MAE_LJ * :P03 +
     c+          ABS_APR_LJ * :P04 + ABS_MAI_LJ * :P05 + ABS_JUN_LJ * :P06 +
     c+          ABS_JUL_LJ * :P07 + ABS_AUG_LJ * :P08 + ABS_SEP_LJ * :P09 +
     c+          ABS_OKT_LJ * :P10 + ABS_NOV_LJ * :P11 + ABS_DEZ_LJ * :P12 )
     c+          , 12, 2 ) Absatz2009,
     c+ decimal((UMS_JAN_LJ * :P01 + UMS_FEB_LJ * :P02 + UMS_MAE_LJ * :P03 +
     c+          UMS_APR_LJ * :P04 + UMS_MAI_LJ * :P05 + UMS_JUN_LJ * :P06 +
     c+          UMS_JUL_LJ * :P07 + UMS_AUG_LJ * :P08 + UMS_SEP_LJ * :P09 +
     c+          UMS_OKT_LJ * :P10 + UMS_NOV_LJ * :P11 + UMS_DEZ_LJ * :P12 )
     c+          , 12, 2 ) Umsatz2009,
     c+ decimal((ROH_JAN_LJ * :P01 + ROH_FEB_LJ * :P02 + ROH_MAE_LJ * :P03 +
     c+          ROH_APR_LJ * :P04 + ROH_MAI_LJ * :P05 + ROH_JUN_LJ * :P06 +
     c+          ROH_JUL_LJ * :P07 + ROH_AUG_LJ * :P08 + ROH_SEP_LJ * :P09 +
     c+          ROH_OKT_LJ * :P10 + ROH_NOV_LJ * :P11 + ROH_DEZ_LJ * :P12 )
     c+          , 12, 2 ) Roherl2009
     c+ FROM #dl0100
     c/end-exec
     C*
     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C*Gesamtauswertung in #dl0205
     C*Summenbildungen
     C*-------------------------------------------------------------------------
     C*
     C     sr2505        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2505
     c/end-exec
     c/exec sql
     c+ insert into gang/#dl0205
     c+ SELECT
     c+ KUNDE, NAME_1, NAME_2, NAME_3, PLZ, ORT, VT1, BRANCHE,
     c+ KGRUPPE, MC, STATNR, LIEF, ARTIKEL, ARTBEZEICH, ART_GRP, PREIS1,
     c+ PREIS2, decimal( sum( ABS_JAN_VJ+ ABS_FEB_VJ+ ABS_MAE_VJ+
     c+ ABS_APR_VJ+ ABS_MAI_VJ+ ABS_JUN_VJ+ ABS_JUL_VJ+ ABS_AUG_VJ+
     c+ ABS_SEP_VJ+ ABS_OKT_VJ+ ABS_NOV_VJ+ ABS_DEZ_VJ), 13, 2) AbsatzVJ,
     c+ decimal( sum(UMS_JAN_VJ+ UMS_FEB_VJ+ UMS_MAE_VJ+ UMS_APR_VJ+
     c+ UMS_MAI_VJ+ UMS_JUN_VJ+ UMS_JUL_VJ+ UMS_AUG_VJ+ UMS_SEP_VJ+
     c+ UMS_OKT_VJ+ UMS_NOV_VJ+ UMS_DEZ_VJ), 13, 2) UmsatzVJ, decimal(
     c+ sum(ROH_JAN_VJ+ ROH_FEB_VJ+ ROH_MAE_VJ+ ROH_APR_VJ+ ROH_MAI_VJ+
     c+ ROH_JUN_VJ+ ROH_JUL_VJ+ ROH_AUG_VJ+ ROH_SEP_VJ+ ROH_OKT_VJ+
     c+ ROH_NOV_VJ+ ROH_DEZ_VJ ), 13, 2) RohVJ FROM #dl0100 GROUP BY KUNDE,
     c+ NAME_1, NAME_2, NAME_3, PLZ, ORT, VT1, BRANCHE, KGRUPPE, MC,
     c+ STATNR, LIEF, ARTIKEL, ARTBEZEICH, ART_GRP, PREIS1, PREIS2
     c/end-exec
     C*
     C     ##2505        ENDSR
     C*
     C**************************************************************************
     C*Kalkulationschemata integrieren
     C*-------------------------------------------------------------------------
     C*
     C     sr3000        BEGSR
     C*
     C                   DO        *HIVAL
     C*
     C                   READ      #dl0100                                95
     C   95              LEAVE
     C*
     C                   update    phy02r
     C*
     C                   enddo

     C*
     C     ##3000        ENDSR

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
     C                   z-add     1             p01               1 0
     C                   if        pmonat > 1
     C                   z-add     1             p02               1 0
     C                   endif
     C                   if        pmonat > 2
     C                   z-add     1             p03               1 0
     C                   endif
     C                   if        pmonat > 3
     C                   z-add     1             p04               1 0
     C                   endif
     C                   if        pmonat > 4
     C                   z-add     1             p05               1 0
     C                   endif
     C                   if        pmonat > 5
     C                   z-add     1             p06               1 0
     C                   endif
     C                   if        pmonat > 6
     C                   z-add     1             p07               1 0
     C                   endif
     C                   if        pmonat > 7
     C                   z-add     1             p08               1 0
     C                   endif
     C                   if        pmonat > 8
     C                   z-add     1             p09               1 0
     C                   endif
     C                   if        pmonat > 9
     C                   z-add     1             p10               1 0
     C                   endif
     C                   if        pmonat > 10
     C                   z-add     1             p11               1 0
     C                   endif
     C                   if        pmonat > 11
     C                   z-add     1             p12               1 0
     C                   endif
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
