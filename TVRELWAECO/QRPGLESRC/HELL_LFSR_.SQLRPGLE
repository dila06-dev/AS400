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
      * SELECT DISTINCT week(#date) weekinput,
      *                 #DATE input,H050 order,apkDNR customer,KDNAM1
      * customName ,H100 delivyadress,H110,H130, H140,substr(H310, 500, 12)
      * ZIPcode,H160 town,L080 item, L090 description, L100 quantity, L060
      * date_deliv , ZUSATZ Status_in_Geluwe FROM ordersun, orderh, kund01,
      * orderl WHERE week(#DATE)>(week(current date) - 50) and (APAFJJ
      * concat APAFNR)= ORDERH.H050 and ORDERSUN.APTENR=l080 and
      * ORDERSUN.#DATE = ORDERL.L200 and APKDNR=kdkdnr and KDFIRM = 01 and
      * h370= L190 and l050= ORDERSUN.APAFPO order by  week(#date)
      * Datei HENKRR in TVRELWAECO wurde erstellt.
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


     C**************************************************************************
     C*über preselect lesen der Interface_daten
     C*-------------------------------------------------------------------------

     C*Absatz/Umsatzdaten
     c                   exsr      sr2000
     c                   exsr      sr1000
     c                   exsr      sr3000

     C                   EXSR      RETURN

     C**************************************************************************
     C*Absatzzahlen
     C*SQL_0001 - Albers
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
     c+ insert into TVRELWAECO/HELL_LFSP
     c+ SELECT apkonz apkonz, apfirm apfirm, aptour aptour, apanr1 apanr1,
     c+ apiden apiden, apalkz apalkz , akan1 akan1, akan2 akan2, akstr
     c+ akstr,aklakz aklakz,akplz,aklort,apresm apresm,apvart apvart,
     c+ substr(AKRFNR, 12, 12) Auftrag, current timestamp tstamp, APDUUSR,
     c+ APDUUSRB,APAPPO,AKpsts ,apalm , char('0', 1) status,
     c+ current timestamp updated
     c+ FROM DOMDATV7/PANFKOP, DOMDATV7/PANFpos
     c+ WHERE AKFIRM ='DWI' and AKTOUR ='HELL' and akfa1 ='H' and
     c+       AKAPN  = APAPN and APRESM <> 0  and AKpsts = 20 and
     c+       APAPN  not in (select APAPN from HELL_LFSP where
     c+                           APAPPO = HELL_LFSP.APAPPO )
     c/end-exec

     C     ##1000        ENDSR

     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr2000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CLRPFM' + ' ' +
           'tvrelwaeco/HELL_LFS';
         cmd = %TrimR(Wrk.Var1);

         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='error in command appeared file not existing       ';
          exsr      SR_log;
       endmon;
      /End-Free

     C     ##2000        ENDSR

     c*
     C**************************************************************************
     C*time stamp COMWEBBRO
     C*-------------------------------------------------------------------------

     C     sr3000        BEGSR
     C*
      /free
       MONITOR;
       Wrk.var1 =
           'CVTDBF OBJ(''/Lager/HENKR.CSV'') '  +
           'DBFILE(TVRELWAECO/HENKR) DBOUTFMT(*CSV) '  +
           'DBFLDDSC(*YES)';
         cmd = %TrimR(Wrk.Var1);
         Laenge = %Len(Cmd);
         QCMDEXC(cmd: %len(cmd));
       on-error;
          status='Error by copy in directory                        ';
          exsr      SR_log;
       endmon;
      /End-Free


     C     ##3000        ENDSR

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
     C**********************************************************************
     C*Sicherung in das Protokoll
     C*-------------------------------------------------------------------------
     C
     C     sr_log        BEGSR
      *
      *
     C                   clear                   md
     C                   movel     §§§JNO        §§§JNO#          06
     C                   movea(p)  'HENKR     '  md(001)
     C                   movea(p)  §§§JOB        md(011)
     C                   movea(p)  §§§USR        md(022)
     C                   movea(p)  §§§JNO#       md(033)
     C                   movea(p)  'LOOP  '      md(040)
     C*                  MOVEA     ATR(14)       md(050)
     C                   movea(p)  status        md(051)
     C                   CALL      'DUMMY512'
     C                   PARM                    MD
     C                   PARM      '#DC0002'     MSG               7
     C                   PARM      *blank        MSGF             10
     C                   PARM      *BLANK        PRINT            10
     C                   PARM      'JOB_RUN   '  OUTFIL           10
     C                   PARM      'TVRELWAECO'  LIB              10
     C                   PARM      '*ADD    '    REPADD           10
     C                   clear                   md
     C                   clear                   status           70
      *
     C     ##_log        ENDSR
     C
     C**************************************************************************
