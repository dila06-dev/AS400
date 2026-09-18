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
     fcalender  if a e             disk
     F                                     RENAME(calender:phy01r)
     F*                                    USROPN
     f##CTL     uf a e             disk
      *-------------------------------------------------------------------------
      *                                                                     ----
     DDate             S               D   DATFMT(*EUR)
     Dpjahr            S              4  0
     Dpmonat           S              2  0
     Dptag             S              2  0
     Dvj_jahr          S              4  0
     Dnxt_jahr         S              4  0
     Dkey_jahr         S              4  0
     Dtstampi          S               Z
     Ddatum            S               D
     Dzeit             S               T
     D#WEEKISO         s             10i 0

      *                                                                     ----
     D**************************************************************************
     D/COPY ##E
     D*-------------------------------------------------------------------------
     C*
     c                   eval      x = -331
     C                   DO        *hival
     C                   exsr      sr1000
     c                   if        x > 7000
     c                   leave
     c                   endif
     c                   enddo
     C*
     c                   exsr      return
     C*
     C**************************************************************************
     C*grundsätzlicher Aufbau des Kalenders
     C*-------------------------------------------------------------------------
     C*
     C     sr1000        BEGSR

     c                   eval      x = x + 1
     c                   clear                   phy01r
     c                   exsr      sr1500
     C                   write     phy01r

     C     ##1000        ENDSR
     C*
     C**************************************************************************
     C*Funktion *date
     C*-------------------------------------------------------------------------
     C*
     C     sr1500        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##1500
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1500
     c/end-exec

     c/exec sql
     C+ select char(user, 10)$user,
     C+ current date +:x days $date,
     C+ DAY(current date +:x days)$day,
     C+ month(current date +:x days)$month,
     C+ year(current date +:x days)$year,
     C+ DAYofyear(current date +:x days)$DAYofyear,
     C+ WEEK(current date +:x days)$week,
     C+ int(WEEK_ISO(current date +:x days))$weekiso,
     C+ DAYOFWEEK(current date +:x days)$DOW,
     C+ DAYOFWEEK_ISO(current date +:x days)$DOWiso,
     C+ DAYOFYEAR(date(substr(char(current date +:x days,iso), 1, 4)
     C+           concat'-12-31'))$daysyear,
     C+ DAYOFYEAR(date(substr(char(current date +:x days,iso), 1, 4)
     C+           concat'-12-31')) - DAYOFYEAR(current date +:x days) $rest,
     C+ char(current date +:x days,iso)$cdateiso,
     C+ char(current date +:x days,eur)$cdateeur,
     C+ current timestamp +:x days $timestamp,
     C+ char(current timestamp +:x days) ctimestamp,
     C+ char(decimal(days(current date +:x days), 7, 0)),
     C+ char(zoned(days(current date +:x days ), 7, 0)),
     C+ char(double(days(current date +:x days) ** 12 )),
     C+ char(bigint(days(current date +:x days) ** 3 )),
     C+ char(MONTHNAME(current date +:x days), 15) $NameMonth,
     C+ char(DAYNAME(current date +:x days), 15) $NameDay,
     C+ char(' ', 512)a,
     C+ char(' ', 512)b,
     C+ dec(0, 6 , 0) DE,dec(0, 6 , 0) FR, dec(0, 6 , 0) UK,
     C+ dec(0, 6 , 0) IT,dec(0, 6 , 0) AU, dec(0, 6 , 0) SE,
     C+ dec(0, 6 , 0) CH,dec(0, 6 , 0) DK, dec(0, 6 , 0) SP,
     C+ dec(0, 6 , 0) x1,dec(0, 6 , 0) x2, dec(0, 6 , 0) x3
     C+ into :$USER,
     C+      :$DATE,
     C+      :$DAY,
     C+      :$MONTH,
     C+      :$YEAR,
     C+      :$DAYOFYEAR,
     C+      :$WEEK,
     C+      :#WEEKISO,
     C+      :$DOW,
     C+      :$DOWISO,
     C+      :$DAYSYEAR,
     C+      :$REST,
     C+      :$CDATEISO,
     C+      :$CDATEEUR,
     C+      :$TIMESTAMP,
     C+      :CTIMESTAMP,
     C+      :SEL0017,
     C+      :SEL0018,
     C+      :SEL0019,
     C+      :SEL0020,
     C+      :$NAMEMONTH,
     C+      :$NAMEDAY,
     C+      :A,
     C+      :B,
     C+      :DE,
     C+      :FR,
     C+      :UK,
     C+      :IT,
     C+      :AU,
     C+      :SE,
     C+      :CH,
     C+      :DK,
     C+      :SP,
     C+      :x1,
     C+      :x2,
     C+      :x3
     C+ from qsys2/qsqptabl
     c/end-exec
     C*

     C     ##1500        ENDSR

     C**************************************************************************
     C*Funktion *de  Deutschland
     C*-------------------------------------------------------------------------
     C*
     C     sr1510        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##1510
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1510
     c/end-exec

     c/exec sql
     C+ update gang/calender set DE = 1, a='Neujahrsfest             '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Tag der Arbeit           '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Tag der deutschen Einheit'
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-10-03'
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Allerheiligen            '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-11-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='1. Weihnachtstag         '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='2. Weihnachtstag         '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-26'
     c/end-exec

     c/exec sql
     C+ update gang/calender set DE = 1, a='Ostersonntag             '
     C+ concat substr(a, 26, 486)
     C+ WHERE substr(CTIMESTAMP, 1, 10)='2010-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2011-04-24' or
     C+       substr(CTIMESTAMP, 1, 10)='2012-04-08' or
     C+       substr(CTIMESTAMP, 1, 10)='2013-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2014-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2015-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2016-03-27' or
     C+       substr(CTIMESTAMP, 1, 10)='2017-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2018-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2019-04-21' or
     C+       substr(CTIMESTAMP, 1, 10)='2020-04-12' or
     C+       substr(CTIMESTAMP, 1, 10)='2021-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2022-04-17' or
     C+       substr(CTIMESTAMP, 1, 10)='2023-04-09' or
     C+       substr(CTIMESTAMP, 1, 10)='2024-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2025-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2026-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2027-03-28' or
     C+       substr(CTIMESTAMP, 1, 10)='2028-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2029-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2030-04-21'
     c/end-exec
     C*
     c/exec sql
     C+ update gang/calender set DE = 1, a='Karfreitag               '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date - 2 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Ostermontag              '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date + 1 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Christi Himmelfahrt      '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date + 39 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Pfingsten                '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date + 49 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Pfingstmontag            '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date + 50 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set DE = 1, a='Fronleichnam             '
     C+ concat substr(a, 26, 486)
     C+ where $DAte in (select $date + 60 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec

     C     ##1510        ENDSR

     C**************************************************************************
     C*Funktion *it      s=51   K=461  v=25   italien
     C*-------------------------------------------------------------------------
     C*
     C     sr1520        BEGSR
     C*
     C                   z-add     2             y                 2 0
     C                   clear                   s                 3 0
     C                   clear                   v                 3 0
     C                   clear                   k                 3 0
     C                   eval      v=(y-1)*25
     C                   eval      s=(y*25)+1
     C                   eval      k=(512-s)

     c/exec sql
     c+ whenever not found goto ##1520
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1520
     c/end-exec

     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Capodanno                '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Epifaniao                '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-06'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Anniversario Liberazione '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-04-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Festa del Lavoro         '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Festa della Repubblica   '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-06-02'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat ' Ferragosto              '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-08-15'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Ognissanti Tutti i Santi '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-11-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Immacolata Concezione    '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-08'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Natale                   '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Santo Stefano            '
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-26'
     c/end-exec

     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Lunedì d.Pasqua Pasquetta'
     C+ concat substr(a, 51, 461)
     C+ WHERE substr(CTIMESTAMP, 1, 10)='2010-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2011-04-24' or
     C+       substr(CTIMESTAMP, 1, 10)='2012-04-08' or
     C+       substr(CTIMESTAMP, 1, 10)='2013-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2014-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2015-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2016-03-27' or
     C+       substr(CTIMESTAMP, 1, 10)='2017-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2018-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2019-04-21' or
     C+       substr(CTIMESTAMP, 1, 10)='2020-04-12' or
     C+       substr(CTIMESTAMP, 1, 10)='2021-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2022-04-17' or
     C+       substr(CTIMESTAMP, 1, 10)='2023-04-09' or
     C+       substr(CTIMESTAMP, 1, 10)='2024-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2025-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2026-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2027-03-28' or
     C+       substr(CTIMESTAMP, 1, 10)='2028-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2029-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2030-04-21'
     c/end-exec
     C*
     c/exec sql
     C+ update gang/calender set IT = 1, a= substr(a, 01, 25)
     C+ concat 'Lunedì d.Pasqua Pasquetta'
     C+ concat substr(a, 51, 461)
     C+ where $DAte in (select $date + 1 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec

     C     ##1520        ENDSR

     C**************************************************************************
     C***************************************************
     C*Funktion *se      s=75   K=436  v=50  Schweden
     C*-------------------------------------------------------------------------
     C*
     C     sr1530        BEGSR
     C*
     C                   z-add     3             y                 2 0
     C                   clear                   s                 3 0
     C                   clear                   v                 3 0
     C                   clear                   k                 3 0
     C                   eval      v=(y-1)*25
     C                   eval      s=(y*25)+1
     C                   eval      k=(512-s)

     c/exec sql
     c+ whenever not found goto ##1530
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1530
     c/end-exec

     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Nyårsdagen               '
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Trettondedag jul         '
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-06'
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Valborg                  '
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Schwedischer NationalfTag'
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-06-06'
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Juldagen                 '
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Annandag julo            '
     C+ concat substr(a, 76, 436)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-26'
     c/end-exec

     C*
     c/exec sql
     C+ update gang/calender set se = 1, a= substr(a, 01, 50)
     C+ concat 'Långfredagen             '
     C+ concat substr(a, 76, 436)
     C+ where $DAte in (select $date - 2 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set SE = 1, a= substr(a, 01, 50)
     C+ concat 'Annandag påsk            '
     C+ concat substr(a, 76, 436)
     C+ where $DAte in (select $date + 1 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set se = 1, a= substr(a, 01, 50)
     C+ concat 'Kristi himmelfärds dag   '
     C+ concat substr(a, 76, 436)
     C+ where $DAte in (select $date + 39 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec

     C     ##1530        ENDSR

     C**************************************************************************
     C*Funktion *uk      s=101  K=461  v=25   Great Britain
     C*-------------------------------------------------------------------------
     C*
     C     sr1540        BEGSR
     C*
     C                   z-add     4             y                 2 0
     C                   clear                   s                 3 0
     C                   clear                   v                 3 0
     C                   clear                   k                 3 0
     C                   eval      v=(y-1)*25
     C                   eval      s=(y*25)+1
     C                   eval      k=(512-s)

     c/exec sql
     c+ whenever not found goto ##1540
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1540
     c/end-exec

     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'New Year s Day           '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-01'   or
     C+       substr(CTIMESTAMP, 5, 06)='-01-02'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Saint Patrick s Day      '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-03-17'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Liberation Day           '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-09'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Tynwald Day              '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-07-05'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Battle of the Boyne      '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-07-12'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Homecoming Day           '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-15'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Chrismas Day             '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Boxing Day               '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-26'
     c/end-exec

     c/exec sql
     C+ update gang/calender set UK = 1, a= substr(a, 01, 75)
     C+ concat 'Easter Sunday            '
     C+ concat substr(a, 101, 411)
     C+ WHERE substr(CTIMESTAMP, 1, 10)='2010-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2011-04-24' or
     C+       substr(CTIMESTAMP, 1, 10)='2012-04-08' or
     C+       substr(CTIMESTAMP, 1, 10)='2013-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2014-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2015-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2016-03-27' or
     C+       substr(CTIMESTAMP, 1, 10)='2017-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2018-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2019-04-21' or
     C+       substr(CTIMESTAMP, 1, 10)='2020-04-12' or
     C+       substr(CTIMESTAMP, 1, 10)='2021-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2022-04-17' or
     C+       substr(CTIMESTAMP, 1, 10)='2023-04-09' or
     C+       substr(CTIMESTAMP, 1, 10)='2024-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2025-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2026-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2027-03-28' or
     C+       substr(CTIMESTAMP, 1, 10)='2028-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2029-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2030-04-21'
     c/end-exec
     C*
     c/exec sql
     C+ update gang/calender set uk = 1, a= substr(a, 01, 75)
     C+ concat 'Easter Monday            '
     C+ concat substr(a, 101, 411)
     C+ where $DAte in (select $date + 1 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set uk = 1, a= substr(a, 01, 75)
     C+ concat 'Good Friday              '
     C+ concat substr(a, 101, 411)
     C+ where $DAte in (select $date - 2 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec

     C     ##1540        ENDSR

     C**************************************************************************
     C*Funktion *FR      s=101  K=461  v=25   Frankreich
     C*-------------------------------------------------------------------------
     C*
     C     sr1550        BEGSR
     C*
     C                   z-add     5             y                 2 0
     C                   clear                   s                 3 0
     C                   clear                   v                 3 0
     C                   clear                   k                 3 0
     C                   eval      v=(y-1)*25
     C                   eval      s=(y*25)+1
     C                   eval      k=(512-s)

     c/exec sql
     c+ whenever not found goto ##1550
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##1550
     c/end-exec

     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Jour de l An             '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-01-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Fête du travail          '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Fête de la Victoire      '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-05-08'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Fête Nation. de la France'
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-07-14'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Assomption               '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-08-15'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Toussaint                '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-11-01'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Armistice 1918           '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-11-11'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Armistice 1918           '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-11-11'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Noël                     '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-25'
     c/end-exec
     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Lendemain de Noël        '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 5, 06)='-12-26'
     c/end-exec


     c/exec sql
     C+ update gang/calender set FR = 1, a= substr(a, 01, 100)
     C+ concat 'Pâques                   '
     C+ concat substr(a, 126, 386)
     C+ WHERE substr(CTIMESTAMP, 1, 10)='2010-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2011-04-24' or
     C+       substr(CTIMESTAMP, 1, 10)='2012-04-08' or
     C+       substr(CTIMESTAMP, 1, 10)='2013-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2014-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2015-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2016-03-27' or
     C+       substr(CTIMESTAMP, 1, 10)='2017-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2018-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2019-04-21' or
     C+       substr(CTIMESTAMP, 1, 10)='2020-04-12' or
     C+       substr(CTIMESTAMP, 1, 10)='2021-04-04' or
     C+       substr(CTIMESTAMP, 1, 10)='2022-04-17' or
     C+       substr(CTIMESTAMP, 1, 10)='2023-04-09' or
     C+       substr(CTIMESTAMP, 1, 10)='2024-03-31' or
     C+       substr(CTIMESTAMP, 1, 10)='2025-04-20' or
     C+       substr(CTIMESTAMP, 1, 10)='2026-04-05' or
     C+       substr(CTIMESTAMP, 1, 10)='2027-03-28' or
     C+       substr(CTIMESTAMP, 1, 10)='2028-04-16' or
     C+       substr(CTIMESTAMP, 1, 10)='2029-04-01' or
     C+       substr(CTIMESTAMP, 1, 10)='2030-04-21'
     c/end-exec
     C*
     c/exec sql
     C+ update gang/calender set fr = 1, a= substr(a, 01, 100)
     C+ concat 'Lundi de Pâques          '
     C+ concat substr(a, 126, 386)
     C+ where $DAte in (select $date + 1 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set fr = 1, a= substr(a, 01, 100)
     C+ concat 'Vendredi Saint           '
     C+ concat substr(a, 126, 386)
     C+ where $DAte in (select $date - 2 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set fr = 1, a= substr(a, 01, 100)
     C+ concat 'Ascension                '
     C+ concat substr(a, 126, 386)
     C+ where $DAte in (select $date + 39 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set fr = 1, a= substr(a, 01, 100)
     C+ concat 'Pentecôte                '
     C+ concat substr(a, 126, 386)
     C+ where $DAte in (select $date + 49 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec
     c/exec sql
     C+ update gang/calender set fr = 1, a= substr(a, 01, 100)
     C+ concat 'Lundi de Pentecôte       '
     C+ concat substr(a, 126, 386)
     C+ where $DAte in (select $date + 50 days from
     C+       gang/calender where substr(a, 1, 26) =
     C+       'Ostersonntag             ')
     c/end-exec

     C     ##1550        ENDSR

     C**************************************************************************
     C*...
     C*-------------------------------------------------------------------------
     C*
     C     sr2500        BEGSR
     C*
     C                   clear                   md
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1005'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*REPLACE'    REPADD           10
     C                   clear                   md
     C*
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1006'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C*
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1007'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C*
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1008'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C*
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1009'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C*
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#CA1010'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'BANKHOLDAY'  OUTFIL           10
     C                   PARM      'QTEMP'       LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md

     C     ##2500        ENDSR
     C*
     C**************************************************************************
     C*time stamp
     C*-------------------------------------------------------------------------
     C*
     C     sr9999        BEGSR
     C*

     c/exec sql
     c+ whenever not found goto ##9999
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLWARNING CONTINUE
     c/end-exec
     c/exec sql
     c+ WHENEVER SQLERROR   goto ##9999
     c/end-exec


     c/exec sql
     c+ select current timestamp, current date, current time
     c+ into   :tstampi, :datum, :zeit
     c+ from   qsys2/qsqptabl
     c/end-exec

     C     ##9999        ENDSR

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
     C                   clear                   x                 6 0
     C
     C                   ENDSR
     C**************************************************************************
     C* PROGRAMM VERLASSEN
     C*-------------------------------------------------------------------------
     C*
     C     RETURN        BEGSR
     C                   MOVE      '1'           *INLR
     C                   exsr      sr2500
     C                   exsr      sr1510
     C                   exsr      sr1520
     C                   exsr      sr1530
     C                   exsr      sr1540
     C                   exsr      sr1550
     C                   RETURN
     C                   ENDSR
     C*
     C**************************************************************************
