     ******************************************************************
      * PROGRAMMNAME.:...                                                     
      * FUNKTION.....:...
      *               ...
      *
      * 15. Okt.2010   GANG, MANFRED
      *
      * WAECO International GmbH
      *
      * Hollefeldstrasse 63
      *
      * 48282 Emsdetten
      *
      * ********************************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *
      *********************************************************************************

     f***man       uf   e             disk
     f***                                     RENAME(man:phy01r)
     f***                                     INFDS(DSF1)
     F***                                     USROPN

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
     I*-------------------------------------------------------------------------
     I/COPY ##E
     I/COPY ##I001
     I*/COPY ##I002
     I*/COPY ##I003
     I*/COPY ##I003
     I*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     C                   PARM                    §§amkdnr         10
     I*-------------------------------------------------------------------------
     C*                  open      man
     C*                  DO        *HIVAL
     C*
     C*                  READ      man                                    95
     C*                  IF        *in95 = '1'
     C*                  leave
     C*                  else
     C*                  movel     man12         artnr
     C*                  exsr      srlines
     c*                  update    phy01r
     c*                  endif
     C
     C*                  enddo
     C*                  close     man
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*write
     c                   exsr      sr6000

     C                   EXSR      RETURN

     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr6000        BEGSR
     C*
     c/exec sql
     c+ whenever not found CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     C*
     c/exec sql
     c+ insert into  TVRELWAECO/NEW_ITEMS
     c+ SELECT ARTNR item, ARTBEZ description, ARTGRP itemgroup, STATNR,
     c+ ABC, ARTZ3 itemstatus, ANLDAT creation_date,
     c+ ARTBEZFRA correction_SKU, E1
     c+ Replacement, ARTSKU sku, ICS_, LIEFNR DomGroup,
     c+ char(' ', 15) mcob_item, char(' ', 15) mcob_sku,
     c+ char(' ', 15) mdp_item, char(' ', 15) mdp_sku,
     c+ char(' ', 15) mf_item, char(' ', 15) mf_sku,
     c+ char(' ', 15) OTRA_item, char(' ', 15)OTRA_sku,
     c+ char(' ', 110) additional_infos_I,
     c+ char(' ', 110) additional_infor_II,
     c+ tstamp
     c+ FROM bar_kalk/kalk_file  WHERE  version='$$EL_PS_DB'
     c+ and   (
     c+      date(substr(char(anldat), 1, 4) concat '-'  concat
     c+            substr(char(anldat), 5, 2) concat '-'  concat
     c+            substr(char(anldat), 7, 2)) > (current date)-5  day
     c+   or
     c+     artnr in ( select TEOSTENR from teos WHERE
     c+     TEOSKLCD ='SKU' and
     c+      date(substr(char(TEOSJDAT), 1, 4) concat '-'  concat
     c+            substr(char(TEOSJDAT), 5, 2) concat '-'  concat
     c+            substr(char(TEOSJDAT), 7, 2)) > (current date)-5  day)
     c+   or
     c+     artnr in ( select item from kataloge)
     c+     )
     c+
     c/end-exec

     C*
     c/exec sql
     c+ update new_items set ADDIT00001 =
     c+ 'please use for ordering the corrected sku ==> ' concat artbezfra
     c+ WHERE SKU<>ARTBEZFRA and artbezfra <> ' '
     c/end-exec


     C*Katalog MCOB
     c/exec sql
     c+ update new_items a set MCOB_ITEM =
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update new_items a set MCOB_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MCOB' group by b.sku)
     c/end-exec


     C*Katalog MDP
     c/exec sql
     c+ update new_items a set MDP_ITEM =
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update new_items a set MDP_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MDP ' group by b.sku)
     c/end-exec


     C*Katalog MF
     c/exec sql
     c+ update new_items a set MF_ITEM =
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update new_items a set MF_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='MF  ' group by b.sku)
     c/end-exec


     C*Katalog OTRA
     c/exec sql
     c+ update new_items a set otra_item =
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.item)
     c+  where exists
     c+ (select b.item from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.item)
     c/end-exec
     C*
     c/exec sql
     c+ update new_items a set otra_sku =
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c+  where exists
     c+ (select b.sku from kataloge b where b.item = a.item
     c+       and KATALOG ='OTRA' group by b.sku)
     c/end-exec


     C*Errors im Katalog
     c/exec sql
     c+ update new_items set ADDIT00002 =
     c+ 'problem in the definition by catalogues ==> ' concat artbezfra
     c+ where
     c+ ( MCOB_SKU <> CORRECTION_SKU and
     c+   MCOB_SKU <> ' ' and CORRECTION_SKU <> ' ') or
     c+ ( MDP_SKU  <> CORRECTION_SKU and
     c+   MDP_SKU  <> ' ' and CORRECTION_SKU <> ' ') or
     c+ ( MF_SKU   <> CORRECTION_SKU and
     c+   MF_SKU   <> ' ' and CORRECTION_SKU <> ' ') or
     c+ ( OTRA_SKU <> CORRECTION_SKU and
     c+   OTRA_SKU <> ' ' and CORRECTION_SKU <> ' ')
     c/end-exec
     C*

     C*Errors im Katalog
     c/exec sql
     c+ update new_items set ADDIT00002 =
     c+ 'problem in the definition by catalogues ==> ' concat sku
     c+ where
     c+ ( MCOB_SKU <>            SKU and
     c+   MCOB_SKU <> ' ' and CORRECTION_SKU =  ' ') or
     c+ ( MDP_SKU  <>            SKU and
     c+   MDP_SKU  <> ' ' and CORRECTION_SKU =  ' ') or
     c+ ( MF_SKU   <>            SKU and
     c+   MF_SKU   <> ' ' and CORRECTION_SKU =  ' ') or
     c+ ( OTRA_SKU <>            SKU and
     c+   OTRA_SKU <> ' ' and CORRECTION_SKU =  ' ')
     c/end-exec
     C*



     C     ##6000        ENDSR

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
