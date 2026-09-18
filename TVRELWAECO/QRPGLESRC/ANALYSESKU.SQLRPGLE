     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      * ==>          :..........                         JJ==>OK
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
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************

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
     D Wrk             DS                  Qualified inz
     D SatzGef                        1A   inz(' ')
     D BatPfad                      100A   inz(' ')
     D WebDName                     100A   inz(' ')
     D BatName                      100A   inz(' ')
     D Var1                         200A   inz(' ')
     D Laenge          s              9  0

     D QCMDEXC         PR                  ExtPgm('QCMDEXC')
     D cmd                        32702A   const options(*varsize)
     D len                           15P 5 const

     D cmd             s            200A   varying

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
     C*    *ENTRY        PLIST
     C*                  PARM                    ic               06
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr2000
     c                   exsr      sr1000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     c/exec sql
     c*+ whenever not found goto ##1000
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/ANALYSESKU
     c+ SELECT ARTNR ,artsku,artbezfra, char(' ', 1) status, ARTZ3
     c+ itemstaus, e1 replacm, anldat birthdate, artbez, current date #date
     c+ , current timestamp #tstamp, char(' ', 1) sku1stamm, char(' ', 1)
     c+ sku2stamm, KCJMNG_VJ, KCJMNG_AJ, KCJUMS_VJ, KCJUMS_AJ, abc, artean,
     c+ #TEDIAV,#TESAAV,ARTGRP,STATNR, liefnr domgrp, EVP_AJ , dec(0, 13,
     c+ 3) preise2014 , dec(0, 13, 3) pricesku ,
     c+ LIEFERANT1, LIEFERANT2, LAENGE, BREITE, HOEHE,
     c+ GEWICHT ,uland, zollnr,artean , char(' ', 15) arteansku,
     c+ char(' ', 15) mcob_item, char(' ', 15) mcob_sku,
     c+ char(' ', 15) mdp_item, char(' ', 15) mdp_sku,
     c+ char(' ', 15) mf_item, char(' ', 15) mf_sku,
     c+ char(' ', 15) OTRA_item, char(' ', 15)OTRA_sku,
     c+ char(' ', 110) additional_infos_I,
     c+ char(' ', 110) additional_infor_II
     c+ from bar_kalk/kalk_file WHERE version='$$EL_PS_DB'
     c*+ and (ARTZ3 <> '90' or  KCJMNG_VJ<> 0 or KCJMNG_AJ<> 0)
     c*+ and abc not in ('K')
     c+ and artgrp not in
     c+     ('LOH','GAR','M01','M02','M03','M05','M06','M10','M11')
     c/end-exec

     C*x
     c/exec sql
     c+ update analysesku set status = '9' where
     c+ artbezfra <> ' ' and artsku <> artbezfra
     c/end-exec
     c*
     C*x
     c/exec sql
     c+ update analysesku set status = '0' where
     c+ artbezfra <> ' ' and artsku =  artbezfra
     c/end-exec
     c*
     C*x
     c/exec sql
     c+ update analysesku set sku1stamm='E' where
     c+ artsku  not in
     c+ (select tetenr from teil01 where tefirm='01')
     c/end-exec
     c*
     C*x
     c/exec sql
     c+ update analysesku set sku2stamm='E' where
     c+ substr(artbezfra, 1, 15)  not in
     c+ (select tetenr from teil01 where tefirm='01')
     c/end-exec
     c*
     C*x
     c***/exec sql
     c***+ update ANALYSESKU a set a.PREISE2014 =
     c***+ (select EVP_AJ from bar_kalk/kalk_file b where
     c***+ a.artnr = b.artnr and version='$$p2014')
     c***+ where exists
     c***+ (select EVP_AJ from bar_kalk/kalk_file b where
     c***+ a.artnr = b.artnr and version='$$p2014')
     c***/end-exec
     c*

     c/exec sql
     c+ update ANALYSESKU a set a.PREISE2014 =
     c+ (select #PRS050 from qtemp/mark         b where
     c+ a.artnr = b.#PRS040 )
     c+ where exists
     c+ (select #PRS050 from qtemp/mark         b where
     c+ a.artnr = b.#PRS040 )
     c/end-exec
     c*

     C*
     c/exec sql
     c+ update ANALYSESKU set ADDIT00001 =
     c+ 'please use for ordering the corrected sku ==> ' concat artbezfra
     c+ WHERE artSKU<>ARTBEZFRA and artbezfra <> ' '
     c/end-exec


     C*Katalog MCOB
     c/exec sql
     c+ update ANALYSESKU a set MCOB_ITEM =
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MCOB' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MCOB' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set MCOB_sku =
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MCOB' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MCOB' group by b.sku)
     c/end-exec


     C*Katalog MDP
     c/exec sql
     c+ update ANALYSESKU a set MDP_ITEM =
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MDP ' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MDP ' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set MDP_sku =
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MDP ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MDP ' group by b.sku)
     c/end-exec


     C*Katalog MF
     c/exec sql
     c+ update ANALYSESKU a set MF_ITEM =
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MF  ' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MF  ' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set MF_sku =
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MF  ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='MF  ' group by b.sku)
     c/end-exec


     C*Katalog OTRA
     c/exec sql
     c+ update ANALYSESKU a set otra_item =
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='OTRA' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.artnr
     c+       and KATALOG ='OTRA' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set otra_sku =
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='OTRA' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.artnr
     c+       and KATALOG ='OTRA' group by b.sku)
     c/end-exec


     C*Errors im Katalog
     c/exec sql
     c+ update ANALYSESKU set ADDIT00002 =
     c+ 'problem in the definition by catalogues ==> ' concat artbezfra
     c+ where
     c+ ( MCOB_SKU <> artbezfra      and
     c+   MCOB_SKU <> ' ' and artbezfra      <> ' ') or
     c+ ( MDP_SKU  <> artbezfra      and
     c+   MDP_SKU  <> ' ' and artbezfra      <> ' ') or
     c+ ( MF_SKU   <> artbezfra      and
     c+   MF_SKU   <> ' ' and artbezfra      <> ' ') or
     c+ ( OTRA_SKU <> artbezfra      and
     c+   OTRA_SKU <> ' ' and artbezfra      <> ' ')
     c/end-exec
     C*

     C*Errors im Katalog
     c/exec sql
     c+ update ANALYSESKU set ADDIT00002 =
     c+ 'problem in the definition by catalogues ==> ' concat artsku
     c+ where
     c+ ( MCOB_SKU <>         artSKU and
     c+   MCOB_SKU <> ' ' and artbezfra      =  ' ') or
     c+ ( MDP_SKU  <>         artSKU and
     c+   MDP_SKU  <> ' ' and artbezfra      =  ' ') or
     c+ ( MF_SKU   <>         artSKU and
     c+   MF_SKU   <> ' ' and artbezfra      =  ' ') or
     c+ ( OTRA_SKU <>         artSKU and
     c+   OTRA_SKU <> ' ' and artbezfra      =  ' ')
     c/end-exec
     C*

     C*...
     c/exec sql
     c+ update ANALYSESKU a set arteansku =
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.artbezfra
     c+       and version='$$EL_PS_DB' and a.artbezfra<>' ')
     c+  where exists
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.artbezfra
     c+       and version='$$EL_PS_DB' and a.artbezfra<>' ')
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set arteansku =
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.artsku
     c+       and version='$$EL_PS_DB' and a.artbezfra=' ')
     c+  where exists
     c+ (select b.artean from bar_kalk/kalk_file b where
     c+       b.artnr=a.artsku
     c+       and version='$$EL_PS_DB' and a.artbezfra=' ')
     c/end-exec
     C*
     C*...        preise
     c/exec sql
     c+ update ANALYSESKU a set pricesku  =
     c+ (select EVP_AJ   from bar_kalk/kalk_file b where
     c+       b.artnr=a.artbezfra
     c+       and version='$$p2014   ' and a.artbezfra<>' ')
     c+  where exists
     c+ (select EVP_AJ   from bar_kalk/kalk_file b where
     c+       b.artnr=a.artbezfra
     c+       and version='$$p2014   ' and a.artbezfra<>' ')
     c/end-exec
     C*
     c/exec sql
     c+ update ANALYSESKU a set pricesku  =
     c+ (select EVP_AJ   from bar_kalk/kalk_file b where
     c+       b.artnr=a.artsku
     c+       and version='$$p2014   ' and a.artbezfra=' ')
     c+  where exists
     c+ (select EVP_AJ   from bar_kalk/kalk_file b where
     c+       b.artnr=a.artsku
     c+       and version='$$p2014   ' and a.artbezfra=' ')
     c/end-exec
     C*

     C*Grundaufbau
     c/exec sql
     c+ insert into tvrelwaeco/sku_change
     c+ SELECT ARTNR item, ARTBEZ desc, artsku sku, artean EAN_item,
     c+ ARTEANSKU EAN_SKU, ITEMSTAUS status_item, MCOB_item MCOB_sku,
     c+ MDP_item MDP_SKU, MF_item MF_Sku, OTRA_item otra_SKU, #tstamp
     c+ tstamp FROM analysesku where
     c+ ( KCJMNG_VJ <> 0 or KCJMNG_AJ <> 0 or
     c+   KCJUMS_VJ <> 0 or KCJUMS_AJ <> 0 or BIRTHDATE > 20121231 )
     c+ and
     c+ lieferant1 not in ('90025', '90489')
     c+ and
     c+ lieferant1 not in ('90526', '92404', '92025')
     c+ and
     c+ lieferant1 not in ('90325', '90204')
     c+ and
     c+ ITEMSTAUS  not in ('90', '81')
     c+ and
     c+ abc       not in ('K', 'X')
     c+ and
     c+ artgrp not in ('ENT','FRA','FWK','GAR','LOH','M01','M02','M03',
     c+                'M05','M06','M10','M11','SON','WER')
     c+ and
     c+ statnr    not in ('906', '196')
     c/end-exec

     c/exec sql
     c+ update sku_change a set sku       =
     c+ (select b.artbezfra from bar_kalk/kalk_file b where
     c+       b.artnr=a.item
     c+       and version='$$EL_PS_DB' and b.artbezfra<>' ')
     c+  where exists
     c+ (select b.artbezfra from bar_kalk/kalk_file b where
     c+       b.artnr=a.item
     c+       and version='$$EL_PS_DB' and b.artbezfra<>' ')
     c/end-exec
     C*
     c/exec sql
     c+ update sku_change a set sku       =
     c+ (select b.artsku from bar_kalk/kalk_file b where
     c+       b.artnr=a.item
     c+       and version='$$EL_PS_DB' and b.artbezfra=' ')
     c+  where exists
     c+ (select b.artsku from bar_kalk/kalk_file b where
     c+       b.artnr=a.item
     c+       and version='$$EL_PS_DB' and b.artbezfra=' ')
     c/end-exec
     C*

     c*
     C     ##1000        ENDSR
     c*
     c*
     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/ANALYSESKU';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'TVRELWAECO/sku_change';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------

     C     sr9999        BEGSR
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
     C*

     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   gang/systempf
     c/end-exec

     C     ##9999        ENDSR

     C**************************************************************************
     C*.
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
