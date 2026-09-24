      * PROGRAMMNAME.:.....                                                   
      * FUNKTION.....:...
      *               
      * November 2009   GANG, MANFRED
      * SELECT * FROM bar_kalk/kalk_file WHERE "VERSION" = '$$EL_PS_DB' and
      * substr(statnr, 1, 1) <>'1' and substr(ARTGRP, 1, 1) > 'Z' and ABC
      * in ('A', 'B', 'C') and STATNR not in ('290', '299', '409', '413',
      * '414', '490', '499', '399', '417', '418', '419', '420', '422',
      * '423', '426', '327')
      *
      * SELECT * FROM gang/help__01 right exception join bar_kalk/kalk_file
      * on char(prs040)= artnr
      * WHERE "VERSION" = '$$EL_PS_DB' and
      * substr(statnr, 1, 1) <>'1' and substr(ARTGRP, 1, 1) > 'Z' and ABC
      * in ('A', 'B', 'C') and STATNR not in ('290', '299', '409', '413',
      * '414', '490', '499', '399', '417', '418', '419', '420', '422',
      * '423', '426', '327')
      *
      *-ÄNDERUNGSDIENST---------------------------------------------------------
      * XX.XX.XX                                              PGMR.....
      *-------------------------------------------------------------------------
     Hdatfmt(*eur) timfmt(*eur)
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
     D*                                                                     ----
     D*-------------------------------------------------------------------------
     C     *ENTRY        PLIST
     c                   PARM                    k                 5
     c                   PARM                    #                 1
     C*
     D*-------------------------------------------------------------------------
     C                   setoff                                       10
     C                   movel     k             #k                5 010
     C                   setoff                                       30
     C                   setoff                                       31
     C                   setoff                                       32
     C                   if        # = 'A'
     C                   seton                                        30
     C                   endif
     C                   if        # = 'B'
     C                   seton                                        31
     C                   endif
     C*
     C                   if        k = '00000'
     C                   exsr      sr3500
     C                   endif
     C*
     C                   if        k <> '00000' and k <> '99999'
     C                   exsr      sr4000
     C   30              exsr      sr4006a
     C   31              exsr      sr4006b
     C                   exsr      sr4040
     C                   exsr      sr4050
     C                   exsr      sr4060
     C                   endif
     C*
     C                   if        k = '99999'
     C                   exsr      sr4070
     C                   exsr      sr4080
     C                   exsr      sr4091
     C                   exsr      sr4092
     C                   exsr      sr5010
     C                   exsr      sr5011
     C                   exsr      sr5015
     C                   endif
     C*
     C                   exsr      return
     C*
     C**************************************************************************
     C*Rabatte eindeutig holen einmalig Initialisierung
     C*-------------------------------------------------------------------------
     C*
     C     sr3500        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##3500
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##3500
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into gang/rabatt
     C+ SELECT RAB010, RAB020, RAB030, RAB040, RAB050, dec(max(RAB070), 5,
     C+ 2) maxrab1, dec(min(RAB070), 5, 2) minrab1, dec(max(RAB140), 5, 2)
     C+ maxrab2, dec(min(RAB140), 5, 2) minrab2, dec(min(RAB060), 5, 2)
     C+ minmenge, dec(max(RAB060), 5, 2) maxmenge, dec(count(*), 5, 2)
     C+ count FROM sbgrab00 GROUP BY RAB010, RAB020, RAB030, RAB040,
     C+ RAB050, RAB140 ORDER BY RAB050
     c/end-exec
     C*
     C     ##3500        ENDSR
     C*
     C**************************************************************************
     C*Datenbasis und Struktur
     C*Zuordnung artikel/Kunde direkt                         gang/HELP_01
     C*-------------------------------------------------------------------------
     C*
     C     sr4000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4000
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##4000
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     c+ insert into gang/help__01
     C+ SELECT A.PRS010, A.PRS020, A.PRS030, A.PRS040, A.PRS050, A.PRS060,
     C+ A.PRS070, A.PRS080, A.PRS090, A.PRS100, A.PRS110, A.PRS120,
     C+ A.PRS130, A.PRS999, B.ART010, B.ART020, B.ART030, B.ART040,
     C+ B.ART050, B.ART060, B.ART070, B.ART080, B.ART090, B.ART100,
     C+ B.ART110, B.ART120, B.ART130, B.ART140, B.ART150, B.ART160,
     C+ B.ART170, B.ART180, B.ART190, B.ART200, B.ART210, B.ART220,
     C+ B.ART230, B.ART240, B.ART250, B.ART260, B.ART270, B.ART280,
     C+ B.ART290, B.ART300, B.ART310, B.ART320, B.ART330, B.ART340,
     C+ B.ART350, B.ART360, B.ART370, B.ART375, B.ART380, B.ART390,
     C+ B.ART400, B.ART410, B.ART420, B.ART430, B.ART440, B.ART450,
     C+ B.ART460, B.ART470, B.ART480, B.ART490, B.ART500, B.ART510,
     C+ B.ART520, B.ART530, B.ART540, B.ART550, B.ART940, B.ART950,
     C+ B.ART960, B.ART970, B.ART980, B.ART999, B.ART610, B.ART620,
     C+ B.ART630, B.ART640, B.ART650, B.ART655, B.ART660, B.ART665,
     C+ B.ART670, B.ART680, B.ART690, B.ART700, B.ART710, B.ART985,
     C+ B.ART720, B.ARTBED, dec(00, 5, 2)Rab1, dec(00, 5, 2)Rab2,
     C+ dec(00, 5, 2)maxrab1, dec(00, 5, 2)minrab1,
     C+ dec(00, 5, 2)maxrab2, dec(00, 5, 2)minrab2,
     C+ dec(00, 5, 2)minmenge, dec(00, 5, 2)maxmenge, char('0') Neu,
     C+ dec(00, 2, 0)KDS200,dec(00, 2, 0)count
     C+ FROM sbgprs00 a, sbgart00 b WHERE char(prs020)
     C+ in (select digits(kds020) from sbgkds00 where (kds210= 00 or
     C+ kds210=00 or kds020=:k)) and prs040 = ART030
     C*
     c/end-exec
     C*
     C     ##4000        ENDSR
     C*
     C**************************************************************************
     C*Datenbasis und Struktur fehlender Sätze
     C*Zuordnung artikel/Kunde fehlt und wird hier erzeugt    gang/HELP_01
     C*-------------------------------------------------------------------------
     C*
     C     sr4006a       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4006a
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##4006a
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     C*
     C+ insert into gang/help__02
     C+
     C+ SELECT b.art010, :k, b.art020, b.art030, 0,00    , 99     ,
     C+  0      , ' '     , ' '     , ' '     , 0,00    , 0       ,
     C+ 'N'     , '1'     , B.ART010, B.ART020, B.ART030, B.ART040,
     C+ B.ART050, B.ART060, B.ART070, B.ART080, B.ART090, B.ART100,
     C+ B.ART110, B.ART120, B.ART130, B.ART140, B.ART150, B.ART160,
     C+ B.ART170, B.ART180, B.ART190, B.ART200, B.ART210, B.ART220,
     C+ B.ART230, B.ART240, B.ART250, B.ART260, B.ART270, B.ART280,
     C+ B.ART290, B.ART300, B.ART310, B.ART320, B.ART330, B.ART340,
     C+ B.ART350, B.ART360, B.ART370, B.ART375, B.ART380, B.ART390,
     C+ B.ART400, B.ART410, B.ART420, B.ART430, B.ART440, B.ART450,
     C+ B.ART460, B.ART470, B.ART480, B.ART490, B.ART500, B.ART510,
     C+ B.ART520, B.ART530, B.ART540, B.ART550, B.ART940, B.ART950,
     C+ B.ART960, B.ART970, B.ART980, B.ART999, B.ART610, B.ART620,
     C+ B.ART630, B.ART640, B.ART650, B.ART655, B.ART660, B.ART665,
     C+ B.ART670, B.ART680, B.ART690, B.ART700, B.ART710, B.ART985,
     C+ B.ART720, B.ARTBED, 0,00  , 0,00  , 0,00     , 0,00     ,
     C+ 0,00     , 0,00     , 0,00      , 0,00      , 'N'  , 0       ,
     C+ 0         FROM gang/help__01 a right exception join sbgart00 b on
     C+ char(prs040)= b.aRT030 WHERE b.art030 in (select artnr from
     C+ bar_kalk/kalk_file where "VERSION" = '$$EL_PS_DB' and
     C+ substr(statnr, 1, 1) <>'1' and substr(ARTGRP, 1, 1) > 'Z' and ABC
     C+ in ('A', 'B', 'C') and STATNR     in ('208', '210', '306', '307',
     C+ '308', '313', '314', '316', '317', '318', '319', '320', '328',
     C+ '329', '330', '331', '332', '333', '334', '335', '336', '337',
     C+ '338', '339', '340', '341', '342', '401', '402', '404', '405',
     C+ '406', '407', '408', '410', '000', '000', '000', '000', '000'))
     C*
     c/end-exec
     C*
     C     ##4006a       ENDSR
     C*
     C**************************************************************************
     C*Datenbasis und Struktur fehlender Sätze
     C*Zuordnung artikel/Kunde fehlt und wird hier erzeugt    gang/HELP_01
     C*-------------------------------------------------------------------------
     C*
     C     sr4006b       BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4006b
     c/end-exec
     c**/exec sql
     c**+ whenever sqlerror  goto ##4006b
     c**/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     C*
     c/exec sql
     C*
     C+ insert into gang/help__02
     C+
     C+ SELECT b.art010, :k, b.art020, b.art030, 0,00    , 99     ,
     C+  0      , ' '     , ' '     , ' '     , 0,00    , 0       ,
     C+ 'N'     , '1'     , B.ART010, B.ART020, B.ART030, B.ART040,
     C+ B.ART050, B.ART060, B.ART070, B.ART080, B.ART090, B.ART100,
     C+ B.ART110, B.ART120, B.ART130, B.ART140, B.ART150, B.ART160,
     C+ B.ART170, B.ART180, B.ART190, B.ART200, B.ART210, B.ART220,
     C+ B.ART230, B.ART240, B.ART250, B.ART260, B.ART270, B.ART280,
     C+ B.ART290, B.ART300, B.ART310, B.ART320, B.ART330, B.ART340,
     C+ B.ART350, B.ART360, B.ART370, B.ART375, B.ART380, B.ART390,
     C+ B.ART400, B.ART410, B.ART420, B.ART430, B.ART440, B.ART450,
     C+ B.ART460, B.ART470, B.ART480, B.ART490, B.ART500, B.ART510,
     C+ B.ART520, B.ART530, B.ART540, B.ART550, B.ART940, B.ART950,
     C+ B.ART960, B.ART970, B.ART980, B.ART999, B.ART610, B.ART620,
     C+ B.ART630, B.ART640, B.ART650, B.ART655, B.ART660, B.ART665,
     C+ B.ART670, B.ART680, B.ART690, B.ART700, B.ART710, B.ART985,
     C+ B.ART720, B.ARTBED, 0,00  , 0,00  , 0,00     , 0,00     ,
     C+ 0,00     , 0,00     , 0,00      , 0,00      , 'N'  , 0       ,
     C+ 0         FROM gang/help__01 a right exception join sbgart00 b on
     C+ char(prs040)= b.aRT030 WHERE b.art030 in (select artnr from
     C+ bar_kalk/kalk_file where "VERSION" = '$$EL_PS_DB' and
     C+ substr(statnr, 1, 1) <>'1' and substr(ARTGRP, 1, 1) > 'Z' and ABC
     C+ in ('A', 'B', 'C') and STATNR     in ('212', '313', '314', '316',
     C+ '317', '318', '320', '328', '329', '330', '331', '332', '333',
     C+ '334', '335', '336', '337', '338', '339', '340', '399', '401',
     C+ '402', '404', '405', '406', '407', '408', '409', '410', '411',
     C+ '412', '413', '414', '415', '420', '421', '422', '424', '427',
     C+ '428', '429', '701', '702', '703', '704', '202', '207', '000'))
     C*
     c/end-exec
     C*
     C     ##4006b       ENDSR
     C*
     C**************************************************************************
     C*Grundrabattgruppe holen aus Kundenstamm
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4040        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4040
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set  KDS200= (select KDS200 from sbgkds00
     C+          where PRS020  = digits(KDS020)  and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select KDS200 from sbgkds00
     C+          where PRS020  = digits(KDS020)  and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set  KDS200= (select KDS200 from sbgkds00
     C+          where PRS020  = digits(KDS020)  and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select KDS200 from sbgkds00
     C+          where PRS020  = digits(KDS020)  and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     C     ##4040        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf Kunde /Gruppe Rabatt 1
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4050        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4050
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set rab1 = (select RAB070 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select RAB070 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set rab1 = (select RAB070 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select RAB070 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     C     ##4050        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf Kunde /Gruppe Rabatt 2
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4060        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4060
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set rab2 = (select RAB140 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select RAB140 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set rab2 = (select RAB140 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C+ where exists
     C+       (select RAB140 from sbgrab00
     C+          where ART050 = RAB050 and RAB020= PRS020 and
     C+                PRS020  = :k )
     C*
     c/end-exec
     C*
     C     ##4060        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe MAXRAB1
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4070        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4070
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set MAXRAB1 =(select  MAXRAB1    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      MAXRAB1     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set MAXRAB1 =(select  MAXRAB1    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      MAXRAB1     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C*
     c/end-exec
     C*
     C     ##4070        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe MINRAB1
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4080        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4080
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set MINRAB1 =(select  MINRAB1    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      MINRAB1     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set MINRAB1 =(select  MINRAB1    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      MINRAB1     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##4080        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe MaxRAB2
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4091        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4091
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set Maxrab2 =(select  Maxrab2    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Maxrab2     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set Maxrab2 =(select  Maxrab2    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Maxrab2     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##4091        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe MinRAB2
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr4092        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##4092
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set Minrab2 =(select  Minrab2    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Minrab2     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set Minrab2 =(select  Minrab2    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Minrab2     from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##4092        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe Maxmenge
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr5010        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##5010
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set Maxmenge=(select  Maxmenge   from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Maxmenge    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set Maxmenge=(select  Maxmenge   from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Maxmenge    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##5010        ENDSR
     C*
     C**************************************************************************
     C*Grundrabatt bezogen auf XXX Gruppe /Gruppe Minmenge
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr5011        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##5011
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set Minmenge=(select  Minmenge   from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Minmenge    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C+ update gang/HELP__02 set Minmenge=(select  Minmenge   from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      Minmenge    from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##5011        ENDSR
     C*
     C**************************************************************************
     C*anzahl verschiedener Rabatte bezogen auf XXX Gruppe /Gruppe Count
     C*update auf                                          gang/help__01
     C*update auf                                          gang/help__02
     C*-------------------------------------------------------------------------
     C*
     C     sr5015        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##5015
     c/end-exec
     c*/exec sql
     c*+ WHENEVER SQLWARNING CONTINUE
     c*/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__01 set count   =(select  count      from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      count       from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     c/exec sql
     C*
     C+ update gang/HELP__02 set count   =(select  count      from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     C+  where exists
     C+        (select      count       from rabatt
     C+     where ART050 = RAB050 and
     C+           RAB020= (substr(char(digits(KDS200)), 1, 2) concat 'XXX'))
     c/end-exec
     C*
     C     ##5015        ENDSR
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
     C                   z-add     1             p01               1 0
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
