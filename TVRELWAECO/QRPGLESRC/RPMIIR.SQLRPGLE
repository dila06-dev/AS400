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
      * WHERE date(substr(char(anldat), 1, 4) concat '-'
      * concat substr(char(anldat), 5, 2) concat '-' concat
      * substr(char(anldat), 7, 2) ) > current date -5 month and
      * date(substr(char(anldat), 1, 4) concat '-' concat
      * substr(char(anldat), 5, 2) concat '-' concat substr(char(anldat),
      * 7, 2) ) < current date -0 month and version = '$$EL_PS_DB' and
      * anldat <> 0 and COSTPRS_AR > 0 and artz1 in ('EIPROD', 'KON   ')
      * and KCJMNG_AJ <> 0
      * and artsku not in (select RPMSKU from tvrelwaeco/RPMII)
      *
      *
      * ***************************************************************        
      * Änderungsprotokoll:...                                                
      *
      *****************************************************************
     hALWNULL(*USRCTL)

     fCODEKUNDE ip   e             disk    RENAME(CODEKUNDE:phy01r)
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
b
     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------
      /Free
         MONITOR;
         if %Nullind(code);
            %Nullind(code) = *off;
            code = *Blanks;
         endif;
         if %Nullind(KUNDEN#1);
            %Nullind(KUNDEN#1) = *off;
            KUNDEN#1 = *Blanks;
         endif;
         if %Nullind(KUNDEN#2);
            %Nullind(KUNDEN#2) = *off;
            KUNDEN#2 = *Blanks;
         endif;
         if %Nullind(KUNDEN#3);
            %Nullind(KUNDEN#3) = *off;
            KUNDEN#2 = *Blanks;
         endif;
         if %Nullind(KUNDEN#4);
            %Nullind(KUNDEN#4) = *off;
            KUNDEN#2 = *Blanks;
         endif;
            ON-ERROR;
                *in20 = '1';
         ENDMON;
      /End-Free

     c                   if        code = '0     ' or code = '      '
     c                   else
     c                   clear                   Distribut        10
     c                   movel     code          Distribut        10
     c                   if        kunden#1 <> '0     '  and
     c                             kunden#1 <> '      '
     c                   movel     kunden#1      kunde             6
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   endif
     c                   if        kunden#2 <> '0     '  and
     c                             kunden#2 <> '      '
     c                   movel     kunden#2      kunde             6
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   endif
     c                   if        kunden#3 <> '0     '  and
     c                             kunden#3 <> '      '
     c                   movel     kunden#3      kunde             6
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   endif
     c                   if        kunden#4 <> '0     '  and
     c                             kunden#4 <> '      '
     c                   movel     kunden#4      kunde             6
     c                   exsr      sr1000
     c                   exsr      sr2000
     c                   endif
     c                   endif

     C**************************************************************************
     C*Definition: Filterung aller Eigenproduktionsartikel mit Absatz
     C*            und einem STK3 Wert > 0,
     C*            die in dieser Datei zum ersten mal auflaufen und
     C*            Kunden der Group sind (Verzeichnis)
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR
     C*
     C**************     goto      ##1000
     c/exec sql
     c+ whenever not found goto ##1000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMII
     c+ SELECT char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c+ :Distribut,      dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2013'                             concat '0101', 8) ab,
     c+ char(   '2013'                             concat '1231', 8) bis,
     c+ char('          ', 10), current timestamp
     c+ from bar_kalk/kalk_file
     c+ WHERE
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0 and
     c+ COSTPRS_AR > 0 and artz1 in ('EIPROD', 'KON   ') and
     c+ artsku not in (select RPMSKU from tvrelwaeco/RPMII where
     c+                rpmsc = :Distribut)
     c+       and :kunde  in  (select APKDNR from absatzb2  where
     c+           apkdnr= :kunde  and   aptenr= artnr)
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*Definition: Filterung aller "nicht" Eigenproduktionsartikel
     C*            mit Absatz und einem STK3 Wert > 0,
     C*            die in dieser Datei zum ersten mal auflaufen und
     C*            Kunden der Group sind (Verzeichnis)
     C*            wichtig!: hier laufen alle Sätze ein, die mit der
     C*                      Group Absatz hatten
     C*            davon     Unterscheidung 1: Artikel produziert in der
     C*                      Group
     C*            ==>       Protokoll alle mit Verknüpfung auf 1
     C*                      ( Treffer gemäss Phase2 )
     C*                      nach Übernahme werden diese auf 2 gesetzt
     C*            davon     Unterscheidung 0: Artikel
     C*                      ausserhalb der Group,
     C*                      ( Treffer gemäss Phase3 )
     C*                      sie erhalten die Kennung 0 und werden
     C*                      nach Übernahme auf 3 gesetzt
     C*-------------------------------------------------------------------------
     C*
     C     sr2000        BEGSR
     C*
     c/exec sql
     c+ whenever not found goto ##2000
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR  CONTINUE
     c/end-exec

     c/exec sql
     c+ insert into tvrelwaeco/RPMII2
     c+ SELECT char( substr(char(current date, eur), 7, 4) concat
     c+ substr(char(current date, eur), 4, 2) concat substr(char(current
     c+ date, eur), 1, 2), 8) upload, char('DE411', 10) factory,
     c+ char('DE411', 10) UploadUT, char('DE', 10) Country , artsku,
     c+ :Distribut,      dec( 1, 8, 0) PUnit, char('PCS', 10)
     c+ punit, char(' ', 20) comment, dec(COSTPRS_AR*100, 11, 0)
     c+ STK3, char('EUR', 3) currency,
     c*+ char(substr(char(current date, eur), 7, 4) concat '0101', 8) ab,
     c*+ char(substr(char(current date, eur), 7, 4) concat '1231', 8) bis,
     c+ char(   '2013'                             concat '0101', 8) ab,
     c+ char(   '2013'                             concat '1231', 8) bis,
     c+ char('          ', 10), current timestamp
     c+ from bar_kalk/kalk_file
     c+ WHERE
     c+ version = '$$EL_PS_DB' and KCJMNG_AJ <> 0 and anldat <> 0 and
     c+ COSTPRS_AR > 0 and artz1 not in ('EIPROD', 'KON   ') and
     c+ artsku not in (select RPMSKU from tvrelwaeco/RPMII2 where
     c+                rpmsc = :Distribut)
     c+       and :kunde  in  (select APKDNR from absatzb2  where
     c+           apkdnr= :kunde  and   aptenr= artnr)
     c/end-exec

     C*FACTORY OF ORIGIN aus original holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMFOO =
     c+ (sELECT RPMII_f.RPMFOO from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMFOO from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*COUNTRY OF ORIGIN aus original holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMCOO =
     c+ (sELECT RPMII_f.RPMCOO from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMCOO from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*PRICE QUANTITY aus original holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMPRCQTY =
     c+ (sELECT RPMII_f.RPMPRCQTY from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMPRCQTY from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*PRICE UNIT aus original holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMPRCUNT =
     c+ (sELECT RPMII_f.RPMPRCUNT from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMPRCUNT from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*PRICE UNITCOMMENT aus original aus holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMCOM    =
     c+ (sELECT RPMII_f.RPMCOM    from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMCOM    from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*PRICE UNITCOMMENT aus original aus holen
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMCOM    =
     c+ (sELECT RPMII_f.RPMCOM    from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c+ where exists
     c+ (sELECT RPMII_f.RPMCOM    from RPMII_f  where
     c+         RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*Protokoll alle mit Verknüpfung auf 1
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMREPORT = '1         '
     c+ where   RPMII2.RPMSKU in
     c+ (select RPMII_F.RPMSKU from tvrelwaeco/rpmII_F where
     c+         rpmII2.RPMREPORT = ' ')
     c/end-exec

     C*PRICE STK3 OHNE KOMMA original aus holen + 4,5% Aufschlag
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMSTK3=
     c+ (sELECT ((RPMII_f.RPMSTK32*100)*1,045)/100 +0,5 from RPMII_f
     c+ where   RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = '1')
     c+ where exists
     c+ (sELECT ((RPMII_f.RPMSTK32*100)*1,045)/100 +0,5 from RPMII_f
     c+ where   RPMII2.RPMSKU = RPMII_F.RPMSKU and rpmII2.RPMREPORT = '1')
     c/end-exec

     C*Protokoll alle ohne Verknüpfung auf 0
     c/exec sql
     c+ update  tvrelwaeco/rpmII2  set  RPMII2.RPMREPORT = '0         '
     c+ where  RPMII2.RPMREPORT = ' '
     c/end-exec

     C     ##2000        ENDSR

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
